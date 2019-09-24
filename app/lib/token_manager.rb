require 'json'

class TokenManager
  def self.generate_token(user_id)
    raise ArgumentError unless user_id

    sign(build_token(user_id))
  end

  def self.validate_token(access_token)
    # Validate this is the token I signed
    return false unless validate_signature(access_token)

    info = parse_token(access_token)

    # Validate the token has not expired
    return false unless 1.day.ago < info.created_at

    info.user_id
  rescue
    raise ActionController::BadRequest
  end

  private

  # Building

  def self.build_token(user_id)
    Base64.strict_encode64("#{user_id}:#{Time.now.to_i}")
  end

  def self.parse_token(access_token)
    token, _signature = access_token.split('.')
    user_id, created_at = Base64.decode64(token).split(':')
    OpenStruct.new(
      user_id: user_id,
      created_at: Time.at(created_at.to_i)
    )
  end

  # Signing

  def self.sign(token)
    sig = compute_signature(token)
    "#{token}.#{sig}"
  end

  def self.validate_signature(access_token)
    token, signature = access_token.split('.')
    ActiveSupport::SecurityUtils.secure_compare(signature, compute_signature(token))
  end

  def self.compute_signature(token)
    OpenSSL::HMAC.hexdigest(
      'sha1',
      Todo::Application.credentials.secret_key_base,
      token
    )
  end
end