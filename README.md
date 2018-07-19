# Tycho.nvim

An indirection layer between neovim and idiomatic lua

## Why?

Sometimes it's hard to interop lua and VimL. You have a nice function in lua,
but it's not trivial to map that to a set of keybindings.

Or maybe you're interested in using your function as a handler for asynchronous jobs.

Tycho exists to solve that gap.

## How?

Tycho has two APIs:

### The formal API

This is the explicit version:
```lua
-- Note that I'm calling the API member
local tycho = require("tycho").api

-- Register your function
tycho.register("my_awesome_function", function()
  print("Hello from Tycho!")
end)

-- Add the mapping in neovim
tycho.map("my_awesome_function", "<Space>!")

-- With arguments
tycho.register("another_function", function(t, msg)
  for i = t, 0, -1 do
    print(msg)
  end
end)

tycho.map("another_function", "<Space><CR>", 10, 'Mapped with arguments")

```

### The sugared version

This is an attempt to make the API more fluid:
```lua
-- This one uses the root object
local tycho = require("tycho")

-- Directly assign to tycho table to register the function
tycho.my_awesome_function = function()
  print("Hello from Tycho!")
end

-- If no arguments, can be a String
tycho.my_awesome_function.map = "<Space>!"

-- A more complex example
tycho.another_function = function(t, msg)
  for i = t, 0, -1 do
    print(msg)
  end
end

-- For multiple arguments, a table is needed
tycho.another_function.map = {"<Space><CR>", 10, 'Mapped with arguments"}
```


## What comes next

- [ ] Support for jobs
- [ ] Support for commands
- [ ] Support for autocommands

## Why the name?

It is a [visible crater](https://upload.wikimedia.org/wikipedia/commons/e/ea/Lage_des_Mondkraters_Tycho.jpg) on the moon and I thoght that'd be a nice analogy to this small gap :)
