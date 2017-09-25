class AccountValidator < ActiveModel::Validator
    include AccountHelper
    def validate(record)
        @scanner = AccountDataScanner.new
        # Password.
        if @scanner.password(record.password) == false
            record.errors[:password] << "invalid"
        end
    end
end

class Account < ApplicationRecord
    include AccountHelper
    include ApplicationHelper
    include ActiveModel::Validations
    validates_with AccountValidator

    before_save do
        self.password = encrypt_password(self.password) if self.password_changed?
    end
    before_validation(on: :create) do
        self.login_at = $datetime
        self.sign_up_at = self.login_at
    end
    before_validation do
        @normalizer = AccountNormalizer.new
        self.username = @normalizer.username self.username if self.username_changed?
        self.email = @normalizer.email self.email if self.email_changed?
        self.password = @normalizer.password self.password if self.password_changed?
        self.first_name = @normalizer.name self.first_name if self.first_name_changed?
        self.last_name = @normalizer.name self.last_name if self.last_name_changed?
        self.first_name_ru = name_to_russian self.first_name
        self.last_name_ru = name_to_russian self.last_name
        self.first_name_en = name_to_english self.first_name
        self.last_name_en = name_to_english self.last_name
        self.language = @normalizer.language self.language
        unless self.new_record?
            self.is_active = @normalizer.is_active self.is_active if self.is_active_changed?
        end
    end

    def check_password value
        @normalizer = AccountNormalizer.new
        return BCrypt::Password.new(self.password) == @normalizer.password(value)
    end

    validates :username,
        length: { minimum: 5, maximum: 36, too_short: "min", too_long: "max" },
        format: { with: AccountConfiguration.new.regexp[:username], message: "invalid" },
        uniqueness: { message: 'unique' }
    validates :first_name,
        length: { minimum: 1, maximum: 15, too_short: "min", too_long: "max" }
    validates :last_name,
        length: { minimum: 1, maximum: 15, too_short: "min", too_long: "max" }
    validates :email,
        length: { minimum: 5, maximum: 50, too_short: "min", too_long: "max" },
        format: { with: AccountConfiguration.new.regexp[:email], message: "invalid" },
        uniqueness: { message: 'unique' },
        allow_nil: true,
        allow_blank: false
    validates :gender,
        inclusion: { in: [0, 1], message: "invalid" }
    validates :password,
        length: { minimum: 6, maximum: 100, too_short: "min", too_long: "max" }
end
