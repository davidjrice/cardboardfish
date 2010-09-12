$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'cgi'
require 'uri'


module Cardboardfish
  
  HOST = 'sms1.cardboardfish.com'
  PORT = '9001'
  PATH = '/HTTPSMS'

  def self.sms(options)
    http = Net::HTTP.new(HOST, PORT)
    options = defaults.merge!(options)
    options.each_pair do |k,v|
      options[k] = CGI::escape(v)
    end
    uri = "/#{PATH}?S=#{options[:system_type]}&UN=#{options[:username]}&P=#{options[:password]}&DA=#{options[:destination]}&SA=#{options[:source]}&M=#{options[:message]}";
    STDERR.puts uri
    response = http.start do |http|
      http.get(uri)
    end
  end

  private

  def self.defaults
    defaults = {}
    defaults[:system_type] = 'H'
    return defaults
  end

end