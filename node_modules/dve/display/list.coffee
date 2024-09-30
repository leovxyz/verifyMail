###

List components.

###

module.exports = (spec, components) ->
  unless spec instanceof Array
    spec = [spec]

  items = []
  for s in spec
    unless components[s.type]?
      return console.error "#{s.type} component not found"
    item = components[s.type] s, components
    items.push item

  list =
    render: (dom, state, params) ->
      for item in items
        item.render dom, state, params
    resize: (dimensions) ->
      for item in items
        continue unless item.resize?
        item.resize dimensions
    query: (params) ->
      result = {}
      for item in items
        if item.query?
          for key, query of item.query params
            result[key] = query
      result
