class UsersController < ApplicationController
  

    def create
        user = User.create(user_params)
        if user
            session[:user_id] = user.id
            render json: user, status: :created
        elsif user.password != user.password_confirmation
            render json: {error:user.errors.full_messages}, status: :unprocessable_entity
        else
            render json: {error:user.errors.full_messages}, status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json:{error:"Not authorized"}, status: :unauthorized
        end
        
    end

    def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end

    private
    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end
end
