# frozen_string_literal: true

require_relative 'sip/version'
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

    ESCAPED = RFC2396_REGEXP::PATTERN::ESCAPED
    UNRESERVED = RFC2396_REGEXP::PATTERN::UNRESERVED

    PARAM_UNRESERVED = '\[\]/:&+$'
    PARAMCHAR = "#{ESCAPED}|[#{UNRESERVED}#{PARAM_UNRESERVED}]".freeze
    PNAME = "(?:#{PARAMCHAR})+".freeze
    PVALUE = PNAME
    URI_PARAMETER_REGEX = Regexp.new(
      "(?<pname>#{PNAME})(?:=(?<pvalue>#{PVALUE}))?"
    )
    URI_PARAMETERS_REGEX = Regexp.new(
      "(?:;#{URI_PARAMETER_REGEX})*"
    )

    HNV_UNRESERVED = '\[\]/?:+$'
    HCHAR = "#{ESCAPED}|[#{UNRESERVED}#{HNV_UNRESERVED}]".freeze
    HNAME = "(?:#{HCHAR})+".freeze
    HVALUE = "(?:#{HCHAR})*".freeze
    HEADER_REGEX = Regexp.new(
      "(?<hname>#{HNAME})=(?<hvalue>#{HVALUE})"
    )
    HEADERS_REGEX = Regexp.new(
      "\\?#{HEADER_REGEX}(?:&#{HEADER_REGEX})*"
    )

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
    end
  end

  register_scheme 'SIP', SIP
end
