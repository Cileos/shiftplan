# encoding: utf-8
require 'spec_helper'

describe Volksplaner::Undo::Step do
  let(:thing23) { mock_model( 'Thing', id: 23 ) }
  let(:thing42) { mock_model( 'Thing', id: 42 ) }
  let(:other66) { mock_model( 'Other', id: 66 ) }

  let(:records) {
    [
      thing23,
      thing42,
      other66,
    ]
  }
  let(:path) { '/an/url_to/redirect/after/execution' }

  describe '.build' do
    it 'stores created_records' do
      undo = described_class.build create: records
      undo.created_records.should be_hash_matching(
        'Thing' => [23,42],
        'Other' => [66]
      )
    end

    it 'stores redirect location when given' do
      undo = described_class.build redirect: path
      undo.should be_redirectable
      undo.location.should == path
    end

    it 'denies redirect when none given' do
      undo = described_class.build
      undo.should_not be_redirectable
    end
  end

  describe '#flash' do
    it 'contains notice when .build with flash.to_hash' do
      flash = {}
      flash[:notice] = 'success'
      flash[:error] = 'fail'
      undo = described_class.build flash: flash
      undo.flash.should == 'success'
    end
  end

  describe '#execute!' do
    it 'destroys created records' do
      undo = described_class.build create: records
      undo.should_receive(:load_record).with('Thing', 23).and_return thing23
      undo.should_receive(:load_record).with('Thing', 42).and_return thing42
      undo.should_receive(:load_record).with('Other', 66).and_return other66
      records.each do |r|
        r.should_receive :destroy
      end
      undo.execute!
    end
  end

  describe '#flash_message' do
    it 'can be provided on build' do
      undo = described_class.build flash_message: 'go back'
      undo.flash_message.should == 'go back'
    end
    it 'ignores blank provided values' do
      undo = described_class.build flash_message: ''
      undo.flash_message.should_not be_blank
    end
    it 'falls back to composing from stored #flash and i18n' do
      undo = described_class.build
      undo.stub flash: 'Tür geöffnet'
      I18n.with_locale :de do
        undo.flash_message.should == 'Rückgängig gemacht: Tür geöffnet'
      end
    end
  end

  describe '#human_title' do
    it 'uses stored flash and i18n' do
      undo = described_class.build
      undo.stub flash: 'Tür geöffnet'
      I18n.with_locale :de do
        undo.human_title.should == 'Rückgängig machen: Tür geöffnet'
      end
    end
  end

  context 'serialization' do
    let(:undo) { described_class.build create: records, redirect: path, flash: { notice: 'hohho' } }

    let(:serialized) { undo.to_json }
    let(:parsed)     { described_class.load serialized }

    it 'keeps created records' do
      parsed.created_records.should == undo.created_records
    end

    it 'keeps location' do
      parsed.location.should == undo.location
    end

    it 'keeps flash' do
      parsed.flash.should == undo.flash
    end

    it 'keeps show count' do
      undo.shown!
      parsed.should be_shown
    end
  end

  context 'shown only once' do
    let(:undo) { described_class.build }

    it 'is not shown from beginning' do
      undo.should_not be_shown
    end

    it 'memoizes that it was shown' do
      undo.shown!
      undo.should be_shown
    end
  end
end
