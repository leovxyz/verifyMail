listcomponent = require './list'

module.exports = (spec, components) ->
  list = listcomponent spec.spec, components

  odoql =
    render: (dom, state, params) ->
      list.render dom, state, params
    resize: (dimensions) ->
      list.resize dimensions
    query: (params) ->
      spec.queries
