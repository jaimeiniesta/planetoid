# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_planetoid_session',
  :secret      => '6457452423c10cea60bfb3eafbd0cdd34bf8d469e0df456b33905f59259687f9236427e42296711ccfff98b4ba30f8192e9792eaeee2206b647a420ebea137ab'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
