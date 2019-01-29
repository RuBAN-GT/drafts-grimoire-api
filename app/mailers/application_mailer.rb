class ApplicationMailer < ActionMailer::Base
  default :from => "reports@localhost"

  layout 'mailer'
end
