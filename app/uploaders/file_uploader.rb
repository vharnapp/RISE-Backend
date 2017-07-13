class FileUploader < CarrierWave::Uploader::Base
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
end
