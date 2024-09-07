local M = {}

local defold_port = 0

local function get_commands(port)
   return vim.system({ "curl", "-s", "http://localhost:" .. port .. "/command" }):wait()
end

local function set_defold_port()
   local handle = io.popen("ss -tplH4")
   if not handle then
      vim.notify("Could not find Defold port", vim.log.levels.ERROR)
      return
   end

   for conn in handle:lines() do
      if conn:find("java") then
         local _, _, port = conn:find("%d+%.%d+%.%d+%.%d+:(%d+)")
         if port then
            if get_commands(port).code == 0 then
               defold_port = port
               break
            end
         end
      end
   end

   handle:close()

   if not defold_port then
      vim.notify("Could not find Defold port", vim.log.levels.ERROR)
   end
end

function M.get_actions()
   local actions = get_commands(defold_port)
   if actions.code ~= 0 then
      set_defold_port()
      return get_commands(defold_port).stdout
   end
   return actions.stdout
end

function M.action(cmd, retry)
   vim.system({
      "curl",
      "-s",
      "-X",
      "POST",
      "http://localhost:" .. defold_port .. "/command/" .. cmd,
   }, {}, function(obj)
      if obj.code ~= 0 then
         if retry then
            vim.notify(
               "Error while sending command to " .. defold_port .. " port",
               vim.log.levels.ERROR
            )
         else
            set_defold_port()
            M.action(cmd, true)
         end
      elseif not obj.stdout:find("Accepted") then
         vim.schedule(function()
            vim.notify("Request rejected: " .. obj.stdout, vim.log.levels.WARN)
         end)
      end
   end)
end

return M
