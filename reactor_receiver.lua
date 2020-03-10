-- Reactor Receiver
-- by cowslaw

-- Configuration
local rednetProtocol = 'cow.reactor'
local rednetHostname = 'cow.reactor.mon1'
local modemLocation = 'top'
local monitorLocation = 'left'

local monitor = peripheral.wrap(monitorLocation)

-- Functions
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

function round(value)
	return math.floor(value + 0.5)
end

-- Main
rednet.open(modemLocation)
rednet.host(rednetProtocol, rednetHostname)

while true do
  local sender, t, protocol = rednet.receive(rednetProtocol)

  monitor.setBackgroundColor(colors.black)
  monitor.setTextColor(colors.white)
  monitor.clear()
  monitor.setTextScale(1)
  monitor.setCursorPos(2, 2)

  drawCenteredLabel('Reactor Stats')

  drawLabel(
  	'Status: ',
  	(t['isActive'] and 'Online' or 'Offline') .. ' (' .. round(t['energyPerTick']) .. ' RF/t)',
  	t['isActive'] and colors.green or colors.red
  )

  drawLabeledBar(
  	'Energy: ',
  	t['storedEnergy'] .. ' RF (' .. round(t['energyPercentage'] * 100) .. '%)',
  	t['energyPercentage'],
  	colors.gray,
  	colors.green
  )

  drawLabeledBar(
  	'Fuel:   ',
  	t['storedFuel'] .. ' mB (' .. round(t['fuelPercentage'] * 100) .. '%)',
  	t['fuelPercentage'],
  	colors.gray,
  	colors.yellow
  )
end
