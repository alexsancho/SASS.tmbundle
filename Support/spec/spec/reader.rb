#!/usr/bin/env ruby -wKU
# encoding: utf-8

require File.join(File.dirname(__FILE__), '../spec_helper')

describe Reader do
  before(:each) do
    FILEPATH = File.expand_path(File.join(File.dirname(__FILE__), "../../fixtures", "valid_with_options.sass"))
    
    @sass_reader = Sass::Reader
  end
  
  describe "execution" do
    before(:each) do
      Kernel.stub!(:system).and_return(true)
      
      @status = mock("process status", :exitstatus => 0)
      @sass_engine.stub!(:process_status).and_return(@status)
    end
    
    it "should pipe the output to the engine" do
      #expects
      Kernel.should_receive(:system).with(/#@filename.*sass.*#@flags.*#@output_filename/)
      #when
      @sass_engine.compile_file(FILEPATH, PROJECT)
    end
    
  end  
  
  describe "filenames" do
    it "should require a filename" do
      lambda { SassEngine.new }.should raise_error
    end
  end
end
