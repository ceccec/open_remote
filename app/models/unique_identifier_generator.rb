require "digest"

class UniqueIdentifierGenerator
  ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".freeze

  class << self
    # Generate a 22-character Base62 ID.
    # If a name is provided, the ID is deterministic for that name.
    def generate_id(name = nil)
      bytes =
        if name
          Digest::SHA256.digest(name.to_s)[0, 16]
        else
          SecureRandom.random_bytes(16)
        end

      base62_encode(bytes)
    end

    private

    def base62_encode(bytes)
      num = bytes.bytes.reduce(0) { |acc, b| (acc << 8) | b }
      return ALPHABET[0] if num.zero?

      base = ALPHABET.length
      chars = []
      while num.positive?
        chars << ALPHABET[num % base]
        num /= base
      end

      chars.reverse.join
    end
  end
end
