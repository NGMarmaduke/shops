require 'json'

module Shops
  class Response
    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def results
      body['results']
    end

    def next_page_token
      body['next_page_token']
    end

    def body
      JSON.parse(response.body)
    end
  end
end