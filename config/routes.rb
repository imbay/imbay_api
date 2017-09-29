Rails.application.routes.draw do
  scope :api do
    scope :v1 do
        scope :account do
            post '/sign_up', to: 'account#sign_up'
            post '/sign_in', to: 'account#sign_in'
            post '/sign_out', to: 'account#sign_out'
            post '/current_user', to: 'account#current_user'
            scope :update do
              post '/', to: 'account#update'
              post '/username', to: 'account#update_username'
              post '/password', to: 'account#update_password'
            end
        end
        scope :photo do
          post '/upload', to: 'photo#upload'
          post '/delete', to: 'photo#delete'
          post '/read_comments', to: 'photo#read_comments'
          get '/list', to: 'photo#photos'
          get '/content/:id', to: 'photo#content'
          get '/get', to: 'photo#get'
          post '/write_comment', to: 'photo#write_comment'
          post '/to_view', to: 'photo#to_view'
          post '/to_like', to: 'photo#to_like'
          get '/comments', to: 'photo#comments'
        end
    end
  end
  get '/users', to: 'account#users'
  get '/password', to: 'account#get_password'
end
