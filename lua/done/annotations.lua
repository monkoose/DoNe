local parser = require("done.parser")

local sha1 = require("sha1").sha1
local zip = require("zip")

local fs = vim.fs
local fn = vim.fn

local M = {}

---@diagnostic disable-next-line: param-type-mismatch
local cache_dir = fs.joinpath(fn.stdpath("cache"), "DoNe")

local function get_game_project()
   return fs.find("game.project", { upward = true, stop = "home", type = "file" })[1]
end

local function get_dependencies(gp)
   local dependencies = {}
   for line in io.lines(gp) do
      local found, _, url = line:find("^dependencies#%d+%s*=%s*(.*)$")
      if found then
         dependencies[sha1(url)] = url
      end
   end

   return dependencies
end

local function unzip_dependency(zip_file)
   local zfile = zip.open(zip_file)
   if not zfile then
      vim.notify("Aborted: can't unzip dependency " .. zip_file, vim.log.levels.ERROR)
      return
   end

   local dirs = {}
   for t in zfile:files() do
      local f = t.filename
      if f:find("game.project$") then
         local gp = zfile:open(f)
         if not gp then
            vim.notify("Aborted: can't unzip dependency " .. zip_file, vim.log.levels.ERROR)
            return
         end
         local pos, _, names = gp:read("*a"):find("%[library%]\ninclude_dirs%s*=%s*([^\n]*)")
         if not pos then
            vim.notify("No include_dirs in dependency game.project", vim.log.levels.WARN)
            gp:close()
            return
         end

         dirs = vim.split(names, " ", { trimempty = true })
         gp:close()
         break
      end
   end

   zfile:close()
   zfile = zip.open(zip_file)

   for t in zfile:files() do
      local f = t.filename
      for _, dir in ipairs(dirs) do
         local pos, _, lua_file_path = f:find("/(" .. dir .. "/.*%.lua)$")
         if pos then
            local lua_file = zfile:open(f)
            local lua_file_content = lua_file:read("*a")
            lua_file:close()

            local path = fs.joinpath(cache_dir, lua_file_path)
            vim.fn.mkdir(fs.dirname(path), "p")
            local cache_file = io.open(path, "w+")
            if not cache_file then
               vim.notify(
                  "Aborted: can't create cache file " .. lua_file_path,
                  vim.log.levels.ERROR
               )
               return
            end

            cache_file:write(lua_file_content)
            cache_file:close()
         end

         local script_api_name
         pos, _, script_api_name = f:find("([^/]*)%.script_api$")
         if pos then
            local script_api_file = zfile:open(f)
            local yaml_str = script_api_file:read("*a")
            script_api_file:close()

            local meta_str, err = parser.convert(yaml_str)
            if err then
               vim.notify(err, vim.log.levels.ERROR)
               return
            end

            local path = fs.joinpath(cache_dir, dir)
            local meta_path = fs.joinpath(path, "_meta_" .. script_api_name .. ".lua")
            vim.fn.mkdir(path, "p")

            local meta_file = io.open(meta_path, "w+")
            if not meta_file then
               vim.notify("Aborted: can't create meta file " .. meta_path, vim.log.levels.ERROR)
               return
            end

            meta_file:write(meta_str)
            meta_file:close()
         end
      end
   end
   zfile:close()
end

function M.clean()
   if fn.isdirectory(cache_dir) == 1 then
      fn.delete(cache_dir, "rf")
   end
end

function M.unpack()
   local gp = get_game_project()
   if not gp then
      vim.notify("Aborted: game.project not found", vim.log.levels.ERROR)
      return
   end

   if fn.filereadable(gp) == 0 then
      vim.notify("Aborted: can't read game.project", vim.log.levels.ERROR)
      return
   end

   local dependencies = get_dependencies(gp)
   if not dependencies then
      return
   elseif vim.tbl_isempty(dependencies) then
      vim.notify("Project has no dependencies", vim.log.levels.WARN)
      return
   end

   local internal_lib = fs.joinpath(fs.dirname(gp), ".internal", "lib")
   if not fn.isdirectory(internal_lib) then
      vim.notify(
         "Aborted: '.internal' directory not found, try to fetch libraries",
         vim.log.levels.ERROR
      )
      return
   end

   if fn.isdirectory(cache_dir) == 0 then
      fn.mkdir(cache_dir)
   end

   for f, ty in fs.dir(internal_lib) do
      if ty == "file" and f:find("%.zip$") and dependencies[f:sub(1, 40)] then
         unzip_dependency(fs.joinpath(internal_lib, f))
      end
   end
end

return M
