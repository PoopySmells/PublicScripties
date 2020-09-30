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
local eggTab = lib:CreateWindow('Eggs')
local teleportTab = lib:CreateWindow('Teleports')
local miscTab = lib:CreateWindow('Misc')
local setTab = lib:CreateWindow('Settings')

autoTab:AddToggle('Auto Click',function()
    ClickAuto = not ClickAuto;
end)

local SpeedOfClick = 1
setTab:AddSlider("Click Speed",0,2,1,function(var)
    SpeedOfClick = var
end)

spawn(function()
    while true do 
        if (ClickAuto and localPlayer.Character) then 
            doRemote(1)
        end 
        wait(SpeedOfClick)
    end
end)

autoTab:AddToggle('Auto Sell',function()
    SellAuto = not SellAuto;
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

farmTab:AddToggle('Farm Run',function()
    runAuto = not runAuto;
end)

farmTab:AddToggle('Farm Endurance',function()
    AutoEndurance = not AutoEndurance;
end)

spawn(function()
    while true do 
        local isTreading = false;
        if runAuto then 
            isTreading = true;
            for i,v in pairs(workspace:GetDescendants()) do 
                if v:IsA("Model") and v.Name == 'Treadmill' then 
                    if runAuto and isTreading then 
                        localPlayer.Character:MoveTo(v:FindFirstChildOfClass('Part').Position)    
                    end
                    wait(1)
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

farmTab:AddToggle('Farm Punches',function()
    farmPunches = not farmPunches;
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

miscTab:AddButton('Redeem All Codes',function()
    local codeList = ReplicatedStorage.Codes:GetChildren();
    for i = 1,#codeList do 
        if codeList[i].Name then 
            Event1:FireServer("Codes",codeList[i].Name)
        end
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

miscTab:AddButton("Unlock All Gamepasses",function()
    local myPlayers = ReplicatedStorage.Players[localPlayer.Name].Gamepass:GetChildren();
    local toUnlock = {"AutoBuy","AutoRank","AutoClick","ZoneUnlock","FastLifting"}
    for i,v in ipairs(myPlayers) do 
        if v.Name == toUnlock[i].Name then 
            v.Value = true;
        end
    end
end)

autoTab:AddToggle('Auto-Rebirth',function()
    rebirthAuto = not rebirthAuto;
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

autoTab:AddToggle('AutoBuy-Strength',function()
    StrengthAutobuy = not StrengthAutobuy;
end)

autoTab:AddToggle('AutoBuy-Endurance',function()
    EnduranceAutobuy = not EnduranceAutobuy;
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
