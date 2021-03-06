require 'dragonfly'
require 'uri'

### The dragonfly app ###
app = Dragonfly[:images]
app.configure_with(:rails)
app.configure_with(:imagemagick)
app.configure_with(:heroku, 'salsaparis_fr') if Rails.env.production?

### Extend Mongoid ###
app.define_macro_on_include(Mongoid::Document, :image_accessor)

### Insert the middleware ###
# Where the middleware is depends on the version of Rails
middleware = Rails.respond_to?(:application) ? Rails.application.middleware : ActionController::Dispatcher.middleware

middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images, app.url_path_prefix
middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
  :verbose     => true,
  :metastore   => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/meta"), # URI encoded because Windows
  :entitystore => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body")  # has problems with spaces
}
