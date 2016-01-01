local lfs = require 'lfs'


local function process()
    local masts = {}

    for f in lfs.dir('inc/masts/home') do
        if f ~= '.' and f ~= '..' then
            local attributes = lfs.attributes('inc/masts/home/' .. f)
            if attributes.mode == 'directory' then
                for mast in lfs.dir('inc/masts/home/' .. f) do
                    if mast:sub(-4) == '.jpg' then
                        mast = 'inc/masts/home/' .. f .. '/' .. mast
                        local mast_attributes = lfs.attributes(mast)
                        if mast_attributes and mast_attributes.mode == 'file' then
                            table.insert(masts, 1, mast)
                        end
                    end
                end
            end
        end
    end

    local out = ''

    for k, v in ipairs(masts) do
        out = out .. [[
<div class="wide mast">
    <img src="]] .. config.url .. '/' .. v .. [[" />
</div>
]]
    end

    return out
end

return process
