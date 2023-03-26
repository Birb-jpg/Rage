--Created by Birb#7304
--https://v3rmillion.net/member.php?action=profile&uid=783024
return error("Patched for now")
local AntiCheatHook
AntiCheatHook = hookmetamethod(game,"__namecall",newcclosure(function(Self,...)
    local Args = {...}
    local Method = getnamecallmethod()

    if Method == "FireServer" and not checkcaller() then
        if typeof(Self) == "Instance" and (Self.Name == "empty" or Self.Name == "BeanBoozled") and typeof(Args[1]) == "string" and (Args[1]:lower():match("goodbye") or Args[1]:lower():match("error")) then
            warn("Ban circumvented from remote:",Self.Name)
            return wait(9e9)
        end
    end
    return AntiCheatHook(Self,...)
end))

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local Camera = workspace.CurrentCamera
local Humanoid = Character:FindFirstChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Target = nil


local TC2 = {}
TC2.Birb = {}
TC2.Birb.Toggles = {
    Ammo = false,
    FallDMG = false,
    FR = false,
    Spread = false,
    Insta = false,
    Recoil = false,
    Level3 = false,
    SelfDMG = false,
    Undisguise = false,
    Testing = false,
    Jumppow = false,
    Walkspeed = false,
    Wallbang = false,
    SilentAim = false,
    --Aimlock = false,
    FOV = false,
    Vis = false,
    VisFOV = false,
    --AimlockActive = false,
    Sap = false,
    Invis = false,
    Cloak = false,
    Charge = false,
    Healy = false,
    Dot = false,
    AntiHead = false,
    HealyKit = false,
    Projectile = false
}
TC2.Birb.Changes = {
    FireRate = 0,
    Recoil = 0,
    WS = 20,
    FOVRadius = 100
}
TC2.Birb.Frameworks = {}
TC2.SetFramework = function(FrameWorkScan)
    for i,v in next, getgc(true) do
        if typeof(v) == "table" then
            for a,b in next, FrameWorkScan do
                if TC2.Birb.Frameworks[a] ~= nil then continue end
                if typeof(rawget(v,b)) == "function" then
                    TC2.Birb.Frameworks[a] = v
                end
            end
        end
    end
end

TC2.GetFramework = function(FrameWorkName)
    return TC2.Birb.Frameworks[FrameWorkName]
end


--[[local Visulaizer
local Weapons
for i,v in next, getgc(true) do
    if typeof(v) == "table" then
        if typeof(rawget(v,"speedupdate")) == "function" and Visulaizer == nil then
            Visulaizer = v
        end
        if typeof(rawget(v,"returndamagemod")) == "function" and Weapons == nil then
            Weapons = v
        end
    end
end]]
TC2.SetFramework({
    ["Visualizer"] = "speedupdate",
    ["Weapons"] = "returndamagemod",
    ["Client"] = "inducefalldamage",
    ["Inventory"] = "equipItem",
    --["ClassHandler"] = "runinvis"
})
local InstaHook = TC2.GetFramework("Weapons").returndamagemod
TC2.GetFramework("Weapons").returndamagemod = function(...)
    if TC2.Birb.Toggles.Insta == true then
        return math.huge
    end
    return InstaHook(...)
end
local FDHook = TC2.GetFramework("Client").inducefalldamage
TC2.GetFramework("Client").inducefalldamage = function(...)
    if TC2.Birb.Toggles.FallDMG == true then
        return
    end
    return FDHook(...)
end

local SpreadHook = TC2.GetFramework("Weapons").calcspread
TC2.GetFramework("Weapons").calcspread = function(...)
    if TC2.Birb.Toggles.Spread == true then
        return CFrame.Angles(0,0,0)
    end
    return SpreadHook(...)
end
local CameraHook = TC2.GetFramework("Weapons").RotCamera
TC2.GetFramework("Weapons").RotCamera = function(...)
    if TC2.Birb.Toggles.Recoil == true then
        return
    end
    return CameraHook(...)
end

