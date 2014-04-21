# Handle lots of commond URL parsing concerns so that we can easily
# do stuff like URI('google.com/hi').params({search: 'football'})
#= require uri

# IE8 JSON parsing compatability.
# TODO - Remove when we no longer care about IE8.
#= require json2

# Provides $.os support, which jQuery ditched.
#= require zepto-detect

# Fanny Pack prerequisites
#= require fanny_pack/namespace
#= require fanny_pack/version
#= require fanny_pack/models/environment
#= require fanny_pack/env

# Fanny Pack assets
#= require_tree ./fanny_pack/routers
#= require_tree ./fanny_pack/models
#= require_tree ./fanny_pack/views