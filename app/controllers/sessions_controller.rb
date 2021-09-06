class SessionsController < ApplicationController

    def create
        @user = User
                .find_by_email(user_params[:email])
                .try(:authenticate, user_params[:password])
        if @user
            token = AuthenticationTokenService.encode_token(@user.id)
            render json: { 
                    tkn: token,
                    name: "#{@user.firstname}, #{@user.lastname}",
                    logged_in: true,
                    user: @user
            },  status: :created
        else 
            render json: {  }, status: 401
        end
      end

      def logged_in
        
        if @user
            token = AuthenticationTokenService.encode_token(@user.id)
            render json: { 
                tkn: token,
                logged_in: true,
            },  status: :created
        else
            render json: { 
                logged_in: false
            }, status: 401
        end
      end

      def logout
            render json: { 
                logged_out: true,
                status: 200
            }
      end

      def user_params
        params.require(:user).permit(:email, :password)
      end

end
