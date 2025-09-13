local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local cameraDistance = 35

local keys = {
	W = false,
	A = false,
	S = false,
	D = false
}

RunService.RenderStepped:Connect(function()
	if not humanoidRootPart then return end
	local cameraPosition = humanoidRootPart.Position + Vector3.new(0, cameraDistance, 0)
	camera.CFrame = CFrame.lookAt(cameraPosition, humanoidRootPart.Position)
	local mouseLocation = mouse.Hit.p
	local lookAtPosition = Vector3.new(mouseLocation.x, humanoidRootPart.Position.y, mouseLocation.z)
	humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, lookAtPosition)
end)

RunService.Heartbeat:Connect(function()
	if humanoid and humanoid.Health > 0 then
		local moveDirection = Vector3.new(0, 0, 0)
		local rootPartCFrame = humanoidRootPart.CFrame
		if keys.W then
			moveDirection = moveDirection + rootPartCFrame.LookVector
		end
		if keys.S then
			moveDirection = moveDirection - rootPartCFrame.LookVector
		end
		if keys.D then
			moveDirection = moveDirection + rootPartCFrame.RightVector
		end
		if keys.A then
			moveDirection = moveDirection - rootPartCFrame.RightVector
		end
		if moveDirection.Magnitude > 0 then
			humanoid:Move(moveDirection.Unit)
		else
			humanoid:Move(Vector3.new(0, 0, 0))
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	if keys[input.KeyCode.Name] ~= nil then
		keys[input.KeyCode.Name] = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	if keys[input.KeyCode.Name] ~= nil then
		keys[input.KeyCode.Name] = false
	end
end)
