class AvatarWidget < Struct.new(:h, :user, :employee, :version)

  attr_reader :html_options

  def initialize(*a)
    @html_options = a.extract_options!
    super(*a)

    @html_options[:class] = "avatar #{version} #{@html_options[:class]}"
  end

  def to_html
    employee = user.find_employee_with_avatar if user && employee.nil?
    if employee && employee.avatar?
      h.image_tag(employee.avatar.url(version), html_options)
    else
      gravatar(user, version, html_options)
    end
  end

  def gravatar(user, version, html_options)
    size = AvatarUploader.const_get("#{version.to_s.camelize}Size")
    gravatar_options = { default: 'mm', size: size }
    if user.present?
      h.image_tag user.gravatar_url(gravatar_options), html_options
    else
      h.image_tag User.new.gravatar_url(gravatar_options.merge(forcedefault: 'y')), html_options
    end
  end
end
