class GravatarUpdater

  # updates the avatar of the given record using Gravatar by the record#email
  def update(record, options={})
    without_touching record do
      size = options.fetch(:size) { AvatarUploader::MaxSize }
      url = record.gravatar_url secure: true, size: size, d: 404
      record.remote_gravatar_url = url
      record.save!
    end
  end


  # @params
  #   list: Enumerable with objects having AvatarUploader as :avatar
  def update_all(list)
    list.each do |record|
      unless record.avatar?
        update(record)
      end
    end
  end

  private

  # do not change #updated_at
  def without_touching(record)
    if record.class.respond_to?(:without_timestamps)
      record.class.without_timestamps { yield }
    else
      yield
    end
  end

end
