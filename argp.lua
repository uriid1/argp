--- Argument parser similar to GNU-style CLI tools
-- @module argp
local argp = {}

--- Create a new argument parser instance
-- @param config (table) containing `name`, `description`, `version`, and optional `epilog`
-- @return parser instance
function argp:new(config)
  local instance = {
    name = config.name,
    description = config.description,
    version = config.version,
    epilog = config.epilog,
    _options = {},
    _options_map = {}
  }

  setmetatable(instance, { __index = self })
  return instance
end

--- Add single option
-- @param[optchain] opt (table) option definition with keys
--  @param opt.short (string) Short form (e.g. `'v'` for `-v`)
--  @param opt.long (string) Long form (e.g. `'verbose'` for `--verbose`)
--  @param opt.description (string) Option description for help text
--  @param opt.type (string) Expected type: `'string'` or `'number'`
--  @param opt.count_params (number|string) Number of expected comma-separated params, or `'*'` for unlimited
--  @param opt.dest (string) Optional key name in parsed table
function argp:add_option(opt)
  local option = {
    short = opt.short,
    long = opt.long,
    description = opt.description,
    type = opt.type or 'string',
    count_params = opt.count_params or 0,
    dest = opt.dest or opt.long or opt.short
  }

  if option.short then
    self._options_map[option.short] = option
  end
  if option.long then
    self._options_map[option.long] = option
  end
  table.insert(self._options, option)
end

--- Add multiple options
-- @param opts (table) List of options
function argp:options(opts)
  for i = 1, #opts do
    self:add_option(opts[i])
  end
end

--- Internal
--
local function typeConverter(__type, value)
  if __type == 'number' then
    return tonumber(value)
  elseif __type == 'boolean' then
    return value == 'true'
  elseif __type == 'string' then
    return tostring(value)
  end
end

--- Internal
--
function argp:parse_comma_values(values_str, opt)
  local max_count = opt.count_params == '*' and math.huge or opt.count_params
  local count = 0
  local values = {}

  for part in values_str:gmatch('[^,]+') do
    local convertedValue = typeConverter(opt.type, part)
    if convertedValue then
      table.insert(values, convertedValue)
    else
      error(('%s: option ‘--%s’: %s value expected, got “%s”'):format(
        self.name, opt.dest, opt.type, part))
    end

    count = count + 1
    if count > max_count then
      error(('%s: option ‘--%s’: too many arguments'):format(self.name, opt.dest))
    end
  end

  return values
end

--- Internal
--
function argp:parse_short_or_long(arg, type)
  local re
  if type == 'long' then
    re = '^%-%-([^=]+)=?(.*)'
  elseif 'short' then
    re = '^%-([^=]+)=?(.*)'
  end

  local name, value = arg:match(re)
  local opt = self._options_map[name]

  if opt == nil then
    error(('%s: unrecognized option ‘-%s’'):format(self.name, name))
  end

  if opt.count_params == 0 then
    if value ~= '' or value == nil then
      error(('%s: option ‘-%s’ does not take a value'):format(self.name, name))
    end

    return opt.dest, true
  elseif opt.count_params == 1 then
    if value ~= nil and value == '' then
      error(('%s: option ‘-%s’ requires an argument'):format(self.name, name))
    end

    local convertedValue = typeConverter(opt.type, value)
    if convertedValue == nil then
      error(('%s: option ‘--%s’: %s value expected, got “%s”'):format(
        self.name, opt.dest, opt.type, value))
    end

    return opt.dest, convertedValue
  else
    if value == nil or value == '' then
      error(('%s: option ‘-%s’ requires an arguments'):format(self.name, name))
    end

    return opt.dest, self:parse_comma_values(value, opt)
  end
end

--- Internal
--
function argp:parse(args)
  args = args or arg or {}

  local result = {}

  for i = 1, #args do
    local current = args[i]

    -- Long options like --option or --option=value,...
    if current:find('^%-%-') then
      local dest, value = self:parse_short_or_long(current, 'long')
      result[dest] = value

    -- Short options like -o or -o=value,...
    elseif current:find('^%-') then
      local dest, value = self:parse_short_or_long(current, 'short')
      result[dest] = value
    end
  end

  return result
end

--- Print program help text in GNU style
-- Displays usage, description, options, and epilog
function argp:print_system_help()
  io.write(('Usage: %s [OPTION...]\n'):format(self.name))

  if self.description and #self.description > 0 then
    io.write('\n' .. self.description .. '\n')
  end

  io.write('\nOptions:\n')
  for _, opt in ipairs(self._options) do
    local forms = {}
    if opt.short then
      table.insert(forms, '-' .. opt.short)
    end
    if opt.long then
      table.insert(forms, '--' .. opt.long)
    end

    local left = table.concat(forms, ', ')
    io.write(('  %-20s %s\n'):format(left, opt.description))
  end

  if self.epilog and #self.epilog > 0 then
    io.write('\n' .. self.epilog .. '\n')
  end

  os.exit(0)
end

return argp
