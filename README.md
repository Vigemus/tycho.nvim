# Tycho.nvim

An indirection layer between neovim and idiomatic lua

## Warning

This is highly experminetal and the API is constantly changing.

## Why?

Sometimes it's hard to interop lua and VimL. You have a nice function in lua,
but it's not trivial to map that to a set of keybindings.

Or maybe you're interested in using your function as a handler for asynchronous jobs.

Tycho exists to solve that gap.

## How?

Tycho has three APIs:

### The formal API (aka. core)

This is the actual implementation of how tycho talks to neovim.
All the other implementations are a matter of taste and were build on top of this one:
```lua
local tycho = require("tycho")

-- Register your function
tycho.core.register("my_awesome_function", function()
  print("Hello from Tycho!")
end)

-- Add the mapping in neovim
tycho.core.map("my_awesome_function", "<Space>!")

-- With arguments
tycho.core.register("another_function", function(t, msg)
  for i = t, 0, -1 do
    print(msg)
  end
end)

tycho.core.map("another_function", "<Space><CR>", 10, 'Mapped with arguments")

```

### The sugared version

This is an attempt to make the api fluid and hide the integration bits.
```lua
local tycho = require("tycho")

-- Directly assign to tycho table to register the function
tycho.my_awesome_function = function()
  print("Hello from Tycho!")
end

-- A more complex example
tycho.another_function = function(t, msg)
  for i = t, 0, -1 do
    print(msg)
  end
end

-- You map passing the assigned object
tycho.api.map("<Space>!", tycho.my_awesome_function)

-- You can also map anonymous functions
tycho.api.map("<Space>!", function()
  print("Hello from Tycho!")
end)

local my_fn = function(a, b)
  print(a + b)
end

-- But you can't pass arguments to it
tycho.api.map("<Space><CR>", function()
  my_fn(12, 30)
end)
```


## What comes next

- [ ] Support for jobs
- [ ] Support for commands
- [ ] Support for autocommands

## Why the name?

It is a [visible crater](https://upload.wikimedia.org/wikipedia/commons/e/ea/Lage_des_Mondkraters_Tycho.jpg) on the moon and I thoght that'd be a nice analogy to this small gap :)
