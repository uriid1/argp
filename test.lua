#!/bin/env lua

-- ./test.lua --ports 80,443,8080 --threads 4 --verbose
-- ./test.lua --ports=80,443,8080 --threads=4 --verbose
-- ./test.lua -v
-- ./test.lua --help

local argp = require('argp')

local parser = argp:new({
  name = 'mytool',
  description = 'Example utility demonstrating GNU-style argument parsing.',
  version = '1.0',
  epilog = 'Report bugs to <dev@example.com>.'
})

parser:options({
  {
    short = 'h',
    long = 'help',
    description = 'Display this help and exit',
    count_params = 0
  },
  {
    short = 'v',
    long = 'verbose',
    description = 'Increase verbosity level',
    count_params = 0
  },
  {
    long = 'threads',
    description = 'Number of worker threads',
    type = 'number',
    count_params = 1
  },
  {
    long = 'ports',
    description = 'List of TCP ports',
    type = 'number', count_params = '*'
  }
})

local args = parser:parse(arg)

if args.help then
  parser:print_system_help()
end

if args.ports then
  print('Ports: ', table.concat(args.ports, ', '))
end

if args.threads then
  print('Threads: ', args.threads)
end

if args.verbose then
  print('Is versobe: ', args.verbose)
end
