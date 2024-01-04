---@alias APMBussinListener fun(event: APMBussinEvent): nil

---@class APMBussinEvent
---@field type string
---@field context any

---@class APMBussin
---@field listeners table<string, APMBussinListener[]>
local APMBussin = {}
APMBussin.__index = APMBussin

function APMBussin.new()
    return setmetatable({
        listeners = {},
    }, APMBussin)
end

function APMBussin:listen(event_type, listener)
    if self.listeners[event_type] == nil then
        self.listeners[event_type] = {}
    end

    table.insert(self.listeners[event_type], listener)
end

---@param event_type string
---@param listener APMBussinListener
function APMBussin:remove(event_type, listener)
    if self.listeners[event_type] == nil then
        return
    end

    for i, l in ipairs(self.listeners[event_type]) do
        if l == listener then
            table.remove(self.listeners[event_type], i)
            return
        end
    end
end

function APMBussin:emit(event)
    if self.listeners[event.type] == nil then
        return
    end

    for _, listener in ipairs(self.listeners[event.type]) do
        listener(event)
    end
end

return APMBussin.new()
