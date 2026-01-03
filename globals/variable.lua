FONT_PATH = {
  DEFAULT = "font_main",
  SUB     = "font_sub",
  COMBAT  = "font_combat"
}
FONT_SIZE = {
  DEFAULT = 13,
  SMALL   = 11,
  MIDDLE  = 13,
  LARGE   = 15,
  CINEMA  = 26,
  XLARGE  = 18,
  XXLARGE = 22,
}
-- local InitFontSize = function()
--   local info = UIParent:InitFontSize()
--   local cnt = 0
--   for k, v in pairs(info) do
--     FONT_SIZE[string.upper(k)] = v
--     cnt = cnt + 1
--   end
--   if cnt == 0 then
--     UIParent:Warning(string.format("[Lua Error] InitFontSize() failed, FONT_SIZE is zero size."))
--   end
-- end
-- InitFontSize()