local SpeedHook = TC2.GetFramework("Visualizer").speedupdate
TC2.GetFramework("Visualizer").speedupdate = function(...)
    if TC2.Birb.Toggles.Walkspeed == true and Humanoid then
        Humanoid.WalkSpeed = TC2.Birb.Changes.WS
        return
    end
    return SpeedHook(...)
end




local Changing = {}
local ValueChanger = function(ValueBase,Prop,Change,Enabler)
    if not Changing[ValueBase] then
         if TC2.Birb.Toggles[Enabler] ~= nil then
            Changing[ValueBase] = ValueBase:GetPropertyChangedSignal(Prop):Connect(function()
                if TC2.Birb.Toggles[Enabler] == true and ValueBase[Prop] ~= nil then
                    ValueBase[Prop] = Change
                end
            end)
        end
    else
        Changing[ValueBase]:Disconnect()
        if TC2.Birb.Toggles[Enabler] ~= nil then
            Changing[ValueBase] = ValueBase:GetPropertyChangedSignal(Prop):Connect(function()
                if TC2.Birb.Toggles[Enabler] == true then
                    v[Prop] = Change
                end
            end)
        end
    end
end

for i,v in next, TC2.GetFramework("Weapons") do
    if i:match("ammocount") then
        ValueChanger(v,"Value",1000,"Ammo")
    end
end

ValueChanger(TC2.GetFramework("Weapons").secondaryduration,"Value",0,"Ammo")
ValueChanger(TC2.GetFramework("Client").maxbaseball,"Value",1000,"Ammo")
ValueChanger(TC2.GetFramework("Client").baseballs,"Value",1000,"Ammo")
ValueChanger(TC2.GetFramework("Client").cloakleft,"Value",10,"Cloak")
ValueChanger(TC2.GetFramework("Client").chargeleft,"Value",30,"Charge")

--ValueChanger(TC2.GetFramework("Weapons").metal,"Value",200,"Ammo")
--ValueChanger(TC2.GetFramework("Weapons").chargetick,"Value",tick()+50,"Testing")

local chegg = 0


local OldIndex
OldIndex = hookmetamethod(game,"__index",newcclosure(function(Self,Key)
    if Key == "Value" and Self:IsA("ValueBase") and not checkcaller() then
        if Self.Name:lower():match("firerate") and TC2.Birb.Toggles.FR == true and Self.Parent:FindFirstChild("Projectile") == nil then
            return TC2.Birb.Changes.FireRate
        --[[elseif Self.Name:lower():match("RecoilControl") and TC2.Birb.Toggles.Recoil == true then
            return TC2.Birb.Changes.Recoil]]
        end
    end
    if Key == "Clips" and TC2.Birb.Toggles.Wallbang == true and not checkcaller() then
        return workspace.Map
    end
    return OldIndex(Self,Key)
end))



local FovCircle = Drawing.new("Circle")
FovCircle.Transparency = 1
FovCircle.Thickness = 2
FovCircle.Radius = TC2.Birb.Changes.FOVRadius
FovCircle.Filled = false
FovCircle.Position = UIS:GetMouseLocation()
FovCircle.Visible = false
FovCircle.Color = Color3.fromRGB(255, 255, 255)

local GetClosestToMouse = function(TargetPart)
    print(TC2.Birb.Toggles.FOV and TC2.Birb.Changes.FOVRadius)

    local MaxDistance = (TC2.Birb.Toggles.FOV and TC2.Birb.Changes.FOVRadius or nil)
	local Closest = 9e9
	local ToRet
	for i,v in next, Players:GetPlayers() do
		if v and v.Character and v ~= Player and (v.Team ~= Player.Team or v.Neutral == true) then
			--print("team")
			local ToTarget = TargetPart or "Head"
			local Selected = v.Character:FindFirstChild(ToTarget)
			if Selected then
				--print("seletcted")

				local SelectedToViewPort,IsVisible = Camera:WorldToViewportPoint(Selected.Position)
				local Magnitude = (UIS:GetMouseLocation() - Vector2.new(SelectedToViewPort.X,SelectedToViewPort.Y)).Magnitude
				if Magnitude < Closest then
					Closest = Magnitude
					ToRet = v.Character
					if MaxDistance ~= nil then
						if MaxDistance >= Magnitude then
							Closest = Magnitude
							ToRet = v.Character
						else
							ToRet = nil
						end
					end
                    if TC2.Birb.Toggles.VisFOV == true then
                        if IsVisible == true then
                            Closest = Magnitude
							ToRet = v.Character
						else
							ToRet = nil
                        end
                    end
                    local Map = workspace:FindFirstChild("Map")
                    if TC2.Birb.Toggles.Vis == true and Selected and Map and Map:FindFirstChild("Ignore") then
                        if #Camera:GetPartsObscuringTarget({Selected.CFrame.Position}, Map.Ignore:GetChildren()) <= 0 then
                            Closest = Magnitude
							ToRet = v.Character
                        else
                            ToRet = nil
                        end
                    end
				end
			end
		end
	end
	return ToRet,Closest
