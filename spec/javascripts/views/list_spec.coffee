describe 'FannyPack', ->
  describe 'List', ->
    it 'exists', ->
      expect(FannyPack.View.List).toBeDefined()

    it 'keeps track of subViews', ->
      collection = new Backbone.Collection [{a:1}, {b:2}, {c:3}]

      class SubView extends Backbone.View

      list = new FannyPack.View.List
        collection: collection
        subView: SubView

      list.render()

      expect(list.subViews.length).toEqual(3)

    it 'renders subView content into $el', ->
      collection = new Backbone.Collection [{one: 'a'}, {two: 'b'}, {three: 'c'}]

      class SubView extends Backbone.View
        className: 'nested'

      list = new FannyPack.View.List
        collection: collection
        subView: SubView

      list.render()

      expect(list.$el.find('.nested').length).toEqual(3)
