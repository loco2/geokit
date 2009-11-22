require File.join(File.dirname(__FILE__), 'test_base_geocoder')

class GeonamesGeocoderTest < BaseGeocoderTest #:nodoc: all
  def geonames_escape(value)
    Geokit::Inflector.url_escape(value.to_s.gsub(/,/, ' '))
  end

  def setup
    super
    @response = MockSuccess.new
  end

  def test_geonames_general_geocoding
    @response.expects(:body).returns(fixture('geonames/postal_code_search'))
    url = "http://ws.geonames.org/postalCodeSearch?placename=#{geonames_escape(@address)}&maxRows=10"
    Geokit::Geocoders::GeonamesGeocoder.expects(:call_geocoder_service).with(url).returns(@response)
    res=Geokit::Geocoders::GeonamesGeocoder.geocode(@address)
    assert_equal "California", res.state
    assert_equal "San Francisco", res.city 
    assert_equal "37.781334,-122.416728", res.ll
    assert res.is_us?
    assert_equal "San Francisco, California, 94102, US", res.full_address
    assert_equal "geonames", res.provider
  end

  def test_geonames_search
    @response.expects(:body).returns(fixture('geonames/full_text_search'))
    url = "http://ws.geonames.org/search?q=#{geonames_escape(@address)}&style=FULL&maxRows=10"
    Geokit::Geocoders::GeonamesGeocoder.expects(:call_geocoder_service).with(url).returns(@response)
    res=Geokit::Geocoders::GeonamesGeocoder.search(@address)
    assert_equal "San Francisco", res.name
    assert_equal "CA", res.state
    assert_equal "San Francisco", res.city 
    assert_equal "37.7749295,-122.4194155", res.ll
    assert res.is_us?
    assert_equal "San Francisco, CA, US", res.full_address
    assert_equal "America/Los_Angeles", res.timezone
    assert_equal "geonames", res.provider
  end

  def test_geonames_search_with_continent_restriction
    @response.expects(:body).returns(fixture('geonames/full_text_search'))
    url = "http://ws.geonames.org/search?q=#{geonames_escape(@address)}&continentCode=NA&style=FULL&maxRows=10"
    Geokit::Geocoders::GeonamesGeocoder.expects(:call_geocoder_service).with(url).returns(@response)
    res=Geokit::Geocoders::GeonamesGeocoder.search(@address, :continent => 'NA')
  end
end
