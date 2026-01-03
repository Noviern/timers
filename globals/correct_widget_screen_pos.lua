---Corrects the widgets screen position to always be inside the screen.
---@param widget Widget
function CorrectWidgetScreenPos(widget)
  local x, y = widget:CorrectOffsetByScreen()
  x = x / UIParent:GetUIScale()
  y = y / UIParent:GetUIScale()
  widget:RemoveAllAnchors()
  widget:AddAnchor("TOPLEFT", "UIParent", x, y)
end
