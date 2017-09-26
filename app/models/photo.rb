class Photo < ApplicationRecord
	attr_accessor :file
	SIZE_LIMIT = 5000000 # 5 MB.
	COUNT_LIMIT = 10

	belongs_to :account, class_name: "Account", foreign_key: "account_id"

	validate :validate_image
	private
		def validate_image
			# count.
			if $current_user.photos.count(:id) >= COUNT_LIMIT
				errors.add(:file, "count")
				return false
			end
			# mime.
			begin
				@image = MiniMagick::Image.open(self.file.path)
				unless @image.mime_type == "image/jpeg" || @image.mime_type == "image/png" || @image.mime_type == "image/gif"
					errors.add(:file, "mime")
					return false
				end
			rescue
				errors.add(:file, "invalid")
				return false
			end
			# size.
			if self.file.size > SIZE_LIMIT
				errors.add(:file, "size")
				return false
			end
			# pixels.
			resize_and_format
			if @image.height > 500 || @image.height < 200
				errors.add(:file, "pixels")
				return false
			end
		end
		def resize_and_format
			@image.format "jpeg"
			@image.resize "300"
			@image.write @image.path
		end
end
