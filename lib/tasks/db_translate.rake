# rubocop:disable Metrics/LineLength
require 'fileutils'
require 'active_record' unless Rails::VERSION::STRING.to_f < 2.3
module ActiveRecord
  class Base
    def self.to_yaml(path)
      yml_export_file = "#{path}/#{table_name}.yml"
      delete_existing_file(yml_export_file)

      result        = {}
      first_time    = true
      total_records = count
      chunk_size    = ENV['CHUNK'].try(:to_i) || 1000
      minimum_id    = 0
      chunk_num     = 0

      puts "WARN >>>>>> #{name}: has #{total_records} records" and return if total_records <= 0

      chunk_message = "in chunks of #{chunk_size}" if total_records > chunk_size

      puts "INFO >>>>>> #{name}: exporting #{total_records} records #{chunk_message}"

      if ENV['NO_ID'] == 'true' # no integer based primary key (hopefully this doesn't happen very often)
        all.each do |o|
          attributes = o.attributes
          result["#{name.to_s.downcase}_#{attributes[primary_key]}"] = o.attributes
        end

        write_file(yml_export_file, result.to_yaml)
      else
        # yes primary key
        while minimum_id
          object_collection =
            where(primary_key + ' > ?', minimum_id)
            .limit(chunk_size)
            .order(primary_key + ' asc')

          object_collection.each do |o|
            attributes = o.attributes
            result["#{name.to_s.downcase}_#{attributes[primary_key]}"] = o.attributes
          end

          if object_collection.empty? || total_records < chunk_size
            minimum_id = nil # terminate the while
          else
            minimum_id = object_collection.last.id
          end

          chunk_num += 1

          print_num_processed_and_percent_complete(result, chunk_size, chunk_num, total_records)

          contents = result.to_yaml

          unless first_time
            contents = contents.split("\n")[1..-1].join("\n") + "\n"
          end

          write_file(yml_export_file, contents)

          # reset for a new round through the loop
          result = {}
          first_time = false
        end
      end

      puts "INFO >>>>>> #{name}: exported #{total_records} records"
    end
  end
end

def print_num_processed_and_percent_complete(result, chunk_size, chunk_num, total_records)
  unless result.empty? || total_records < chunk_size
    percentage = (chunk_size * chunk_num) / total_records.to_f
    percent_complete = (percentage * 100).round

    if percent_complete > 100
      percent_complete_text = '100%'
    else
      percent_complete_text = "#{percent_complete}%"
    end

    number_processed = chunk_size * chunk_num
    number_processed = total_records if number_processed > total_records

    puts "INFO >>>>>> #{name}: #{number_processed}/#{total_records} (#{percent_complete_text})"
  end
end

def delete_existing_file(yml_export_file)
  if File.exist?(yml_export_file)
    File.delete(yml_export_file)
    puts "INFO >>>>>> Deleting #{yml_export_file} for a clean re-export of data"
  end
end

def write_file(filename, contents)
  action = File.exist?(filename) ? 'Appended to' : 'Wrote'

  File.open(filename, 'a') do |f|
    f << contents
  end

  puts "FILE >>>>>> #{action} #{filename}" unless contents.strip.empty?
end

def habtm_fixtures(object)
  path = Rails.root.to_s + '/production_data'

  hatbms = object.reflect_on_all_associations.map{ |i| i if i.macro == :has_and_belongs_to_many }.compact
  h = {}

  hatbms.each do |m|
    table = m.options[:join_table]
    p = "#{path}/#{table}.yml"
    # object2 = m.klass

    h = {}
    object.find(:all).each_with_index do |o, index|
      associations = o.send m.klass.table_name

      associations.each do |a|
        h[a.class.to_s.underscore + index.to_s] =
          {
            "#{o.class.to_s.underscore}_id" => o.id,
            "#{a.class.to_s.underscore}_id" => a.id
          }
      end
    end

    write_file(p, h.to_yaml)
  end
end

namespace :db do
  desc "Load fixtures into the current environment's database. Load specific fixtures using FIXTURES=x,y"
  task from_yaml: :environment do
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(Rails.env.to_sym)
    (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Rails.root.to_s, 'production_data', '*.yml'))).each do |fixture_file|
      puts "DB >>>>>>>> importing #{fixture_file}"
      ActiveRecord::FixtureSet.create_fixtures('production_data', File.basename(fixture_file, '.*'))
    end
  end

  desc 'Dump all data to the production_data folder. Dump specific models using MODELS=model1,model_name2,another_model'
  task to_yaml: :environment do
    ############ This is to give a time calculation at the end ##################
    require 'time'
    include ActionView::Helpers::TextHelper

    def seconds_fraction_to_time(seconds)
      hours = 0
      mins = 0
      if seconds >=  60
        mins = (seconds / 60).to_i
        seconds = (seconds % 60).to_i

        if mins >= 60
          hours = (mins / 60).to_i
          mins = (mins % 60).to_i
        end
      else
        mins = 0
        hours = 0
        seconds = seconds.floor
      end

      total_time = ''
      total_time << pluralize(hours, 'hour') + ', '     if hours > 0
      total_time << pluralize(mins, 'minute') + ' and ' if mins > 0

      if seconds > 0
        total_time << pluralize(seconds, 'second')
      else
        total_time << '0 seconds'
      end

      total_time
    end
    ################################################################################

    path = Rails.root.to_s + '/production_data'

    models = ENV['MODELS'].split(',').map{ |m| m.camelize.singularize.gsub('.rb', '') } if ENV['MODELS']
    models ||= Dir.glob("#{Rails.root}/app/models/*.rb").map{ |c| c.gsub("#{Rails.root}/app/models/", '').gsub('.rb', '').camelize }

    start_time = Time.now

    FileUtils.mkdir_p(path)

    models.each do |m|
      begin
        this_models_start_time = Time.now

        object = m.constantize
        puts "\nDB >>>>>>>> Dumping data for #{object}"
        object.to_yaml(path)

        # get the association data for has_and_belongs_to_many
        habtm_fixtures(object)
        puts "TIME >>>>>> It took #{seconds_fraction_to_time(Time.now - this_models_start_time.to_time)} to export the data for the #{m} model"
      rescue => e
        puts "\nERROR >>>>>  #{e} \n\nskipping '#{m}'"
      end
    end
    puts '-----------'
    puts "TOTAL TIME: It took #{seconds_fraction_to_time(Time.now - start_time.to_time)} total to export the data you requested"
  end
end
