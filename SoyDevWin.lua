--==============================================================
--  StealMorph HUB  •  by SoyDevWin
--==============================================================

------------------- Serviços / Jogador -------------------------
local P, UIS, RS = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService")
local plr  = P.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum  = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
plr.CharacterAdded:Connect(function(c) char=c; hum=c:WaitForChild("Humanoid"); root=c:WaitForChild("HumanoidRootPart") end)

--------------------------- GUI --------------------------------
local gui    = Instance.new("ScreenGui", plr.PlayerGui) gui.ResetOnSpawn=false
local arcade = Enum.Font.Arcade

-- seta abrir/fechar -------------------------------------------
local arrow = Instance.new("TextButton", gui)
arrow.Size, arrow.Position = UDim2.new(0,30,0,30), UDim2.new(1,-10,0,10)
arrow.AnchorPoint, arrow.Font, arrow.Text = Vector2.new(1,0), arcade, "↓"
arrow.TextSize, arrow.TextColor3 = 24, Color3.fromRGB(80,255,120)
arrow.BackgroundColor3, arrow.AutoButtonColor, arrow.BorderSizePixel = Color3.fromRGB(25,25,25), false, 0
Instance.new("UICorner", arrow).CornerRadius = UDim.new(0,8)

-- janela principal --------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size, frame.Position = UDim2.new(0,260,0,380), UDim2.new(0.5,-130,0.25,0)
frame.BackgroundColor3, frame.BackgroundTransparency = Color3.fromRGB(15,15,15), 0.7
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

-- título & assinatura -----------------------------------------
local title = Instance.new("TextLabel", frame)
title.Size,  title.Position = UDim2.new(1,0,0,30), UDim2.new(0,0,0,5)
title.BackgroundTransparency = 1
title.Font, title.TextSize, title.Text = arcade, 22, "Steal a Morph Hub"
title.TextColor3, title.TextStrokeTransparency = Color3.fromRGB(80,255,120), 0.7

local sig = Instance.new("TextLabel", frame)
sig.Size, sig.Position = UDim2.new(1,0,0,22), UDim2.new(0,0,0,32)
sig.BackgroundTransparency = 1
sig.Font, sig.TextSize, sig.Text = arcade, 20, "SoyDevWin"
sig.TextColor3 = Color3.fromRGB(0,0,0)
sig.TextXAlignment = Enum.TextXAlignment.Center

-- abrir/fechar frame
local open = true
arrow.MouseButton1Click:Connect(function()
	open = not open
	frame.Visible = open
	arrow.Text   = open and "↓" or "↑"
end)

-- arrastar frame ----------------------------------------------
do
	local drag, startPos, startInput
	local function update(inp)
		local delta = inp.Position - startInput
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X,
		                           startPos.Y.Scale, startPos.Y.Offset+delta.Y)
	end
	frame.InputBegan:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
			drag, startInput, startPos = true, inp.Position, frame.Position
			inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then drag=false end end)
		end
	end)
	frame.InputChanged:Connect(function(inp)
		if (inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseMovement) and drag then
			update(inp)
		end
	end)
end

---------------- helper de botões ------------------------------
local function wide(txt,y,col)
	local b = Instance.new("TextButton", frame)
	b.Size, b.Position = UDim2.new(0,220,0,40), UDim2.new(0,20,0,y)
	b.BackgroundColor3, b.Font, b.TextSize, b.Text = col, arcade, 20, txt
	b.TextColor3, b.AutoButtonColor, b.BorderSizePixel = Color3.new(1,1,1), false, 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end
local function short(txt,x,y,col,sz)
	local b = Instance.new("TextButton", frame)
	b.Size, b.Position = UDim2.new(0,100,0,40), UDim2.new(0,x,0,y)
	b.BackgroundColor3, b.Font, b.TextSize, b.Text = col, arcade, sz or 18, txt
	b.TextColor3, b.AutoButtonColor, b.BorderSizePixel = Color3.new(1,1,1), false, 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

----------------------------------------------------------------
-- Noclip -------------------------------------------------------
local noclip, noclipBtn = false, wide("Noclip OFF",60,Color3.fromRGB(180,0,0))
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "Noclip ON" or "Noclip OFF"
	noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
end)
RS.Stepped:Connect(function()
	if noclip and char then
		for _,p in ipairs(char:GetChildren()) do
			if p:IsA("BasePart") then p.CanCollide=false end
		end
	end
end)

