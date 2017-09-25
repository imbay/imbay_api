Rails.application.routes.draw do
  scope :api do
    scope :v1 do
        scope :account do
            post '/sign_up', to: 'account#sign_up'
            post '/sign_in', to: 'account#sign_in'
        end
    end
  end
end
