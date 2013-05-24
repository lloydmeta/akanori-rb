# encoding: utf-8

$:.push('./lib')

require 'trend_thrift_server'
require 'benchmark'

begin
  port = ARGV[0] || 9090

  transport = Thrift::BufferedTransport.new(Thrift::Socket.new('localhost', port))
  protocol = Thrift::BinaryProtocol.new(transport)
  client = TrendServer::Gen::TrendThriftServer::Client.new(protocol)

  transport.open

  # while true do
  Benchmark.bm(10) do |x|
    x.report("Getting current trends from z server"){
      puts
      client.currentTrends.each do |trend|
        puts "Trend #{trend.term} has score #{trend.termScore}"
      end
    }
  end

rescue
  puts $!
end