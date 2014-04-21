FannyPack.namespace 'FannyPack.View', (View) ->
  class View.Base extends Backbone.View
    include: (modules...) ->
      for module in modules
        _.extend this, module(this)

    constructor: (options = {}) ->
      # Set the app for this view to the base application
      # that FannyPack.Router.Base sets up in its initialize method.
      @app ||= FannyPack.app

      {title, template} = options

      # Set the page title if we're given one.
      @title = title if title?

      # Override the template if specified
      @template = template if template?

      # TODO - Figure out how to show the full namespace
      # of the view that's being rendered (and not just the prototype name)
      # Make it easier for non-lib devs to find views.
      @app.log "Constructing View", @

      # Tell the router what the title of our window should be.
      @app.title @title if @title

      # make sure we have an external events hash
      # if the child class hasn't defined one
      @appEvents ?= {}

      # Setup Backbone.View last since it fires the
      # subclasses' `initialize` method, which assumes
      # everything above is setup.
      super

    # Listen to a list of events and fire callback only once
    # e.g. @listenToChanges @poll, "max_votes web_enabled sms_enabled", @refreshPage
    # The above will call @refreshPage only once instead of 3 times for each attribute
    # change event
    listenToChanges: (model, attributes, callback) =>
      attributes = attributes.split /\s+/
      @listenTo model, 'change', (model) ->
        changedAttributes = _.keys model.changed

        if _.intersection(changedAttributes, attributes).length
          callback.apply(@, model)

    pageTitle: =>
      if _.isFunction(@title)
        @title.apply(@)
      else
        @title

    _configureAppEvents: =>
      for action, handler of @appEvents
        try
          method = @[handler]
          method = handler if _.isFunction(handler)
          boundMethod = _.bind(method, @)

          @app.on action, boundMethod
        catch
          name = "'#{@constructor?.name || ''}'"
          message = "View #{name} has no method named '#{handler}'. It cannot be registered as a handler for application events."
          throw new Error(message)

      @

    delegateEvents: (events) =>
      super
      @_configureAppEvents()
      @

    undelegateEvents: =>
      super
      for action, handler of @appEvents
        @app.off action, _.bind @[handler], @
      @

    renderTemplate: (template = @template) =>
      @app.log "Rendering Template", template
      @$el.html JST[template]()

    renderTitle: =>
      @$(".title").text @pageTitle()
      @app.title @pageTitle()

    pageClass: =>
      ""