require 'token_manager'

# Authentication handled with header: 'X-Access-Token'
class ApplicationController < ActionController::API
  attr_accessor :current_user

  private

  def authenticate_user
    token = request.headers['X-Access-Token']
    if (user_id = TokenManager.validate_token(token))
      @current_user = User.find(user_id)
    else
      head :unauthorized
      false
    end
  end
end
