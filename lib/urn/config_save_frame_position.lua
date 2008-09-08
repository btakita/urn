-- ----------------------------------------------------------------------------
-- wxConfig save preferences function

function ConfigSaveFramePosition(window, windowName)
    local path = config:GetPath()
    config:SetPath("/"..windowName)

    local s    = 0
    local w, h = window:GetSizeWH()
    local x, y = window:GetPositionXY()

    if window:IsMaximized() then
        s = 1
    elseif window:IsIconized() then
        s = 2
    end

    config:Write("s", s)

    if s == 0 then
        config:Write("x", x)
        config:Write("y", y)
        config:Write("w", w)
        config:Write("h", h)
    end

    config:SetPath(path)
end
