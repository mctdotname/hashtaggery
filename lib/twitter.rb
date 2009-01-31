require 'rubygems'
require 'httparty'

module Twitter

  module Search
    include HTTParty
    format(:json)
    base_uri('search.twitter.com')

    class << self
      def find_by_user_and_tag(user, tag)
        results = get("/search.json?q=from:#{user}+%23#{tag}")
        results['results'].map {|tweet| Twitter::Tweet.new(tweet)}
      end

      def find_by_tag(tag)
        results = get("/search.json?q=%23#{tag}")
        results['results'].map {|tweet| Twitter::Tweet.new(tweet)}
      end
    end
  end

  module User
    include HTTParty
    format(:json)
    base_uri('twitter.com')

    class << self
      def timeline(user)
        tweets = get("/statuses/user_timeline/#{user}.json?count=200")
        tweets.map {|tweet| Twitter::Tweet.new(tweet)}
      end
    end
  end

  class << self
    def extract_tags(tweets)
      tweets.inject([]) do |tags, tweet|
        tags << tweet.text.scan(/#(\S+)/)
      end.flatten.uniq
    end

    def group_tweets_by_tag(tweets)
      extract_tags(tweets).inject({}) do |hash, tag|
        hash[tag] = tweets.select {|tweet| tweet.text.include?("##{tag}")}
        hash
      end
    end

  end

  class Tweet
    attr_reader(:text,
                :from_user,
                :to_user, 
                :id,
                :iso_language_code,
                :from_user_id,
                :created_at,
                :profile_image_url)

    def initialize(hash)
      @text = hash['text']
      @from_user = hash['from_user']
      @to_user = hash['to_user']
      @id = hash['id']
      @iso_language_code = hash['iso_language_code']
      @from_user_id = hash['from_user_id']
      @created_at = hash['created_at']
      @profile_image_url = hash['profile_image_url']
    end

    def twitpic_url
      if @text.match(/http:\/\/twitpic.com\/\w+/)
        $&
      end
    end

    def twitpic_thumbnail_url
      twitpic_url.sub('twitpic.com/','twitpic.com/show/thumb/') if twitpic_url
    end
  end
end
