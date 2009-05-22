# Load planetoid config file and store the variables for later use
# They can be accessed later from inside the app like this:
# <%= PLANETOID_CONF[:site][:title] %>

raw_config = File.read(RAILS_ROOT + "/config/planetoid.yml")
PLANETOID_CONF = YAML.load(raw_config)[RAILS_ENV]

puts "planetoid config file loaded successfully"