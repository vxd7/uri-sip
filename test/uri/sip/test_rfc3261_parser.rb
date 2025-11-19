# frozen_string_literal: true

require 'test_helper'

class URI::SIP::TestRFC3261_Parser < Minitest::Test
  def parser
    @parser ||= URI::SIP::RFC3261_Parser.new
  end

  def parse(uri)
    scheme, userinfo, host, port, uri_parameters, headers = parser.split(uri)

    {
      scheme: scheme,
      userinfo: userinfo,
      host: host,
      port: port,
      uri_parameters: uri_parameters,
      headers: headers
    }
  end

  def test_sip_scheme
    parsed = parse('sip:example.com')

    assert_equal('sip', parsed[:scheme])
  end

  def test_sips_scheme
    parsed = parse('sips:example.com')

    assert_equal('sips', parsed[:scheme])
  end

  def test_sip_uri_with_hostname
    hostname = 'example.com'
    parsed = parse("sip:#{hostname}")

    assert_equal(hostname, parsed[:host])
  end

  def test_sip_uri_with_ipv4
    hostname = '127.0.0.1'
    parsed = parse("sip:#{hostname}")

    assert_equal(hostname, parsed[:host])
  end

  def test_sip_uri_with_ipv6
    hostname = '[::ffff:c000:280]'
    parsed = parse("sip:#{hostname}")

    assert_equal(hostname, parsed[:host])
  end

  def test_sip_uri_with_hostname_and_port
    hostname = 'example.com'
    port = rand(0...65_536)
    parsed = parse("sip:#{hostname}:#{port}")

    assert_equal(hostname, parsed[:host])
    assert_equal(port.to_s, parsed[:port])
  end

  def test_sip_uri_with_ipv4_and_port
    hostname = '127.0.0.1'
    port = rand(0...65_536)
    parsed = parse("sip:#{hostname}:#{port}")

    assert_equal(hostname, parsed[:host])
    assert_equal(port.to_s, parsed[:port])
  end

  def test_sip_uri_with_ipv6_and_port
    hostname = '[::ffff:192.0.2.128]'
    port = rand(0...65_536)
    parsed = parse("sip:#{hostname}:#{port}")

    assert_equal(hostname, parsed[:host])
    assert_equal(port.to_s, parsed[:port])
  end
end
