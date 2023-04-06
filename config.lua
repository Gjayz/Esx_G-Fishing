Config = Config or {}

---Ramdon Time
Config.FishTimeWait = math.random(20000, 40000)
Config.Framework = "ESX"    
Config.Target = "OX"  
Config.UseBlips = true
Config.Debug = false
Config.MoneyCash = 'money'


-- Item Fish Shop
Config.FishingGrod = 'fishingrod'
Config.FishBait = 'fishbait'
-- Item Fish Price
Config.FishingGrodPrice = 2500
Config.FishBaitPrice = 1000


-- Fish Item
-- Tuna (Gensan Fish)
Config.BlackFinTuna = 'blackfin_tuna'
Config.YellowFinTuna = 'yellowfin_tuna'
-- Isda sa bato pag ikaw Filipino (in English stone fish)
Config.Cichlid = 'cichlid'
Config.FloridaPompano = 'florida_pompano'
Config.HorsEyeJack = 'horseye_jack'
Config.LaneSanapper = 'lane_sanapper'
Config.MuttonSnapper = 'mutton_snapper'
Config.PigFish = 'pig_fish'
Config.SilverPerch = 'silver_perch'
Config.StripedBass = 'striped_bass'

--Fish Price
-- Tuna (Gensan Fish)
Config.TunaPrice = 2500
-- Isda sa bato pag ikaw Filipino (in English stone fish)
Config.StoneFishPrice = 100

--- Target ped
Config.FishShop = {
    {
        coords = vec3(-1830.85, -1181.0, 19.3),
        rotation = 54.5,
        size = vec3(0.55, 0.65, 2.25),
    },
    {
        coords = vec3(1654.94, 33.45, 173.0),
        rotation = 0.0,
        size = vec3(1.0, 0.75, 2.0),
    },
    {
        coords = vec3(1308.83, 4362.17, 41.35),
        rotation = 340.0,
        size = vec3(0.5, 0.55, 1.95),
    },
    {
        coords = vec3(-1597.5, 5205.5, 4.0),
        rotation = 25.0,
        size = vec3(0.5, 0.5, 2.0),
    },
    {
        coords = vec3(-3422.13, 965.28, 12.0),
        rotation = 0.0,
        size = vec3(0.5, 0.5, 1.7),
    },
}

-- all blips
Config.Allblips = {
    --- Fish Store
    [1] = {
        coords = vector4(-1830.87, -1180.99, 19.153, 334.488),
        SetBlipSprite = 86,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 29,
        BlipName = "Fishing Store",
    },
    [2] = {
        coords = vector4(1654.97, 33.34, 172.87, 90.70),
        SetBlipSprite = 86,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 29,
        BlipName = "Fishing Store",
    },
    [3] = {
        coords = vector4(1308.87, 4362.17, 41.54, 255.11),
        SetBlipSprite = 86,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 29,
        BlipName = "Fishing Store",
    },
    [4] = {
        coords = vector4(-1597.58, 5205.60, 4.30, 22.67),
        SetBlipSprite = 86,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 29,
        BlipName = "Fishing Store",
    },
    [5] = {
        coords = vector4(-3422.17, 965.30, 11.90, 175.74),
        SetBlipSprite = 86,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 29,
        BlipName = "Fishing Store",
    },
    --- Fish Sell
    [6] = {
        coords = vector4(206.67, -1851.62, 27.47, 150.23),
        SetBlipSprite = 86,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 65,
        BlipName = "Fish Sell",
    },
    ----Fish Spot
    [7] = {
        coords = vector4(-1849.371, -1251.19, 8.60, 136.06),
        SetBlipSprite = 317,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 30,
        BlipName = "Fish Spot",
    },
    [8] = {
        coords = vector4(1687.55, 39.25, 161.75, 218.26),
        SetBlipSprite = 317,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 30,
        BlipName = "Fish Spot",
    },
    [9] = {
        coords = vector4(1340.54, 4224.87, 33.91, 266.45),
        SetBlipSprite = 317,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 30,
        BlipName = "Fish Spot",
    },
    [10] = {
        coords = vector4(-1612.35, 5262.75, 3.97, 14.17),
        SetBlipSprite = 317,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 30,
        BlipName = "Fish Spot",
    },
    [11] = {
        coords = vector4(-3428.17, 965.82, 8.33, 93.54),
        SetBlipSprite = 317,
        SetBlipDisplay = 6,
        SetBlipScale = 0.70,
        SetBlipColour = 30,
        BlipName = "Fish Spot",
    },
}


-- Ped
Config.PedLocation = {
    ---Buy item Ped
    [1] = {
        coords = vector4(-1830.87, -1180.99, 19.153, 334.488),
        model = 'a_m_y_sunbathe_01',
        scenario = 'WORLD_HUMAN_AA_COFFEE',
    },
    [2] = {
        coords = vector4(1654.97, 33.34, 172.87, 90.70),
        model = 'a_m_y_sunbathe_01',
        scenario = 'WORLD_HUMAN_AA_COFFEE',
    },
    [3] = {
        coords = vector4(1308.87, 4362.17, 41.54, 255.11),
        model = 'a_m_y_sunbathe_01',
        scenario = 'WORLD_HUMAN_AA_COFFEE',
    },
    [4] = {
        coords = vector4(-1597.58, 5205.60, 4.30, 22.67),
        model = 'a_m_y_sunbathe_01',
        scenario = 'WORLD_HUMAN_AA_COFFEE',
    },
    [5] = {
        coords = vector4(-3422.17, 965.30, 11.90, 175.74),
        model = 'a_m_y_sunbathe_01',
        scenario = 'WORLD_HUMAN_AA_COFFEE',
    },
    ---Sell Fish Ped
    [6] = {
        coords = vector4(206.67, -1851.62, 27.47, 150.23),
        model = 'a_m_m_salton_02',
        scenario = 'WORLD_HUMAN_AA_SMOKE',
    },
}

