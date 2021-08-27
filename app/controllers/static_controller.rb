class StaticController < ApplicationController
    def home
        render json: {status:"Home Ok"}
    end 
end
