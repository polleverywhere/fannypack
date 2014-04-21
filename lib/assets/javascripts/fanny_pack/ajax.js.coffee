#= require ppx

FannyPack.namespace "FannyPack", (FannyPack) ->
  FannyPack.BasicAuth =
    setCredentials: (username, password) ->
      FannyPack.BasicAuth.username = username
      FannyPack.BasicAuth.password = password
      FannyPack.AJAX_DEFAULTS.headers['Authorization'] = "Basic #{btoa(FannyPack.BasicAuth.username + ':' + FannyPack.BasicAuth.password)}"

  FannyPack.AJAX_DEFAULTS =
    xhrFields:  {}
    headers: {}
    dataType: 'json'
    type: 'GET'

  # Deep clone the ajax defaults
  ajaxDefaults = ->
    clone = _.clone FannyPack.AJAX_DEFAULTS
    clone.xhrFields = _.clone FannyPack.AJAX_DEFAULTS.xhrFields
    clone.headers = _.clone FannyPack.AJAX_DEFAULTS.headers
    clone

  # Cross Domain polyfill for IE8
  # ---
  # IMPORTANT: We MUST call toString() on this method or IE will barf on allow
  # other URLS to access the domain. For example, IE would request the URL
  # 'multiple_choice_polls/[object]' without throwing an error message.

  # PPX Proxy JS will determine whether iframe needs SSL or not
  polyfillCORS = (options, xhr) ->
    # A PPX end-point lives in our rails_app server at the /ppx location.
    path = FannyPack.env.get('api_url').path()
    ppxUrl = FannyPack.env.get('api_url').path("/ppx#{path}")

    FannyPack.PPXRequest ||= PPX.buildClientConstructor ppxUrl.toString()

    if (options.crossDomain && !$.support.cors) || options.usePostMessage
      options.xhr = FannyPack.PPXRequest
      options.crossDomain = false
      xhr.isProxiedThroughPostMessage = true

  $.ajaxPrefilter (options, originalOptions, xhr) ->
    _.defaults options, ajaxDefaults()

    # Only set this up if we're given a relative path. Paths with domains
    # should just flow through to the next uri mutations.
    url = URI(options.url).absoluteTo(FannyPack.env.get('api_url'))
    url.setQuery 'cache_buster', (new Date).getTime().toString() if $.os?.android
    options.url = url.toString()

    # Check if this is a cross domain request.
    # CORS PPX polyfill uses this to determine if PPX should be used.
    options.crossDomain = !url.absoluteTo('/').equals(URI(window.location.href).absoluteTo('/'))

    # We need this for CORS + Cookies to work when using jQuery
    options.xhrFields.withCredentials ?= true

    polyfillCORS(options, xhr)
