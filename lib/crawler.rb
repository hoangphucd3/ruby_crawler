require 'benchmark'

modules = ARGV[0].split(',') rescue []

if modules.size.zero?
  puts 'Missing module list'
  exit(1)
end


