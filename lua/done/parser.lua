local lyaml = require("lyaml")

local M = {}

local allowed_types = {
   "boolean",
   "number",
   "string",
   "table",
   "function",
}

---@param str string
---@param sep string
---@return table
local function splitstr(str, sep)
   if not sep then
      sep = " "
   end
   local t = {}
   for s in string.gmatch(str, "([^" .. sep .. "]+)") do
      table.insert(t, s)
   end
   return t
end

---@param desc string
---@param result table
local function split_desc(desc, result)
   local t = splitstr(desc, "\n")
   for _, line in ipairs(t) do
      table.insert(result, "---" .. line)
   end
end

---@param desc string
---@return string
local function join_desc(desc)
   local result = desc:gsub("\n", " ")
   return result
end

---@param t string
---@return string
local function strip_type(t)
   for _, v in ipairs(allowed_types) do
      if t:find("^" .. v) then
         return v
      end
   end
   return "any"
end

---@param t string|table
---@return string
local function sanitize_type(t)
   if not t then
      return "any"
   end

   if type(t) == "table" then
      local result = {}
      for _, v in ipairs(t) do
         table.insert(result, strip_type(v))
      end
      return table.concat(result, "|")
   end

   return strip_type(t)
end

---@param t table
---@param result table
---@param parent_name? string
local function parse_table(t, result, parent_name)
   local name = (parent_name or "") .. t.name
   table.insert(result, "")
   if t.desc then
      table.insert(result, "---" .. t.desc:gsub("\n", " "))
   end
   table.insert(result, t.name .. " = {}")
   name = name .. "."

   -- parse members
   for _, m in ipairs(t.members) do
      if m.type == "function" then
         local params = {}
         table.insert(result, "")
         split_desc(m.desc, result)
         if m.parameters then
            for _, p in ipairs(m.parameters) do
               local p_desc = join_desc(p.desc or "")
               -- remove some unwanted characters from p.name, as example `astar` has some
               -- parameter names like paramname[optional] etc.
               local p_name = string.match(p.name, "[%w_]+")
               table.insert(
                  result,
                  "---@param " .. p_name .. " " .. sanitize_type(p.type) .. " " .. p_desc
               )
               table.insert(params, p_name)
            end
         end

         if m.returns then
            table.insert(
               result,
               "---@return " .. sanitize_type(m.returns.type) .. " " .. join_desc(m.desc or "")
            )
         end

         if m.examples then
            for _, e in ipairs(m.examples) do
               table.insert(result, "---")
               table.insert(result, "---  Example:")
               split_desc(e.desc, result)
            end
         end

         table.insert(
            result,
            "function " .. name .. m.name .. "(" .. table.concat(params, ", ") .. ") end"
         )
      elseif m.type == "table" then
         parse_table(m, result, name)
      else
         table.insert(result, "")
         if m.desc then
            table.insert(result, "---" .. join_desc(m.desc))
         end
         table.insert(result, "---@type " .. sanitize_type(m.type))
         table.insert(result, name .. m.name .. " = ...")
      end
   end
end

---@param yaml_str string
---@return string|nil, string|nil
function M.convert(yaml_str)
   local tbl = lyaml.load(yaml_str)
   if type(tbl) ~= "table" then
      return nil, "Invalid script_api file"
   end

   local result = { "---@meta" }

   for _, t in ipairs(tbl) do
      if t.type == "table" then
         parse_table(t, result)
      end
   end

   return table.concat(result, "\n"), nil
end

return M
