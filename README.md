# Tycho.nvim

An indirection layer between neovim and idiomatic lua

## Warning

This is highly experminetal and the API is constantly changing.

## Why?

Sometimes it's hard to interop lua and VimL. You have a nice function in lua,
but it's not trivial to map that to a set of keybindings.

Or maybe you're interested in using your function as a handler for asynchronous jobs.

Tycho exists to solve that gap.

Also, take a look at [this issue](https://github.com/Vigemus/tycho.nvim/issues/2) so you can understand a little better.

## Who is this plugin for?

This is a resource for plugin writers that want o use the lua API.
It allows a one to write plugins in lua purely, without needing to think about the interop or viml semantics.

## How do I use it?

```lua
-- Mapping a lua function to a key sequence:
tycho.map{
  ns = ..., -- (unique name of current module)
  fn = "my_function",
  keys = "<leader>q"
}
```

## What comes next

- [ ] Support for jobs
- [ ] Support for commands
- [ ] Support for autocommands

## Why the name?

It is a [visible crater](https://upload.wikimedia.org/wikipedia/commons/e/ea/Lage_des_Mondkraters_Tycho.jpg) on the moon and I thought that'd be a nice analogy for this small gap :)
