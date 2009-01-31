require 'rubygems'
require 'httparty'

module Twitter
  include HTTParty
  base_uri('search.twitter.com')
  format(:json)

  class << self
    def find_by_user_and_tag(user, tag)
      get("/search.json?q=from:#{user}+%23#{tag}")
    end
  end
end
