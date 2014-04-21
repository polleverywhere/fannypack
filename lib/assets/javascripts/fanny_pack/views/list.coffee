#= require ../namespace

FannyPack.namespace 'FannyPack.View', (View) ->
  class View.List extends View.Base
    initialize: (options={}) ->
      @collection = options.collection
      @subView = options.subView

      @subViews = []

    # always blow away existing subViews.
    # call this only if you want a full re-render
    render: =>
      @remove()

      @collection.each (item) =>
        v = new @subView
          model: item

        @subViews.push v

        @$el.append v.render().$el

      @

    remove: =>
      _.invoke @subViews, 'remove'

      super
