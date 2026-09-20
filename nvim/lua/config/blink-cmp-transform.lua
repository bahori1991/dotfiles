-- =====================================================================================================
-- TITLE: blink-cmp-transform
-- ABOUT: Custom transform-items helpers for blink.cmp
-- =====================================================================================================

local M = {}

local function single_to_double_quoted(text)
  if type(text) ~= "string" then
    return text
  end
  local inner = text:match("^'(.+)'$")
  if inner then
    return '"' .. inner .. '"'
  end
  return text
end

local function transform_item(item)
  if item.textEdit and item.textEdit.newText then
    item.textEdit.newText = single_to_double_quoted(item.textEdit.newText)
  end
  if item.insertText then
    item.insertText = single_to_double_quoted(item.insertText)
  end
  item.label = single_to_double_quoted(item.label)
  return item
end

function M.single_to_double_quoted(_, items)
  for i, item in ipairs(items) do
    items[i] = transform_item(item)
  end
  return items
end

return M
