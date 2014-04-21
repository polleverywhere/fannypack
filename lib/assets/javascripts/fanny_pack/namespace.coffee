if module?.exports?
  global.FannyPack ||= {}
else
  window.FannyPack ||= {}

FannyPack.namespace = (target, name, block) ->
  [target, name, block] = [(if global? then global else window), arguments...]
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, name
