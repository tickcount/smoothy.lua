local function ease(t, b, c, d)
    return c * t / d + b
end

local function get_timer()
    -- use your own timer implementation
    return globals.frametime()
end

local function get_type(value)
    local val_type = type(value)

    if val_type == 'boolean' then
        value = value and 1 or 0
    end

    return val_type
end

local function copy_tables(destination, keysTable, valuesTable)
    valuesTable = valuesTable or keysTable
    local mt = getmetatable(keysTable)

    if mt and getmetatable(destination) == nil then
        setmetatable(destination, mt)
    end

    for k,v in pairs(keysTable) do
        if type(v) == 'table' then
            destination[k] = copy_tables({ }, v, valuesTable[k])
        else
            local value = valuesTable[k]

            if type(value) == 'boolean' then
                value = value and 1 or 0
            end

            destination[k] = value
        end
    end

    return destination
end

local function resolve(easing_fn, previous, new, clock, duration)
    if type(new) == 'boolean' then new = new and 1 or 0 end
    if type(previous) == 'boolean' then previous = previous and 1 or 0 end

    local previous = easing_fn(clock, previous, new - previous, duration)

    if type(new) == 'number' then
        if math.abs(new-previous) <= .001 then
            previous = new
        end

        if previous % 1 < .0001 then
            previous = math.floor(previous)
        elseif previous % 1 > .9999 then
            previous = math.ceil(previous)
        end
    end

    return previous
end

local function perform_easing(ntype, easing_fn, previous, new, clock, duration)
    if ntype == 'table' then
        for k, v in pairs(new) do
            previous[k] = previous[k] or v
            previous[k] = perform_easing(
                type(v), easing_fn,
                previous[k], v,
                clock, duration
            )
        end

        return previous
    end

    return resolve(easing_fn, previous, new, clock, duration)
end

local function update(self, duration, value, easing, ignore_adj_speed)
    if type(value) == 'boolean' then
        value = value and 1 or 0
    end

    local clock = get_timer()
    local duration = duration or .15
    local value_type = get_type(value)
    local target_type = get_type(self.value)

    assert(value_type == target_type, 'type mismatch')

    if self.value == value then
        return value
    end

    if clock <= 0 or clock >= duration then
        if target_type == 'table' then
            copy_tables(self.value, value)
        else
            self.value = value
        end
    else
        local easing = easing or self.easing

        self.value = perform_easing(
            target_type, easing,
            self.value, value,
            clock, duration
        )
    end

    return self.value
end

local M = {
    __metatable = false,
    __call = update,

    __index = {
        update = update
    }
}

return function(default, easing_fn)
    if type(default) == 'boolean' then
        default = default and 1 or 0
    end

    return setmetatable({
        value = default or 0,
        easing = easing_fn or ease,
    }, M)
end
