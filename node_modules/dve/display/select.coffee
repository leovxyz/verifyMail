listcomponent = require './list'
extend = require 'extend'

module.exports = (spec, components) ->
  list = listcomponent spec.spec, components

  select =
    render: (dom, state, params) ->
      data = state[spec.dataset]
      state = extend {}, state, data: data
      list.render dom, state, params
    resize: (dimensions) ->
      list.resize dimensions
    query: (params) ->
      list.query params
