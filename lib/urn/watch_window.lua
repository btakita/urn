WatchWindow = {}

WatchWindow.New = function()
  local width = 180
  local watchWindow = wx.wxFrame(frame, wx.wxID_ANY, "wxLua Watch Window",
                           wx.wxDefaultPosition, wx.wxSize(width, 160))

  local watchMenu = wx.wxMenu{
          { ID_ADDWATCH,      "&Add Watch"        },
          { ID_EDITWATCH,     "&Edit Watch\tF2"   },
          { ID_REMOVEWATCH,   "&Remove Watch"     },
          { ID_EVALUATEWATCH, "Evaluate &Watches" }}

  local watchMenuBar = wx.wxMenuBar()
  watchMenuBar:Append(watchMenu, "&Watches")
  watchWindow:SetMenuBar(watchMenuBar)

  local watchListCtrl = wx.wxListCtrl(watchWindow, ID_WATCH_LISTCTRL,
                                wx.wxDefaultPosition, wx.wxDefaultSize,
                                wx.wxLC_REPORT + wx.wxLC_EDIT_LABELS)
                                
  watchWindow.watchListCtrl = watchListCtrl

  local info = wx.wxListItem()
  info:SetMask(wx.wxLIST_MASK_TEXT + wx.wxLIST_MASK_WIDTH)
  info:SetText("Expression")
  info:SetWidth(width / 2)
  watchListCtrl:InsertColumn(0, info)

  info:SetText("Value")
  info:SetWidth(width / 2)
  watchListCtrl:InsertColumn(1, info)

  watchWindow:CentreOnParent()
  ConfigRestoreFramePosition(watchWindow, "WatchWindow")
  watchWindow:Show(true)

  local function FindSelectedWatchItem()
    local count = watchListCtrl:GetSelectedItemCount()
    if count > 0 then
      for idx = 0, watchListCtrl:GetItemCount() - 1 do
        if watchListCtrl:GetItemState(idx, wx.wxLIST_STATE_FOCUSED) ~= 0 then
          return idx
        end
      end
    end
    return -1
  end

  watchWindow:Connect( wx.wxEVT_CLOSE_WINDOW,
      function (event)
        ConfigSaveFramePosition(watchWindow, "WatchWindow")
        watchWindow = nil
        watchListCtrl = nil
        event:Skip()
      end)

  watchWindow:Connect(ID_ADDWATCH, wx.wxEVT_COMMAND_MENU_SELECTED,
      function (event)
        local row = watchListCtrl:InsertItem(watchListCtrl:GetItemCount(), "Expr")
        watchListCtrl:SetItem(row, 0, "Expr")
        watchListCtrl:SetItem(row, 1, "Value")
        watchListCtrl:EditLabel(row)
      end)

  watchWindow:Connect(ID_EDITWATCH, wx.wxEVT_COMMAND_MENU_SELECTED,
      function (event)
        local row = FindSelectedWatchItem()
        if row >= 0 then
          watchListCtrl:EditLabel(row)
        end
      end)
  watchWindow:Connect(ID_EDITWATCH, wx.wxEVT_UPDATE_UI,
      function (event)
        event:Enable(watchListCtrl:GetSelectedItemCount() > 0)
      end)

  watchWindow:Connect(ID_REMOVEWATCH, wx.wxEVT_COMMAND_MENU_SELECTED,
      function (event)
        local row = FindSelectedWatchItem()
        if row >= 0 then
          watchListCtrl:DeleteItem(row)
        end
      end)
  watchWindow:Connect(ID_REMOVEWATCH, wx.wxEVT_UPDATE_UI,
      function (event)
        event:Enable(watchListCtrl:GetSelectedItemCount() > 0)
      end)

  watchWindow:Connect(ID_EVALUATEWATCH, wx.wxEVT_COMMAND_MENU_SELECTED,
      function (event)
        ProcessWatches()
      end)
  watchWindow:Connect(ID_EVALUATEWATCH, wx.wxEVT_UPDATE_UI,
      function (event)
        event:Enable(watchListCtrl:GetItemCount() > 0)
      end)

  watchListCtrl:Connect(wx.wxEVT_COMMAND_LIST_END_LABEL_EDIT,
      function (event)
        watchListCtrl:SetItem(event:GetIndex(), 0, event:GetText())
        ProcessWatches()
        event:Skip()
      end)
  
  watchWindow.ProcessWatches = function(debuggerServer)
    for idx = 0, watchListCtrl:GetItemCount() - 1 do
      local expression = watchListCtrl:GetItemText(idx)
      debuggerServer:EvaluateExpr(idx, expression)
    end
  end
  
  watchWindow.Close = function()
    self.Destroy()
  end
  
  return watchWindow
end