Config.ZoneFish = {
    {
        --Fish Zone 1
        zones = {
            vector2(-1863.5925292969, -1233.6607666016),
            vector2(-1866.8145751953, -1237.4653320312),
            vector2(-1826.4913330078, -1272.3984375),
            vector2(-1821.1169433594, -1266.5834960938),
            vector2(-1822.6434326172, -1265.3591308594),
            vector2(-1826.4290771484, -1269.4727783203),
            vector2(-1864.4986572266, -1237.2130126953),
            vector2(-1862.6270751953, -1234.7220458984)
        },
        minZ = 7.6383194923401,
        maxZ = 8.695611000061
    },
    {
        -- Fish Zone 2
        zones = {
            vector2(-3421.2346191406, 950.79071044922),
            vector2(-3429.7377929688, 950.53723144531),
            vector2(-3429.1833496094, 984.75048828125),
            vector2(-3419.4133300781, 984.97827148438),
            vector2(-3419.7377929688, 982.39044189453),
            vector2(-3427.65625, 982.36560058594),
            vector2(-3427.7216796875, 952.68133544922),
            vector2(-3421.4372558594, 952.20166015625)
        },
        minZ = 7.2947301864624,
        maxZ = 8.3466968536377
    },
    {
        --- Fish Zone 3
        zones = {
            vector2(-1605.1646728516, 5256.6821289062),
            vector2(-1608.3709716797, 5263.7763671875),
            vector2(-1607.7174072266, 5264.0854492188),
            vector2(-1607.1446533203, 5263.2060546875),
            vector2(-1605.7254638672, 5263.6918945312),
            vector2(-1606.3989257812, 5266.615234375),
            vector2(-1617.5167236328, 5262.2612304688),
            vector2(-1614.3298339844, 5251.8666992188),
            vector2(-1611.703125, 5253.2666015625),
            vector2(-1614.7576904297, 5261.2045898438),
            vector2(-1608.6413574219, 5263.7036132812),
            vector2(-1609.0421142578, 5261.833984375),
            vector2(-1606.5386962891, 5256.3999023438)
        },
        minZ = 2.0756027698517,
        maxZ = 3.974104642868
    },
    {
        --- Fish Zone 4
        zones = {
            vector2(1343.0037841797, 4226.3901367188),
            vector2(1342.2092285156, 4221.9731445312),
            vector2(1307.4934082031, 4228.0678710938),
            vector2(1307.8107910156, 4230.0297851562),
            vector2(1340.2103271484, 4224.1069335938),
            vector2(1341.0378417969, 4226.640625)
        },
        minZ = 33.08810043335,
        maxZ = 34.36803817749
    },
    {
        --- Fish Zone 5
        zones = {
            vector2(1674.3619384766, 39.294448852539),
            vector2(1674.5516357422, 36.801651000977),
            vector2(1698.9616699219, 37.712928771973),
            vector2(1698.6870117188, 41.701229095459),
            vector2(1696.1945800781, 41.297962188721),
            vector2(1696.2170410156, 40.875602722168),
            vector2(1676.7904052734, 38.88748550415)
        },
        minZ = 161.73927307129,
        maxZ = 163.7801361084
    },
}


----Text 
Config.Label = {
    FishShop = 'Open Fish Shop',
    FishSell = 'Open Sell Industry',
    BuyFishingGrod = "Buy Fishing Grod",
    BuyFishBait = "Buy Fish Bait",
    --
    SellBlckTuna = 'Sell BlackFin Tuna',
    SellYllwTuna = 'Sell YellowFin Tuna',
    --
    SellCichlid = 'Sell Cichlid',
    SellFloridaPompano = 'Sell FloridaPompano',
    SellHorsEyeJack = 'Sell HorsEyeJack',
    SellLaneSanapper = 'Sell LaneSanapper',
    SellMuttonSnapper = 'Sell MuttonSnapper',
    SellPigFish = 'Sell PigFish',
    SellSilverPerch = 'Sell SilverPerch',
    SellStripedBass = 'Sell StripedBass',
    ----
    NoCichlid = 'Dont Have Cichlid Fish',
    NoFloridaPompano = 'Dont Have Florida Pompano Fish',
    NoHorsEyeJack = 'Dont Have Hors Eye Jack Fish',
    NoLaneSanapper = 'Dont Have Lane Sanapper Fish',
    NoMuttonSnapper = 'Dont Have Mutton Snappe Fish',
    NoPigFish = 'Dont Have PigFish Fish',
    NoSilverPerch = 'Dont Have Silver Perch Fish',
    NoStripedBass = 'Dont Have Striped Bass Fish',
}
