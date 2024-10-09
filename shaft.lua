local args = { ... }

-- block that will be used to build the bridge
local targetBlock = nil

local function shouldPlaceBlock()
  local item = turtle.getItemDetail()
  if item == nil then
    return false
  end

  return item.name == targetBlock
end

local function shouldSelectNextSlot()
  -- we can't select the next slot if we're already at the end
  if turtle.getSelectedSlot() == 16 then
    return false
  end

  return turtle.getItemCount() == 0 or not shouldPlaceBlock()
end

local function maybeSelectNextSlot()
  while shouldSelectNextSlot() do
    turtle.select(turtle.getSelectedSlot() + 1)
  end
end


local function tryDig()
  while turtle.detect() do
    turtle.dig()
    turtle.attack()
  end
end

local function tryPlace()
  maybeSelectNextSlot()

  if turtle.compare() or not shouldPlaceBlock() then
    return
  end

  tryDig()
  turtle.place()
end

local function tryPlaceDown()
  maybeSelectNextSlot()

  if turtle.compareDown() or not shouldPlaceBlock() then
    return
  end

  while turtle.detectDown() do
    turtle.digDown()
    turtle.attackDown()
  end

  turtle.placeDown()
end

local function tryForward()
  tryDig()
  turtle.forward()
end

local function countBlocks(blockName)
  local total = 0

  for i = 1, 16 do
    local data = turtle.getItemDetail(i)
    if data ~= nil and data.name == blockName then
      total = total + turtle.getItemCount(i)
    end
  end

  return total
end

local function maybePlaceFloor(maxDepth, currentLevel)
  if currentLevel ~= maxDepth then
    return
  end

  tryPlaceDown()
end

local function placeWall(maxDepth, currentLevel)
  maybePlaceFloor(maxDepth, currentLevel)
  tryPlace()
  turtle.turnRight()
  tryForward()
  maybePlaceFloor(maxDepth, currentLevel)
  turtle.turnLeft()
  tryPlace()
  turtle.turnRight()
  tryForward()
  maybePlaceFloor(maxDepth, currentLevel)
  turtle.turnLeft()
  tryPlace()
end

local function main(depth)
  turtle.select(1)

  local data = turtle.getItemDetail()
  if data == nil then
    print("at least one block of bridge material must be in the first slot")
    return
  end

  targetBlock = data.name
  print("using: " .. targetBlock)

  local numBlocks = countBlocks(targetBlock)
  local blocksNeeded = (12 * depth) + 9

  if numBlocks < blocksNeeded then
    print("not enough blocks!")
    print("  need: " .. math.floor(blocksNeeded / 64) .. " stack(s) + " .. blocksNeeded % 64 .. " block(s)")
    print("  have: " .. numBlocks .. " block(s)")
    return
  end

  for i = 1, depth do
    turtle.digDown()
    turtle.down()

    maybePlaceFloor(depth, i)
    tryForward()
    maybePlaceFloor(depth, i)
    tryForward()
    maybePlaceFloor(depth, i)
    tryPlace()
    turtle.turnLeft()
    tryPlace()
    turtle.turnLeft()
    turtle.turnLeft()
    tryPlace()
    turtle.turnRight()
    tryForward()

    turtle.turnLeft()
    tryForward()

    placeWall(depth, i)
    turtle.turnRight()
    placeWall(depth, i)
    turtle.turnRight()
    placeWall(depth, i)

    turtle.back()
    turtle.turnRight()
    turtle.back()
  end

  for _ = 1, depth do
    turtle.up()
  end

  -- turtle.turnRight()
  -- turtle.up()
  -- tryBack()
  -- tryBack()
end

if #args == 1 then
  main(tonumber(args[1]))
else
  print("usage: shaft <depth>")
end
