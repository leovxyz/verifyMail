###

Returns a copy of array with dulicates removed

###

module.exports =  (array) ->
  obj = {}
  obj[item] = item for item in array
  return (value for key, value of obj) 