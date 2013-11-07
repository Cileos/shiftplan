class Notification::RecipientsFinder

  attr_reader :notifiable

  def find(notifiable)
    @notifiable = notifiable

    case notifiable
    when ::Post
      recipients_for_post
    end
  end

  def recipients_for_post
    notifiable.organization.employees.select do |e|
      e.user.present? && e.user.confirmed? &&
        notifiable.author != e
    end
  end
end
