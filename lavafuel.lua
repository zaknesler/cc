while turtle.getFuelLevel() ~= turtle.getFuelLimit() do
    turtle.suck()
    turtle.refuel()
    turtle.drop()
    term.clear()
    term.setCursorPos(1, 1)
    print("fuel level: " .. turtle.getFuelLevel() .. "/" .. turtle.getFuelLimit())
    os.sleep(3)
end

print("finished refueling")
