RSpec::Matchers.define :have_received_mails do |count|
  match do |address|
    address = resolve_email_address address
    mails = all_mails(address)
    if @subject.present?
      mails = mails.select {|m| m.subject == @subject }
    end
    if @body.present?
      mails = mails.select {|m| m.body.include? @body }
    end
    @count = mails.count || 1
    @count == count
  end

  chain :with_subject do |subject|
    @subject = subject
  end
  chain :with_body do |body|
    @body = body
  end

  failure_message_for_should do |address|
    address = resolve_email_address address
    "#{address} should have received #{count} mails, but received #{@count}".tap do |m|
      if @subject.present?
        m << " with subject #{@subject.inspect}"
      end
      if @body.present?
        m << " with body including #{@body.inspect}"
      end
      m << "\nreceived_mails:\n#{all_mails(address).map {|m| dump_mail(m) }.join("\n\n")}"
    end
  end
end

RSpec::Matchers.define :have_received_no_mail do
  match do |address|
    address = resolve_email_address address
    ActionMailer::Base.deliveries.none? { |mail| mail.to.include?(address) }
  end
end

module NotificationMatcher
  def have_been_notified(*a)
    have_received_mails(1)
  end

  def all_mails(to=nil)
    if to.nil?
      ActionMailer::Base.deliveries
    else
      ActionMailer::Base.deliveries.select { |mail| mail.to.include?(to) }
    end
  end

  def dump_mail(mail)
    "#{mail.from.inspect} => #{mail.to.inspect} `#{mail.subject}`\n#{mail.body}"
  end

  def resolve_email_address(address)
    address = address.user if address.respond_to?(:user) # can throw an employee in here
    address = address.email if address.respond_to?(:email) # can throw a user in here
    address
  end
end

RSpec::Matchers.send :include, NotificationMatcher

