local utils = {}

utils.get = function(d, k)
  return d and d[k]
end

utils.get_in = function(d, k)
  local p = d
  for _, i in ipairs(k) do
    p = utils.get(p, i)
  end

  return p
end

utils.get_qualified = function(d, p)
  local buff = {}
  p:gsub("([^.]+)", function(i) table.insert(buff, i) end)
  return utils.get_in(d, buff)
end

return utils
