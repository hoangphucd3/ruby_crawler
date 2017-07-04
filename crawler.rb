require 'benchmark'
require_relative 'lib/crawler'

modules = ARGV[0].split(',') rescue []

if modules.size.zero?
  puts 'Missing module list'
  exit(1)
end

c = Crawler::Main.new(modules)

real = Benchmark.measure { c.run }.real
puts "---- Time taken total: #{'%0.2f' % real}s"


