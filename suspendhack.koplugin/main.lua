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
	if os.execute("lipc-probe -l|grep ^com.lab126.kaf$") == 256 then
		return false
	else
		return true
	end
end

function SuspendHack:init()
	if not self:_kafPresent() then
		logger.dbg("SuspendHack enabled.")
		self:_start()
	else
		logger.dbg("SuspendHack disabled.")
		return { disabled = true, }
	end
end

function SuspendHack:_start()
	local lipc_handle, error_message, error_number = lipc.init("com.lab126.kaf")
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
	lipc_handle:close()
end

function SuspendHack:onResume()
	if not self:_kafPresent() then
		self:_start()
	end
end

return SuspendHack