# frozen_string_literal: true

# Methods for validating Archive-It credentials.
class AiWasapiValidator < ActiveModel::Validator
  def validate(user)
    unless :wasapi_username.blank? && :wasapi_password.blank?
      ai_wasapi_base_url = 'https://partner.archive-it.org/wasapi/v1/webdata'
      ai_wasapi_request_code = HTTP.basic_auth(user: user.wasapi_username,
                                               pass: user.wasapi_password)
                                   .get(ai_wasapi_base_url).code
      if ai_wasapi_request_code != 200
        user.errors.add(:wasapi_username, 'Invalid Archive-It credentials.')
        user.errors.add(:wasapi_password, 'Invalid Archive-It credentials.')
      end
    end
  end
end
