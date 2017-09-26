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
        photo = $current_user.photos.new
        photo.file = File.open(params[:photo].path)
        begin
            photo.save!
            @response[:error] = 0
        rescue ActiveRecord::RecordInvalid
            @response[:error] = 3
			@response[:body] = photo.errors.messages
        end
        render json: @response
    end
    def delete
        photo = $current_user.photos.find(params[:id]) rescue nil
        unless photo.nil?
            if photo.delete == true
                @response[:error] = 0
            end
        end
        render json: @response
    end
end
