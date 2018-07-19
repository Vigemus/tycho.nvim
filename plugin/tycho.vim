function! Tycho(namespace, ch, arg, str)
  exec "lua tycho.core.call('" . a:namespace . "', '" . join(a:arg, "','") . "')"
endfunction

lua tycho.echo = function(a) print(a) end

call jobstart(["echo", "1"], {"on_stdout": function("Tycho", ["echo"])})
