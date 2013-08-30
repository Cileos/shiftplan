class GravatarUpdater

  # updates the avatar of the given record using Gravatar by the record#email
  def update(record, options={})
    size   = options.fetch(:size) { AvatarUploader::MaxSize }
    logger = options.fetch(:logger) { Rails.logger }
    url = record.gravatar_url secure: true, size: size, d: 404
    record.remote_avatar_url = url
    without_touching record do
      record.save!
    end
  rescue StandardError => e
    logger.warn "could not update gravatar for #{record}: #{e.message}"
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
