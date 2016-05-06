require 'dotenv'
Dotenv.load!

require 'shops/client'
require 'shops/response'
require 'shops/grid'

module Shops
  extend self

  def fetch_closed(grid = Shops::Grid.boundry)
    client = Shops::Client.new
    results = []

    grid.shuffle.each { |location|
      lat_lon = location.join(',')

      puts "%-20s, %-20s" % location

      all = client.fetch_all(location: lat_lon)
      closed = all.select{ |place| place['permanently_closed'] }

      puts "======\nclosed: #{closed.inspect}\n======" if closed.any?

      results += closed
    }

    results
  end

end