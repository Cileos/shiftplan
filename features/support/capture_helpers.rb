def capture_quoted
  /"([^"]+)"/
end

def capture_cell
  %r~(cell "[^"]+"/"[^"]+")~
end
