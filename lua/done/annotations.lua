local parser = require("done.parser")

local sha1 = require("sha1").sha1
local zip = require("zip")

local fs = vim.fs
local fn = vim.fn

---@alias sha string sha1 hash string
---@alias filepath string

local annotations = {}

---@type filepath
---@diagnostic disable-next-line: param-type-mismatch
local done_cache_dir = fs.joinpath(fn.stdpath("cache"), "DoNe")

---Returns path to the game.project file, if it doesn't exist returns `nil`
---@return filepath?
local function get_game_project()
   return fs.find("game.project", { upward = true, stop = "home", type = "file" })[1]
end

---Returns a table of dependencies from `game.project`
---@param gp filepath Path to the `game.project` file
---@return table<sha, url>
local function get_dependencies(gp)
   local dependencies = {}
   for line in io.lines(gp) do
      local _, _, url = line:find("^dependencies#%d+%s*=%s*(.*)$")
      if url then
         dependencies[sha1(url)] = url
      end
   end

   return dependencies
end

---Returns `include_dirs` of the dependency archive
---@param zip_file filepath Path to the dependency archive
---@return string[]?
local function get_dep_include_dirs(zip_file)
   local zfile = zip.open(zip_file)
   if not zfile then
      zfile:close()
      return
   end

   for t in zfile:files() do
      local f = t.filename
      if f:find("game.project$") then
         local gp = zfile:open(f)
         if not gp then
            zfile:close()
            return
         end

         local _, _, names = gp:read("*a"):find("%[library%]\ninclude_dirs%s*=%s*([^\n]*)")
         gp:close()
         zfile:close()

         if not names then
            return
         end

         return vim.split(names, " ", { trimempty = true })
      end
   end

   zfile:close()
   return {}
end

---Unzips lua files from zip archive and stores them in cache
---Also unzips script_api files, converts them to @meta annotations and stores them in cache
---@param zip_file filepath
---@param url url
local function unzip_dependency(zip_file, url)
   local include_dirs = get_dep_include_dirs(zip_file)
   if not include_dirs then
      vim.notify(
         "Can't retrieve 'include_dirs' of the dependency '" .. url .. "'",
         vim.log.levels.ERROR
      )
      return
   -- NOTE: is it redundant? can dependencies be without include_dirs?
   elseif vim.tbl_isempty(include_dirs) then
      vim.notify("Dependency '" .. url .. "' has no 'include_dirs'", vim.log.levels.WARN)
      return
   end

   local zfile = zip.open(zip_file)

   for t in zfile:files() do
      local f = t.filename
      for _, dir in ipairs(include_dirs) do
         -- unpack lua files
         local _, _, lua_file_path = f:find("/(" .. dir .. "/.*%.lua)$")
         if lua_file_path then
            local lua_file = zfile:open(f)
            local lua_file_content = lua_file:read("*a")
            lua_file:close()

            local path = fs.joinpath(done_cache_dir, lua_file_path) --[@as filepath]
            vim.fn.mkdir(fs.dirname(path), "p")
            local cache_file = io.open(path, "w+")
            if not cache_file then
               vim.notify(
                  "Error while unpacking '" .. lua_file_path .. "'. Skipped",
                  vim.log.levels.ERROR
               )
               return
            end

            cache_file:write(lua_file_content)
            cache_file:close()
         end

         -- convert script_api files to lua_ls @meta
         local script_api_name
         _, _, script_api_name = f:find("([^/]*)%.script_api$")
         if script_api_name then
            local script_api_file = zfile:open(f)
            local yaml_str = script_api_file:read("*a")
            script_api_file:close()

            local meta_str = parser.convert(yaml_str)
            if not meta_str then
               vim.notify(
                  "Invalid script_api file: '" .. f .. "' of the dependency '" .. url .. "'",
                  vim.log.levels.ERROR
               )
               return
            end

            local path = fs.joinpath(done_cache_dir, dir)
            local meta_path = fs.joinpath(path, "_meta_" .. script_api_name .. ".lua") --[@as filepath]
            vim.fn.mkdir(path, "p")

            local meta_file = io.open(meta_path, "w+")
            if not meta_file then
               vim.notify("Can't create meta file '" .. meta_path .. "'", vim.log.levels.ERROR)
               return
            end

            meta_file:write(meta_str)
            meta_file:close()
         end
      end
   end

   zfile:close()
end

---Cleans the cache directory where annotations are stored
function annotations.clean()
   if fn.isdirectory(done_cache_dir) == 1 then
      fn.delete(done_cache_dir, "rf")
   end
   vim.notify("Annotations cache has been cleaned", vim.log.levels.INFO)
end

---Unpacks annotations for all dependencies and stores them in cache
function annotations.unpack()
   local gp = get_game_project()
   if not gp or fn.filereadable(gp) == 0 then
      vim.notify("File 'game.project' not found", vim.log.levels.ERROR)
      return
   end

   local dependencies = get_dependencies(gp)
   if vim.tbl_isempty(dependencies) then
      vim.notify("Project has no dependencies", vim.log.levels.WARN)
      return
   end

   local internal_lib = fs.joinpath(fs.dirname(gp), ".internal", "lib") --[[@as filepath]]
   if not fn.isdirectory(internal_lib) then
      vim.notify(
         "Directory '.internal' not found in project's root, try to fetch libraries first with `:DoNe fetch`",
         vim.log.levels.ERROR
      )
      return
   end

   if fn.isdirectory(done_cache_dir) == 0 then
      fn.mkdir(done_cache_dir)
   end

   for f, type_ in fs.dir(internal_lib) do
      if type_ == "file" and f:find("%.zip$") then
         local dep_url = dependencies[f:sub(1, 40)]
         if dep_url then
            local dep_zip_file = fs.joinpath(internal_lib, f) --[[@as filepath]]
            unzip_dependency(dep_zip_file, dep_url)
         end
      end
   end

   vim.notify("Annotations have been unpacked", vim.log.levels.INFO)
end

return annotations
