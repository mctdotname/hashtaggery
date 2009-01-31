require 'rubygems'
require 'httparty'

module Twitter

  module Search
    include HTTParty
    format(:json)
    base_uri('search.twitter.com')

    class << self
      def find_by_user_and_tag(user, tag)
        get("/search.json?q=from:#{user}+%23#{tag}")
      end

      def find_by_tag(tag)
        get("/search.json?q=%23#{tag}")
      end
    end
  end

  module User
    include HTTParty
    format(:json)
    base_uri('twitter.com')

    class << self
      def timeline(user)
        get("/statuses/user_timeline/#{user}.json?count=200")
      end
    end
  end

  class << self
    def extract_tags(tweets)
      tweets.inject([]) do |tags, tweet|
        tags << tweet['text'].scan(/#(\S+)/)
      end.flatten.uniq
    end
  end
end
