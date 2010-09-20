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

  def test_find_nearby
    latlng = GeoKit::LatLng.new(47.3, 9)

    @response = MockSuccess.new
    @response.expects(:body).returns(fixture('geonames/find_nearby'))

    url = "http://ws.geonames.org/findNearby?lat=47.3&lng=9&radius=10&featureClass=P&style=FULL&maxRows=1"

    Geokit::Geocoders::GeonamesGeocoder.expects(:call_geocoder_service).with(url).returns(@response)

    res=Geokit::Geocoders::GeonamesGeocoder.find_nearby(latlng, {:radius => 10, :feature_class => 'P'})
    assert_equal "Atzmännig", res.city
    assert_equal "47.28763,8.98845", res.ll
    assert !res.is_us?
    assert_equal "Atzmännig, SG, CH", res.full_address
    assert_equal "geonames", res.provider
    assert_equal "6559633", res.provider_id
  end
end
