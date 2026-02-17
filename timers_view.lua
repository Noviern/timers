ADDON:ImportObject(OBJECT.TextStyle)
ADDON:ImportObject(OBJECT.Window)
ADDON:ImportObject(OBJECT.Button)
ADDON:ImportObject(OBJECT.CheckButton)
ADDON:ImportObject(OBJECT.Textbox)
ADDON:ImportObject(OBJECT.NinePartDrawable)
ADDON:ImportObject(OBJECT.ImageDrawable)
ADDON:ImportObject(OBJECT.EmptyWidget)
ADDON:ImportObject(OBJECT.X2Editbox)
ADDON:ImportObject(OBJECT.Label)
ADDON:ImportObject(OBJECT.Slider)
ADDON:ImportObject(OBJECT.ListCtrl)
ADDON:ImportAPI(API.X2Sound)

WINDOW      = {
  WIDTH               = 600,
  -- HEIGHT              = 515,
  TITLE_HEIGHT        = 45,
  MARGIN              = 20,
  CLOSE_BUTTON_OFFSET = 3,
  ITEM_DIMENSION      = 30,
  VISIBLE_ROW_COUNT   = 10,
}

-- WINDOW.HEIGHT = WINDOW.TITLE_HEIGHT + WINDOW.ITEM_DIMENSION * WINDOW.VISIBLE_ROW_COUNT + WINDOW.MARGIN * 2 + 37

local inset = { 8, 8, 8, 8 }

---@TODO: filePath could fail if the user installed ArcheRage on another drive. Need to find a way to get the ArcheRage Documents folder.
filePath    = "C:/ArcheRage/Documents/Addon/" .. ADDON:GetName() .. "/timer_data.lua"

DAY         = 86400
HOUR        = 3600
MINUTE      = 60
SECOND      = 1

---@class Timer
---@field name string
---@field duration number
---@field startTime number|nil
---@field pauseTime number|nil

