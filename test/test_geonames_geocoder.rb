require File.join(File.dirname(__FILE__), 'test_base_geocoder')

class GeonamesGeocoderTest < BaseGeocoderTest #:nodoc: all
  GEONAMES_RESULT = fixture('geonames')

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

  def test_geonames_search
    response = MockSuccess.new
    response.expects(:body).returns(GEONAMES_SEARCH_RESULT)
    url = "http://ws.geonames.org/search?q=#{geonames_escape(@address)}&style=FULL&maxRows=10"
    Geokit::Geocoders::GeonamesGeocoder.expects(:call_geocoder_service).with(url).returns(response)
    res=Geokit::Geocoders::GeonamesGeocoder.search(@address)
    assert_equal "CA", res.state
    assert_equal "San Francisco", res.city 
    assert_equal "37.7749295,-122.4194155", res.ll
    assert res.is_us?
    assert_equal "San Francisco, CA, US", res.full_address
    assert_equal "geonames", res.provider
  end
end
