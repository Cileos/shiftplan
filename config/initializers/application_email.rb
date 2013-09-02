if Volksplaner.staging?
  Mail.register_interceptor(Volksplaner::StagingMailInterceptor)
end
