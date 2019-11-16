class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(payload: { user_id: user.id }, secret_key: Rails.application.secrets.secret_key_base) if user
  end

    private
      attr_accessor :email, :password

      def user
        user = User.find_by_email(email)
        return user if user && user.authenticate(password)

        errors.add :user_authentication, "invalid credentials"
        nil
      end
end
