local M = {}

local Log = require "lvim.core.log"
local fmt = string.format
local lvim_lsp_utils = require "lvim.lsp.utils"
local is_windows = vim.uv.os_uname().version:match "Windows"

---Resolve the configuration for a server by merging with the default config
---@param server_name string
---@vararg any config table [optional]
---@return table
local function resolve_config(server_name, ...)
  local defaults = {
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    on_exit = require("lvim.lsp").common_on_exit,
    capabilities = require("lvim.lsp").common_capabilities(),
  }

  local has_custom_provider, custom_config = pcall(require, "lvim/lsp/providers/" .. server_name)
  if has_custom_provider then
    Log:debug("Using custom configuration for requested server: " .. server_name)
    defaults = vim.tbl_deep_extend("force", defaults, custom_config)
  end

  defaults = vim.tbl_deep_extend("force", defaults, ...)

  return defaults
end

---Enable a server with the given configuration, using the native `vim.lsp.config` +
---`vim.lsp.enable` APIs. Server defaults are picked up from nvim-lspconfig's `lsp/` dir
---and mason-installed executables are resolvable via PATH (see lvim.core.mason).
local function launch_server(server_name, config)
  vim.lsp.config(server_name, config)

  local resolved = vim.lsp.config[server_name]
  local command = resolved and resolved.cmd
  -- some servers resolve their command dynamically; only skip when we can tell it's missing
  if type(command) == "table" and type(command[1]) == "string" and vim.fn.executable(command[1]) ~= 1 then
    Log:debug(string.format("[%q] is either not installed, missing from PATH, or not executable.", server_name))
    return false
  end
  vim.lsp.enable(server_name)
  return true
end

---Setup a language server by providing a name
---@param server_name string name of the language server
---@param user_config table? when available it will take predence over any default configurations
function M.setup(server_name, user_config)
  vim.validate { name = { server_name, "string" } }
  user_config = user_config or {}

  if lvim_lsp_utils.is_client_active(server_name) then
    return
  end

  local mason_ok, server_mapping = pcall(function()
    return require("mason-lspconfig").get_mappings().get_mason_map().lspconfig_to_package
  end)
  local pkg_name = mason_ok and server_mapping and server_mapping[server_name]
  if not pkg_name then
    launch_server(server_name, resolve_config(server_name, user_config))
    return
  end

  local registry = require "mason-registry"
  local should_auto_install = function(name)
    local installer_settings = lvim.lsp.installer.setup
    return installer_settings.automatic_installation
      and not vim.tbl_contains(installer_settings.automatic_installation.exclude or {}, name)
  end

  if not registry.is_installed(pkg_name) then
    if should_auto_install(server_name) then
      Log:debug "Automatic server installation detected"
      vim.notify_once(string.format("Installation in progress for [%s]", server_name), vim.log.levels.INFO)
      local pkg = registry.get_package(pkg_name)
      pkg:install():once("closed", function()
        if pkg:is_installed() then
          vim.schedule(function()
            vim.notify_once(string.format("Installation complete for [%s]", server_name), vim.log.levels.INFO)
            launch_server(server_name, resolve_config(server_name, user_config))
          end)
        end
      end)
      return
    end
    Log:debug(server_name .. " is not managed by the automatic installer")
  end

  launch_server(server_name, resolve_config(server_name, user_config))
end

return M
