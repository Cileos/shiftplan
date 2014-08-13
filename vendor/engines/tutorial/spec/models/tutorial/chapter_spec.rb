require 'spec_helper'

describe Tutorial::Chapter do

  context '.all' do
    before :each do
      described_class.stub translations_for_locale: [
        {id: 'one', title: 'The One'},
        {id: 'two', title: 'The Two'},
      ]
    end

    it 'returns a chapter for each entry having a translation' do
      described_class.all.should have(2).records
    end

    it 'assigns attributes to all chapters from translation data' do
      described_class.all.map(&:id).should == %w(one two)
      described_class.all.map(&:title).should == ['The One', 'The Two']
    end

    it 'takes a user and let him visit each chapter' do
      one = instance_double 'Tutorial::Chapter'
      two = instance_double 'Tutorial::Chapter'
      user = double 'User'
      described_class.stub(:new).and_return(one, two)
      one.should_receive(:visit).with(user)
      two.should_receive(:visit).with(user)

      described_class.all(user)
    end
  end


  context '.translations_for_locale' do
    in_locale :de
    it 'returns raw chapters for the current locale' do
      described_class.stub translations: {
        en: { tutorial: { chapters: 'EN' } },
        de: { tutorial: { chapters: 'DE' } },
      }

      described_class.translations_for_locale.should == 'DE'
    end
  end


  context '.translations' do
    it 'fetches all translation data from I18n.backend' do
      all_trans = double('All Translations').as_null_object
      I18n.backend.stub translations: all_trans

      described_class.translations.should == all_trans
    end
  end

  context '#visit' do
    let(:user)  { double 'User', noob?: nil } # or more complex
    subject     { described_class.new id: 'breath' }
    def visit
      subject.visit(user)
    end

    it 'starts with an undone chapter' do
      should_not be_done
    end

    it 'ignores chapters without conditions' do
      visit
      should_not be_done
    end

    context 'with conditions present' do
      keep_chapter_conditions
      before :each do
        Tutorial.define_chapter 'breath' do |user|
          user.noob?
        end
      end

      it 'marks chapter as done when condition is not fulfilled anymore' do
        user.stub noob?: false
        visit
        should be_done
      end

      it 'does not mark chapter as done when condition is met' do
        user.stub noob?: true
        visit
        should_not be_done
      end
    end

  end
end

