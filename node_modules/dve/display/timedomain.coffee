d3 = require 'd3'
moment = require 'timespanner'
createhub = require '../util/hub'
listcomponent = require './list'
extend = require 'extend'

module.exports = (spec, components) ->
  list = listcomponent spec.spec, components

  timedomain =
    render: (dom, state, params) ->
      data = state.data
      for d in data
        d.time = moment.utc d.time, moment.ISO_8601
      domain = d3.extent data, (d) -> d.time
      # yaml supports dates, so only parse if a string
      if spec.start?
        domain[0] = spec.start
        if typeof domain[0] is 'string'
          domain[0] = moment.spanner domain[0]
      if spec.end?
        domain[1] = spec.end
        if typeof domain[1] is 'string'
          domain[1] = moment.spanner domain[1]
      poi = null
      if moment.utc().isBetween domain[0], domain[1]
        poi = moment.utc()
      if spec.timezone?
        tz = spec.timezone
        domain[0] = domain[0].tz tz
        domain[1] = domain[1].tz tz
        for d in data
          d.time = d.time.tz tz
        poi = poi.tz tz if poi?
      hub = createhub()
      newparams = extend {}, params,
        domain: domain
        hub: hub
      list.render dom, state, newparams
      hub.emit 'poi', poi
    resize: (dimensions) ->
      list.resize dimensions
    query: (params) ->
      spec.queries
