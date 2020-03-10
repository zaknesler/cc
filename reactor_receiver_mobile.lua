-- Reactor Receiver (Mobile Version)
-- by cowslaw

-- Configuration
local rednetProtocol = 'cow.reactor'
local rednetHostname = 'cow.reactor.mobile1'

-- Functions
function drawCenteredLabel(text)
  local width, height = term.getSize()
  local cursorX, cursorY = term.getCursorPos()

  term.setCursorPos(math.floor((width / 2) - (#text / 2)) + 1, cursorY)
  term.write(text)
  term.setCursorPos(2, cursorY + 2)
end

function drawLabel(label, text, color)
  local cursorX, cursorY = term.getCursorPos()

  term.setTextColor(colors.yellow)
  term.write(label)

  term.setTextColor(color and color or colors.white)
  term.write(text)

  term.setCursorPos(2, cursorY + 2)
end

function drawLabeledBar(label, text, percentage, colorBg, colorFill)
  local width, height = term.getSize()
  local cursorX, cursorY = term.getCursorPos()
  local maxBarWidth = width - 2

  term.setTextColor(colors.yellow)
  term.write(label)

  term.setTextColor(colors.white)
  term.write(text)

  term.setCursorPos(2, cursorY + 1)
  term.setBackgroundColor(colorBg)
  term.write(string.rep(' ', maxBarWidth))

  term.setCursorPos(2, cursorY + 1)
  term.setBackgroundColor(colorFill)
  term.write(string.rep(' ', math.floor(maxBarWidth * percentage)))

  term.setCursorPos(2, cursorY + 3)
  term.setBackgroundColor(colors.black)
end

function round(value)
	return math.floor(value + 0.5)
end

-- Main
rednet.open('back')
rednet.host(rednetProtocol, rednetHostname)

while true do
  local sender, t, protocol = rednet.receive(rednetProtocol)

  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.clear()
  term.setCursorPos(2, 2)

  drawCenteredLabel('Reactor Stats')

  drawLabel(
  	'Status: ',
  	(t['isActive'] and 'Online' or 'Offline') .. ' (' .. round(t['energyPerTick']) .. ' RF/t)',
  	t['isActive'] and colors.green or colors.red
  )

  drawLabel('Core Temp:  ', round(t['coreTemp']) .. ' C')
  drawLabel('Case Temp:  ', round(t['caseTemp']) .. ' C')
  drawLabel('Reactivity: ', round(t['fuelReactivity'] * 100) .. '%')
  drawLabel('Fuel Use:   ', round(t['fuelUsedPerTick']) .. ' mB/t')

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
