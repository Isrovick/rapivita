class TransController < ApplicationController
    require 'rest-client'
    def new
        @tran = Tran.new
    end

    def getrel
        url = 'https://api.coindesk.com/v1/bpi/currentprice.json' 
        @response = RestClient.get(url)
        res = ActiveSupport::JSON.decode(@response)
        rate = res['bpi']['USD']['rate']
    end

    def getrelf
        url = 'https://api.coindesk.com/v1/bpi/currentprice.json' 
        @response = RestClient.get(url)
        res = ActiveSupport::JSON.decode(@response)
        rate = (res['bpi']['USD']['rate_float']).to_d
    end

    def getrelresp
        render json: ActiveSupport::JSON.encode(getrel) ,  status: :ok
    end 

    def getconv
        rate = getrelf

        unless (@currto && @currfr)
            @currto= Curr.find(params['rate']['cto'])
            @currfr= Curr.find(params['rate']['cfr'])
        end 

        if @currto.cod=="USD"  && @currfr.cod=="BTC"
            rel = 1*rate
        elsif @currto.cod=="BTC"  && @currfr.cod=="USD"
            rel = 1/rate
        else
            rel=1
        end
        
        rel=rel#.ceil(10)
    end

    def getconvresp
        render json: {rel: getconv}
    end
    
    def create

        unless @user
            render json:{ status: :bad_request}
            return true
        end

        ammount= (params['rate']['ammount']).to_d
        @currto= Curr.find(params['rate']['cto'])
        @currfr= Curr.find(params['rate']['cfr'])
        @bto= Balance.where({user: @user , curr: @currto.id}).first
        @bfr= Balance.where({user: @user , curr: @currfr.id}).first

        ct=gc(@currto)
        cf=gc(@currfr)
        rel = getconv
        ammount = ammount.ceil(cf)
        amm = (rel*ammount)
        amm = amm.ceil(ct)

        #render json: {amm: amm, ammount: ammount}
        #return true

        unless (ammount > 0 || @bfr.bal.to_d < ammount)   
            render json: { status: :precondition_failed} 
            return true
        end

        ActiveRecord::Base.transaction do

        @conv = Conv.create({curto: @currto , curfr: @currfr, rel: rel})
        unless @conv.save
            render json: {  status: :conflict } 
            return true
        end
     
        balfr = (@bfr.bal.to_d - ammount.to_d)
        balto = (@bto.bal.to_d + amm.to_d)

        #balfr = BigDecimal.new(@bfr.bal) - BigDecimal.new(ammount)
        #balto = BigDecimal.new(@bto.bal) + BigDecimal.new(amm)
        # render json: {balto: balto.to_d,
        #               balfr: balfr.to_d,
        #               cf: cf, 
        #               ct: ct, 
        #               amm: amm, 
        #               ammount: ammount, 
        #               bfrbal: @bfr.bal, 
        #               btobal: @bto.bal}
        # return true

            @bfr.update bal: balfr.to_d
            @bto.update bal: balto.to_d

                @tran = Tran.create(
                    usrto: @user,
                    usrfr: @user,
                    bal:(-1*ammount),
                    conv: @conv
                )

                @tran2 = Tran.create(
                    usrto: @user,
                    usrfr: @user,
                    bal: amm,
                    conv: @conv
                )

                if @tran.save && @tran2.save
                
                    token = AuthenticationTokenService.encode_token(@user.id)
                    render json: { 
                        tkn: token,
                        tran:@tran.id,
                        logged_in: true,
                        status: :accepted }
                else
                    render json: { errors: @tran.errors }, status: :unprocessable_entity
                end

        rescue 
            render json: {  status: :conflict }

        end 
    end

    def gc(curr)
        
        type= curr.typ

        if(type=="1")
            c = 8
        else
            c = 2
        end
    end

    def gettrans
        if @user
            tran= Tran.find(params['tid'])
            token = AuthenticationTokenService.encode_token(@user.id)
            usrto= User.find(tran.usrto.id)
            usrfr= User.find(tran.usrfr.id)

            usrtos= "#{usrto.firstname}, #{usrto.lastname}"
            usrfrs= "#{usrfr.firstname}, #{usrfr.lastname}"

            nbal=0
            cod=''
            conv=Conv.find(tran.conv_id)
             if tran.bal<0
                 curr=Curr.find(conv.curfr_id)
                 cod=curr.cod
                 if curr.typ=="1"
                     nbal= "%.8f" % tran.bal
                 else
                     nbal=tran.bal
                 end    
             else
                 curr=Curr.find(conv.curto_id)
                 cod=curr.cod
                 if curr.typ=="1"
                     nbal= "%.8f" % tran.bal
                 else
                     nbal=tran.bal
                 end  
             end    

            render json: {
            from:usrfrs,
            to:usrtos,
            ammount:nbal,
            date:tran.updated_at.strftime("%d %b %y, %H:%M"),
            tkn:token,
            logged_in:true,
            status: :ok
            }
        else
            render json:{status:401}
        end
    end   

    def getalltrans
        if @user
            token = AuthenticationTokenService.encode_token(@user.id)
            trans = Tran.where("usrto_id=#{@user.id} or usrfr_id=#{@user.id}").order("updated_at DESC").limit(10).pluck(:id,:bal,:updated_at,:conv_id)
            
            tt=[]
            
            for t in trans do 
               nt=[]
               nbal=0
               cod=''
               conv=Conv.find(t[3])
                if t[1]<0
                    curr=Curr.find(conv.curfr_id)
                    cod=curr.cod
                    if curr.typ=="1"
                        nbal= "%.8f" % t[1]
                    else
                        nbal=t[1]
                    end    
                else
                    curr=Curr.find(conv.curto_id)
                    cod=curr.cod
                    if curr.typ=="1"
                        nbal= "%.8f" % t[1]
                    else
                        nbal=t[1]
                    end  
                end    

                nt.push(t[0])
                nt.push(nbal)
                nt.push(t[2].strftime("%d %b %y, %H:%M"))
                nt.push(cod)
               tt.push(nt)
            end
            
            render json: {
                trans: tt,
                tkn: token,
                logged_in: true,
                status: :ok
                }
        else
            render json:{status:401}
        end

    end  
    
end
