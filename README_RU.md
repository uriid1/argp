🇷🇺 Russian | 🇺🇸 [English](README_EN.md)</br>

# Lightweight GNU-style Argument Parser

Минималистичный парсер аргументов командной строки, совместимый со стилем **GNU Tools**.  
Поддерживает короткие и длинные опции, значения через `=` или через пробел, множественные аргументы, а также вывод справки в классическом формате.

---

## Возможности

- Поддержка коротких (`-v`) и длинных (`--verbose`) опций
- Возможность передачи параметров через `=` или пробел: `--threads=4` или `--threads 4`
- Обработка нескольких значений через запятую: `--ports=80,443,8080` или `--ports 80,443,8080`
- Поддержка ограниченного (`count_params = n`) или произвольного (`count_params = '*'`) количества аргументов
- Проверка типов (`string`, `number`)
- Автоматическая генерация справки в стиле GNU (`argp:print_system_help()`)
- LDOC-документация

---

## Установка

Luarocks:

```bash
luarocks intsall argp
```

или подключите как модуль:

```lua
local argp = require('argp')
```

---

## Пример использования

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
```

---

## Пример вывода справки

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

## Сообщения об ошибках

```
mytool: option ‘--threads’: numeric value expected, got “abc”
mytool: option ‘--ports’: too many arguments
mytool: unrecognized option ‘--wrong’
mytool: option ‘-v’ does not take a value
```

---

## LDOC

Для генерации документации:

```bash
ldoc -s '!new' -d ldoc argp.lua
```
