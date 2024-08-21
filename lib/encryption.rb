# frozen_string_literal: true

require 'base64'

# Module for encrypting and decrypting values
module Encryption
  # extend ActiveSupport::Concern
  # Encrypts the given value using the Rails application's secret key base
  #
  # @param val [String] The value to encrypt
  # @return [String] The encrypted and Base64 encoded value
  def encrypt_value(val)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base[0..31])
    encrypted_val = crypt.encrypt_and_sign(val)
    shortened_encrypted_val = Base64.urlsafe_encode64(encrypted_val)
    shortened_encrypted_val
  end

  # Decrypts the given value using the Rails application's secret key base
  #
  # @param val [String] The value to decrypt (Base64 encoded)
  # @return [String] The decrypted value
  def decrypt_value(val)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base[0..31])
    begin
      if val.nil?
        raise "Value is nil. Cannot decrypt and verify."
      else
        # Decode the shortened Base64 value before decrypting
        encrypted_val = Base64.urlsafe_decode64(val)
        crypt.decrypt_and_verify(encrypted_val)
      end
    rescue StandardError => e
      logger.info "An error occurred: #{e.message}"
      return nil
    end
  end
end
