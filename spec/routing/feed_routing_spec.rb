require 'spec_helper'

describe 'routes for feeds' do
  let(:token) { 'Aa' * 10 }
  it 'routes private URLs to feed controller' do
    { get: "/feeds/foo%40example.com/private-#{token}/upcoming" }.should route_to(
      controller: 'feeds',
      action:     'upcoming',
      email:      'foo@example.com',
      private_token: token
    )
  end

  # mitigate timing attacks
  it 'ignores tokens longer than 20 chars' do
    { get: "/feeds/foo%40example.com/private-#{'a' * 21}/upcoming" }.should_not be_routable
  end

  it 'ignores tokens shorter than 20 chars' do
    { get: "/feeds/foo%40example.com/private-#{'a' * 19}/upcoming" }.should_not be_routable
  end
end
