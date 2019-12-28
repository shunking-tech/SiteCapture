class Capture < ApplicationRecord
  mount_uploader :image, ImageUploader
end
