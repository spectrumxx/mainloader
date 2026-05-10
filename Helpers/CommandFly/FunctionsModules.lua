-- [[ Spectrum X - FunctionsModules.lua ]]
-- Link: https://raw.githubusercontent.com/spectrumxx/mainloader/refs/heads/main/Helpers/CommandFly/FunctionsModules.lua

return function(Env)
    -- Importa o ambiente do loader
    local st, hs, path, lp, r, c, v3, up = Env.st, Env.hs, Env.path, Env.lp, Env.r, Env.c, Env.v3, Env.up
    local fly, nc, ws = Env.fly, Env.nc, Env.ws
    local bv, bg, ncConn = nil, nil, nil

    local Funcs = {}

    -- [SISTEMA DE SAVE/LOAD]
    Funcs.sv = function()
        if writefile then
            local d = {}
            for k, v in pairs(st) do d[k] = v[1] end
            writefile(path, hs:JSONEncode(d))
        end
    end

    Funcs.ls = function()
        if isfile and isfile(path) then
            local ok, d = pcall(function() return hs:JSONDecode(readfile(path)) end)
            if ok and d then
                for k, v in pairs(d) do if st[k] then st[k][1] = v end end
            end
        end
    end

    -- [LÓGICA DO FLY]
    Funcs.m = function(state)
        if not state then 
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid.PlatformStand = false
            end
            return 
        end
        
        local ch = lp.Character or lp.CharacterAdded:Wait()
        local h = ch:WaitForChild("Humanoid")
        local rt = ch:WaitForChild("HumanoidRootPart")
        
        h.PlatformStand = true
        bv = Instance.new("BodyVelocity", rt)
        bg = Instance.new("BodyGyro", rt)
        
        bv.MaxForce = v3(1, 1, 1) * math.huge
        bg.MaxTorque = v3(1, 1, 1) * math.huge
        bg.P = 9000
        
        task.spawn(function()
            while state and ch.Parent do
                local md = h.MoveDirection
                if md.Magnitude > 0 then
                    local rv = c.CFrame.RightVector
                    local fv = up:Cross(rv).Unit
                    local z, x = md:Dot(fv), md:Dot(rv)
                    local d = (c.CFrame.LookVector * z) + (c.CFrame.RightVector * x)
                    bv.Velocity = d.Unit * st.sp[1]
                else
                    bv.Velocity = v3(0, 0, 0)
                end
                bg.CFrame = c.CFrame
                r.RenderStepped:Wait()
            end
        end)
    end

    -- [LÓGICA DO NOCLIP]
    Funcs.startNoclip = function()
        local conn = r.Stepped:Connect(function()
            local ch = lp.Character
            if not ch then return end
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
        return conn
    end

    -- [LÓGICA DO WALKSPEED]
    Funcs.applyWalkspeed = function()
        local ch = lp.Character
        if ch and ch:FindFirstChild("Humanoid") then
            ch.Humanoid.WalkSpeed = st.wsp[1]
        end
    end

    Funcs.resetWalkspeed = function()
        local ch = lp.Character
        if ch and ch:FindFirstChild("Humanoid") then
            ch.Humanoid.WalkSpeed = 16
        end
    end

    return Funcs
end
