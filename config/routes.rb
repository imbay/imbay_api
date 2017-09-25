Rails.application.routes.draw do
  scope :api do
    scope :v1 do
        scope :account do
            post '/sign_up', to: 'account#sign_up'
            post '/sign_in', to: 'account#sign_in'
            post '/sign_out', to: 'account#sign_out'
            post '/current_user', to: 'account#current_user'
        end
    end
  end
end
