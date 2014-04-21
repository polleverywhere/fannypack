FannyPack.namespace "FannyPack.Model", (Model) ->
  class Model.Environment extends Backbone.Model
    currentHost = window?.location?.host
    protocol = window?.location?.protocol
    defaults:
      api_url: "//#{currentHost}"
      ssl: protocol is 'https:'

    get: (key) ->
      switch
        # When a key ends with _url, wrap it in an URI.js object so we can mutate it.
        when key.match(/_url$/)
          URI(super(key))
        else
          super(key)
