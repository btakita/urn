Urn.Commands.New = {}

function Urn.Commands.New:new(wx, urn)
  local command = {id = wx.wxID_NEW, urn = urn}
  function command:attach()
    self.urn.menus["file"]:Append(self.id, "&New", "Create an empty document")
  end
  
  return command
end