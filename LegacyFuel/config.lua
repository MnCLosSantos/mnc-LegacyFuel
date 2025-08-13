Config = {}

Config.RefuelSettings = {
    UpdateInterval = 1000,  -- Time between fuel updates in milliseconds (1000ms = 1 second)
    FuelPerTick = {
        Min = 3,    -- Minimum fuel added per tick (divided by 10, so 3 = 0.3% fuel)
        Max = 8     -- Maximum fuel added per tick (divided by 10, so 8 = 0.8% fuel)
    },
    -- Optional: Different rates for different refuel methods
    PumpRefuel = {
        UpdateInterval = 500,   -- Pumps refuel slightly faster
        FuelPerTick = {
            Min = 1,
            Max = 4
        }
    },
    JerryCanRefuel = {
        UpdateInterval = 1200,  -- Jerry cans refuel slower
        FuelPerTick = {
            Min = 2,
            Max = 6
        }
    }
}

-- What should the price of jerry cans be?
Config.JerryCanCost = 100
Config.RefillCost = 50 -- If it is missing half of it capacity, this amount will be divided in half, and so on.

-- Fuel decor - No need to change this, just leave it.
Config.FuelDecor = "_FUEL_LEVEL"

-- What keys are disabled while you're fueling.
Config.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}

-- Configure blips here. Turn both to false to disable blips all together.
Config.ShowNearestGasStationOnly = false
Config.ShowAllGasStations = true

-- Modify the fuel-cost here, using a multiplier value. Setting the value to 2.0 would cause a doubled increase.
Config.CostMultiplier = 0.25

-- Configure the strings as you wish here.
Config.Strings = {
	ExitVehicle = "~r~Exit the vehicle to refuel",
	EToRefuel = "~b~Press ~g~E ~b~to refuel vehicle",
	JerryCanEmpty = "~r~Jerry can is empty",
	FullTank = "~g~Tank is full",
	PurchaseJerryCan = "~b~Press ~g~E ~b~to purchase a jerry can for ~g~$" .. Config.JerryCanCost,
	CancelFuelingPump = "~b~Press ~g~E ~b~to cancel the fueling",
	CancelFuelingJerryCan = "~b~Press ~g~E ~b~to cancel the fueling",
	NotEnoughCash = "~r~Not enough cash",
	RefillJerryCan = "~b~Press ~g~E ~b~to refill the jerry can for ",
	NotEnoughCashJerryCan = "~r~Not enough cash to refill jerry can",
	JerryCanFull = "~g~Jerry can is full",
	TotalCost = "~r~Cost",
}

Config.PumpModels = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
}

-- Blacklist certain vehicles. Use names or hashes. https://wiki.gtanet.work/index.php?title=Vehicle_Models
Config.Blacklist = {
	--"Adder",
	--276773164
}

-- Do you want the HUD removed from showing in blacklisted vehicles?
Config.RemoveHUDForBlacklistedVehicle = true

-- Class multipliers. If you want SUVs to use less fuel, you can change it to anything under 1.0, and vise versa.
Config.Classes = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 1.0, -- SUVs
	[3] = 1.0, -- Coupes
	[4] = 1.0, -- Muscle
	[5] = 1.0, -- Sports Classics
	[6] = 1.0, -- Sports
	[7] = 1.0, -- Super
	[8] = 1.0, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 1.0, -- Industrial
	[11] = 1.0, -- Utility
	[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- Boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 1.0, -- Service
	[18] = 1.0, -- Emergency
	[19] = 1.0, -- Military
	[20] = 1.0, -- Commercial
	[21] = 1.0, -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
Config.FuelUsage = {
	[1.0] = 1.6,
	[0.9] = 1.3,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

Config.GasStations = {
	vector3(49.4187, 2778.793, 58.043),
	vector3(263.894, 2606.463, 44.983),
	vector3(1039.958, 2671.134, 39.550),
	vector3(1207.260, 2660.175, 37.899),
	vector3(2539.685, 2594.192, 37.944),
	vector3(2679.858, 3263.946, 55.240),
	vector3(2005.055, 3773.887, 32.403),
	vector3(1687.156, 4929.392, 42.078),
	vector3(1701.314, 6416.028, 32.763),
	vector3(179.857, 6602.839, 31.868),
	vector3(-94.4619, 6419.594, 31.489),
	vector3(-2554.996, 2334.40, 33.078),
	vector3(-1800.375, 803.661, 138.651),
	vector3(-1437.622, -276.747, 46.207),
	vector3(-2096.243, -320.286, 13.168),
	vector3(-724.619, -935.1631, 19.213),
	vector3(-526.019, -1211.003, 18.184),
	vector3(-70.2148, -1761.792, 29.534),
	vector3(265.648, -1261.309, 29.292),
	vector3(819.653, -1028.846, 26.403),
	vector3(1208.951, -1402.567,35.224),
	vector3(1181.381, -330.847, 69.316),
	vector3(620.843, 269.100, 103.089),
	vector3(2581.321, 362.039, 108.468),
	vector3(176.631, -1562.025, 29.263),
	vector3(176.631, -1562.025, 29.263),
	vector3(-319.292, -1471.715, 30.549),
	vector3(-66.48, -2532.57, 6.14),
	vector3(356.06, 5371.25, 670.88),
	vector3(-883.97, 2844.06, 23.58),
	vector3(910.52, 3609.86, 32.81),
	vector3(2003.45, 3772.75, 32.4),
	vector3(4432.92, -4485.97, 4.29),
	vector3(1531.28, -3387.08, 47.07),
	vector3(2113.22, -2884.95, 135.66),
	vector3(1784.324, 3330.55, 41.253)
}
