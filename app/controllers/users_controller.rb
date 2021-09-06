class UsersController < ApplicationController
    before_action :authorize , only: [:show]
    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user,only:[:id,:username,:image_url,:bio], status: :created
            
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json: { error: "Not authorized" }, status: :unauthorized
        end
    end

    private

    def user_params
        params.permit(:username,:image_url,:bio, :password, :password_confirmation)
    end

    def authorize
        user = User.find_by(id: session[:user_id])
    
        render json: { errors: ["Not authorized"] }, status: :unauthorized unless user
    end
    
end