----------------------------------------------------------------
-- Fly + velocidade --------------------------------------------
local flyUI, flyOn = false, false
local flyToggle = short("Fly UI OFF",20,110,Color3.fromRGB(180,0,0),14)
local speedBox = Instance.new("TextBox", frame)
speedBox.Size, speedBox.Position = UDim2.new(0,80,0,30), UDim2.new(0,130,0,115)
speedBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
speedBox.Font, speedBox.TextSize = arcade, 18
speedBox.TextColor3, speedBox.BorderSizePixel, speedBox.ClearTextOnFocus = Color3.fromRGB(80,255,120), 0, false
speedBox.PlaceholderText = "Speed"
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,8)
local flySpeed=25
speedBox.FocusLost:Connect(function() local n=tonumber(speedBox.Text); if n and n>0 then flySpeed=n end end)

local flyBtn = wide("Fly OFF",0,Color3.fromRGB(180,0,0))
flyBtn.Parent, flyBtn.Size, flyBtn.Position, flyBtn.AnchorPoint = gui, UDim2.new(0,100,0,40), UDim2.new(0.5,-50,0.8,0), Vector2.new(0.5,0)
flyBtn.Visible=false
local function drag(btn)
	local d,sp,ip
	btn.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
			d,sp,ip=true,btn.Position,i.Position
			i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local delta=i.Position-ip
			btn.Position=UDim2.new(sp.X.Scale,sp.X.Offset+delta.X,sp.Y.Scale,sp.Y.Offset+delta.Y)
		end
	end)
end
drag(flyBtn)

local upBtn = flyBtn:Clone(); upBtn.Text="▲"; upBtn.Size=UDim2.new(0,40,0,40); upBtn.Position=UDim2.new(0.9,0,0.7,-50); upBtn.Parent=gui; upBtn.Visible=false
local dnBtn = upBtn:Clone(); dnBtn.Text="▼"; dnBtn.Position=UDim2.new(0.9,0,0.7,0); dnBtn.Parent=gui; dnBtn.Visible=false
local upHold,dnHold=false,false
upBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then upHold=true end end)
upBtn.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then upHold=false end end)
dnBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then dnHold=true end end)
dnBtn.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then dnHold=false end end)

flyToggle.MouseButton1Click:Connect(function()
	flyUI = not flyUI
	flyToggle.Text = flyUI and "Fly UI ON" or "Fly UI OFF"
	flyToggle.BackgroundColor3 = flyUI and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
	flyBtn.Visible, upBtn.Visible, dnBtn.Visible = flyUI, flyUI, flyUI
	if not flyUI and flyOn then flyBtn:Activate() end
end)

local bv,bg
local function fly(enable)
	if enable then
		bv = Instance.new("BodyVelocity", root); bv.MaxForce=Vector3.new(1e5,1e5,1e5)
		bg = Instance.new("BodyGyro", root);     bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
		hum.PlatformStand=true
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
		hum.PlatformStand=false
	end
end
flyBtn.MouseButton1Click:Connect(function()
	flyOn = not flyOn
	flyBtn.Text = flyOn and "Fly ON" or "Fly OFF"
	flyBtn.BackgroundColor3 = flyOn and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
	fly(flyOn)
end)
RS.RenderStepped:Connect(function()
	if flyOn and bv and bg then
		local mv=hum.MoveDirection
		if upHold then mv=mv+Vector3.new(0,1,0) elseif dnHold then mv=mv+Vector3.new(0,-1,0) end
		if mv.Magnitude>0 then mv=mv.Unit*flySpeed end
		bv.Velocity=mv
		bg.CFrame=CFrame.new(root.Position,root.Position+workspace.CurrentCamera.CFrame.LookVector)
	end
end)

----------------------------------------------------------------
-- RemoveCooldown ----------------------------------------------
local rc=false
local rcBtn=wide("RemoveCooldown OFF",160,Color3.fromRGB(180,0,0))
local function setPrompt(v)
	for _,p in ipairs(workspace:GetDescendants()) do
		if p:IsA("ProximityPrompt") then p.HoldDuration=v and 0 or 0.5 end
	end
end
rcBtn.MouseButton1Click:Connect(function()
	rc=not rc
	rcBtn.Text = rc and "RemoveCooldown ON" or "RemoveCooldown OFF"
	rcBtn.BackgroundColor3 = rc and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
	setPrompt(rc)
end)

----------------------------------------------------------------
-- SavePoint & TpToggle + TP-flash -----------------------------
local saveBtn     = short("SavePoint",20,210,Color3.fromRGB(0,120,255))
local tpToggleBtn = short("TpToggle OFF",130,210,Color3.fromRGB(180,0,0),14)

