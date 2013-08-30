class AvatarWidget < Struct.new(:h, :user, :employee, :version)

  attr_reader :html_options

  def initialize(*a)
    @html_options = a.extract_options!
    super(*a)

    @html_options[:class] = "avatar #{version} #{@html_options[:class]}"
    if user && employee.nil?
      employee = user.find_employee_with_avatar
    end
  end

  def to_html
    if employee && employee.avatar?
      avatar_tag employee.avatar, version, html_options
    elsif user.avatar?
      avatar_tag user.avatar, version, html_options
    else
      h.content_tag(:i, employee.shortcut, html_options)
    end
  end

  # FIXME dead code, move to GravatarUpdater or similar
  def gravatar(user, version, html_options)
    size = AvatarUploader.const_get("#{version.to_s.camelize}Size")
    gravatar_options = { default: 'mm', size: size }
    if user.present?
      h.image_tag user.gravatar_url(gravatar_options), html_options
    else
      h.image_tag User.new.gravatar_url(gravatar_options.merge(forcedefault: 'y')), html_options
    end
  end

  private

  def avatar_tag(avatar, version, options)
    h.image_tag avatar.url(version), options
  end
end
