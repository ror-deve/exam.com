class DnsVerifier
  def verify(type, host, expected_value)
    begin
      send("verify_" + type, host, expected_value)
    rescue NoMethodError => e
      return {error: "unsupported record type: " + type}
    rescue Resolv::ResolvError => e
      return {error: e.message}
    end
  end

  def verify_cname(host, expected_value)
    r = Resolv::DNS.open do |dns|
      dns.getresource(host, Resolv::DNS::Resource::IN::CNAME)
    end
    if r.name.to_s == expected_value
      {success: true}
    else
      {error: "DNS value did not match. Expected #{expected_value} but found #{r.name.to_s}"}
    end
  end

  def verify_txt(host, expected_value)
    r = Resolv::DNS.open do |dns|
      dns.getresource(host, Resolv::DNS::Resource::IN::TXT)
    end

    # for DKIM keys with larger size like 2048 bit, 
    # TXT values get splitted as DNS has a limit of 255 character
    if host.include?("_domainkey")
      return {success: true} if r.strings.join("") == expected_value
    end

    r.strings.each do |str_val|
      if str_val == expected_value
        return {success: true}
      end
    end
    {error: "No TXT record found with value: " + expected_value}
  end

  def verify_mx(host, expected_value)
    r = Resolv::DNS.open do |dns|
      dns.getresource(host, Resolv::DNS::Resource::IN::MX)
    end
    if r.exchange.to_s == expected_value
      {success: true}
    else
      {error: "DNS value did not match. Expected #{expected_value} but found #{r.exchange.to_s}"}
    end
  end

  def get_resource_type(type)
    case type.to_s
    when "cname"
      return Resolv::DNS::Resource::IN::CNAME
    when "txt"
      return Resolv::DNS::Resource::IN::TXT
    when "mx"
      return Resolv::DNS::Resource::IN::MX
    else
      raise "unsupported DNS record type"
    end
  end
end
