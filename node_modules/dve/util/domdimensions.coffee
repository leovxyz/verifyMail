module.exports = (dom) ->
  styles = window.getComputedStyle dom
  paddingLeft = parseFloat styles.paddingLeft
  paddingRight = parseFloat styles.paddingRight
  paddingTop = parseFloat styles.paddingTop
  paddingBottom = parseFloat styles.paddingBottom
  [
    dom.offsetWidth - paddingLeft - paddingRight
    dom.offsetHeight - paddingTop - paddingBottom
  ]