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

autoTab:AddToggle('Auto Click',function()
    ClickAuto = not ClickAuto;
end)

spawn(function()
    while true do 
        if (ClickAuto and localPlayer.Character) then 
            doRemote(1)
        end 
        wait()
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

miscTab:AddButton('Discord',function()
    setclipboard("https://crypthub.xyz/GetDiscord")
end)

miscTab:AddButton('my Discord Name/Id',function()
    setclipboard("YoungStar#5628/628384321773764618")
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

farmTab:AddToggle('Farm All',function()
    allFarming = not allFarming;
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
