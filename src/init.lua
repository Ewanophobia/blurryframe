local Lighting = game:GetService("Lighting")

local Fusion = require(script.Parent.Parent.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local Cleanup = Fusion.Cleanup

local Neon = require(script.Neon)

local IGNORE_LIST = {"Color", "Transparency", "BlurFactor"}

local FAR_INTENSITY = 0
local FOCUS_DISTANCE = 52
local INFOCUS_RADIUS = 50
local NEAR_INTENSITY = 1

local function BlurryFrame(props)
    local depthOfField = New "DepthOfFieldEffect" {
        FarIntensity = FAR_INTENSITY,
        FocusDistance = FOCUS_DISTANCE - 1 + props.BlurFactor,
        InFocusRadius = INFOCUS_RADIUS,
        NearIntensity = NEAR_INTENSITY,

        Parent = Lighting,
        Name = "_blurryFrame"
    }

    -- create a dummy frame
    local scope = nil
    local frame = New "Frame" {
        [Children] = props[Children],
        [Cleanup] = {
            depthOfField,
            function()
                if Neon:HasBinding(scope) then
                    Neon:UnbindFrame(scope)
                end
            end
        }
    }

    scope = frame

    -- fill in base properties
    for index, value in props do
        if not table.find(IGNORE_LIST, index) and frame[index] then
            frame[index] = value
        end
    end

    -- hide the dummy frame
    frame.BackgroundTransparency = 1

    local function createGlass()
        local color = BrickColor.new(
            props.Color.R or 0,
            props.Color.G or 0,
            props.Color.B or 0
        )

        Neon:BindFrame(frame, {
            Transparency = props.Transparency,
            BrickColor = color
        })
    end

    task.defer(createGlass)
    return frame
end

return BlurryFrame