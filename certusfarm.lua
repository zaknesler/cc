-- e.g. the following has a width of 2 and depth of 5, place the turtle on the X, facing right
-- 0 0 0 0 0
-- X 0 0 0 0

local width = 3
local depth = 3
local waitMins = 30

local function check()
  local _, data = turtle.inspectDown()

  if data.name == "ae2:quartz_cluster" then
    turtle.digDown()
  end
end

local function moveToNextRow(x)
  if x % 2 == 0 then
    turtle.turnRight()
  else
    turtle.turnLeft()
  end

  turtle.forward()

  if x % 2 == 0 then
    turtle.turnRight()
  else
    turtle.turnLeft()
  end
end

while true do
  for x = 1, width do
    for _ = 1, depth - 1 do
      check()
      turtle.forward()
      check()
    end

    if x ~= width then
      moveToNextRow(x)
    end
  end

  if width % 2 ~= 0 then
    turtle.turnLeft()
    turtle.turnLeft()

    for _ = 1, depth - 1 do
      turtle.forward()
    end
  end

  turtle.turnLeft()

  for _ = 1, width - 1 do
    turtle.forward()
  end

  turtle.turnLeft()

  os.sleep(waitMins * 60)
end
