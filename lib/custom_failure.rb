# :nocov:
class CustomFailure < Devise::FailureApp
  def respond
    # NOTE: This was only necessary when using Postman
    if request.format == :api_json || request_content_type_includes_json
      request.format = :json
    end

    super
  end

  private

  def request_content_type_includes_json
    request.content_type && request.content_type.include?('json')
  end
end
