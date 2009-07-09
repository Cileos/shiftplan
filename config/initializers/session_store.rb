# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shiftplan_session',
  :secret      => 'd85737ffefa5b429be2d8ee838b853621a8bfd724f0b7a0278517602eae830de8b1149397df5d50a84142f4df41e93e106f44fc30f5b67fec70c1b678a0baf32'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
