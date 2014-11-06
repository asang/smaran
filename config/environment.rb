# Load the Rails application.
require File.expand_path('../application', __FILE__)

Paperclip.options[:content_type_mappings] = {
  :cfg => "application/octet-stream"
}

# Initialize the Rails application.
Smaran::Application.initialize!
