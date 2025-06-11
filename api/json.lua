--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.10.2

  JSON API documentation

  Manipulation of JSON data strings.
--]]

---@meta
---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field
---@diagnostic disable: args-after-dots

---@class defold_api.json
json = {}

---Represents the null primitive from a json file
json.null = nil

---Decode a string of JSON data into a Lua table.
---A Lua error is raised for syntax errors.
---@param json string json data
---@param options { decode_null_as_userdata:boolean|nil } table with decode options
---
---bool decode_null_as_userdata: wether to decode a JSON null value as json.null or nil (default is nil)
---
---@return table data decoded json
function json.decode(json, options) end

---Encode a lua table to a JSON string.
---A Lua error is raised for syntax errors.
---@param tbl table lua table to encode
---@param options { encode_empty_table_as_object:string } table with encode options
---
---string encode_empty_table_as_object: wether to encode an empty table as an JSON object or array (default is object)
---
---@return string json encoded json
function json.encode(tbl, options) end

return json