require File.join(File.dirname(__FILE__), 'test_base_geocoder')

class GeonamesGeocoderTest < BaseGeocoderTest #:nodoc: all
  GEONAMES_RESULT = <<-EOF.strip
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<geonames>
<totalResultsCount>76</totalResultsCount>
<code>
<postalcode>94102</postalcode>
<name>San Francisco</name>
<countryCode>US</countryCode>
<lat>37.781334</lat>
<lng>-122.416728</lng>
<adminCode1>CA</adminCode1>
<adminName1>California</adminName1>
<adminCode2>075</adminCode2>
<adminName2>San Francisco</adminName2>
<adminCode3/>
<adminName3/>
</code>
<code>
<postalcode>94103</postalcode>
<name>San Francisco</name>
<countryCode>US</countryCode>
<lat>37.77254</lat>
<lng>-122.414664</lng>
<adminCode1>CA</adminCode1>
<adminName1>California</adminName1>
<adminCode2>075</adminCode2>
<adminName2>San Francisco</adminName2>
<adminCode3/>
<adminName3/>
</code>
</geonames>
  EOF

  def geonames_escape(value)
    Geokit::Inflector.url_escape(value.to_s.gsub(/,/, ' '))
  end

  def setup
    super
  end

  def test_geonames_general_geocoding
    response = MockSuccess.new
    response.expects(:body).returns(GEONAMES_RESULT)
    url = "http://ws.geonames.org/postalCodeSearch?placename=#{geonames_escape(@address)}&maxRows=10"
    Geokit::Geocoders::GeonamesGeocoder.expects(:call_geocoder_service).with(url).returns(response)
    res=Geokit::Geocoders::GeonamesGeocoder.geocode(@address)
    assert_equal "California", res.state
    assert_equal "San Francisco", res.city 
    assert_equal "37.781334,-122.416728", res.ll
    assert res.is_us?
    assert_equal "San Francisco, California, 94102, US", res.full_address
    assert_equal "geonames", res.provider
  end
end
