require 'openssl'
require 'base64'

class DKIMGenerator
  attr_accessor :key_type, :bit_size, :encoded_public_key, :private_key
  
  def initialize(key_type = 'rsa', bit_size = 2048)
    self.key_type = key_type
    self.bit_size = bit_size
  end

  def generate
    case key_type
    when 'rsa'
      key = OpenSSL::PKey::RSA.new(bit_size)
    else
      raise "Unsupported key type: #{key_type}"
    end

    self.private_key = key.to_pem
    public_key = key.public_key.to_der
    self.encoded_public_key = Base64.strict_encode64(public_key)
  end

  def dns_value
    options = [
      "v=DKIM1",
      "k=#{key_type}",
      "p=#{encoded_public_key}"
    ]
    options.join('; ')
  end
end
