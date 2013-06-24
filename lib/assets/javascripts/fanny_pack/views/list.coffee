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

        @append v

      return this

    remove: =>
      _.invoke @subViews, 'remove'

      super
