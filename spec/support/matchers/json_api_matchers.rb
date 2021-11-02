module JsonApiMatchers
  def expect_attributes(attrs)
    expect_json 'data.attributes', attrs
  end

  def expect_id(id)
    expect_json 'data', id: id
  end

  def expect_type(type)
    expect_json 'data', type: type
  end

  def expect_attributes_in_list(attrs)
    expect(json_body[:data]).to_not be_empty
    expect_json 'data.?.attributes', attrs
  end

  # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity, Style/GuardClause, Metrics/LineLength
  def expect_relationship(attrs, in_list = false)
    # If looking for item in a list, need to change location string
    location = if in_list
                 "data.?.relationships.#{attrs[:key]}"
               else
                 "data.relationships.#{attrs[:key]}"
               end

    expect_json "#{location}.links.related", attrs[:link] if attrs[:link]

    if attrs[:id]
      location = "#{location}.data"
      type = attrs[:type] || attrs[:key].pluralize
      id_value = attrs[:id]
      if id_value.respond_to? :each
        # if an array if ids were passed in, look for each of them in the list
        location = "#{location}.?"
        id_value.each do |id|
          # TODO: also look for included thing?
          expect_json location, type: type, id: id
        end
      else
        # otherwise just look for it
        # TODO: also look for included thing?
        expect_json location, type: type, id: id_value
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity, Style/GuardClause, Metrics/LineLength

  def expect_relationship_in_list(attrs)
    expect(json_body[:data]).to_not be_empty
    expect_relationship attrs, in_list: true
  end

  def expect_item_to_not_be_in_list(dont_find_me)
    expect(json_body[:data]).to_not be_empty
    json_body[:data].each do |item|
      expect(item[:id]).to_not eq(dont_find_me.id)
    end
  end

  def expect_item_count(number)
    expect_json_sizes data: number
  end

  def expect_error_text(text)
    expect_json('errors.?.title', text)
  end
end

RSpec.configure do |config|
  config.include JsonApiMatchers
end
