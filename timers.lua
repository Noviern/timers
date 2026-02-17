local UIC_TIMERS = 12345677
local timersWindow
local timers = table.load(filePath)

---Creates a finished timer window.
---@return Window
local function CreateFinishedTimerWindow(timer)
  local window           = SetViewOfFinishedTimer(timer)
  local titleBar         = window.titleBar ---@type Window
  local closeButton      = titleBar.closeButton ---@type Button

  window:SetSounds("bag")
  window:SetCloseOnEscape(true)
  window:EnableHidingIsRemove(true)
  window:SetAlphaAnimation(0, 1, .1, .1)
  window:SetStartAnimation(true, true)
  window:SetUILayer("normal")

  window:SetHandler("OnScale", function (self)
    CorrectWidgetScreenPos(window)
  end)

  titleBar:SetHandler("OnDragStart", function ()
    window:StartMoving()
  end)

  titleBar:SetHandler("OnDragStop", function ()
    window:StopMovingOrSizing()
    CorrectWidgetScreenPos(window)
  end)

  closeButton:SetHandler("OnClick", function ()
    window:Show(false)
  end)

  local timeCheck = 0
  window:SetHandler("OnUpdate", function (self, frameTime)
    timeCheck = timeCheck + frameTime

    if timeCheck < 1000 then
      return
    end

    timeCheck = timeCheck % 1000
    X2Sound:PlayUISound("event_commercial_mail_alarm")
  end)

  return window
end

function UpdateTimers()
  for row, timer in ipairs(timers) do
    if timer.startTime ~= nil and timer.pauseTime == nil then
      local remainingTime = timer.startTime + timer.duration - os.time()

      if remainingTime <= 0 then
        timer.startTime = nil
        timer.pauseTime = nil

        local error = table.save(filePath, timers)

        if error then
          ADDON:ChatLog(error)
        else
          local finishedTimerWindow = CreateFinishedTimerWindow(timer)
          finishedTimerWindow:Show(true)
        end

        if timersWindow ~= nil and timersWindow:IsVisible(true) then
          timersWindow.contentFrame.scrollFrame.timersListCtrl:UpdateList()
        end
      elseif timersWindow ~= nil and timersWindow:IsVisible(true) then
        local rowWindow = timersWindow.contentFrame.scrollFrame.timersListCtrl.items[row]
        local checkButton, timerNameTextbox, timerDurationTextbox, refreshButton, deleteButton = unpack(
          rowWindow.subItems
        )
        timerDurationTextbox:SetText(formatDHMS(remainingTime))
      end
    end
  end
end

function EnableTimer(timer)
  if timer.startTime == nil and timer.pauseTime == nil then
    timer.startTime = os.time()
  elseif timer.startTime ~= nil and timer.pauseTime == nil then
    timer.pauseTime = os.time()
  elseif timer.startTime ~= nil and timer.pauseTime ~= nil then
    timer.startTime = timer.startTime + (os.time() - timer.pauseTime)
    timer.pauseTime = nil
  end

  local error = table.save(filePath, timers)

  if error then
    ADDON:ChatLog(error)
  else
    timersWindow.contentFrame.scrollFrame.timersListCtrl:UpdateList()
  end
end

---Formats seconds into day hour minute seconds.
---@param seconds number
---@return string
function formatDHMS(seconds)
  if not seconds or seconds <= 0 then
    return "0 s"
  end

  seconds            = math.floor(seconds)

  local totalDays    = math.floor(seconds / DAY)
  local totalHours   = math.floor((seconds % DAY) / HOUR)
  local totalMinutes = math.floor((seconds % HOUR) / MINUTE)
  local totalSeconds = seconds % 60

  local parts        = {}

  if totalDays > 0 then
    table.insert(parts, totalDays .. " d")
  end

  if totalHours > 0 or totalDays > 0 then
    table.insert(parts, totalHours .. " h")
  end

  if totalMinutes > 0 or totalHours > 0 or totalDays > 0 then
    table.insert(parts, totalMinutes .. " m")
  end

  table.insert(parts, totalSeconds .. " s")

  return table.concat(parts, " ")
end

