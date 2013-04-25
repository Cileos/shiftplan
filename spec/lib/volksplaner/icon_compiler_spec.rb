require 'spec_helper'


describe Volksplaner::IconCompiler do
  let(:compiler) { described_class }
  context '.compile' do
    let(:instructions) { { icons: {
      'dirty' => 'pile',
      'liked' => 'heart'
    }}}
    let(:scss) { compiler.compile(instructions) }
    it "generates scss for each entry from hash" do
      compiler.stub(:entry).with('dirty', 'pile').and_return('[dirty]')
      compiler.stub(:entry).with('liked', 'heart').and_return('[liked]')
      scss.should include('[dirty]')
      scss.should include('[liked]')
    end
  end

  context '.entry' do
    it "generates scss" do
      scss = compiler.entry('dirty', 'pile')
      scss.should include_scss(<<-EOSCSS)
        .icon-dirty {
          &:before {
            content: "pile";
          }
        }
      EOSCSS
    end
  end

  context '.observe' do
    let(:yaml_path) { stub 'path to yaml' }
    let(:scss_path) { stub 'path to scss' }
    let(:hash) { stub 'parsed yaml' }
    let(:scss) { stub 'compiled scss' }

    def expect_compilation
      compiler.should_receive(:read_and_parse).with(yaml_path).and_return(hash)
      compiler.should_receive(:compile).with(hash).and_return(scss)
      compiler.should_receive(:write).with(scss_path, scss)
    end

    it "updates scss from yaml" do
      File.should_receive(:exist?).with(scss_path).and_return(true)
      compiler.stub(:uptodate?).with(yaml_path, scss_path).and_return(false)
      expect_compilation
      compiler.observe(yaml_path, scss_path)
    end

    it "generates scss if none exists" do
      File.should_receive(:exist?).with(scss_path).and_return(false)
      expect_compilation
      compiler.observe(yaml_path, scss_path)
    end

    it "does not touch scss if it is uptodate" do
      File.should_receive(:exist?).with(scss_path).and_return(true)
      compiler.stub(:uptodate?).with(yaml_path, scss_path).and_return(true)

      compiler.should_not_receive(:read_and_parse)
      compiler.should_not_receive(:compile)
      compiler.should_not_receive(:write)

      compiler.observe(yaml_path, scss_path)
    end
  end

  context '.uptodate?' do
    let(:now) { 1.minute.ago }
    let(:source) { stub 'source' }
    let(:result) { stub 'result' }

    it 'is false if source file is newer' do
      File.stub(:mtime).with(source).and_return(now+1)
      File.stub(:mtime).with(result).and_return(now)
      compiler.should_not be_uptodate(source, result)
    end

    it 'is true if source file is older' do
      File.stub(:mtime).with(source).and_return(now - 1)
      File.stub(:mtime).with(result).and_return(now)
      compiler.should be_uptodate(source, result)
    end

  end
end
