# frozen_string_literal: true

module URI
  class SIP
    class RFC3261_Parser # rubocop:disable Naming/ClassAndModuleCamelCase
      ALPHA = 'a-zA-Z'
      ALNUM = "#{ALPHA}\\d".freeze
      HEXDIGIT = '\\h'
      ESCAPED = "%#{HEXDIGIT}{2}".freeze
      UNRESERVED = "\\-_.!~*'()#{ALNUM}".freeze

      PARAM_UNRESERVED = '\[\]/:&+$'
      PARAMCHAR = "#{ESCAPED}|[#{UNRESERVED}#{PARAM_UNRESERVED}]".freeze
      PNAME = "(?:#{PARAMCHAR})+".freeze
      PVALUE = PNAME
      URI_PARAMETER = "(?:#{PNAME})(?:=#{PVALUE})?".freeze
      URI_PARAMETERS = "(?:;#{URI_PARAMETER})*".freeze

      HNV_UNRESERVED = '\[\]/?:+$'
      HCHAR = "#{ESCAPED}|[#{UNRESERVED}#{HNV_UNRESERVED}]".freeze
      HNAME = "(?:#{HCHAR})+".freeze
      HVALUE = "(?:#{HCHAR})*".freeze
      HEADER = "(?:#{HNAME})=(?:#{HVALUE})".freeze
      HEADERS = "\\?#{HEADER}(?:&#{HEADER})*".freeze

      USER_UNRESERVED = '&=+$,;?/'
      USERCHAR = "#{ESCAPED}|[#{UNRESERVED}|#{USER_UNRESERVED}]".freeze
      USER = "(?:#{USERCHAR})+".freeze
      PASSWORDCHAR = "#{ESCAPED}|[#{UNRESERVED}&=+$,]".freeze
      PASSWORD = "(?:#{PASSWORDCHAR})*".freeze
      USERINFO = "#{USER}(?::#{PASSWORD})?@".freeze

      DOMLABEL = "(?:[#{ALNUM}](?:[-#{ALNUM}]*[#{ALNUM}])?)".freeze
      TOPLABEL = "(?:[#{ALPHA}](?:[-#{ALNUM}]*[#{ALNUM}])?)".freeze
      HOSTNAME = "(?:#{DOMLABEL}\\.)*#{TOPLABEL}\\.?".freeze

      # RFC5954 corrections to the IPv6 and IPv4 ABNF rules
      #
      DEC_OCTET = '(?:[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5]|\\d)'
      IPV4ADDR = "#{DEC_OCTET}\\.#{DEC_OCTET}\\.#{DEC_OCTET}\\.#{DEC_OCTET}".freeze
      H16 = "#{HEXDIGIT}{1,4}".freeze
      LS32 = "(?:#{H16}:#{H16}|#{IPV4ADDR})".freeze
      IPV6ADDR =
        "(?:#{H16}:){6}#{LS32}" \
        "|::(?:#{H16}:){5}#{LS32}" \
        "|#{H16}?::(?:#{H16}:){4}#{LS32}" \
        "|(?:(?:#{H16}:)?#{H16})?::(?:#{H16}:){3}#{LS32}" \
        "|(?:(?:#{H16}:){,2}#{H16})?::(?:#{H16}:){2}#{LS32}" \
        "|(?:(?:#{H16}:){,3}#{H16})?::#{H16}:#{LS32}" \
        "|(?:(?:#{H16}:){,4}#{H16})?::#{LS32}" \
        "|(?:(?:#{H16}:){,5}#{H16})?::#{H16}" \
        "|(?:(?:#{H16}:){,6}#{H16})?::".freeze

      IPV6REF = "\\[#{IPV6ADDR}\\]".freeze
      HOST = "(?:#{HOSTNAME}|#{IPV4ADDR}|#{IPV6REF})".freeze

      PORT = '\d*'
      HOSTPORT = "#{HOST}(?::#{PORT})?".freeze

      SIP_URI =
        "(?<userinfo>#{USERINFO})?" \
        "(?<hostport>#{HOSTPORT})" \
        "(?<uri_parameters>#{URI_PARAMETERS})" \
        "(?<headers>#{HEADERS})?".freeze

      SIP_URI_REGEX = Regexp.new(
        "\\Asip:#{SIP_URI}\\z"
      )

      SIPS_URI_REGEX = Regexp.new(
        "\\Asips:#{SIP_URI}\\z"
      )

      def split(str)
        str.match(SIP_URI)
      end
    end
  end
end
