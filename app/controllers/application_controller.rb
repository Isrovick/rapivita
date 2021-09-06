class ApplicationController < ActionController::Base
    
    skip_before_action :verify_authenticity_token
    
    before_action :require_login

    def logged_in?
        @user = AuthenticationTokenService::session_user(request,params)
        !!( @user || request['user'])     
    end

    def require_login
        render json: {msg: 'Please Login'}, status: :unauthorized unless logged_in?
    end

    

end
