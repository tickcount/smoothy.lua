# smoothy.lua
This library gives you the ability to create easings providing unique and friendly functionality.

## Example
```Lua
local smoothy = require 'smoothy'

-- create smoothy object
local number = smoothy.new(0)
local table = smoothy.new({ 0, 3, 5, 1, 6 })
local table2 = smoothy.new({ var1 = 1, var2 = 50 })

events.render(function()
  -- update values
  local number_output = number(0.5, 1000)
  local table_output = table(0.15, { 70, 50, nil, 35, 6 })
  local table2_output = table2(0.25, { var1 = 50, var2 = 0 })

  -- print
  print('number: ', number_output)
  print('table: ', table.concat(table_output, ' ')))
  print('table2: ', table2_output.var1, ' ', table_output.var2)

  -- getting values (alternative way)
  print(number.value)
  print(table.value[1], ...)
  print(table2.value.var1, ...)
end)
```

## Documentation
**`smoothy.new(default_value, easing_function)`**

- **default_value**: Default value (can either be a number or a table of numbers)
- (optional) **easing_function**: Easing function.

**`smoothy_object(duration, value, easing_function)`**

**`smoothy_object:update(duration, value, easing_function)`**

- **duration**: An amount of time to interpolate from one value to another
- **value**: A number or a table of numbers to interpolate to
- (optional) **easing_function**: Easing function.

**smoothy_object.value**
- Current smoothy value
---
