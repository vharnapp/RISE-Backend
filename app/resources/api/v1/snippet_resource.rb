module Api
  module V1
    class SnippetResource < JSONAPI::Resource
      attributes :name, :content
    end
  end
end
