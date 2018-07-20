-- luacheck: globals unpack vim.api
local nvim = vim.api
local cache = {}
local core = {}

core.register = function(namespace, fn)
  rawset(cache, namespace, fn)
end

core.call = function(namespace, ...)
  local fn = cache[namespace]
  return fn(...)
end

core.map = function(namespace, kw, ...)
  local args = {...}
  local command = "'" .. namespace .. "'"
  if #args >= 0 then
    for _, i in ipairs(args) do
      if type(i) == "string" then
        command = command .. ", '" .. i .. "'"
      else
        command = command .. ", " .. i
      end
    end
  end

  nvim.nvim_command("map " .. kw .. " <Cmd>lua tycho.core.call(" .. command .. ")<CR>")
end


return {core, cache}
