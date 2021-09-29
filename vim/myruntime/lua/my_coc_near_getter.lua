local main = function()
  local ok, m = pcall(require, 'coc-nearest-symbol')
  if not ok then
    return ''
  end
  local n = m:nearest_symbol(vim.fn.CocAction('documentSymbols'), m:get_char_pos())
  local near = n['here'] or n['prev'] or n['next']
  if near == nil then
    return ''
  end

  if near['text'] == nil then
    return ''
  end

  if near['kind'] == nil then
    return near['text']
  end

  return near['text'] .. '(' .. near['kind'] .. ')'
end

local wrapped = function()
  local ok, value = pcall(main)
  if ok then
    return value
  end
  return ''
end

return wrapped