---Sets up the view of the example addon window.
---@param timers Timer[]
---@return Window
function SetViewOfTimers(timers)
  -- Create the main window.
  local window = UIParent:CreateWidget("window", "timers", "UIParent")
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  -- window:SetExtent(WINDOW.WIDTH, WINDOW.HEIGHT)
  window:SetWidth(WINDOW.WIDTH)

  WINDOW.HEIGHT = WINDOW.TITLE_HEIGHT + 37 + WINDOW.MARGIN +
    WINDOW.ITEM_DIMENSION * WINDOW.VISIBLE_ROW_COUNT +
    WINDOW.MARGIN

  window:SetHeight(WINDOW.HEIGHT)

  -- Add background to the main window.
  local background = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "main_bg", "background")
  background:AddAnchor("TOPLEFT", window, -5, -5)
  background:AddAnchor("BOTTOMRIGHT", window, 5, 5)

  -- Add title decoration to the main window.
  local decoration = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "main_bg_deco", "background")
  decoration:AddAnchor("TOPLEFT", window, 0, -5)
  decoration:AddAnchor("TOPRIGHT", window, 0, -5)

  -- Create title bar.
  local titleBar = window:CreateChildWidget("window", "titleBar", 0, true)
  titleBar.titleStyle:SetAlign(ALIGN_CENTER)
  titleBar.titleStyle:SetSnap(true)
  titleBar.titleStyle:SetFont(FONT_PATH.SUB, FONT_SIZE.XLARGE)
  titleBar.titleStyle:SetColorByKey("title")
  titleBar:AddAnchor("TOPLEFT", window, 0, 0)
  titleBar:AddAnchor("TOPRIGHT", window, 0, 0)
  titleBar:SetTitleText(locale.addon.title)
  titleBar:EnableDrag(true)
  titleBar:SetHeight(45)

  -- Add close button to title bar.
  local closeButton = titleBar:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:AddAnchor("TOPRIGHT", titleBar, WINDOW.CLOSE_BUTTON_OFFSET, -WINDOW.CLOSE_BUTTON_OFFSET)
  closeButton:SetStyle("btn_close_default")

  -- Create content frame.
  local createTimerFrame = window:CreateChildWidget("emptywidget", "createTimerFrame", 0, true)
  createTimerFrame:AddAnchor("TOPLEFT", titleBar, "BOTTOMLEFT", WINDOW.MARGIN, 0)
  createTimerFrame:AddAnchor("TOPRIGHT", titleBar, "BOTTOMRIGHT", -WINDOW.MARGIN, 0)

  -- Create name editbox.
  local nameEditbox = createTimerFrame:CreateChildWidget("x2editbox", "nameEditbox", 0, true)
  nameEditbox.style:SetColorByKey("default")
  nameEditbox.style:SetAlign(ALIGN_LEFT)
  nameEditbox.guideTextStyle:SetAlign(ALIGN_LEFT)
  nameEditbox.guideTextStyle:SetColorByKey("guide_text_in_editbox")
  nameEditbox:SetInset(inset[1], inset[2], inset[3], inset[4])
  nameEditbox:SetGuideTextInset({ inset[1], inset[2], inset[3], inset[4] })
  nameEditbox:SetGuideText(locale.addon.guide)
  nameEditbox:SetCursorColorByColorKey("editbox_cursor_default")
  nameEditbox:SetMaxTextLength(25)

  local nameEditboxBackground = nameEditbox:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "background")
  nameEditboxBackground:AddAnchor("TOPLEFT", nameEditbox, 0, 0)
  nameEditboxBackground:AddAnchor("BOTTOMRIGHT", nameEditbox, 0, 0)

  local dayEditbox = createTimerFrame:CreateChildWidget("x2editbox", "dayEditbox", 0, true)
  dayEditbox.style:SetColorByKey("default")
  local zeroWidth = dayEditbox.style:GetTextWidth("0")
  dayEditbox.guideTextStyle:SetColorByKey("guide_text_in_editbox")
  dayEditbox:SetInset(inset[1], inset[2], inset[1], inset[4])
  dayEditbox:SetGuideText("000")
  dayEditbox:SetWidth(zeroWidth * 3 + inset[1] * 2)
  dayEditbox:SetDigit(true)
  dayEditbox:SetDigitEmpty(true)
  dayEditbox:SetMaxTextLength(3)
  dayEditbox:SetCursorColorByColorKey("editbox_cursor_default")

  local dayLabel = createTimerFrame:CreateChildWidget("label", "dayLabel", 0, true)
  dayLabel:SetText(locale.addon.day)
  dayLabel:SetAutoResize(true)
  dayLabel:SetInset(0, 0, inset[1], 0)
  dayLabel.style:SetColorByKey("default")

  local dayEditboxBackground = dayEditbox:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "background")
  dayEditboxBackground:AddAnchor("TOPLEFT", dayEditbox, 0, 0)
  dayEditboxBackground:AddAnchor("BOTTOMRIGHT", dayLabel, 0, 0)

  local hourEditbox = createTimerFrame:CreateChildWidget("x2editbox", "hourEditbox", 0, true)
  hourEditbox.style:SetColorByKey("default")
  hourEditbox.guideTextStyle:SetColorByKey("guide_text_in_editbox")
  hourEditbox:SetInset(inset[1], inset[2], inset[1], inset[4])
  hourEditbox:SetGuideText("00")
  hourEditbox:SetWidth(zeroWidth * 2 + inset[1] * 2)
  hourEditbox:SetDigit(true)
  hourEditbox:SetDigitEmpty(true)
  hourEditbox:SetMaxTextLength(2)
  hourEditbox:SetCursorColorByColorKey("editbox_cursor_default")

  local hourLabel = createTimerFrame:CreateChildWidget("label", "hourLabel", 0, true)
  hourLabel:SetText(locale.addon.hour)
  hourLabel.style:SetColorByKey("default")
  hourLabel:SetAutoResize(true)
  hourLabel:SetInset(0, 0, inset[1], 0)

  local hourEditboxBackground = hourEditbox:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "background")
  hourEditboxBackground:AddAnchor("TOPLEFT", hourEditbox, 0, 0)
  hourEditboxBackground:AddAnchor("BOTTOMRIGHT", hourLabel, 0, 0)

  local minuteEditbox = createTimerFrame:CreateChildWidget("x2editbox", "minuteEditbox", 0, true)
  minuteEditbox.style:SetColorByKey("default")
  minuteEditbox.guideTextStyle:SetColorByKey("guide_text_in_editbox")
  minuteEditbox:SetInset(inset[1], inset[2], inset[1], inset[4])
  minuteEditbox:SetGuideText("00")
  minuteEditbox:SetWidth(zeroWidth * 2 + inset[1] * 2)
  minuteEditbox:SetDigit(true)
  minuteEditbox:SetDigitEmpty(true)
  minuteEditbox:SetMaxTextLength(2)
  minuteEditbox:SetCursorColorByColorKey("editbox_cursor_default")

  local minuteLabel = createTimerFrame:CreateChildWidget("label", "minuteLabel", 0, true)
  minuteLabel:SetText(locale.addon.minute)
  minuteLabel.style:SetColorByKey("default")
  minuteLabel:SetAutoResize(true)
  minuteLabel:SetInset(0, 0, inset[1], 0)

  local minuteEditboxBackground = minuteEditbox:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "background")
  minuteEditboxBackground:AddAnchor("TOPLEFT", minuteEditbox, 0, 0)
  minuteEditboxBackground:AddAnchor("BOTTOMRIGHT", minuteLabel, 0, 0)

  local secondEditbox = createTimerFrame:CreateChildWidget("x2editbox", "secondEditbox", 0, true)
  secondEditbox.style:SetColorByKey("default")
  secondEditbox.guideTextStyle:SetColorByKey("guide_text_in_editbox")
  secondEditbox:SetInset(inset[1], inset[2], inset[1], inset[4])
  secondEditbox:SetGuideText("00")
  secondEditbox:SetWidth(zeroWidth * 2 + inset[1] * 2)
  secondEditbox:SetDigit(true)
  secondEditbox:SetDigitEmpty(true)
  secondEditbox:SetMaxTextLength(2)
  secondEditbox:SetCursorColorByColorKey("editbox_cursor_default")

  local secondLabel = createTimerFrame:CreateChildWidget("label", "secondLabel", 0, true)
  secondLabel:SetText(locale.addon.second)
  secondLabel.style:SetColorByKey("default")
  secondLabel:SetAutoResize(true)
  secondLabel:SetInset(0, 0, inset[1], 0)

  local secondEditboxBackground = secondEditbox:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "background")
  secondEditboxBackground:AddAnchor("TOPLEFT", secondEditbox, 0, 0)
  secondEditboxBackground:AddAnchor("BOTTOMRIGHT", secondLabel, 0, 0)

  -- Create save button for save frame.
  local createButton = createTimerFrame:CreateChildWidget("button", "createButton", 0, true)
  createButton:SetStyle("expansion")
  createButton:AddAnchor("RIGHT", createTimerFrame, 0, 0)


  dayEditbox:AddAnchor("TOPRIGHT", dayLabel, "TOPLEFT", 0, 0)
  dayEditbox:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  dayLabel:AddAnchor("TOPRIGHT", hourEditbox, "TOPLEFT", 0, 0)
  dayLabel:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  hourEditbox:AddAnchor("TOPRIGHT", hourLabel, "TOPLEFT", 0, 0)
  hourEditbox:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  hourLabel:AddAnchor("TOPRIGHT", minuteEditbox, "TOPLEFT", 0, 0)
  hourLabel:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  minuteEditbox:AddAnchor("TOPRIGHT", minuteLabel, "TOPLEFT", 0, 0)
  minuteEditbox:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  minuteLabel:AddAnchor("TOPRIGHT", secondEditbox, "TOPLEFT", 0, 0)
  minuteLabel:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  secondEditbox:AddAnchor("TOPRIGHT", secondLabel, "TOPLEFT", 0, 0)
  secondEditbox:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  secondLabel:AddAnchor("TOPRIGHT", createButton, "TOPLEFT", 0, 0)
  secondLabel:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  nameEditbox:AddAnchor("TOPLEFT", createTimerFrame, 0, 0)
  nameEditbox:AddAnchor("RIGHT", dayEditbox, "LEFT", 0, 0)
  nameEditbox:AddAnchor("BOTTOM", createTimerFrame, 0, 0)

  createTimerFrame:SetHeight(createButton:GetHeight())

  -- Create a content frame.
  local contentFrame = window:CreateChildWidget("emptywidget", "contentFrame", 0, true)
  contentFrame:AddAnchor("TOPLEFT", createTimerFrame, "BOTTOMLEFT", 0, WINDOW.MARGIN)
  contentFrame:AddAnchor("BOTTOMRIGHT", window, "BOTTOMRIGHT", -WINDOW.MARGIN, -WINDOW.MARGIN)

  -- Create a scroll frame.
  local scrollFrame = contentFrame:CreateChildWidget("emptywidget", "scrollFrame", 0, true)
  scrollFrame:AddAnchor("TOPLEFT", contentFrame, 0, 0)
  scrollFrame:EnableScroll(true)

  -- Create a slider frame.
  local sliderFrame = contentFrame:CreateChildWidget("emptywidget", "sliderFrame", 0, true)
  sliderFrame:AddAnchor("TOPRIGHT", contentFrame, "TOPRIGHT", 0, 0)
  sliderFrame:AddAnchor("BOTTOMLEFT", contentFrame, "BOTTOMRIGHT", -WINDOW.MARGIN, 0)

  scrollFrame:AddAnchor("BOTTOMRIGHT", sliderFrame, "BOTTOMLEFT", 0, 0)

  -- Create a up button for the slider frame.
  local upButton = sliderFrame:CreateChildWidget("button", "upButton", 0, true)
  upButton:AddAnchor("TOPRIGHT", sliderFrame, 0, 0)
  upButton:SetExtent(20, 12)
  upButton:SetStyle("slider_scroll_button_up")

  -- Create a slider for the slider frame.
  local slider = sliderFrame:CreateChildWidget("slider", "slider", 0, true)
  slider:AddAnchor("TOPLEFT", upButton, "BOTTOMLEFT", 0, 0)

  local sliderBackground = slider:CreateDrawable(TEXTURE_PATH.SCROLL, "scroll_frame_bg", "background")
  sliderBackground:SetTextureColor("default")
  sliderBackground:AddAnchor("TOPLEFT", slider, 3, -9)
  sliderBackground:AddAnchor("BOTTOMRIGHT", slider, -3, 9)

  -- Create a thumb for the slider.
  local thumb = slider:CreateChildWidget("button", "thumb", 0, true)
  thumb:EnableDrag(true)
  thumb:SetWidth(20)

  local normalBackground = thumb:CreateDrawable(TEXTURE_PATH.SCROLL, "thumb_df", "background")
  normalBackground:AddAnchor("TOPLEFT", thumb, 0, 0)
  normalBackground:AddAnchor("BOTTOMRIGHT", thumb, 0, 0)
  thumb:SetNormalBackground(normalBackground)

  local highlightBackground = thumb:CreateDrawable(TEXTURE_PATH.SCROLL, "thumb_ov", "background")
  highlightBackground:AddAnchor("TOPLEFT", thumb, 0, 0)
  highlightBackground:AddAnchor("BOTTOMRIGHT", thumb, 0, 0)
  thumb:SetHighlightBackground(highlightBackground)

  local pushedBackground = thumb:CreateDrawable(TEXTURE_PATH.SCROLL, "thumb_on", "background")
  pushedBackground:AddAnchor("TOPLEFT", thumb, 0, 0)
  pushedBackground:AddAnchor("BOTTOMRIGHT", thumb, 0, 0)
  thumb:SetPushedBackground(pushedBackground)

  slider:SetThumbButtonWidget(thumb)

  -- Create a down button for the slider frame.
  local downButton = sliderFrame:CreateChildWidget("button", "downButton", 0, true)
  downButton:AddAnchor("BOTTOMRIGHT", sliderFrame, 0, 0)
  downButton:SetExtent(20, 12)
  downButton:SetStyle("slider_scroll_button_down")

  slider:AddAnchor("BOTTOMRIGHT", downButton, "TOPRIGHT", 0, 0)

  -- Create a list for the content frame.
  local timersListCtrl = scrollFrame:CreateChildWidget("listctrl", "timersListCtrl", 0, true)
  timersListCtrl:AddAnchor("TOPLEFT", 0, 0)
  timersListCtrl:SetWidth(scrollFrame:GetWidth())
  timersListCtrl:InsertColumn(WINDOW.ITEM_DIMENSION, LCCIT_BUTTON)
  timersListCtrl:InsertColumn((timersListCtrl:GetWidth() - WINDOW.ITEM_DIMENSION * 3) / 2, LCCIT_TEXTBOX)
  timersListCtrl:InsertColumn((timersListCtrl:GetWidth() - WINDOW.ITEM_DIMENSION * 3) / 2, LCCIT_TEXTBOX)
  timersListCtrl:InsertColumn(WINDOW.ITEM_DIMENSION, LCCIT_BUTTON)
  timersListCtrl:InsertColumn(WINDOW.ITEM_DIMENSION, LCCIT_BUTTON)

  local overedImage = timersListCtrl:CreateOveredImage()
  overedImage:SetTexture(TEXTURE_PATH.TAB_LIST)
  overedImage:SetTextureInfo("enchant_info_bg", "listctrl_overed_default")

  function timersListCtrl:UpdateList()
    timersListCtrl:DeleteRows()
    timersListCtrl:SetHeaderColumnHeight(0)
    timersListCtrl:SetHeight(WINDOW.ITEM_DIMENSION * #timers)
    timersListCtrl:InsertRows(#timers, false)

    -- Without InsertData overedImage won't work. Putting InsertData inside the
    -- main loop was causing a bug where addonNameTextbox.style:SetEllipsis(true)
    -- wouldn't work so it has been moved to its own loop.
    for row, _ in pairs(timers) do
      timersListCtrl:InsertData(row, 2, "")
      -- timersListCtrl:InsertData(row, 3, "")
    end

    for row, timer in ipairs(timers) do
      local rowWindow = timersListCtrl.items[row]
      local checkButton, timerNameTextbox, timerDurationTextbox, refreshButton, deleteButton = unpack(
        rowWindow.subItems
      )

      -- timersListCtrl:SetHeight should set the correct height of row but for
      -- some reason it doesnt on timer count 2, 4, 6, 11, etc. when the ui is
      -- scaled. 27.9 is normal but sets it as 27 on uiscale .93
      -- Im sure its probably some kind of rounding error but unsure what causes it.
      rowWindow:SetHeight(WINDOW.ITEM_DIMENSION)

      local checkButtonBackground = checkButton:CreateDrawable(TEXTURE_PATH.CHECK_BTN, "btn_df", "background")
      checkButtonBackground:SetExtent(20, 20)
      checkButtonBackground:AddAnchor("CENTER", checkButton, 0, 0)

      local checkButtonCheckedBackground = checkButton:CreateDrawable(TEXTURE_PATH.CHECK_BTN, "btn_chk_df", "background")
      checkButtonCheckedBackground:SetExtent(20, 20)
      checkButtonCheckedBackground:AddAnchor("CENTER", checkButton, 0, 0)
      checkButtonCheckedBackground:SetVisible(timer.startTime ~= nil and timer.pauseTime == nil)

      checkButton:SetHandler("OnClick", function ()
        EnableTimer(timer)
      end)

      timerNameTextbox.style:SetColorByKey("default")
      timerNameTextbox.style:SetAlign(ALIGN_LEFT)
      timerNameTextbox.style:SetFontSize(FONT_SIZE.LARGE)
      timerNameTextbox.style:SetEllipsis(true)
      timerNameTextbox:SetAutoWordwrap(false)
      timerNameTextbox:SetText(timer.name)

      timerNameTextbox:SetHandler("OnClick", function ()
        EnableTimer(timer)
      end)

      timerDurationTextbox.style:SetColorByKey("default")
      timerDurationTextbox.style:SetAlign(ALIGN_LEFT)
      timerDurationTextbox.style:SetFontSize(FONT_SIZE.LARGE)
      timerDurationTextbox.style:SetEllipsis(true)
      timerDurationTextbox:SetAutoWordwrap(false)

      if timer.startTime == nil and timer.pauseTime == nil then
        timerDurationTextbox:SetText(formatDHMS(timer.duration))
      elseif timer.startTime ~= nil and timer.pauseTime == nil then
        -- timerDurationTextbox:UpdateTime()
        -- timerDurationTextbox:SetText(formatDHMS(timer.startTime + timer.duration - os.time()))
        UpdateTimers()
      elseif timer.startTime ~= nil and timer.pauseTime ~= nil then
        timerDurationTextbox:SetText(formatDHMS(timer.duration - (timer.pauseTime - timer.startTime)))
      end

      refreshButton:SetExtent(20, 20)

      local refreshNormalBackground = assert(refreshButton:CreateImageDrawable(BUTTON_TEXTURE_PATH.COMMON_RESET,
        "background"))
      refreshNormalBackground:SetTextureInfo("reset_df")
      refreshNormalBackground:AddAnchor("TOPLEFT", refreshButton, 0, 0)
      refreshNormalBackground:AddAnchor("BOTTOMRIGHT", refreshButton, 0, 0)
      refreshButton:SetNormalBackground(refreshNormalBackground)

      local refreshHighlightBackground = assert(refreshButton:CreateImageDrawable(BUTTON_TEXTURE_PATH.COMMON_RESET,
        "background"))
      refreshHighlightBackground:SetTextureInfo("reset_ov")
      refreshHighlightBackground:AddAnchor("TOPLEFT", refreshButton, 0, 0)
      refreshHighlightBackground:AddAnchor("BOTTOMRIGHT", refreshButton, 0, 0)
      refreshButton:SetHighlightBackground(refreshHighlightBackground)

      local refreshPushedBackground = assert(refreshButton:CreateImageDrawable(BUTTON_TEXTURE_PATH.COMMON_RESET,
        "background"))
      refreshPushedBackground:SetTextureInfo("reset_on")
      refreshPushedBackground:AddAnchor("TOPLEFT", refreshButton, 0, 0)
      refreshPushedBackground:AddAnchor("BOTTOMRIGHT", refreshButton, 0, 0)
      refreshButton:SetPushedBackground(refreshPushedBackground)

      local refreshDisabledBackground = assert(refreshButton:CreateImageDrawable(BUTTON_TEXTURE_PATH.COMMON_RESET,
        "background"))
      refreshDisabledBackground:SetTextureInfo("reset_dis")
      refreshDisabledBackground:AddAnchor("TOPLEFT", refreshButton, 0, 0)
      refreshDisabledBackground:AddAnchor("BOTTOMRIGHT", refreshButton, 0, 0)
      refreshButton:SetDisabledBackground(refreshDisabledBackground)

      ---@TODO: move this to the timers.lua
      refreshButton:SetHandler("OnClick", function ()
        timer.startTime = nil
        timer.pauseTime = nil

        local error = table.save(filePath, timers)

        if error then
          ADDON:ChatLog(error)
        else
          timersListCtrl:UpdateList()
        end
      end)

      deleteButton:SetStyle("btn_close_default")
      deleteButton:SetExtent(20, 20)

      ---@TODO: move this to the timers.lua
      deleteButton:SetHandler("OnClick", function ()
        table.remove(timers, row)

        local error = table.save(filePath, timers)

        if error then
          ADDON:ChatLog(error)
        else
          timersListCtrl:UpdateList()
        end
      end)
    end

    local min = 0
    -- @TODO:
    -- When the 11 timer was added and then removed I was getting a floating
    -- point bug.
    -- timersListCtrl:GetHeight() = 330
    -- scrollFrame:GetHeight() = 300
    -- 330 - 300 = 30.0001
    -- This only happens after the first time this used for some odd reason.
    local max = math.max(min, math.floor(timersListCtrl:GetHeight() - scrollFrame:GetHeight()))

    slider:SetMinMaxValues(min, max)

    if max == min then
      upButton:Enable(false)
      thumb:Enable(false)
      downButton:Enable(false)
      sliderBackground:SetTextureColor("disable")
    else
      upButton:Enable(true)
      thumb:Enable(true)
      downButton:Enable(true)
      sliderBackground:SetTextureColor("default")
    end
  end

  timersListCtrl:UpdateList()

  return window
end

---Sets up the view of the finished timer window.
---@param timer Timer
---@return Window
function SetViewOfFinishedTimer(timer)
  -- Create the main window.
  local window = UIParent:CreateWidget("window", "timers", "UIParent")
  window:AddAnchor("RIGHT", "UIParent", 0, 0)
  window:SetExtent(250, 180)

  -- Add background to the main window.
  local background = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "main_bg", "background")
  background:AddAnchor("TOPLEFT", window, -5, -5)
  background:AddAnchor("BOTTOMRIGHT", window, 5, 5)

  -- Add title decoration to the main window.
  local decoration = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "main_bg_deco", "background")
  decoration:AddAnchor("TOPLEFT", window, 0, -5)
  decoration:AddAnchor("TOPRIGHT", window, 0, -5)

  -- Create title bar.
  local titleBar = window:CreateChildWidget("window", "titleBar", 0, true)
  titleBar.titleStyle:SetAlign(ALIGN_CENTER)
  titleBar.titleStyle:SetSnap(true)
  titleBar.titleStyle:SetFont(FONT_PATH.SUB, FONT_SIZE.XLARGE)
  titleBar.titleStyle:SetColorByKey("title")
  titleBar.titleStyle:SetEllipsis(true)
  titleBar:AddAnchor("TOPLEFT", window, 0, 0)
  titleBar:AddAnchor("TOPRIGHT", window, 0, 0)
  titleBar:SetTitleText(locale.addon.timerFinishedTitle)
  titleBar:EnableDrag(true)
  titleBar:SetHeight(45)

  -- Add close button to title bar.
  local closeButton = titleBar:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:AddAnchor("TOPRIGHT", titleBar, WINDOW.CLOSE_BUTTON_OFFSET, -WINDOW.CLOSE_BUTTON_OFFSET)
  closeButton:SetStyle("btn_close_default")

  local timerTextbox = window:CreateChildWidget("textbox", "timerTextbox", 0, true)
  timerTextbox.style:SetColorByKey("default")
  timerTextbox.style:SetFontSize(FONT_SIZE.LARGE)
  timerTextbox.style:SetEllipsis(true)
  timerTextbox:SetAutoWordwrap(true)
  timerTextbox:AddAnchor("TOPLEFT", titleBar, "BOTTOMLEFT", WINDOW.MARGIN, 0)
  timerTextbox:AddAnchor("BOTTOMRIGHT", window, "BOTTOMRIGHT", -WINDOW.MARGIN, -WINDOW.MARGIN)
  timerTextbox:SetText(timer.name)

  return window
end
