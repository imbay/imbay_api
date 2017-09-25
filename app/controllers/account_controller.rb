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
		session = new_session(params[:username], params[:password])
		if session == 2
			@response[:error] = 2
		elsif session.class.name == 'String'
			@response[:error] = 0
			@response[:body] = session
		end
		@response[:body] = init_session(session).account
		render json: @response
	end
end
