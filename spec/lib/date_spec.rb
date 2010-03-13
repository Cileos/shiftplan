require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Date do
  describe "class methods" do
    describe ".week" do
      it "should return all days of a given week number in a given year" do
        Date.week(2010, 10).should == (Date.civil(2010,  3,  8)..Date.civil(2010, 3, 14))
        # see http://en.wikipedia.org/wiki/Seven-day_week#Week_numbering
        Date.week(2005,  1).should == (Date.civil(2005,  1,  3)..Date.civil(2005, 1,  9))
        Date.week(2004,  1).should == (Date.civil(2003, 12, 29)..Date.civil(2004, 1,  4))
      end

      it "should raise an error if an invalid week is passed" do
        lambda { Date.week(2010, -1) }.should raise_error(ArgumentError)
        lambda { Date.week(2010,  0) }.should raise_error(ArgumentError)
        lambda { Date.week(2010, 54) }.should raise_error(ArgumentError)
      end

      it "should raise an error if given year has 52 weeks and user requests week 53" do
        lambda { Date.week(2010, 53) }.should raise_error(ArgumentError)
      end
    end

    describe ".first_monday_in_year" do
      it "should return all days of a given week number in a given year" do
        Date.first_monday_in_year(2010).should == Date.civil(2010,  1,  4)
        Date.first_monday_in_year(2005).should == Date.civil(2005,  1,  3)
        Date.first_monday_in_year(2004).should == Date.civil(2003, 12, 29)
      end
    end

    describe ".weeks_in_year" do
      it "should return the number of weeks in a given year" do
        # 52 weeks
        (2010..2014).each { |year| Date.weeks_in_year(year).should == 52 }
        (2016..2019).each { |year| Date.weeks_in_year(year).should == 52 }
        (2021..2025).each { |year| Date.weeks_in_year(year).should == 52 }
        # 53 weeks
        [2009, 2015, 2020, 2026].each { |year| Date.weeks_in_year(year).should == 53 }
      end
    end

    describe ".same_year?" do
      it "should return true for dates in the same year" do
        Date.same_year?(Date.civil(2010, 3, 12), Date.civil(2010,  1,  1)).should be_true
        Date.same_year?(Date.civil(2010, 3, 12), Date.civil(2010, 12, 31)).should be_true
      end

      it "should return false for dates in another year" do
        Date.same_year?(Date.civil(2010, 3, 12), Date.civil(2009, 12, 31)).should be_false
        Date.same_year?(Date.civil(2010, 3, 12), Date.civil(2011,  1,  1)).should be_false
      end

      it "should raise an error if non-date/time object is passed" do
        lambda { Date.same_year?(Date.today, 'not a date')   }.should raise_error(ArgumentError)
        lambda { Date.same_year?('not a date', Date.today)   }.should raise_error(ArgumentError)
        lambda { Date.same_year?('not a date', 'not a date') }.should raise_error(ArgumentError)
      end
    end

    describe ".same_month?" do
      it "should return true for dates in the same year and month" do
        Date.same_month?(Date.civil(2010, 3,  1), Date.civil(2010, 3, 12)).should be_true
        Date.same_month?(Date.civil(2010, 3, 31), Date.civil(2010, 3, 12)).should be_true
      end

      it "should return false for dates in another year and/or month" do
        Date.same_month?(Date.civil(2010, 2, 28), Date.civil(2010, 3, 12)).should be_false
        Date.same_month?(Date.civil(2010, 4,  1), Date.civil(2010, 3, 12)).should be_false
        Date.same_month?(Date.civil(2009, 3, 12), Date.civil(2010, 3, 12)).should be_false
        Date.same_month?(Date.civil(2011, 3, 12), Date.civil(2010, 3, 12)).should be_false
      end

      it "should raise an error if non-date/time object is passed" do
        lambda { Date.same_month?(Date.today, 'not a date')   }.should raise_error(ArgumentError)
        lambda { Date.same_month?('not a date', Date.today)   }.should raise_error(ArgumentError)
        lambda { Date.same_month?('not a date', 'not a date') }.should raise_error(ArgumentError)
      end
    end
  end

  describe "instance methods" do
    describe "#same_year_as?" do
      before(:each) do
        @date = Date.civil(2010, 3, 12)
      end

      it "should return true for dates in the same year" do
        @date.should be_same_year_as(Date.civil(2010, 1, 1))
        @date.should be_same_year_as(Date.civil(2010, 12, 31))
      end

      it "should return false for dates in another year" do
        @date.should_not be_same_year_as(Date.civil(2009, 12, 31))
        @date.should_not be_same_year_as(Date.civil(2011, 1, 1))
      end

      it "should raise an error if non-date/time object is passed" do
        lambda { @date.same_year_as?('not a date') }.should raise_error(ArgumentError)
      end
    end

    describe "#same_month_as?" do
      before(:each) do
        @date = Date.civil(2010, 3, 12)
      end

      it "should return true for dates in the same year and month" do
        @date.should be_same_month_as(Date.civil(2010, 3,  1))
        @date.should be_same_month_as(Date.civil(2010, 3, 31))
      end

      it "should return false for dates in another year and/or month" do
        @date.should_not be_same_month_as(Date.civil(2010, 2, 28))
        @date.should_not be_same_month_as(Date.civil(2010, 4,  1))
        @date.should_not be_same_month_as(Date.civil(2009, 3, 12))
        @date.should_not be_same_month_as(Date.civil(2011, 3, 12))
      end

      it "should raise an error if non-date/time object is passed" do
        lambda { @date.same_month_as?('not a date') }.should raise_error(ArgumentError)
      end
    end
  end
end
