# Setup an environment class for all Poll Everywhere applications to access and store global state.

FannyPack.namespace "FannyPack", (FannyPack) ->
  FannyPack.env = new FannyPack.Model.Environment