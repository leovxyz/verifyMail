###

Represents an entire report.
Includes title, author and other metadata.

TODO: metadata

###

mount = require './mount'

module.exports = (spec, components) ->
  mount spec.spec, components
