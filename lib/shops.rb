require 'json'
require 'redis'
require 'dotenv'
Dotenv.load!

require 'shops/client'
require 'shops/response'
require 'shops/grid'
require 'shops/redis_adapter'

module Shops
  extend self

  def queue_grids
    sample = Shops::Grid.hammersmith
    RedisAdapter.queue_grid(sample.grid)
  end

  def fetch_closed
    client = Shops::Client.new
    results = []

    RedisAdapter.each_in_queue { |location|
      lat_lon = location.join(',')

      puts "%-20s, %-20s" % location

      all = client.fetch_all(location: lat_lon)
      closed = all.select{ |place| place['permanently_closed'] }

      RedisAdapter.push_response(lat_lon, all.to_json)

      if closed.any?
        puts "======\nclosed: #{closed.inspect}\n======"
        closed.each{ |c| RedisAdapter.push_found(c) }
        results += closed
      end
    }
    
    results
  end



end