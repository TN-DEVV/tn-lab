Config = Config or {}

Config.ingrediant1 = 'cokedoll'
Config.ingrediant2 = 'cocaineleaf'
Config.ingrediant3 = 'bakingsoda'

Config.brakecoke = vector3(1092.89, -3195.55, -39.03)
Config.packagecoke = vector3(1100.93, -3199.63, -39.09)

Config.entercoke = vector3(189.77, 309.14, 105.39)
Config.outlab = vector4(189.77, 309.14, 105.39, 9.47)
Config.exitcoke = vector3(1088.68, -3187.87, -38.99)
Config.insidelab = vector4(1088.68, -3187.87, -38.99, 275.5)

Config.MinZOffset = 30
Config.CurrentLab = 0
Config.CooldownActive = false




Config.cannabis_bottle = 1
Config.cannabis_coke = 1
Config.Coke_brick  = 1

Config.FurnaceTimer = 30

Config.BreakMethTimer = math.random(20000, 25000)

Config.Locations = {
    ["laboratories"] = {
        [1] = {
            coords = vector4(189.77, 309.14, 105.39, 9.47), 
        },
    },
    ["exit"] = {
        coords = vector4(1088.68, -3187.87, -38.99, 275.5), 
    },
    ["break"] = {
        coords = vector4(1092.81, -3194.82, -38.99, 176.86), 
    }
}

Config.Tasks = {
    ["Furnace"] = {
        label = "Furnace",
        completed = false,
        started = false,
        -- ingredients = {
        --     current = 0,
        --     needed = 1,
        -- },
        coords = vector4(1101.24, -3198.8, -38.99, 179.68),
        timeremaining = 30,
        duration = 30,
        done = false,
    },
}
SceneDicts = {
    Cocaine = {
      [1] = 'anim@amb@business@coc@coc_unpack_cut_left@',
      [2] = 'anim@amb@business@coc@coc_packing_hi@',
    },
}
PlayerAnims = {
    Cocaine = {
      [1] = 'coke_cut_v5_coccutter',
      [2] = 'full_cycle_v3_pressoperator'
    },
}
SceneAnims = {
    Cocaine = {
      [1] = {
        bakingsoda  = 'coke_cut_v5_bakingsoda',
        creditcard1 = 'coke_cut_v5_creditcard',
        creditcard2 = 'coke_cut_v5_creditcard^1',     
      },
      [2] = {
        scoop     = 'full_cycle_v3_scoop',
        box1      = 'full_cycle_v3_FoldedBox',
        dollmold  = 'full_cycle_v3_dollmould',
        dollcast1 = 'full_cycle_v3_dollcast',
        dollcast2 = 'full_cycle_v3_dollCast^1',
        dollcast3 = 'full_cycle_v3_dollCast^2',
        dollcast4 = 'full_cycle_v3_dollCast^3',
        press     = 'full_cycle_v3_cokePress',
        doll      = 'full_cycle_v3_cocdoll',
        bowl      = 'full_cycle_v3_cocbowl',
        boxed     = 'full_cycle_v3_boxedDoll',
      },
    },
}
SceneItems = {
    Cocaine = {
      [1] = {
        bakingsoda  = 'bkr_prop_coke_bakingsoda_o',
        creditcard1 = 'prop_cs_credit_card',
        creditcard2 = 'prop_cs_credit_card',
      },
      [2] = {
        scoop     = 'bkr_prop_coke_fullscoop_01a',
        doll      = 'bkr_prop_coke_doll',
        boxed     = 'bkr_prop_coke_boxedDoll',
        dollcast1 = 'bkr_prop_coke_dollCast',
        dollcast2 = 'bkr_prop_coke_dollCast',
        dollcast3 = 'bkr_prop_coke_dollCast',
        dollcast4 = 'bkr_prop_coke_dollCast',
        dollmold  = 'bkr_prop_coke_dollmould',
        bowl      = 'bkr_prop_coke_fullmetalbowl_02',
        press     = 'bkr_prop_coke_press_01b',      
        box1      = 'bkr_prop_coke_dollboxfolded',
      },
    },
}