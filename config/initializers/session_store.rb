Shiftplan::Application.configure do
  config.session_store :cookie_store, :key => '_shiftplan_session'
  config.cookie_secret = 'd85737ffefa5b429be2d8ee838b853621a8bfd724f0b7a0278517602eae830de8b1149397df5d50a84142f4df41e93e106f44fc30f5b67fec70c1b678a0baf32'
end

# ActionController::Base.session = {
#   :key         => '_shiftplan_session',
#   :secret      => 'd85737ffefa5b429be2d8ee838b853621a8bfd724f0b7a0278517602eae830de8b1149397df5d50a84142f4df41e93e106f44fc30f5b67fec70c1b678a0baf32'
# }
