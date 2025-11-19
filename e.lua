getgenv().Config = {
        Dashboard = {
            Enabled = false, -- true = Connect to Adopt Me dashboard for remote monitoring/control (uses websocket), false = Local farming only (better performance, no external connections)
            GroupName = "", -- Group name to organize accounts on the Adopt Me dashboard (only used if Enabled = true)
        },
        BabyFarm = true, -- Enable/disable baby farming
        PetFarm = {
            Enabled = true, -- Enable/disable pet farming
            FarmEggs = true, -- Farm eggs instead of regular pets
            BuyEggs = true, -- Automatically buy eggs when needed
            EggType = "any", -- Which egg type to farm (any or specific egg ID)
            BuyEggType = "retired_egg", -- Which egg type to buy
            MaxPets = 2, -- Maximum pets to equip (1-2)
            FarmUntilFullGrown = false, -- Prioritize pets that aren't full grown
            PrioritizeFriendship = false, -- Prioritize pets with higher friendship
            SelectiveFarm = false, -- Only farm specific pet types
            SelectedPetTypes = {}, -- Pet types to farm when SelectiveFarm is enabled
        },
        AutoNeon = { -- Auto neon 
            Enabled = true,
            MakeMega = true, -- to use neon pets to make mega neon
        },
        Misc = {
            AutoShowUI = true, -- (To Load the ui or not)
        },
        Performance = {
            Disable3DRendering = false, -- Disable 3D rendering for better performance
            ReduceGraphics = false, -- Reduce graphics quality to minimum
        },
        AutoPotion = {
            Enabled = false, -- Use age potions automatically
            SelectedPets = {}, -- Pet types to age with potions
        },
        AutoTrade = {
            Enabled = false,
            AutoAcceptTrades = false,
            SendTradesTo = "",
            TradeMode = "all", -- "specific" or "all"
            Categories = {},
            Items = {}, -- e.g., {"dog", "cat", "sandwich"}
            ItemCounts = {}, -- e.g., {30, 12} - corresponds to Items array
            FilterByAge = false,
            SelectedAges = {}, -- 1=Newborn, 2=Junior, 3=PreTeen, 4=Teen, 5=PostTeen, 6=FullGrown
            ExcludeNeons = true,
            ExcludeFullGrown = false
        },
        AutoBuy = {
            Enabled = false, -- Enable auto buying system
            SelectedItems = {}, -- Items to buy (e.g., {"pet_food", "water_cooler", "pizza_ingredients"})
        },
        AutoPay = {
            Enabled = false, -- on or off 
            TargetPlayer = "", -- username of player to pay
        },
        AutoOpen = { -- auto open gift boxes/baits etc 
            Enabled = false,
            Items = {},
        },
        AutoRecycle = {
            Enabled = true, -- Enable auto recycler system
            RarityFilter = { --Rarity filter for recycling pets
                common = true,
                uncommon = true,
                rare = true,
                ultra_rare = true,
                legendary = false
            },
            KeepNeons = true,
            KeepFullGrown = true, -- Keep full grown pets
            SelectiveMode = false, -- Only recycle specific pet types
            SelectedPets = {}
        },
        IdleProgression = { -- pet pen
            Enabled = false,
            SelectedPets = {}  -- List of pet IDs to use for the pet pen
        },
       Webhook = {
            Enabled = true, -- Send webhook notifications
            URL = "https://discord.com/api/webhooks/1435691168984731678/LMqcwY-H0Aw4sONWenIS5SaB-VnpPi1ClCFWH1foGkH5u-9JOBE2WrF0txUc98riHlJ3", -- Default Discord webhook URL
            PetUnlock = {
                Enabled = true, -- Send webhook notifications when unlocking a pet
                URL = "https://discord.com/api/webhooks/1416373985012355104/35Rs2-I_VtuyA8gVkPDBQFuQVWYbQYCWwjnAg5WEwFa3a0P47_PzvcazyUd-3ZpoaV2-", -- Separate webhook for pet unlocks
                FilterRarities = {"legendary"} -- Only send webhook for these rarities
            },
        },
        TaskExclusion = {
            Enabled = false, -- Enable task exclusion system
            ExcludedTasks = {}, -- Tasks to skip (e.g., {"buccaneer_band", "summerfest_bonfire"})
        },
    };
script_key="sKCDGlkwArwaTEPfWXIlqqfNDliIVHjW"
loadstring(game:HttpGet("https://zekehub.com/scripts/AdoptMe/MassFarm.lua"))()
