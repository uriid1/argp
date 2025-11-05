🇺🇸 English | 🇷🇺 [Russian](README_RU.md)</br>

# Lightweight GNU-style Argument Parser

A minimalist command-line argument parser compatible with **GNU Tools** style.  
It supports short and long options, `=` assignments, multiple arguments, and generates help output in classic GNU format.

---

## 🚀 Features

- Supports short (`-v`) and long (`--verbose`) options  
- Allows `=` syntax for arguments: `--threads=4`  
- Parses comma-separated values: `--ports=80,443,8080`  
- Supports fixed (`count_params = n`) or unlimited (`count_params = '*'`) number of arguments  
- Type checking (`string`, `number`)  
- Automatic help generation in GNU style (`argp:print_system_help()`)  
- LDOC documentation support  

---

## 📦 Installation

Via **Luarocks**:

```bash
luarocks install argp
```

Or include it manually as a module:

```lua
local argp = require('argp')
```

---

## 🧩 Usage Example

```lua
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
    type = 'number',
    count_params = '*'
  }
})

local args = parser:parse(arg)

if args.help then
  parser:print_system_help()

elseif args.ports then
  -- handle ports

elseif args.threads then
  -- handle threads

elseif args.verbose then
  -- handle verbose mode
end

for k, v in pairs(args) do
  print(k, v)
end
```

---

## 🧠 Example Help Output

```
Usage: mytool [OPTION...]

Example utility demonstrating GNU-style argument parsing.

Options:
  -h, --help           Display this help and exit
  -v, --verbose        Increase verbosity level
  --threads            Number of worker threads
  --ports              List of TCP ports

Report bugs to <dev@example.com>.
```

---

## ⚙️ Error Messages (GNU-style)

```
mytool: option ‘--threads’: numeric value expected, got “abc”
mytool: option ‘--ports’: too many arguments
mytool: unrecognized option ‘--wrong’
mytool: option ‘-v’ does not take a value
```

---

## 🧾 LDOC

To generate documentation:

```bash
ldoc -s '!new' -d ldoc argp.lua
```
