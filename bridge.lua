local args = { ... }

-- block that will be used to build the bridge
local bridgeBlock = nil

local function repeatDig()
  while turtle.detect() do
    turtle.dig()
  end
end

local function shouldPlaceBlock()
  local item = turtle.getItemDetail()
  if item == nil then
    return false
  end

  return item.name == bridgeBlock
end

local function shouldSelectNextSlot()
  -- we can't select the next slot if we're already at the end
  if turtle.getSelectedSlot() == 16 then
    return false
  end

  return turtle.getItemCount() == 0 or not shouldPlaceBlock()
end

local function tryPlace()
  while shouldSelectNextSlot() do
    turtle.select(turtle.getSelectedSlot() + 1)
  end

  if turtle.getSelectedSlot() == 16 and turtle.getItemCount == 0 then
    print("no more items")
    -- exit? i dunno how
  end

  if turtle.compare() or not shouldPlaceBlock() then
    return
  end

  repeatDig()
  turtle.place()
end

local function tryBack()
  if not turtle.back() then
    turtle.turnLeft()
    turtle.turnLeft()
    repeatDig()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.back()
  end
end

local function main(length)
  turtle.select(1)

  local data = turtle.getItemDetail()
  if data == nil then
    print("at least one block of bridge material must be in the first slot")
    return
  end

  bridgeBlock = data.name
  print("bridge block set: " .. bridgeBlock)

  turtle.forward()
  turtle.digDown()
  turtle.down()
  turtle.turnLeft()

  for _ = 1, length do
    tryPlace()
    turtle.turnLeft()
    turtle.turnLeft()
    tryPlace()
    turtle.turnRight()
    tryBack()
    tryPlace()
    turtle.turnRight()
  end

  turtle.turnRight()
  turtle.up()
  tryBack()
  tryBack()
end

if #args == 1 then
  main(tonumber(args[1]))
else
  print("usage: bridge <length>")
end
