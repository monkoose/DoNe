--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.10.2

  System API documentation

  Functions and messages for using system resources, controlling the engine,
  error handling and debugging.
--]]

---@meta
---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field
---@diagnostic disable: args-after-dots

---@class defold_api.sys
sys = {}

---an asyncronous request is unable to read the resource
sys.REQUEST_STATUS_ERROR_IO_ERROR = nil

---an asyncronous request is unable to locate the resource
sys.REQUEST_STATUS_ERROR_NOT_FOUND = nil

---an asyncronous request has finished successfully
sys.REQUEST_STATUS_FINISHED = nil

---The sys.load_buffer function will first try to load the resource
---from any of the mounted resource locations and return the data if
---any matching entries found. If not, the path will be tried
---as is from the primary disk on the device.
---In order for the engine to include custom resources in the build process, you need
---to specify them in the "custom_resources" key in your "game.project" settings file.
---You can specify single resource files or directories. If a directory is included
---in the resource list, all files and directories in that directory is recursively
---included:
---For example "main/data/,assets/level_data.json".
---@param path string the path to load the buffer from
---@return buffer_data buffer the buffer with data
function sys.load_buffer(path) end

---The sys.load_buffer function will first try to load the resource
---from any of the mounted resource locations and return the data if
---any matching entries found. If not, the path will be tried
---as is from the primary disk on the device.
---In order for the engine to include custom resources in the build process, you need
---to specify them in the "custom_resources" key in your "game.project" settings file.
---You can specify single resource files or directories. If a directory is included
---in the resource list, all files and directories in that directory is recursively
---included:
---For example "main/data/,assets/level_data.json".
---Note that issuing multiple requests of the same resource will yield
---individual buffers per request. There is no implic caching of the buffers
---based on request path.
---@param path string the path to load the buffer from
---@param status_callback fun(self, request_id, result) A status callback that will be invoked when a request has been handled, or an error occured. The result is a table containing:
---
---status
---number The status of the request, supported values are:
---
---
---resource.REQUEST_STATUS_FINISHED
---resource.REQUEST_STATUS_ERROR_IO_ERROR
---resource.REQUEST_STATUS_ERROR_NOT_FOUND
---
---
---buffer
---buffer If the request was successfull, this will contain the request payload in a buffer object, and nil otherwise. Make sure to check the status before doing anything with the buffer value!
---
---@return resource_handle handle a handle to the request
function sys.load_buffer_async(path, status_callback) end

return sys