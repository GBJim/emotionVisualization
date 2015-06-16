class GoldenGlobeTweetsController < ApplicationController


	def index
		if params[:q].present? 
			@tweets = gon.daily_emotion  = GoldenGlobeTweet.where(:text => /#{params[:q]}/i)
			
		else
			@tweets = GoldenGlobeTweet
			
		end

		if params[:user].present? and params[:user][:born_on].present?
			@date = Time.parse params[:user][:born_on]
		else
			@date = Time.new(2015,1,11)
		end

		gon.daily_emotion = @tweets.daily_emotion_count
		gon.daily_emotion_before = @tweets.where(:created_at => {:$lt => @date}).daily_emotion_count
		gon.daily_emotion_after = @tweets.where(:created_at => {:$gte => @date}).daily_emotion_count
		@q = @date
	end


end
