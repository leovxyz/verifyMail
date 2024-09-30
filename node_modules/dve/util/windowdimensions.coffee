###

Find the dimensions of the whole page.

###

module.exports = ->
  documentElement = document.documentElement
  body = document.getElementsByTagName('body')[0]
  [
    parseInt window.innerWidth || documentElement.clientWidth || body.clientWidth
    -2 + parseInt window.innerHeight || documentElement.clientHeight|| body.clientHeight
  ]
