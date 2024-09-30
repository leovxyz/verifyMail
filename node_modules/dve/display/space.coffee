###

Create some breathing room in your visualisations.
Has a default height, or height can be specified.

- type: space
  height: 50

###

d3 = require 'd3'

module.exports = (spec, components) ->
  el = null
  space =
    render: (dom, state, params) ->
      el = d3.select dom
        .append 'div'
        .attr 'class', 'item space'
      space.resize params.dimensions

    resize: (dimensions) ->
      el
        .style 'width', "#{dimensions[0]}px"
        .style 'height', "#{spec.height or 15}px"
