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
            session.session_key = sha256("#{account.id}_#{SecureRandom.uuid.to_s}")
            session.save!
            return session.session_key
        else
            return 2
        end
    end
    def init_session key
        $current_user = nil
        $is_auth = false
        $session_key = key
        session = Session.find_by(session_key: key) rescue nil
        unless session.nil?
            $current_user = session.account
            $is_auth = true
        end
        return session
    end
    def delete_session
        if $is_auth == true
            session = $current_user.sessions.find_by(session_key: $session_key) rescue nil
            puts "test"
            puts session.class.name
            unless session.nil?
                if session.delete
                    return true
                end
            end
        end
        return false
    end
    def clear_sessions
        if $is_auth == true
            session = $current_user.sessions.find_by(session_key: $session_key) rescue nil
            puts "test"
            puts session.class.name
            unless session.nil?
                if session.delete_all
                    return true
                end
            end
        end
        return false
    end
    def sha256 value
        Digest::SHA256.hexdigest(value.to_s).to_s
    end
end
