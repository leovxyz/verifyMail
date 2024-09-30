###

Mount a component or group of components into the dom.
Keep them resized based on window resize events.

###

d3 = require 'd3'
domdimensions = require '../util/domdimensions'
debounce = require '../util/debounce'
extend = require 'extend'
listcomponent = require './list'

module.exports = (spec, components) ->
  list = listcomponent spec, components

  mount =
    render: (dom, state, params) ->
      params = extend {}, params,
        dimensions: domdimensions dom

      list.render dom, state, params

      namespacedListener = 'resize' + '.' + params.id

      d3
        .select window
        .on namespacedListener, debounce 125, ->
          dimensions = domdimensions dom

          if isNaN(dimensions[0]) or isNaN(dimensions[1])
            console.error 'Not resizing, element has invalid dimensions'
            return

          params.dimensions = dimensions
          dom.innerHTML = ''
          list.render dom, state, params

      # hack to take into account the vertical scrollbar if our content extends past the bottom
      setTimeout(->
        dimensions = domdimensions dom

        if isNaN(dimensions[0]) or isNaN(dimensions[1])
          console.error 'Not resizing, element has invalid dimensions'
          return

        params.dimensions = dimensions
        dom.innerHTML = ''
        list.render dom, state, params
      , 500)

    resize: (dimensions) ->
      list.resize dimensions
    query: (params) ->
      list.query params
