require 'faraday'

module Shops
  class Client
    GMAPS_DOMAIN = 'https://maps.googleapis.com'
    GMAPS_PLACES = '/maps/api/place/nearbysearch/json'

    def fetch_all(params={})
      params = default_params.merge(params)
      results = []

      begin
        response = fetch_page(params)
        results.concat(response.results)

        params = base_params.merge({ pagetoken: response.next_page_token })
      end while response.next_page_token && response.next_page_token != ''

      results
    end

    def fetch_page(params)
      Response.new(client.get(GMAPS_PLACES, params))
    end

    private

    def default_params
      base_params.merge({
        radius: 100,
        types: INTERESTING_PLACES.join('|')
      })
    end

    def base_params
      {
        key: ENV['GMAPS_KEY']
      }
    end

    def client
      Faraday.new(:url => GMAPS_DOMAIN) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        # faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end

  INTERESTING_PLACES = [
    'accounting',
    'airport',
    'amusement_park',
    'aquarium',
    'art_gallery',
    'bakery',
    'bank',
    'bar',
    'beauty_salon',
    'bicycle_store',
    'book_store',
    'bowling_alley',
    'cafe',
    'car_dealer',
    'car_rental',
    'car_repair',
    'car_wash',
    'casino',
    'church',
    'city_hall',
    'clothing_store',
    'convenience_store',
    'courthouse',
    'dentist',
    'department_store',
    'doctor',
    'electrician',
    'electronics_store',
    'embassy',
    'establishment',
    'finance',
    'fire_station',
    'florist',
    'food',
    'funeral_home',
    'furniture_store',
    'gas_station',
    'general_contractor',
    'grocery_or_supermarket',
    'gym',
    'hair_care',
    'hardware_store',
    'health',
    'home_goods_store',
    'hospital',
    'insurance_agency',
    'jewelry_store',
    'laundry',
    'lawyer',
    'library',
    'liquor_store',
    'local_government_office',
    'locksmith',
    'lodging',
    'meal_delivery',
    'meal_takeaway',
    'movie_rental',
    'movie_theater',
    'moving_company',
    'museum',
    'night_club',
    'painter',
    'park',
    'parking',
    'pet_store',
    'pharmacy',
    'physiotherapist',
    'plumber',
    'police',
    'post_office',
    'real_estate_agency',
    'restaurant',
    'roofing_contractor',
    'rv_park',
    'school',
    'shoe_store',
    'shopping_mall',
    'spa',
    'stadium',
    'storage',
    'store',
    'subway_station',
    'train_station',
    'transit_station',
    'travel_agency',
    'veterinary_care',
  ]
end