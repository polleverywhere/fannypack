# The FannyPack.Router.Base is considered our most global application
# state for applications. Its assumed that only one router should
# be running at a given time within the context of a single runtime.
#
# Views and Templates all have access to the router via the `@app`
# method.
FannyPack.namespace "FannyPack.Router", (Router) ->
  {Model} = FannyPack

  class Router.Base extends Backbone.Router
    # Default app name. Sets the default <title> on the page and
    # is used in error messaging.
    appName: "FannyPack App"

    constructor: ->
      # Lets prevent confusion for the clowns out there who try
      # initializing 2 routers in the same runtime.
      throw Error "FannyPack.app already initialized with '#{@appName}'" if FannyPack.app
      FannyPack.app = @

      # Convient access to the FannyPack.env from
      # applications
      @env = FannyPack.env

      # What's that? You turned logging on? SWEET! You
      # get to hear about everything that's happening in the
      # event bus.
      if @env.get('logging_enabled')
        @on 'all', =>
          @log 'App Event', arguments

      # View manager responsible for de-activating old views and activating new ones
      @view = new View.App

      # We call super last since this calls the `initialize` method,
      # which assumes everything above is all set and ready to go.
      super

    # Take care of all the messy bootstrapping of browser globals and singletons to
    # the router, render a view, bootstrap user data from the server, and start
    # Backbone.history routing. Basically all of the gross browser bootstrapping should
    # go here.
    #
    # If you're trying to setup the router for testing, you should either decompose this
    # method or manually start the browser's history.
    start: (opts={pushState: true}) =>
      throw Error "Specify a view property in the initialize method of the router" unless @view

      {pushState, el} = opts

      # Render the view first on the element since the login state could
      # change what's rendered.
      el.append @view.render().$el

      # Start the router
      Backbone.history.start(pushState: pushState)

      @

    # Returns the current location of the application.
    location: ->
      # This assumes that we're in a web browser context.
      window.location.pathname.substring(1)

    # Go "back" through the browsers history.
    navigateBack: ->
      Backbone.history.history.back()

    # Default in backbone is to *not* trigger to execute the route handler,
    # which is undesirable and feels like unexpected behavior for our devs.
    navigate: (fragment, options = {trigger: true}) ->
      super fragment, options

    # Log tracing messages to a logging device if enabled.
    log: =>
      console.log(arguments...) if @env.get('logging_enabled')

    # Change the title of the page and notify views/models that
    # care about a title change what's up.
    title: (title = @appName) =>
      document?.title = title
      @trigger "change:title", title