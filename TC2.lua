--[[
    [*] Info, [+] Update, [-] Removed, [>] Item

    [*] Created by Birb (https://v3rmillion.net/member.php?action=profile&uid=783024)
    [*] v0.1.1
    [*] Release
    [-] Anti Headshot
        [*] Not really useful
    [-] Pickup Heal
        [*] Serversided check for distance (not confirmed)
    [+] Labled/Disabled Patched Functions
        [>] Sap all (Unpatched?)
    [TODO]
        [>] Kill all
        [>] Counter attack (Deny projectiles)
]]--

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local Camera = workspace.CurrentCamera
local Humanoid = Character:FindFirstChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Status = Player.Status
local Target

local Birb = {}
Birb.TC2 = {}
Birb.Locals = {PackString = "", CurrentHitPart = nil}
Birb.TC2.Toggles = {
    KillAll = false,
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
    FOV = false,
    Vis = false,
    VisFOV = false,
    Sap = false,
    Invis = false,
    Cloak = false,
    Charge = false,
    Healy = false,
    Dot = false,
    AntiHead = false,
    HealyKit = false,
    CounterAttack = false
}
Birb.TC2.Changes = {
    FireRate = 0,
    Recoil = 0,
    WS = 20,
    FOVRadius = 100
}
Birb.TC2.Frameworks = {}
Birb.TC2.SetFramework = function(FrameWorkScan)
    for i,v in next, getgc(true) do
        if typeof(v) == "table" then
            for a,b in next, FrameWorkScan do
                if Birb.TC2.Frameworks[a] ~= nil then continue end
                if typeof(rawget(v,b)) == "function" then
                    Birb.TC2.Frameworks[a] = v
                end
            end
        end
    end
end

Birb.TC2.GetFramework = function(FrameWorkName)
    return Birb.TC2.Frameworks[FrameWorkName]
end

Birb.TC2.SetFramework({
    ["Visualizer"] = "speedupdate",
    ["Weapons"] = "returndamagemod",
    ["Client"] = "inducefalldamage",
    ["Inventory"] = "equipItem",
    --["ClassHandler"] = "runinvis"
})

for i,v in next, getgc(true) do
    if v and typeof(v) == "table" then
        if rawget(v,"Debug") then
            for a,b in next, debug.getproto(rawget(v,"Debug"),1,true) do
                --print(a,debug.getupvalue(b,1))
                debug.setupvalue(b,1,function()
                    return task.wait(9e9)
                end)
            end
        end
        if rawget(v,"firebullet") then
            for a,b in next, debug.getupvalues(rawget(v,"firebullet")) do
                if typeof(b) == "Instance" and b.ClassName == "RemoteEvent" then
                    Birb.Locals.CurrentHitPart = b --u2
                    Birb.Locals.PackString = debug.getupvalue(rawget(v,"firebullet"),a-1) --u3
                    Birb.Locals.DecodingTable = debug.getupvalue(rawget(v,"firebullet"),a-2) --table2
                end
            end 
        end
    end
end
print(Birb.Locals.DecodingTable)
local InstaHook = Birb.TC2.GetFramework("Weapons").returndamagemod
Birb.TC2.GetFramework("Weapons").returndamagemod = function(...)
    if Birb.TC2.Toggles.Insta == true then
        return math.huge
    end
    return InstaHook(...)
end
local FDHook = Birb.TC2.GetFramework("Client").inducefalldamage
Birb.TC2.GetFramework("Client").inducefalldamage = function(...)
    if Birb.TC2.Toggles.FallDMG == true then
        return
    end
    return FDHook(...)
end

local SpreadHook = Birb.TC2.GetFramework("Weapons").calcspread
Birb.TC2.GetFramework("Weapons").calcspread = function(...)
    if Birb.TC2.Toggles.Spread == true then
        return CFrame.Angles(0,0,0)
    end
    return SpreadHook(...)
end
local CameraHook = Birb.TC2.GetFramework("Weapons").RotCamera
Birb.TC2.GetFramework("Weapons").RotCamera = function(...)
    if Birb.TC2.Toggles.Recoil == true then
        return
    end
    return CameraHook(...)
end

local SpeedHook = Birb.TC2.GetFramework("Visualizer").speedupdate
Birb.TC2.GetFramework("Visualizer").speedupdate = function(...)
    if Birb.TC2.Toggles.Walkspeed == true and Humanoid then
        Humanoid.WalkSpeed = Birb.Changes.WS
        return
    end
    return SpeedHook(...)
end




local Changing = {}
local ValueChanger = function(ValueBase,Prop,Change,Enabler)
    if not Changing[ValueBase] then
         if Birb.TC2.Toggles[Enabler] ~= nil then
            Changing[ValueBase] = ValueBase:GetPropertyChangedSignal(Prop):Connect(function()
                if Birb.TC2.Toggles[Enabler] == true and ValueBase[Prop] ~= nil then
                    ValueBase[Prop] = Change
                end
            end)
        end
    else
        Changing[ValueBase]:Disconnect()
        if Birb.TC2.Toggles[Enabler] ~= nil then
            Changing[ValueBase] = ValueBase:GetPropertyChangedSignal(Prop):Connect(function()
                if Birb.TC2.Toggles[Enabler] == true then
                    ValueBase[Prop] = Change
                end
            end)
        end
    end
end

for i,v in next, Birb.TC2.GetFramework("Weapons") do
    if i:match("ammocount") then
        ValueChanger(v,"Value",1000,"Ammo")
    end
end

ValueChanger(Birb.TC2.GetFramework("Weapons").secondaryduration,"Value",0,"Ammo")
ValueChanger(Birb.TC2.GetFramework("Client").maxbaseball,"Value",1000,"Ammo")
ValueChanger(Birb.TC2.GetFramework("Client").baseballs,"Value",1000,"Ammo")
ValueChanger(Birb.TC2.GetFramework("Client").cloakleft,"Value",10,"Cloak")
ValueChanger(Birb.TC2.GetFramework("Client").chargeleft,"Value",30,"Charge")

--ValueChanger(TC2.GetFramework("Weapons").chargetick,"Value",tick()+50,"Testing")

local OldIndex
OldIndex = hookmetamethod(game,"__index",newcclosure(function(Self,Key)
    if Key == "Value" and Self:IsA("ValueBase") and not checkcaller() then
        if Self.Name:lower():match("firerate") and Birb.TC2.Toggles.FR == true and Self.Parent:FindFirstChild("Projectile") == nil then
            return Birb.TC2.Changes.FireRate
        end
    end
    if Key == "Clips" and Birb.TC2.Toggles.Wallbang == true and not checkcaller() then
        return workspace.Map
    end
    return OldIndex(Self,Key)
end))


local FovCircle = Drawing.new("Circle")
FovCircle.Transparency = 1
FovCircle.Thickness = 2
FovCircle.Radius = Birb.TC2.Changes.FOVRadius
FovCircle.Filled = false
FovCircle.Position = UIS:GetMouseLocation()
FovCircle.Visible = false
FovCircle.Color = Color3.fromRGB(255, 255, 255)

local GetClosestToMouse = function(TargetPart)
    --print(Birb.TC2.Toggles.FOV and Birb.TC2.Changes.FOVRadius)

    local MaxDistance = (Birb.TC2.Toggles.FOV and Birb.TC2.Changes.FOVRadius or nil)
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
                    if Birb.TC2.Toggles.VisFOV == true then
                        if IsVisible == true then
                            Closest = Magnitude
							ToRet = v.Character
						else
							ToRet = nil
                        end
                    end
                    local Map = workspace:FindFirstChild("Map")
                    if Birb.TC2.Toggles.Vis == true and Selected and Map and Map:FindFirstChild("Ignore") then
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

local FireHitPart = function(v)
    if not Birb.TC2.GetFramework("Client").gun.Value then return end
    local PackValues = {
        PosX = v.Hitbox.CFrame.X,
        PosY = v.Hitbox.CFrame.Y,
        PosZ = v.Hitbox.CFrame.Z,
        HPPX = v.Hitbox.CFrame.Position.X,
        HPPY = v.Hitbox.CFrame.Position.Y,
        HPPZ = v.Hitbox.CFrame.Position.Z,
        HPX = v.Hitbox.CFrame.Position.X,
        HPY = v.Hitbox.CFrame.Position.Y,
        HPZ = v.Hitbox.CFrame.Position.Z,
        gunname = Birb.TC2.GetFramework("Client").gun.Value.Name,
        damage = 2000,
        head = 0,
        range = 1000,
        distance = 0,
        backstab = 0,
        critb = 0,
        mcrit = 0,
        metal = 0,
        time = workspace.Status.ServerStats.DistributedTime.Value,
        penetrated = 1,
        boom = 0,
        marketgarden = 0,
        ping = Player.Ping.Value,
        mg = 0,
        damagemodifier = 0,
        gf = "",
        ts = 6,
        bdm = 2000
    }
    local PackIn = {}
    for i,v in next, Birb.Locals.DecodingTable do
        PackIn[i] = PackValues[v[1]]
    end
    local Gun = Character:FindFirstChild("Gun")
    if Gun then
        --Birb.Locals.CurrentHitPart:FireServer(v.Hitbox,Gun,string.pack(Birb.Locals.PackString,table.unpack(PackIn)),string.pack("f", 1),string.pack("f", 0))
    end
end

RunService:BindToRenderStep("Runeasd", 1, function()
    --[[if Player.Character ~= nil and Player.Character:FindFirstChild("Dead") then
        local Dead = Player.Character:FindFirstChild("Dead")
        if Dead.Value == true then
            ReplicatedStorage.Events.LoadCharacter:FireServer()
            Birb.TC2.GetFramework("Client").setcharacter(Player)
            Dead.Value = false
        end
    end]]
    if Birb.TC2.Toggles.KillAll == true then
        for _,Targeted in next, game.Players:GetPlayers() do
            if Targeted and Targeted.Character and Targeted.Character:FindFirstChild("Hitbox") and Targeted.Team ~= Player.Team and Targeted.Character:FindFirstChild("Humanoid") and Targeted.Character:FindFirstChild("Humanoid").Health > 0 then
                --FireHitPart(Targeted.Character)
            end
        end
    end
    if Birb.TC2.Toggles.Healy == true and Character and Character:FindFirstChild("Gun") and Character.Gun:FindFirstChild("effect") and Character.Gun.effect:FindFirstChild("hp") and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health < Character.Humanoid.MaxHealth then
        ReplicatedStorage.Events.LoseHealth:FireServer(-500)
    end
	if Birb.TC2.Toggles.Sap == true then
        for i,v in next, getrenv()._G.BuildingsOOP do
            if v and rawget(v,"BldgObjs") then
                local BldgData = rawget(v,"BldgObjs")
                local TeamColor = BldgData.TeamColor3.BrickColor
                if TeamColor ~= Player.TeamColor and Birb.TC2.GetFramework("Client").gun.Value then
                    --FireHitPart(BldgData)
                end
            end
        end    
    end
    FovCircle.Position = UIS:GetMouseLocation()
    Target = GetClosestToMouse()
end)
local OldNameCall
OldNameCall = hookmetamethod(game,"__namecall",newcclosure(function(Self,...)
    local Method = getnamecallmethod()
    local Args = {...}
    if Method == "FireServer" and not checkcaller() then
        if typeof(Self) == "Instance" then
            if Self.IsA(Self,"RemoteEvent") then
                if Self.Name == "DeployBuilding" and Birb.TC2.Toggles.Level3 == true then
                    return Self.FireServer(Self,Args[1],Args[2],true,3,216,200,200,0,0,Args[10])
                end
                if Self.Name == "ReplicateDot" and Birb.TC2.Toggles.Dot == true then
                    return
                end
                if Self.Name == "UpdateMetal2" and Birb.TC2.Toggles.Ammo == true then
                    return
                end
                if Self.Name == "IMISSED" and Birb.TC2.Toggles.SelfDMG == true then
                    return
                end
                if Self.Name == "Undisguise" and Birb.TC2.Toggles.Undisguise == true then
                    return
                end
            end
        end 
    end
   if Method == "Raycast" and not checkcaller() then
        if Target ~= nil and Target.FindFirstChild(Target,"Head") and Birb.TC2.Toggles.SilentAim == true then
            if Args[3].IgnoreWater == true then
                --print(Target)
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

AimTab:Toggle({
	Name = "Toggle Silent Aim",
	StartingState = false,
	Description = "Bullets go towards the targets's head when you shoot",
	Callback = function(Bool)
        Birb.TC2.Toggles.SilentAim = Bool
    end
})

AimTab:Toggle({
	Name = "Toggle FOV Circle",
	StartingState = false,
	Description = "Only lock onto the target inside the circle on screen",
	Callback = function(Bool)
        FovCircle.Visible = Bool
        Birb.TC2.Toggles.FOV = Bool
    end
})

AimTab:Slider({
	Name = "FOV Radius",
	Default = 100,
	Min = 50,
	Max = 1000,
	Callback = function(Value)
        Birb.TC2.Changes.FOVRadius = Value
        FovCircle.Radius =Value
    end
})

AimTab:Toggle({
	Name = "Toggle Visibility Check",
	StartingState = false,
	Description = "Check if the target is behind a wall",
	Callback = function(Bool)
        Birb.TC2.Toggles.Vis = Bool
    end
})

AimTab:Toggle({
	Name = "Toggle Visibility in FOV Check",
	StartingState = false,
	Description = "Checks if the target is in your FOV so you don't kill a dude behind you",
	Callback = function(Bool)
        Birb.TC2.Toggles.VisFOV = Bool
    end
})


GunTab:Toggle({
	Name = "Build Level 3's",
	StartingState = false,
	Description = "Any mechanic build is automatically placed as a level 3",
	Callback = function(Bool)
        Birb.TC2.Toggles.Level3 = Bool
    end
})
GunTab:Toggle({
	Name = "Infinite Ammo",
	StartingState = false,
	Description = "1000 ammo constantly (don't use wreckers yard)",
	Callback = function(Bool)
        Birb.TC2.Toggles.Ammo = Bool
    end
})
GunTab:Toggle({
	Name = "Fast Firerate",
	StartingState = false,
	Description = "Firerate for bullet based (hitscan) guns is increased significantly",
	Callback = function(Bool)
        Birb.TC2.Toggles.FR = Bool
    end
})
GunTab:Toggle({
	Name = "No Spread",
	StartingState = false,
	Description = "Gun spread is no longer calculated",
	Callback = function(Bool)
        Birb.TC2.Toggles.Spread = Bool
    end
})
GunTab:Toggle({
	Name = "Instant Kill",
	StartingState = false,
	Description = "Damage goes to infinity",
	Callback = function(Bool)
        Birb.TC2.Toggles.Insta = Bool
    end
})
GunTab:Toggle({
	Name = "No Recoil",
	StartingState = false,
	Description = "No gun recoil",
	Callback = function(Bool)
        Birb.TC2.Toggles.Recoil = Bool
    end
})
GunTab:Toggle({
	Name = "No Self Damage",
	StartingState = false,
	Description = "Self damage from melee is negated",
	Callback = function(Bool)
        Birb.TC2.Toggles.SelfDMG = Bool
    end
})
GunTab:Toggle({
	Name = "Facestabs",
	StartingState = false,
	Description = "Allow for facestabs (360 backstab)",
	Callback = function(Bool)
        Birb.TC2.GetFramework("Weapons").backstabangle = 180
        if Bool then Birb.TC2.GetFramework("Weapons").backstabangle = 360 end
    end
})
--[[GunTab:Toggle({
	Name = "Testing switch",
	StartingState = false,
	Description = "Toggle testing features",
	Callback = function(Bool)
        Birb.TC2.Toggles.Testing = Bool
    end
})
]]
GunTab:Toggle({
	Name = "Wallbang",
	StartingState = false,
	Description = "Shoot through walls",
	Callback = function(Bool)
        Birb.TC2.Toggles.Wallbang = Bool
    end
})

GunTab:Toggle({
	Name = "Infinite Charge",
	StartingState = false,
	Description = "You have to run into a wall to stop charging lol",
	Callback = function(Bool)
        Birb.TC2.Toggles.Charge = Bool
    end
})

GunTab:Toggle({
	Name = "Infinite Cloak",
	StartingState = false,
	Description = "Just buy a cloak and dagger tbh",
	Callback = function(Bool)
        Birb.TC2.Toggles.Cloak = Bool
    end
})

GunTab:Toggle({
	Name = "No Sniper Dot",
	StartingState = false,
	Description = "Removes the dot when aiming with a sniper",
	Callback = function(Bool)
        Birb.TC2.Toggles.Dot = Bool
    end
})

CharacterTab:Toggle({
	Name = "No Fall Damage",
	StartingState = false,
	Description = "Don't take fall damage",
	Callback = function(Bool)
        Birb.TC2.Toggles.FallDMG = Bool
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

    end
})
CharacterTab:Toggle({
	Name = "No Undisguise",
	StartingState = false,
	Description = "As Agent when disguise you don't undisguise when shooting",
	Callback = function(Bool)
        Birb.TC2.Toggles.Undisguise = Bool
    end
})
CharacterTab:Toggle({
	Name = "Jumppower",
	StartingState = false,
	Description = "Enable your jumppower to be set to the slider value",
	Callback = function(Bool)
        Humanoid.UseJumpPower = Bool
        Birb.TC2.Toggles.Jumppow = Bool
    end
})
CharacterTab:Slider({
	Name = "JP Amount",
	Default = 50,
	Min = 0,
	Max = 1000,
	Callback = function(Value)
        ValueChanger(Birb.TC2.GetFramework("Client").JP,"Value",Value,"Jumppow")
    end
})

CharacterTab:Toggle({
	Name = "Walkspeed",
	StartingState = false,
	Description = "Enable your walkspeed to be set to the slider value",
	Callback = function(Bool)
        Birb.TC2.Toggles.Walkspeed = Bool
        Humanoid.WalkSpeed = Birb.TC2.Changes.WS
    end
})
CharacterTab:Slider({
	Name = "WS Amount",
	Default = 20,
	Min = 0,
	Max = 1000,
	Callback = function(Value)
        Birb.TC2.Changes.WS = Value
        Humanoid.WalkSpeed = Birb.TC2.Changes.WS
    end
})

--[[MiscTab:Toggle({
	Name = "Sap All",
	StartingState = false,
	Description = 'Saps (Kills) all buildings',
	Callback = function(Bool)
        Birb.TC2.Toggles.Sap = Bool
    end
})
]]
--[[MiscTab:Toggle({
	Name = "Kill All",
	StartingState = false,
	Description = 'Kill all enemies',
	Callback = function(Bool)
        Birb.TC2.Toggles.KillAll = Bool
    end
})]]

MiscTab:Toggle({
	Name = "Food Heal",
	StartingState = false,
	Description = "A scuffed godmode you need a item like brash burger in your hand",
	Callback = function(Bool)
        Birb.TC2.Toggles.Healy = Bool
    end
})


--[[MiscTab:Toggle({
	Name = "Counter Attack",
	StartingState = false,
	Description = "Any damage done to you kills the attacker",
	Callback = function(Bool)
        Birb.TC2.Toggles.CounterAttack = Bool
    end
})
]]
