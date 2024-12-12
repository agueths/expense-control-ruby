# frozen_string_literal: true

class Tokenization
  include ActiveModel::Model

  # Encodes a payload into a JWT token.
  #
  # @param payload [Hash] The payload to encode.
  # @param time_now_int [Integer, nil] Time. If not provided, it will be set to the current time.
  # @return [String] The encoded JWT token.
  #
  # @raise [JWT::InvalidPayload] If the payload is not a Hash.
  #
  # @note This method generates a JWT token with an expiration time of 4 hours from the current time.
  # It also includes 'iat' (issued at) and 'jti' (JWT ID) claims in the token.
  # The 'jti' claim is generated using a MD5 hash of the secret key and the current time.
  #
  def self.encode(payload, time_now_int = Time.now.utc.to_i)
    JWT.encode(
      {
        exp: (time_now_int + 4 * 3600), # Expiration time is 4 hours from now
        iat: time_now_int, # Issued at time is the current time
        jti: Digest::MD5.hexdigest(
          [
            Rails.application.credentials[:secret_key_jwt],
            time_now_int
          ].join(':').to_s
        ), # JWT ID is a MD5 hash of the secret key and the current time
        data: payload # The payload to be encoded
      },
      Rails.application.credentials[:secret_key_jwt], # The secret key used for encoding
      'HS512' # The algorithm used for encoding
    )
  end

  # Decodes a JWT token and returns the decoded payload.
  #
  # @param token [String] The JWT token to decode.
  # @return [Hash] The decoded payload.
  #
  # @raise [JWT::ExpiredSignature] If the token has expired.
  # @raise [JWT::InvalidIatError] If the token's 'iat' claim is invalid.
  # @raise [JWT::InvalidJtiError] If the token's 'jti' claim is invalid.
  #
  # @note This method verifies the token's signature, expiration, 'iat', and 'jti' claims.
  #
  def self.decode(token)
    JWT.decode(
      token,
      Rails.application.credentials[:secret_key_jwt],
      true,
      {
        verify_iat: true,
        verify_jti: true,
        algorithm: 'HS512'
      }
    )[0]
  end
end
