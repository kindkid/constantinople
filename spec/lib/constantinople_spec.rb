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
    CONFIG.spec.animal.should == 'turtle' # from test environment
  end
end