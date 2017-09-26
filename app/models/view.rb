class View < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: "account_id"
    belongs_to :photo, class_name: "Photo", foreign_key: "photo_id"

    before_save do
        view = self.photo.Views.find_by(account_id: $current_user.id) rescue nil
        if view.nil?
            # first view.
            self.account = $current_user
            self.photo.Views = self.photo.Views+1
            self.photo.save!(validate: false)
        end
    end
end
