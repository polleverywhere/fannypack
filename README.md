# fanny-pack

A simple set of base views to help develop Backbone applications.

## Documentation

**Namespacing**: JavaScript doesn’t have a native namespace language feature. We use a simple function to do our namespacing. We even put it on our PollEv object to avoid with other possible namespace implementations.

```coffee
FannyPack.namespace 'MyApp.View', (View) ->
  class View.PollWidget extends FannyPack.View.Base
    show: ->
    hide: ->
```

The first string ensures that `MyApp`, and `View` exist, and then gives you a reference to the `View` key. From there you define your new view.

**Base Class**: The base class can’t infer the current application you’re working on, so you need to define a base class for your application that all your views will inherit from.

```coffee
FannyPack.namespace 'MyApp.View', (View) ->
  # set up an application specific base view that
  # inherits from our FannyPack base view
  class View.Base extends FannyPack.View.Base
    application: 'Editor'
```

**Templates**: We use [haml\_coffee\_assets](https://github.com/netzpirat/haml_coffee_assets) for our templating.

`FannyPack.Base#template` resolves the path to your templates relative to your application. First create a .hamlc file in your templates directory (eg. in viz: lib/assets/javascripts/my_app/templates/header.hamlc)

Then, make sure to require it with sprockets.

```coffee
# FannyPack.Base#template usage

#= require my_app/templates/view

FannyPack.namespace "MyApp.View", (View) ->
  class View.Header extends View.Base
    render: =>
      {
        headerLogoPlacement
        headerLogoUrl
      } = @model.flashOptions().attributes

      @$el.html @template 'chart_header',
        title: @model.get('title')
        headerPlacement: headerLogoPlacement
        headerLogoUrl: headerLogoUrl

      return @
```

Note: Since launching HTML charts we've decided to start practicing 'logic-less' templates. That is, we aren't going to pass variables into to templates or use any control flow inside them. They will simply be used to insert markup into the DOM. Any dynamic hiding, or updating text will occur in view methods (this makes re-rendering individual pieces much easier and makes it easier to optimize performance in slow browsers).

**Events**: In addition to the standard event bindings that Backbone sets up for views, we use an eventBus pattern that allows any view to trigger an application specific custom event that other views can listen to. This is better for testing and refactoring than passing hard dependencies into each view’s constructor. You should try to keep all interaction within the appropriate view but sometimes outside or coordinating views need to respond to things happening within subviews.

```coffee
# FannyPack.Base#triggerEvent usage

FannyPack.namespace 'MyApp.View', (View) ->
  class View.Header extends View.Base
    toggle: =>
      @$el.toggle()

      # send the 'header:toggle' event to any view that is listening
      # passing them a boolean of whether the current view is hidden
      @triggerEvent 'header:toggle', @$el.hasClass('hidden')

  class View.Body extends View.Base
    externalEvents:
      'header:toggle': 'resize'

    # this is called whenever ChartHeader or any other view
    # triggers 'header:toggle'
    resize: =>
      @measureBars()
      @render()
```

**Modules**: Use modules to break up large classes that have repeated behaviors or just to isolate related behavior. Call include in the class declaration to include other modules.

```coffee
# FannyPack.Base#include usage

FannyPack.namespace 'MyApp.View' (View) ->
  View.MyModule =
    eat: ->
      'mmm'

    sleep: ->
      'zzz'

    breathe: ->
      '*silent*'

    # use the fat arrow if you need to
    # reference `this` in your method
    getModel: =>
      @model

FannyPack.namespace 'MyApp.View', (View) ->
  class View.Person extends View.Base
    @::include View.MyModule

view = new MyApp.View.Person
  model: new Backbone.Model

# view now has all these methods
view.eat() # => 'mmm'
view.sleep() # => 'zzz'
view.breathe() # => '*silent*'

view.getModel() # => Backbone.Model
```

**Memory Management and listening to model events**: Usually Backbone Views are a huge pain to manage in terms of leaking events and memory. FannyPack deals with memory management for you.

```coffee
# FannyPack.Base#include usage

FannyPack.namespace 'MyApp.View' (View) ->
  class View.DontLeak extends View.Base
    externalEvents:
      'otherView:update': 'render'

    events:
      'click': 'respondToClick'

    initialize: ->
      # set up your view to listen on change events
      # emitted from the passed in @model
      @listenTo @model, 'change', (model, attributes) =>
        # Do stuff

    render: =>
      # ...

    respondToClick: (e) ->
      # ...

  view = new View.DontLeak
    model: new Backbone.Model

  # FannyPack unbinds all model events set up with listenOn,
  # all jQuery events, all external events and removes the
  # view element from the DOM
  view.remove()
```

**Subviews**: Add subviews by calling append on the current view.

```coffee
# FannyPack.Base#append usage

FannyPack.namespace 'MyApp.View' (View) ->
  View.ParentView extends View.Base
    initialize: ->
      @childView = new Backbone.View

    render: =>
      # syntax sugar. Equivalent to
      # @$el.append(@childView.render().$el)
      @append @childView
```
