require 'spec_helper'

describe ReportsHelper do

  context "#csv_export_params" do

    before do
      helper.stub(params: params)
    end

    context "when no filter params are present" do

      let(:params) { { foo: :bar } }

      it "sets format to csv" do
        helper.csv_export_params.should include(format: :csv)
      end

      it "sets limit to 'all'" do
        helper.csv_export_params.should include(report: { limit: "all" })
      end

      it "does not include other params" do
        helper.csv_export_params.should be_hash_matching({ format: :csv, report: { limit: "all" }})
      end
    end

    context "when filter params are present" do

      let(:params) { { foo: :bar, report: { fuzz: :buzz, limit: "50" }}}

      it "sets format to csv" do
        helper.csv_export_params.should include(format: :csv)
      end

      it "overwrites the limit with 'all'" do
        helper.csv_export_params[:report].should include( limit: "all" )
      end

      it "keeps filter params" do
        helper.csv_export_params[:report].should include( fuzz: :buzz )
      end

      it "does not include other params" do
        helper.csv_export_params.should be_hash_matching({ format: :csv, report: { limit: "all" , fuzz: :buzz }})
      end
    end
  end
end
