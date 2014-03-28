require 'spec_helper'

describe LocalesController do
  describe 'GET show.json' do
    render_views

    it 'translates at least day names' do
      get :show, id: 'de', format: 'json'

      response.should be_success # no auth neccessary

      json = response.body
      json.should_not == 'null'
      t = JSON.parse(json)

      t.should_not be_nil
      # we only return the translations for the current locale, so we can skip its name
      t.should_not have_key('de')
      t.should have_key('date')
      t['date'].should have_key('day_names')
      t['date']['day_names'].should include('Freitag')
    end

    it 'sends expire header depending on latest change of locale files'
  end
end
