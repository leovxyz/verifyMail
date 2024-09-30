###

Keep track of listeners based on id.
Great for messaging.

###

module.exports = ->
  listeners = {}
  on: (id, listener) ->
    listeners[id] = [] if !listeners[id]?
    listeners[id].push listener
  emit: (id, args...) ->
    return if !listeners[id]?
    h args... for h in listeners[id]
