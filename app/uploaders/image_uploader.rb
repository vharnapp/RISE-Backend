class ImageUploader < CarrierWave::Uploader::Base
  include ::CarrierWaveBase64Uploader

  # Store uploaded images in S3
  if Rails.env.development? || Rails.env.test?
    storage :file
  else
    # :nocov:
    storage :fog
    # :nocov:
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'http://plachold.it/300x300.png'
  end
end
