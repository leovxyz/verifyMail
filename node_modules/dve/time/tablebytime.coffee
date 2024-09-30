###

Show a cell heatmap of cells of data on a timeline.
Great for visually seeing highlights.

TODO: Add poi.

###

d3 = require 'd3'
colorbrewer = require 'colorbrewer'

calculate_layout = (dimensions) ->
  dimensions =
    width: dimensions[0]
    height: 30

  info =
    top: 0
    right: 0
    bottom: 0
    left: 200

  title =
    top: 0
    right: dimensions.width - info.left
    bottom: 0
    left: 0
    height: dimensions.height
    width: info.left

  canvas =
    top: info.top
    right: info.right
    bottom: info.bottom
    left: info.left
    width: dimensions.width - info.left - info.right
    height: dimensions.height - info.top - info.bottom

  dimensions: dimensions
  info: info
  title: title
  canvas: canvas

module.exports = (spec, components) ->
  svg = null
  data = null
  filteredData = null
  cells = null
  cellsEnter = null
  container = null
  scale = null
  field = null
  colorScale = null
  textcolorScale = null

  create_cells = ->
    bisector = d3.bisector((d) -> d.time).left
    data = scale
      .ticks d3.time.hour, 3
      .map (d) ->
        index = bisector filteredData, d
        filteredData[index]
      .filter (d) -> d?

    cells = container
      .selectAll 'g.cell'
      .data data

    cellsEnter = cells
      .enter()
      .append 'g'
      .attr 'class', 'cell'
      .attr 'class', (d) ->
        hour = d.time.local().get('hour')
        if hour % 12 is 0
          'cell priority1'
        else if hour % 6 is 0
          'cell priority2'
        else if hour % 3 is 0
          'cell priority3'

    cellsEnter
      .append 'rect'
      .attr 'height', field.height - 1
      .style 'fill', (d) ->  colorScale d[spec.field]

    cellsEnter
      .append 'text'
      .attr 'y', field.height/2
      .attr 'dy', '0.35em'
      .text (d) -> d[spec.field]
      .style 'fill', (d) -> textcolorScale d[spec.field]

  results =
    render: (dom, state, params) ->
      layout = calculate_layout params.dimensions

      svg = d3.select dom
        .append 'svg'
        .attr 'class', 'item tablebytime'

      data = state.data.map (d) ->
        result = time: d.time
        result[spec.field] = +d[spec.field]
        result

      filteredData = data.filter (d) ->
        +d.time >= +params.domain[0] and +d.time <= +params.domain[1]

      scale = d3.time.scale().domain params.domain
        .range [0, layout.canvas.width]

      # need to make these equal to the longest string in the data set
      field =
        height: 30
        width: 0

      dataDom = [(d3.min filteredData, (d)-> d[spec.field]), (d3.max filteredData, (d) -> d[spec.field])]

      colorScale = d3.scale.quantize()
        .range(colorbrewer.Blues[9])
        .domain dataDom   #scale decided by value extremes, maybe should be set values for different data types?

      textcolorScale = d3.scale.quantize()
        .range(["#000000", "#000000", "#ffffff", "#ffffff"])
        .domain dataDom

      # colorScale = d3.scale.quantize()
      #   .range(colorbrewer.Blues[9])
      #   .domain [0, 360]

      svg
        .append 'g'
        .attr 'class', 'title'
        .attr 'transform', "translate(#{layout.title.left},#{layout.title.top})"
        .append 'text'
        .attr 'class', 'infotext'
        .text spec.text
        .attr 'dy', 18

      inner = svg
        .append 'g'
        .attr 'class', 'inner'
        .attr 'transform', "translate(#{layout.canvas.left},#{layout.canvas.top})"

      inner
        .append 'line'
        .attr 'class', 'divider'
        .attr 'x1', 0
        .attr 'x2', 0
        .attr 'y1', 0
        .attr 'y2', layout.dimensions.height

      container =  inner
        .append 'g'
        .attr 'class', 'container'

      cells = null

      create_cells()

      results.resize params.dimensions

    resize: (dimensions) ->
      layout = calculate_layout dimensions

      svg
        .attr 'width', layout.dimensions.width
        .attr 'height', layout.dimensions.height

      scale.range [0, layout.canvas.width]

      bisector = d3.bisector((d) -> d.time).left

      data = scale
        .ticks d3.time.hour, 3
        .map (d) ->
          index = bisector filteredData, d
          filteredData[index]
        .filter (d) -> d?

      p1 = container.selectAll '.priority1'
      p2 = container.selectAll '.priority2'
      p3 = container.selectAll '.priority3'

      minLabelWidth = 31
      p1widths = p1[0].length * minLabelWidth
      p2widths = p2[0].length * minLabelWidth
      p3widths = p3[0].length * minLabelWidth
      switch
        when p1widths + p2widths + p3widths <= layout.canvas.width
          p2.attr 'display', 'inline'
          p3.attr 'display', 'inline'
          field.width = layout.canvas.width / (p1[0].length + p2[0].length + p3[0].length)
        when p1widths + p2widths <= layout.canvas.width
          p2.attr 'display', 'inline'
          p3.attr 'display', 'none'
          field.width = layout.canvas.width / (p1[0].length + p2[0].length)
        when p1widths <= layout.canvas.width
          p3.attr 'display', 'none'
          p2.attr 'display', 'none'
          field.width = layout.canvas.width / p1[0].length

      cells = container
        .selectAll 'g.cell'
        .data data

      cells
        .attr 'transform', (d) -> "translate(#{scale(d.time) - field.width/2}, 0)"

      container.selectAll '.cell rect'
        .attr 'width', field.width - 1

      container.selectAll '.cell text'
        .attr 'x', field.width/2
