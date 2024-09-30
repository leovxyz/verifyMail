###

Find the closest points in a dataset.

###

module.exports = (data, f) ->
  (value) ->
    value = +value
    return [] if data.length is 0 or +f(data[0])> value or +f(data[data.length-1]) < value
    last = null
    for d in data
      fd = +f(d)
      return [d] if fd == value
      return [last, d] if value < fd
      last = d