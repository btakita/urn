Urn.MenuBar = {
  new = function(wx, frame)
    local menuBar = wx.wxMenuBar()
    
    local fileMenu = wx.wxMenu({
        { Urn.ID_NEW,     "&New\tCtrl-N",        "Create an empty document" },
        { Urn.ID_OPEN,    "&Open...\tCtrl-O",    "Open an existing document" },
        { ID_CLOSE,   "&Close page\tCtrl+W", "Close the current editor window" },
        { },
        { ID_SAVE,    "&Save\tCtrl-S",       "Save the current document" },
        { ID_SAVEAS,  "Save &As...\tAlt-S",  "Save the current document to a file with a new name" },
        { ID_SAVEALL, "Save A&ll...\tCtrl-Shift-S", "Save all open documents" },
        { },
        { ID_EXIT,    "E&xit\tAlt-X",        "Exit Program" }})
    menuBar:Append(fileMenu, "&File")
    
    function NewFile(event)
      local editor = CreateEditor("untitled.lua")
      SetupKeywords(editor, true)
    end

    frame:Connect(Urn.ID_NEW, wx.wxEVT_COMMAND_MENU_SELECTED, NewFile)

    -- Find an editor page that hasn't been used at all, eg. an untouched NewFile()
    function FindDocumentToReuse()
      local editor = nil
      for id, document in pairs(openDocuments) do
        if (document.editor:GetLength() == 0) and
         (not document.isModified) and (not document.filePath) and
         not (document.editor:GetReadOnly() == true) then
          editor = document.editor
          break
        end
      end
      return editor
    end

    function LoadFile(filePath, editor, file_must_exist)
      local file_text = ""
      local handle = io.open(filePath, "rb")
      if handle then
          file_text = handle:read("*a")
          handle:close()
      elseif file_must_exist then
          return nil
      end

      if not editor then
          editor = FindDocumentToReuse()
      end
      if not editor then
          editor = CreateEditor(wx.wxFileName(filePath):GetFullName() or "untitled.lua")
       end

      editor:Clear()
      editor:ClearAll()
      SetupKeywords(editor, IsLuaFile(filePath))
      editor:MarkerDeleteAll(BREAKPOINT_MARKER)
      editor:MarkerDeleteAll(CURRENT_LINE_MARKER)
      editor:AppendText(file_text)
      editor:EmptyUndoBuffer()
      local id = editor:GetId()
      openDocuments[id].filePath = filePath
      openDocuments[id].fileName = wx.wxFileName(filePath):GetFullName()
      openDocuments[id].modTime = GetFileModTime(filePath)
      SetDocumentModified(id, false)
      editor:Colourise(0, -1)

      return editor
    end

    function OpenFile(event)
      local fileDialog = wx.wxFileDialog(frame, "Open file",
                                         "",
                                         "",
                                         "Lua files (*.lua)|*.lua|Text files (*.txt)|*.txt|All files (*)|*",
                                         wx.wxOPEN + wx.wxFILE_MUST_EXIST)
      if fileDialog:ShowModal() == wx.wxID_OK then
        if not LoadFile(fileDialog:GetPath(), nil, true) then
            wx.wxMessageBox("Unable to load file '"..fileDialog:GetPath().."'.",
                            "wxLua Error",
                            wx.wxOK + wx.wxCENTRE, frame)
        end
      end
      fileDialog:Destroy()
    end
    frame:Connect(Urn.ID_OPEN, wx.wxEVT_COMMAND_MENU_SELECTED, OpenFile)    
    
    
    return menuBar
  end
}
