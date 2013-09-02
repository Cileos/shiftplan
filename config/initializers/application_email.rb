require 'volksplaner/staging_mail_interceptor'

if Volksplaner.staging?
  Mail.register_interceptor(Volksplaner::StagingMailInterceptor)
end
