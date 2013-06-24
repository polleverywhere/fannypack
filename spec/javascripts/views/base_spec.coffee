describe 'FannyPack', ->
  describe 'Base', ->
    it 'exists', ->
      expect(FannyPack.View.Base).toBeDefined()

    describe '#triggerEvent', ->
      afterEach ->
        delete TestApp
        delete Mobile

      it 'registers an application specific eventBus', ->
        class EventBus extends FannyPack.View.Base
          application: 'TestApp'

        view = new EventBus

        expect(TestApp.eventBus).toBeDefined()
        expect(view._eventBus()).toBeDefined()

      it 'registers a namespaced application specific eventBus', ->
        class EventBus extends FannyPack.View.Base
          application: 'MyOrg.TestApp'

        view = new EventBus

        expect(MyOrg.TestApp.eventBus).toBeDefined()
        expect(view._eventBus()).toBeDefined()

      it 'triggers events on an event bus', ->
        class Listener extends FannyPack.View.Base
          externalEvents:
            'test': 'test'
            'second': 'another'

          test: ->
          another: ->

        # need to declare this before instantiating view
        testSpy = sinon.spy(Listener.prototype, 'test')
        secondSpy = sinon.spy(Listener.prototype, 'another')

        view = new Listener

        view.triggerEvent 'test'
        view.triggerEvent 'second'

        expect(testSpy).toHaveBeenCalledOnce()
        expect(secondSpy).toHaveBeenCalledOnce()

      it 'passes function arguments through', ->
        class Listener extends FannyPack.View.Base
          externalEvents:
            'test': 'test'

          test: (one, two, three) ->

        # need to declare this before instantiating view
        spy = sinon.spy(Listener.prototype, 'test')

        view = new Listener

        view.triggerEvent 'test', 1, 'two', [3]

        expect(spy).toHaveBeenCalledWith(1, 'two', [3])

      it 'cleans up eventBus handlers when the view is destroyed', ->
        class Advice extends FannyPack.View.Base
          application: 'TestApp'

          externalEvents:
            'never': 'test'
            'trust': 'another'
            'twain': 'last'

          test: ->
          another: ->
          last: ->

        # need to declare this before instantiating view
        testSpy = sinon.spy(Advice.prototype, 'test')
        secondSpy = sinon.spy(Advice.prototype, 'another')
        lastSpy = sinon.spy(Advice.prototype, 'last')

        view = new Advice

        # trigger events normally
        view.triggerEvent 'never'
        view.triggerEvent 'never'

        view.triggerEvent 'trust'
        view.triggerEvent 'twain'

        # get rid of the view
        view.remove()

        # try to trigger events by hand.
        # should not call spies again
        TestApp.eventBus.trigger 'never'
        TestApp.eventBus.trigger 'trust'
        TestApp.eventBus.trigger 'twain'

        expect(testSpy).toHaveBeenCalledTwice()
        expect(secondSpy).toHaveBeenCalledOnce()
        expect(secondSpy).toHaveBeenCalledOnce()

    describe 'include', ->
      it "doesn't include methods on the base prototype", ->
        Mixin =
          seeMe: -> ''

        class MixinTarget extends FannyPack.View.Base
          application: 'TestApp'

          @::include Mixin

        class Another extends FannyPack.View.Base
          application: 'TestApp'

        mixinTarget = new MixinTarget
        another = new Another

        expect(mixinTarget.seeMe).toBeDefined()
        expect(another.seeMe).not.toBeDefined()

      it 'adds included module methods to object prototype', ->
        Mixin =
          count: -> @application
          average: -> @application
          format: -> @application

        class Includer extends FannyPack.View.Base
          application: 'TestApp'

          @::include Mixin

        view = new Includer

        expect(view.count).toBeDefined()
        expect(view.average).toBeDefined()
        expect(view.format).toBeDefined()

        expect(view.count()).toEqual('TestApp')

      it 'includes multiple modules', ->
        Minin =
          methodOne: -> 1

        Maxin =
          methodTwo: -> 2

        class Includer extends FannyPack.View.Base
          @::include Minin, Maxin

        view = new Includer

        expect(view.methodOne()).toEqual(1)
        expect(view.methodTwo()).toEqual(2)
