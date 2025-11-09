require_relative 'sip'

module URI
  class SIPS < SIP
    DEFAULT_PORT = 5061
  end

  register_scheme 'SIPS', SIPS
end