end


RunService:BindToRenderStep("Runeasd", 1, function()
    --[[if Player.Character ~= nil and Player.Character:FindFirstChild("Dead") then
        local Dead = Player.Character:FindFirstChild("Dead")
        if Dead.Value == true then
            ReplicatedStorage.Events.LoadCharacter:FireServer()
            TC2.GetFramework("Client").setcharacter(Player)
            Dead.Value = false
        end
    end]]
    if TC2.Birb.Toggles.Healy == true and Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("effect") and Character.Gun.effect:FindFirstChild("hp") and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health < Character.Humanoid.MaxHealth then
        ReplicatedStorage.Events.LoseHealth:FireServer(-500)
    end
    if TC2.Birb.Toggles.HealyKit == true and Character and Character:FindFirstChild("Hitbox") and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health < Character.Humanoid.MaxHealth and Character:FindFirstChild("Dead") and Character.Dead.Value == false then
        for i,v in next, CollectionService:GetTagged("Touched") do
            if v.Name:match("HP") or v.Parent.Name:match("Resupply") and Character:FindFirstChild("Humanoid") then
                ReplicatedStorage.Events.Touched:FireServer(v,Character.Hitbox)
            end
        end
    end
    if TC2.Birb.Toggles.Sap == true then
        for i,v in next, CollectionService:GetTagged("HasHealth") do
            if v:FindFirstChild("IsABldg") and v.TeamColor3.BrickColor ~= Player.TeamColor then
                local Gun = Character:FindFirstChild("Gun")
                local PackValues = {v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,TC2.GetFramework("Client").gun.Value.Name,500,0,99999999,0,0,0,0,0,workspace.Status.ServerStats.DistributedTime.Value,1,0,0,Player.Ping.Value,0,0}
                ReplicatedStorage.Events.HitCrud:FireServer(v.Hitbox,Gun,string.pack("f f f f f f f f f s f i1 f f i1 i1 f f f f f f f f",table.unpack(PackValues)))
            end
        end
    end
    FovCircle.Position = UIS:GetMouseLocation()
    Target = GetClosestToMouse()
    --warn(Target)
end)
local OldNameCall
OldNameCall = hookmetamethod(game,"__namecall",newcclosure(function(Self,...)
    local Method = getnamecallmethod()
    local Args = {...}
    if Method == "FireServer" and not checkcaller() then
        if typeof(Self) == "Instance" then
            if Self.IsA(Self,"RemoteEvent") then
                if Self.Name == "DeployBuilding" and TC2.Birb.Toggles.Level3 == true then
                    return Self.FireServer(Self,Args[1],Args[2],true,3,216,200,200,0,0,Args[10])
                end
                if Self.Name == "ReplicateDot" and TC2.Birb.Toggles.Dot == true then
                    return
                end
                if Self.Name == "ControlTurn" and TC2.Birb.Toggles.AntiHead == true then
                    return Self.FireServer(Self,math.rad(160))
                end
                if Self.Name == "IMISSED" and TC2.Birb.Toggles.SelfDMG == true then
                    return
                end
                if Self.Name == "Undisguise" and TC2.Birb.Toggles.Undisguise == true then
                    return
                end
            end
        end 
    end
   if Method == "Raycast" and not checkcaller() then
        if Target ~= nil and Target.FindFirstChild(Target,"Head") and TC2.Birb.Toggles.SilentAim == true then
            if Args[3].IgnoreWater == true then
                print(Target)
                Args[1] = Camera.CFrame.Position
                Args[2] = Target.Head.CFrame.Position - Camera.CFrame.Position
                return OldNameCall(Self,unpack(Args))
            end
        end
    end
    return OldNameCall(Self,...)
end))

