require "mongo"
require "date"
require 'time'
include Mongo
def tweet_transform(tweet)
	new_tweet = {}
	new_tweet["id"] = tweet["id"]
	new_tweet["text"] = tweet["text"]
	new_tweet["user_id"] = tweet["user"]["id"]
	new_tweet["emotion"] = tweet["emotion"]["groups"][0]["name"]
	new_tweet["created_at"] = Time.parse(tweet["created_at"])
	new_tweet["lang"] = tweet["lang"]
	new_tweet["lon"] = tweet["coordinates"]["coordinates"][0]
	new_tweet["lat"] = tweet["coordinates"]["coordinates"][1]
	new_tweet["country_code"] = tweet["place"]["country_code"]
	new_tweet
end




mongo_client = MongoClient.new("localhost", 27017)
coll = mongo_client['idea']['emotion']
insert_coll = mongo_client['emotion_visualization_development']['tweets']



bulk = insert_coll.initialize_ordered_bulk_op
tweetCounter = 0
coll.find.each do |tweet|
	begin
		document = tweet_transform(tweet)
		bulk.insert(document)
		tweetCounter += 1

		
		
	rescue
	end

	if tweetCounter > 100000
		puts document
		p bulk.execute
		bulk = insert_coll.initialize_ordered_bulk_op
		tweetCounter = 0
	end

end

p bulk.execute