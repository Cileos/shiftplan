class ClockworkMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: "Clockwork <no-reply@#{Volksplaner.hostname}>"
end
