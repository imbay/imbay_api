class Comment < ApplicationRecord
    COUNT_LIMIT = 1000

    belongs_to :account, class_name: "Account", foreign_key: "account_id"
    belongs_to :photo, class_name: "Photo", foreign_key: "photo_id"

    private
        def normalize value
            value.to_s.strip
        end

    before_validation do
        self.account = $current_user
        self.photo.comments = self.photo.comments+1
        self.photo.new_comments = self.photo.new_comments+1
        self.text = normalize(self.text)
    end

    before_save do
        self.photo.save!(validate: false)
    end

    validate :validate_comment
    private
        def validate_comment
            # count.
			if $current_user.comments.where("created_at >= ?", Time.now.beginning_of_day).count(:id) >= COUNT_LIMIT
				errors.add(:comment, "count")
            end
        end

    validates :text,
        length: { minimum: 1, maximum: 100, too_short: "min", too_long: "max" }
end
