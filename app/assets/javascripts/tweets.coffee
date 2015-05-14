# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(".tweets.index").ready ->
  renderLineChart()


parseDate = d3.time.format("%Y-%m-%d").parse

renderLineChart = ->

        
	gon.daily_emotion.forEach((d) ->
		d.date = parseDate(d.date))

	ndx = crossfilter(gon.daily_emotion)
	dateDim = ndx.dimension((d) ->
		d.date)
	minDate = dateDim.bottom(1)[0].date
	maxDate = dateDim.top(1)[0].date
	
	hitslineChart  = dc.lineChart("#line-chart")

	emotionDim  = ndx.dimension((d) ->
	  d.emotion)
	emotionTotal = emotionDim.group().reduceSum((d) ->
		d.count)
	emotionPieChart  = dc.pieChart("#pie-chart");

	emotions = ["anger", "anticipation", "disgust", "fear", "joy", "sadeness", "surprise", "trust"]
	emotionsCount = []



	emotions.forEach((emotion) ->
		count = dateDim.group().reduceSum((d) ->
			if d.emotion == emotion
				d.count
			else
				0)
		emotionsCount.push(count))

	emotionPieChart
    	.width(335).height(335)
    	.dimension(emotionDim )
    	.group(emotionTotal)
    	.colors(["#D40000","#FFA854","#FF54FF","#008000","#FFFF54","#5151FF",'#59BDFF','#54FF54'])
    	.innerRadius(80)
    	.legend(dc.legend().x(148).y(95).itemHeight(13).gap(5))
    	.renderLabel(false)
    	.renderTitle(false) 
		
	hitslineChart
	   .width(700).height(550)
	   .dimension(dateDim)
	   .colors(["#D40000","#FFA854","#FF54FF","#008000","#FFFF54","#5151FF",'#59BDFF','#54FF54'])
	   .group(emotionsCount[0],"anger")
	   .stack(emotionsCount[1],"anticipation")
	   .stack(emotionsCount[2],"disgust")
	   .stack(emotionsCount[3],"fear")
	   .stack(emotionsCount[4],"joy")
	   .stack(emotionsCount[5],"sadeness")
	   .stack(emotionsCount[6],'surprise')
	   .stack(emotionsCount[7],'trust')
	   .renderArea(true)
	   .x(d3.time.scale().domain([minDate,maxDate]))
	
	   .legend(dc.legend().x(50).y(10).itemHeight(13).gap(5))
	   .yAxisLabel("Emotion Counts");

	   dc.renderAll()