-- Built off of concepts from: https://www.youtube.com/watch?v=-O6pd9nhL8U

local menu_options = {
  { text = "Lights", side = "bottom", enabled = true },
  { text = "Masher", side = "back", enabled = false },
}

local focused = 1

local function drawMenu()
  local termX, termY = term.getSize()
  local yPos = termY / 2 - #menu_options / 2

  for index, option in pairs(menu_options) do
    menu_options[index].pos = {
      x = termX / 2 - (#option.text + 4) / 2;
      y = yPos;
    }

    if option.enabled then
      term.setTextColor(colors.green)
    else
      term.setTextColor(colors.red)
    end

    term.setCursorPos(option.pos.x, option.pos.y)
    term.write((index == focused) and "[ " .. option.text .. " ]" or "  " .. option.text .. "  ")

    yPos = yPos + 2
  end
end

local function updateOutputs()
  for index, option in pairs(menu_options) do
    redstone.setOutput(menu_options[index].side, menu_options[index].enabled)
  end
end

term.setBackgroundColor(colors.black)
term.clear()

while true do
  updateOutputs()
  drawMenu()

  local event = { os.pullEvent() }

  if event[1] == "key" then
    local key = event[2]

    if key == keys.down then
      focused = focused < #menu_options and focused + 1 or #menu_options
    elseif key == keys.up then
      focused = focused > 1 and focused - 1 or 1
    elseif key == keys.enter or key == keys.space then
      menu_options[focused].enabled = not menu_options[focused].enabled
    end
  end
end
