class GenerateVerifyToken
  prepend SimpleCommand

  def initialize(user_id)
    @user_id = user_id
  end

  def call
    JsonWebToken.encode(payload: { user_id: @user_id }, secret_key: Rails.application.secrets.secret_key_email)
  end
end
