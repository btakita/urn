-- Load the wxLua module, does nothing if running from wxLua, wxLuaFreeze, or wxLuaEdit
package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"
require("wx")

Urn = {}
Urn.Commands = {}

require("urn/iif")

-- Generate a unique new wxWindowID
function Urn:new_id()
  if not self.next_id then
    self.next_id = wx.wxID_HIGHEST + 1
  else
    self.next_id = Urn.next_id + 1
  end
  return self.next_id
end

-- File menu
Urn.ID_NEW              = wx.wxID_NEW
Urn.ID_OPEN             = wx.wxID_OPEN
Urn.ID_CLOSE            = Urn:new_id()
Urn.ID_SAVE             = wx.wxID_SAVE
Urn.ID_SAVEAS           = wx.wxID_SAVEAS
Urn.ID_SAVEALL          = Urn:new_id()
Urn.ID_EXIT             = wx.wxID_EXIT
-- Edit menu
Urn.ID_CUT              = wx.wxID_CUT
Urn.ID_COPY             = wx.wxID_COPY
Urn.ID_PASTE            = wx.wxID_PASTE
Urn.ID_SELECTALL        = wx.wxID_SELECTALL
Urn.ID_UNDO             = wx.wxID_UNDO
Urn.ID_REDO             = wx.wxID_REDO
Urn.ID_AUTOCOMPLETE     = Urn:new_id()
Urn.ID_AUTOCOMPLETE_ENABLE = Urn:new_id()
Urn.ID_COMMENT          = Urn:new_id()
Urn.ID_FOLD             = Urn:new_id()
-- Find menu
Urn.ID_FIND             = wx.wxID_FIND
Urn.ID_FINDNEXT         = Urn:new_id()
Urn.ID_FINDPREV         = Urn:new_id()
Urn.ID_REPLACE          = Urn:new_id()
Urn.ID_GOTOLINE         = Urn:new_id()
Urn.ID_SORT             = Urn:new_id()
-- Debug menu
Urn.ID_COMPILE          = Urn:new_id()
Urn.ID_RUN              = Urn:new_id()
Urn.ID_USECONSOLE       = Urn:new_id()

-- Help menu
Urn.ID_ABOUT            = wx.wxID_ABOUT

-- Markers for editor marker margin
Urn.BREAKPOINT_MARKER         = 1
Urn.BREAKPOINT_MARKER_VALUE   = 2 -- = 2^BREAKPOINT_MARKER
Urn.CURRENT_LINE_MARKER       = 2
Urn.CURRENT_LINE_MARKER_VALUE = 4 -- = 2^CURRENT_LINE_MARKER

function Urn:new(wx)
  local urn = {}
  
  function urn:start()
    self.frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "wxLua")
    self.splitter = wx.wxSplitterWindow(
      self.frame,
      wx.wxID_ANY,
      wx.wxDefaultPosition,
      wx.wxDefaultSize,
      wx.wxSP_3DSASH)
    self.notebook = wx.wxNotebook(
      self.splitter,
      wx.wxID_ANY,
      wx.wxDefaultPosition,
      wx.wxDefaultSize,
      wx.wxCLIP_CHILDREN)
    self.open_documents = {}
    self.status_text_table = { "OVR?", "R/O?", "Cursor Pos" }
    
    self.font = wx.wxFont(10, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_NORMAL, wx.wxFONTWEIGHT_NORMAL, false, "Andale Mono")
    self.font_italic = wx.wxFont(10, wx.wxFONTFAMILY_MODERN, wx.wxFONTSTYLE_ITALIC, wx.wxFONTWEIGHT_NORMAL, false, "Andale Mono")
    
    self.menu_bar = wx.wxMenuBar()
    self.frame:SetMenuBar(self.menu_bar)
    self.menus = {}
    self:append_menu("file", wx.wxMenu(), "&File")
    
    Urn.Commands.New:new(wx, self):attach()
    
    self.frame:Show(true)
    wx.wxGetApp():MainLoop()
  end
  
  function urn:append_menu(name, menu, display_name)
    self.menus[name] = menu
    self.menu_bar:Append(menu, display_name)
  end
  
  function urn:load_command(file)
    require(file)
  end
  
  return urn
end

require("urn/commands/new")

local urn = Urn:new(wx)
urn:start()
