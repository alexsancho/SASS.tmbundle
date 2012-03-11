require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Reader" do
  describe "execution" do    
    it "should pipe the output to the engine" do
		reader = SASS::Reader::compile_file(FILEPATH, PROJECT)
		reader.should_not match(/Converting/), "expected success message, got #{reader.inspect}"
    end

  end

end
