include Mongo
def tweet_transform(tweet)
	new_tweet = {}
	new_tweet["id"] = tweet["id"]
	new_tweet["text"] = tweet["text"]
	new_tweet["user_id"] = tweet["user"]["id"]
	new_tweet["emotion"] = tweet["emotion"]["groups"][0]["name"]
	new_tweet["created_at"] = time.parse(tweet["created_at"])
	new_tweet["lang"] = tweet["lang"]
	new_tweet["lon"] = tweet["coordinates"][0]
	new_tweet["lat"] = tweet["coordinates"][1]
	new_tweet["country_code"] = tweet["place"]["country_code"]
	new_tweet
end




mongo_client = Mongo::Connection.new("localhost", 27017)
coll = mongo_client['idea']['emotion']
insert_coll = mongo_client['emotion_visualization_development']['tweet22']


bulk = insert_coll.initialize_ordered_bulk_op

coll.each do |tweet|
bulk.insert(tweet_transform(tweet))
p bulk.execute
end

