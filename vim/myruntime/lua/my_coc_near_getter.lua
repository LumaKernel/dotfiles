local format = function(sym)
  if sym['kind'] == nil then
    return sym['text']
  end

  return sym['text'] .. '[' .. sym['kind'] .. ']'
end

local main = function()
  local ok, m = pcall(require, 'coc-nearest-symbol')
  if not ok then
    return ''
  end
  local ns = m:all_symbols(vim.fn.CocAction('documentSymbols'), m:get_char_pos())
  local txt = ''

  for i=1, #ns do
    if ns[i]['text'] ~= nil then
      if txt == '' then
        txt = format(ns[i])
      else
        txt = txt .. ' > ' .. format(ns[i])
      end
    end
  end

  return txt
end

local wrapped = function()
  return main()
end
--   local ok, value = pcall(main)
--   if ok then
--     return value
--   end
--   return ''
-- end

return wrapped
