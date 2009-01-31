require 'rubygems'
require 'sinatra'

$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'twitter'

get '/user/:user/tag/:tag' do
  tweets = Twitter::Search.find_by_user_and_tag(params[:user], params[:tag])
  tweets['results'].map {|tweet| tweet['text']}.join('<br />')
end

get '/tag/:tag' do
  tweets = Twitter::Search.find_by_tag(params[:tag])
  tweets['results'].map {|tweet| tweet['from_user'] + ': ' + tweet['text']}.join('<br />')
end

get '/user/:user' do
  tweets = Twitter::User.timeline(params[:user])
#   tweets['results'].map {|tweet| tweet['text']}.join('<br />')
  tweets.inspect
end
