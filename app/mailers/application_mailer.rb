class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@athletefit.com',
          return_path: 'info@athletefit.com'

  layout 'mailer'

  def email(to_address, subject, body)
    options = { to: to_address, subject: subject, body: body }
    mail options
  end
end
