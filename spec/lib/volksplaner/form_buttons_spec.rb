require 'spec_helper'

describe Volksplaner::FormButtons do
  let(:template) do
   mock('template').tap do |t| 
     t.extend ActionView::Helpers::TagHelper
     t.stub(ti: 'icon')
   end
  end
  let(:form) do
    mock('form').tap do |f|
      f.extend described_class
      f.stub(template: template)
    end
  end
  include Capybara::RSpecMatchers

  shared_examples "a submit button" do
    it "should have type of 'submit'" do
      button.should have_css('button[type=submit]')
    end
  end

  shared_examples "a beautiful button" do
    it "should have class button-success" do
      button.should have_css('button.button-success')
    end
  end

  shared_examples "a responsive button" do
    it "should disable itself on first click" do
      button.should have_css('button[data-disable-with]')
    end
  end

  describe 'create button' do
    let(:button) { form.create_button }
    it_should_behave_like 'a submit button'
    it_should_behave_like 'a beautiful button'
    it_should_behave_like 'a responsive button'
  end

  describe 'update button' do
    let(:button) { form.update_button }
    it_should_behave_like 'a submit button'
    it_should_behave_like 'a beautiful button'
    it_should_behave_like 'a responsive button'
  end

  describe 'responsive submit button' do
    it "accepts extra class" do
      form.responsive_submit_button('label', class: 'extra').should have_css('button.extra')
    end
    it "accepts label as first argument" do
      form.responsive_submit_button('the label').should have_css('button', text: 'the label')
    end
    it "accepts label as :label option" do
      form.responsive_submit_button(label: 'the label').should have_css('button', text: 'the label')
    end
    it "translates label with icon" do
      template.should_receive(:ti).with(:colorful_action).and_return('the label')
      form.responsive_submit_button(:colorful_action).should have_css('button', text: 'the label')
    end
  end
end
