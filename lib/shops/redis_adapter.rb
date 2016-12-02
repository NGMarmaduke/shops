$redis = Redis.new(db: 1)

module Shops
  module RedisAdapter
    extend self
    QUEUE = 'grid-queue'
    DONE  = 'grid-done'
    FOUND = 'grid-found'
    RESP  = 'grid-response'

    def reset
      $redis.del(QUEUE)
      $redis.del(DONE)
      $redis.del(FOUND)
      $redis.del(RESP)
    end

    def queue_grid(grid)
      $redis.pipelined do
        grid.shuffle.each do |coord|
          $redis.rpush(QUEUE, coord.to_json)
        end
      end
    end

    def each_in_queue(&block)
      while coord = $redis.rpoplpush(QUEUE, DONE)
        coord = JSON.parse(coord)
        block.call(coord)
      end
    end

    def push_found(found)
      $redis.rpush(FOUND, found)
    end

    def push_response(key, response)
      $redis.hset(RESP, key, response)
    end

    def done?(coord)
      $redis.hexists(RESP, coord)
    end

  end
end