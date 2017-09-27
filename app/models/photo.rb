class Photo < ApplicationRecord
	attr_accessor :file
	SIZE_LIMIT = 5000000 # 5 MB.
	COUNT_LIMIT = 10

	belongs_to :account, class_name: "Account", foreign_key: "account_id"
	has_many :Likes, class_name: "Like", foreign_key: "photo_id", dependent: :destroy
	has_many :Comments, class_name: "Comment", foreign_key: "photo_id", dependent: :destroy
	has_many :Views, class_name: "View", foreign_key: "photo_id", dependent: :destroy

	validate :validate_image
	before_save(if: :new_record?) do
		self.content = File.read(@image.path)
	end
	private
		def validate_image
			# count.
			if $current_user.photos.count(:id) >= COUNT_LIMIT
				errors.add(:image, "count")
				return false
			end
			# mime.
			begin
				@image = MiniMagick::Image.open(self.file.path)
				unless @image.mime_type == "image/jpeg" || @image.mime_type == "image/png" || @image.mime_type == "image/gif"
					errors.add(:image, "mime")
					return false
				end
			rescue
				errors.add(:image, "invalid")
				return false
			end
			# size.
			if self.file.size > SIZE_LIMIT
				errors.add(:image, "size")
				return false
			end
			# pixels.
			resize_and_format
			if @image.height > 500 || @image.height < 200
				errors.add(:image, "pixels")
				return false
			end
		end
		def resize_and_format
			@image.format "jpeg"
			@image.resize "300"
			@image.write @image.path
		end
end
