-- Check if file is altered, show dialog to reload it
function IsFileAlteredOnDisk(editor)
    if not editor then return end

    local id = editor:GetId()
    if openDocuments[id] then
        local filePath   = openDocuments[id].filePath
        local fileName   = openDocuments[id].fileName
        local oldModTime = openDocuments[id].modTime

        if filePath and (string.len(filePath) > 0) and oldModTime and oldModTime:IsValid() then
            local modTime = GetFileModTime(filePath)
            if modTime == nil then
                openDocuments[id].modTime = nil
                wx.wxMessageBox(fileName.." is no longer on the disk.",
                                "wxLua Message",
                                wx.wxOK + wx.wxCENTRE, frame)
            elseif modTime:IsValid() and oldModTime:IsEarlierThan(modTime) then
                local ret = wx.wxMessageBox(fileName.." has been modified on disk.\nDo you want to reload it?",
                                            "wxLua Message",
                                            wx.wxYES_NO + wx.wxCENTRE, frame)
                if ret ~= wx.wxYES or LoadFile(filePath, editor, true) then
                    openDocuments[id].modTime = nil
                end
            end
        end
    end
end
