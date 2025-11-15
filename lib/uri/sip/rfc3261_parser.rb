# frozen_string_literal: true

module URI
  class SIP
    class RFC3261_Parser # rubocop:disable Naming/ClassAndModuleCamelCase
      ALPHA = 'a-zA-Z'
      ALNUM = "#{ALPHA}\\d".freeze
      HEX     = 'a-fA-F\\d'
      ESCAPED = "%[#{HEX}]{2}".freeze
      UNRESERVED = "\\-_.!~*'()#{ALNUM}".freeze

      PARAM_UNRESERVED = '\[\]/:&+$'
      PARAMCHAR = "#{ESCAPED}|[#{UNRESERVED}#{PARAM_UNRESERVED}]".freeze
      PNAME = "(?:#{PARAMCHAR})+".freeze
      PVALUE = PNAME
      URI_PARAMETER = "(?<pname>#{PNAME})(?:=(?<pvalue>#{PVALUE}))?".freeze
      URI_PARAMETERS = "(?:;#{URI_PARAMETER})+".freeze

      HNV_UNRESERVED = '\[\]/?:+$'
      HCHAR = "#{ESCAPED}|[#{UNRESERVED}#{HNV_UNRESERVED}]".freeze
      HNAME = "(?:#{HCHAR})+".freeze
      HVALUE = "(?:#{HCHAR})*".freeze
      HEADER = "(?<hname>#{HNAME})=(?<hvalue>#{HVALUE})".freeze
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

      IPV4ADDR = '\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}'

      HEX4 = "[#{HEX}]{1,4}".freeze
      LASTPART = "(?:#{HEX4}|#{IPV4ADDR})".freeze
      HEXSEQ1 = "(?:#{HEX4}:)*#{HEX4}".freeze
      HEXSEQ2 = "(?:#{HEX4}:)*#{LASTPART}".freeze
      IPV6ADDR = "(?:#{HEXSEQ2}|(?:#{HEXSEQ1})?::(?:#{HEXSEQ2})?)".freeze
      IPV6REF  = "\\[#{IPV6ADDR}\\]".freeze
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
