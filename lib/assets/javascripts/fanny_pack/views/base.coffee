#= require ../namespace

FannyPack.namespace 'FannyPack.View', (View) ->
  class View.Base extends Backbone.View
    application: 'MyApp'
    externalEvents: {}

    initialize: ->
      app = @application

      # Allow creating the eventBus on a namespaced application
      @target = window
      @target = @target[item] ?= {} for item in app.split '.'
      @target.eventBus ?= _.extend({}, Backbone.Events)

    _eventBus: =>
      @target.eventBus

    append: (views...) =>
      for view in views
        @$el.append(view.render().$el)

    include: (modules...) ->
      for module in modules
        _.extend @, module

    template: (name, data={}) ->
      JST["#{@application}/templates/#{name}"](data)

    delegateEvents: (events) =>
      super

      for action, handler of @externalEvents
        @_eventBus().on action, _.bind(@[handler], @), @

    stopListening: =>
      for action, handler of @externalEvents
        @_eventBus().off action, null, @

      super

    triggerEvent: (eventName, args...) =>
      # pass all these through
      @_eventBus().trigger eventName, args...
