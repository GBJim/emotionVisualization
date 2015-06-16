# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(".oscar_tweets.index").ready ->
  renderLineChart(gon.daily_emotion)
  renderPieChart(gon.daily_emotion_before, "pie-chart-before")
  renderPieChart(gon.daily_emotion_after, "pie-chart-after")
  dc.renderAll()

parseDate = d3.time.format("%Y-%m-%d").parse

renderLineChart = ((data,elementID)->

	data.forEach((d) ->
		d.date = parseDate(d.date))

	ndx = crossfilter(data)
	dateDim = ndx.dimension((d) ->
		d.date)
	minDate = dateDim.bottom(1)[0].date
	maxDate = dateDim.top(1)[0].date

	total = dateDim.group().reduceSum((d) -> 
 		d.count)
	
	hitslineChart  = dc.lineChart("#line-chart")

	emotionDim  = ndx.dimension((d) ->
	  d.emotion)
	emotionTotal = emotionDim.group().reduceSum((d) ->
		d.count)


	emotions = ["anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust"]
	emotionsCount = []
	colorScheme = {"anger":"#D40000", "anticipation":"#FFA854", "disgust":"#FF54FF", "fear":"#008000", "joy":"#FFFF54", "sadness":"#5151FF", "surprise":'#59BDFF', "trust":'#54FF54'}
	showedEmotions = {}
	showedColors = []
	emotionTotal.top(Infinity).forEach((emotion) ->
		showedEmotions[emotion.key] = true
		)

	emotions.forEach((emotion) ->
		if emotion of showedEmotions

			showedColors.push(colorScheme[emotion])
			console.log(colorScheme[emotion])
		)


	emotions.forEach((emotion) ->
		count = dateDim.group().reduceSum((d) ->
			if d.emotion == emotion
				d.count
			else
				0)
		emotionsCount.push(count))

	emotionPieChart  = dc.pieChart("#pie-chart");
		
	hitslineChart
	   .width(1200).height(550)
	   .dimension(dateDim)
	   .ordinalColors(["#D40000","#FFA854","#FF54FF","#008000","#FFFF54","#5151FF",'#59BDFF','#54FF54'])
	   .group(emotionsCount[0],"anger")
	   .stack(emotionsCount[1],"anticipation")
	   .stack(emotionsCount[2],"disgust")
	   .stack(emotionsCount[3],"fear")
	   .stack(emotionsCount[4],"joy")
	   .stack(emotionsCount[5],"sadness")
	   .stack(emotionsCount[6],'surprise')
	   .stack(emotionsCount[7],'trust')
	   .renderArea(true)
	   .x(d3.time.scale().domain([minDate,maxDate]))
	   .y(d3.scale.linear().domain([0, total.top(1)[0].value]))
	   .legend(dc.legend().x(50).y(10).itemHeight(13).gap(5))
	   .yAxisLabel("Emotion Counts")

	emotionPieChart
	   .width(335).height(335)
	   .dimension(emotionDim )
	   .group(emotionTotal)
	   .ordinalColors(	showedColors)
	   .innerRadius(80)
	   .legend(dc.legend().x(148).y(95).itemHeight(13).gap(5))
	   .renderLabel(false)
	   .renderTitle(false) 
	)

renderPieChart = ((data,elementID)->

	

	ndx = crossfilter(data)


	emotionDim  = ndx.dimension((d) ->
	  d.emotion)
	emotionTotal = emotionDim.group().reduceSum((d) ->
		d.count)


	colorScheme = {"anger":"#D40000", "anticipation":"#FFA854", "disgust":"#FF54FF", "fear":"#008000", "joy":"#FFFF54", "sadness":"#5151FF", "surprise":'#59BDFF', "trust":'#54FF54'}
	showedEmotions = {}
	showedColors = []
	emotions = ["anger", "anticipation", "disgust", "fear", "joy", "sadness", "surprise", "trust"]
	emotionTotal.top(Infinity).forEach((emotion) ->
		showedEmotions[emotion.key] = true
		)

	emotions.forEach((emotion) ->
		if emotion of showedEmotions

			showedColors.push(colorScheme[emotion])
			console.log(colorScheme[emotion])
		)


	emotionPieChart  = dc.pieChart("#" + elementID);
	


	emotionPieChart
    	.width(335).height(335)
    	.dimension(emotionDim )
    	.group(emotionTotal)
    	.ordinalColors(	showedColors)
    	.innerRadius(80)
    	.legend(dc.legend().x(148).y(95).itemHeight(13).gap(5))
    	.renderLabel(false)
    	.renderTitle(false) 
	)

	  