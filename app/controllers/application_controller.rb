require 'token_manager'

# Authentication handled with header: 'X-Access-Token'
class ApplicationController < ActionController::API
  attr_accessor :current_user

  private

  def authenticate_user
    token = request.headers['X-Access-Token']
    raise Exception unless (user_id = token_manager.verify(token))
    @current_user = User.find(user_id)
  rescue
    head :unauthorized
    false
  end

  def token_manager
    @_token_manager ||= TokenBuilder.from(DataToken, ExpirableToken.with(Time.now + 5.days), SignableToken)
  end
end
