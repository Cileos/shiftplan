require 'spec_helper'

describe 'routes for feeds' do
  it 'routes private URLs to feed controller' do
    { get: '/feeds/foo@example.com/private-XYZ2342/upcoming' }.should route_to(
      controller: 'feeds',
      action:     'upcoming',
      email:      'foo@example.com',
      token:      'XYZ2342'
    )
  end
end
