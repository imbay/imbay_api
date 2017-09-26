class PhotoController < ApplicationController
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
    
    def upload
        init_session(params[:session_key])
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
            photo = $current_user.photos.find(params[:id]) rescue nil
            unless photo.nil?
                if photo.delete == true
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
                photo = $current_user.photos.find(params[:id]) rescue nil
                unless photo.nil?
                    photo.new_comments = 0
                    if photo.save == true
                        @response[:error] = 0
                    end
                end
            end
        end
        render json: @response
    end
    def list
        init_session(params[:session_key])
        if $is_auth == true
            begin
                @response[:error] = 0
                @response[:body] = $current_user.photos.select(:id, :views, :likes, :dislikes, :comments, :new_comments).limit(Photo::COUNT_LIMIT).order(id: :desc).all
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
        if $is_auth == true
            begin
                @response[:error] = 0
                photo = Photo.joins(:account).select('id', 'accounts.username', 'accounts.first_name', 'accounts.last_name').order("accounts.login_at DESC, views ASC, likes ASC, comments ASC").where("accounts.is_active = ? AND accounts.gender = ?", true, @normalizer.gender(params[:gender])).first rescue nil
                unless photo.nil?
                    photo = photo.serializable_hash
                    like = photo.likes.find_by(photo_id: photo.id, account_id: $current_user.id).select('up') rescue nil
                    if like == nil
                        photo['like'] = nil
                    else
                        photo['like'] = like.up
                    end
                    @response[:body] = photo
                else
                    @response[:error] = 4
                end
            rescue
            end
        end
        render json: @response
    end
    def to_like
        init_session(params[:session_key])
        if $is_auth == true
            ActiveRecord::Base.transaction(isolation: :serializable) do
                photo = Photo.find(params[:id]) rescue nil
                unless photo.nil?
                    like = photo.likes.find_by(account_id: $current_user.id) rescue nil
                    if like.nil?
                        # first like.
                        photo.likes = photo.likes+1
                        photo.save!
                        like.account = current_user
                        photo.save!
                        @response[:error] = 0
                    else
                        # update like.
                        like.up = params[:like].to_i
                        like.save!
                        photo.likes = photo.likes+1
                        photo.save!
                        @response[:error] = 0
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
                photo = Photo.find(params[:id]) rescue nil
                unless photo.nil?
                    unless photo.views.find_by(account_id: $current_user.id).exists?
                        # first view.
                        view = photo.views.new
                        view.account = $current_user
                        view.save!
                        photo.views = photo.views+1
                        photo.save!
                        @response[:error] = 0
                    end
                else
                    @response[:error] = 4
                end
            end
        end
        render json: @response
    end
    def to_comment
        init_session(params[:session_key])
        if $is_auth == true
            ActiveRecord::Base.transaction(isolation: :serializable) do
                photo = Photo.find(params[:id]) rescue nil
                unless photo.nil?
                    comment = photo.comments.new
                    comment.account = $current_user
                    comment.text = params[:text].to_s.strip
                    begin
                        comment.save!
                        photo.comments = photo.comments+1
                        photo.new_comments = photo.new_comments+1
                        photo.save!
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
    def comments
        init_session(params[:session_key])
        if $is_auth == true
            begin
                comments = $current_user.photos.find(params[:id]).comments.limit(500).select(:id, :text).order(id: :desc).all
                @response[:error] = 0
                @response[:body] = comments
            rescue
                @response[:error] = []
            end
        end
        render json: @response
    end
end
