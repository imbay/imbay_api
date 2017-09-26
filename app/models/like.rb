class Like < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: "account_id"
    belongs_to :photo, class_name: "Photo", foreign_key: "photo_id"

    before_validation do
        self.account = $current_user
        like = self.photo.Likes.find_by(account_id: $current_user.id)
        unless like.nil?
            # like is exists.
            like.delete
            if self.up == true
                self.photo.likes = self.photo.likes-1
            else
                self.photo.dislikes = self.photo.dislikes-1
            end
        end
    end

    before_save do
        if self.up == true
            self.photo.likes = self.photo.likes+1
        else
            self.photo.dislikes = self.photo.dislikes+1
        end
        self.photo.save!(validate: false)
    end
end

