class WSF_BARCHART_CONTROL extends WSF_CONTROL
	requirements: ['/assets/d3.min.js', '/assets/graph.css']

	attach_events: ()->
		super
		margin =
			top: 20
			right: 20
			bottom: 30
			left: 40

		data = @state.data
		console.log @state
		#Clear
		@$el.html("")
		#Calculate width
		width = @$el.width() - margin.left - margin.right
		height = 500 - margin.top - margin.bottom
		#Create axis
		x = d3.scale.ordinal().rangeRoundBands([
			0
			width
		], .1)
		y = d3.scale.linear().range([
			height
			0
		])
		xAxis = d3.svg.axis().scale(x).orient("bottom")
		yAxis = d3.svg.axis().scale(y).orient("left").ticks(10)
		svg = d3.select(@$el[0]).append("svg")
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
			.attr("transform", "translate(" + margin.left + "," + margin.top + ")")
		x.domain data.map((d) ->
			d.key
		)
		y.domain [
			0
			d3.max(data, (d) ->
				d.value
			)
		]

		svg.append("g")
			.attr("class", "x axis")
			.attr("transform", "translate(0," + height + ")")
			.call xAxis

		svg.append("g")
			.attr("class", "y axis")
			.call(yAxis)

		svg.selectAll(".bar")
			.data(data).enter()
				.append("rect")
					.attr("class", "bar")
					.attr("x", (d) ->
						x d.key
					)
					.attr("width", x.rangeBand())
					.attr("y", (d) ->
						y d.value
					)
					.attr "height", (d) ->
						height - y(d.value)