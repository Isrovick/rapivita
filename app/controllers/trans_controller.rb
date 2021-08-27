class TransController < ApplicationController
    require 'rest-client'
    def new
        @tran = Tran.new
    end

    def getconv

        url = 'https://api.coindesk.com/v1/bpi/currentprice.json' 
        @response = RestClient.get(url)
        res=ActiveSupport::JSON.decode(@response)
        render json: ActiveSupport::JSON.encode(res['bpi']['USD']['rate'])
         

    end 
    
    def create

        unless @current_user && @current_user.id = session[:user_id] 
            render json:{status: "500"}
            return true
        end

        url = 'https://api.coindesk.com/v1/bpi/currentprice.json' 
        @response = RestClient.get(url)
        res=ActiveSupport::JSON.decode(@response)
        rate=res['bpi']['USD']['rate_float'].to_f
        ammount= params['ammount'].to_f
        currto= Curr.find(params['cto'])
        currfr= Curr.find(params['cfr'])

        rel=1
        
        unless ammount > 0  
            render json: { error: "amount"} 
            return true
        end
       
        if currto.cod=="USD"  && currfr.cod=="BTC"
        
            rel=rate*ammount
    
        elsif currto.cod=="BTC"  && currfr.cod=="USD"
        
            rel= ammount/rate

        end

        #render json: { status: rel }
        #return true

        @conv = Conv.where({currto: params['cto'] , currfr: params['cfr']}).first
        @bto= Balance.where({user: params['uto'] , curr: params['cto']}).first
        @bfr= Balance.where({user: params['ufr'] , curr: params['cfr']}).first

        if @bfr.bal < ammount
            render json: { status: "no tiene suficiente saldo" }
            return true
        end

        balfr=@bfr.bal - ammount
        balto=@bto.bal + rel

        ActiveRecord::Base.transaction do

            @bfr.update_attributes(:bal => balfr )
            @bto.update_attributes(:bal => balto )

                @tran = Tran.create!(
                    usrto:User.find(params['uto']),
                    usrfr:User.find(params['ufr']),
                    bal:ammount,
                    conv: @conv
                )

                if @tran.save
                
                session[:tran_id] = @tran.id
                render json: { msg: "Trans completed" }, status: :ok
                else
                    render json: { errors: @tran.errors }, status: :unprocessable_entity
                end

        rescue 
            render json: { errors: "error en transaccion" }, status: :unprocessable_entity

        end 
    end
    

end
