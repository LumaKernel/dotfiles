local trim_spaces = function(s)
 return s:match "^%s*(.-)%s*$"
end

local format_simple = function(sym)
  tail = ''
  if sym['kind'] ~= nil then
    tail = ' ' .. sym['kind']
  end

  return '[' .. sym['text'] .. tail .. ']'
end

local format_peek = function(sym)
  if sym['lnum'] == nil then
    return format_simple(sym) or ''
  end

  local tail = ''
  if sym['kind'] ~= nil then
    tail = ' ' .. sym['kind']
  end

  return '[' .. trim_spaces(vim.fn.getline(sym['lnum'])) .. tail .. ']'
end

local format = format_peek

local main = function()
  if not vim.g.coc_enabled then
    return
  end
  local ok, m = pcall(require, 'coc-nearest-symbol')
  if not ok then
    return ''
  end
  local ns = m:all_symbols(vim.fn.CocAction('documentSymbols'), m:get_char_pos())
  local txt = ''
  local last_line

  for i=1, #ns do
    if last_line == nil or last_line ~= ns[i]['lnum'] then
      if txt == '' then
        txt = format(ns[i])
      else
        txt = txt .. '  >  ' .. format(ns[i])
      end
    end
    last_line = ns[i]['lnum']
  end

  return txt
end

local wrapped = function()
  local ok, value = pcall(main)
  if ok then
    return value
  end
  return ''
end

return wrapped
