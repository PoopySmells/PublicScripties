--[[

 /$$     /$$                                       /$$$$$$   /$$                        
|  $$   /$$/                                      /$$__  $$ | $$                        
 \  $$ /$$//$$$$$$  /$$   /$$ /$$$$$$$   /$$$$$$ | $$  \__//$$$$$$    /$$$$$$   /$$$$$$ 
  \  $$$$//$$__  $$| $$  | $$| $$__  $$ /$$__  $$|  $$$$$$|_  $$_/   |____  $$ /$$__  $$
   \  $$/| $$  \ $$| $$  | $$| $$  \ $$| $$  \ $$ \____  $$ | $$      /$$$$$$$| $$  \__/
    | $$ | $$  | $$| $$  | $$| $$  | $$| $$  | $$ /$$  \ $$ | $$ /$$ /$$__  $$| $$      
    | $$ |  $$$$$$/|  $$$$$$/| $$  | $$|  $$$$$$$|  $$$$$$/ |  $$$$/|  $$$$$$$| $$      
    |__/  \______/  \______/ |__/  |__/ \____  $$ \______/   \___/   \_______/|__/      
                                        /$$  \ $$                                       
                                       |  $$$$$$/                                       
                                        \______/                                        
                          /$$$$$$                      /$$             /$$              
                         /$$__  $$                    |__/            | $$              
                        | $$  \__/  /$$$$$$$  /$$$$$$  /$$  /$$$$$$  /$$$$$$   /$$$$$$$ 
                        |  $$$$$$  /$$_____/ /$$__  $$| $$ /$$__  $$|_  $$_/  /$$_____/ 
                         \____  $$| $$      | $$  \__/| $$| $$  \ $$  | $$   |  $$$$$$  
                         /$$  \ $$| $$      | $$      | $$| $$  | $$  | $$ /$$\____  $$ 
                        |  $$$$$$/|  $$$$$$$| $$      | $$| $$$$$$$/  |  $$$$//$$$$$$$/ 
                         \______/  \_______/|__/      |__/| $$____/    \___/ |_______/  
                                                          | $$                          
                                                          | $$                          
                                                          |__/                                                                                                                                                                                                                                                               
--]]

