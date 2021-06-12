------------
-- FEATURES

-- Priority (1 = Off, 2 = 2nd Preference, 3 = 1st Preference)
-- Change Directory To Scan: - LMB: Select the instance in Explorer to set
--                           - RMB: Reset to Workspace
-- Empty Quarantine Folder: - LMB: Delete whole folder's contents
--                          - RMB: Return all content's to their old Parents, if the Parent no longer exists, then the Parent is Workspace
-- Scan: - Names, Keywords, Snippets
--       - If "require" detected as a keyword, it scans the assetid that would be required into the game
--       - Disables all scripts in quarantine so they do not run
--       - Before deleting, all sounds' "Play On Remove" is set to false so there are no surprise blasts of noise; I've had my fair share of these scares!

-- Have fun, and stay safe!
-- R0bl0x10501050, 2021
------------

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local StudioService = game:GetService("StudioService")

local toolbar = plugin:CreateToolbar("Eliminate")

local NewButton = toolbar:CreateButton("Open Panel", "Start scanning scripts for malicious content", "rbxassetid://6942427800")

local VERSION = "0.6.9"

local Widget

local selectedDirectory = game.Workspace
local quarantineFolder

local currentStudioUser = game:GetService("Players"):GetPlayerByUserId(StudioService:GetUserId())

local success, e = pcall(function()
	game.ServerStorage['Eliminate_ScriptQuarantine'].Name = "Eliminate_ScriptQuarantine"
end)

if success == false then
	quarantineFolder = Instance.new("Folder", game.ServerStorage)
	quarantineFolder.Name = "Eliminate_ScriptQuarantine"
else
	quarantineFolder = game.ServerStorage['Eliminate_ScriptQuarantine']
end

local strengths = {
	['keyword_strength'] = 3,
	['name_strength'] = 3,
	['snippet_strength'] = 3
}

local keyword_strength
local name_strength
local snippet_strength

function ref()
	keyword_strength = strengths['keyword_strength']
	name_strength = strengths['name_strength']
	snippet_strength = strengths['snippet_strength']
end

ref()

local keywords = {
	'require',
	'eriuqer', -- 'require'
	'getfenv',
	'vnefteg', -- 'getfenv'
	'setfenv',
	'vneftes', -- 'setfenv'
	'gnirts', -- 'string'
	'elbat', -- 'table'
	'esrever', -- 'reverse'
	"string.reverse('\101\114\105\117\113\101\114')",
	'string.reverse("\101\114\105\117\113\101\114")' -- ;) |  print(string.reverse("\101\114\105\117\113\101\114"))
}

local names = {
	'vaccine',
	'spread',
	'injection',
}

local snippets = {
	'official roblox',
	'rosync',
	'roloader',
	'ro-loader',
	'not a virus',
	'do not delete',
}

