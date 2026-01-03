---Serializes a value to a Lua string representation.
---Supports numbers, booleans, strings, and tables (with string/number/boolean keys).
---Returns nil and an error message on unsupported types or invalid keys.
---@param o any The value to serialize.
---@return string|nil result The serialized string, or nil on error.
---@return string|nil error Error message if serialization failed.
---@nodiscard
local function serialize(o)
  local t = type(o)

  if t == "number" or t == "boolean" then
    return tostring(o)
  elseif t == "string" then
    return string.format("%q", o)
  elseif t == "table" then
    local entries = {}

    for k, v in pairs(o) do
      -- Serialize key
      local keyResult, keyError = serialize(k)
      if not keyResult then
        return nil, "Invalid table key: " .. keyError
      end

      -- Serialize value
      local valueResult, valueError = serialize(v)
      if not valueResult then
        return nil, "Invalid table value: " .. valueError
      end

      table.insert(entries, "[" .. keyResult .. "]=" .. valueResult)
    end

    return "{" .. table.concat(entries, ",") .. "}"
  else
    return nil, "Cannot serialize type: " .. t
  end
end

---Serializes a table to a Lua code string.
---@param list table The table to serialize.
---@return string|nil result The serialized string, or nil on error.
---@return string|nil error Error message if serialization failed.
---@nodiscard
function table.serialize(list)
  return serialize(list)
end

---Saves a table to a file as executable Lua code (`return { ... }`).
---@param filename string The file path to write.
---@param list table The table to save.
---@return string|nil error Error message if failed, otherwise `nil`.
---@nodiscard
function table.save(filename, list)
  local file, error = io.open(filename, "w")

  if file then
    local result, serializeError = table.serialize(list)

    if serializeError then
      return serializeError
    else
      file:write("return ", result)
      file:close()
    end
  end

  return error
end

---Loads a table from a file created by `table.save`.
---The file must contain `return { ... }`.
---@param filename string The file path to load.
---@return table list The loaded table (empty table on error).
---@return string|nil error Error message if failed, otherwise `nil`.
---@nodiscard
function table.load(filename)
  local fn, error = loadfile(filename)
  local list = {}

  if fn then
    local success, result = pcall(fn)

    if not success then
      error = result
    elseif type(result) == "table" then
      list = result
    else
      error = filename .. " did not return a table."
    end
  end

  return list, error
end
