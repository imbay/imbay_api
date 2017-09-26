class Comment < ApplicationRecord
    attr_accessor :Photo_id

    COUNT_LIMIT = 10

    belongs_to :account, class_name: "Account", foreign_key: "account_id"
    belongs_to :photo, class_name: "Photo", foreign_key: "photo_id"

    validate :validate_comment
    private
        def validate_comment
            # count.
			if $current_user.comments.where("created_at >= ?", Time.now.beginning_of_day).count(:id) >= COUNT_LIMIT
				errors.add(:comment, "count")
            end
            # photo exists?
            unless Photo.find(self.Photo_id).exists?
                errors.add(:photo, "not found")
            end
        end

    validates :text,
        length: { minimum: 1, maximum: 100, too_short: "min", too_long: "max" }
end
