module OpenRemote
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0

    STRING = [ MAJOR, MINOR, PATCH ].join(".")
  end

  # Public version constant for the gem/engine
  VERSION = Version::STRING
end
