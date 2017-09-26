class AccountController < ActionController::API
	include AccountHelper
	include SessionHelper
	before_action :init_controller

	def init_controller
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
                account.language = params[:language]
                account.save!
                
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

		if delete_session
			@response[:error] = 0
		end
		render json: @response
	end

	def current_user
		init_session(params[:session_key])
		if $is_auth == true
			@response[:error] = 0
			@response[:body] = $current_user
		else
			@response[:error] = 2
		end
		render json: @response
	end
end
