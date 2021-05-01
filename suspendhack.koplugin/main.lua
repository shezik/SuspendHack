local Device = require("device")

if not Device:isKindle() then
	return { disabled = true, }
end

local InfoMessage = require("ui/widget/infomessage")
local PluginShare = require("pluginshare")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local logger = require("logger")
local _ = require("gettext")
local T = require("ffi/util").template
local lipc = require("liblipclua")

local lipc_handle, error_message, error_number

local SuspendHack = WidgetContainer:new{
	name = "suspendhack",
	is_doc_only = false,
}

function SuspendHack:_notify(userText)
	UIManager:show(InfoMessage:new{
		text = T(userText),
	})
end

function SuspendHack:_kafPresent()
	return os.execute("lipc-probe -l|grep ^com.lab126.kaf$") ~= 256
end

function SuspendHack:init()
	if self:_kafPresent() then
		logger.dbg("SuspendHack is inactive since framework is present.")
	else
		logger.dbg("SuspendHack is active.")
		self:_start()
	end
	if not self.ui or not self.ui.menu then return end
    self.ui.menu:registerToMainMenu(self)
end

function SuspendHack:_start()
	lipc_handle, error_message, error_number = lipc.init("com.lab126.kaf")
	if not lipc_handle then
		self:_notify("SuspendHack: Failed to initialize LIPC: (" .. tostring(error_number) .. ") " .. error_message)
		return error_number
	else
		lipc.set_error_handler(function(error) self:_notify("SuspendHack: " .. error) end)
	end

	local readonly_property = lipc_handle:register_int_property("frameworkStarted", "r")
	readonly_property.value = 1
	
	logger.dbg("SuspendHack started.")
end

function SuspendHack:onSuspend()
	if lipc_handle then
		lipc_handle:close()
	end
end

function SuspendHack:onResume()
	if not self:_kafPresent() then
		self:_start()
	end
end

return SuspendHack