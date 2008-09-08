function IsLuaFile(filePath)
    return filePath and (string.len(filePath) > 4) and
           (string.lower(string.sub(filePath, -4)) == ".lua")
end
