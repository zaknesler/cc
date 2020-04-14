-- Reactor Transmitter
-- by cowslaw

-- Configuration
local rednetProtocol = 'cow.reactor'
local rednetHostname = 'cow.reactor.host'
local modemLocation = 'right'
local reactorLocation = 'back'
local autoToggle = true
local activateThreshold = 0.50
local deactivateThreshold = 0.95
local updateFrequency = 5

local reactor = peripheral.wrap(reactorLocation)

-- Functions
function checkEnergyThreshold()
  local energyPercentage = reactor.getEnergyStored() / reactor.getEnergyStats()['energyCapacity']
  local isActive = reactor.getActive()

  if not isActive and energyPercentage <= activateThreshold then
    print('Activating...')
    reactor.setActive(true)
  elseif isActive and energyPercentage >= deactivateThreshold then
    print('Deactivating...')
    reactor.setActive(false)
  end
end

-- Main
rednet.open(modemLocation)
rednet.host(rednetProtocol, rednetHostname)

storedEnergyLast = reactor.getEnergyStored()

while true do
  if autoToggle then
    checkEnergyThreshold()
  end

  t = {}
  t['isActive'] = reactor.getActive()

  local energyStats = reactor.getEnergyStats()

  t['energyPerTick'] = energyStats['energyProducedLastTick']
  t['storedEnergy'] = energyStats['energyStored']
  t['energyMax'] = energyStats['energyCapacity']
  t['energyPercentage'] = t['storedEnergy'] / t['energyMax']
  t['energyChangePerTick'] = (t['storedEnergy'] - storedEnergyLast) / (updateFrequency * 20)

  t['fuelUsedPerTick'] = reactor.getFuelConsumedLastTick()
  t['storedFuel'] = reactor.getFuelAmount()
  t['fuelMax'] = reactor.getFuelAmountMax()
  t['fuelPercentage'] = t['storedFuel'] / t['fuelMax']
  t['fuelReactivity'] = reactor.getFuelReactivity() / 100

  t['caseTemp'] = reactor.getCasingTemperature()
  t['coreTemp'] = reactor.getFuelTemperature()

  storedEnergyLast = reactor.getEnergyStored()

  rednet.broadcast(t, rednetProtocol)
  os.sleep(updateFrequency)
end
