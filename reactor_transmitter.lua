-- Reactor Transmitter
-- by cowslaw

-- Configuration
local rednetProtocol = 'cow.reactor'
local rednetHostname = 'cow.reactor.host'
local modemLocation = 'right'
local reactorLocation = 'back'
local autoToggle = true
local maxEnergy = 1e7
local activateThreshold = 0.50
local deactivateThreshold = 0.95
local updateFrequency = 5

local reactor = peripheral.wrap(reactorLocation)

-- Functions
function checkEnergyThreshold()
  local energyPercentage = reactor.getEnergyStored() / maxEnergy
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

while true do
  if autoToggle then
    checkEnergyThreshold()
  end

  t = {}
  t['isActive'] = reactor.getActive()

  t['energyPerTick'] = reactor.getEnergyProducedLastTick()
  t['storedEnergy'] = math.floor(reactor.getEnergyStored())
  t['energyMax'] = maxEnergy
  t['energyPercentage'] = t['storedEnergy'] / maxEnergy

  t['fuelUsedPerTick'] = reactor.getFuelConsumedLastTick()
  t['storedFuel'] = math.floor(reactor.getFuelAmount())
  t['fuelMax'] = reactor.getFuelAmountMax()
  t['fuelPercentage'] = t['storedFuel'] / t['fuelMax']
  t['fuelReactivity'] = reactor.getFuelReactivity() / 100

  t['caseTemp'] = reactor.getCasingTemperature()
  t['coreTemp'] = reactor.getFuelTemperature()

  rednet.broadcast(t, rednetProtocol)
  os.sleep(updateFrequency)
end
