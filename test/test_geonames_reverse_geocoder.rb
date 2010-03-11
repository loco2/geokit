require File.join(File.dirname(__FILE__), 'test_base_geocoder')

class GeonamesReverseGeocoderTest < BaseGeocoderTest #:nodoc: all
  def test_cities_in_bounds
    ne = GeoKit::LatLng.new(48.97, 2.47)
    sw = GeoKit::LatLng.new(48.79, 2.21)
    bounds = GeoKit::Bounds.new(sw, ne)

    @response = MockSuccess.new
    @response.expects(:body).returns(fixture('geonames/cities_in_bounds'))

    url = "http://ws.geonames.org/cities?north=48.97&south=48.79&east=2.47&west=2.21"
    Geokit::Geocoders::GeonamesGeocoder.expects(:call_geocoder_service).with(url).returns(@response)

    res=Geokit::Geocoders::GeonamesGeocoder.cities_in_bounds(bounds)
    assert_equal "Paris", res.city 
    assert_equal "48.85341,2.3488", res.ll
    assert !res.is_us?
    assert_equal "Paris, FR", res.full_address
    assert_equal "geonames", res.provider
  end
end
