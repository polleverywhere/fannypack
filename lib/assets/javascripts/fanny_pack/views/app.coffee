#= require_tree ../views

FannyPack.namespace "FannyPack.View", (View) ->
  class View.App extends View.Base
    className: 'fannypack'

    initialize: (opts = {}) ->
      @currentView = null

    activate: (view) =>
      @currentView?.remove()
      @currentView = view
      @$el.append view.render().$el

    currentPage: =>
      @currentView

    render: =>
      @