local tpBtn = wide("TP",0,Color3.fromRGB(180,0,0))
tpBtn.Parent,tpBtn.Size,tpBtn.Position = gui, UDim2.new(0,100,0,40), UDim2.new(0.5,-50,0.75,0)
tpBtn.AnchorPoint,tpBtn.Visible = Vector2.new(0.5,0), false
drag(tpBtn)

local savedCF,tpReady=nil,true
saveBtn.MouseButton1Click:Connect(function()
	savedCF=root.CFrame
	saveBtn.Text,saveBtn.BackgroundColor3="✓",Color3.fromRGB(0,180,0)
	task.delay(1,function() saveBtn.Text,saveBtn.BackgroundColor3="SavePoint",Color3.fromRGB(0,120,255) end)
end)

local showTP=false
tpToggleBtn.MouseButton1Click:Connect(function()
	showTP=not showTP
	tpToggleBtn.Text=showTP and "TpToggle ON" or "TpToggle OFF"
	tpToggleBtn.BackgroundColor3=showTP and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
	tpBtn.Visible=showTP
end)

local function tpCD()
	tpReady=false
	for i=3,1,-1 do tpBtn.Text="⌛ "..i; task.wait(1) end
	tpBtn.Text="TP"; tpReady=true
end
tpBtn.MouseButton1Click:Connect(function()
	if not tpReady then return end
	if savedCF then
		local old=root.CFrame
		root.CFrame=savedCF; task.wait(0.1); root.CFrame=old
		tpCD()
	else
		tpBtn.Text="Sem Save!"
		task.delay(1.5,function() if tpReady then tpBtn.Text="TP" end end)
	end
end)

----------------------------------------------------------------
--                    AutoLock (sem SaveLock)                  --
----------------------------------------------------------------
local autoBtn = short("AutoLock OFF",130,260,Color3.fromRGB(180,0,0),14)

local autoOn, loop, nudgeLoop = false, nil, nil
local desiredSize = Vector3.new(588,0.296,1298.034)

-- procura pasta da base do jogador
local function findLockTouch()
	local bases = workspace:FindFirstChild("Bases")
	if not bases then return nil end
	local playersFolder = bases:FindFirstChild("Players")
	if not playersFolder then return nil end
	local myFolder = playersFolder:FindFirstChild(plr.Name)
	if not myFolder then return nil end
	return myFolder:FindFirstChild("LockTouch", true)
end

-- aplica tamanho/transparência
local function prepLT()
	local lt=findLockTouch()
	if lt and lt:IsA("BasePart") then
		lt.Size, lt.Transparency, lt.CanCollide = desiredSize, 1, false
	end
end

-- busca prompt "lock" habilitado dentro de LockTouch
local function getPrompt()
	local lt=findLockTouch()
	if not lt then return nil end
	for _,p in ipairs(lt:GetDescendants()) do
		if p:IsA("ProximityPrompt") and p.Enabled then
			local t=((p.ActionText or "")..(p.ObjectText or "")):lower()
			if t:find("lock") then return p end
		end
	end
	return nil
end

-- nudge lateral anti-AFK (±0.1 stud a cada 1 s)
local function startNudge()
	if nudgeLoop then nudgeLoop:Disconnect() end
	local dir,acc = 1,0
	nudgeLoop = RS.Heartbeat:Connect(function(dt)
		if not autoOn then return end
		acc = acc + dt
		if acc >= 1 then
			acc=0; dir=-dir
			pcall(function() root.CFrame = root.CFrame * CFrame.new(0.1*dir,0,0) end)
		end
	end)
end
local function stopNudge() if nudgeLoop then nudgeLoop:Disconnect(); nudgeLoop=nil end end

-- loop principal: prepara LT e dispara prompt se possível
local function startLoop()
	if loop then loop:Disconnect() end
	loop = RS.Heartbeat:Connect(function()
		if not autoOn then return end
		prepLT()
		local pr = getPrompt()
		if pr then pcall(function() fireproximityprompt(pr,0) end) end
	end)
end

autoBtn.MouseButton1Click:Connect(function()
	autoOn = not autoOn
	autoBtn.Text = autoOn and "AutoLock ON" or "AutoLock OFF"
	autoBtn.BackgroundColor3 = autoOn and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
	if autoOn then startLoop(); startNudge() else if loop then loop:Disconnect() end; stopNudge() end
end)
