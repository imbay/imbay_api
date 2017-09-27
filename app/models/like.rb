class Like < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: "account_id"
    belongs_to :photo, class_name: "Photo", foreign_key: "photo_id"

    before_validation do
        self.account = $current_user
        like = self.photo.Likes.find_by(account_id: $current_user.id)
        unless like.nil?
            # like is exists.
            like.delete
            if self.up == true && like.up == false
                # up like.
                self.photo.dislikes = self.photo.dislikes-1
                self.photo.likes = self.photo.likes+1
            elsif self.up == false && like.up == true
                # down like.
                self.photo.dislikes = self.photo.dislikes+1
                self.photo.likes = self.photo.likes-1
            end
            like.save(validate: false)
        else
            # new like.
            if self.up == true
                self.photo.likes = self.photo.likes+1
            else
                self.photo.dislikes = self.photo.dislikes+1
            end
        end
    end

    before_save do
        self.photo.save!(validate: false)
    end
end

