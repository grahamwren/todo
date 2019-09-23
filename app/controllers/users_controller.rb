class UsersController < ApplicationController
  before_action :authenticate_user, except: :login

  def login
    email, password = params.values_at :email, :password
    if (user = User.find_by_email(email)&.authenticate(password))
      render json: {
        user_id: user.id,
        access_token: TokenManager.generate_token(user.id)
      }, status: 201
    else
      render status: :unauthorized
    end
  end

  def show
    if current_user.id == params[:id]
      render json: current_user
    else
      render status: :forbidden
    end
  end
end
