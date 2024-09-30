###

Combine multiple arrays

###

module.exports = () ->
  arrayLengths = (arr.length for arr in arguments)
  minLength = Math.min(arrayLengths...)
  for i in [0...minLength]  # Exclusive
    arr[i] for arr in arguments
