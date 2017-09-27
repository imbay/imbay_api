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
    def list
        init_session(params[:session_key])
        if $is_auth == true
            begin
                @response[:error] = 0
                @response[:body] = $current_user.photos.select(:id, :views, :likes, :dislikes, :comments, :new_comments).limit(Photo::COUNT_LIMIT).order(new_comments: :desc, likes: :desc).all
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
                photo = Photo.joins(:account).select('id', 'accounts.username', 'accounts.first_name', 'accounts.last_name').order("views ASC, likes ASC, comments ASC").where("accounts.is_active = ? AND accounts.gender = ?", true, @normalizer.gender(params[:gender])).limit(100).all[rand(Photo.all.limit(100).count(:id))] rescue nil
                unless photo.nil?
                    like = photo.Likes.select(:up).find_by(account_id: $current_user.id) rescue nil
                    puts "test:"
                    puts like.class.name
                    photo = photo.serializable_hash
                    if like == nil
                        photo['like'] = nil
                    else
                        photo['like'] = like[:up]
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
    def write_comment
        init_session(params[:session_key])
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
