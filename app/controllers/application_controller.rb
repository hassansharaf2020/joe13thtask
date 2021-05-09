class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

    def current_user
      @current_user ||= User.find(payload['user_id'])
    end

    def not_authorized
      render json: { error: 'Not authorized' }, status: :unauthorized
    end

    def base_url
		@base_url =  'http://127.0.0.1:3000/'
   	end
end
