###

Add a title to your visualisations.

- type: title
  text: Wind Speed (kts)

###

d3 = require 'd3'
unique = require '../util/unique'
mount = require './mount'

changeTabClosure = (title, component) -> (event) ->
  component.activeTitle = title
  component._updateTabs()
  component._updateContent()


module.exports = (spec, components) ->
  render: (dom, state, params) ->

    # Check titles are unique
    titles = (t.text for t in spec.tabs)
    if titles.length != unique(titles).length
      throw 'Tab titles must be unique'

    @activeTitle = spec.tabs[1].text
    @dom = dom
    @state = state
    @params = params
    @_update()



  _update: () ->
    @_renderTabs()
    @_renderContent()

  _renderTabs: () ->
    ul = document.createElement 'ul'
    ul.className = 'tabs tabs--bootstrap'

    @tabs = []

    for specTab, i in spec.tabs
      li = document.createElement 'li'
      li.classList.add 'is-active' if specTab.text == @activeTitle
      li.setAttribute 'data-title', specTab.text

      a = document.createElement 'a'
      a.href = '#!'
      a.innerHTML = specTab.text
      a.addEventListener 'click', changeTabClosure specTab.text, @

      li.appendChild a
      @tabs.push li

    ul.appendChild child for child in @tabs
    @dom.appendChild ul

  _updateTabs: () ->
    # IE10/11 doesn't support classList.toggle :(
    for tab in @tabs
      if tab.getAttribute('data-title') == @activeTitle
        tab.classList.add 'is-active'
      else
        tab.classList.remove 'is-active'

  _renderContent: () ->
    @tabContent = document.createElement 'div'
    @tabContent.className = 'tab-content'
    @dom.appendChild @tabContent
    @_updateContent()

  _updateContent: () ->
    @tabContent.innerHTML = '' if @tabContent
    childSpec = t.spec for t in spec.tabs when t.text == @activeTitle
    childItem = mount childSpec, components
    childItem.render @tabContent, @state, @params


