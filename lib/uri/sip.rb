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

    def initialize(*args)
      super(*args)

      @params = []
      @headers = []

      parse_params(@opaque)
      parse_headers(@opaque)
    end

    def parse_params(str)
      params_idx = str.index(URI_PARAMETERS_REGEX)
      headers_idx = str.index(HEADERS_REGEX)
      return unless params_idx

      headers_idx ||= -1
      @params = str[params_idx..headers_idx].scan(URI_PARAMETER_REGEX).to_h
    end

    def parse_headers(str)
    end
  end

  register_scheme 'SIP', SIP
end
