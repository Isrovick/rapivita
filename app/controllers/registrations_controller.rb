class RegistrationsController < ApplicationController

    def create
        user = User.new(user_params)
        if user.save
            token = AuthenticationTokenService::encode_user(user.id)
           
            render json: { 
                tkn: token,
                name: "#{@user.firstname}, #{@user.lastname}",
                logged_in: true,
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
