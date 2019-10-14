class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "verify_email"
end
