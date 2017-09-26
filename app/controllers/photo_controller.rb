class PhotoController < ApplicationController
    include AccountHelper
	include SessionHelper
	before_action :init_controller

	def init_controller
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
            photo = $current_user.photos.find(params[:id]) rescue nil
            unless photo.nil?
                photo.new_comments = 0
                if photo.save == true
                    @response[:error] = 0
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
end
