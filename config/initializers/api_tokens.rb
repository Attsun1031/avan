# set api tokens to config
require 'yaml'
Avan::Application.config.api_tokens = YAML.load_file 'config/secrets.yml'