local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()
local MainGui = Mercury:Create({
    Name = "TC2 Birb Breaker",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/deeeity/mercury-lib"
})
MainGui:Credit{
	Name = "Birb",
	Description = "Script Developer",
	V3rm = "Outdated memes",
	Discord = "Birb#7304"
}
local GunTab = MainGui:Tab({
	Name = "Gun-Mods",
	Icon = "rbxassetid://10321891346"
})
local CharacterTab = MainGui:Tab({
	Name = "Character",
	Icon = "rbxassetid://10321892969"
})
local AimTab = MainGui:Tab({
	Name = "Silent-Aim",
	Icon = "rbxassetid://10321893834"
})
local MiscTab = MainGui:Tab({
	Name = "Misc",
	Icon = "rbxassetid://10321892327"
})

--[[AimTab:Toggle({
	Name = "Toggle Aimlock",
	StartingState = false,
	Description = "Mouse move to the target head you click head, simple",
	Callback = function(Bool)
        TC2.Birb.Toggles.Aimlock = Bool
    end
})

AimTab:KeyBind({
	Name = "Aimlock Keybind",
	Keybind = Enum.KeyCode.V,
	Description = "Use this keybind to activate the aimlock",
    Callback = function(Bool)
        TC2.Birb.Toggles.AimlockActive = not TC2.Birb.Toggles.AimlockActive
    end
})]]

AimTab:Toggle({
	Name = "Toggle Silent Aim",
	StartingState = false,
	Description = "Bullets go towards the targets's head when you shoot",
	Callback = function(Bool)
        TC2.Birb.Toggles.SilentAim = Bool
    end
})

AimTab:Toggle({
	Name = "Toggle FOV Circle",
	StartingState = false,
	Description = "Only lock onto the target inside the circle on screen",
	Callback = function(Bool)
        FovCircle.Visible = Bool
        TC2.Birb.Toggles.FOV = Bool
    end
})

AimTab:Slider({
	Name = "FOV Radius",
	Default = 100,
	Min = 50,
	Max = 1000,
	Callback = function(Value)
        TC2.Birb.Changes.FOVRadius = Value
        FovCircle.Radius =Value
    end
})

AimTab:Toggle({
	Name = "Toggle Visibility Check",
	StartingState = false,
	Description = "Check if the target is behind a wall",
	Callback = function(Bool)
        TC2.Birb.Toggles.Vis = Bool
    end
})

AimTab:Toggle({
	Name = "Toggle Visibility in FOV Check",
	StartingState = false,
	Description = "Checks if the target is in your FOV so you don't kill a dude behind you",
	Callback = function(Bool)
        TC2.Birb.Toggles.VisFOV = Bool
    end
})


