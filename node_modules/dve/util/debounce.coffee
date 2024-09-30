###

Wait for 'delay' after the last call before executing fuction.
Great for limiting recalculations due to screen resizing.

###

module.exports = (delay, fn) ->
  timeout = null
  ->
    clearTimeout timeout if timeout > -1
    timeout = setTimeout fn, delay