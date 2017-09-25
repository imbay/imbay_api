module SessionHelper
    def new_session username, password
        @normalizer = AccountHelper::AccountNormalizer.new
        username = @normalizer.username(username)
        password = @normalizer.password(password)
        account = Account.find_by(username: username) rescue nil
        if !account.nil? && account.check_password(password)
            session = Session.new
            session.account = account
            session.expire_time = $time+2592000 # one month.
            session.key = sha256("#{account.id}_#{SecureRandom.uuid.to_s}")
            session.save!
            return session.key
        else
            return 2
        end
    end
    def init_session key
        session = Session.find_by(key: key) rescue nil
        return session
    end
    def delete_session key
    end
    def clear_sessions
    end
    def sha256 value
        Digest::SHA256.hexdigest(value.to_s).to_s
    end
end
