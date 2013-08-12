#= require ../namespace

FannyPack.namespace 'FannyPack.View', (View) ->
  class View.Base extends Backbone.View
    application: 'MyApp'
    externalEvents: {}

    _eventBus: =>
      app = @application

      # Allow creating the eventBus on a namespaced application
      @target = window || {}
      @target = @target[item] ?= {} for item in app.split '.'
      @target.eventBus ?= _.extend({}, Backbone.Events)

      @target.eventBus

    append: (views...) =>
      for view in views
        @$el.append(view.render().$el)

    include: (modules...) ->
      for module in modules
        _.extend @, module

    template: (name, data={}) =>
      JST["#{@application}/templates/#{name}"](data)

    delegateEvents: (events) =>
      super

      @_eventBus() # causes eventBus to be created

      for action, method of @externalEvents
        if _.isFunction(method)
          @_eventBus().on action, _.bind(method, @), @
        else
          @_eventBus().on action, _.bind(@[method], @), @

    stopListening: =>
      for action, method of @externalEvents
        @_eventBus().off action, null, @

      super

    triggerEvent: (eventName, args...) =>
      # pass all these through
      @_eventBus().trigger eventName, args...
