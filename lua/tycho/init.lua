-- luacheck: globals unpack vim.api
local nvim = vim.api
local tycho = {}
local utils = require("tycho.utils")

--[[

example usage:

tycho.map{
  ns = ...,
  fn = "myfn",
  args = {"arg", 123}, -- optional
  keys = "<leader>p"
}

--]]
tycho.map = function(obj)
  assert(obj.ns ~= nil and type(obj.ns) == "string", "Must supply a string namespace")
  assert(obj.fn ~= nil and type(obj.fn) == "string", "Must supply the name of the function")
  assert(obj.keys ~= nil and type(obj.keys) == "string", "Must supply keys to be mapped")
  assert(utils.get_qualified(require(obj.ns), obj.fn) ~= nil, "Unable to find function")

  local command = "lua require('" .. obj.ns .. "')." .. obj.fn .. "("
  if obj.args ~= nil and #obj.args >= 0 then
    for _, i in ipairs(obj.args) do
      if type(i) == "string" then
        command = command .. ", '" .. i .. "'"
      else
        command = command .. ", " .. i
      end
    end
  end
  command = command .. ")"

  nvim.nvim_command("map " .. obj.keys .. " <Cmd>" .. command .. "<CR>")
end

_G.tycho = tycho -- HACK: For manual testing. Needs to be removed.
return tycho
