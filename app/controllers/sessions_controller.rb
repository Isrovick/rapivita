class SessionsController < ApplicationController
    include CurrentUserConcern

    def create
        user = User
                .find_by_email(user_params[:email])
                .try(:authenticate, user_params[:password])
        if user
            session[:user_id] = user.id
            render json: { 
                    status: :created,
                    logged_in: true,
                    user: user
            }
        else 
            render json: { status: 401 }
        end
      end

      def logged_in
        if @current_user
            render json: { 
                logged_in: true,
                user: @current_user
            }
        else
            render json: { 
                logged_in: false
            }
        end
      end

      def logout
            reset_session
            render json: { 
                logged_out: true,
                status: 200
            }
      end

      def user_params
        params.require(:user).permit(:email, :password)
      end

end