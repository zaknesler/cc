-- Tree Farm
-- by cowslaw

local saplingSlot = 1
local logSlot = 2
local sleepAmount = 5

-- Main Program
while true do
  turtle.select(logSlot)

  if turtle.compare() then
    turtle.dig()
    turtle.forward()

    local height = 0
    while turtle.detectUp() do
      turtle.digUp()
      turtle.up()

      height = height + 1
    end

    for i = 1, height do
      turtle.down()
    end

    turtle.back()
    turtle.select(saplingSlot)
    turtle.place()

    turtle.turnRight()
    turtle.turnRight()

    for i = 3, 16 do
      turtle.select(i)
      turtle.drop()
    end

    turtle.turnLeft()
    turtle.turnLeft()
  end

  os.sleep(sleepAmount)
end