local lib = loadstring(game:HttpGet"https://fluxteam.xyz/external-files/lib.lua")()
local Players = game:GetService('Players');
local localPlayer = Players.LocalPlayer;
local ReplicatedStorage = game:GetService"ReplicatedStorage";
local RunService = game:GetService('RunService')
local renderedStepped = RunService.RenderStepped
--{ Events // Remotes }--                                           
local Event1 = ReplicatedStorage.Network.Port1;

function doRemote(arg)
    local forOption = (arg == 1 and "Click") or (arg == 2 and "SellEnergy") or (arg == 3 and "Running")
    return Event1:FireServer(forOption)
end

--[[
    doRemote(1) // Fires (Click remote) -- common sense
    doRemote(2) // Fires (Sell remote) -- ^^
    doRemote(3) // Fires (Running remote) -- Gains Energy for running faster
]]
local autoTab = lib:CreateWindow('Auto-Tools')
local farmTab = lib:CreateWindow('Farming')
local areaTab = lib:CreateWindow('Areas')
local teleportTab = lib:CreateWindow('Teleports')
local miscTab = lib:CreateWindow('Misc')

autoTab:AddToggle('Auto Click',function(bool)
    ClickAuto = bool;
end)

spawn(function()
    while true do 
        if (ClickAuto and localPlayer.Character) then 
            doRemote(1)
        end 
        wait()
    end
end)

autoTab:AddToggle('Auto Sell',function(bool)
    SellAuto = bool;
end)

RunService.RenderStepped:Connect(function()
    local Amount = string.split(localPlayer.PlayerGui.Main.LeftFrame.EnergyFrame.AmountLabel.Text,"/");
    if SellAuto then
        local GUIPopup = localPlayer.PlayerGui.Main.Frame.FrameYY.FrameXY.Sell;
        if (Amount[1] == Amount[2]) or GUIPopup.Visible and SellAuto then 
            localPlayer.PlayerGui.Main.Frame.FrameYY.FrameXY.Sell.Visible = false;
            doRemote(2)
        end
    end
    renderedStepped:Wait()
end)

farmTab:AddToggle('Farm Stanima',function(bool)
    runAuto = bool;
end)

farmTab:AddToggle('Farm Endurance',function(bool)
    AutoEndurance = bool;
end)

autoTab:AddToggle('Auto Kill',function(bool)
    killAutomatic = bool
end)

local PlayersFolder = ReplicatedStorage.Players;
function plrToKill()
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do 
        if (v.Name ~= game.Players.LocalPlayer.Name and v.Character) then 
            if (PlayersFolder[v.Name] and PlayersFolder[v.Name].Game.PvP.Value) then  
                if killAutomatic then 
                    return v;
                end
            end
        end
    end
end

function teleportTo(player)
    local myChar = localPlayer.Character
    local humanoidRoot = myChar:FindFirstChild("HumanoidRootPart");
    
    if player and player.Character and player.Character.Humanoid.Health > 1 then 
        repeat
            local playerChar = player.Character;
            humanoidRoot.CFrame = playerChar.HumanoidRootPart.CFrame*Vector3.new(-humanoidRoot.CFrame.lookVector)
            wait()
        until autoKill == false or (not player.Character and player.Character.Humanoid.Health < 1)
    end
end 

spawn(function()
    while true do 
        if killAutomatic then 
            local plr = plrToKill()
            repeat
                teleportTo(plr)
                local random = (math.random(1,2) == 2 and "Punch" or "Stomp")
                ReplicatedStorage.Network.Port1:FireServer(random,{plr})
                wait(.05)
            until killAutomatic == false or (plr.Character and PlayersFolder[plr.Name].Game.Health == 0)
        end
        wait()
    end
end)

spawn(function()
    local isTreading = false;
    local oldTread;
    while true do 
        if runAuto then 
            isTreading = true;
            for i,v in pairs(workspace:GetDescendants()) do 
                if v:IsA("Model") and v.Name == 'Treadmill' and v ~= oldTread then 
                    if runAuto and isTreading then 
                        oldTread = v
                        localPlayer.Character:MoveTo(v:FindFirstChildOfClass("Part").Position)
                    end
                end
            end
        else
            isTreading = false;
        end
        wait()
    end
end)

local old = nil
function randomModel()
    for i,v in pairs(workspace.PowerTrainingFolder:GetChildren()) do 
        if v ~= old then 
            old = v;
            return v;
        end
    end
end

farmTab:AddToggle('Farm Strength',function(bool)
    farmPunches = bool;
end)

spawn(function()
    while true do 
        if farmPunches then 
            local ModelTo = randomModel()
            Event1:FireServer("Punching",ModelTo) 
            wait()
        end
        wait(0.6)
    end
end)

miscTab:AddButton('Copy Invite',function()
    setclipboard("https://crypthub.xyz/GetDiscord")
end)

local funcCooldown;
for i,v in pairs(getgc()) do 
    if typeof(v) == "function" and debug.getinfo(v).name == "updateClickCooldown" then
        func = v;
    end
end

local gamepass = ReplicatedStorage.Players[localPlayer.Name].Gamepass.FastLifting
miscTab:AddToggle('Fast Click',function(bool)
    FastClickOpt = bool
    gamepass.Value = bool
end)

local numberChange = 0.02
spawn(function()
    while true do 
        if FastClickOpt then 
            debug.setupvalue(funcCooldown,2,numberChange)
            debug.setconstant(funcCooldown,4,numberChange)
            funcCooldown()
        end
        wait()
    end
end)

spawn(function()
    for i,v in pairs(workspace:GetChildren()) do 
        if v:IsA('MeshPart') then 
            if string.sub(v.Name,1,4) == "Tier" then 
                local name = string.sub(v.Name,1,5);
                teleportTab:AddButton(name,function()
                    localPlayer.Character:MoveTo(v.Position)
                end)
            end
        end
    end
end)

farmTab:AddToggle('Farm All',function(bool)
    allFarming = bool;
end)

function getTread()
    for i,v in pairs(workspace:GetDescendants()) do 
        if v:IsA("Model") and v.Name == 'Treadmill'then 
            return v:FindFirstChildOfClass("Part");
        end
    end
end

function getEndurancePad()
    for i,v in pairs(workspace.VitalityTrainingFolder:GetChildren()) do 
        if v:IsA("Model") then 
            return v:FindFirstChildOfClass('UnionOperation'); 
        end
    end
end

spawn(function()
    while true do 
        if allFarming then
            local treadMill = getTread();
            localPlayer.Character:MoveTo(treadMill.Position);
            wait(1)
            local EndurancePad = getEndurancePad();
            localPlayer.Character:MoveTo(EndurancePad.Position);
            wait(4)
            local ModelTo = randomModel()
            Event1:FireServer("Punching",ModelTo) 
            wait(1)
        end
        wait()
    end
end)

spawn(function()
    local Areas = {};
    for i,v in pairs(workspace:GetChildren()) do 
        if string.sub(v.Name,1,4) == "Area" then 
            Areas[#Areas + 1] = {
                Name = v.Name,
                PartPos = v.Position
            }
        end
    end

    for i,v in ipairs(Areas) do 
        areaTab:AddButton(v.Name,function()
            game.Players.LocalPlayer.Character:MoveTo(v.PartPos*Vector3.new(.25,0,.25))
        end)
    end
end)

autoTab:AddToggle('Auto-Rebirth',function(bool)
    rebirthAuto = bool;
end)

spawn(function()
    while true do 
        if rebirthAuto then 
            Event1:FireServer("Purchase","Rank")
        end
        wait()
    end
end)

spawn(function()
    local isEndurance = false;
    while true do 
        if AutoEndurance then 
            isEndurance = true;
            for i,v in pairs(workspace.VitalityTrainingFolder:GetChildren()) do 
                if v:IsA("Model") then 
                    if AutoEndurance and isEndurance then 
                        localPlayer.Character:MoveTo(v:FindFirstChildOfClass('UnionOperation').Position)    
                    end
                    wait(3)
                end
            end
        else
            isEndurance = false;
        end
        wait()
    end
end)

autoTab:AddToggle('AutoBuy-Strength',function(bool)
    StrengthAutobuy = bool;
end)

autoTab:AddToggle('AutoBuy-Endurance',function(bool)
    EnduranceAutobuy = bool;
end)

spawn(function()
    while true do 
        if EnduranceAutobuy then 
            Event1:FireServer("Purchase","Endurance")
        end
        wait()
    end
end)

spawn(function()
    while true do 
        if StrengthAutobuy then 
            Event1:FireServer("Purchase","Strength")
        end
        wait()
    end
end)
