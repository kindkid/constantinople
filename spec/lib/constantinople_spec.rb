describe Constantinople do

  before(:all) do
    CONSTANTINOPLE.spec.a.should == 'default' # just showing we do auto-load

    ENV['RAILS_ENV'] ||= 'test'
    CONFIG = Constantinople.reload!
  end
  
  it "just works" do
    CONFIG.should_not be_nil
    CONFIG.spec.should_not be_nil
    CONFIG.spec.a.should == 'default'
    CONFIG.spec.b.should == 'standard'
    CONFIG.spec.c.should == 'override'
    CONFIG.spec.monkey.should == 'banana'
    CONFIG.spec.test.monkey.should == 'test-banana'
    CONFIG.spec.animal.should == 'turtle' # from test environment
    CONFIG.empty.should be_empty
  end

  describe "ignore files" do
    it "should read .ymlignore if it exists" do
      Constantinople.send(:files_to_ignore, "spec/config").should == ['error.yml']
    end

    it "should not bother reading error.yml" do
      lambda {
        CONFIG.error
      }.should raise_exception
    end
  end
end