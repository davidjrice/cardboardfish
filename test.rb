require 'lib/cardboardfish'
options = {:username => 'safetextcbf', :password => 'september009', :source => '+447590538303', :destination => '+447590538303', :message => 'HELLOOOOO FROM CBF'}
response = Cardboardfish.sms(options)

STDERR.puts response.inspect