GunTab:Toggle({
	Name = "Build Level 3's",
	StartingState = false,
	Description = "Any mechanic build is automatically placed as a level 3",
	Callback = function(Bool)
        TC2.Birb.Toggles.Level3 = Bool
    end
})
GunTab:Toggle({
	Name = "Infinite Ammo",
	StartingState = false,
	Description = "1000 ammo constantly (don't use wreckers yard)",
	Callback = function(Bool)
        TC2.Birb.Toggles.Ammo = Bool
    end
})
GunTab:Toggle({
	Name = "Fast Firerate",
	StartingState = false,
	Description = "Firerate for bullet based (hitscan) guns is increased significantly",
	Callback = function(Bool)
        TC2.Birb.Toggles.FR = Bool
    end
})
GunTab:Toggle({
	Name = "No Spread",
	StartingState = false,
	Description = "Gun spread is no longer calculated",
	Callback = function(Bool)
        TC2.Birb.Toggles.Spread = Bool
    end
})
GunTab:Toggle({
	Name = "Instant Kill",
	StartingState = false,
	Description = "Damage goes to infinity",
	Callback = function(Bool)
        TC2.Birb.Toggles.Insta = Bool
    end
})
GunTab:Toggle({
	Name = "No Recoil",
	StartingState = false,
	Description = "No gun recoil",
	Callback = function(Bool)
        TC2.Birb.Toggles.Recoil = Bool
    end
})
GunTab:Toggle({
	Name = "No Self Damage",
	StartingState = false,
	Description = "Self damage from melee is negated",
	Callback = function(Bool)
        TC2.Birb.Toggles.SelfDMG = Bool
    end
})
GunTab:Toggle({
	Name = "Facestabs",
	StartingState = false,
	Description = "Allow for facestabs (360 backstab)",
	Callback = function(Bool)
        TC2.GetFramework("Weapons").backstabangle = 180
        if Bool then TC2.GetFramework("Weapons").backstabangle = 360 end
    end
})
--[[GunTab:Toggle({
	Name = "Testing switch",
	StartingState = false,
	Description = "Toggle testing features",
	Callback = function(Bool)
        TC2.Birb.Toggles.Testing = Bool
    end
})
]]
GunTab:Toggle({
	Name = "Wallbang",
	StartingState = false,
	Description = "Shoot through walls",
	Callback = function(Bool)
        TC2.Birb.Toggles.Wallbang = Bool
    end
})

GunTab:Toggle({
	Name = "Infinite Charge",
	StartingState = false,
	Description = "You have to run into a wall to stop charging lol",
	Callback = function(Bool)
        TC2.Birb.Toggles.Charge = Bool
    end
})

GunTab:Toggle({
	Name = "Infinite Cloak",
	StartingState = false,
	Description = "Just buy a cloak and dagger tbh",
	Callback = function(Bool)
        TC2.Birb.Toggles.Cloak = Bool
    end
})

GunTab:Toggle({
	Name = "No Sniper Dot",
	StartingState = false,
	Description = "Removes the dot when aiming with a sniper",
	Callback = function(Bool)
        TC2.Birb.Toggles.Dot = Bool
    end
})

CharacterTab:Toggle({
	Name = "No Fall Damage",
	StartingState = false,
	Description = "Don't take fall damage",
	Callback = function(Bool)
        TC2.Birb.Toggles.FallDMG = Bool
    end
})
do
    local Val = Instance.new("NumberValue",Character)
    CharacterTab:Toggle({
        Name = "No Knockback",
        StartingState = false,
        Description = "Don't take knockback",
        Callback = function(Bool)
            Val.Name = Bool and "PlrNoKnockback" or tostring(math.random(1,10000))
            Val.Value = math.random(1,10000)
        end
    })
end


CharacterTab:Toggle({
	Name = "Instant Respawn",
	StartingState = false,
	Description = "Respawn instantly after killcam",
	Callback = function(Bool)
        local Const76,Const75 = Bool and 2000 or 2.5,Bool and 0 or 0.25
        setconstant(TC2.GetFramework("Client").died200,76,Const76) 
        setconstant(TC2.GetFramework("Client").died200,75,Const75) 
    end
})
CharacterTab:Toggle({
	Name = "No Undisguise",
	StartingState = false,
	Description = "As Agent when disguise you don't undisguise when shooting",
	Callback = function(Bool)
        TC2.Birb.Toggles.Undisguise = Bool
    end
})
CharacterTab:Toggle({
	Name = "Jumppower",
	StartingState = false,
	Description = "Enable your jumppower to be set to the slider value",
	Callback = function(Bool)
        Humanoid.UseJumpPower = Bool
        TC2.Birb.Toggles.Jumppow = Bool
    end
})
CharacterTab:Slider({
	Name = "JP Amount",
	Default = 50,
	Min = 0,
	Max = 1000,
	Callback = function(Value)
        ValueChanger(TC2.GetFramework("Client").JP,"Value",Value,"Jumppow")
    end
})

