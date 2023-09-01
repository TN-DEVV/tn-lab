Config = Config or {}

Config.MinZOffset = 30
Config.CurrentLab = 0
Config.CooldownActive = false

Config.HydrochloricAcid = 1
Config.Ephedrine = 1
Config.Meth_package  = 1

Config.FurnaceTimer = 30

Config.BreakMethTimer = math.random(15000, 20000)

Config.Locations = {
    ["laboratories"] = {
        [1] = {
            coords = vector4(-1321.6, -1264.23, 4.59, 114.95),
        }, 
    },
    ["exit"] = {
        coords = vector4(997.01, -3200.65, -36.4, 90.4), 
    },
    ["break"] = {
        coords = vector4(1016.04, -3194.95, -38.99, 275.5), 
    }
}

SceneDicts = {
    Meth = {
      [1] = 'anim@amb@business@meth@meth_monitoring_cooking@cooking@',
      [2] = 'anim@amb@business@meth@meth_smash_weight_check@',
    },
  }
  
  -- Animation for player within scenes.
  PlayerAnims = {
    Meth = {
      [1] = 'chemical_pour_short_cooker',
      [2] = 'break_weigh_v3_char01',
    },
  }
  
  -- Animation for entities within scenes.
  SceneAnims = {
    Meth = {
      [1] = {
        ammonia   = 'chemical_pour_short_ammonia',
        clipboard = 'chemical_pour_short_clipboard',
        pencil    = 'chemical_pour_short_pencil',
        sacid     = 'chemical_pour_short_sacid',
      },
      [2] = {
        box1      = 'break_weigh_v3_box01',
        box2      = 'break_weigh_v3_box01^1',
        clipboard = 'break_weigh_v3_clipboard',
        methbag1  = 'break_weigh_v3_methbag01',
        methbag2  = 'break_weigh_v3_methbag01^1',
        methbag3  = 'break_weigh_v3_methbag01^2',
        methbag4  = 'break_weigh_v3_methbag01^3',
        methbag5  = 'break_weigh_v3_methbag01^4',
        methbag6  = 'break_weigh_v3_methbag01^5',
        methbag7  = 'break_weigh_v3_methbag01^6',
        pen       = 'break_weigh_v3_pen',
        scale     = 'break_weigh_v3_scale',
        scoop     = 'break_weigh_v3_scoop',     
      },
    },
  }
  
  -- Objects for entities within scenes.
  SceneItems = {
    Meth = {
      [1] = {
        ammonia   = 'bkr_prop_meth_ammonia',
        clipboard = 'bkr_prop_fakeid_clipboard_01a',
        pencil    = 'bkr_prop_fakeid_penclipboard',
        sacid     = 'bkr_prop_meth_sacid',
      },
      [2] = {
        box1      = 'bkr_prop_meth_bigbag_04a',
        box2      = 'bkr_prop_meth_bigbag_03a',
        clipboard = 'bkr_prop_fakeid_clipboard_01a',
        methbag1  = 'bkr_prop_meth_openbag_02',
        methbag2  = 'bkr_prop_meth_openbag_02',
        methbag3  = 'bkr_prop_meth_openbag_02',
        methbag4  = 'bkr_prop_meth_openbag_02',
        methbag5  = 'bkr_prop_meth_openbag_02',
        methbag6  = 'bkr_prop_meth_openbag_02',
        methbag7  = 'bkr_prop_meth_openbag_02',
        pen       = 'bkr_prop_fakeid_penclipboard',
        scale     = 'bkr_prop_coke_scale_01',
        scoop     = 'bkr_prop_meth_scoop_01a',     
      },
    },
  }