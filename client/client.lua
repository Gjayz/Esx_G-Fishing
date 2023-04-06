local ESX = exports["es_extended"]:getSharedObject()

local isZone = false

-- Notifiy
RegisterNetEvent('esx-fishing:client:notify')
AddEventHandler('esx-fishing:client:notify', function(title, description, position, typeM)
    lib.notify({
        title = title,
        description = description,
        position = position,
        type = typeM
    })
end)

-- Text UI
RegisterNetEvent('esx-fishing:client:text-showUI')
AddEventHandler('esx-fishing:client:text-showUI', function(position,  borderRadius, backgroundColor, color)
    Wait(500)
    lib.showTextUI('[E] - Fishing', {
        position = position,
        style = {
            borderRadius =  borderRadius,
            backgroundColor = backgroundColor,
            color = color
        }
    })
end)
RegisterNetEvent('esx-fishing:client:text-hideUI')
AddEventHandler('esx-fishing:client:text-hideUI', function()
    lib.hideTextUI()
end)

-- Progresbarr pick
RegisterNetEvent('esx-fishing:client:progressbarSellandBuy')
AddEventHandler('esx-fishing:client:progressbarSellandBuy', function(duration, position, label, useWhileDead, canCancel, move, car, dict, clip)
    lib.progressCircle({
        duration = duration,
        position = position,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        disable = {
            move = move,
            car = car,
        },
        anim = {
            dict =  dict,
            clip = clip
        },
    })
end)

--Ped All
Citizen.CreateThread(function()
    for k, v in pairs(Config.PedLocation) do
    local modelHash = GetHashKey(v.model)
    RequestModel(modelHash) 
    while ( not HasModelLoaded(modelHash) ) do
        Wait(1)
    end
    local ped = CreatePed(1, modelHash, v.coords, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true) 
    TaskStartScenarioInPlace(ped, v.scenario, -1, true) 
    -- FreezeEntityPosition(ped, true)
    end
end)

-- animation
local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

if Config.UseBlips then
    Citizen.CreateThread(function()
        -- All Blips
        for k, v in pairs(Config.Allblips) do
            local AllBlip = AddBlipForCoord(v.coords)
            SetBlipSprite(AllBlip, v.SetBlipSprite)
            SetBlipDisplay(AllBlip, v.SetBlipDisplay)
            SetBlipScale(AllBlip, v.SetBlipScale)
            SetBlipColour(AllBlip, v.SetBlipColour)
            SetBlipAsShortRange(AllBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.BlipName)
            EndTextCommandSetBlipName(AllBlip)
        end
        -- Fish Zone
        for k, v in pairs(Config.ZoneFish) do
            local FishZone = PolyZone:Create(v.zones, {
                name = v.label,
                minZ = v.minz,
                maxZ = v.maxz,
                debugPoly = false
            })
            FishZone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    TriggerEvent('esx-fishing:client:text-showUI',"left-center", 0, '#000000', 'white')
                    isZone = true
                else
                    TriggerEvent('esx-fishing:client:text-hideUI')
                    isZone = false  
                end
            end)
        end

        --- Buy Target
        for _, v in pairs(Config.FishShop) do
            exports.ox_target:addBoxZone({
                coords = vec3(v.coords.x, v.coords.y, v.coords.z),
                size = v.size,
                rotation = v.rotation,
                debugPoly = drawZones,
                options = {
                    {
                    name = 'Open Fish Shop',
                    event = "esx-fishing:client:BuyItemFish",
                    icon = "fa-solid fa-cart-shopping",
                    label = Config.Label["FishShop"],
                    }
                } 
            })
        end
        --- SEll Target
        exports.ox_target:addBoxZone({
            coords = vec3(206.62, -1851.81, 27.0),
            size = vec3(0.5, 0.55, 2.6),
            rotation = 318.5,
            debugPoly = drawZones,
            options = {
                {
                name = 'Open Fish Sell Industry',
                event = "esx-fishing:client:SellFishInDustry",
                icon = "fa-regular fa-money-bill-1",
                label = Config.Label["FishSell"],
                }
            } 
        })
        
    end)
end

