###

Plot an xy table with heatmap.

TODO: Work out how to position these xy visualisations.
TODO: Allow the different categories and values to be specified.

###

d3 = require 'd3'
colorbrewer = require 'colorbrewer'

calculate_layout = (dimensions, nRows, nCols, params) ->
  innerMargin = 
    top: 75
    right: 10
    bottom: 15
    left: 85

  if params.megaMargin
    innerMargin.left *= 2

  maxFieldWidth = 120
  minFieldWidth = 35
  containerWidth = dimensions[0]
  containerWidth = Math.min(containerWidth, maxFieldWidth*nCols + innerMargin.left + innerMargin.right)
  containerWidth = Math.max(containerWidth, minFieldWidth*nCols + innerMargin.left + innerMargin.right)

  field = 
    height: 30

  container = 
    width: containerWidth  

  inner = 
    left: innerMargin.left
    top: innerMargin.top
    width: Math.min(container.width - innerMargin.left - innerMargin.right, maxFieldWidth*nCols)
    height: field.height * nRows

  container.height = innerMargin.top + innerMargin.bottom + inner.height
  inner.bottom = inner.top + inner.height
  inner.right = inner.left + inner.width
  field.width = inner.width / nCols
  
  container: container
  inner: inner
  innerMargin: innerMargin
  field: field

module.exports = (spec, components) ->
  result =
    render: (dom, state, params) ->
      cat = state.data.bins[0].labels
      dir = state.data.bins[1].labels

      rowData = state.data.data
      globalMin = d3.min((d3.min((+x for x in v)) for k, v of rowData))
      globalMax = d3.max((d3.max((+x for x in v)) for k, v of rowData))

      nRows = rowData.length
      nCols = rowData[0].length

      if params.roundToDp?
        for row, i in rowData
          for value, j in row
            value = parseFloat(value).toFixed(params.roundToDp).toString()
            rowData[i][j] = value

      layout = calculate_layout params.dimensions, nRows, nCols, params
      field =  layout.field

      svg = d3.select dom
        .append 'svg'
        .attr 'class', 'item table'
      svg
        .attr 'width', layout.container.width
        .attr 'height', layout.container.height

      inner = svg
        .append 'g'
        .attr 'class', 'inner'
        .attr 'transform', "translate(#{layout.inner.left},#{layout.inner.top})"

      if spec.xLabel?
        inner.append 'text'
          .attr 'x', layout.inner.width / 2
          .attr 'y',  -1 * layout.innerMargin.top + 15
          .attr 'dy', '1em'
          .style 'text-anchor', 'middle'
          .text spec.xLabel + if spec.xUnits then " [#{state.data.bins[1].units}]" else ''

      if spec.yLabel?
        inner.append 'text'
          .attr 'text-anchor', 'middle'
          .attr 'x', (-1 * layout.inner.height / 2)
          .attr 'y', -1 * layout.innerMargin.left + 15
          .attr 'dy', '1em'
          .attr 'transform', 'rotate(-90)'
          .text spec.yLabel + if spec.yUnits then " [#{state.data.bins[0].units}]" else ''

      container =  inner
        .append 'g'
        .attr 'class', 'container'



      rowsGrp = container
        .append 'g'
        .attr 'class', 'rowsGrp'
        .attr 'transform', "translate(#{field.width*0.5}, 0)"

      colorScale = d3.scale.quantize()
        .range colorbrewer.Blues[9]
        .domain [globalMin, globalMax]
      textcolorScale = d3.scale.quantize()
        .range ["#000000", "#000000", "#000000", "#ffffff", "#ffffff"]
        .domain [globalMin, globalMax]

      if params.disableColoring
        colorScale = d3.scale.quantize()
          .range ["#fff"]
          .domain [globalMin, globalMax]
        textcolorScale = d3.scale.quantize()
          .range ["#000"]
          .domain [globalMin, globalMax]


      topheaderGrp = container
        .append 'g'
        .attr 'class', 'topheaderGrp'
      topheader = topheaderGrp
        .selectAll 'g'
        .data dir
        .enter()
        .append 'g'
        .attr 'class', 'header top'
        .attr 'transform', (d, i) -> "translate(#{(i)*field.width}, #{-1 * field.height})"
      topheader.append 'rect'
        .attr 'width', field.width - 1
        .attr 'height', field.height
      topheader.append 'text'
        .attr 'x', field.width/2
        .attr 'y', field.height/2
        .attr 'dy', '0.35em'
        .text String

      headerWidth = 35
      if params.megaMargin
        headerWidth = layout.innerMargin.left - 15
      sideheaderGrp = container
        .append 'g'
        .attr 'class', 'sideheaderGrp'
      sideheader = sideheaderGrp
        .selectAll 'g'
        .data cat
        .enter()
        .append 'g'
        .attr 'class', 'header side'
        .attr 'transform', (d, i) -> "translate(#{-1 * headerWidth}, #{(i)*(field.height)})"
      sideheader.append 'rect'
        .attr 'width', headerWidth - 2
        .attr 'height', field.height
      sideheader.append 'text'
        .attr 'x', 0
        .attr 'y', field.height/2
        .attr 'dy', '0.35em'
        .text String

      row = rowsGrp
        .selectAll 'g.row'
        .data rowData
      row
        .enter()
        .append 'g'
        .attr 'class', 'row'
        .attr 'transform', (d, i) -> "translate(0, #{i*field.height})"

      cells = row.selectAll 'g.cell'
        .data (d) -> d
      
      cellsEnter = cells
        .enter()
        .append 'g'
        .attr 'class', 'cell'
        .attr 'transform', (d, i) -> "translate(#{i*field.width-field.width/2}, 0)"
      cellsEnter
        .append 'rect'
        .attr 'width', field.width
        .attr 'height', field.height
        .style 'fill', colorScale
      cellsEnter
        .append 'text'
        .attr 'x', field.width/2
        .attr 'y', field.height/2
        .attr 'dy', '0.35em'
        .text String
        .style 'fill', textcolorScale
