local fs = vim.fs
local fn = vim.fn
local nvim_create_user_command = vim.api.nvim_create_user_command
local nvim_create_autocmd = vim.api.nvim_create_autocmd

local cache_dir = fn.stdpath("cache")
---@diagnostic disable-next-line: param-type-mismatch
local done_cache_dir = fs.joinpath(cache_dir, "DoNe")

-- Returns the path to the plugin's `api` directory
-- @return string
local function api_path()
   local source = debug.getinfo(2, "S").source
   if source:sub(1, 1) == "@" then
      return fs.joinpath(fs.dirname(fs.dirname(source:sub(2))), "api")
   end
   return ""
end

local lua_ls_settings = {
   Lua = {
      runtime = {
         version = "LuaJIT",
      },
      workspace = {
         library = { "lua", api_path(), done_cache_dir },
         ignoreDir = { ".internal" },
      },
      diagnostics = {
         globals = {
            "init",
            "update",
            "fixed_update",
            "final",
            "on_input",
            "on_message",
            "on_reload",
         },
      },
   },
}

local root_pattern = { "game.project" }
local augroup = vim.api.nvim_create_augroup("DoneSetup", {})

-- Filetype mappings
vim.filetype.add({
   extension = {
      script = "lua",
      gui_script = "lua",
      render_script = "lua",
      editor_script = "lua",
      project = "dosini",
      fp = "glsl",
      vp = "glsl",
      buffer = "json",
      go = "proto",
      collection = "proto",
      animationset = "proto",
      atlas = "proto",
      camera = "proto",
      collectionfactory = "proto",
      collectionproxy = "proto",
      collisionobject = "proto",
      display_profiles = "proto",
      factory = "proto",
      gamepads = "proto",
      gui = "proto",
      input_binding = "proto",
      label = "proto",
      material = "proto",
      mesh = "proto",
      model = "proto",
      particlefx = "proto",
      render = "proto",
      sound = "proto",
      spinemodel = "proto",
      spinescene = "proto",
      sprite = "proto",
      texture_profiles = "proto",
      tilemap = "proto",
      tilesource = "proto",
      manifest = "proto",
      appmanifest = "yaml",
      script_api = "yaml",
   },
   filename = {
      ["ext.manifest"] = "yaml",
   },
})

-- Configure con.nvim
nvim_create_autocmd("User", {
   pattern = "CocNvimInit",
   group = augroup,
   once = true,
   callback = function()
      fn["coc#config"]("languageserver", {
         lua = {
            rootPatterns = root_pattern,
            settings = lua_ls_settings,
         },
      })
   end,
})

-- Confugure built-in LSP
nvim_create_autocmd("LspAttach", {
   group = augroup,
   callback = function(ev)
      local buf_filetype = vim.filetype.match({ buf = ev.buf })
      if buf_filetype == "lua" then
         local root_dir = vim.fs.root(ev.buf, root_pattern)
         if not root_dir then
            return
         end

         local client = vim.lsp.get_client_by_id(ev.data.client_id)
         if not client then
            return
         end

         client.root_dir = root_dir
         client.settings = vim.tbl_deep_extend("force", client.settings or {}, lua_ls_settings)
      end
   end,
})

-- User command

---Returns a list of :DoNe commands for completion
---@param arg_lead string
---@return table
local function complete_commands(arg_lead)
   local result = {}
   local commands = {
      "annotate",
      "clean",
      "build",
      "reload",
      "fetch",
      "actions",
      "delete_server_pipe",
   }
   for _, cmd in ipairs(commands) do
      if vim.startswith(cmd, arg_lead) then
         table.insert(result, cmd)
      end
   end
   table.sort(result)

   return result
end

nvim_create_user_command("DoNe", function(opts)
   local annotations = require("done.annotations")
   local remote = require("done.remote")
   local cmd = opts.args
   if cmd == "annotate" then
      annotations.unpack()
   elseif cmd == "clean" then
      annotations.clean()
   elseif cmd == "build" then
      remote.action("build")
   elseif cmd == "reload" then
      remote.action("hot-reload")
   elseif cmd == "fetch" then
      remote.action("fetch-libraries")
   elseif cmd == "actions" then
      vim.print(remote.get_actions())
   elseif cmd == "delete_server_pipe" then
      ---@diagnostic disable-next-line: param-type-mismatch
      local pipe = fs.joinpath(cache_dir, "defold.pipe")
      if fn.filereadable(pipe) == 1 then
         fn.delete(pipe)
         vim.notify("Server pipe 'defold.pipe' has been deleted. Neovim restart required.")
      else
         vim.notify("Server pipe 'defold.pipe' doesn't exist", vim.log.levels.WARN)
      end
   else
      vim.notify("Command '" .. cmd .. "' not found")
   end
end, {
   nargs = 1,
   complete = complete_commands,
})
