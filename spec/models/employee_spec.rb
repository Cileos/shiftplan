require 'spec_helper'

describe Employee do
  context "full name" do
    it "is build up by first and last name" do
      employee = build :employee, :first_name => 'Homer', :last_name => 'Simpson'
      employee.name.should == 'Homer Simpson'
    end
  end

  shared_examples 'human name' do
    it "is needed" do
      build(:employee, attr => nil).should be_invalid
      build(:employee, attr => '').should  be_invalid
      build(:employee, attr => ' ').should be_invalid
    end

    it "may not start with a dot" do # causes translate_action
      build(:employee, attr => '.lookslikeaction').should be_invalid
    end

    it "may not start with a dash" do # looks ugly
      build(:employee, attr => '-in').should be_invalid
    end

    it "may contain dashes" do
      build(:employee, attr => 'Hans-Peter').should be_valid
    end
  end

  context "first name" do
    let(:attr) { :first_name }
    it_behaves_like 'human name'
  end

  context "last name" do
    let(:attr) { :last_name }
    it_behaves_like 'human name'
  end

  context "weekly working time" do
    it "must have positive numeric value" do
      build(:employee, :weekly_working_time => 1.2).should be_valid
      build(:employee, :weekly_working_time => 0).should   be_valid
      build(:employee, :weekly_working_time => 40).should  be_valid
    end

    it "may be nil" do
      build(:employee, :weekly_working_time => nil).should be_valid
    end

    it "may not be negative" do
      build(:employee, :weekly_working_time => -1).should  be_invalid
    end

    context "in simple form" do
      it "keeps beeing empty (no accidental 0)" do
        build(:employee, weekly_working_time: nil).weekly_working_time_before_type_cast.should be_nil
      end
    end
  end

  context "role" do
    it "can be 'planner'" do
      build(:employee, role: 'planner').should be_valid
    end

    it "can be 'owner'" do
      build(:employee, role: 'owner').should be_valid
    end

    it "does not correct mistakes in writing plan(n)er" do
      build(:employee, role: 'planer').should be_invalid
    end

    it "may not be arbitrary" do
      build(:employee, role: 'weihnachtsmann').should be_invalid
    end

    it "is persisted" do
      create(:employee, role: 'planner').reload.role.should == 'planner'
    end
  end

  context "duplicates" do
    let(:account) { create :account }

    context "for blank employee" do
      let(:employee) { build :employee, first_name: '', last_name: '', account: account }

      it "has not enough details" do
        employee.should_not be_sufficient_details_to_search_duplicates
      end
    end

    context "for non blank employee" do
      let(:employee) { build :employee, first_name: 'Helmut', last_name: 'Kohl', account: account, force_duplicate: false }

      it "has enough details" do
        employee.should be_sufficient_details_to_search_duplicates
      end

      context "with duplicates present" do
        let!(:duplicate) { create :employee, name: 'Helmut Kohl', account: account }

        it "are found" do
          employee.duplicates.should include(duplicate)
        end

        it "do not include itself" do
          duplicate.duplicates.should be_empty
        end

        it "add errors to employee" do
          employee.valid?
          employee.should have_at_least(1).error_on(:duplicates)
        end
      end
    end
  end
end
