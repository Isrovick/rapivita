class AuthenticationTokenService 

HMAC_SECRET = '!SHhhh4R341_'
ALGORITHM_TYPE = 'HS256'

    def self.encode_token(user_id)
        payload = {user_id: user_id }
        JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
    end 

    def self.session_user(request,params)
        @request=request
        @params=params
        decoded_hash = decoded_token
       
        if decoded_hash && !decoded_hash.empty?
            user_id = decoded_hash[0]['user_id']
            @user = User.find_by(id: user_id)
        else
            nil
        end
    end

    def self.decoded_token
        if auth_header
                token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, HMAC_SECRET, true ,algorithm: ALGORITHM_TYPE)
            rescue JWT::DecodeError
                []
            end
        end
    end

    private

    def self.auth_header
        if @request.headers['Authorization']
            @request.headers['Authorization']
        elsif  @params[:headers]['Authorization']
                @params[:headers]['Authorization']
        else 
            nil
        end
    end 

end 