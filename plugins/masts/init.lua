local lfs = require 'lfs'

local months = {
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
}


local function process()
    local masts = {}

    -- Build list of year directories
    local year_dirs = {}
    for f in lfs.dir('inc/masts/home') do
        if f ~= '.' and f ~= '..' then
            table.insert(year_dirs, f)
        end
    end

    table.sort(year_dirs)

    for _, f in ipairs(year_dirs) do
        if f ~= '.' and f ~= '..' then
            local attributes = lfs.attributes('inc/masts/home/' .. f)
            if attributes.mode == 'directory' then
                for _, month in ipairs(months) do
                    mast = 'inc/masts/home/' .. f .. '/' .. month .. '.jpg'
                    local mast_attributes = lfs.attributes(mast)
                    if mast_attributes and mast_attributes.mode == 'file' then
                        table.insert(masts, 1, mast)
                    end
                end
            end
        end
    end

    local out = ''

    for k, v in ipairs(masts) do
        out = out .. [[
    <img src="]] .. config.url .. '/' .. v .. [[" />
]]
    end

    return '<div style="font-size:0;">' .. out .. '</div>'
end

return process
