-- ----------------------------------------------------------------------------
-- Get file modification time, returns a wxDateTime (check IsValid) or nil if
--   the file doesn't exist
function GetFileModTime(filePath)
    if filePath and (string.len(filePath) > 0) then
        local fn = wx.wxFileName(filePath)
        if fn:FileExists() then
            return fn:GetModificationTime()
        end
    end

    return nil
end
