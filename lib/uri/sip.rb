# frozen_string_literal: true

require_relative 'sip/version'
require_relative 'sip/rfc3261_parser'
require 'uri'

module URI # :nodoc:
  # This class describes SIP URI scheme according to RFC3261
  #
  # General form of SIP URI is "sip:user:password@host:port;uri-parameters?headers"
  #
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

    attr_reader :headers, :params

    # Create new URI::SIP object from components
    #
    def self.build(args)
      tmp = Util.make_components_hash(self, args)

      super(tmp)
    end

    def self.parse(sipuri)
      RFC3261_Parser.new.parse(sipuri)
    end

    def initialize(*args)
      super(*args)

      # SIP URIs are considered as 'opaque' by base
      # URI parser and not parsed;
      #
      # Parse them additionally there
      #
      self.class.parse("#{@scheme}:#{@opaque}")
    end
  end

  register_scheme 'SIP', SIP
end