---Start Fishing Animation
function startFishing(dict, set, model)
    if isFishing then return end
    local animDict = dict
    local animName = set
    local trClassic = PlayerPedId() 
    isFishing = true
    local coords = GetEntityCoords(trClassic)
    bon = GetPedBoneIndex(trClassic, 18905)
    ESX.Game.SpawnObject(model, coords, function(rodHandle, time)
        CreateThread(function()
            while isFishing do
                AttachEntityToEntity(rodHandle, trClassic, bon, 0.1, 0.05, 0, 40.0, 80.0, 160.0, true, true, false, true, 1, true)
                loadAnimDict(animDict)
                TaskPlayAnim(trClassic, animDict, animName, 20.0, -8, -1, 17, 0, 0, 0, 0)
                Wait(Config.FishTimeWait)
                isFishing = false
                TriggerEvent('esx-fishing:client:text-showUI',"left-center", 0, '#000000', 'white')
                loseBait()
                TriggerServerEvent('esx-fishing:server:FishingReward', src)
            end
            if rodHandle then
                ClearPedTasks(trClassic)
                DetachEntity(rodHandle, 1, true)
                DeleteEntity(rodHandle)
                rodHandled = nil
            end
        end)
       
    end)
end

CreateThread(function()
    while true do
        Wait(1)
        if isZone then
            if IsControlJustReleased(0, 38) then  
                TriggerEvent('esx-fishing:client:text-hideUI')
                TriggerEvent('esx-fishing:client:StartFishing')
            end  
        end   
    end
end)

---- Lost Fish Bait
loseBait = function()
    local chancelost = math.random(1, 15)
	if chancelost <= 5 then
		TriggerServerEvent("esx-fishing:server:removeFishingBaitLost")
	end
end

-- Buy Item Fishing Shop
RegisterNetEvent('esx-fishing:client:BuyItemFish')
AddEventHandler('esx-fishing:client:BuyItemFish', function(src)
    lib.registerContext({
        id = 'shop_open_buy',
        title = 'Fish Shop',
        options = {
           {
                icon = "fa-regular fa-money-bill-1",
                title = 'Buy Fishing Grod',
                description = 'Fishing Grod',
                args = 1,
                event = 'esx-fishing:client:BuyItemProcess',
                image = "https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/fishingrod.png",
                metadata = {
                    {label = 'Fishing Grod', value = 1},
                },
           },  
           {
               icon = "fa-regular fa-money-bill-1",
               title = 'Buy Fish Bait',
               description = 'Fish Bait',
               args = 2,    
               event = 'esx-fishing:client:BuyItemProcess',
               image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/fishbait.png',
               metadata = {
                   {label = 'Fish Bait', value = 10},
               },
           },  
        },
    })
    lib.showContext('shop_open_buy')
end)

-- Sell Fish Menu
RegisterNetEvent('esx-fishing:client:SellFishInDustry')
AddEventHandler('esx-fishing:client:SellFishInDustry', function(src)
    lib.registerContext({
        id = 'shop_open_sell',
        title = 'Fish Sell Industry',
        options = {
           {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Stone Fish',
                description = 'Stone Fish',
                event = 'esx-fishing:client:SellStoneFish',
           },  
           {
               icon = "fa-solid fa-fish-fins",
               title = 'Sell Tuna Fish',
               description = 'Tuna Fish',
               event = 'esx-fishing:client:SellTunaFish',
           },  
        },
    })
    lib.showContext('shop_open_sell')
end)

-- Sell Stone Fish
RegisterNetEvent('esx-fishing:client:SellStoneFish')
AddEventHandler('esx-fishing:client:SellStoneFish',  function(src)
    lib.registerContext({
        id = 'sell_stone_fish',
        title = 'Stone Fish',
        options = {
           {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Cichlid',
                description = 'Cichlid',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/cichlid.png',----img URL
                args = 1,
                event = 'esx-fishing:client:AllSellStoneFish',
           },  
           {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Florida Pompano',
                description = 'Florida Pompano',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/florida_pompano.png',----img URL
                args = 2,
                event = 'esx-fishing:client:AllSellStoneFish',
           },  
           {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Horseye Jack',
                description = 'Horseye Jack',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/horseye_jack.png',----img URL
                args = 3,
                event = 'esx-fishing:client:AllSellStoneFish',
            },  
            {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Lane Sanapper',
                description = 'Lane Sanapper',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/lane_sanapper.png',----img URL
                args = 4,
                event = 'esx-fishing:client:AllSellStoneFish',
            },
            {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Mutton Snapper',
                description = 'Mutton Snapper',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/mutton_snapper.png',----img URL
                args = 5,
                event = 'esx-fishing:client:AllSellStoneFish',
            },  
            {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Pig Fish',
                description = 'Pig Fish',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/pig_fish.png', ----img URL
                args = 6,
                event = 'esx-fishing:client:AllSellStoneFish',
            },
            {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Silver Perch',
                description = 'Silver Perch',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/silver_perch.png', ----img URL
                args = 7,
                event = 'esx-fishing:client:AllSellStoneFish',
            },
            {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell Striped Bass',
                description = 'Striped Bass',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/striped_bass.png', ----img URL
                args = 8,
                event = 'esx-fishing:client:AllSellStoneFish',
            },
          

           {
            title = '< Back',
            event = "esx-fishing:client:SellFishInDustry",
            }
        },
    })
    lib.showContext('sell_stone_fish')
end)

