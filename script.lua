-- Infinite Yield Fling By Phnhh_8 Do not repost
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local flinging = false
local bambam = nil
local noclipConn = nil

local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

-- Hàm bật Fling
local function startFling()
    if flinging then return end
    local char = LocalPlayer.Character
    local root = getRoot(char)
    if not char or not root then return end

    flinging = true

    -- Tắt va chạm (Noclip) để không tự văng
    noclipConn = RunService.Stepped:Connect(function()
        if flinging and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)

    -- Tạo lực xoay cực lớn
    bambam = Instance.new("BodyAngularVelocity")
    bambam.Name = "IY_Fling"
    bambam.Parent = root
    bambam.AngularVelocity = Vector3.new(0, 99999, 0)
    bambam.MaxTorque = Vector3.new(0, math.huge, 0)
    bambam.P = math.huge

    -- Giữ vận tốc ổn định và giật lực
    task.spawn(function()
        while flinging and char and root and bambam.Parent do
            bambam.AngularVelocity = Vector3.new(0, 99999, 0)
            task.wait(0.2)
            if not flinging then break end
            bambam.AngularVelocity = Vector3.new(0, 0, 0)
            task.wait(0.1)
        end
    end)
end

-- Hàm tắt Fling (Unfling)
local function stopFling()
    flinging = false
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if bambam then
        bambam:Destroy()
        bambam = nil
    end
    -- Đưa vận tốc nhân vật về 0 để không bị trôi
    local root = getRoot(LocalPlayer.Character)
    if root then
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
    end
end

-- KÍCH HOẠT NGAY KHI CHẠY SCRIPT:
startFling()

-- Do you want to off this? : stopFling()
