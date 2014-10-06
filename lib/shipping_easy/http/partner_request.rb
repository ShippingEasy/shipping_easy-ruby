class ShippingEasy::Http::PartnerRequest < ShippingEasy::Http::Request

  def uri
    "/partners/api#{relative_path}"
  end

  def api_secret
    ShippingEasy.partner_api_secret
  end

  def api_key
    ShippingEasy.partner_api_key
  end

end
