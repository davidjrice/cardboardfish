$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'cgi'
require 'uri'


module Cardboardfish
  
  class AuthenticationError < StandardError; end;
  
  HOST = 'sms1.cardboardfish.com'
  PORT = '9001'
  PATH = 'HTTPSMS'

  @@username = nil
  @@password = nil
  
  def self.authenticate(username, password)
    @@username = username
    @@password = password
  end

  def self.sms(options)
    raise AuthenticationError.new("must provide login details first Cardboardfish.authenticate(username, password)") unless @@username && @@password
    http = Net::HTTP.new(HOST, PORT)
    options = defaults.merge!(options)
    options.each_pair do |k,v|
      options[k] = CGI::escape(v)
    end
    uri = "/#{PATH}?S=#{options[:system_type]}&UN=#{@@username}&P=#{@@password}&DR=#{options[:receipt]}&DA=#{options[:destination]}&SA=#{options[:source]}&M=#{options[:message]}";
    STDERR.puts uri
    response = http.start do |http|
      http.get(uri)
    end
  end

  def self.parse(receipt)
    parts = receipt.split("#")
    count = parts.shift
    receipts = []
    parts.each do |p|
      receipts << self.parse_fragment(p)
    end
    return receipts
  end
  
  private

  def self.parse_fragment(part)
    fragments = part.split(":")
    msg = {
      :id => fragments[0],
      :source => fragments[1],
      :destination => fragments[2],
      :status => delivery_receipt_codes[fragments[3]],
      :gsm_status => fragments[4],
      :time => Time.at(fragments[5].to_i),
      :ref => fragments[6]
    }
  end

  def self.delivery_receipt_codes
    codes = {}
    codes["1"]  = "DELIVERED"
    codes["2"]  = "BUFFERED"
    codes["3"]  = "FAILED"
    codes["5"]  = "EXPIRED"
    codes["6"]  = "REJECTED"
    codes["7"]  = "ERROR"
    codes["11"] = "UNKNOWN"
    codes["12"] = "UNKNOWN"
    return codes
  end

  def self.defaults
    defaults = {}
    defaults[:system_type] = 'H'
    defaults[:receipt] = "0"
    return defaults
  end

end