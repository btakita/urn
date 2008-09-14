-- Generate a unique new wxWindowID
Urn.ID_IDCOUNTER = wx.wxID_HIGHEST + 1
Urn.new_id = function()
  Urn.ID_IDCOUNTER = Urn.ID_IDCOUNTER + 1
  return Urn.ID_IDCOUNTER
end

Urn.assign_new_id_to_variable = function(variable_name)
  Urn[variable_name] = Urn.new_id()
end
