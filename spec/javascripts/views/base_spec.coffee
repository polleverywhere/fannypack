describe 'FannyPack', ->
  describe 'Base', ->
    it 'exists', ->
      expect(FannyPack.View.Base).toBeDefined()

    describe "appEvents", ->
      describe "anonymous functions", ->
        it "are allowed to be registered as handlers", ->
          counter = 0

          class AnonymousHandlers extends FannyPack.View.Base
            appEvents:
              'somethingCrazy': ->
                counter += 1

          anon = new AnonymousHandlers

          anon.app.trigger 'somethingCrazy'

          expect(counter).toEqual(1)

        it "preserve current context (this)", ->
          class AnonymousHandlers extends FannyPack.View.Base
            appEvents:
              'instanceVariable': ->
                @myVar += 1

            initialize: ->
              @myVar = 0

            testVar: =>
              @myVar

          anon = new AnonymousHandlers
          anon.app.trigger 'instanceVariable'

          expect(anon.testVar()).toEqual(1)

    describe '#trigger', ->
      afterEach ->
        delete TestApp
        delete Mobile

      it 'triggers an app event', ->
        class Listener extends FannyPack.View.Base
          appEvents:
            'test': 'test'
            'second': 'another'

          test: ->
          another: ->

        # need to declare this before instantiating view
        testSpy = sinon.spy(Listener.prototype, 'test')
        secondSpy = sinon.spy(Listener.prototype, 'another')

        view = new Listener

        view.app.trigger 'test'
        view.app.trigger 'second'

        expect(testSpy).toHaveBeenCalledOnce()
        expect(secondSpy).toHaveBeenCalledOnce()

      it 'passes function arguments through', ->
        class Listener extends FannyPack.View.Base
          appEvents:
            'test': 'test'

          test: (one, two, three) ->

        # need to declare this before instantiating view
        spy = sinon.spy(Listener.prototype, 'test')

        view = new Listener

        view.app.trigger 'test', 1, 'two', [3]

        expect(spy).toHaveBeenCalledWith(1, 'two', [3])

    describe 'include', ->
      it "doesn't include methods on the base prototype", ->
        Mixin = (self) ->
          seeMe: -> ''

        class MixinTarget extends FannyPack.View.Base
          initialize: ->
            @include Mixin

        class Another extends FannyPack.View.Base

        mixinTarget = new MixinTarget
        another = new Another

        expect(mixinTarget.seeMe).toBeDefined()
        expect(another.seeMe).not.toBeDefined()

      it 'adds included module methods to object prototype', ->
        Mixin = (self) ->
          count: -> self.app
          average: -> self.app
          format: -> self.app

        class Includer extends FannyPack.View.Base
          initialize: ->
            @include Mixin

        view = new Includer

        expect(view.count).toBeDefined()
        expect(view.average).toBeDefined()
        expect(view.format).toBeDefined()

        expect(view.count()).toEqual(FannyPack.app)

      it 'includes multiple modules', ->
        Minin = (self) ->
          methodOne: -> 1

        Maxin = (self) ->
          methodTwo: -> 2

        class Includer extends FannyPack.View.Base
          initialize: ->
            @include Minin, Maxin

        view = new Includer

        expect(view.methodOne()).toEqual(1)
        expect(view.methodTwo()).toEqual(2)
