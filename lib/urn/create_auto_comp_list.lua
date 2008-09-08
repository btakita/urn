function CreateAutoCompList(key_) -- much faster than iterating the wx. table
    local key = "wx."..key_;
    local a, b = string.find(wxkeywords, key, 1, 1)
    local key_list = ""

    while a do
        local c, d = string.find(wxkeywords, " ", b, 1)
        key_list = key_list..string.sub(wxkeywords, a+3, c or -1)
        a, b = string.find(wxkeywords, key, d, 1)
    end

    return key_list
end
