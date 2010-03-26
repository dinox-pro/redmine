# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_plugin_session',
  :secret      => 'ae7b7cc0780cc9cb4ba1b8088885d3aa3d7dec45e3d3623dbe26ea9dc81a86d4cb0f7d608252cf12b007237f9962a9f1990951b048332299f36ac28552b69d1b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