CharacterTab:Toggle({
	Name = "Walkspeed",
	StartingState = false,
	Description = "Enable your walkspeed to be set to the slider value",
	Callback = function(Bool)
        TC2.Birb.Toggles.Walkspeed = Bool
        Humanoid.WalkSpeed = TC2.Birb.Changes.WS
    end
})
CharacterTab:Slider({
	Name = "WS Amount",
	Default = 20,
	Min = 0,
	Max = 1000,
	Callback = function(Value)
        TC2.Birb.Changes.WS = Value
        Humanoid.WalkSpeed = TC2.Birb.Changes.WS
    end
})

MiscTab:Toggle({
	Name = "Sap All",
	StartingState = false,
	Description = 'Saps (Kills) all buildings',
	Callback = function(Bool)
        TC2.Birb.Toggles.Sap = Bool
        if Bool == true then
            for i,v in next, CollectionService:GetTagged("HasHealth") do
                if v:FindFirstChild("IsABldg") and v.TeamColor3.BrickColor ~= Player.TeamColor then
                    local Gun = Character:FindFirstChild("Gun")
                    local PackValues = {v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,TC2.GetFramework("Client").gun.Value.Name,10000,0,99999999,0,0,0,0,0,workspace.Status.ServerStats.DistributedTime.Value,1,0,0,Player.Ping.Value,0,0}
                    ReplicatedStorage.Events.HitCrud:FireServer(v.Hitbox,Gun,string.pack("f f f f f f f f f s f i1 f f i1 i1 f f f f f f f f",table.unpack(PackValues)))
                end
            end
        end
    end
})

MiscTab:Toggle({
	Name = "Food Heal",
	StartingState = false,
	Description = "A scuffed godmode you need a item like/or brash burger in your hand",
	Callback = function(Bool)
        TC2.Birb.Toggles.Healy = Bool
    end
})

MiscTab:Toggle({
	Name = "Pickup Heal",
	StartingState = false,
	Description = "Another scuffed godmode picks up medkits around the map",
	Callback = function(Bool)
        TC2.Birb.Toggles.HealyKit = Bool
    end
})


MiscTab:Toggle({
	Name = "Anti Headshot",
	StartingState = false,
	Description = "Only useful against marksman",
	Callback = function(Bool)
        ReplicatedStorage.Events.ControlTurn:FireServer(math.rad(180))
        TC2.Birb.Toggles.AntiHead = Bool
    end
})
--Broken
--[[MiscTab:Toggle({
	Name = "Deny Projectiles",
	StartingState = false,
	Description = "Ever hated projectiles? Kill anyone who directs one at you",
	Callback = function(Bool)
        TC2.Birb.Toggles.Projectile = Bool
    end
})

local DoFilter = function(Instance)
    if (Instance.Name == "Rocket" or Instance.Name == "Grenade"  or Instance.Name == "Baseball")and Instance.BrickColor ~= Player.TeamColor and Instance:FindFirstChild("Owner") and TC2.Birb.Toggles.Projectile == true then
        task.spawn(function()
            while Instance ~= nil do
                task.wait()
                if (Character.HumanoidRootPart.Position - Instance.Position).Magnitude < 30 then
                    print(("%s's projectile got close"):format(Instance.Owner.Value.Name))
                    if Instance.Owner.Value and Instance.Owner.Value.Character and Instance.Owner.Value.Character:FindFirstChild("Hitbox") and Instance:FindFirstChild("NT") and Character:FindFirstChild("Gun") then
                        v = Instance.Owner.Value.Character

                        local Gun = Character:FindFirstChild("Gun")
                        local PackValues = {v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,v.Hitbox.CFrame.X,v.Hitbox.CFrame.Y,v.Hitbox.CFrame.Z,TC2.GetFramework("Client").gun.Value.Name,10000,0,99999999,0,0,0,0,0,workspace.Status.ServerStats.DistributedTime.Value,1,0,0,Player.Ping.Value,0,0}
                        ReplicatedStorage.Events.HitCrud:FireServer(v.Hitbox,Gun,string.pack("f f f f f f f f f s f i1 f f i1 i1 f f f f f f f f",table.unpack(PackValues)))
                    end
                    break
                end
            end
        end)
    end
end

workspace.Ray_Ignore.ChildAdded:Connect(DoFilter)]]
