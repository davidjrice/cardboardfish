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

  private

  def self.defaults
    defaults = {}
    defaults[:system_type] = 'H'
    defaults[:receipt] = "0"
    return defaults
  end

end