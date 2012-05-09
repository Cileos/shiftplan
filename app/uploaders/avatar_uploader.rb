# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # Store files that were uploaded in tests under a different path and not under
    # the public directory. This way we can easily remove all these generated files
    # after each test run without having to fear deleting production files,
    # accidentally.
    if Rails.env.test?
      "#{Rails.root}/features/support/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      # production files are stored in 'uploads' under the Rails public path
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_fit => [400, 400]

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:

  MediumSize = 200
  version :medium do
    process :resize_to_fit => [200, 200]
  end

  ThumbSize = 50
  version :thumb do
    process :resize_to_fit => [50, 50]
  end

  TinySize = 27
  version :tiny do
    process :resize_to_fit => [27, 27]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
