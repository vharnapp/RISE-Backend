class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@athletefit_backend.com',
          return_path: 'contact@athletefit_backend.com'

  layout 'mailer'

  def email(to_address, subject, body)
    options = { to: to_address, subject: subject, body: body }
    mail options
  end
end
