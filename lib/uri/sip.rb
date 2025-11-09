# frozen_string_literal: true

require_relative 'sip/version'
require 'uri'

module URI
  class SIP < Generic
    DEFAULT_PORT = 5060
    COMPONENT = %i[
      scheme
      userinfo
      host
      port
      params
      headers
    ].freeze

    # Create new URI::SIP object from components
    #
    def self.build(args)
      tmp = Util.make_components_hash(self, args)
      super(tmp)
    end
  end

  register_scheme 'SIP', SIP
end
