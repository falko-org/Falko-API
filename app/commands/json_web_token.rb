class JsonWebToken
  class << self
    def encode(payload:, exp: 24.hours.from_now, secret_key:)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret_key)
    end

    def decode(token:, secret_key:)
      body = JWT.decode(token, secret_key)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end
