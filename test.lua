--- Test
--
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

elseif args.ports then
  -- pass

elseif args.threads then
  -- pass

elseif args.verbose then
  -- pass
end

for k, v in pairs(args) do
  print(k, v)
end
