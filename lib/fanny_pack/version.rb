module FannyPack
  # Read the FannyPack.version attribute from lib/assets/javascripts/fanny_pack/version.js.coffee
  VERSION = File.read(File.expand_path('../../assets/javascripts/fanny_pack/version.js.coffee', __FILE__)).match(/Package.version \= '(.+)'/m).captures.first
end
