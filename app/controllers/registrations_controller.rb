class RegistrationsController < ApplicationController

    def create
        user = User.new(user_params)
        if user.save
         
        session[:user_id] = user.id
        render json: { 
            status: :created,
            user: user
        }
        else
            render json: {  status: 500 }
        end
    end
    
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :firstname, :lastname)
    end

end
