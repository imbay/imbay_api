class Session < ApplicationRecord
    belongs_to :account, class_name: "Account", foreign_key: "account_id"
end
