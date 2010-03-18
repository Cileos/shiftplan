#devise will send confirmation mail, so we have to setup action mailer
ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'cileos.com',
  :authentication => :plain,
  :user_name => 'sysadmin@cileos.com',
  :password => 'alsk10fritz8'
}

#needs to be set for devise (http://github.com/plataformatec/devise/issues/closed#issue/139)
# FIXME
#after switching to rails HEAD we have to re-check this
if RAILS_ENV == 'production'
  ActionMailer::Base.default_url_options[:host] = "shiftplandemo.heroku.com"
else
  ActionMailer::Base.default_url_options[:host] = "localhost:3000"
end