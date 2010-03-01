require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "PartOfSpeech" do
  it "should properly tag 'the fast fox'" do
    a = PartOfSpeech.analyze('the fast fox')
    a[0][1].should == "DT"
    a[1][1].should == "RB"
    a[2][1].should == "NN"
  end
end
