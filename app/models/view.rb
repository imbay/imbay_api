class View < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: "account_id"
    belongs_to :photo, class_name: "Photo", foreign_key: "photo_id"

    before_validation do
        self.account = $current_user
        if self.photo.Views.exists?(account_id: $current_user.id)
            errors.add(:view, "exists")
        else
            self.photo.views = self.photo.views+1
        end
    end

    before_save do
        self.photo.save!(validate: false)
    end
end
