require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Cardboardfish" do
  
  it "should parse a single receipt" do
    fixture = {
      :id => "361520192",
      :source => "Jane",
      :destination => "353868442660",
      :status => "FAILED",
      :gsm_error_code => "000",
      #:time => Time.new("Thu, 04 Nov 2010 03:44:01 GMT +00:00"),
      :ref => nil
    }
    receipts = Cardboardfish.parse("1#361520192:Jane:353868442660:3:000:1288842241::")
    receipts.kind_of?(Array).should be_true
    
    receipt = receipts.first

    receipt[:id].should == fixture[:id]
    receipt[:source].should == fixture[:source]
    receipt[:destination].should == fixture[:destination]
    receipt[:status].should == fixture[:status]
    receipt[:gsm_error_code].should == fixture[:gsm_error_code]
    receipt[:ref].should == fixture[:ref]
  end
end
