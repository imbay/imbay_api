class ApplicationController < ActionController::API
    include AccountHelper
	include SessionHelper
	before_action :init_controller

    def init_controller
        $time = Time.now.strftime("%s").to_i
        $datetime = DateTime.now.in_time_zone(Rails.application.config.time_zone)
        
		@normalizer = AccountNormalizer.new
		@response = {
			:error => 1,
			:body => nil
		}
	end
end
