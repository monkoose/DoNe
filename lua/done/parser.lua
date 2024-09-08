local lyaml = require("lyaml")

local parser = {}

local allowed_types = {
   "nil",
   "boolean",
   "number",
   "integer",
   "string",
   "table",
   "function",
}

---Splits string `str` by optional separator `sep`, which defaults to space character
---@param str string
---@param sep? string
---@return string[]
local function splitstr(str, sep)
   if not sep then
      sep = " "
   end

   local result = {}
   for s in string.gmatch(str, "([^" .. sep .. "]+)") do
      table.insert(result, s)
   end
   return result
end

---Appends splitted `desc` to `result` list
---@param desc string
---@param result string[]
local function split_desc(desc, result)
   local t = splitstr(desc, "\n")
   for _, line in ipairs(t) do
      table.insert(result, "---" .. line)
   end
end

---Replaces new line characters `\n` with spaces
---@param desc string
---@return string
local function join_desc(desc)
   local result = desc:gsub("\n", " ")
   return result
end

---@param type_str string
---@return string
local function strip_type(type_str)
   for _, v in ipairs(allowed_types) do
      if type_str:find("^" .. v) then
         return v
      end
   end
   return "any"
end

---Sanitizes provided string with represents type,
---so it can be recognized by `lua_ls` without errors
---@param type_str string|table
---@return string
local function sanitize_type(type_str)
   if not type_str then
      return "any"
   end

   if type(type_str) == "table" then
      local result = {}
      for _, v in ipairs(type_str) do
         table.insert(result, strip_type(v))
      end
      return table.concat(result, "|")
   end

   return strip_type(type_str)
end

---Parses table `t` into `result` list converting script_api fields
---into `lua_ls` @meta annotations
---@param t table
---@param result string[]
---@param parent_module? string
local function parse_table(t, result, parent_module)
   -- get module name
   local module = (parent_module or "") .. t.name
   table.insert(result, "")
   if t.desc then
      table.insert(result, "---" .. t.desc:gsub("\n", " "))
   end
   table.insert(result, t.name .. " = {}")
   module = module .. "."

   -- process members
   for _, m in ipairs(t.members) do
      -- collect functions
      if m.type == "function" then
         local params = {}
         table.insert(result, "")
         split_desc(m.desc, result)
         -- function parameters docstring
         if m.parameters then
            for _, p in ipairs(m.parameters) do
               -- any newline characters in a description on writing file will be splitted
               -- by them, so it results in a lines not prepended with comments, which are
               -- wrong lua files. Replace them with spaces here
               local p_desc = join_desc(p.desc or "")
               -- remove some unwanted characters from p.name, as example `astar` extension
               -- has some parameter names like paramname[optional] etc.
               local p_name = string.match(p.name, "[%w_]+")
               table.insert(
                  result,
                  "---@param " .. p_name .. " " .. sanitize_type(p.type) .. " " .. p_desc
               )
               table.insert(params, p_name)
            end
         end

         -- function return docstring
         if m.returns then
            table.insert(
               result,
               "---@return " .. sanitize_type(m.returns.type) .. " " .. join_desc(m.desc or "")
            )
         end

         -- function examples of usage
         if m.examples then
            for _, e in ipairs(m.examples) do
               table.insert(result, "---")
               table.insert(result, "---  Example:")
               split_desc(e.desc, result)
            end
         end

         -- function module.funcname(param1, param2) end
         table.insert(
            result,
            "function " .. module .. m.name .. "(" .. table.concat(params, ", ") .. ") end"
         )
      -- recurse into tables with combined module name
      elseif m.type == "table" then
         parse_table(m, result, module)
      else -- just collect regular types
         table.insert(result, "")
         if m.desc then
            table.insert(result, "---" .. join_desc(m.desc))
         end
         table.insert(result, "---@type " .. sanitize_type(m.type))
         table.insert(result, module .. m.name .. " = ...")
      end
   end
end

---Converts script_api string into lua_ls @meta annotations
---@param yaml_str string
---@return string?
function parser.convert(yaml_str)
   local tbl = lyaml.load(yaml_str)
   if type(tbl) ~= "table" then
      return
   end

   local result = { "---@meta" }

   for _, t in ipairs(tbl) do
      if t.type == "table" then
         parse_table(t, result)
      end
   end

   return table.concat(result, "\n")
end

return parser
