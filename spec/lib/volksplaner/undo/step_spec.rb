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

  describe '.build' do
    it 'stores created_records' do
      undo = described_class.build create: records
      undo.created_records.should be_hash_matching(
        'Thing' => [23,42],
        'Other' => [66]
      )
    end

    it 'stores redirect location when given' do
      path = double 'Path'
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
    it 'can be provided by i18n'
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
end
