class GravatarUpdater

  # updates the avatar of the given record using Gravatar by the record#email
  def update(record, options={})
    size = options.fetch(:size) { AvatarUploader::MaxSize }
    url = record.gravatar_url secure: true, size: size, d: 404
    record.remote_gravatar_url = url
    record.save!
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

end
