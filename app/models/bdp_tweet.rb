class BDPTweet

	include Mongoid::Document
	field :id, type: Integer
	field :text, type: String
	field :user_id, type: Integer
	field :emotion, type: String
	field :created_at, type: Time
	field :lang, type: String

	def self.emotion_count
		map = %Q{
			function() {
				emit(this.emotion, {count: 1})
			}
		}

		reduce = %Q{
			function(key, values){
				var result = {count: 0}
				values.forEach(function(value){
					result.count += value.count;
				});
				return result; 

			}
		}	
	

		Hash[self.map_reduce(map, reduce).out(inline: true).collect {|v| [v["_id"], v["value"]["count"].to_i]  }]
			
	end



	def self.daily_emotion_count(ratio=false, percent = true,dcjs_format = true)
		map = %Q{
			function() {
				emit([this.created_at.toLocaleDateString(),this.emotion], {count: 1})
			}
		}

		reduce = %Q{
			function(key, values){
				var result = {count: 0}
				values.forEach(function(value){
					result.count += value.count;
				});
				return result; 

			}
		}	
		result = {}
		sum_by_day = {}
		dcjs_result = [] if dcjs_format
		self.map_reduce(map, reduce).out(inline: true).each do |v|
			date = Date.parse(v['_id'][0])
			emotion = v['_id'][1]
			count = v['value']["count"].to_i

			if result.has_key? date
				result[date][emotion] = count
				sum_by_day[date] += count
			else
				result[date] = {emotion => count}
				sum_by_day[date] = count.to_f
			end
			dcjs_result.push({date: date.to_s, emotion: emotion, count: count}) if dcjs_format
		
		end
		
		if ratio
			dcjs_result = [] if dcjs_format
			result.each do |date, emotions|
				emotions.each do |emotion,count|
					result[date][emotion] /= sum_by_day[date]
					result[date][emotion] *= 100 if percent
					dcjs_result.push({date:date.to_s, emotion: emotion, count: result[date][emotion]}) if dcjs_format
				end
			end
		end

		dcjs_format ? dcjs_result : result


	end



	



end