require 'attire'
require 'rack/utils'
require 'openssl'

class GHSecretChecker
  attire 'secret, body, gh_signature', verb: :check

  def check
    !secret || body && gh_signature && compare || fail(SignatureError)
  end

  private

  def compare
    Rack::Utils.secure_compare(signature, gh_signature)
  end

  def signature
    'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, body)
  end
end

class SignatureError < StandardError; end
