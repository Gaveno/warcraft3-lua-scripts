function InitializeHumanAI()
    humanBuildPriorities = {
        {["type"] = "worker"}, -- Child
        {["type"] = "worker"},
        {
            ["type"] = "building",
            ["building"] = "h003:hhou" -- Footman
        },
        {["type"] = "worker"},
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 0
        },
        {
            ["type"] = "building",
            ["building"] = "h003:hhou" -- Footman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {["type"] = "worker"},
        {["type"] = "worker"},
        -- {
        --     ["type"] = "upgrade",
        --     ["upgrade"] = "Resw", -- Base Attack
        --     ["level"] = 0
        -- },
        {
            ["type"] = "building",
            ["building"] = "h005:hhou" -- Priest
        },
        {["type"] = "worker"},
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 1
        },
        {
            ["type"] = "building",
            ["building"] = "h003:hhou" -- Footman
        },
        {
            ["type"] = "building",
            ["building"] = "h003:hhou" -- Footman
        },
        -- {
        --     ["type"] = "upgrade",
        --     ["upgrade"] = "Resw", -- Base Attack
        --     ["level"] = 1
        -- },
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 2
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {["type"] = "worker"},
        {["type"] = "worker"},
        {["type"] = "worker"},
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 3
        },
        {["type"] = "worker"},
        -- {
        --     ["type"] = "upgrade",
        --     ["upgrade"] = "Rerh", -- Base Health
        --     ["level"] = 0
        -- },
        {
            ["type"] = "building",
            ["building"] = "h005:hhou" -- Priest
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {["type"] = "worker"},
        {["type"] = "worker"},
        {["type"] = "worker"},
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 4
        },
        {["type"] = "worker"},
        {["type"] = "worker"},
        {["type"] = "worker"},
        -- {
        --     ["type"] = "upgrade",
        --     ["upgrade"] = "Rerh", -- Base Health
        --     ["level"] = 1
        -- },
        {["type"] = "worker"},
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 5
        },
        {["type"] = "worker"},
        {["type"] = "worker"},
        
        {["type"] = "worker"},
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 6
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        -- {
        --     ["type"] = "upgrade",
        --     ["upgrade"] = "Resw", -- Base Attack
        --     ["level"] = 2
        -- },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 7
        },
        {
            ["type"] = "upgrade",
            ["upgrade"] = "Rhan", -- Child Speed
            ["level"] = 8
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        -- {
        --     ["type"] = "upgrade",
        --     ["upgrade"] = "Rerh", -- Base Health
        --     ["level"] = 2
        -- },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
        {
            ["type"] = "building",
            ["building"] = "h005:hhou" -- Priest
        },
        {
            ["type"] = "building",
            ["building"] = "h005:hhou" -- Priest
        },
        {
            ["type"] = "building",
            ["building"] = "h005:hhou" -- Priest
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h008:hhou" -- Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h009:hhou" -- Storm Hammers Gryphon Rider
        },
        {
            ["type"] = "building",
            ["building"] = "h004:hhou" -- Rifleman
        },
    }

    playerAIOrders = {}

    for player = 1, 6 do
        playerAIOrders[player] = 1
    end
end