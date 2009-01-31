require 'rubygems'
require 'sinatra'

$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'twitter'

get '/user/:user/tag/:tag' do
  tweets = Twitter.find_by_user_and_tag(params[:user], params[:tag])
  tweets['results'].map {|tweet| tweet['text']}.join('<br />')
end