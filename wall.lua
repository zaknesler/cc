-- Turtle Wall Builder
-- By cowslaw
-- Usage: wall <x> <y>
-- Place fuel in slot 1
-- Place all blocks in and after slot 2.

local args = { ... }

function hasEnoughBlocks(width, height)
  total = 0

  for i = 2, 16 do
    total = total + turtle.getItemCount(i)
  end

  return total >= width * height
end

function checkFuel()
  if turtle.getFuelLevel() > 0 then
    return
  end

  lastSlot = turtle.getSelectedSlot()

  turtle.select(1)
  turtle.refuel(1)
  turtle.select(lastSlot)
end

function repeatDig()
  while turtle.detect() do
    turtle.dig()
  end
end

function repeatDigUp()
  while turtle.detectUp() do
    turtle.digUp()
  end
end

function repeatDigDown()
  while turtle.detectDown() do
    turtle.digDown()
  end
end

function place()
  local slot = turtle.getSelectedSlot()

  while turtle.getItemCount(slot) == 0 do
    slot = slot + 1

    if slot <= 16 then
      turtle.select(slot)
    end
  end

  if turtle.compare() then
    return
  end

  repeatDig()
  turtle.place()
end

function printProgress(x, y, width, height)
  term.clear()
  term.setCursorPos(1, 1)

  percentComplete = (((x - 1) * height) + y) / (width * height)

  print('Building wall... ' .. math.floor(percentComplete * 100, 3) .. '% complete')
  print('(x: ' .. x .. ' of ' .. width .. ') (y: ' .. y .. ' of ' .. height .. ')')
end

function main(width, height)
  if not hasEnoughBlocks(width, height) then
    print('Error: Not enough blocks to complete wall.')

    return
  end

  turtle.select(2)

  for x = 1, width do
    for y = 1, height do
      checkFuel()
      place()
      printProgress(x, y, width, height)

      if y < height then
        if x % 2 == 0 then
          repeatDigDown()
          turtle.down()
        else
          repeatDigUp()
          turtle.up()
        end
      end
    end

    if x < width then
      turtle.turnRight()
      repeatDig()
      turtle.forward()
      turtle.turnLeft()
    end
  end

  if width % 2 ~= 0 then
    for d = 1, height - 1 do
      repeatDigDown()
      turtle.down()
    end
  end

  if width == 1 then
    return
  end

  turtle.turnLeft()

  for d = 1, width - 1 do
    repeatDig()
    turtle.forward()
  end

  turtle.turnRight()
end

if #args == 2 then
  main(tonumber(args[1]), tonumber(args[2]))
elseif #args == 1 then
  main(tonumber(args[1]), tonumber(args[1]))
else
  print('Error: Invalid arguments.')
  print('Usage: wall <width> <height> or wall <width/height>')
end