-- Sell Tuna Fish
RegisterNetEvent('esx-fishing:client:SellTunaFish')
AddEventHandler('esx-fishing:client:SellTunaFish', function(src)
    lib.registerContext({
        id = 'sell_tuna',
        title = 'Tuna Fish',
        options = {
           {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell BlackFin Tuna',
                description = 'BlackFin Tuna',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/blackfin_tuna.png',
                args = 1,
                event = 'esx-fishing:client:AllSellTunaFish',
           },  
           {
                icon = "fa-solid fa-fish-fins",
                title = 'Sell YellowFin Tuna',
                description = 'YellowFin Tuna',
                image = 'https://raw.githubusercontent.com/Gjayz/Esx_G-Fishing/main/img/yellowfin_tuna.png',
                args = 2,
                event = 'esx-fishing:client:AllSellTunaFish',
           },  
           {
            title = '< Back',
            event = "esx-fishing:client:SellFishInDustry",
            }
        },
    })
    lib.showContext('sell_tuna')
end)

---- Buy Process
RegisterNetEvent('esx-fishing:client:BuyItemProcess')
AddEventHandler('esx-fishing:client:BuyItemProcess', function(args)
    if args == 1 then
        ESX.TriggerServerCallback('esx-fishing:server:MoneyCashBuyFishingGrodInfo', function(CashBuyFishingGrod)
            if CashBuyFishingGrod then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 3000, 'bottom', Config.Label["BuyFishingGrod"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(3000)
                TriggerServerEvent('esx-fishing:server:BuyItemFishingGrodRewards', src)
            else
                TriggerEvent('esx-fishing:client:notify', 'Dont Have '..Config.FishingGrodPrice..' Cash', 'Buy Fishing Grod', 'center-right', 'error')
            end
        end)
    elseif args == 2 then
        ESX.TriggerServerCallback('esx-fishing:server:MoneyCashBuyFishBaitInfo', function(CashBuyFishBait)
            if CashBuyFishBait then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 3000, 'bottom', Config.Label["BuyFishBait"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(3000)
                TriggerServerEvent('esx-fishing:server:BuyItemFishBaitRewards', src)
            else
                TriggerEvent('esx-fishing:client:notify', 'Dont Have '..Config.FishBaitPrice..' Cash', 'Buy FishBait', 'center-right', 'error')
            end
        end)
    end
end)

-- Start Fishing
RegisterNetEvent('esx-fishing:client:StartFishing')
AddEventHandler('esx-fishing:client:StartFishing', function(args)
    ESX.TriggerServerCallback('esx-fishing:server:FishingRodInfo', function(FishingGrod)
        if FishingGrod then
            ESX.TriggerServerCallback('esx-fishing:server:FishBaitInfo', function(FishBait)
                if FishBait then
                    if IsPedSwimming(PlayerPedId()) then return TriggerEvent('esx-fishing:client:notify', 'Are You Swim', 'Swim', 'center-right', 'error') end 
                    if IsPedInAnyVehicle(PlayerPedId()) then return TriggerEvent('esx-fishing:client:notify', 'Are You Driving', 'Driving', 'center-right', 'error') end 
                    local success = lib.skillCheck({'easy', 'easy',  { areaSize = 50, speedMultiplier = 1 }, 'easy'}, {'q','e'})
                    if success then
                        startFishing('amb@world_human_stand_fishing@idle_a', 'idle_c', 'prop_fishing_rod_01')
                    else
                        TriggerEvent('esx-fishing:client:notify', 'Sorry Try Again', 'Try Again', 'center-right', 'error')
                        TriggerEvent('esx-fishing:client:text-showUI',"left-center", 0, '#000000', 'white')
                    end
                else
                    TriggerEvent('esx-fishing:client:notify', 'No Fish Bait', 'Fish Bait', 'center-right', 'error')
                    TriggerEvent('esx-fishing:client:text-showUI',"left-center", 0, '#000000', 'white')
                 end
            end)
        else
            TriggerEvent('esx-fishing:client:notify', 'No Fishing Grod', 'Fishing Grod', 'center-right', 'error')
            TriggerEvent('esx-fishing:client:text-showUI',"left-center", 0, '#000000', 'white')
        end
    end)
end)

--Proccess Sell Fish Stone
RegisterNetEvent('esx-fishing:client:AllSellStoneFish')
AddEventHandler('esx-fishing:client:AllSellStoneFish', function(args)
    if args == 1 then
        ESX.TriggerServerCallback('esx-fishing:server:CichlidInfo', function(Cichlid)
            if Cichlid then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellCichlid"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:CichlidSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', Config.Label["NoCichlid"], 'Cichlid', 'center-right', 'error')
            end
        end)
    elseif args == 2 then
        ESX.TriggerServerCallback('esx-fishing:server:FloridaPompanoInfo', function(FloridaPompano)
            if FloridaPompano then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellFloridaPompano"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:FloridaPompanoSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', Config.Label["NoFloridaPompano"], 'Florida Pompano', 'center-right', 'error')
            end
        end)
    elseif args == 3 then
        ESX.TriggerServerCallback('esx-fishing:server:HorsEyeJackInfo', function(HorsEyeJack)
            if HorsEyeJack then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellHorsEyeJack"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:HorsEyeJackSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', Config.Label["NoHorsEyeJack"], 'Hors Eye Jack', 'center-right', 'error')
            end
        end)
    elseif args == 4 then
        ESX.TriggerServerCallback('esx-fishing:server:LaneSanapperInfo', function(LaneSanapper)
            if LaneSanapper then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellLaneSanapper"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:LaneSanapperSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', Config.Label["NoLaneSanapper"], 'Lane Sanapper', 'center-right', 'error')
            end
        end)
    elseif args == 5 then
        ESX.TriggerServerCallback('esx-fishing:server:MuttonSnapperInfo', function(MuttonSnapper)
            if MuttonSnapper then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellMuttonSnapper"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:MuttonSnapperSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', Config.Label["NoMuttonSnapper"], 'Mutton Snapper', 'center-right', 'error')
            end
        end)
    elseif args == 6 then
        ESX.TriggerServerCallback('esx-fishing:server:PigFishInfo', function(PigFish)
            if PigFish then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellPigFish"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:PigFishSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', Config.Label["NoPigFish"], 'PigFish', 'center-right', 'error')
            end
        end)
    elseif args == 7 then
        ESX.TriggerServerCallback('esx-fishing:server:SilverPerchInfo', function(SilverPerch)
            if SilverPerch then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellSilverPerch"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:SilverPerchSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', Config.Label["NoSilverPerch"], 'Silver Perch', 'center-right', 'error')
            end
        end)
    elseif args == 8 then
        ESX.TriggerServerCallback('esx-fishing:server:StripedBassInfo', function(StripedBass)
            if StripedBass then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellStripedBass"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:StripedBassSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', Config.Label["NoStripedBass"], 'Striped Bass', 'center-right', 'error')
            end
        end)
    end
end)


--Proccess Sell Fish Tuna
RegisterNetEvent('esx-fishing:client:AllSellTunaFish')
AddEventHandler('esx-fishing:client:AllSellTunaFish', function(args)
    if args == 1 then
        ESX.TriggerServerCallback('esx-fishing:server:BlackTunaInfo', function(BlackFinTuna)
            if BlackFinTuna then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellBlckTuna"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:BlackFinTunaSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', 'No BlackFin Tuna', 'BlackFin Tuna', 'center-right', 'error')
            end
        end)
    elseif args == 2 then
        ESX.TriggerServerCallback('esx-fishing:server:YellowTunaInfo', function(YellowFinTuna)
            if YellowFinTuna then
                TriggerEvent('esx-fishing:client:progressbarSellandBuy', 2500, 'bottom', Config.Label["SellYllwTuna"], false, true, true, true, 'mp_common', 'givetake2_a')
                Wait(2500)
                TriggerServerEvent('esx-fishing:server:YellowFinTunaSellReward', src)
            else
                TriggerEvent('esx-fishing:client:notify', 'No YellowFin Tuna', 'YellowFin Tuna', 'center-right', 'error') 
            end
        end)
    end
end)





