class PhotoController < ApplicationController
    def upload
        init_session(params[:session_key])
        set_login_datetime()
		if $is_auth == true
            photo = $current_user.photos.new
            photo.file = File.open(params[:photo].path)
            ActiveRecord::Base.transaction(isolation: :serializable) do
                begin
                    photo.save!
                    @response[:error] = 0
                rescue ActiveRecord::RecordInvalid
                    @response[:error] = 3
                    @response[:body] = photo.errors.messages
                end
            end
        end
        render json: @response
    end
    def delete
        init_session(params[:session_key])
		if $is_auth == true
            photo = $current_user.photos.find(params[:photo_id]) rescue nil
            unless photo.nil?
                if photo.destroy
                    @response[:error] = 0
                end
            end
        end
        render json: @response
    end
    def read_comments
        init_session(params[:session_key])
        if $is_auth == true
            ActiveRecord::Base.transaction(isolation: :serializable) do
                photo = $current_user.photos.find(params[:photo_id]) rescue nil
                unless photo.nil?
                    photo.new_comments = 0
                    if photo.save(validate: false) == true
                        @response[:error] = 0
                    end
                end
            end
        end
        render json: @response
    end
    def photos
        init_session(params[:session_key])
        if $is_auth == true
            begin
                @response[:body] = $current_user.photos.select(:id, :views, :likes, :dislikes, :comments, :new_comments).limit(Photo::COUNT_LIMIT).order(new_comments: :desc, id: :desc).all
                @response[:error] = 0
            rescue
            end
        end
        render json: @response
    end
    def content
        photo = Photo.find(params[:id]) rescue nil
        unless photo.nil?
            Photo.find(params[:id]).content
            render plain: photo.content, content_type: 'image/jpeg'
        else
            raise ActionController::RoutingError.new('Not Found')
        end
    end
    def get
        init_session(params[:session_key])
        set_login_datetime()
        if $is_auth == true
            begin
                gender = @normalizer.gender(params[:gender])
                photos = Photo.joins(:account).select('id', 'accounts.username', 'accounts.first_name', 'accounts.last_name').order("views ASC").where("accounts.is_active = ? AND accounts.gender = ?", true, gender).limit(100).all rescue nil
                if photos.size == 0
                    @response[:error] = 4
                else
                    photo = photos[rand(photos.size)-1]
                    like = photo.Likes.select(:up).find_by(account_id: $current_user.id) rescue nil
                    photo = photo.serializable_hash
                    if like == nil
                        photo['like'] = nil
                    else
                        photo['like'] = like[:up]
                    end
                    @response[:error] = 0
                    @response[:body] = photo
                end
            rescue
            end
        end
        render json: @response
    end
    def write_comment
        init_session(params[:session_key])
        set_login_datetime()
        if $is_auth == true
            ActiveRecord::Base.transaction(isolation: :serializable) do
                photo = Photo.find(params[:photo_id]) rescue nil
                unless photo.nil?
                    comment = photo.Comments.new
                    comment.text = params[:text]
                    begin
                        comment.save!
                        @response[:error] = 0
                    rescue ActiveRecord::RecordInvalid
                        @response[:error] = 3
                        @response[:body] = comment.errors.messages
                    end
                else
                    @response[:error] = 4
                end
            end
        end
        render json: @response
    end
    def to_view
        init_session(params[:session_key])
        if $is_auth == true
            ActiveRecord::Base.transaction(isolation: :serializable) do
                photo = Photo.find(params[:photo_id]) rescue nil
                unless photo.nil?
                    begin
                        view = photo.Views.new
                        view.save!
                        @response[:error] = 0
                    rescue ActiveRecord::RecordInvalid
                        @response[:error] = 3
                        @response[:body] = view.errors.messages
                    end
                else
                    @response[:error] = 4
                end
            end
        end
        render json: @response
    end
    def to_like
        init_session(params[:session_key])
        set_login_datetime()
        if $is_auth == true
            ActiveRecord::Base.transaction(isolation: :serializable) do
                photo = Photo.find(params[:photo_id]) rescue nil
                unless photo.nil?
                    begin
                        like = photo.Likes.new
                        like.up = params[:up]
                        like.save!
                        @response[:error] = 0
                    rescue ActiveRecord::RecordInvalid
                        @response[:error] = 3
                        @response[:error] = like.errors.messages
                    end
                else
                    @response[:error] = 4
                end
            end
        end
        render json: @response
    end
    def comments
        init_session(params[:session_key])
        if $is_auth == true
                comments = $current_user.photos.find(params[:photo_id]).Comments.joins(:account).select(:id, :text, "accounts.id AS user_id, accounts.username, accounts.first_name, accounts.last_name").order(id: :desc).limit(500).all
                @response[:error] = 0
                @response[:body] = comments
        end
        render json: @response
    end
end