NewButton.Click:Connect(function()
	local widgetInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
		true,   -- Widget will be initially enabled
		false,  -- Don't override the previous enabled state
		295,    -- Default width of the floating window
		512,    -- Default height of the floating window
		295,    -- Minimum width of the floating window
		512     -- Minimum height of the floating window
	)

	if Widget == nil then
		Widget = plugin:CreateDockWidgetPluginGui("EliminateGUI", widgetInfo)
		Widget.Title = "Panel - Eliminate"
		Widget.Enabled = true

		--// UI SETUP \\--

		local Frame = Instance.new("Frame", Widget)
		Frame.Name = "Frame"
		Frame.BackgroundColor3 = Color3.fromRGB(71,71,71)
		Frame.BackgroundTransparency = 0
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.fromScale(0, 0)
		Frame.Size = UDim2.fromScale(1, 1)

		local Bottom = Instance.new("Frame", Frame)
		Bottom.Name = "Bottom"
		Bottom.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
		Bottom.BackgroundTransparency = 0
		Bottom.BorderSizePixel = 0
		Bottom.Position = UDim2.fromScale(0, 0.957)
		Bottom.Size = UDim2.fromScale(1, 0.042)
		Bottom.ZIndex = 2
		
		local HR1 = Instance.new("Frame", Frame)
		HR1.Name = "HR1"
		HR1.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
		HR1.BackgroundTransparency = 0
		HR1.BorderSizePixel = 0
		HR1.Position = UDim2.fromScale(0, 0.165)
		HR1.Size = UDim2.fromScale(1, 0.007)
		HR1.ZIndex = 2
		
		local HR2 = Instance.new("Frame", Frame)
		HR2.Name = "HR2"
		HR2.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
		HR2.BackgroundTransparency = 0
		HR2.BorderSizePixel = 0
		HR2.Position = UDim2.fromScale(0, 0.771)
		HR2.Size = UDim2.fromScale(1, 0.007)
		HR2.ZIndex = 2
		
		local HR3 = Instance.new("Frame", Frame)
		HR3.Name = "HR3"
		HR3.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
		HR3.BackgroundTransparency = 0
		HR3.BorderSizePixel = 0
		HR3.Position = UDim2.fromScale(0, 0.496)
		HR3.Size = UDim2.fromScale(1, 0.007)
		HR3.ZIndex = 2
		
		local Bottom_TextLabel_1 = Instance.new("TextLabel", Bottom)
		Bottom_TextLabel_1.Name = "Bottom_TextLabel_1"
		Bottom_TextLabel_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Bottom_TextLabel_1.BackgroundTransparency = 1
		Bottom_TextLabel_1.Position = UDim2.fromScale(0.025, 0)
		Bottom_TextLabel_1.Size = UDim2.fromScale(0.475, 1)
		Bottom_TextLabel_1.Font = Enum.Font.SourceSans
		Bottom_TextLabel_1.Text = "R0bl0x10501050"
		Bottom_TextLabel_1.TextColor3 = Color3.fromRGB(157, 157, 157)
		Bottom_TextLabel_1.TextScaled = true
		Bottom_TextLabel_1.ZIndex = 2
		
		local Bottom_TextLabel_2 = Instance.new("TextLabel", Bottom)
		Bottom_TextLabel_2.Name = "Bottom_TextLabel_2"
		Bottom_TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Bottom_TextLabel_2.BackgroundTransparency = 1
		Bottom_TextLabel_2.Position = UDim2.fromScale(0.5, 0)
		Bottom_TextLabel_2.Size = UDim2.fromScale(0.475, 1)
		Bottom_TextLabel_2.Font = Enum.Font.SourceSans
		Bottom_TextLabel_2.Text = "v"..VERSION
		Bottom_TextLabel_2.TextColor3 = Color3.fromRGB(157, 157, 157)
		Bottom_TextLabel_2.TextScaled = true
		Bottom_TextLabel_2.ZIndex = 2
		
		local Title = Instance.new("TextLabel", Frame)
		Title.Name = "Title"
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.fromScale(0, 0.022)
		Title.Size = UDim2.fromScale(1, 0.123)
		Title.ClipsDescendants = true
		Title.Font = Enum.Font.Gotham
		Title.RichText = true
		Title.Text = "<b>Eliminate</b>"
		Title.TextColor3 = Color3.fromRGB(245, 245, 245)
		Title.TextScaled = true
		Title.ZIndex = 1
		
		local Title_Glint = Instance.new("Frame", Title)
		Title_Glint.Name = "Glint"
		Title_Glint.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title_Glint.BackgroundTransparency = 0.75
		Title_Glint.BorderSizePixel = 0
		Title_Glint.Position = UDim2.fromScale(1, -1.75)
		Title_Glint.Rotation = -22.5
		Title_Glint.Size = UDim2.fromScale(0.051, 1.1)
		Title_Glint.ZIndex = 2
		
		local VKeywords = Instance.new("TextLabel", Frame)
		VKeywords.Name = "VKeywords"
		VKeywords.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		VKeywords.BackgroundTransparency = 1
		VKeywords.Position = UDim2.fromScale(0.025, 0.37)
		VKeywords.Size = UDim2.fromScale(0.544, 0.081)
		VKeywords.Font = Enum.Font.Gotham
		VKeywords.Text = "Keywords"
		VKeywords.TextColor3 = Color3.fromRGB(197, 197, 197)
		VKeywords.TextScaled = true
		VKeywords.TextXAlignment = Enum.TextXAlignment.Right
		VKeywords.ZIndex = 2
		
		local VNames = Instance.new("TextLabel", Frame)
		VNames.Name = "VNames"
		VNames.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		VNames.BackgroundTransparency = 1
		VNames.Position = UDim2.fromScale(0.024, 0.19)
		VNames.Size = UDim2.fromScale(0.544, 0.081)
		VNames.Font = Enum.Font.Gotham
		VNames.Text = "Names"
		VNames.TextColor3 = Color3.fromRGB(197, 197, 197)
		VNames.TextScaled = true
		VNames.TextXAlignment = Enum.TextXAlignment.Right
		VNames.ZIndex = 2
		
		local VSnippets = Instance.new("TextLabel", Frame)
		VSnippets.Name = "VSnippets"
		VSnippets.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		VSnippets.BackgroundTransparency = 1
		VSnippets.Position = UDim2.fromScale(0.024, 0.282)
		VSnippets.Size = UDim2.fromScale(0.544, 0.081)
		VSnippets.Font = Enum.Font.Gotham
		VSnippets.Text = "Snippets"
		VSnippets.TextColor3 = Color3.fromRGB(197, 197, 197)
		VSnippets.TextScaled = true
		VSnippets.TextXAlignment = Enum.TextXAlignment.Right
		VSnippets.ZIndex = 2
		
		local DirSelect = Instance.new("TextButton", Frame)
		DirSelect.Name = "DirSelect"
		DirSelect.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
		DirSelect.BackgroundTransparency = 0
		DirSelect.BorderSizePixel = 0
		DirSelect.Position = UDim2.fromScale(0.152, 0.535)
		DirSelect.Size = UDim2.fromScale(0.669, 0.092)
		DirSelect.Font = Enum.Font.SourceSans
		DirSelect.Text = ""
		DirSelect.TextColor3 = Color3.fromRGB(197, 197, 197)
		DirSelect.TextScaled = true
		DirSelect.ZIndex = 2
		
		local Empty = Instance.new("TextButton", Frame)
		Empty.Name = "Empty"
		Empty.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
		Empty.BackgroundTransparency = 0
		Empty.BorderSizePixel = 0
		Empty.Position = UDim2.fromScale(0.158, 0.65)
		Empty.Size = UDim2.fromScale(0.669, 0.092)
		Empty.Font = Enum.Font.SourceSans
		Empty.Text = ""
		Empty.TextColor3 = Color3.fromRGB(197, 197, 197)
		Empty.TextScaled = true
		Empty.ZIndex = 2
		
		local Scan = Instance.new("TextButton", Frame)
		Scan.Name = "Scan"
		Scan.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
		Scan.BackgroundTransparency = 0
		Scan.BorderSizePixel = 0
		Scan.Position = UDim2.fromScale(0.19, 0.811)
		Scan.Size = UDim2.fromScale(0.618, 0.119)
		Scan.Font = Enum.Font.Gotham
		Scan.Text = "Scan"
		Scan.TextColor3 = Color3.fromRGB(197, 197, 197)
		Scan.TextScaled = true
		Scan.ZIndex = 2
		
		local DirSelect_TextLabel = Instance.new("TextLabel", DirSelect)
		DirSelect_TextLabel.Name = "TextLabel"
		DirSelect_TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DirSelect_TextLabel.BackgroundTransparency = 1
		DirSelect_TextLabel.Position = UDim2.fromScale(0.093, 0.06)
		DirSelect_TextLabel.Size = UDim2.fromScale(0.813, 0.86)
		DirSelect_TextLabel.Font = Enum.Font.SourceSans
		DirSelect_TextLabel.Text = "Choose Directory"
		DirSelect_TextLabel.TextColor3 = Color3.fromRGB(197, 197, 197)
		DirSelect_TextLabel.TextScaled = true
		DirSelect_TextLabel.ZIndex = 2
		
		local Empty_TextLabel = Instance.new("TextLabel", Empty)
		Empty_TextLabel.Name = "TextLabel"
		Empty_TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Empty_TextLabel.BackgroundTransparency = 1
		Empty_TextLabel.Position = UDim2.fromScale(0.085, 0.06)
		Empty_TextLabel.Size = UDim2.fromScale(0.813, 0.86)
		Empty_TextLabel.Font = Enum.Font.SourceSans
		Empty_TextLabel.Text = "Empty Quarantine"
		Empty_TextLabel.TextColor3 = Color3.fromRGB(197, 197, 197)
		Empty_TextLabel.TextScaled = true
		Empty_TextLabel.ZIndex = 2
		
		local VKeywords_One = Instance.new("TextButton", VKeywords)
		VKeywords_One.Name = "VKeywords_One"
		VKeywords_One.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
		VKeywords_One.BackgroundTransparency = 0
		VKeywords_One.Position = UDim2.fromScale(1.085, 0.068)
		VKeywords_One.Size = UDim2.fromScale(0.185, 0.841)
		VKeywords_One.Font = Enum.Font.Gotham
		VKeywords_One.Text = "1"
		VKeywords_One.TextColor3 = Color3.fromRGB(255, 255, 255)
		VKeywords_One.TextScaled = true
		VKeywords_One:SetAttribute('Strength', 2)
		VKeywords_One.ZIndex = 2
		
		local VKeywords_Two = Instance.new("TextButton", VKeywords)
		VKeywords_Two.Name = "VKeywords_Two"
		VKeywords_Two.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
		VKeywords_Two.BackgroundTransparency = 0
		VKeywords_Two.Position = UDim2.fromScale(1.32, 0.068)
		VKeywords_Two.Size = UDim2.fromScale(0.185, 0.841)
		VKeywords_Two.Font = Enum.Font.Gotham
		VKeywords_Two.Text = "2"
		VKeywords_Two.TextColor3 = Color3.fromRGB(255, 255, 255)
		VKeywords_Two.TextScaled = true
		VKeywords_Two:SetAttribute('Strength', 2)
		VKeywords_Two.ZIndex = 2
		
		local VKeywords_Three = Instance.new("TextButton", VKeywords)
		VKeywords_Three.Name = "VKeywords_Three"
		VKeywords_Three.BackgroundColor3 = Color3.fromRGB(64, 161, 235)
		VKeywords_Three.BackgroundTransparency = 0
		VKeywords_Three.Position = UDim2.fromScale(1.56, 0.068)
		VKeywords_Three.Size = UDim2.fromScale(0.185, 0.841)
		VKeywords_Three.Font = Enum.Font.Gotham
		VKeywords_Three.Text = "3"
		VKeywords_Three.TextColor3 = Color3.fromRGB(255, 255, 255)
		VKeywords_Three.TextScaled = true
		VKeywords_Three:SetAttribute('Strength', 2)
		VKeywords_Three.ZIndex = 2
		
		local VNames_One = Instance.new("TextButton", VNames)
		VNames_One.Name = "VNames_One"
		VNames_One.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
		VNames_One.BackgroundTransparency = 0
		VNames_One.Position = UDim2.fromScale(1.085, 0.068)
		VNames_One.Size = UDim2.fromScale(0.185, 0.841)
		VNames_One.Font = Enum.Font.Gotham
		VNames_One.Text = "1"
		VNames_One.TextColor3 = Color3.fromRGB(255, 255, 255)
		VNames_One.TextScaled = true
		VNames_One:SetAttribute('Strength', 1)
		VNames_One.ZIndex = 2
		
		local VNames_Two = Instance.new("TextButton", VNames)
		VNames_Two.Name = "VNames_Two"
		VNames_Two.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
		VNames_Two.BackgroundTransparency = 0
		VNames_Two.Position = UDim2.fromScale(1.32, 0.068)
		VNames_Two.Size = UDim2.fromScale(0.185, 0.841)
		VNames_Two.Font = Enum.Font.Gotham
		VNames_Two.Text = "2"
		VNames_Two.TextColor3 = Color3.fromRGB(255, 255, 255)
		VNames_Two.TextScaled = true
		VNames_Two:SetAttribute('Strength', 2)
		VNames_Two.ZIndex = 2
		
		local VNames_Three = Instance.new("TextButton", VNames)
		VNames_Three.Name = "VNames_Three"
		VNames_Three.BackgroundColor3 = Color3.fromRGB(64, 161, 235)
		VNames_Three.BackgroundTransparency = 0
		VNames_Three.Position = UDim2.fromScale(1.56, 0.068)
		VNames_Three.Size = UDim2.fromScale(0.185, 0.841)
		VNames_Three.Font = Enum.Font.Gotham
		VNames_Three.Text = "3"
		VNames_Three.TextColor3 = Color3.fromRGB(255, 255, 255)
		VNames_Three.TextScaled = true
		VNames_Three:SetAttribute('Strength', 3)
		VNames_Three.ZIndex = 2
		
		local VSnippets_One = Instance.new("TextButton", VSnippets)
		VSnippets_One.Name = "VSnippets_One"
		VSnippets_One.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
		VSnippets_One.BackgroundTransparency = 0
		VSnippets_One.Position = UDim2.fromScale(1.085, 0.068)
		VSnippets_One.Size = UDim2.fromScale(0.185, 0.841)
		VSnippets_One.Font = Enum.Font.Gotham
		VSnippets_One.Text = "1"
		VSnippets_One.TextColor3 = Color3.fromRGB(255, 255, 255)
		VSnippets_One.TextScaled = true
		VSnippets_One:SetAttribute('Strength', 1)
		VSnippets_One.ZIndex = 2
		
		local VSnippets_Two = Instance.new("TextButton", VSnippets)
		VSnippets_Two.Name = "VSnippets_Two"
		VSnippets_Two.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
		VSnippets_Two.BackgroundTransparency = 0
		VSnippets_Two.Position = UDim2.fromScale(1.32, 0.068)
		VSnippets_Two.Size = UDim2.fromScale(0.185, 0.841)
		VSnippets_Two.Font = Enum.Font.Gotham
		VSnippets_Two.Text = "2"
		VSnippets_Two.TextColor3 = Color3.fromRGB(255, 255, 255)
		VSnippets_Two.TextScaled = true
		VSnippets_Two:SetAttribute('Strength', 2)
		VSnippets_Two.ZIndex = 2
		
		local VSnippets_Three = Instance.new("TextButton", VSnippets)
		VSnippets_Three.Name = "VSnippets_Three"
		VSnippets_Three.BackgroundColor3 = Color3.fromRGB(64, 161, 235)
		VSnippets_Three.BackgroundTransparency = 0
		VSnippets_Three.Position = UDim2.fromScale(1.56, 0.068)
		VSnippets_Three.Size = UDim2.fromScale(0.185, 0.841)
		VSnippets_Three.Font = Enum.Font.Gotham
		VSnippets_Three.Text = "3"
		VSnippets_Three.TextColor3 = Color3.fromRGB(255, 255, 255)
		VSnippets_Three.TextScaled = true
		VSnippets_Three:SetAttribute('Strength', 3)
		VSnippets_Three.ZIndex = 2
		
		local Title_UIGradient = Instance.new("UIGradient", Title)
		Title_UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(65, 171, 238)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(27, 140, 245))
		})
		Title_UIGradient.Offset = Vector2.new(-0.05, 0)
		Title_UIGradient.Rotation = 45

		local V_Items = {VKeywords_One, VKeywords_Two, VKeywords_Three, VNames_One, VNames_Two, VNames_Three, VSnippets_One, VSnippets_Two, VSnippets_Three}

		local V_UICorner = Instance.new("UICorner")
		V_UICorner.CornerRadius = UDim.new(0.125, 0)

		for _, v in ipairs(V_Items) do
			local clone = V_UICorner:Clone()
			clone.Parent = v
		end

		V_UICorner:Destroy()

		--// PLUGIN FUNCTIONALITY \\--

		local k_buttons = {VKeywords_One, VKeywords_Two, VKeywords_Three}
		local n_buttons = {VNames_One, VNames_Two, VNames_Three}
		local s_buttons = {VSnippets_One, VSnippets_Two, VSnippets_Three}

		for _, v in ipairs(k_buttons) do
			v.MouseButton1Click:Connect(function()
				-- local stren = v:GetAttribute("Strength")
				strengths['keyword_strength'] = tonumber(v.Text)
				ref()
				for _, vv in ipairs(k_buttons) do
					if v ~= vv then
						vv.BackgroundColor3 = Color3.fromRGB(92, 92, 92) -- original
					end
					v.BackgroundColor3 = Color3.fromRGB(64, 161, 235) -- new
				end
			end)
		end

		for _, v in ipairs(n_buttons) do
			v.MouseButton1Click:Connect(function()
				-- local stren = v:GetAttribute("Strength")
				strengths['name_strength'] = tonumber(v.Text)
				ref()
				for _, vv in ipairs(n_buttons) do
					if v ~= vv then
						vv.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
					end
					v.BackgroundColor3 = Color3.fromRGB(64, 161, 235)
				end
			end)
		end

		for _, v in ipairs(s_buttons) do
			v.MouseButton1Click:Connect(function()
				-- local stren = v:GetAttribute("Strength")
				strengths['snippet_strength'] = tonumber(v.Text)
				ref()
				for _, vv in ipairs(s_buttons) do
					if v ~= vv then
						vv.BackgroundColor3 = Color3.fromRGB(92, 92, 92)
					end
					v.BackgroundColor3 = Color3.fromRGB(64, 161, 235)
				end
			end)
		end

		DirSelect.MouseButton1Click:Connect(function()
			local connection
			connection = Selection.SelectionChanged:Connect(function()
				connection:Disconnect()
				selectedDirectory = Selection:Get()[1]
				DirSelect_TextLabel.Text = "Changed!"
				DirSelect.Active = false
				wait(0.66)
				DirSelect_TextLabel.Text = "Choose Directory"
				DirSelect.Active = true
			end)
		end)

		DirSelect.MouseButton2Click:Connect(function()
			selectedDirectory = game
		end)

		Empty.MouseButton1Click:Connect(function()
			local success, e = pcall(function()
				game.ServerStorage['Eliminate_ScriptQuarantine'].Name = "Eliminate_ScriptQuarantine"
			end)

			if success == false then
				quarantineFolder = Instance.new("Folder", game.ServerStorage)
				quarantineFolder.Name = "Eliminate_ScriptQuarantine"
				Empty_TextLabel.Text = "Nothing To Empty"
				Empty.Active = false
				wait(0.66)
				Empty_TextLabel.Text = "Empty Quarantine"
				Empty.Active = true
			elseif success == true then
				if game.ServerStorage['Eliminate_ScriptQuarantine']:GetChildren()[1] == nil then
					Empty_TextLabel.Text = "Nothing To Empty"
					Empty.Active = false
					wait(0.66)
					Empty_TextLabel.Text = "Empty Quarantine"
					Empty.Active = true
				else
					for _, v in pairs(game.ServerStorage['Eliminate_ScriptQuarantine']:GetChildren()) do
						if (v:GetAttribute("DND") == true) or (v:GetAttribute("dnd") == true) then continue end
						for _, v in pairs(v:GetDescendants()) do
							if v:IsA("Sound") then
								v.PlayOnRemove = false
							end
						end
						v:Destroy()
					end
					ChangeHistoryService:SetWaypoint("[ELIMINATE] - Emptied Quarantine!")
					Empty_TextLabel.Text = "Emptied!"
					Empty.Active = false
					wait(0.66)
					Empty_TextLabel.Text = "Empty Quarantine"
					Empty.Active = true
				end
			end
		end)

		Empty.MouseButton2Click:Connect(function()
			local success, e = pcall(function()
				game.ServerStorage['Eliminate_ScriptQuarantine'].Name = "Eliminate_ScriptQuarantine"
			end)

			if success == false then
				quarantineFolder = Instance.new("Folder", game.ServerStorage)
				quarantineFolder.Name = "Eliminate_ScriptQuarantine"
				Empty_TextLabel.Text = "Nothing To Return"
				Empty.Active = false
				wait(0.66)
				Empty_TextLabel.Text = "Empty Quarantine"
				Empty.Active = true
			elseif success == true then
				if game.ServerStorage['Eliminate_ScriptQuarantine']:GetChildren()[1] == nil then
					Empty_TextLabel.Text = "Nothing To Return"
					Empty.Active = false
					wait(0.66)
					Empty_TextLabel.Text = "Empty Quarantine"
					Empty.Active = true
				else
					for _, v in pairs(game.ServerStorage['Eliminate_ScriptQuarantine']:GetChildren()) do
						-- local origParentName = v:GetAttribute("Eliminate_OriginalParent_Name")
						local origParentDebugId = v:GetAttribute("Eliminate_OriginalParent_Id")
						local inst = game.Workspace

						for _, v2 in pairs(game:GetDescendants()) do
							local s, re = pcall(function()
								if v2:GetDebugId(10) == origParentDebugId then
									inst = v2
									return 0
								else
									return 1
								end
							end)

							if s then
								if re == 0 then
									break
								end
							else
								continue
							end
						end
						
						if not v:IsA("ModuleScript") then
							v.Disabled = false
						end
						
						v.Parent = inst
					end
					ChangeHistoryService:SetWaypoint("[ELIMINATE] - Returned Quarantine!")
					Empty_TextLabel.Text = "Returned!"
					Empty.Active = false
					wait(0.66)
					Empty_TextLabel.Text = "Empty Quarantine"
					Empty.Active = true
				end
			end
		end)

		Scan.MouseButton1Click:Connect(function()
			warn("ELIMINATE - Scanning")
			local function scanInst(inst)

				local function scanKeywords()
					if not inst:IsA("LuaSourceContainer") then return end
					local src = inst.Source
					for _, v in ipairs(keywords) do
						if string.find(string.lower(src), v) then
							if v == "require" then
								local tbl1 = string.split(string.lower(src), 'require(')

								local function getreqId(tabletouse)
									local requireId = ""
									if tabletouse[2] == nil then tabletouse[2] = "" end
									tabletouse = string.split(tabletouse[2], "")
									for _, v in ipairs(tabletouse) do
										if v == ")" or tonumber(v) == nil then
											break
										else
											requireId = requireId .. tostring(v)
										end
									end
									return requireId
								end

								local tbl1_id = getreqId(tbl1)
								-- print("TBLID: "..tbl1_id)
								if tonumber(tbl1_id) ~= nil then
									local productInfo = MarketplaceService:GetProductInfo(tonumber(tbl1_id), Enum.InfoType.Asset)
									local success, doesPlayerOwnAsset = pcall(MarketplaceService.PlayerOwnsAsset, MarketplaceService, currentStudioUser, tonumber(tbl1_id))
									local threatLevel = 0

									if productInfo.IsPublicDomain == false then
										threatLevel += 0.75
									else
										if productInfo.Sales < math.random(150, 350) then -- reduces chance of people trying to cheat the system
											threatLevel += 0.5
										end
									end

									if productInfo.AssetTypeId == 5 then
										threatLevel += 1
									elseif productInfo.AssetTypeId == 10 then
										threatLevel += 0.5
									end

									if doesPlayerOwnAsset == true then
										threatLevel -= 1
									end

									print(" - Threat Level: "..threatLevel)
									if threatLevel >= 1 then
										return true
									else
										return false
									end
								else
									return true
								end
							else
								return true
							end
						end
					end
					return false
				end

				local function scanNames()
					if not inst:IsA("LuaSourceContainer") then return end
					for _, v in ipairs(names) do
						if v == string.lower(inst.Name) then
							return true
						end
					end
					return false
				end

				local function scanSnippets()
					if not inst:IsA("LuaSourceContainer") then return end
					local src = inst.Source
					for _, v in ipairs(snippets) do
						if string.find(string.lower(src), v) then
							return true
						end
					end
					return false
				end

				local tbl_of_three = {}
				local tbl_of_two = {}

				local k_res
				local n_res
				local s_res

				for k, v in next, strengths do
					if v ~= 1 then
						if k == "keyword_strength" then
							k_res = scanKeywords()
							if v == 2 then
								table.insert(tbl_of_two, #tbl_of_two+1, k_res)
							elseif v == 3 then
								table.insert(tbl_of_three, #tbl_of_three+1, k_res)
							end
						elseif k == "name_strength" then
							n_res = scanNames()
							if v == 2 then
								table.insert(tbl_of_two, #tbl_of_two+1, n_res)
							elseif v == 3 then
								table.insert(tbl_of_three, #tbl_of_three+1, n_res)
							end
						elseif k == "snippet_strength" then
							s_res = scanSnippets()
							if v == 2 then
								table.insert(tbl_of_two, #tbl_of_two+1, s_res)
							elseif v == 3 then
								table.insert(tbl_of_three, #tbl_of_three+1, s_res)
							end
						end
					end
				end

				if tbl_of_three[1] == nil then
					for _, v in ipairs(tbl_of_two) do
						if v == true then
							return true
						end
					end

					return false
				else
					for _, v in ipairs(tbl_of_three) do
						if v == true then
							return true
						end
					end

					for _, v in ipairs(tbl_of_two) do
						if v == true then
							return true
						end
					end

					return false
				end
			end

			for _, v in pairs(selectedDirectory:GetDescendants()) do
				if (not v:IsA("LuaSourceContainer")) or (v:IsA("CoreScript")) then continue end
				print("Scanning "..v.Name)
				local result = scanInst(v)
				if result == true then
					print("Detected "..v.Name)
					-- v:SetAttribute('Eliminate_OriginalParent_Name', v.Parent.Name)
					v:SetAttribute('Eliminate_OriginalParent_Id', v.Parent:GetDebugId(10))
					v.Parent = quarantineFolder
					if not v:IsA("ModuleScript") then
						v.Disabled = true
					end
				end
			end
			ChangeHistoryService:SetWaypoint("[ELIMINATE] - Scanned!")
			
			warn("ELIMINATE - Scan Complete")
		end)
		
		coroutine.resume(coroutine.create(function()
			while true do
				wait(math.random(4, 7))
				TweenService:Create(Title_Glint, TweenInfo.new(1, Enum.EasingStyle.Linear), {Position = UDim2.fromScale(-0.1, -1.75)}):Play()
				wait(1)
				Title_Glint.Position = UDim2.fromScale(1, -1.75)
			end
		end))
		
		while true do
			local t1 = math.random(1.75,3)
			TweenService:Create(Title_UIGradient, TweenInfo.new(t1), {Offset = Vector2.new(0.3, 0)}):Play()
			wait(t1)
			local t2 = math.random(1.75,3)
			TweenService:Create(Title_UIGradient, TweenInfo.new(t2), {Offset = Vector2.new(-0.2, 0)}):Play() -- -0.05 originally
			wait(t2)
		end
	else
		if Widget.Enabled == true then
			Widget.Enabled = false
		else
			Widget.Enabled = true
		end
	end
end)
