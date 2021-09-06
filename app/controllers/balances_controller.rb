class BalancesController < ApplicationController

    def getuserbals
        if @user

            balances = Balance.includes(:curr).where(user_id:1).pluck("balances.id",:bal,"currs.cod", "currs.id","currs.typ")
                       
                token = AuthenticationTokenService.encode_token(@user.id)
                render json: { 
                    tkn: token,
                    bals:  balances,
                    logged_in: true,
                },  status: :created
        else
            render json: { 
                logged_in: false
            }, status: 401
        end
      
    end

   

end
