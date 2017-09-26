class Like < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: "account_id"
    belongs_to :photo, class_name: "Photo", foreign_key: "photo_id"

    private
        def normalize value
            value.to_s.strip.to_i
        end

    before_save do
        like = self.photo.Likes.find_by(account_id: $current_user.id) rescue nil
        self.up = normalize(self.up)
        if like.nil?
            # first like.
            self.account = $current_user
            self.photo.Likes = self.photo.Likes+1
            self.photo.save!(validate: false)
        end
    end
end
