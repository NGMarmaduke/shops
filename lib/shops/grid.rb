module Shops
  class Grid
    # Earth’s radius, sphere
    R = 6378137.0

    attr_reader :min_lat, :max_lat, :max_lon, :min_lon

    def self.holborn
      new(
        min_lat: 51.515786,
        max_lat: 51.518910,
        max_lon: -0.114668,
        min_lon: -0.123980,
      )
    end

    def self.hammersmith
      new(
        min_lat: 51.492625,
        max_lat: 51.500693,
        max_lon: -0.204647,
        min_lon: -0.242155,
      )
    end

    def initialize(min_lat:, max_lat:, max_lon:, min_lon:)
      @min_lat = min_lat
      @max_lat = max_lat
      @max_lon = max_lon
      @min_lon = min_lon
    end

    def coords
      grid.map{ |coord| coord.join(',') }
    end

    def grid
      @grid ||= generate_grid
    end

    def generate_grid
      base_lons = [[min_lat, min_lon]]
      all_lat_lons = []

      loop do
        base_lons << increment_lat_lon(base_lons.last, north: 0, east: 170)
        break if base_lons.last[1] > max_lon
      end

      base_lons.each do |base|
        lats = [base]

        loop do
          lats << increment_lat_lon(lats.last, north: 170, east: 0)
          break if lats.last[0] > max_lat
        end

        all_lat_lons += lats
      end

      all_lat_lons
    end


    def increment_lat_lon(lat_lon, north:, east:)
     lat = lat_lon[0]
     lon = lat_lon[1]

     #offsets in meters
     dn = north
     de = east

     #Coordinate offsets in radians
     dLat = dn / R
     dLon = de / (R * Math.cos(Math::PI * lat / 180))

     #OffsetPosition, decimal degrees
     latO = lat + dLat * 180 / Math::PI
     lonO = lon + dLon * 180 / Math::PI

     [latO, lonO]
    end
  end
end