---Creates a example addon window.
---@return Window
local function CreateTimersWindow()
  local window           = SetViewOfTimers(timers)
  local titleBar         = window.titleBar ---@type Window
  local closeButton      = titleBar.closeButton ---@type Button
  local createTimerFrame = window.createTimerFrame ---@type EmptyWidget
  local nameEditbox      = createTimerFrame.nameEditbox ---@type X2Editbox
  local dayEditbox       = createTimerFrame.dayEditbox ---@type X2Editbox
  local hourEditbox      = createTimerFrame.hourEditbox ---@type X2Editbox
  local minuteEditbox    = createTimerFrame.minuteEditbox ---@type X2Editbox
  local secondEditbox    = createTimerFrame.secondEditbox ---@type X2Editbox
  local createButton     = createTimerFrame.createButton ---@type Button
  local contentFrame     = window.contentFrame ---@type EmptyWidget
  local scrollFrame      = contentFrame.scrollFrame ---@type EmptyWidget
  local sliderFrame      = contentFrame.sliderFrame ---@type EmptyWidget
  local upButton         = sliderFrame.upButton ---@type Button
  local downButton       = sliderFrame.downButton ---@type Button
  local slider           = sliderFrame.slider ---@type Slider
  local timersListCtrl   = scrollFrame.timersListCtrl ---@type ListCtrl

  window:SetSounds("bag")
  window:SetCloseOnEscape(true)
  -- window:EnableHidingIsRemove(true)
  window:SetAlphaAnimation(0, 1, .1, .1)
  window:SetStartAnimation(true, true)
  window:SetUILayer("normal")

  window:SetHandler("OnScale", function (self)
    CorrectWidgetScreenPos(window)
  end)

  titleBar:SetHandler("OnDragStart", function ()
    window:StartMoving()
  end)

  titleBar:SetHandler("OnDragStop", function ()
    window:StopMovingOrSizing()
    CorrectWidgetScreenPos(window)
  end)

  closeButton:SetHandler("OnClick", function ()
    window:Show(false)
  end)

  local function CreateTimer()
    local timerName = nameEditbox:GetText()

    if #timerName > 0 then
      local timerDay    = tonumber(dayEditbox:GetText()) or 0
      local timerHour   = tonumber(hourEditbox:GetText()) or 0
      local timerMinute = tonumber(minuteEditbox:GetText()) or 0
      local timerSecond = tonumber(secondEditbox:GetText()) or 0
      local duration    = timerDay * DAY + timerHour * HOUR + timerMinute * MINUTE + timerSecond * SECOND

      if duration > 0 then
        ---@type Timer
        local timer = {
          name     = timerName,
          duration = duration
        }

        table.insert(timers, timer)

        nameEditbox:SetText("")
        dayEditbox:SetText("")
        hourEditbox:SetText("")
        minuteEditbox:SetText("")
        secondEditbox:SetText("")

        nameEditbox:ClearFocus()
        dayEditbox:ClearFocus()
        hourEditbox:ClearFocus()
        minuteEditbox:ClearFocus()
        secondEditbox:ClearFocus()

        local error = table.save(filePath, timers)

        if error then
          ADDON:ChatLog(error)
        else
          timersListCtrl:UpdateList()
        end
      end
    end
  end

  dayEditbox:SetHandler("OnEnterPressed", CreateTimer)
  hourEditbox:SetHandler("OnEnterPressed", CreateTimer)
  minuteEditbox:SetHandler("OnEnterPressed", CreateTimer)
  secondEditbox:SetHandler("OnEnterPressed", CreateTimer)
  createButton:SetHandler("OnClick", CreateTimer)

  upButton:SetHandler("OnClick", function ()
    slider:Up(WINDOW.ITEM_DIMENSION)
  end)

  slider:SetHandler("OnSliderChanged", function (self, value)
    scrollFrame:ChangeChildAnchorByScrollValue("vert", value)
  end)

  downButton:SetHandler("OnClick", function ()
    slider:Down(WINDOW.ITEM_DIMENSION)
  end)

  slider:SetPageStep(WINDOW.ITEM_DIMENSION)
  slider:SetValueStep(WINDOW.ITEM_DIMENSION)
  slider:SetFixedThumb(true)

  contentFrame:SetHandler("OnWheelUp", function ()
    slider:Up(WINDOW.ITEM_DIMENSION)
  end)

  contentFrame:SetHandler("OnWheelDown", function ()
    slider:Down(WINDOW.ITEM_DIMENSION)
  end)

  window:SetHandler("OnShow", function (self)
    UpdateTimers()
  end)

  return window
end

---Toggles the example addon window.
---@param show boolean|nil
local function ToggleTimersWindow(show)
  -- If the window should be shown.
  if show == nil then
    show = timersWindow == nil or not timersWindow:IsVisible()
  end

  -- If the window should be shown and doesn't exist, create it.
  if show == true and timersWindow == nil then
    timersWindow = CreateTimersWindow()

    timersWindow:SetDeletedHandler(function ()
      timersWindow = nil
    end)
  end

  -- If the window exists, Show or Hide it.
  if timersWindow then
    timersWindow:Show(show)
  end
end

function CreateTimerNotificationWindow()
  local timerNotifier = UIParent:CreateWidget("emptywidget", "timerNotifier", "UIParent")
  timerNotifier:Show(true)

  local timeCheck = 0
  timerNotifier:SetHandler("OnUpdate", function (self, frameTime)
  timeCheck = timeCheck + frameTime

  if timeCheck < 1000 then
    return
  end

  timeCheck = timeCheck % 1000

  UpdateTimers()
  end)
end

CreateTimerNotificationWindow()

ADDON:RegisterContentTriggerFunc(UIC_TIMERS, ToggleTimersWindow)
ADDON:AddEscMenuButton(4, UIC_TIMERS, "optimizer", locale.addon.name)
