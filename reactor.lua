-- Reactor Monitor v1.0
-- by cowslaw

-- Constants
local autoToggle = true
local maxEnergy = 1e7
local activateThreshold = 0.50
local deactivateThreshold = 0.95
local updateFrequency = 0.2

-- Peripherals
local reactor = peripheral.wrap('BigReactors-Reactor_0')
local monitor = peripheral.wrap('left')

function checkThreshold()
  local energyPercentage = reactor.getEnergyStored() / maxEnergy
  local isActive = reactor.getActive()

  if not isActive and energyPercentage <= activateThreshold then
    print('Activating...')
    reactor.setActive(true)
  elseif isActive and energyPercentage >= deactivateThreshold then
    print('Deactivating...')
    reactor.setActive(false)
  end
end

function drawCenteredLabel(text)
  local width, height = monitor.getSize()
  local cursorX, cursorY = monitor.getCursorPos()

  monitor.setCursorPos(math.floor((width / 2) - (#text / 2)) + 1, cursorY)
  monitor.write(text)
  monitor.setCursorPos(2, cursorY + 2)
end

function drawLabel(label, text, color)
  local cursorX, cursorY = monitor.getCursorPos()

  monitor.setTextColor(colors.yellow)
  monitor.write(label)

  monitor.setTextColor(color and color or colors.white)
  monitor.write(text)

  monitor.setCursorPos(2, cursorY + 2)
end

function drawLabeledBar(label, text, percentage, colorBg, colorFill)
  local width, height = monitor.getSize()
  local cursorX, cursorY = monitor.getCursorPos()
  local maxBarWidth = width - 2

  monitor.setTextColor(colors.yellow)
  monitor.write(label)

  monitor.setTextColor(colors.white)
  monitor.write(text)

  monitor.setCursorPos(2, cursorY + 1)
  monitor.setBackgroundColor(colorBg)
  monitor.write(string.rep(' ', maxBarWidth))

  monitor.setCursorPos(2, cursorY + 1)
  monitor.setBackgroundColor(colorFill)
  monitor.write(string.rep(' ', math.floor(maxBarWidth * percentage)))

  monitor.setCursorPos(2, cursorY + 3)
  monitor.setBackgroundColor(colors.black)
end

function updateScreen()
  local isActive = reactor.getActive()

  local storedEnergy = math.floor(reactor.getEnergyStored())
  local energyPercentage = storedEnergy / maxEnergy

  local storedFuel = math.floor(reactor.getFuelAmount())
  local fuelMax = reactor.getFuelAmountMax()
  local fuelPercentage = storedFuel / fuelMax

  drawCenteredLabel('Reactor Stats')

  drawLabel('Status: ',
    isActive and 'Online' or 'Offline',
    isActive and colors.green or colors.red
  )

  drawLabeledBar('Energy: ',
    storedEnergy .. ' RF (' .. math.floor(energyPercentage * 100) .. '%)',
    energyPercentage,
    colors.gray,
    colors.green
  )

  drawLabeledBar(
    'Fuel:   ',
    storedFuel .. '/' .. fuelMax .. ' (' .. math.floor(fuelPercentage * 100) .. '%)',
    fuelPercentage,
    colors.gray,
    colors.yellow
  )
end

while true do
  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.white)
  monitor.clear()
  monitor.setTextScale(1)
  monitor.setCursorPos(2, 2)

  if autoToggle then
    checkThreshold()
  end

  updateScreen()

  os.sleep(updateFrequency)
end
