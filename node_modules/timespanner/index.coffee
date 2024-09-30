bind = (root, factory) ->
  if typeof(define) is 'function' and define.amd?
    define(['moment'], factory)
  else if typeof(exports) is 'object'
    module.exports = factory require 'moment-timezone'
  else
    factory root.moment

isNumber = (n) -> n >= '0' and n <= '9'
isAlpha = (n) -> n >= 'a' and n <= 'z'
isOperation = (n) -> n is '/' or n is '+' or n is '-' or n is '('
isTimezone = (n) -> isAlpha(n) or n >= 'A' and n <= 'Z' or n is '_' or n is '/'

bind @, (moment) ->
  return moment if moment.spanner?

  spanner = (anchor, tz, s, vars) ->
    # current position in string
    i = 0

    readalpha = ->
      n = 0
      n++ while i + n < s.length and isAlpha s[i+n]
      res = s.substr i, n
      i += n
      res

    readnumber = ->
      n = 0
      n++ while i + n < s.length and isNumber s[i+n]
      res = s.substr i, n
      i += n
      res

    readtimezone = ->
      n = 0
      n++ while i + n < s.length and isTimezone s[i+n]
      res = s.substr i, n
      i += n
      res

    readduration = ->
      value = readnumber()
      value = 1 if value is ''
      shorthand = readalpha()
      moment.duration +value, shorthand

    # could start with a timezone
    if i < s.length and s[i] is '('
      i++
      tz = readtimezone()
      #console.log "use #{tz}"
      if s[i] isnt ')'
        throw new Error 'Expecting closing ) on timezone'
      i++

    # could start with 'now' or another variable
    if i < s.length and isAlpha s[i]
      variable = readalpha()
      if variable isnt 'now' # now is the default
        if !vars? or !vars[variable]?
          throw new Error "Variable #{variable} not known"
        f = vars[variable]
        f = f tz if typeof f is 'function'
        anchor = f

    anchor = anchor.tz tz if tz?
    #console.log "Starting with #{anchor.toString()}"

    while i < s.length and isOperation s[i]
      if s[i] is '/'
        i++
        shorthand = readalpha()
        #console.log "round #{shorthand}"
        anchor = anchor.startOf shorthand
      else if s[i] is '+'
        i++
        while i < s.length
          duration = readduration()
          #console.log "add #{duration.toString()}"
          anchor = anchor.add duration
      else if s[i] is '-'
        i++
        while i < s.length
          duration = readduration()
          #console.log "subtract #{duration.toString()}"
          anchor = anchor.subtract duration
      else if s[i] is '('
        i++
        tz = readtimezone()
        #console.log "use #{tz}"
        anchor = anchor.tz tz
        if s[i] isnt ')'
          throw new Error 'Expecting closing ) on timezone'
        i++

    if i < s.length
      throw new Error "unknown format #{i} < #{s.length}"

    anchor

  moment.spanner = (s, vars) ->
    iso8601 = moment s, moment.ISO_8601
    return iso8601 if iso8601.isValid()
    spanner moment(), 'UTC', s, vars

  moment.fn.spanner = (s, vars) ->
    tz = @_z?.name
    spanner @, tz, s, vars
  moment