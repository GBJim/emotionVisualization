class TweetsController < ApplicationController
	def index
		gon.daily_emotion  = Tweet.daily_emotion_count


	end
end
