require 'spec_helper'

describe WelcomeController do
  describe '#landing (root of app)' do
    context 'being signed in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in create(:confirmed_user)
      end
      it 'redirects to dashboard' do
        get :landing
        response.should redirect_to('/dashboard')
      end
    end

    context 'not being signed in' do
      it 'redirects to signin' do
        get :landing
        response.should redirect_to('/users/sign_in')
      end
    end
  end
end
