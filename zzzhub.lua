--!native
--!optimize 2





if not LPH_OBFUSCATED then
	LPH_JIT = function(...)
		return ...;
	end;
	LPH_JIT_MAX = function(...)
		return ...;
	end;
	LPH_NO_VIRTUALIZE = function(...)
		return ...;
	end;
	LPH_NO_UPVALUES = function(f)
		return (function(...)
			return f(...);
		end);
	end;
	LPH_ENCSTR = function(...)
		return ...;
	end;
	LPH_ENCNUM = function(...)
		return ...;
	end;
	LPH_ENCFUNC = function(func, key1, key2)
		if key1 ~= key2 then return print("LPH_ENCFUNC mismatch") end
		return func
	end
	LPH_CRASH = function()
		return print(debug.traceback());
	end;
	SWG_DiscordUser = "swim"
	SWG_DiscordID = 1337
	SWG_SecondsLeft = 9999
	SWG_Note = "scp,alpha"
	SWG_IsLifetime = true
end;


do
	local genv = (getgenv and getgenv()) or _G
	if genv.zqv_guard_job ~= tostring(game.JobId) then
		local Guarded = pcall(function()
			local Players = game:GetService("Players")
			repeat task.wait() until game:IsLoaded() and Players.LocalPlayer
			local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
			for _, PartName in ipairs({"HumanoidRootPart", "Humanoid", "Head"}) do
				Character:WaitForChild(PartName, 10)
			end
			local function Guard(RecursiveTable, BanIndexValue)
				setrawmetatable(RecursiveTable, {
					__newindex = function(Self, Index, Value)
						if type(Value) == "table" and Index == BanIndexValue then
							local Id1 = rawget(Value, 1)
							local Id2 = rawget(Value, 2)
							local Id4 = rawget(Value, 4)
							local Length = rawlen(Value)
							local Whitelisted = false
							if Id1 then
								if type(Id1) == "table" and Length == 2 and rawlen(Id1) == 1 and not rawget(Id1, "n") then
									local Inside = rawget(Id1, 1)
									local Outside = rawget(Value, 2)
									if Inside and Outside and tonumber(Inside) and tonumber(Outside) then
										Whitelisted = true
									end
								elseif type(Id1) == "number" and rawequal(Id1, 2) then
									if Length == 1 or (Length == 4 and rawequal(Id4, false)) then
										Whitelisted = true
									end
								elseif type(Id1) == "string" and type(Id2) == "number" and rawequal(Id2, 7) then
									Whitelisted = true
								end
							end
							if not Whitelisted then return end
						end
						return rawset(Self, Index, Value)
					end,
				})
				return true
			end
			local Deadline = os.clock() + 60
			repeat
				for _, Table in getgc(true) do
					if type(Table) ~= "table" or getrawmetatable(Table) then continue end
					local FoundIndex, FoundRecursive = false, false
					local IterOk = pcall(function()
						for _, Value in Table do
							if type(Value) == "number" and (rawequal(Value, 1) or rawequal(Value, 2) or rawequal(Value, 3) or rawequal(Value, 4)) then
								FoundIndex = Value
							end
							if rawequal(Value, Table) then
								FoundRecursive = Value
							end
						end
					end)
					if not IterOk then continue end
					if FoundIndex and FoundRecursive and rawequal(rawget(Table, FoundIndex), nil) then
						if Guard(FoundRecursive, FoundIndex) then
							genv.zqv_guard_job = tostring(game.JobId)
							return true
						end
					end
				end
				task.wait(1)
			until os.clock() > Deadline
			return false
		end)
		if not Guarded then return end
	end
end


if (getgenv and getgenv() or _G).Library then
	(getgenv and getgenv() or _G).Library.Unload()
end

local Folder = "moneyblox"
makefolder(Folder)

local ImagesFolder = string.format( "%s\\%s\\", Folder, "Images" )
makefolder(ImagesFolder)

local FontsFolder = string.format( "%s\\%s\\", Folder, "FontsFolder" )
makefolder(FontsFolder)

local HitsoundFolder = string.format( "%s\\%s\\", Folder, "Hitsounds" )
makefolder(HitsoundFolder)

local PicturesOnKillFolder = string.format( "%s\\%s\\", Folder, "PicturesOnKill" )

local CREATE_PRESET_IMAGES = isfolder(PicturesOnKillFolder)
makefolder(PicturesOnKillFolder)

local TempFolder = string.format( "%s\\%s\\", Folder, "TempFolder" )
makefolder(TempFolder)

local ConfigFolder = string.format( "%s\\%s\\", Folder, "Configs" )
makefolder(ConfigFolder)

local ThemeFolder = string.format( "%s\\%s\\", Folder, "Themes" )
makefolder(ThemeFolder)

local Fonts, Images = LPH_JIT(function()
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")

	local Fonts = {
		URL = "https://raw.githubusercontent.com/SWIMHUBISWIMMING/librehub/refs/heads/main/assets/",

		Names = {
			"Tahoma",
			"TahomaXP",
			"Comfortaa",
			"Verdana",
			"SmallestPixel7",
			"Proggy",
		},

		Data = {}
	}; do
		function Fonts.Load(font)
			if not RunService:IsStudio() then
				local TTF = string.format("%s%s.ttf", FontsFolder, font)
				local JSON = string.format("%s%s.json", FontsFolder, font)

				if not isfile(TTF) then
					local success, data = pcall(function()
						return game:HttpGet( string.format("%s%s.txt", Fonts.URL, font) )
					end)

					if success and data then
						writefile(TTF, base64_decode(data))
					else
						return
					end			
				end

				if not isfile(JSON) then
					local Font = {
						name = font,
						faces = {{
							name = "Regular",
							weight = 400,
							style = "normal",
							assetId = getcustomasset(TTF)
						}}
					}

					writefile(JSON, HttpService:JSONEncode(Font))
				end

				local temp_TTF = string.format("%s%s.ttf", TempFolder, font)
				local temp_JSON = string.format("%s%s.json", TempFolder, font)
				writefile(temp_TTF, readfile(TTF))
				writefile(temp_JSON, HttpService:JSONEncode({
					name = font,
					faces = {{
						name = "Regular",
						weight = 400,
						style = "normal",
						assetId = getcustomasset(temp_TTF)
					}}
				}))

				Fonts.Data[font] = Font.new(getcustomasset(temp_JSON), Enum.FontWeight.Regular)
			end
		end

		function Fonts.Get(font)
			return Fonts.Data[font]
		end

		for _,font in Fonts.Names do
			Fonts.Load(font)
		end
	end

	local Images = {
		URL = "https://raw.githubusercontent.com/SWIMHUBISWIMMING/librehub/refs/heads/main/assets/",

		Names = {
			"combat",
			"visuals",
			"misc",
			"config",
			"checkers",
			"saturation",
			"scrollbar",
			"lines"
		},

		Data = {}
	}; do
		function Images.Load(image)
			if not RunService:IsStudio() then
				local PNG = string.format("%s%s.png", ImagesFolder, image)

				if not isfile(PNG) then
					local success, data = pcall(function()
						return game:HttpGet( string.format( "%s%s.txt", Images.URL, image ) )
					end)

					if success and data then
						writefile(PNG, base64_decode(data))
					else
						return
					end
				end

				Images.Data[image] = getcustomasset(PNG)
			end
		end

		function Images.Get(image)
			return Images.Data[image]
		end

		for _,image in Images.Names do
			Images.Load(image)
		end
	end
	return Fonts, Images
end)();
local Library, Utility = LPH_JIT(function()
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
	local GuiService = game:GetService("GuiService")
	local TweenService = game:GetService("TweenService")
	local Stats = game:GetService("Stats")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera

	local Env = RunService:IsStudio() and _G or getgenv()
	local HiddenUI = RunService:IsStudio() and game.Players.LocalPlayer.PlayerGui  or game:GetService("CoreGui")
	local Converts = {
		[0] = "0",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
	}
	local KeyConverters = {
		escape = "ESC",
		backquote = "`",
		backspace = "BSP",
		slash = "/",
		leftquote = "'",
		rightquote = '"',
		leftbracket = "[",
		rightbracket = "]",
		semicolon = ";",
		comma = ",",
		period = ".",
		backslash = "\\",
		minus = "-",
		equals = "=",
		space = "SPC",
		[ "return" ] = "ENT",
		tab = "TAB",
		capslock = "CAP",
		leftshift = "LSH",
		mousebutton1 = "MB1",
		mousebutton2 = "MB2",
		mousebutton3 = "MB3",
		rightshift = "RSH",
		leftcontrol = "CTRL",
		leftalt = "ALT",
		leftsuper = "WIN",
		rightcontrol = "CTRL",
		rightalt = "ALT",
		rightsuper = "WIN",
		insert = "INS",
		delete = "DEL",
		home = "HME",
		pageup = "PUD",
		pagedown = "PDN",
		up = "UP",
		down = "DWN",
		left = "LFT",
		right = "RGT",
		numlock = "NUM",
		numpad0 = "N0",
		numpad1 = "N1",
		numpad2 = "N2",
		numpad3 = "N3",
		numpad4 = "N4",
		numpad5 = "N5",
		numpad6 = "N6",
		numpad7 = "N7",
		numpad8 = "N8",
		numpad9 = "N9",
	}
	local Library = {
		TweenSpeed = 0.4,
		TweenStyle = Enum.EasingStyle.Exponential,

		ThemeObjects = {},

		Font = Fonts.Get("Verdana"),
		FontSize = 16,

		Flags = {},
		ConfigFlags = {},

		Popups = {},

		CopiedColor = nil,

		Fps = 0,

		Images = {
			Lines = Images.Get("lines"),
			ScrollBar = Images.Get("scrollbar"),
			Saturation = Images.Get("saturation"),
			Checkers = Images.Get("checkers")
		},

		Theme = {
			outline = Color3.fromRGB(0, 0, 0),
			inline = Color3.fromRGB(40, 42, 44),
			["inline hovering"] = Color3.fromRGB(50, 52, 54),

			background = Color3.fromRGB(23, 25, 26),
			["dock background"] = Color3.fromRGB(19, 19, 19),

			accent = Color3.fromRGB(220, 100, 100),

			text = Color3.fromRGB(230, 230, 230),
			["dark text"] = Color3.fromRGB(86, 86, 86),
		},

	}; Library.__index = Library
	do
		Library.Utility = { Objects = {}, Connections = {} }; local Utility = Library.Utility do
			function Utility.New(object, props, theme)
				local Obj = Instance.new(object)

				if object == "TextButton" then
					Obj.AutoButtonColor = false
					Obj.Text = ""
					Obj.Style = Enum.ButtonStyle.Custom
				end

				if props then
					for prop, val in props do
						
						

						Obj[prop] = val
					end
				end

				if theme then
					Library.AddObjectTheme(Obj, theme)
				end

				table.insert(Utility.Objects, Obj)

				return Obj
			end

			function Utility.Signal(connection)
				table.insert(Utility.Connections, connection)

				return connection
			end

			function Utility.GetTransparency(obj)
				if obj:IsA("Frame") then
					return "BackgroundTransparency"
				elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
					return { "TextTransparency", "BackgroundTransparency" }
				elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
					return { "BackgroundTransparency", "ImageTransparency" }
				elseif obj:IsA("ScrollingFrame") then
					return { "BackgroundTransparency", "ScrollBarImageTransparency" }
				elseif obj:IsA("TextBox") then
					return { "TextTransparency", "BackgroundTransparency" }
				elseif obj:IsA("UIStroke") then
					return "Transparency"
				end

				return nil
			end

			function Utility.Round(number, float)
				local Mult = 1 / (float or 1)

				return math.floor(number * Mult + 0.5) / Mult
			end

			
			function Utility.PositionOver(position, object, addedy)
				addedy = addedy or 0

				local posX, posY = object.AbsolutePosition.X, (object.AbsolutePosition.Y - addedy)
				local size = object.AbsoluteSize
				local sizeX, sizeY = posX + size.X, posY + size.Y + addedy

				if position.X >= posX and position.Y >= posY and position.X <= sizeX and position.Y <= sizeY then
					return true
				end

				return false
			end

			function Utility.MouseOver(object, input)
				local posX, posY = object.AbsolutePosition.X, object.AbsolutePosition.Y
				local size = object.AbsoluteSize
				local sizeX, sizeY = posX + size.X, posY + size.Y
				local position = input.Position

				if position.X >= posX and position.Y >= posY and position.X <= sizeX and position.Y <= sizeY then
					return true
				end

				return false
			end

			function Utility.Lerp(a, b, c)
				c = c or 1 / 8

				local offset = math.abs(b - a)
				if (offset < c) then 
					return b 
				end 

				return a + (b - a) * c
			end

			function Utility.StringToEnum(enumstring)
				local EnumType, EnumValue = enumstring:match("Enum%.([^%.]+)%.(.+)")

				if EnumType and EnumValue then
					return Enum[EnumType][EnumValue]
				end

				return nil
			end

			function Utility.TextTriggers(text)
				local Triggers = {
					["{hour}"] = os.date("%H"),
					["{minute}"] = os.date("%M"),
					["{second}"] = os.date("%S"),
					["{ap}"] = os.date("%p"),
					["{month}"] = os.date("%b"),
					["{day}"] = os.date("%d"),
					["{year}"] = os.date("%Y"),
					["{fps}"] = Library.Fps,
					["{user}"] = SWG_DiscordUser or "admin",
					["{ping}"] = RunService:IsStudio() and 0 or math.floor(Stats.PerformanceStats.Ping:GetValue() or 0),
					["{time}"] = os.date("%H:%M:%S"),
					["{date}"] = os.date("%b. %d, %Y"),
					["{game}"] = Game and Game.Name or "Universal",
					["{n}"] = "\n"
				}

				for i,v in Triggers do
					text = string.gsub(text, i, v)
				end

				return text
			end

			function Utility.ToTitleCase(str)
				return str:gsub("(%a)([%w_']*)", function(first, rest)
					return first:upper() .. rest:lower()
				end)
			end

			function Utility.IsScrollable(frame)
				local CanvasSize = frame.AbsoluteCanvasSize
				local WindowSize = frame.AbsoluteWindowSize

				return CanvasSize.Y > WindowSize.Y
			end

			function Utility.IsAtBottom(frame)
				return frame.CanvasPosition.Y == frame.AbsoluteCanvasSize.Y - frame.AbsoluteWindowSize.Y
			end

			function Utility.RichText(text, color)
				return string.format('<font color="rgb(%s, %s, %s)">%s</font>', math.floor(color.r * 255), math.floor(color.g * 255), math.floor(color.b * 255), text)
			end

			function Utility.GetFiles(folder, extensions)
				if not isfolder(folder) then
					makefolder(folder)
				end

				local Files = isfolder(folder) and listfiles(folder) or {}
				local StoredFiles = {}
				local FileNames = {}

				for _,v in Files do
					for _,ext in extensions do
						if v:find(ext) then
							StoredFiles[#StoredFiles + 1] = v
							FileNames[#FileNames + 1] = v:gsub(folder, ""):gsub(ext, "")
						end
					end
				end

				return StoredFiles, FileNames
			end
		end

		Library.ScreenGui = Utility.New("ScreenGui", {
			Name = "\0",
			DisplayOrder = 1,
			Parent = HiddenUI,
			IgnoreGuiInset = true,
		})

		Library.ScreenGuiPopups = Utility.New("ScreenGui", {
			Name = "\0",
			DisplayOrder = -1,
			Parent = HiddenUI,
			IgnoreGuiInset = true,
		})

		local ItemsHolder = Utility.New("Frame", {
			Name = "leftholder",
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Position = UDim2.new(0, 0, 0, 60),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Parent = Library.ScreenGuiPopups,
		})

		Utility.New("UIListLayout", {
			Padding = UDim.new(0, 0),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ItemsHolder
		})

		Library.NotificationHolder = ItemsHolder

		function Library.Tween(obj, props, tweeninfo)
			if not obj then return nil end
			tweeninfo = tweeninfo or TweenInfo.new(Library.TweenSpeed, Library.TweenStyle)

			local ok, Tween = pcall(TweenService.Create, TweenService, obj, tweeninfo, props)

			if not ok or not Tween then
				pcall(function()
					for k, v in pairs(props) do
						obj[k] = v
					end
				end)
				return nil
			end

			local played = pcall(function() Tween:Play() end)
			if not played then
				pcall(function()
					for k, v in pairs(props) do
						obj[k] = v
					end
				end)
			end

			return Tween
		end

		function Library.Fade(obj, prop, vis)
			if not ((obj:IsA("UIStroke") and obj.Enabled or obj.Visible) and prop) then
				return
			end

			local OldTransparency = obj[prop]
			obj[prop] = vis and 1 or OldTransparency

			local Tween = Library.Tween(obj, { [prop] = vis and OldTransparency or 1 })

			Utility.Signal(Tween.Completed:Connect(function()
				if not vis then
					task.wait()
					obj[prop] = OldTransparency
				end
			end))

			return Tween
		end

		function Library.AddObjectTheme(object, props)
			local Theme = {
				Props = props,
				Object = object
			}

			for prop,v in props do
				if type(v) == "string" then
					object[prop] = Library.Theme[v]
				elseif type(v) == "function" then
					object[prop] = v()
				end
			end

			Library.ThemeObjects[object] = Theme
		end

		function Library.ChangeObjectTheme(object, props, tweened)
			local Theme = Library.ThemeObjects[object]

			if Theme then
				Theme.Props = props

				for prop,v in props do
					if type(v) == "string" then
						if tweened then
							Theme.Tween = Library.Tween(object, {
								[prop] = Library.Theme[v]
							})
						else
							object[prop] = Library.Theme[v]
						end
					elseif type(v) == "function" then
						object[prop] = v()
					end
				end
			end
		end

		function Library.UpdateTheme(theme, color)
			if not Library.Theme[theme] then
				return
			end

			Library.Theme[theme] = color

			for _,themeobj in Library.ThemeObjects do
				for prop,val in themeobj.Props do
					if val == theme then
						if themeobj.Tween then
							themeobj.Tween:Cancel()
						end

						themeobj.Object[prop] = color
					end
				end
			end
		end

		function Library.Config(cfg, default)
			local Table = { }

			for name, val in cfg do
				Table[name:lower()] = val
			end

			for name, val in default do
				if Table[name] == nil then
					Table[name] = val
				end
			end

			return Table
		end

		function Library.Resize(holder, box)
			local Start, StartSize, Resizing;
			local CurrentSize = holder.Size
			local OriginalSize = holder.Size

			Utility.Signal(box.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Resizing = true
					Start = input.Position
					StartSize = holder.Size
				end
			end))

			Utility.Signal(UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and Resizing then
					local ViewportSize = Camera.ViewportSize
					CurrentSize = UDim2.new(0, math.clamp(StartSize.X.Offset + (input.Position.X - Start.X), OriginalSize.X.Offset, ViewportSize.x), 0, math.clamp(StartSize.Y.Offset + (input.Position.Y - Start.Y), OriginalSize.Y.Offset, ViewportSize.y))
					holder.Size = CurrentSize
				end
			end))

			Utility.Signal(UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Resizing = false
				end
			end))
		end

		function Library.Dragging(holder, box, useinset)
			useinset = useinset == nil and true or useinset

			local Start, StartPos, Dragging;
			local CurrentPos;
			local Inset = GuiService:GetGuiInset( );

			Utility.Signal(box.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = true
					Start = input.Position
					StartPos = holder.AbsolutePosition
				end
			end))

			Utility.Signal(UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
					local MaxSize = holder.AbsoluteSize
					local ViewportSize = Camera.ViewportSize
					CurrentPos = UDim2.new(0, math.clamp(StartPos.X + (input.Position.X - Start.X), 0, ViewportSize.x - MaxSize.x), 0, math.clamp(StartPos.Y + (input.Position.Y - Start.Y + 36), 0, ViewportSize.y - MaxSize.y) + ( useinset and (Inset.Y / 2) or 0 ))
					holder.Position = CurrentPos
				end
			end))

			Utility.Signal(UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = false
				end
			end))
		end

		function Library.CreateList(cfg)
			cfg = cfg or {}; cfg = Library.Config(cfg, {
				namestart = "Key",
				nameend = "binds",
				size = 150,
			})

			local List = {
				Objects = { },

				Items = { },

				ShowMode = cfg.showmode,
			}

			local Objects = List.Objects; do
				Objects.accent = Utility.New("Frame", {
					Name = "accent",
					Position = UDim2.new(0, 20, 0.5, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, cfg.size, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Library.ScreenGuiPopups,
				}, { BackgroundColor3 = "accent" })

				Library.Dragging(Objects.accent, Objects.accent, true)

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.accent,
				}, { BackgroundColor3 = "background" })

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.background,
				})

				Objects.dock_background = Utility.New("Frame", {
					Name = "dock_background",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 23),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(19, 19, 19),
					Parent = Objects.background,
				}, { BackgroundColor3 = "dock background" })

				Objects.textholder = Utility.New("Frame", {
					Name = "textholder",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.dock_background,
				})

				Utility.New("UIPadding", {
					PaddingRight = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 6),
					Parent = Objects.textholder,
				})

				Utility.New("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.textholder,
				})

				Objects.text = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.namestart,
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "text",
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.textholder,
				}, { TextColor3 = "text" })

				Objects.text2 = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(220, 100, 100),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.nameend,
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "accent",
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.textholder,
				}, { TextColor3 = "accent" })

				Objects.content = Utility.New("Frame", {
					Name = "content",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Utility.New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.content,
					Padding = UDim.new(0, 0),
				})
			end

			function List.Add()
				local Item = {}

				local Holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					Visible = false,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.content,
				})

				Utility.New("UIPadding", {
					Parent = Holder,
					PaddingBottom = UDim.new(0, 8),
				})

				local Text = Utility.New("TextLabel", {
					FontFace = Fonts.Get("TahomaXP"),
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = "",
					Name = "text",
					TextStrokeTransparency = 0,
					Size = UDim2.new(1, -16, 0, 0),
					Position = UDim2.new(0, 8, 0, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Holder,
				}, { TextColor3 = "text" })

				Utility.New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Parent = Text,
				})

				local Accent = Utility.New("TextLabel", {
					FontFace = Fonts.Get("TahomaXP"),
					TextColor3 = Color3.fromRGB(220, 100, 100),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = "[]",
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "accent",
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Text,
				}, { TextColor3 = "accent" })

				function Item.Set(value, text, mode)
					Holder.Visible = value
					Text.Text = text
					Accent.Text = string.format("[%s]", mode)
				end

				table.insert(List.Items, Item)

				return Item
			end

			function List.Status(value)
				Objects.accent.Visible = value
			end

			return List
		end

		local KeybindList = Library.CreateList()
		Library.KeybindsList = KeybindList

		

		function Library.ColorpickerWindow(self)
			local Popup = {
				Visible = false,

				Tweening = false,

				Objects = { },

				Flag = nil,

				SetFunc = function() end,

				Alpha = 1,

				Color = Color3.new(1, 1, 1),

				HuePos = nil,
			}

			local Objects = Popup.Objects; do
				Objects.accent = Utility.New("Frame", {
					Size = UDim2.new(0, 200, 0, 200),
					Name = "accent",
					Position = UDim2.new(0, 0, 0, 0),
					Visible = false,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Library.ScreenGui,
				}, { BackgroundColor3 = "accent" })

				Objects.outline = Utility.New("Frame", {
					Name = "outline",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					Parent = Objects.accent,
				}, { BackgroundColor3 = "outline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.outline,
				}, { BackgroundColor3 = "background" })

				Utility.New("UIPadding", {
					PaddingTop = UDim.new(0, 6),
					PaddingBottom = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 6),
					Parent = Objects.background,
				})

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.background,
				})

				Objects.satholder = Utility.New("Frame", {
					Name = "satholder",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 186),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Parent = Objects.satholder,
				})

				Objects.saturation = Utility.New("TextButton", {
					Name = "saturation",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 186, 0, 186),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 0, 4),
					Parent = Objects.satholder,
				})

				Objects.saturationimage = Utility.New("ImageLabel", {
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Image = Library.Images.Saturation,
					BackgroundTransparency = 1,
					Name = "saturationimage",
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.saturation,
				})

				Objects.saturationpickeroutline = Utility.New("Frame", {
					Name = "saturationpickeroutline",
					Position = UDim2.new(0, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 3, 0, 3),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					Parent = Objects.saturationimage,
				})

				Objects.saturationpicker = Utility.New("Frame", {
					Name = "saturationpicker",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.saturationpickeroutline,
				})

				Objects.hue = Utility.New("TextButton", {
					Name = "hue",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 12, 0, 186),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.satholder,
				})

				Objects.huepickeroutline = Utility.New("Frame", {
					Name = "huepickeroutline",
					Position = UDim2.new(0, 0, 0.5, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 3),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					Parent = Objects.hue,
				})

				Objects.huepicker = Utility.New("Frame", {
					Name = "huepicker",
					Position = UDim2.new(0, 0, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.huepickeroutline,
				})

				Utility.New("UIGradient", {
					Rotation = -90,
					Color = ColorSequence.new{
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
						ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
						ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
						ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
						ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
						ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
					},
					Parent = Objects.hue,
				})

				Objects.alphaimage = Utility.New("ImageLabel", {
					ScaleType = Enum.ScaleType.Tile,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Name = "alphaimage",
					Image = Library.Images.Checkers,
					TileSize = UDim2.new(0, 6, 0, 6),
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(0, 186, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Objects.alpha = Utility.New("TextButton", {
					Name = "alpha",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.alphaimage,
				})

				Objects.UIGradient = Utility.New("UIGradient", {
					Transparency = NumberSequence.new{
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					},
					Parent = Objects.alpha,
				})

				Objects.alphapickeroutline = Utility.New("Frame", {
					Name = "alphapickeroutline",
					Position = UDim2.new(0.5, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 3, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					Parent = Objects.alpha,
				})

				Objects.alphapicker = Utility.New("Frame", {
					Name = "alphapicker",
					Position = UDim2.new(0, 1, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.alphapickeroutline,
				})

				Objects.buttonline = Utility.New("Frame", {
					Name = "buttonline",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 186, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Utility.New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = UDim.new(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.buttonline,
				})

				Library.Button({
					holder = Objects.buttonline,
				}, {Name = "Copy", Callback = function()
					Library.CopiedColor = Popup.Color
				end})

				Library.Button({
					holder = Objects.buttonline,
				}, {Name = "Paste", Callback = function()
					if not Library.CopiedColor then 
						Library.Notification("Please copy a color first.", 5)
						return 
					end

					Popup.Set(Library.CopiedColor, Popup.Alpha, false)
				end})
			end

			local Hue, Sat, Val;
			function Popup.Set(color, alpha, ignore)
				alpha = alpha or Popup.Alpha

				Hue, Sat, Val = color:ToHSV()

				Popup.Color = color
				Popup.Alpha = alpha

				if not ignore then
					Library.Tween(Objects.saturationpickeroutline, {
						Position = UDim2.new(
							Sat,
							0,
							1 - Val,
							0
						),
						AnchorPoint = Vector2.new(Sat, 1 - Val)
					})

					Popup.HuePos = Hue

					Library.Tween(Objects.huepickeroutline, {
						Position = UDim2.new(
							0,
							0,
							Hue,
							0
						),
						AnchorPoint = Vector2.new(0, Hue)
					})

					Library.Tween(Objects.alphapickeroutline, {
						Position = UDim2.new(
							1 - alpha,
							0,
							0,
							0
						),
						AnchorPoint = Vector2.new(1 - alpha, 0)
					})
				end

				Popup.SetFunc(color, alpha)

				Objects.huepicker.BackgroundColor3 = Color3.fromHSV(Popup.HuePos, 1, 1)
				Objects.saturationpicker.BackgroundColor3 = color
				Objects.alphapicker.BackgroundColor3 = color
				Objects.saturation.BackgroundColor3 = Color3.fromHSV(Popup.HuePos, 1, 1)
			end

			function Popup.Open(visibility, position)
				if Popup.Tweening or Popup.Visible == visibility then
					return
				end

				Popup.Tweening = true

				Popup.Visible = visibility

				if Popup.Visible then
					Objects.accent.Visible = true

					Objects.saturationpickeroutline.Position = UDim2.new(0, 0, 0, 0)
					Objects.alphapickeroutline.Position = UDim2.new(0, 0, 0, 0)
					Objects.huepickeroutline.Position = UDim2.new(0, 0, 0, 0)
				end

				local ParentObjects = Objects.accent:GetDescendants()

				table.insert(ParentObjects, Objects.accent)

				local Tween;
				for _, obj in ParentObjects do
					local Index = Utility.GetTransparency(obj)
					if not Index then continue end

					if type(Index) == "table" then
						for _, prop in Index do
							Tween = Library.Fade(obj, prop, Popup.Visible)
						end
					else
						Tween = Library.Fade(obj, Index, Popup.Visible)
					end
				end

				if not Popup.Visible then
					Library.Tween(Objects.saturationpickeroutline, {
						Position = UDim2.new(
							0,
							0,
							0,
							0
						),
						AnchorPoint = Vector2.new(0, 0)
					})

					Library.Tween(Objects.huepickeroutline, {
						Position = UDim2.new(
							0,
							0,
							0,
							0
						),
						AnchorPoint = Vector2.new(0, 0)
					})

					Library.Tween(Objects.alphapickeroutline, {
						Position = UDim2.new(
							0,
							0,
							0,
							0
						),
						AnchorPoint = Vector2.new(0, 0)
					})
				end

				if position then
					Objects.accent.Position = UDim2.new(0, position.X, 0, position.Y)
				end

				Utility.Signal(Tween.Completed:Connect(function()
					Objects.accent.Visible = Popup.Visible

					Popup.Tweening = false
				end))
			end

			function Popup.SlideSaturation(input)
				if Popup.Tweening or not Popup.Visible then return end

				local SizeX = math.clamp((input.Position.X - Objects.saturation.AbsolutePosition.X) / Objects.saturation.AbsoluteSize.X, 0, 1)
				local SizeY = 1 - math.clamp((input.Position.Y - Objects.saturation.AbsolutePosition.Y) / Objects.saturation.AbsoluteSize.Y, 0, 1)

				Objects.saturationpickeroutline.Position = UDim2.new(SizeX, 0, 1 - SizeY, 0)
				Objects.saturationpickeroutline.AnchorPoint = Vector2.new(SizeX, 1 - SizeY)

				Popup.Set(Color3.fromHSV(Popup.HuePos, SizeX, SizeY), Popup.Alpha, true)
			end

			Utility.Signal(Objects.saturation.MouseButton1Down:Connect(function()
				Popup.SlidingSaturation = true
				Popup.SlideSaturation({ Position = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset( ).Y) })
			end))

			function Popup.SlideHue(input)
				if Popup.Tweening or not Popup.Visible then return end

				local SizeY = math.clamp((input.Position.Y - Objects.hue.AbsolutePosition.Y) / Objects.hue.AbsoluteSize.Y, 0, 1)

				Objects.huepickeroutline.Position = UDim2.new(0, 0, SizeY, 0)
				Objects.huepickeroutline.AnchorPoint = Vector2.new(0, SizeY)
				Popup.HuePos = SizeY

				Popup.Set(Color3.fromHSV(SizeY, Sat, Val), Popup.Alpha, true)
			end

			Utility.Signal(Objects.hue.MouseButton1Down:Connect(function()
				Popup.SlidingHue = true
				Popup.SlideHue({ Position = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset( ).Y) })
			end))

			function Popup.SlideAlpha(input)
				if Popup.Tweening or not Popup.Visible then return end

				local SizeX = math.clamp((input.Position.X - Objects.alpha.AbsolutePosition.X) / Objects.alpha.AbsoluteSize.X, 0, 1)

				Objects.alphapickeroutline.Position = UDim2.new(SizeX, 0, 0, 0)
				Objects.alphapickeroutline.AnchorPoint = Vector2.new(SizeX, 0)
				Popup.Set(Popup.Color, 1 - SizeX, true)
			end

			Utility.Signal(Objects.alpha.MouseButton1Down:Connect(function()
				Popup.SlidingAlpha = true
				Popup.SlideAlpha({ Position = UserInputService:GetMouseLocation() })
			end))

			Utility.Signal(UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if Popup.SlidingSaturation then Popup.SlideSaturation({ Position = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset( ).Y) }) end
					if Popup.SlidingHue then Popup.SlideHue({ Position = UserInputService:GetMouseLocation() - Vector2.new(0, GuiService:GetGuiInset( ).Y) }) end
					if Popup.SlidingAlpha then Popup.SlideAlpha({ Position = UserInputService:GetMouseLocation() }) end
				end
			end))

			Utility.Signal(UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Popup.SlidingSaturation, Popup.SlidingHue, Popup.SlidingAlpha = false, false, false
				end
			end))

			return Popup
		end

		function Library.Window(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				size = UDim2.fromOffset(602, 502),
				open = true,
				namestart = "swim",
				nameend = "hub",
			})

			local Window = {
				Objects = { },

				Visible = cfg.open,

				Tweening = false,

				TabsTweening = false,

				Tabs = { },

				CurrentPage = nil,
			}

			local Objects = Window.Objects; do
				Objects.ScreenGui = Utility.New("ScreenGui", {
					Name = "\0",
					Parent = HiddenUI,
					IgnoreGuiInset = true,
				})

				Objects.accent = Utility.New("Frame", {
					Name = "accent",
					Position = UDim2.new(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = cfg.size,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Objects.ScreenGui,
				}, { BackgroundColor3 = "accent" })

				Objects.outline = Utility.New("Frame", {
					Name = "outline",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					Parent = Objects.accent,
				}, { BackgroundColor3 = "outline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.outline,
				}, { BackgroundColor3 = "background" })

				Objects.holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 44),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -14, 1, -58),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Objects.dock_background = Utility.New("Frame", {
					Name = "dock_background",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 30),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(19, 19, 19),
					Parent = Objects.background,
				}, { BackgroundColor3 = "dock background" })

				Library.Dragging(Objects.accent, Objects.dock_background, true)

				Objects.textholder = Utility.New("Frame", {
					Name = "textholder",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.dock_background,
				})

				Utility.New("UIPadding", {
					PaddingRight = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 6),
					Parent = Objects.textholder,
				})

				Utility.New("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.textholder,
				})

				Objects.text = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.namestart,
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "text",
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.textholder,
				}, { TextColor3 = "text" })

				Objects.text2 = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(220, 100, 100),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.nameend,
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "accent",
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.textholder,
				}, { TextColor3 = "accent" })

				Objects.shadow = Utility.New("Frame", {
					Name = "shadow",
					Position = UDim2.new(0, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 8),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(16, 16, 16),
					Parent = Objects.dock_background,
				})

				Utility.New("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new{
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					},
					Parent = Objects.shadow,
				})

				Objects.tabsholder = Utility.New("Frame", {
					BackgroundTransparency = 1,
					Name = "tabsholder",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 105, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.holder,
				})

				Utility.New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill,
					Parent = Objects.tabsholder,
				})

				Window.tabsholder = Objects.tabsholder

				Window.pageholder = Objects.holder
			end

			function Window.Open()
				if Window.Tweening then
					return
				end

				Window.Tweening = true

				Library.ColorpickerWindow.Open(false)

				Window.Visible = not Window.Visible

				if Window.Visible then
					Objects.accent.Visible = true
				end

				for _,popup in Library.Popups do
					popup.Open(false)
				end

				local Tween;
				for _,obj in Objects.ScreenGui:GetDescendants() do
					local Index = Utility.GetTransparency(obj)

					if not Index then continue end

					if type(Index) == "table" then
						for _,prop in Index do
							Tween = Library.Fade(obj, prop, Window.Visible)
						end
					else
						Tween = Library.Fade(obj, Index, Window.Visible)
					end
				end

				Utility.Signal(Tween.Completed:Connect(function()
					Window.Tweening = false
					Objects.accent.Visible = Window.Visible
				end))
			end

			return setmetatable(Window, Library)
		end

		function Library.Tab(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "Tab",
				image = "rbxassetid://12941020168",
				size = 45,
				side = false,
			})

			local Tab = {
				Selected = false,

				Objects = { },

				Name = cfg.name,

				Tabs = {}
			}

			local Objects = Tab.Objects; do
				Objects.holder = Utility.New("TextButton", {
					BackgroundTransparency = 1,
					Name = "holder",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 105, 0, 88),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.tabsholder,
				})

				Objects.icon = Utility.New("ImageLabel", {
					ImageColor3 = Color3.fromRGB(215, 215, 215),
					ScaleType = Enum.ScaleType.Fit,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Name = "icon",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = cfg.image,
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, -2, 0.5, 0),
					Size = UDim2.new(0, cfg.size, 0, cfg.size),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.holder,
				}, { ImageColor3 = "text" })

				Objects.accent = Utility.New("Frame", {
					Name = "accent",
					Position = UDim2.new(1, -2, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 2, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Objects.holder,
				}, { BackgroundColor3 = "accent" })

				Objects.pagetabsholder = Utility.New("Frame", {
					Name = "pagetabsholder",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 115, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -115, 0, 32),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.pageholder,
				})

				Utility.New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Parent = Objects.pagetabsholder,
				})

				Tab.pagetabsholder = Objects.pagetabsholder

				Objects.page = Utility.New("Frame", {
					Name = "page",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 115, 0, 42),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -115, 1, -42),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.pageholder,
				})

				Tab.pageholder = Objects.page
			end

			function Tab.Set(status, nested)
				Library.ChangeObjectTheme(Objects.accent, {
					BackgroundColor3 = status and "accent" or "inline",
				}, true)

				Library.ChangeObjectTheme(Objects.icon, {
					ImageColor3 = status and "text" or "dark text",
				}, true)

				Objects.pagetabsholder.Parent = status and self.pageholder or HiddenUI
				Objects.page.Parent = status and self.pageholder or HiddenUI

				Tab.Selected = status

				if not nested then
					for _,tab in self.Tabs do
						if tab == Tab then continue end

						tab.Set(false, true)
					end
				end
			end

			Utility.Signal(Objects.holder.MouseButton1Click:Connect(function()
				Tab.Set(true)
			end))

			table.insert(self.Tabs, Tab)

			return setmetatable(Tab, Library)
		end

		function Library.SubTab(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "Tab",
			})

			local Tab = {
				Selected = false,

				Objects = { },
			}

			local Objects = Tab.Objects; do
				Objects.holder = Utility.New("TextButton", {
					BackgroundTransparency = 1,
					Name = "holder",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.pagetabsholder,
				})

				Objects.accent = Utility.New("Frame", {
					Name = "accent",
					Position = UDim2.new(0, 0, 1, -2),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Objects.holder,
				}, { BackgroundColor3 = "accent" })

				Objects.text = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.name,
					TextStrokeTransparency = 0,
					Name = "text",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 18),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.holder,
				}, { TextColor3 = "text" })  

				Objects.page = Utility.New("Frame", {
					Name = "page",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.pageholder,
				})

				Utility.New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.page,
				})

				Objects.left = Utility.New("Frame", {
					BackgroundTransparency = 1,
					Name = "left",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.page,
				})

				Tab.left = Objects.left

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.left,
				})

				Objects.right = Utility.New("Frame", {
					BackgroundTransparency = 1,
					Name = "right",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.page,
				})

				Tab.right = Objects.right

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.right,
				})
			end

			function Tab.Set(status, nested)
				Library.ChangeObjectTheme(Objects.accent, {
					BackgroundColor3 = status and "accent" or "inline",
				}, true)

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = status and "text" or "dark text",
				}, true)

				Tab.Selected = status

				Objects.page.Parent = status and self.pageholder or HiddenUI

				if not nested then
					for _,tab in self.Tabs do
						if tab == Tab then continue end

						tab.Set(false, true)
					end
				end
			end

			Utility.Signal(Objects.holder.MouseButton1Click:Connect(function()
				Tab.Set(true)
			end))

			table.insert(self.Tabs, Tab)

			return setmetatable(Tab, Library)
		end

		function Library.Section(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "Section",
				tabs = false,
				side = "left",
				size = UDim2.new(1, 0, 1, 0)
			})

			local Side = cfg.side:lower() == "left" and self.left or self.right

			local Section = {
				Objects = {},

				Tabs = {},
			}

			local Objects = Section.Objects; do
				Objects.outline = Utility.New("Frame", {
					Name = "outline",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = cfg.size,
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					Parent = Side,
				}, { BackgroundColor3 = "outline" })

				Objects.accent = Utility.New("Frame", {
					Name = "accent",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Objects.outline,
				}, { BackgroundColor3 = "accent" })

				Objects.outline = Utility.New("Frame", {
					Name = "outline",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					Parent = Objects.accent,
				}, { BackgroundColor3 = "outline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.outline,
				}, { BackgroundColor3 = "background" })

				Objects.dock_background = Utility.New("Frame", {
					Name = "dock_background",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 28),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(19, 19, 19),
					Parent = Objects.background,
				}, { BackgroundColor3 = "dock background" })

				Objects.shadow = Utility.New("Frame", {
					Name = "shadow",
					Position = UDim2.new(0, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 8),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(16, 16, 16),
					Parent = Objects.dock_background,
				})

				Utility.New("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new{
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					},
					Parent = Objects.shadow,
				})

				Objects.text = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.name,
					TextStrokeTransparency = 0,
					Name = "text",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, -2),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.dock_background,
				}, { TextColor3 = "text" })

				Objects.accent = Utility.New("ScrollingFrame", {
					Active = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					ScrollBarImageColor3 = Color3.fromRGB(220, 100, 100),
					MidImage = Library.Images.ScrollBar,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					ScrollBarThickness = 1,
					Name = "accent",
					Size = UDim2.new(1, -12, 1, -28),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 12, 0, 28),
					BottomImage = Library.Images.ScrollBar,
					TopImage = Library.Images.ScrollBar,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				}, { ScrollBarImageColor3 = "accent" })

				Objects.content = Utility.New("Frame", {
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Name = "content",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 12),
					Size = UDim2.new(1, -12, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.accent,
				})

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 9),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.content,
				})

				Utility.New("UIPadding", {
					Parent = Objects.accent,
					PaddingBottom = UDim.new(0, 4),
				})

				Section.holder = Objects.content
			end

			function Section.State(value)
				Objects.outline.Visible = value
			end

			return setmetatable(Section, Library)
		end

		function Library.Toggle(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "New Toggle",
				value = false,
				callback = function() end,
				flag = nil,
			})



			if not cfg.flag then
				cfg.flag = cfg.name
			end

			local Toggle = {
				Objects = { },

				Tweening = false,

				Value = false,
			}

			local Objects = Toggle.Objects; do
				Objects.holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.holder,
				})

				Objects.line = Utility.New("TextButton", {
					Name = "line",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.holder,
				})

				Objects.inline = Utility.New("Frame", {
					Name = "inline",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 17, 0, 17),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Objects.line,
				}, { BackgroundColor3 = "inline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.inline,
				}, { BackgroundColor3 = "background" })

				Objects.accent = Utility.New("Frame", {
					Name = "accent",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Objects.background,
				}, { BackgroundColor3 = "accent" })

				Objects.text = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.name,
					TextStrokeTransparency = 0,
					Name = "text",
					Size = UDim2.new(1, -25, 1, -3),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.new(0, 25, 0, 0),
					BorderSizePixel = 0,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.line,
				}, { TextColor3 = "text" })

				Utility.New("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDim.new(0, 2),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.text,
				})

				Toggle.childholder = Objects.text
			end

			function Toggle.Set(value)
				Toggle.Value = value

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = value and "text" or "dark text"
				}, true)

				Library.Tween(Objects.accent, {
					BackgroundTransparency = value and 0 or 1
				})

				cfg.callback(value)

				Library.Flags[cfg.flag] = value
			end

			function Toggle.Enable()
				Toggle.Set(not Toggle.Value)
			end

			function Toggle.State(value)
				Objects.holder.Visible = value
			end

			Utility.Signal(Objects.line.MouseButton1Click:Connect(Toggle.Enable))

			Utility.Signal(Objects.line.MouseEnter:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline hovering"
				}, true)

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = "text"
				}, true)
			end))

			Utility.Signal(Objects.line.MouseLeave:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline"
				}, true)

				if not Toggle.Value then
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "dark text"
					}, true)
				end
			end))

			Toggle.Set(cfg.value)

			Library.ConfigFlags[cfg.flag] = Toggle.Set

			return setmetatable(Toggle, Library)
		end

		function Library.Slider(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "New Slider",
				value = 50,
				min = 0,
				max = 100,
				float = 1,
				suffix = "%s",
				callback = function() end,
				flag = nil,
			})

			if not cfg.flag then
				cfg.flag = cfg.name
			end

			local Slider = {
				Tweening = false,

				Objects = { },

				Value = cfg.value,

				Sliding = false,
			}

			local Objects = Slider.Objects; do
				Objects.holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.holder,
				})

				Objects.line = Utility.New("TextButton", {
					Name = "line",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.holder,
				})

				if cfg.name ~= "" then
					Objects.text = Utility.New("TextLabel", {
						FontFace = Library.Font,
						TextColor3 = Color3.fromRGB(86, 86, 86),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = cfg.name,
						TextStrokeTransparency = 0,
						Name = "text",
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = Library.FontSize,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						Parent = Objects.line,
					}, { TextColor3 = "dark text" })

					Slider.childholder = Objects.text

					Utility.New("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, 2),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Objects.text,
					})
				end

				Objects.value = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(86, 86, 86),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = "50%",
					TextStrokeTransparency = 0,
					Name = "text",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.text,
				}, { TextColor3 = "dark text" })

				Utility.New("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					FillDirection = Enum.FillDirection.Horizontal,
					Parent = Objects.value,
				})

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.line,
				})

				Objects.inline = Utility.New("Frame", {
					Name = "inline",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Objects.line,
				}, { BackgroundColor3 = "inline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.inline,
				}, { BackgroundColor3 = "background" })

				Objects.accent = Utility.New("Frame", {
					Name = "accent",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0.5, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Objects.background,
				}, { BackgroundColor3 = "accent" })

				Utility.New("UIPadding", {
					PaddingTop = UDim.new(0, 1),
					PaddingBottom = UDim.new(0, 1),
					PaddingRight = UDim.new(0, 1),
					PaddingLeft = UDim.new(0, 1),
					Parent = Objects.background,
				})  
			end

			function Slider.Set(value)
				Slider.Value = math.clamp(Utility.Round(value, cfg.float), cfg.min, cfg.max)

				if Objects.value then
					Objects.value.Text = string.format(cfg.suffix, tostring(Slider.Value))
				end

				Objects.accent.Size = UDim2.new((Slider.Value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)

				cfg.callback(Slider.Value)

				Library.Flags[cfg.flag] = Slider.Value
			end

			function Slider.State(value)
				Objects.holder.Visible = value
			end

			Utility.Signal(Objects.line.MouseButton1Down:Connect(function(input)
				local MouseLocation = UserInputService:GetMouseLocation()

				Slider.Sliding = true

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = "text"
				}, true)

				Library.ChangeObjectTheme(Objects.value, {
					TextColor3 = "text"
				}, true)

				Slider.Set( ((cfg.max - cfg.min) * ((MouseLocation.x - Objects.inline.AbsolutePosition.x) / Objects.inline.AbsoluteSize.x)) + cfg.min )
			end))

			Utility.Signal(Objects.line.MouseEnter:Connect(function(input)
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline hovering"
				}, true)

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = "text"
				}, true)

				Library.ChangeObjectTheme(Objects.value, {
					TextColor3 = "text"
				}, true)
			end))

			Utility.Signal(Objects.line.MouseLeave:Connect(function(input)
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline"
				}, true)

				if not Slider.Sliding then
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "dark text"
					}, true)

					Library.ChangeObjectTheme(Objects.value, {
						TextColor3 = "dark text"
					}, true)
				end
			end))

			Utility.Signal(UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and Slider.Sliding then
					Slider.Sliding = false

					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "dark text"
					}, true)

					Library.ChangeObjectTheme(Objects.value, {
						TextColor3 = "dark text"
					}, true)
				end
			end))

			Utility.Signal(UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and Slider.Sliding then
					Slider.Set( ((cfg.max - cfg.min) * ((input.Position.x - Objects.inline.AbsolutePosition.x) / Objects.inline.AbsoluteSize.x)) + cfg.min )
				end
			end))

			Slider.Set(cfg.value)

			Library.ConfigFlags[cfg.flag] = Slider.Set

			return setmetatable(Slider, Library)
		end

		function Library.Button(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "New Button",
				confirm = false,
				callback = function() end,
			})

			local Button = {
				Clicked = false,

				Time = 0,

				Objects = { },
			}

			local Objects = Button.Objects; do
				Objects.holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.holder,
				})

				Objects.line = Utility.New("TextButton", {
					Name = "line",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.holder,
				})

				Objects.inline = Utility.New("Frame", {
					Name = "inline",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 27),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Objects.line,
				}, { BackgroundColor3 = "inline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.inline,
				}, { BackgroundColor3 = "background" })

				Objects.text = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(86, 86, 86),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.name,
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "dark_text",
					Size = UDim2.new(1, 0, 1, -2),
					BorderSizePixel = 0,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.background,
				}, { TextColor3 = "dark text" })
			end

			function Button.StartConfirmation()
				Button.Clicked = true

				Button.Time = 5

				Objects.text.Text = string.format("Confirm %s? (%s)", cfg.name, Button.Time)

				Button.Coroutine = coroutine.create(function()
					for i = 1, 5 do
						task.wait(1)

						Button.Time -= 1

						if Button.Time > 0 then
							Objects.text.Text = string.format("Confirm %s? (%s)", cfg.name, Button.Time)
						else
							Objects.text.Text = cfg.name

							if Button.Clicked then
								Library.ChangeObjectTheme(Objects.text, {
									TextColor3 = "dark text"
								}, true)

								Button.Clicked = false
							end

							break
						end
					end
				end); coroutine.resume(Button.Coroutine)
			end

			function Button.Click()
				if cfg.confirm then
					if Button.Clicked then
						Library.ChangeObjectTheme(Objects.text, {
							TextColor3 = "dark text"
						}, true)

						coroutine.close(Button.Coroutine)

						Objects.text.Text = cfg.name

						Button.Clicked = false

						cfg.callback()
					else
						Library.ChangeObjectTheme(Objects.text, {
							TextColor3 = "text"
						}, true)

						Button.StartConfirmation()
					end
				else
					cfg.callback()	

					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "text"
					}, true)

					task.wait(Library.TweenSpeed)

					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "dark text"
					}, true)
				end
			end

			function Button.State(value)
				Objects.holder.Visible = value
			end

			Utility.Signal(Objects.line.MouseButton1Click:Connect(Button.Click))

			Utility.Signal(Objects.line.MouseEnter:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline hovering"
				}, true)

				if not Button.Clicked then
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "text"
					}, true)
				end
			end))

			Utility.Signal(Objects.line.MouseLeave:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline"
				}, true)

				if not Button.Clicked then
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "dark text"
					}, true)
				end
			end))

			return setmetatable(Button, Library)
		end

		function Library.Dropdown(self, cfg)
			cfg = cfg or {}; cfg = Library.Config(cfg, {
				name = "New Dropdown",
				values = { "value1", "value2", "value3", "value4", "value5", "value6" },
				value = "value1",
				multi = false,
				flag = nil,
				callback = function() end,
			})

			if not cfg.flag then
				cfg.flag = cfg.name
			end

			local Dropdown = {
				Tweening = false,

				Visible = false,

				Objects = { },

				Popup = { Objects = {} },

				Items = { },

				Value = nil,
			}

			local Objects = Dropdown.Objects; do
				Objects.holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.holder,
				})

				Objects.line = Utility.New("TextButton", {
					Name = "line",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.holder,
				})

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.line,
				})

				if cfg.name ~= "" then
					Objects.text = Utility.New("TextLabel", {
						FontFace = Library.Font,
						TextColor3 = Color3.fromRGB(86, 86, 86),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = cfg.name,
						TextStrokeTransparency = 0,
						Name = "text",
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = Library.FontSize,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						Parent = Objects.line,
					}, { TextColor3 = "dark text" })

					Dropdown.childholder = Objects.text

					Utility.New("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, 2),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Objects.text,
					})
				end

				Objects.inline = Utility.New("Frame", {
					Name = "inline",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 27),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Objects.line,
				}, { BackgroundColor3 = "inline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.inline,
				}, { BackgroundColor3 = "background" })

				Objects.value = Utility.New("TextLabel", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(86, 86, 86),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = "-",
					TextStrokeTransparency = 0,
					Name = "dark_text",
					Size = UDim2.new(1, -4, 1, -2),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Position = UDim2.new(0, 4, 0, 0),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.background,
				}, { TextColor3 = "dark text" })

				Objects.ImageLabel = Utility.New("ImageLabel", {
					ImageColor3 = Color3.fromRGB(86, 86, 86),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Image = Library.Images.Lines,
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -8, 0.5, 0),
					Size = UDim2.new(0, 10, 0, 7),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Objects.value.Size = UDim2.new(1, -(4 + Objects.ImageLabel.AbsoluteSize.X + 12), 1, -2)
			end

			local Popup = Dropdown.Popup; do
				local Objects = Popup.Objects

				Objects.inline = Utility.New("Frame", {
					Name = "inline",
					Position = UDim2.new(0, 618, 0, 464),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 199, 0, 60),
					BorderSizePixel = 0,
					Visible = false,
					ClipsDescendants = true,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Library.ScreenGui,
				}, { BackgroundColor3 = "inline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -1),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.inline,
				}, { BackgroundColor3 = "background" })

				Objects.accent = Utility.New("ScrollingFrame", {
					Active = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					ScrollBarImageColor3 = Color3.fromRGB(220, 100, 100),
					MidImage = Library.Images.ScrollBar,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					ScrollBarThickness = 1,
					Name = "accent",
					Size = UDim2.new(1, 1, 1, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, -1, 0, 0),
					BottomImage = Library.Images.ScrollBar,
					TopImage = Library.Images.ScrollBar,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				}, { ScrollBarImageColor3 = "accent" })

				Utility.New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.accent,
				})
			end

			
			Utility.Signal(Objects.inline:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				if Dropdown.Visible then
					local Size = Objects.inline.AbsoluteSize

					local Position = Objects.inline.AbsolutePosition

					Popup.Objects.inline.Position = UDim2.new(0, math.round(Position.X), 0, math.round(Position.Y) + math.round(Size.Y) + GuiService:GetGuiInset().Y - 2)
				end
			end))

			Utility.Signal(UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and Dropdown.Visible and not Utility.MouseOver(Popup.Objects.inline, input) then
					Dropdown.Open(false)
				end
			end))
			

			function Dropdown.Display()
				local Value = Dropdown.Value

				if cfg.multi then
					local CurrentText = {}

					if #Value > 0 then
						for _,item in Value do
							table.insert(CurrentText, item)

							Objects.value.Text = table.concat(CurrentText, ", ")
						end
					else
						Objects.value.Text = "-"
					end
				else
					Objects.value.Text = type(Value) == "string" and Value or "-"
				end
			end

			function Dropdown.Size()
				local Size = 0

				local Count = 0

				for _,v in Popup.Objects.accent:GetChildren() do
					Count += 1

					if v:IsA("TextButton") then
						Size += v.AbsoluteSize.y
					end

					if Count > 5 then
						break
					end
				end

				return Size
			end

			function Dropdown.Open(visbility)
				if Dropdown.Tweening or Dropdown.Visible == visbility then
					return
				end

				Dropdown.Tweening = true

				Dropdown.Visible = visbility

				if Dropdown.Visible then
					Popup.Objects.inline.Visible = true
				end

				local ParentObjects = Popup.Objects.inline:GetDescendants()

				table.insert(ParentObjects, Popup.Objects.inline)

				for _, obj in ParentObjects do
					local Index = Utility.GetTransparency(obj)
					if not Index then continue end

					if type(Index) == "table" then
						for _, prop in Index do
							Library.Fade(obj, prop, Dropdown.Visible)
						end
					else
						Library.Fade(obj, Index, Dropdown.Visible)
					end
				end

				local Size = Vector2.new(Objects.inline.AbsoluteSize.x, math.round(Objects.inline.AbsoluteSize.y))

				local Position = Vector2.new(math.round(Objects.inline.AbsolutePosition.x), math.round(Objects.inline.AbsolutePosition.y))

				Popup.Objects.inline.Position = UDim2.new(0, Position.X, 0, Position.Y + Size.Y + 1 + GuiService:GetGuiInset().Y - 2)

				Popup.Objects.inline.Size = Dropdown.Visible and UDim2.new(0, Size.X, 0, 10) or UDim2.new(0, Size.X + 1, 0, Dropdown.Size())

				local Tween = Library.Tween(Popup.Objects.inline, {
					Size = Dropdown.Visible and UDim2.new(0, Size.X, 0, Dropdown.Size()) or UDim2.new(0, Size.X + 1, 0, 10),
				})

				Utility.Signal(Tween.Completed:Connect(function()
					Popup.Objects.inline.Visible = Dropdown.Visible

					Dropdown.Tweening = false
				end))
			end

			function Dropdown.Set(value, ignore)
				if cfg.multi then
					if type(value) == "table" then 
						for _,item in Dropdown.Items do
							item.Select(false)
						end

						for _,item in value do
							for _,item2 in Dropdown.Items do
								if item2.Name == item then
									item2.Select(true)
								end
							end
						end

						Dropdown.Value = value

						Dropdown.Display()

						if not ignore then
							cfg.callback(Dropdown.Value)
						end

						Library.Flags[cfg.flag] = Dropdown.Value
					else
						local Index = table.find(Dropdown.Value, value)

						if Index then
							table.remove(Dropdown.Value, Index)

							for _,item in Dropdown.Items do
								if item.Name == value then
									item.Select(false)
								end
							end

							Dropdown.Display()

							if not ignore then
								cfg.callback(Dropdown.Value)
							end

							Library.Flags[cfg.flag] = Dropdown.Value
						else
							table.insert(Dropdown.Value, value)

							for _,item in Dropdown.Items do
								if item.Name == value then
									item.Select(true)
								end
							end

							Dropdown.Display()

							if not ignore then
								cfg.callback(Dropdown.Value)
							end

							Library.Flags[cfg.flag] = Dropdown.Value
						end
					end
				else
					for _,item in Dropdown.Items do
						item.Select(item.Name == value)
					end

					Dropdown.Value = value

					Dropdown.Display()

					if not ignore then
						cfg.callback(Dropdown.Value)
					end

					Library.Flags[cfg.flag] = Dropdown.Value
				end
			end

			function Dropdown.Add(name)
				local Item = {
					Objects = {},

					Name = name,

					Selected = false,
				}

				local Objects = Item.Objects; do
					Objects.holder = Utility.New("TextButton", {
						Name = "holder",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Parent = Popup.Objects.accent,
					})

					Objects.text = Utility.New("TextLabel", {
						FontFace = Library.Font,
						TextColor3 = Color3.fromRGB(230, 230, 230),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = name,
						TextStrokeTransparency = 0,
						Name = "text",
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 5, 0, 0),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = Library.FontSize,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						Parent = Objects.holder,
					}, { TextColor3 = "dark text" })

					Utility.New("UIPadding", {
						PaddingBottom = UDim.new(0, 4),
						PaddingTop = UDim.new(0, 4),
						PaddingRight = UDim.new(0, 6),
						Parent = Objects.text,
					})

					Objects.accent = Utility.New("Frame", {
						Name = "accent",
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Size = UDim2.new(0, 1, 1, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = Color3.fromRGB(220, 100, 100),
						Parent = Objects.holder,
					}, { BackgroundColor3 = "accent" })

					Utility.New("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Objects.accent,
					})
				end

				function Item.Select(value)
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = value and "text" or "dark text"
					}, true)

					Library.Tween(Objects.accent, {
						BackgroundTransparency = value and 0 or 1
					})

					Item.Selected = value
				end

				Utility.Signal(Objects.holder.MouseButton1Click:Connect(function()
					Dropdown.Set(name)
				end))

				Utility.Signal(Objects.holder.MouseEnter:Connect(function()
					if Item.Selected then return end

					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "text"
					}, true)
				end))

				Utility.Signal(Objects.holder.MouseLeave:Connect(function()
					if Item.Selected then return end

					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "dark text"
					}, true)
				end))

				table.insert(Dropdown.Items, Item)

				return Item
			end

			function Dropdown.Refresh(tbl)
				for _,item in Dropdown.Items do
					item.Objects.holder:Destroy()
				end

				Dropdown.Items = { }

				Dropdown.Value = cfg.multi and { } or nil

				for _,item in tbl do
					Dropdown.Add(item)
				end

				Dropdown.Display()
			end

			function Dropdown.State(value)
				Objects.holder.Visible = value
				Dropdown.Open(false)
			end

			for _,item in cfg.values do
				Dropdown.Add(item)
			end

			Dropdown.Set(cfg.value)

			Utility.Signal(Objects.line.MouseButton1Click:Connect(function()
				Dropdown.Open(not Dropdown.Visible)
			end))

			Utility.Signal(Objects.line.MouseEnter:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline hovering"
				}, true)

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = "text"
				}, true)

				Library.ChangeObjectTheme(Objects.value, {
					TextColor3 = "text"
				}, true)
			end))

			Utility.Signal(Objects.line.MouseLeave:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline"
				}, true)

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = "dark text"
				}, true)

				Library.ChangeObjectTheme(Objects.value, {
					TextColor3 = "dark text"
				}, true)
			end))

			Library.ConfigFlags[cfg.flag] = Dropdown.Set

			table.insert(Library.Popups, Dropdown)

			return setmetatable(Dropdown, Library)
		end

		function Library.List(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "New List",
				value = "value1",
				values = { "value1", "value2", "value3", "value4", "value5", "value6" },
				multi = false,
				size = 100,
				search = false,
				callback = function() end,
				flag = nil,
			})

			if not cfg.flag then
				cfg.flag = cfg.name
			end

			local List = {
				Objects = { },

				Items = { },

				Value = nil,
			}

			function List.SearchFunc(text)
				text = text:lower()

				for _,item in List.Items do
					local Holder = item.Objects.text

					Holder.Visible = text == "" and true or item.Name:lower():find(text)
				end
			end

			local Objects = List.Objects; do
				Objects.holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.holder,
				})

				Objects.line = Utility.New("Frame", {
					Name = "line",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.holder,
				})

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.line,
				})

				if cfg.name ~= "" then
					Objects.text = Utility.New("TextLabel", {
						FontFace = Library.Font,
						TextColor3 = Color3.fromRGB(86, 86, 86),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = cfg.name,
						TextStrokeTransparency = 0,
						Name = "text",
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = Library.FontSize,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						Parent = Objects.line,
					}, { TextColor3 = "dark text" })

					Utility.New("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, 2),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Objects.text,
					})

					List.childholder = Objects.text
				end

				Objects.box = Utility.New("Frame", {
					Name = "box",
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.line,
				})

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, -1),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.box,
				})

				if cfg.search then
					Library.Textbox({
						holder = Objects.box
					}, {
						name = "",
						callback = function(value)
							List.SearchFunc(value)
						end,
						flag = "list_search_" .. cfg.name,
					})
				end

				Objects.inline = Utility.New("Frame", {
					Name = "inline",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, cfg.size),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Objects.box,
				}, { BackgroundColor3 = "inline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.inline,
				}, { BackgroundColor3 = "background" })

				Objects.accent = Utility.New("ScrollingFrame", {
					Active = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					ScrollBarImageColor3 = Color3.fromRGB(220, 100, 100),
					MidImage = Library.Images.ScrollBar,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					ScrollBarThickness = 1,
					Name = "accent",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					BottomImage = Library.Images.ScrollBar,
					TopImage = Library.Images.ScrollBar,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				}, { ScrollBarImageColor3 = "accent" })

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.accent,
				})

				Utility.New("UIPadding", {
					PaddingTop = UDim.new(0, 4),
					PaddingBottom = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 4),
					PaddingLeft = UDim.new(0, 4),
					Parent = Objects.accent,
				})
			end

			function List.Set(value)
				if cfg.multi then
					if type(value) == "table" then 
						for _,item in List.Items do
							item.Select(false)
						end

						for _,item in value do
							for _,item2 in List.Items do
								if item2.Name == item then
									item2.Select(true)
								end
							end
						end

						List.Value = value

						cfg.callback(List.Value)

						Library.Flags[cfg.flag] = List.Value
					else
						local Index = table.find(List.Value, value)

						if Index then
							table.remove(List.Value, Index)

							for _,item in List.Items do
								if item.Name == value then
									item.Select(false)
								end
							end

							cfg.callback(List.Value)

							Library.Flags[cfg.flag] = List.Value
						else
							table.insert(List.Value, value)

							for _,item in List.Items do
								if item.Name == value then
									item.Select(true)
								end
							end

							cfg.callback(List.Value)

							Library.Flags[cfg.flag] = List.Value
						end
					end
				else
					for _,item in List.Items do
						item.Select(item.Name == value)
					end

					List.Value = value

					cfg.callback(List.Value)

					Library.Flags[cfg.flag] = List.Value
				end
			end

			function List.Add(name)
				local Item = {
					Objects = {},

					Name = name,

					Selected = false,
				}

				local Objs = Item.Objects; do
					Objs.text = Utility.New("TextButton", {
						FontFace = Library.Font,
						TextColor3 = Color3.fromRGB(86, 86, 86),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = name,
						TextStrokeTransparency = 0,
						Name = "text",
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = Library.FontSize,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						Parent = Objects.accent,
					}, { TextColor3 = "dark text" })
				end

				function Item.Select(value)
					Library.ChangeObjectTheme(Objs.text, {
						TextColor3 = value and "text" or "dark text"
					}, true)

					Item.Selected = value
				end

				Utility.Signal(Objs.text.MouseButton1Click:Connect(function()
					List.Set(name)
				end))

				Utility.Signal(Objs.text.MouseEnter:Connect(function()
					if Item.Selected then return end

					Library.ChangeObjectTheme(Objs.text, {
						TextColor3 = "text"
					}, true)
				end))

				Utility.Signal(Objs.text.MouseLeave:Connect(function()
					if Item.Selected then return end

					Library.ChangeObjectTheme(Objs.text, {
						TextColor3 = "dark text"
					}, true)
				end))

				table.insert(List.Items, Item)

				return Item
			end

			function List.Refresh(tbl)
				for _,item in List.Items do
					item.Objects.text:Destroy()
				end

				List.Items = { }

				List.Value = cfg.multi and { } or nil

				for _,item in tbl do
					List.Add(item)
				end
			end

			function List.State(value)
				Objects.holder.Visible = value
			end

			for _,item in cfg.values do
				List.Add(item)
			end

			Utility.Signal(Objects.inline.MouseEnter:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline hovering"
				}, true)
			end))

			Utility.Signal(Objects.inline.MouseLeave:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline"
				}, true)
			end))

			List.Set(cfg.value)

			Library.ConfigFlags[cfg.flag] = List.Set

			return setmetatable(List, Library)
		end

		function Library.Textbox(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "Textbox",
				value = "",
				callback = function() end,
				flag = nil,
			})

			if not cfg.flag then
				cfg.flag = cfg.name
			end

			local Textbox = {
				Objects = { },
			}

			local Objects = Textbox.Objects; do
				Objects.holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = self.holder,
				})

				Objects.line = Utility.New("Frame", {
					Name = "line",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.holder,
				})

				Utility.New("UIListLayout", {
					Padding = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.line,
				})

				if cfg.name ~= "" then
					Objects.text = Utility.New("TextLabel", {
						FontFace = Library.Font,
						TextColor3 = Color3.fromRGB(86, 86, 86),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = cfg.name,
						TextStrokeTransparency = 0,
						Name = "text",
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = Library.FontSize,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						Parent = Objects.line,
					}, { TextColor3 = "dark text" })

					Textbox.childholder = Objects.text

					Utility.New("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, 2),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Objects.text,
					})
				end

				Objects.inline = Utility.New("Frame", {
					Name = "inline",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 0, 27),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Objects.line,
				}, { BackgroundColor3 = "inline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.inline,
				}, { BackgroundColor3 = "background" })

				Objects.textbox = Utility.New("TextBox", {
					FontFace = Library.Font,
					Name = "text",
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.value,
					Size = UDim2.new(1, -5, 1, 0),
					TextStrokeTransparency = 0,
					Position = UDim2.new(0, 4, 0, 0),
					ClipsDescendants = true,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					ClearTextOnFocus = false,
					TextSize = Library.FontSize,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				}, { TextColor3 = "dark text" })			 
			end

			function Textbox.Set(value)
				Objects.textbox.Text = value

				Library.Flags[cfg.flag] = value
				cfg.callback(value)
			end

			function Textbox.State(value)
				Objects.holder.Visible = value
			end

			Utility.Signal(Objects.textbox.FocusLost:Connect(function()
				Textbox.Set(Objects.textbox.Text)

				Library.ChangeObjectTheme(Objects.textbox, {
					TextColor3 = "dark text"
				}, true)
			end))

			Utility.Signal(Objects.textbox.Focused:Connect(function()
				Library.ChangeObjectTheme(Objects.textbox, {
					TextColor3 = "text"
				}, true)
			end))

			Utility.Signal(Objects.line.MouseEnter:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline hovering"
				}, true)

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = "text"
				}, true)
			end))

			Utility.Signal(Objects.line.MouseLeave:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline"
				}, true)

				Library.ChangeObjectTheme(Objects.text, {
					TextColor3 = "dark text"
				}, true)
			end))

			Textbox.Set(cfg.value)

			Library.ConfigFlags[cfg.flag] = Textbox.Set

			return setmetatable(Textbox, Library)
		end

		function Library.Colorpicker(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "New Colorpicker",
				value = Color3.new(1, 1, 1),
				alpha = 0,
				usealpha = true,
				flag = nil,
				ignore = false,
				callback = function() end,
			})

			if not cfg.flag then
				cfg.flag = cfg.name
			end

			local Colorpicker = {
				Tweening = false,

				ZIndex = self.ZIndex,

				Objects = { },

				OriginalColor = cfg.value,

				Popup = { },

				Value = cfg.value,

				Alpha = cfg.alpha,
			}

			local ZIndex = Colorpicker.ZIndex

			local Objects = Colorpicker.Objects; do
				if not self.childholder then
					Objects.holder = Utility.New("Frame", {
						Name = "holder",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Parent = self.holder,
					})

					Objects.line = Utility.New("Frame", {
						Name = "line",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Parent = Objects.holder,
					})

					Objects.text = Utility.New("TextLabel", {
						FontFace = Library.Font,
						TextColor3 = Color3.fromRGB(86, 86, 86),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = cfg.name,
						TextStrokeTransparency = 0,
						Name = "text",
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = Library.FontSize,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						Parent = Objects.line,
					}, { TextColor3 = "dark text" })

					Utility.New("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, 2),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Objects.text,
					})

					Colorpicker.childholder = Objects.text
				end

				local Parent = self.childholder or Objects.text

				Objects.inline = Utility.New("TextButton", {
					Name = "inline",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 24, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Parent,
				}, { BackgroundColor3 = "inline" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.inline,
				}, { BackgroundColor3 = "background" })

				Objects.alphaimage = Utility.New("ImageLabel", {
					ScaleType = Enum.ScaleType.Tile,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Name = "alphaimage",
					Image = Library.Images.Checkers,
					TileSize = UDim2.new(0, 6, 0, 6),
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Objects.color = Utility.New("Frame", {
					BackgroundTransparency = 0,
					Name = "color",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(0, 151, 197),
					Parent = Objects.alphaimage,
				})
			end

			local ColorpickerWindow = Library.ColorpickerWindow

			function Colorpicker.Set(value, alpha)
				local Color, Alpha;

				if type(value) == "table" then
					Color = value.c
					Alpha = value.a
				else
					Color = value
					Alpha = alpha or Colorpicker.Alpha
				end

				Colorpicker.Value = Color

				if Alpha then
					Colorpicker.Alpha = Alpha

					Objects.color.BackgroundTransparency = Alpha
				end

				Objects.color.BackgroundColor3 = Color

				if not cfg.ignore then
					Library.Flags[cfg.flag] = {
						c = Color,
						a = Alpha
					}
				end

				cfg.callback({
					c = Color,
					a = Alpha
				})
			end

			function Colorpicker.State(state)
				if Objects.holder then Objects.holder.Visible = state end
				Objects.inline.Visible = state
				ColorpickerWindow.Open(false)
			end

			Utility.Signal(Objects.inline.MouseButton1Click:Connect(function(input)
				ColorpickerWindow.Flag = cfg.flag

				ColorpickerWindow.SetFunc = Colorpicker.Set

				ColorpickerWindow.OriginalColor = Colorpicker.OriginalColor

				ColorpickerWindow.Set(Colorpicker.Value, Colorpicker.Alpha)

				ColorpickerWindow.Open(not ColorpickerWindow.Visible, Objects.inline.AbsolutePosition + Vector2.new(0, Objects.inline.AbsoluteSize.Y + 2 + GuiService:GetGuiInset().Y) )

				ColorpickerWindow.Objects.alphaimage.Visible = cfg.usealpha
			end))

			Utility.Signal(UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and ColorpickerWindow.Visible and ColorpickerWindow.Flag == cfg.flag and not (Utility.MouseOver(ColorpickerWindow.Objects.accent, input) or Utility.MouseOver(Objects.inline, input)) then
					ColorpickerWindow.Open(false, Objects.inline.AbsolutePosition + Vector2.new(0, Objects.inline.AbsoluteSize.Y + 2 + GuiService:GetGuiInset().Y) )
				end
			end))

			Utility.Signal(Objects.inline.MouseEnter:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline hovering"
				}, true)
			end))

			Utility.Signal(Objects.inline.MouseLeave:Connect(function()
				Library.ChangeObjectTheme(Objects.inline, {
					BackgroundColor3 = "inline"
				}, true)
			end))

			if Objects.line then
				Utility.Signal(Objects.line.MouseEnter:Connect(function()
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "text"
					}, true)
				end))

				Utility.Signal(Objects.line.MouseLeave:Connect(function()
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "dark text"
					}, true)
				end))
			end

			Colorpicker.Set(cfg.value, cfg.alpha)

			if not cfg.ignore then
				Library.ConfigFlags[cfg.flag] = Colorpicker.Set
			end

			return setmetatable(Colorpicker, Library)
		end

		function Library.Keybind(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				name = "New Keybind",
				value = false,
				key = nil,
				mode = "Toggle",
				ignore = false,
				callback = function() end,
				flag = nil,
			})

			if not cfg.flag then
				cfg.flag = cfg.name
			end

			local Keybind = {
				Tweening = false,

				Visible = false,

				Objects = { },

				Popup = { Objects = {}, Items = {} },

				Key = nil,

				Mode = nil,

				Value = false,

				OnHold = nil,

				Listener = nil,
			}

			local Objects = Keybind.Objects; do
				if not self.childholder then
					Objects.holder = Utility.New("Frame", {
						Name = "holder",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Parent = self.holder,
					})

					Objects.line = Utility.New("Frame", {
						Name = "line",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						Parent = Objects.holder,
					})

					Objects.text = Utility.New("TextLabel", {
						FontFace = Library.Font,
						TextColor3 = Color3.fromRGB(86, 86, 86),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						Text = cfg.name,
						TextStrokeTransparency = 0,
						Name = "text",
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = Library.FontSize,
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						Parent = Objects.line,
					}, { TextColor3 = "dark text" })

					Utility.New("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = UDim.new(0, 2),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Objects.text,
					})

					Keybind.childholder = Objects.text
				end

				local Parent = self.childholder or Objects.text

				Objects.value = Utility.New("TextButton", {
					FontFace = Library.Font,
					TextColor3 = Color3.fromRGB(86, 86, 86),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = "[-]",
					TextStrokeTransparency = 0,
					Name = "text",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Parent,
				}, { TextColor3 = "dark text" })

				Utility.New("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					FillDirection = Enum.FillDirection.Horizontal,
					Parent = Objects.value,
				})
			end

			local Popup = Keybind.Popup; do
				Popup.Objects.inline = Utility.New("Frame", {
					Name = "inline",
					Position = UDim2.new(0, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Visible = false,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(40, 42, 44),
					Parent = Library.ScreenGui,
				}, { BackgroundColor3 = "inline" })

				Popup.Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Popup.Objects.inline,
				}, { BackgroundColor3 = "background" })

				Utility.New("UIPadding", {
					PaddingBottom = UDim.new(0, 1),
					Parent = Popup.Objects.background,
				})

				Utility.New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Popup.Objects.background,
				})

				function Popup.SetMode(mode)
					for _,item in Popup.Items do
						item.Select(item.Mode == mode)
					end
				end

				function Popup.Add(mode)
					local Item = {
						Objects = {},

						Mode = mode,

						Selected = false,
					}

					local Objs = Item.Objects; do
						Objs.holder = Utility.New("TextButton", {
							BackgroundTransparency = 1,
							Name = "holder",
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							Parent = Popup.Objects.background,
						})

						Objs.text = Utility.New("TextLabel", {
							FontFace = Library.Font,
							TextColor3 = Color3.fromRGB(230, 230, 230),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							Text = mode,
							TextStrokeTransparency = 0,
							Name = "text",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 4, 0, 0),
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.XY,
							TextSize = 12,
							BackgroundColor3 = Color3.fromRGB(25, 25, 25),
							Parent = Objs.holder,
						}, { TextColor3 = "dark text" })

						Utility.New("UIPadding", {
							PaddingBottom = UDim.new(0, 4),
							PaddingTop = UDim.new(0, 4),
							PaddingRight = UDim.new(0, 6),
							Parent = Objs.text,
						})

						Objs.accent = Utility.New("Frame", {
							Name = "accent",
							Position = UDim2.new(0, -1, 0, 0),
							BorderColor3 = Color3.fromRGB(0, 0, 0),
							Size = UDim2.new(0, 1, 1, 0),
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							BackgroundColor3 = Color3.fromRGB(220, 100, 100),
							Parent = Objs.holder,
						}, { BackgroundColor3 = "accent" })
					end

					function Item.Select(value)
						Library.ChangeObjectTheme(Objs.text, {
							TextColor3 = value and "text" or "dark text"
						})

						Library.Tween(Objs.accent, {
							BackgroundTransparency = value and 0 or 1
						})

						Item.Selected = value
					end

					Utility.Signal(Objs.holder.MouseButton1Click:Connect(function()
						Keybind.Set(mode)
					end))

					Utility.Signal(Objs.holder.MouseEnter:Connect(function()
						if Item.Selected then return end

						Library.ChangeObjectTheme(Objs.text, {
							TextColor3 = "text"
						})
					end))

					Utility.Signal(Objs.holder.MouseLeave:Connect(function()
						if Item.Selected then return end

						Library.ChangeObjectTheme(Objs.text, {
							TextColor3 = "dark text"
						})
					end))

					Popup.Items[mode] = Item

					return Item
				end

				Utility.Signal(Objects.value:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
					if Keybind.Visible then
						local Size = Objects.value.AbsoluteSize
						local Position = Objects.value.AbsolutePosition

						Popup.Objects.inline.Position = UDim2.new(0, math.round(Position.X), 0, math.round(Position.Y) + math.round(Size.Y) + 2 + GuiService:GetGuiInset().Y)
					end
				end))
			end; Keybind.ZIndex = ZIndex

			for _,mode in {"Always on", "Hold", "Toggle"} do
				Popup.Add(mode)
			end

			local Item;
			if not cfg.ignore then
				Item = Library.KeybindsList.Add()
			end

			function Keybind.Set(value, ignore)
				if type(value) == "table" then
					for _,v in value do 
						Keybind.Set(v, true)
					end

					return 
				end

				local Type = typeof(value)
				if Type == "EnumItem" then
					Keybind.Key = value 

					value = ( value == Enum.KeyCode.Unknown and "-" or value.Name )

					Objects.value.Text = string.format("[%s]", KeyConverters[ value:lower() ] or value)
				elseif Type == "boolean" then
					
					if Keybind.Mode == "Always on" and not value then
						value = true 
					end 

					Keybind.Value = value 
				elseif Type == "string" then
					
					if Keybind.OnHold and value ~= "Hold" then 
						Keybind.OnHold:Disconnect( )
						Keybind.OnHold = nil 
					end 

					Keybind.Mode = value 

					Popup.SetMode(value)

					if value == "Always on" then
						Keybind.Value = true 
					end	
				end 

				if Item then
					Item.Set(Keybind.Value, cfg.name, Keybind.Mode or "Toggle")
				end

				if not ignore then
					Library.Flags[cfg.flag] = Keybind.Value
					cfg.callback(Keybind.Value)
				end

				Library.Flags[string.format("%s_data", cfg.flag)] = {
					value = Keybind.Value,
					key = Keybind.Key,
					mode = Keybind.Mode
				}
			end

			function Keybind.Open(visibility)
				if Keybind.Tweening or Keybind.Visible == visibility then
					return
				end

				Keybind.Tweening = true

				Keybind.Visible = visibility

				if Keybind.Visible then
					Popup.Objects.inline.Visible = true
				end

				local ParentObjects = Popup.Objects.inline:GetDescendants()

				table.insert(ParentObjects, Popup.Objects.inline)

				local Tween;
				for _, obj in ParentObjects do
					local Index = Utility.GetTransparency(obj)
					if not Index then continue end

					if type(Index) == "table" then
						for _, prop in Index do
							Tween = Library.Fade(obj, prop, Keybind.Visible)
						end
					else
						Tween = Library.Fade(obj, Index, Keybind.Visible)
					end
				end

				Popup.Objects.inline.Position = UDim2.new(0, Objects.value.AbsolutePosition.X, 0, Objects.value.AbsolutePosition.Y + Objects.value.AbsoluteSize.Y + 2 + GuiService:GetGuiInset().Y)

				Utility.Signal(Tween.Completed:Connect(function()
					Keybind.Tweening = false

					Popup.Objects.inline.Visible = Keybind.Visible
				end))
			end

			function Keybind.State(state)
				if Objects.holder then Objects.holder.Visible = state end
				Objects.inline.Visible = state
				Keybind.Open(false)
			end

			Utility.Signal(Objects.value.MouseButton1Click:Connect(function(input)
				if Keybind.Listener then 
					Keybind.Listener:Disconnect( )
					Keybind.Listener = nil 

					return
				end

				Objects.value.Text = string.format("[%s]", "...")

				Library.ChangeObjectTheme(Objects.value, {
					TextColor3 = "text"
				}, true)

				task.wait( 1/50 )

				Keybind.Listener = Utility.Signal(UserInputService.InputBegan:Connect(function(input) 
					if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then 
						Keybind.Set( Enum.KeyCode.Unknown )

						Library.ChangeObjectTheme(Objects.value, {
							TextColor3 = "dark text"
						}, true)

						Keybind.Listener:Disconnect( )
						Keybind.Listener = nil

						return
					end

					if input.UserInputType == Enum.UserInputType.Keyboard or table.find({ Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3 }, input.UserInputType ) then 
						local Key = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType or Enum.KeyCode.Unknown

						Keybind.Set( Key )

						Library.ChangeObjectTheme(Objects.value, {
							TextColor3 = "dark text"
						}, true)

						Keybind.Listener:Disconnect( )
						Keybind.Listener = nil
					end
				end))
			end))

			Utility.Signal(Objects.value.MouseButton2Click:Connect(function(input)
				Keybind.Open(not Keybind.Visible)
			end))

			Utility.Signal(UserInputService.InputBegan:Connect(function(input) 
				if input.KeyCode == Keybind.Key or input.UserInputType == Keybind.Key then 
					local Value = Keybind.Mode ~= "Toggle" or not Keybind.Value
					Keybind.Set( Value )

					if Keybind.Mode == "Hold" then 
						if Keybind.OnHold then 
							Keybind.OnHold:Disconnect( ) 
						end

						Keybind.OnHold = Utility.Signal(UserInputService.InputEnded:Connect(function(input) 
							if input.KeyCode == Keybind.Key or input.UserInputType == Keybind.Key then 
								Keybind.Set( false )

								if Keybind.OnHold then 
									Keybind.OnHold:Disconnect( )
									Keybind.OnHold = nil
								end
							end
						end))
						
						
					end
				end
			end))

			Utility.Signal(UserInputService.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Visible and not Utility.MouseOver(Popup.Objects.inline, input) then
					Keybind.Open(false)
				end
			end))

			if Objects.line then
				Utility.Signal(Objects.line.MouseEnter:Connect(function(input)
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "text"
					}, true)
				end))

				Utility.Signal(Objects.line.MouseLeave:Connect(function(input)
					Library.ChangeObjectTheme(Objects.text, {
						TextColor3 = "dark text"
					}, true)
				end))
			end

			Keybind.Set({ cfg.key, cfg.mode, cfg.value }, true)
			
			Library.ConfigFlags[string.format("%s_data", cfg.flag)] = Keybind.Set

			table.insert(Library.Popups, Keybind)

			return setmetatable(Keybind, Library)
		end

		function Library.Watermark(self, cfg)
			cfg = cfg or { }; cfg = Library.Config(cfg, {
				text = "ping: {ping}ms | user: admin | {date}",
				titlestart = "swim",
				titleend = "bot",
				visible = true,
				rate = 1 / 20,
			})

			local Watermark = {
				Objects = {},

				Visible = cfg.visible,

				Rate = cfg.rate,

				Text = cfg.text,

				Clock = os.clock(),
			}

			local Objects = Watermark.Objects; do
				Objects.accent = Utility.New("Frame", {
					Size = UDim2.new(0, 250, 0, 0),
					Name = "accent",
					Position = UDim2.new(0, 5, 0, 60),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Library.NotificationHolder,
				}, { BackgroundColor3 = "accent" })

				Objects.background = Utility.New("Frame", {
					Name = "background",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Parent = Objects.accent,
				}, { BackgroundColor3 = "background" })

				Utility.New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.background,
				})

				Objects.topbar = Utility.New("Frame", {
					Name = "topbar",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Objects.textholder = Utility.New("Frame", {
					Name = "textholder",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.topbar,
				})

				Utility.New("UIPadding", {
					PaddingBottom = UDim.new(0, 2),
					PaddingTop = UDim.new(0, 4),
					Parent = Objects.topbar,
				})

				Utility.New("UIPadding", {
					PaddingRight = UDim.new(0, 6),
					PaddingLeft = UDim.new(0, 6),
					Parent = Objects.textholder,
				})

				Utility.New("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.textholder,
				})

				Objects.text = Utility.New("TextLabel", {
					FontFace = Fonts.Get("TahomaXP"),
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.titlestart,
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "text",
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.textholder,
				}, { TextColor3 = "text" })

				Objects.text2 = Utility.New("TextLabel", {
					FontFace = Fonts.Get("TahomaXP"),
					TextColor3 = Color3.fromRGB(220, 100, 100),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = cfg.titleend,
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "accent",
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.textholder,
				}, { TextColor3 = "accent" })

				Objects.bottombar = Utility.New("Frame", {
					Name = "bottombar",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Objects.background,
				})

				Utility.New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Objects.bottombar,
				})

				Utility.New("UIPadding", {
					PaddingTop = UDim.new(0, 4),
					PaddingBottom = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 14),
					PaddingLeft = UDim.new(0, 14),
					Parent = Objects.bottombar,
				})

				Objects.bottomtext = Utility.New("TextLabel", {
					FontFace = Fonts.Get("TahomaXP"),
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = "",
					TextStrokeTransparency = 0,
					BackgroundTransparency = 1,
					Name = "text",
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.bottombar,
				}, { TextColor3 = "text" })
			end

			function Watermark.SetText(text)
				Watermark.Text = text
			end

			function Watermark.SetVisible(visibility)
				Objects.accent.Visible = visibility
				Watermark.Visible = visibility
			end

			function Watermark.SetRate(rate)
				Watermark.Rate = rate
			end

			local LastTime = 0
			local Frames = 0
			function Watermark.Think(step)
				Frames += 1
				if tick() - LastTime >= 1 then
					Library.Fps = Frames
					LastTime = tick()
					Frames = 0
				end

				if Watermark.Visible and os.clock() - Watermark.Clock >= Watermark.Rate then
					Watermark.Clock = os.clock()

					Objects.bottomtext.Text = Utility.TextTriggers(Watermark.Text)
				end
			end

			Utility.Signal(RunService.RenderStepped:Connect(Watermark.Think))

			return Watermark
		end

		function Library.Notification(text, time)
			local Notification = {
				Objects = { },
			}

			local Objects = Notification.Objects; do
				Objects.holder = Utility.New("Frame", {
					Name = "holder",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 70),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					Parent = Library.NotificationHolder,
				})

				Objects.background = Utility.New("Frame", {
					BackgroundTransparency = 0.5,
					Name = "background",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3.fromRGB(23, 25, 26),
					Position = UDim2.new(-1, 0, 0, 0),
					Parent = Objects.holder,
				}, { BackgroundColor3 = "background" })

				Objects.text = Utility.New("TextLabel", {
					FontFace = Fonts.Get("TahomaXP"),
					TextColor3 = Color3.fromRGB(230, 230, 230),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Text = text,
					RichText = true,
					TextStrokeTransparency = 0,
					Name = "text",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 4, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = Color3.fromRGB(25, 25, 25),
					Parent = Objects.background,
				}, { TextColor3 = "text" })

				Utility.New("UIPadding", {
					PaddingBottom = UDim.new(0, 8),
					PaddingTop = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6),
					Parent = Objects.text,
				})

				Objects.accent = Utility.New("Frame", {
					Name = "accent",
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					Size = UDim2.new(0, 2, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(220, 100, 100),
					Parent = Objects.background,
				}, { BackgroundColor3 = "accent" })	
			end

			task.spawn(function()
				Library.Tween(Objects.background, {
					Position = UDim2.new(0, 0, 0, 0),
				})

				task.wait(time)

				Library.Tween(Objects.background, {
					Position = UDim2.new(-1, 0, 0, 0),
				})

				task.wait(Library.TweenSpeed)

				local Size = Objects.holder.AbsoluteSize

				Objects.holder.AutomaticSize = Enum.AutomaticSize.None

				Objects.background:Destroy()

				Objects.holder.Size = UDim2.new(0, Size.X, 0, Size.Y)

				Library.Tween(Objects.holder, {
					Size = UDim2.new(0, Size.X, 0, 0),
				})

				task.wait(Library.TweenSpeed)

				Notification.Objects.holder:Destroy()
			end)

			return Notification
		end

		Library.ColorpickerWindow = Library.ColorpickerWindow()

		

		function Library.GetConfig()
			local Config = { }

			for _, v in Library.ConfigFlags do
				local Value = Library.Flags[_]

				if type(Value) == "table" and Value["key"] then
					Config[_] = {value = Value.value, mode = Value.mode, key = tostring(Value.key)}
				elseif type(Value) == "table" and Value["a"] and Value["c"] then
					Config[_] = {a = Value.a, c = Value.c:ToHex()}
				else
					Config[_] = Value
				end
			end

			return HttpService:JSONEncode(Config)
		end

		function Library.GetTheme()
			local Theme = { }

			for theme,v in Library.Theme do
				if typeof(v) == "Color3" then
					Theme[theme] = v:ToHex()
				end
			end

			return HttpService:JSONEncode(Theme)
		end

		function Library.GetThemeData(data)
			data = HttpService:JSONDecode(data)

			local RawData = {  }
			for theme,v in data do
				RawData[theme] = Color3.fromHex(v)
			end

			return RawData
		end

		function Library.LoadConfig(data)
			data = HttpService:JSONDecode(data)

			for i,v in data do
				local Config = Library.ConfigFlags[i]

				if Config then
					if type(v) == "table" and v["a"] and v["c"] then
						Config({
							a = v.a,
							c = type(v.c) == "string" and Color3.fromHex(v.c) or v.c
						})
					elseif type(v) == "table" and v["key"] then
						Config({
							value = v.value,
							mode = v.mode,
							key = Utility.StringToEnum(v.key)
						}, true)
					else
						Config(v)
					end
				end
			end
		end

		function Library.Unload()
			for _,obj in Utility.Connections do
				obj:Disconnect()
			end

			for _,obj in Utility.Objects do
				obj:Destroy()
			end

			Env.Library = nil
		end
	end;
	Env.Library = Library
	Env.Utility = Library.Utility
	return Library, Library.Utility
end)();
local PicturesOnKill = LPH_JIT(function()
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
	local TweenService = game:GetService("TweenService")


	local PicturesOnKill = {
		URL = "https://raw.githubusercontent.com/SWIMHUBISWIMMING/librehub/refs/heads/main/assets/",

		DefaultImages = {
			"sigil.png",
			"cat.jpg"
		},

		Data = {}
	}
	do
		local current_image_index = 1
		local max_image_index = 1

		function PicturesOnKill.Reload()
			table.clear(PicturesOnKill.Data)
			current_image_index = 1
			max_image_index = 0

			local Pictures = Utility.GetFiles(PicturesOnKillFolder, { ".png", ".jpg", ".jpeg", ".webm" })

			for i, Picture in Pictures do
				max_image_index += 1
				PicturesOnKill.Data[max_image_index] = getcustomasset(Picture)
			end
		end

		function PicturesOnKill.GetNextPicture()
			if max_image_index < 1 then
				return
			end

			local Picture = PicturesOnKill.Data[current_image_index]
			
			current_image_index += 1

			if current_image_index > max_image_index then
				current_image_index = 1
			end

			return Picture
		end

		if not CREATE_PRESET_IMAGES then
			for _, image in PicturesOnKill.DefaultImages do
				local Picture = string.format("%s%s", PicturesOnKillFolder, image)
				if not isfile(Picture) then
					local success, data = pcall(function()
						return game:HttpGet( string.format( "%s%s", Images.URL, image ) )
					end)
					if success and data then
						writefile(Picture, base64_decode(data))
					end
				end
			end
		end

		PicturesOnKill.Reload()
	end
	
	return PicturesOnKill
end)();


local cloneref = cloneref or function(...) return ... end
local checkcaller = checkcaller
local getnamecallmethod = getnamecallmethod
local getcallingscript = getcallingscript
local tablecreate = table.create
local mathfloor = math.floor
local mathround = math.round
local mathrandom = math.random
local tostring = tostring
local unpack = table.unpack
local getupvalues = debug.getupvalues
local getupvalue = debug.getupvalue
local setupvalue = debug.setupvalue
local getconstants = debug.getconstants
local getconstant = debug.getconstant
local setconstant = debug.setconstant
local getstack = debug.getstack
local setstack = debug.setstack
local getinfo = debug.getinfo
local debugtraceback = debug.traceback
local rawget = rawget
local tick = tick

local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local GuiInset = game:GetService("GuiService"):GetGuiInset()
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local _CFramenew = CFrame.new
local _Vector2new = Vector2.new
local _Vector3new = Vector3.new
local _IsDescendantOf = game.IsDescendantOf
local _FindFirstChild = game.FindFirstChild
local _FindFirstChildOfClass = game.FindFirstChildOfClass
local _Raycast = workspace.Raycast
local _IsKeyDown = UserInputService.IsKeyDown
local _WorldToViewportPoint = Camera.WorldToViewportPoint
local _Vector3zeromin = Vector3.zero.Min
local _Vector2zeromin = Vector2.zero.Min
local _Vector3zeromax = Vector3.zero.Max
local _Vector2zeromax = Vector2.zero.Max
local _VectorToObjectSpace = CFrame.new().VectorToObjectSpace
local _IsA = game.IsA

local cheat = {
	Library = nil,
	Toggles = nil,
	Options = nil,
	ThemeManager = nil,
	SaveManager = nil,
	connections = {
		heartbeats = {},
		renderstepped = {}
	},
	drawings = {},
	hooks = {},
	hitsounds = {}
}

do
	local sounds = {}
	for name, id in {
        Bameware = "rbxassetid://3124331820",
        Bell = "rbxassetid://6534947240",
        Bubble = "rbxassetid://6534947588",
        Pick = "rbxassetid://1347140027",
        Pop = "rbxassetid://198598793",
        Rust = "rbxassetid://1255040462",
        Sans = "rbxassetid://3188795283",
        Fart = "rbxassetid://130833677",
        Big = "rbxassetid://5332005053",
        Vine = "rbxassetid://5332680810",
        Bruh = "rbxassetid://4578740568",
        Skeet = "rbxassetid://5633695679",
        Neverlose = "rbxassetid://6534948092",
        Fatality = "rbxassetid://6534947869",
        Bonk = "rbxassetid://5766898159",
        Minecraft = "rbxassetid://4018616850",
    } do
		local sound = Instance.new("Sound")
		sound.SoundId = id
		cheat.hitsounds[name] = sound
		table.insert(sounds, sound)
	end

	task.spawn(function()
		game:GetService("ContentProvider"):PreloadAsync(sounds, function(...)end)
	end)
end

local project_delta = {
	fps_object = nil,
	fps_hooks = {},
	fps_module = require(game:GetService("ReplicatedStorage").Modules.FPS),
	universaltable_module = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("UniversalTables")),
	reload_remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Reload"),
	equip_remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Equip"),
	updatetilt_remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpdateTilt"),
	inventorymove_remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("InventoryMove"),
	aizones = workspace:WaitForChild("AiZones"),
	droppeditems = workspace:WaitForChild("DroppedItems"),
	itemslist = game:GetService("ReplicatedStorage"):WaitForChild("ItemsList"),
	hitboxes_priority = {
		"FaceHitBox",
		"HeadTopHitBox",
		"Head",
		"UpperTorso",
		"LowerTorso",
		"LeftUpperArm",
		"LeftLowerArm",
		"LeftHand",
		"RightUpperArm",
		"RightLowerArm",
		"RightHand",
		"RightUpperLeg",
		"RightLowerLeg",
		"RightFoot",
		"LeftUpperLeg",
		"LeftLowerLeg",
		"LeftFoot"
	},
	hitboxes = {
		["FaceHitBox"] = true,
		["HeadTopHitBox"] = true,
		["Head"] = true,
		["UpperTorso"] = true,
		["LowerTorso"] = true,
		["LeftUpperArm"] = true,
		["LeftLowerArm"] = true,
		["LeftHand"] = true,
		["RightUpperArm"] = true,
		["RightLowerArm"] = true,
		["RightHand"] = true,
		["RightUpperLeg"] = true,
		["RightLowerLeg"] = true,
		["RightFoot"] = true,
		["LeftUpperLeg"] = true,
		["LeftLowerLeg"] = true,
		["LeftFoot"] = true
	}
}

for i, v in getgc(true) do
	if type(v) == "table" then
		if rawget(v, "springs") and rawget(v, "characterAnimations") then
			project_delta.fps_object = v
		end
		if type(rawget(v, "RangedWeaponDefault")) == "function" and type(rawget(v, "MeleeWeaponDefault")) == "function" then
			project_delta.fps_usetypes = v
		end
		if rawget(v, "loadByHand") and type(rawget(v, "magazine")) == "function" then
			
			project_delta.fps_reloadtypes = v
		end
	end
end


local desync_enabled, desync_enabled_key = false, false
local old_cframe, old_velocity, replicated_hrp_cframe, forced_cframe

do
	project_delta.fps_bindable = Instance.new("BindableEvent")

	project_delta.add_fps_hook = function(f)
		project_delta.fps_bindable.Event:Connect(f)
	end

	local fps_module = project_delta.fps_module
	local old = fps_module.new

	local ok_upd, upd = pcall(getupvalue, old, 5)
	project_delta.update_fps = ok_upd and upd
	local ok_rm, rm = pcall(getupvalue, project_delta.fps_usetypes.RangedWeaponDefault, 4)
	project_delta.remove_bullet = ok_rm and rm

	fps_module.new = function(player, character)
		local returns = old(player, character)
		task.delay(0.5, function()
			project_delta.fps_object = returns
			project_delta.fps_bindable:Fire()
		end)
		return returns
	end

	local player_folder = game:GetService("ReplicatedStorage"):WaitForChild("Players")
	local local_game_data = player_folder:WaitForChild(LocalPlayer.Name, 9e9)

	project_delta.local_game_data = local_game_data

	project_delta.FindFirstChildOfSlotType = LPH_NO_VIRTUALIZE(function(instance, slottype)
		for _, v in instance:GetChildren() do
			if v:GetAttribute("SlotType") == slottype then
				return v
			end
			if v:GetAttribute("Slot") == slottype then
				return v
			end
		end
	end)

	local findfirstchildofslottype = project_delta.FindFirstChildOfSlotType
	project_delta.get_visor_status = LPH_NO_VIRTUALIZE(function(inventory)
		local helmet_visor = findfirstchildofslottype(inventory, "ClothingHeadware")
		if not helmet_visor then
			return false
		end

		local attachments = _FindFirstChild(helmet_visor, "Attachments")
		if not attachments then
			return false
		end

		if not attachments:GetAttribute("Visor") then
			return false
		end

		helmet_visor = findfirstchildofslottype(attachments, "Visor")

		return (helmet_visor and helmet_visor:GetAttribute("Toggle") or false)
	end)

	project_delta.get_current_magazine = LPH_NO_VIRTUALIZE(function(gun)
		return findfirstchildofslottype(gun, "Magazine")
	end)
	

	project_delta.calculate_speed = LPH_NO_VIRTUALIZE(function(hrp)
		local external_mod = hrp:GetAttribute("MovementModifier")
		local movement_mod = project_delta.fps_object and project_delta.fps_object.movementModifier or 0
		local total_mod = external_mod + math.clamp(movement_mod, -10, 0)
		if local_game_data.Status.GameplayVariables.Buffs:GetAttribute("SerumRed") then
			total_mod = total_mod * 0.5 + 1
		end
		return 18.2 + total_mod
	end)

	project_delta.get_compatible_mag = LPH_NO_VIRTUALIZE(function(fps_object)
		local chosen_mag, loaded_mag_ammo = nil, 0
		local compatable_mags = fps_object.itemProperties.CompatibleMagazines
		for _, container in local_game_data.Inventory:GetChildren() do
			local inventory = _FindFirstChild(container, "Inventory")
			if not inventory then continue end
			for _, item in inventory:GetChildren() do
				if not compatable_mags:GetAttribute(item.Name) then continue end

				local loaded_ammo = item:GetAttribute("LoadedAmmo") or 0
				if chosen_mag and (loaded_ammo <= 0 or loaded_mag_ammo >= loaded_ammo) then continue end

				chosen_mag = item
				loaded_mag_ammo = loaded_ammo
			end
		end
		return chosen_mag, loaded_mag_ammo
	end)

	project_delta.get_compatible_ammo = LPH_NO_VIRTUALIZE(function(fps_object, arg_ammo)
		local needed_ammo = fps_object.MaxAmmo - fps_object.Bullets
		local chosen_ammo, ammo_amount = arg_ammo, arg_ammo and arg_ammo:GetAttribute("Amount") or 0

		if needed_ammo <= 0 or (chosen_ammo and ammo_amount) then
			return chosen_ammo, needed_ammo > ammo_amount and ammo_amount or needed_ammo
		end

		local item_properties = fps_object.itemProperties
		local compatible_ammo = item_properties.CompatibleAmmo
		local preferred_ammo = item_properties:GetAttribute("PreferredAmmo")
		for _, container in local_game_data.Inventory:GetChildren() do
			local inventory = _FindFirstChild(container, "Inventory")
			if not inventory then continue end

			for _, item in inventory:GetChildren() do
				if not compatible_ammo:GetAttribute(item.Name) then continue end
				if preferred_ammo and preferred_ammo ~= item.Name then continue end

				local loaded_ammo = (item:GetAttribute("Amount") or 0)
				if chosen_ammo and ammo_amount >= loaded_ammo then continue end

				ammo_amount = loaded_ammo
				chosen_ammo = item
			end
		end

		return chosen_ammo, needed_ammo > ammo_amount and ammo_amount or needed_ammo
	end)

	project_delta.get_mags_ammo = LPH_NO_VIRTUALIZE(function()
		local mags, ammo = {}, {}
		for _, container in local_game_data.Inventory:GetChildren() do
			local inventory = _FindFirstChild(container, "Inventory")
			if not inventory then continue end
			for _, item in inventory:GetChildren() do
				local item_prop = item.Value
				if not item_prop then continue end

				local item_type = item_prop:GetAttribute("ItemType")
				if item_type == "Magazine" then
					table.insert(mags, {item:GetAttribute("LoadedAmmo"), item:GetAttribute("AmmoType"), item:GetAttribute("Slot"), item, item_prop})
				elseif item_type == "Ammo" then
					table.insert(ammo, {item:GetAttribute("Amount"), item:GetAttribute("SlotType"), item:GetAttribute("Slot"), item, item_prop})
				end
			end
		end
		return mags, ammo
	end)
	
	local wallpen_params = RaycastParams.new()
	wallpen_params.FilterType = Enum.RaycastFilterType.Include
	wallpen_params.IgnoreWater = true
	wallpen_params.CollisionGroup = "WeaponRay"
	
	local material_ballistics = project_delta.universaltable_module.UniversalTable.MaterialBallistics
	local global_ignorelist_proj = project_delta.universaltable_module.UniversalTable.GlobalIgnoreListProjectile
	
	project_delta.calculate_penetration = LPH_NO_VIRTUALIZE(function(hit_part, hit_position, direction_vector, penetration_power)
		if hit_part:GetAttribute("NoPen") then return 0 end
		
		wallpen_params.FilterDescendantsInstances = { hit_part }

		local backwards_ray_origin = hit_position + direction_vector * 5
		local reverse_direction = -direction_vector
			
		local exit_ray_result = _Raycast(workspace, backwards_ray_origin, reverse_direction * 5, wallpen_params)

		if not exit_ray_result then return 0 end

		local exit_part = exit_ray_result.Instance
		local exit_position = exit_ray_result.Position
		local exit_normal = exit_ray_result.Normal
		local exit_material = exit_ray_result.Material
		local thickness = (exit_position - hit_position).Magnitude
		local material_properties = material_ballistics[exit_material.Name]

		if not material_properties then return 0 end

		local penetration_cost = hit_part:GetAttribute("PenResistance") and hit_part:GetAttribute("PenResistance") * thickness or material_properties.StrengthPerStud * thickness

		if not (penetration_cost and penetration_cost < penetration_power) then return 0 end

		return penetration_power - penetration_cost, hit_position + direction_vector * 0.03
	end)

	local weapon_params = RaycastParams.new()
	weapon_params.FilterType = Enum.RaycastFilterType.Exclude
	weapon_params.IgnoreWater = false
	weapon_params.CollisionGroup = "WeaponRay"

	local calculate_penetration, hitboxes = project_delta.calculate_penetration, project_delta.hitboxes

	project_delta.target_wall_penetration = LPH_NO_VIRTUALIZE(function(origin, target_character, target_part, target_position, bullet_stats)
		local character = LocalPlayer.Character
		weapon_params.FilterDescendantsInstances = { character, Camera, global_ignorelist_proj }

		local penetration_power, muzzle_velocity = bullet_stats:GetAttribute("ArmorPen"), bullet_stats:GetAttribute("MuzzleVelocity")
		
		local direction = (target_position - origin).Unit * muzzle_velocity * 1/120
		while true do
			local raycast_result = _Raycast(workspace, origin, direction, weapon_params)
			
			if not raycast_result then
				origin += direction 
				continue
			end

			local hit_instance, hit_pos = raycast_result.Instance, raycast_result.Position
			
			if _IsDescendantOf(hit_instance, target_character) and hitboxes[hit_instance.Name] then
				return true
			end

			local pen_rem, pen_pos = calculate_penetration(hit_instance, hit_pos, direction, penetration_power)
			penetration_power = pen_rem
			
			if penetration_power <= 0 then
				return false
			end

			origin = pen_pos
		end

		return false
	end)

	local noclip_params = RaycastParams.new()
	noclip_params.FilterType = Enum.RaycastFilterType.Exclude
	noclip_params.IgnoreWater = true
	noclip_params.CollisionGroup = "NoclipRay"

	project_delta.get_estimated_origin = LPH_NO_VIRTUALIZE(function(player, position)
		local character = player.Character
		local leaning_factor = character:GetAttribute("Leaning") or 0
		local hrp = character.HumanoidRootPart
		local hum = character.Humanoid;
		local estimated_camera = (position or (
			player == LocalPlayer and replicated_hrp_cframe and replicated_hrp_cframe.Position or hrp.Position)
		) + (hum:GetAttribute("Crouch") and _Vector3new(0, 0.6, 0, 0) or _Vector3new(0, 1.6, 0, 0))
		if leaning_factor == 0 then
			return estimated_camera
		else
			noclip_params.FilterDescendantsInstances = { workspace.NoCollision, workspace.DroppedItems, Camera }
			local new_camera = _CFramenew(estimated_camera - hrp.CFrame.RightVector * leaning_factor * 1.18).Position
			local result = _Raycast(workspace, estimated_camera, (new_camera - estimated_camera), noclip_params)
			if result then
				return (estimated_camera + result.Position) * 0.8
			else
				return new_camera
			end
		end
	end)
end

cheat.utility = {} do
	cheat.utility.new_heartbeat = function(func)
		local obj = {}
		cheat.connections.heartbeats[func] = func
		function obj:Disconnect()
			if func then
				cheat.connections.heartbeats[func] = nil
				func = nil
			end
		end
		return obj
	end
	cheat.utility.new_renderstepped = function(func)
		local obj = {}
		cheat.connections.renderstepped[func] = func
		function obj:Disconnect()
			if func then
				cheat.connections.renderstepped[func] = nil
				func = nil
			end
		end
		return obj
	end
	cheat.utility.new_drawing = function(drawobj, args)
		local obj = Drawing.new(drawobj)
		for i, v in (args) do
			obj[i] = v
		end
		cheat.drawings[obj] = obj
		return obj
	end
	cheat.utility.new_hook = function(f, newf, usecclosure) LPH_NO_VIRTUALIZE(function()
			if usecclosure then
				local old; old = hookfunction(f, newcclosure(function(...)
					return newf(old, ...)
				end))
				cheat.hooks[f] = old
				return old
			else
				local old; old = hookfunction(f, function(...)
					return newf(old, ...)
				end)
				cheat.hooks[f] = old
				return old
			end
		end)() end
	local connection; connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(delta)
		for _, func in (cheat.connections.heartbeats) do
			func(delta)
		end
	end))
	local connection1; connection1 = RunService.PreRender:Connect(LPH_NO_VIRTUALIZE(function(delta)
		for _, func in (cheat.connections.renderstepped) do
			func(delta)
		end
	end))
	cheat.utility.unload = function()
		connection:Disconnect()
		connection1:Disconnect()
		for key, _ in (cheat.connections.heartbeats) do
			cheat.connections.heartbeats[key] = nil
		end
		for key, _ in (cheat.connections.renderstepped) do
			cheat.connections.heartbeats[key] = nil
		end
		for _, drawing in (cheat.drawings) do
			drawing:Remove()
			cheat.drawings[_] = nil
		end
		for hooked, original in (cheat.hooks) do
			if type(original) == "function" then
				hookfunction(hooked, clonefunction(original))
			else
				hookmetamethod(original["instance"], original["metamethod"], clonefunction(original["func"]))
			end
		end
	end
end

local notification_queue = {}

do
    cheat.utility.new_renderstepped(function()
        for i, v in notification_queue do
			Library.Notification(v.text, v.duration)
            notification_queue[i] = nil
        end
    end)
	cheat.utility.new_heartbeat(function()
		Camera = workspace.CurrentCamera
	end)
end


if setfflag then
	setfflag("AdornShadingAPI", "true") 
end

LPH_NO_VIRTUALIZE(function()
	local esp_table = {}
	local workspace = game:GetService("Workspace")
	local rservice = game:GetService("RunService")
	local plrs = game:GetService("Players")
	local lplr = plrs.LocalPlayer
	local container = Instance.new("Folder", game:GetService("CoreGui").RobloxGui)
	local gui_inset = game:GetService("GuiService"):GetGuiInset()

	esp_table = {
		__loaded = false,
		registered_flags = {},
		settings = {
			enemy = {
				main_settings = {
					fade_time = 1,
					team_check = false,
					dead_check = false,
					dist_check = false,
					npc_check = false,
					max_distance = 1000,
					skeleton_rate = 1e-10,
					gradient_spin = false,
					gradient_speed = 360, 
					holder_spin = false,
					holder_speed = 360 
				},

				enabled = false,

				box = false,
				box_outline = false,
				health_bar = false,
				name = false,
				health_text = false,
				distance = false,
				weapon = false,
				skeleton = false,
				flags = false,

				box_color = { Color3.new(1, 1, 1), Color3.new(1, 1, 1), 0 },
				box_outline_color = { Color3.new(1, 1, 1), 0, Color3.new(1, 1, 1), 0 },
				health_bar_color = { Color3.new(1, 1, 1), Color3.new(1, 1, 1) },
				name_color = { Color3.new(1, 1, 1), 0 },
				health_text_color = { Color3.new(1, 1, 1), 0 },
				dist_color = { Color3.new(1, 1, 1), 0 },
				weapon_color = { Color3.new(1, 1, 1), 0 },
				skeleton_color = { Color3.new(1, 1, 1), 0 },
				flags_color = { Color3.new(1, 1, 1), 0 },

				box_rotation = 0,

				chams = false,
				chams_color = { Color3.new(1, 1, 1), 0 },
				chams_glow_factor = 2
			},
			item = {
				main_settings = {
					dist_check = true,
					max_distance = 100
				},

				enabled = true,

				distance = true,
				amount = true,
				durability = true,
				durability_bar = true,

				text_color = { Color3.new(1, 1, 1), 0.7 }
			},
			corpse = {
				main_settings = {
					dist_check = false,
					max_distance = 100
				},

				enabled = true,

				distance = true,

				text_color = { Color3.new(1, 1, 1), 0.5 }
			}
		}
	}

	local loaded_plrs = {}

	local VERTICES = {
		_Vector3new(-1, -1, -1),
		_Vector3new(-1, 1, -1),
		_Vector3new(-1, 1, 1),
		_Vector3new(-1, -1, 1),
		_Vector3new(1, -1, -1),
		_Vector3new(1, 1, -1),
		_Vector3new(1, 1, 1),
		_Vector3new(1, -1, 1)
	}
	local skeleton_order = {
		["LeftFoot"] = "LeftLowerLeg",
		["LeftLowerLeg"] = "LeftUpperLeg",
		["LeftUpperLeg"] = "LowerTorso",

		["RightFoot"] = "RightLowerLeg",
		["RightLowerLeg"] = "RightUpperLeg",
		["RightUpperLeg"] = "LowerTorso",

		["LeftHand"] = "LeftLowerArm",
		["LeftLowerArm"] = "LeftUpperArm",
		["LeftUpperArm"] = "UpperTorso",

		["RightHand"] = "RightLowerArm",
		["RightLowerArm"] = "RightUpperArm",
		["RightUpperArm"] = "UpperTorso",

		["LowerTorso"] = "UpperTorso",
		["UpperTorso"] = "Head"
	}
	local esp = {}
	esp.create_obj = function(new, args, tbl)
		local obj = Instance.new(new)
		for i, v in args do
			obj[i] = v
		end
		if tbl then table.insert(tbl, obj) end
		return obj
	end

	local valid_parts = {
		["LeftFoot"] = true,
		["LeftLowerLeg"] = true,
		["LeftUpperLeg"] = true,
		["RightFoot"] = true,
		["RightLowerLeg"] = true,
		["RightUpperLeg"] = true,
		["LeftHand"] = true,
		["LeftLowerArm"] = true,
		["LeftUpperArm"] = true,
		["RightHand"] = true,
		["RightLowerArm"] = true,
		["RightUpperArm"] = true,
		["LowerTorso"] = true,
		["UpperTorso"] = true,
		["Head"] = true
	}

	local function isBodyPart(name)
		return valid_parts[name]
	end

	local function getBoundingBox(parts)
		local min, max
		for i, part in parts do
			local cframe, size = part[1], part[2]

			min = _Vector3zeromin(min or cframe.Position, (cframe - size * 0.5).Position)
			max = _Vector3zeromax(max or cframe.Position, (cframe + size * 0.5).Position)
		end

		local center = (min + max) * 0.5
		local front = _Vector3new(center.X, center.Y, max.Z)
		return _CFramenew(center, front), max - min
	end

	local function worldToScreen(world)
		local screen, inBounds = Camera:WorldToScreenPoint(world)
		return _Vector2new(screen.X, screen.Y) + gui_inset, inBounds, screen.Z
	end

	local function calculateCorners(cframe, size)
		local corners = table.create(#VERTICES)
		for i, vertice in VERTICES do
			corners[i] = worldToScreen((cframe + size * 0.5 * vertice).Position)
		end

		return _Vector2zeromin(Camera.ViewportSize, unpack(corners)), _Vector2zeromax(Vector2.zero, unpack(corners))
	end

	local create_esp, create_object_esp, create_corpse_esp, create_item_esp, destroy_esp;

	create_esp = function(plr_instance)
		local is_npc = plr_instance.ClassName == "Model"
		local is_helicopter = is_npc and plr_instance.Name == "MI24V"

		loaded_plrs[plr_instance] = {
			obj = {},
			connections = {}
		}

		

		local flags_table = {}
		local chams_table = {}
		local parts_cache = {}

		local registered_flags = esp_table.registered_flags

		local plr = loaded_plrs[plr_instance]
		local obj = plr.obj

		local main_holder = esp.create_obj("Frame", {
			Parent = container,
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 0),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Visible = false
		}, obj)
		local box_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			ZIndex = -1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1
		}, obj)
		local box_outline_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			ZIndex = -1,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0, 2, 0, 2),
			BackgroundTransparency = 1
		}, obj)

		local main_box = esp.create_obj("UIStroke", {
			Parent = box_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new(1, 1, 1)
		}, obj)
		local main_box_color = esp.create_obj("UIGradient", {
			Parent = main_box,
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			}
		}, obj)
		local main_box_outline_1 = esp.create_obj("UIStroke", {
			Parent = main_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)
		local main_box_outline_2 = esp.create_obj("UIStroke", {
			Parent = box_outline_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)

		local main_name = esp.create_obj("TextLabel", {
			Parent = main_holder,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 12,
			FontFace = Fonts.Get("TahomaXP"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0, 10000, 0, 13),
			Text = plr_instance.Name,
			Position = UDim2.new(0.5, 0, 0, -17)
		}, obj)

		local main_distance = esp.create_obj("TextLabel", {
			Parent = main_holder,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 12,
			FontFace = Fonts.Get("TahomaXP"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0, 10000, 0, 13),
			Text = "0m",
			Position = UDim2.new(0.5, 0, 1, 1)
		}, obj)

		local main_weapon = esp.create_obj("TextLabel", {
			Parent = main_holder,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 12,
			FontFace = Fonts.Get("TahomaXP"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0, 10000, 0, 13),
			Text = "",
			Position = UDim2.new(0.5, 0, 1, 14)
		}, obj)

		esp.create_obj("UIStroke", {
			Parent = main_name,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)

		esp.create_obj("UIStroke", {
			Parent = main_distance,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)

		esp.create_obj("UIStroke", {
			Parent = main_weapon,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)

		local health_bar_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(0, 1, 1, 0),
			Position = UDim2.new(0, -5, 0, 0),
			BorderSizePixel = 0
		}, obj)

		local health_bar_outline = esp.create_obj("UIStroke", {
			Parent = health_bar_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)

		local main_health_bar = esp.create_obj("Frame", {
			Parent = health_bar_holder,
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, 0, 0, 0)
		}, obj)

		local main_health_text = esp.create_obj("TextLabel", {
			Parent = main_health_bar,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
			FontFace = Fonts.Get("TahomaXP"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(50, 0, 0, 6),
			Text = "100",
			Position = UDim2.new(-2, 0, 1, 0)
		}, obj)

		esp.create_obj("UIStroke", {
			Parent = main_health_text,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			LineJoinMode = Enum.LineJoinMode.Miter,
			Color = Color3.new()
		}, obj)

		local health_bar_thing = esp.create_obj("Frame", {
			Parent = health_bar_holder,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			AnchorPoint = Vector2.new(0, 1),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 1, 0)
		}, obj)

		local main_health_bar_color = esp.create_obj("UIGradient", {
			Parent = health_bar_thing,
			Rotation = 90,
			Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
			}
		}, obj)

		local flag_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(1, 3, 0, -4),
			BackgroundTransparency = 1,
		}, obj)

		esp.create_obj("UIListLayout", {
			Parent = flag_holder,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalFlex = Enum.UIFlexAlignment.None,
			Padding = UDim.new(0, -2)
		}, obj)


		for i, v in registered_flags do
			local flag = esp.create_obj("TextLabel", {
				Parent = flag_holder,
				TextStrokeTransparency = 0,
				BorderSizePixel = 0,
				TextSize = 9,
				TextXAlignment = Enum.TextXAlignment.Left,
				FontFace = Fonts.Get("SmallestPixel7"),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 10),
				Text = v[1],
				Position = UDim2.new(0, 0, 0, -1)
			}, flags_table)
			table.insert(obj, flag)
			esp.create_obj("UIStroke", {
				Parent = flag,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				LineJoinMode = Enum.LineJoinMode.Miter,
				Color = Color3.new()
			}, obj)
		end

		local main_wireframe = esp.create_obj("WireframeHandleAdornment", {
			Parent = container,
			Color3 = Color3.new(1, 1, 1),
			Transparency = 0,
			AlwaysOnTop = true,
			CFrame = CFrame.new(),
			Scale = Vector3.one,
			Thickness = 1,
			AdornCullingMode = Enum.AdornCullingMode.Automatic
		}, obj)

		

		local settings = esp_table.settings.enemy
		local main_settings = settings.main_settings

		local character, humanoid, head, root

		
		local team_check, dead_check, dist_check, npc_check = main_settings.team_check, main_settings.dead_check, main_settings.dist_check, main_settings.npc_check
		local skeleton_rate = main_settings.skeleton_rate <= 0 and 1e-10 or main_settings.skeleton_rate
		local max_distance, update_skeleton = main_settings.max_distance, settings.skeleton
		local weapon_enabled, box_rotation = settings.weapon, settings.box_rotation

		local gradient_spin, gradient_speed = main_settings.gradient_spin, main_settings.gradient_speed
		local holder_spin, holder_speed = main_settings.holder_spin, main_settings.holder_speed

		local get_team, get_gun = esp_table.get_team, esp_table.get_gun

		local setvis_cache, skeleton_tick, gui_tick = false, 0, 0

		function plr:forceupdate()
			team_check, dead_check, dist_check, npc_check = main_settings.team_check, main_settings.dead_check, main_settings.dist_check, main_settings.npc_check
			skeleton_rate = main_settings.skeleton_rate <= 0 and 1e-10 or main_settings.skeleton_rate
			max_distance, update_skeleton = main_settings.max_distance, settings.skeleton
			weapon_enabled, box_rotation = settings.weapon, settings.box_rotation

			gradient_spin, gradient_speed = main_settings.gradient_spin, main_settings.gradient_speed
			holder_spin, holder_speed = main_settings.holder_spin, main_settings.holder_speed

			main_box_outline_1.Enabled = settings.box_outline
			main_box_outline_1.Color = settings.box_outline_color[1]
			main_box_outline_1.Transparency = settings.box_outline_color[2]

			main_box_outline_2.Enabled = settings.box_outline
			main_box_outline_2.Color = settings.box_outline_color[3]
			main_box_outline_2.Transparency = settings.box_outline_color[4]

			main_box.Enabled = settings.box
			main_box.Transparency = settings.box_color[3]
			main_box_color.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, settings.box_color[1]),
				ColorSequenceKeypoint.new(1, settings.box_color[2])
			}
			main_box_color.Rotation = box_rotation + (gradient_spin and tick() % 1 * gradient_speed or 0)

			health_bar_holder.Visible = settings.health_bar
			main_health_bar_color.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, settings.health_bar_color[1]),
				ColorSequenceKeypoint.new(1, settings.health_bar_color[2])
			}

			main_health_text.Visible = settings.health_text
			main_health_text.TextColor3 = settings.health_text_color[1]
			main_health_text.TextTransparency = settings.health_text_color[2]

			main_name.Visible = settings.name
			main_name.TextColor3 = settings.name_color[1]
			main_name.TextTransparency = settings.name_color[2]

			main_distance.Visible = settings.distance
			main_distance.TextColor3 = settings.distance_color[1]
			main_distance.TextTransparency = settings.distance_color[2]

			main_weapon.Visible = settings.weapon
			main_weapon.TextColor3 = settings.weapon_color[1]
			main_weapon.TextTransparency = settings.weapon_color[2]

			main_wireframe.Visible = settings.skeleton
			main_wireframe.Color3 = settings.skeleton_color[1]
			main_wireframe.Transparency = settings.skeleton_color[2]

			flag_holder.Visible = settings.flags
			for _, flag in flags_table do
				flag.TextColor3 = settings.flags_color[1]
				flag.TextTransparency = settings.flags_color[2]
			end

			for part, cham in chams_table do
				cham.cham.Adornee = setvis_cache and settings.chams and part or nil
				cham.cham.Color3 = Color3.new(
					settings.chams_color[1].R * settings.chams_glow_factor,
					settings.chams_color[1].G * settings.chams_glow_factor,
					settings.chams_color[1].B * settings.chams_glow_factor
				)
			end
		end

		local destroy_cham_object = function(part)
			if not chams_table[part] then
				return 
			end
			chams_table[part].connection:Disconnect()
			chams_table[part].cham:Destroy()
			chams_table[part] = nil
		end

		local create_cham_object = function(part)
			if not (_IsA(part, "BasePart") and isBodyPart(part.Name)) then return end
			if chams_table[part] then destroy_cham_object(part) end
			
			local cham = esp.create_obj("BoxHandleAdornment", {
				Parent = container,
				Size = part.Size * .95,
				Adornee = setvis_cache and settings.chams and part or nil,
				Color3 = Color3.new(
					settings.chams_color[1].R * settings.chams_glow_factor,
					settings.chams_color[1].G * settings.chams_glow_factor,
					settings.chams_color[1].B * settings.chams_glow_factor
				),
				Transparency = -1,
				Shading = Enum.AdornShading.XRayShaded,
				ZIndex = -1,
				AlwaysOnTop = false
			}, obj)

			local conn = part:GetPropertyChangedSignal("Size"):Connect(function()
				if not (cham and part) then return print("MEMORY LEAK!!!!!!", cham, part) end
				cham.Size = part.Size * .95
			end)

			chams_table[part] = {
				cham = cham,
				connection = conn
			}
		end

		function plr:togglevis(bool, fade)
			if setvis_cache == bool then return end
			setvis_cache = bool

			main_holder.Visible = bool
			main_wireframe.Visible = bool and settings.skeleton
			if not bool then main_wireframe:Clear() end
			for part, cham in chams_table do
				cham.cham.Adornee = bool and settings.chams and part or nil
			end
		end

		function plr:unload()
			if not loaded_plrs[plr_instance] then return end
			for i,v in chams_table do
				v.connection:Disconnect()
				chams_table[i] = nil
			end
			for i,v in plr.connections do
				v:Disconnect()
				plr.connections[i] = nil
			end
			for i,v in plr.obj do
				v:Remove()
				plr.obj[i] = nil
			end
			for i,v in plr do
				plr[i] = nil
			end
			loaded_plrs[plr_instance] = nil
		end

		local character_added = function(character)
			for _, part in character:GetChildren() do
				create_cham_object(part)
				if _IsA(part, "BasePart") and isBodyPart(part.Name) then
					parts_cache[part.Name] = part
				end
			end
			plr.connections["character_childadded"] = character.ChildAdded:Connect(function(part)
				create_cham_object(part)
				if _IsA(part, "BasePart") and isBodyPart(part.Name) then
					parts_cache[part.Name] = part
				end
			end)
			plr.connections["character_childremoved"] = character.ChildRemoved:Connect(function(part)
				destroy_cham_object(part)
				parts_cache[part.Name] = nil
			end)
		end

		local character_removing = function(character)
			if plr.connections["character_childadded"] then plr.connections["character_childadded"]:Disconnect() end
			if plr.connections["character_childremoved"] then plr.connections["character_childremoved"]:Disconnect() end
			for part, _ in chams_table do
				destroy_cham_object(part)
			end
			for name, _ in parts_cache do
				parts_cache[name] = nil
			end
		end

		if is_npc or plr_instance.Character then character_added(is_npc and plr_instance or plr_instance.Character) end
		if not is_npc then
			plr.connections["character_added"] = plr_instance.CharacterAdded:Connect(character_added)
			plr.connections["character_removing"] = plr_instance.CharacterRemoving:Connect(character_removing)
		end

		plr.render = function(delta, camera_position, current_tick)
			skeleton_tick += delta
			gui_tick += delta
			local gui_ready = gui_tick > 0.08

			if not settings.enabled then
				return plr:togglevis(false)
			end

			if (npc_check) and (is_npc) then
				return plr:togglevis(false)
			end

			character = is_npc and plr_instance or plr_instance.Character
			root = is_helicopter and character.PrimaryPart or character and _FindFirstChild(character, "HumanoidRootPart")
			humanoid = character and _FindFirstChildOfClass(character, "Humanoid")

			if not (character and root and humanoid) then
				return plr:togglevis(false)
			end

			local humanoid_health = is_helicopter and root:GetAttribute("Health") or humanoid.Health
			local humanoid_max_health = is_helicopter and root:GetAttribute("MaxHealth") or humanoid.MaxHealth
			local humanoid_distance = (camera_position - root.Position).Magnitude

			if (not is_npc and team_check) and get_team(plr_instance, character, humanoid) then
				return plr:togglevis(false)
			end

			if (dead_check) and (humanoid_health <= 0) then
				return plr:togglevis(false)
			end

			if (dist_check) and (humanoid_distance > max_distance) then
				return plr:togglevis(false)
			end

			local _, on_screen = _WorldToViewportPoint(Camera, root.Position)

			if not on_screen then
				return plr:togglevis(false)
			end

			local topLeft, bottomRight, cache = nil, nil, table.create(15)
			do
				local count = 0
				for name, part in parts_cache do
					if part.Parent then
						cache[name] = {part.CFrame, part.Size}
						count += 1
					else
						parts_cache[name] = nil
					end
				end
				if is_helicopter then
					cache[root.Name] = {root.CFrame, root.Size}
				end
				if count <= 0 then
					return plr:togglevis(false)
				end
				topLeft, bottomRight = calculateCorners(getBoundingBox(cache))
			end

			plr:togglevis(true)

			do
				main_holder.Rotation = holder_spin and current_tick * holder_speed % 360 or 0
				main_box_color.Rotation = box_rotation + (gradient_spin and current_tick * gradient_speed % 360 or 0)
			end

			do
				local pos = topLeft
				local size = bottomRight - topLeft
				main_holder.Position = UDim2.fromOffset(pos.X - gui_inset.X, pos.Y - gui_inset.Y)
				main_holder.Size = UDim2.fromOffset(size.X, size.Y)
			end

			if gui_ready then
				gui_tick = 0
				main_distance.Text = mathround(humanoid_distance / 3) .. "m"
				if weapon_enabled then
					local gun = is_npc and "???" or get_gun(plr_instance, character, humanoid)
					if gun then
						main_weapon.Text = gun
						main_weapon.Position = main_distance.Visible and UDim2.new(0.5, 0, 1, 14) or UDim2.new(0.5, 0, 1, 1)
						main_weapon.Visible = true
					else
						main_weapon.Visible = false
					end
				end
			end

			main_health_text.Text = tostring(mathfloor(humanoid_health))
			main_health_bar.Size = UDim2.fromScale(1, 1 - humanoid_health / humanoid_max_health)

			if gui_ready then
				for i, v in registered_flags do
					local show_flag, flag_text = v[2](plr_instance, character, humanoid)
					local flag = flags_table[i]
					if not show_flag then
						flag.Visible = false
						continue	
					end
					flag.Visible = true
					if flag_text then flag.Text = flag_text end
				end
			end

			if not is_helicopter and update_skeleton and skeleton_tick > skeleton_rate then
				skeleton_tick = skeleton_tick % skeleton_rate
				local root_pos = root.CFrame
				main_wireframe:Clear()
				main_wireframe.Adornee = root

				local points = table.create(15 * 2)
				local counter = 0

				for part_name, info in cache do 
					local parent_part = skeleton_order[part_name]
					local parent_info = parent_part and cache[parent_part]
					if not (parent_info) then
						continue
					end

					local part_pos, parent_pos = info[1], parent_info[1]

					points[counter + 1] = _VectorToObjectSpace(root_pos, part_pos.Position - root_pos.Position)
					points[counter + 2] = _VectorToObjectSpace(root_pos, parent_pos.Position - root_pos.Position)

					counter += 2
				end

				main_wireframe:AddLines(points)
			end

			if gui_ready then
				plr:forceupdate()
			end
		end
	end

	create_object_esp = function(model)
		
		local s = tick()
		while task.wait() and (tick() - s < 1) do
			if _FindFirstChildOfClass(model, "Humanoid") then
				return create_corpse_esp(model)
			end
			if _FindFirstChildOfClass(model, "ObjectValue") then
				return create_item_esp(model)
			end
		end

		print("unidentified object:", model:GetFullName())
	end
	create_corpse_esp = function(object)
		loaded_plrs[object] = {
			obj = {},
			connections = {}
		}

		local plr = loaded_plrs[object]
		local obj = plr.obj

		local main_holder = esp.create_obj("Frame", {
			Parent = container,
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 0),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Visible = false
		}, obj)

		esp.create_obj("UIListLayout", {
			Parent = main_holder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}, obj)

		local main_text = esp.create_obj("TextLabel", {
			Parent = main_holder,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 9,
			FontFace = Fonts.Get("SmallestPixel7"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0, 10000, 0, 10),
			Text = object.Name
		}, obj)


		

		local settings = esp_table.settings.corpse
		local main_settings = settings.main_settings

		local main_part = _FindFirstChild(object, "UpperTorso")
		local corpse_name = object.Name

		
		local dist_check, max_distance = main_settings.dist_check, main_settings.max_distance
		local distance_enabled = settings.distance

		local setvis_cache = false

		function plr:forceupdate()
			dist_check, max_distance = main_settings.dist_check, main_settings.max_distance
			distance_enabled = settings.distance

			main_holder.Visible = settings.enabled and setvis_cache

			main_text.TextColor3 = settings.text_color[1]
			main_text.TextTransparency = settings.text_color[2]
		end

		function plr:togglevis(bool, fade)
			if setvis_cache == bool then return end
			setvis_cache = bool

			main_holder.Visible = bool
		end

		plr.render = function(delta, camera_position, current_tick)
			if not settings.enabled then
				return plr:togglevis(false)
			end

			main_part = _FindFirstChild(object, "UpperTorso")
			if not (main_part) then
				return plr:togglevis(false)
			end

			local corpse_position = main_part.Position
			local screen_pos, on_screen = _WorldToViewportPoint(Camera, corpse_position)

			if not on_screen then
				return plr:togglevis(false)
			end

			screen_pos = _Vector2new(screen_pos.X, screen_pos.Y)

			local corpse_distance = (camera_position - corpse_position).Magnitude

			if (dist_check) and (corpse_distance > max_distance) then
				return plr:togglevis(false)
			end

			plr:togglevis(true)

			do
				main_holder.Position = UDim2.fromOffset(screen_pos.X - gui_inset.X, screen_pos.Y - gui_inset.Y)

				local text_buffer = ("%*'s corpse"):format(corpse_name)

				if distance_enabled then
					text_buffer ..= (" (%*m)"):format(mathround(corpse_distance / 3))
				end

				main_text.Text = text_buffer
			end
		end

		plr:forceupdate()
	end
	create_item_esp = function(object)
		loaded_plrs[object] = {
			obj = {},
			connections = {}
		}

		local plr = loaded_plrs[object]
		local obj = plr.obj

		local main_holder = esp.create_obj("Frame", {
			Parent = container,
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 0),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			Visible = false
		}, obj)

		esp.create_obj("UIListLayout", {
			Parent = main_holder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}, obj)

		local main_text = esp.create_obj("TextLabel", {
			Parent = main_holder,
			TextStrokeTransparency = 0,
			BorderSizePixel = 0,
			TextSize = 9,
			FontFace = Fonts.Get("SmallestPixel7"),
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0, 10000, 0, 10),
			Text = object.Name
		}, obj)

		local durability_holder = esp.create_obj("Frame", {
			Parent = main_holder,
			BackgroundColor3 = Color3.new(),
			BorderSizePixel = 0,
			Size = UDim2.new(0, 50, 0, 3),
			Visible = false
		})

		local current_durability = esp.create_obj("Frame", {
			Parent = durability_holder,
			BackgroundColor3 = Color3.fromRGB(206, 206, 206),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(0, -1, 0, 1)
		})

		local max_durability = esp.create_obj("Frame", {
			Parent = durability_holder,
			AnchorPoint = Vector2.new(1, 0),
			BackgroundColor3 = Color3.fromRGB(197, 60, 62),
			BorderSizePixel = 0,
			Position = UDim2.new(1, -1, 0, 1),
			Size = UDim2.new(0, 1, 0, 1)
		})

		esp.create_obj("UIStroke", {
			Parent = durability_holder,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			LineJoinMode = Enum.LineJoinMode.Miter,
			BorderOffset = UDim.new(0, -1),
			Thickness = 1
		})


		

		local settings = esp_table.settings.item
		local main_settings = settings.main_settings

		local main_part, main_value = object.PrimaryPart, _FindFirstChildOfClass(object, "ObjectValue")
		local item_name = object.Name

		
		local dist_check, max_distance = main_settings.dist_check, main_settings.max_distance
		local distance_enabled, amount_enabled, durability_enabled = settings.distance, settings.amount, settings.durability
		local durability_bar_enabled = settings.durability_bar

		local setvis_cache = false

		function plr:forceupdate()
			dist_check, max_distance = main_settings.dist_check, main_settings.max_distance
			distance_enabled, amount_enabled, durability_enabled = settings.distance, settings.amount, settings.durability
			durability_bar_enabled = settings.durability_bar

			main_holder.Visible = settings.enabled and setvis_cache

			durability_holder.Visible = durability_bar_enabled

			main_text.TextColor3 = settings.text_color[1]
			main_text.TextTransparency = settings.text_color[2]
		end

		function plr:togglevis(bool, fade)
			if setvis_cache == bool then return end
			setvis_cache = bool

			main_holder.Visible = bool
		end

		plr.render = function(delta, camera_position, current_tick)
			local main_part, main_value = object.PrimaryPart, _FindFirstChildOfClass(object, "ObjectValue")

			if not (main_part and main_value) then
				return plr:togglevis(false)
			end

			if not settings.enabled then
				return plr:togglevis(false)
			end

			local item_position = main_part.Position
			local screen_pos, on_screen = _WorldToViewportPoint(Camera, item_position)

			if not on_screen then
				return plr:togglevis(false)
			end

			screen_pos = _Vector2new(screen_pos.X, screen_pos.Y)

			local item_distance = (camera_position - item_position).Magnitude

			if (dist_check) and (item_distance > max_distance) then
				return plr:togglevis(false)
			end

			plr:togglevis(true)

			local item_itemlist = main_value.Value
			local item_properties = item_itemlist and _FindFirstChild(item_itemlist, "ItemProperties")
			local item_amount = main_value:GetAttribute("Amount")
			local item_durability = main_value:GetAttribute("Durability")
			local item_maxdurability = main_value:GetAttribute("MaxDurability")
			local item_originalmaxdurability = item_properties and item_properties:GetAttribute("OriginalMaxDurability")
			do
				main_holder.Position = UDim2.fromOffset(screen_pos.X - gui_inset.X, screen_pos.Y - gui_inset.Y)

				local text_buffer = item_name

				if distance_enabled then
					text_buffer ..= (" (%*m)"):format(mathround(item_distance / 3))
				end
				if amount_enabled and item_amount then
					text_buffer ..= (" (%*x)"):format(item_amount)
				end
				if durability_enabled and item_durability and item_maxdurability then
					text_buffer ..= (" (%*/%*)"):format(item_durability, item_maxdurability)
				end

				main_text.Text = text_buffer
			end

			local should_durability = durability_bar_enabled and item_durability and item_maxdurability
			durability_holder.Visible = should_durability
			if should_durability then
				local curr_size = item_durability / item_originalmaxdurability
				local max_size = 1 - item_maxdurability / item_originalmaxdurability
				current_durability.Size = UDim2.new(curr_size, -2, 0, 1)
				max_durability.Size = UDim2.new(max_size, max_size == 0 and 0 or -1, 0, 1)
			end
		end

		plr:forceupdate()
	end

	destroy_esp = function(player)
		if not loaded_plrs[player] then return end
		if loaded_plrs[player].unload then
			return loaded_plrs[player]:unload()
		end
		local plr = loaded_plrs[player]
		for i,v in plr.connections do
			v:Disconnect()
			plr.connections[i] = nil
		end
		for i,v in plr.obj do
			v:Remove()
			plr.obj[i] = nil
		end
for i,v in loaded_plrs[player] do
		loaded_plrs[player][i] = nil
	end
	loaded_plrs[player] = nil
	end

	function esp_table.load()
		assert(not esp_table.__loaded, "[ESP] already loaded");

		for _, player in plrs:GetPlayers() do
			if lplr ~= player then
				create_esp(player)
			end
		end

		for _, object in project_delta.droppeditems:GetChildren() do
			create_object_esp(object)
		end

		for _, aizone in project_delta.aizones:GetChildren() do
			for _, npc in aizone:GetChildren() do
				create_esp(npc)
			end
		end

		esp_table.connections = {}
		table.insert(esp_table.connections, plrs.PlayerAdded:Connect(create_esp))
		table.insert(esp_table.connections, plrs.PlayerRemoving:Connect(destroy_esp))
		table.insert(esp_table.connections, project_delta.droppeditems.ChildAdded:Connect(create_object_esp))
		table.insert(esp_table.connections, project_delta.droppeditems.ChildRemoved:Connect(destroy_esp))
		for _, aizone in project_delta.aizones:GetChildren() do
			table.insert(esp_table.connections, aizone.ChildAdded:Connect(create_esp))
			table.insert(esp_table.connections, aizone.ChildRemoved:Connect(destroy_esp))
		end

		table.insert(esp_table.connections, cheat.utility.new_renderstepped(function(delta)
			local camera_position = Camera.CFrame.Position
			local current_tick = tick()
			for _, plr in loaded_plrs do
				plr.render(delta, camera_position, current_tick)
			end
		end))

		esp_table.__loaded = true;
	end

	function esp_table.unload()
		assert(esp_table.__loaded, "[ESP] not loaded yet");

		for player, v in next, loaded_plrs do
			destroy_esp(player)
		end

		for _, connection in esp_table.connections do
			connection:Disconnect()
		end

		esp_table.__loaded = false;
	end

	esp_table.get_team = function(player, character, humanoid)
		return LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team
	end

	esp_table.get_gun = function(player, character, humanoid)
		if not character then
			return
		end
		local tool = _FindFirstChildOfClass(character, "Tool")
		return tool and tool.Name
	end

	function esp_table.icaca()
		for _, v in loaded_plrs do
			task.spawn(function() v:forceupdate() end)
		end
	end

	function esp_table.register_flag(flag, func)
		assert(not esp_table.__loaded, "[ESP] tried adding flag after loading, add before loading")
		local registered_flags = esp_table.registered_flags
		registered_flags[#registered_flags + 1] = {flag, func}
	end

	cheat.EspLibrary = esp_table
end)();
LPH_NO_VIRTUALIZE(function()
	local camera = workspace.CurrentCamera

	local indicatorlib = {
		indicators = {}
	}

	function indicatorlib:new_indicator()
		local indicator = {
			enabled = false,

			followpart = false,
			target_part = nil,

			scale_x = 0.5,
			scale_y = 0.5,
			offset_x = 0,
			offset_y = 0,

			blink = false,
			blink_speed = 1, 
			blink_cycle = false,

			text = "",
			transparency = 1
		}

		indicator.drawing = cheat.utility.new_drawing("Text", { Visible = false })
		indicator.text = `indicator {tostring(indicator)}`

		indicatorlib.indicators[indicator] = indicator

		return indicator 
	end


	cheat.utility.new_renderstepped(function(delta)
		local viewportsize = camera and camera.ViewportSize
		if not viewportsize then
			camera = workspace.CurrentCamera;
			for _, indicator in indicatorlib.indicators do
				local drawing = indicator.drawing
				if not drawing then continue end

				drawing.Visible = false
			end
			return
		end
		local viewport_x = viewportsize.X
		local viewport_y = viewportsize.Y
		for _, indicator in indicatorlib.indicators do

			local drawing = indicator.drawing
			if not drawing then continue end

			if not indicator.enabled then
				drawing.Visible = false
				continue
			end

			drawing.Visible = true
			drawing.Text = indicator.text

			if indicator.followpart then
				local target_part = indicator.target_part
				if not target_part then
					drawing.Visible = false
					continue
				end
				local pos, on_screen = _WorldToViewportPoint(camera, target_part.CFrame.Position)
				if not on_screen then
					drawing.Visible = false
					continue
				end
				drawing.Position = _Vector2new(pos.X + indicator.offset_x, pos.Y + indicator.offset_y)
			else
				local calculated_x = viewport_x * indicator.scale_x + indicator.offset_x
				local calculated_y = viewport_y * indicator.scale_y + indicator.offset_y
				drawing.Position = _Vector2new(calculated_x, calculated_y)
			end

			if not indicator.blink then
				drawing.Transparency = indicator.transparency
				continue
			end

			local blink_speed = indicator.blink_speed

			if drawing.Transparency <= 0 then
				indicator.blink_cycle = true
			elseif drawing.Transparency >= 1 then
				indicator.blink_cycle = false
			end

			drawing.Transparency = drawing.Transparency + (blink_speed * (indicator.blink_cycle and 1 or -1)) * delta
		end
	end)


	cheat.IndicatorLibrary = indicatorlib
end)();

do
	local vischeck_params = RaycastParams.new()
	vischeck_params.FilterType = Enum.RaycastFilterType.Exclude
	vischeck_params.CollisionGroup = "WeaponRay"
	vischeck_params.IgnoreWater = true

	cheat.is_visible = LPH_NO_VIRTUALIZE(function(origin, target, target_part)
		vischeck_params.FilterDescendantsInstances = { workspace.NoCollision, Camera, LocalPlayer.Character }
		local castresults = _Raycast(workspace, origin, target_part.Position - origin, vischeck_params)
		return castresults and castresults.Instance and _IsDescendantOf(castresults.Instance, target), castresults
	end)

	cheat.is_pos_visible = LPH_NO_VIRTUALIZE(function(origin, target_pos, target)
		vischeck_params.FilterDescendantsInstances = { workspace.NoCollision, Camera, LocalPlayer.Character }
		local castresults = _Raycast(workspace, origin, target_pos - origin, vischeck_params)
		return castresults and castresults.Instance and _IsDescendantOf(castresults.Instance, target), castresults
	end)
end

cheat.make_beam = function(Origin, Position, Color)
	local part1, part2 = Instance.new("Part", workspace.NoCollision), Instance.new("Part", workspace.NoCollision)
	part1.CFrame = _CFramenew(Origin);
	part2.CFrame = _CFramenew(Origin); 
	part1.Transparency = 1; part2.Transparency = 1;
	part1.CanCollide = false; part2.CanCollide = false;
	part1.Size = Vector3.zero; part2.Size = Vector3.zero;
	part1.Anchored = true; part2.Anchored = true;
	local OriginAttachment = Instance.new("Attachment", part1)
	local PositionAttachment = Instance.new("Attachment", part2)
	local Beam = Instance.new("Beam", workspace.NoCollision)
	Beam.Name = "Beam"
	Beam.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0,Color),
		ColorSequenceKeypoint.new(1,Color)
	};
	Beam.LightEmission = 9e9
	Beam.LightInfluence = 9e9
	Beam.TextureMode = Enum.TextureMode.Static
	Beam.TextureSpeed = 0
	
	Beam.Transparency = NumberSequence.new(0)
	Beam.Attachment0 = OriginAttachment
	Beam.Attachment1 = PositionAttachment
	Beam.FaceCamera = true
	Beam.Segments = 1
	Beam.Width0 = 0.2
	Beam.Width1 = 0.2
	local start_tick = tick()
	local speed = 50
	local connection; connection = cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
		local passed = tick() - start_tick
		local lv = (Position - Origin)
		local dist = passed * speed
		local newpos = (Position - Origin).Unit * dist
		part2.CFrame = _CFramenew(Origin + newpos)

		local dist_left = lv.Magnitude - dist
		local tp1 = math.clamp((dist - lv.Magnitude + speed) / speed, 0, 1)
		local tp2 = math.clamp((passed - (5 / 2)) * (5 * 2), 0, 1)
		local ctp = tp1 > tp2 and tp1 or tp2
		Beam.Transparency = NumberSequence.new(ctp)

		if ctp > 1 then
			Beam:Destroy()
			OriginAttachment:Destroy()
			PositionAttachment:Destroy()
			part1:Destroy()
			part2:Destroy()
			connection:Disconnect()
		end
	end))
end

cheat.report_list = {}
do
	local report_list = game:GetService("ReplicatedStorage").ReportList
	local most_wanted = report_list.MostWanted
	local recent_reports = report_list.Recent
	
	local player_report_list = cheat.report_list
	task.spawn(LPH_NO_VIRTUALIZE(function()
		while task.wait(0.25) do
			for i, v in player_report_list do
				v.rr = 0
				v.mw = 0
			end
			for i, v in recent_reports:GetChildren() do
				local username, report_id = v.Name:match("(.+)_([^_]+)$")
				local player_object = player_report_list[username]
				
				if not player_object then
					player_report_list[username] = {rr = 0, mw = 0}
					player_object = player_report_list[username]
				end

				player_object.rr += 1
			end
			for i, v in most_wanted:GetChildren() do
				local username, user_id = v.Name:match("(.+)_([^_]+)$")
				local player_object = player_report_list[username]
				
				if not player_object then
					player_report_list[username] = {rr = 0, mw = 0}
					player_object = player_report_list[username]
				end

				player_object.mw += 1
			end
		end
	end))
end

cheat.player_list = {}
local hit_detection = function(...)end


do 
	local InfoBuildStatus, InfoBuildErr = pcall(function()
		local Info = { Objects = {} }
		local Objects = Info.Objects; do
			Objects.accent = Utility.New("Frame", {
				Name = "inforeports.accent",
				Position = UDim2.new(0, 30, 0.5, 0),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(0, 140, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3.fromRGB(120, 160, 220),
				Parent = Library.ScreenGuiPopups,
			}, { BackgroundColor3 = "accent" })
			Library.Dragging(Objects.accent, Objects.accent, true)
			Objects.background = Utility.New("Frame", {
				Name = "inforeports.background",
				Position = UDim2.new(0, 1, 0, 1),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(23, 25, 26),
				Parent = Objects.accent,
			}, { BackgroundColor3 = "background" })
			Objects.dock = Utility.New("Frame", {
				Name = "inforeports.dock",
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 0, 0, 22),
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(19, 19, 19),
				Parent = Objects.background,
			}, { BackgroundColor3 = "dock background" })
			Objects.title = Utility.New("TextLabel", {
				FontFace = Library.Font,
				TextColor3 = Color3.fromRGB(230, 230, 230),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "Info",
				TextStrokeTransparency = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = Library.FontSize,
				Parent = Objects.dock,
			}, { TextColor3 = "text" })
			Objects.title2 = Utility.New("TextLabel", {
				FontFace = Library.Font,
				TextColor3 = Color3.fromRGB(220, 100, 100),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "  reports",
				TextStrokeTransparency = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = Library.FontSize,
				Parent = Objects.dock,
			}, { TextColor3 = "accent" })
			Utility.New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 2),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Parent = Objects.dock,
			})
			Objects.text = Utility.New("TextLabel", {
				FontFace = Fonts.Get("TahomaXP"),
				TextColor3 = Color3.fromRGB(230, 230, 230),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				Text = "",
				TextWrapped = true,
				TextStrokeTransparency = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -8, 0, 0),
				Position = UDim2.new(0, 4, 0, 24),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = 13,
				Parent = Objects.background,
			}, { TextColor3 = "text" })
			Objects.text.Size = UDim2.new(0, 132, 0, 0)
		end
		function Info.Status(value)
			Objects.accent.Visible = value
		end
		Library.InfosList = Info
	end)
	if not InfoBuildStatus then
		warn("[Info] widget init failed: " .. tostring(InfoBuildErr))
	end
	task.spawn(LPH_NO_VIRTUALIZE(function()
		while task.wait(0.5) do
			local ok = pcall(function()
				local infos = Library.InfosList
				if not infos or not infos.Objects.text then return end
				local plr = game:GetService("Players").LocalPlayer
				local self_stat = plr and cheat.player_list[plr]
				if not self_stat then
					infos.Objects.text.Text = "loading..."
					return
				end
				local lines = {}
				local total = self_stat.reports or 0
				table.insert(lines, ("Total: %s"):format(total))
				if total > 0 then
					table.insert(lines, "репортов")
				end
				local game_data = self_stat.game_data
				local status = game_data and _FindFirstChild(game_data, "Status")
				local gameplay = status and _FindFirstChild(status, "GameplayVariables")
				local combat = self_stat.combat or (gameplay and _FindFirstChild(gameplay, "Combat"))
				if combat then
					local headshots = math.max(tonumber(combat:GetAttribute("Headshots")) or 0, 0)
					local bodyshots = math.max(tonumber(combat:GetAttribute("Bodyshots")) or 0, 0)
					local total_shots = headshots + bodyshots
					local hsr = total_shots > 0 and (headshots / total_shots) or 0
					table.insert(lines, ("HSR: %s%%"):format(mathfloor(hsr * 1000) / 10 or 0))
				end
				local statistics = self_stat.statistics
				local wipe_statistics = self_stat.wipe_statistics
				if statistics then
					local kills = math.max(tonumber(statistics:GetAttribute("Kills")) or 0, 0)
					local deaths = math.max(tonumber(statistics:GetAttribute("Deaths")) or 0, 0)
					table.insert(lines, ("Kills: %s"):format(kills))
					table.insert(lines, ("Deaths: %s"):format(deaths))
					table.insert(lines, ("KDR: %s"):format(mathfloor((kills / math.max(deaths, 1)) * 100) / 100))
				end
				if wipe_statistics then
					local played = math.max(tonumber(wipe_statistics:GetAttribute("TimePlayed")) or 0, 0)
					local session = self_stat.session_start or 0
					local hours = (played + math.max(0, os.time() - session)) / 3600
					table.insert(lines, ("Hours: %s"):format(mathfloor(hours * 100) / 100))
				end
				for p, pobj in cheat.player_list do
					local reason = pobj and pobj.mod_reason
					if reason then
						table.insert(lines, ("!!MOD DETECTED!! %s (%s)"):format(p.Name, reason))
					end
				end
				infos.Objects.text.Text = table.concat(lines, "\n")
			end)
			if not ok then
				local infos = Library.InfosList
				if infos and infos.Objects.text then
					infos.Objects.text.Text = "error"
				end
			end
		end
	end))
end
do
	local is_visible, get_visor_status = cheat.is_visible, project_delta.get_visor_status
	local player_list = cheat.player_list
	local player_folder = game:GetService("ReplicatedStorage"):WaitForChild("Players")
	local add_player = function(player)
		player_list[player] = {}
		local player_object = player_list[player]
		local game_data, game_uac, game_clan, game_inventory
		local character, humanoid
		local old_health
		player_object.premium = player.MembershipType == Enum.MembershipType.Premium
		local refresh_tick = 0
		player_object.update_loop = LPH_NO_VIRTUALIZE(function(delta, bullet_origin)

			refresh_tick += delta
			local do_refresh = refresh_tick > 0.35

			if do_refresh then
				refresh_tick = 0
				game_data = _FindFirstChild(player_folder, player.Name)
			local game_inventory = game_data and _FindFirstChild(game_data, "Inventory")
			local game_status = game_data and _FindFirstChild(game_data, "Status")
			local game_journey = game_status and _FindFirstChild(game_status, "Journey")
			local game_uac = game_status and _FindFirstChild(game_status, "UAC")
			local game_clan = game_journey and _FindFirstChild(game_journey, "Clan")

			player_object.game_data = game_data
			player_object.inventory = game_inventory

			if game_data then
				player_object.statistics = game_data:FindFirstChild("Statistics", true)
				player_object.wipe_statistics = game_data:FindFirstChild("WipeStatistics", true)
			end

			if game_journey then
				player_object.session_start = game_journey:GetAttribute("SessionStart")
			end

			if game_clan then
				local clan = game_clan:GetAttribute("CurrentClan")
				player_object.current_clan = clan ~= "nil" and clan
			end

			if game_uac then
				player_object.server_position = game_uac:GetAttribute("LastVerifiedPos")
				local reports = _FindFirstChild(game_uac, "Reports")
				if reports then
					local total_reports = 0
					local report_types = {}
					for report_type, count in reports:GetAttributes() do
						total_reports += count
						if count > 0 then
							report_types[report_type] = count
						end
					end
					player_object.reports = total_reports
					player_object.report_types = report_types
				end
				if game_uac:GetAttribute("A1Detected") then
					player_object.mod_reason = "A1Detected"
				elseif game_uac:GetAttribute("A2Detected") then
					player_object.mod_reason = "A2Detected"
				elseif game_uac:GetAttribute("A3Detected") then
					player_object.mod_reason = "A3Detected"
				end
			end

			if game_data then
				local status = _FindFirstChild(game_data, "Status")
				local gameplay = status and _FindFirstChild(status, "GameplayVariables")
				local equipped_tool = gameplay and _FindFirstChild(gameplay, "EquippedTool")
				player_object.current_weapon = equipped_tool and equipped_tool.Value
				player_object.combat = gameplay and _FindFirstChild(gameplay, "Combat")
				if gameplay then
					if not player_object.mod_reason and gameplay:GetAttribute("Godmode") then
						player_object.mod_reason = "Godmode"
					end
					if not player_object.mod_reason and (gameplay:GetAttribute("PremiumLevel") or 0) >= 4 then
						player_object.mod_reason = "PremiumLevel"
					end
				end
			end

			if game_inventory then
				player_object.visor = get_visor_status(game_inventory)
			end
			end

			character = player.Character
			if not character then return end

			if do_refresh and bullet_origin then
				local hrp, head = _FindFirstChild(character, "HumanoidRootPart"), _FindFirstChild(character, "Head")
				player_object.visible = (hrp and is_visible(bullet_origin, character, hrp)) or (head and is_visible(bullet_origin, character, head))
			end

			humanoid = _FindFirstChildOfClass(character, "Humanoid")
			if not humanoid then return end
			if not old_health then old_health = humanoid.Health end
			local new_health = humanoid.Health
			if new_health ~= old_health then
				hit_detection(player, new_health, old_health)
				old_health = new_health
			end
		end)
		player_object.friend = false
		pcall(function()
			player_object.friend = player:IsFriendsWith(LocalPlayer.UserId)
		end)
	end

	for _, player in Players:GetPlayers() do
		task.spawn(add_player, player)
	end
	Players.PlayerAdded:Connect(add_player)

	Players.PlayerRemoving:Connect(function(player)
		local object = player_list[player]
		player_list[player] = nil
	end)

	local get_estimated_origin = project_delta.get_estimated_origin
	cheat.utility.new_heartbeat(LPH_NO_VIRTUALIZE(function(delta)
		local character = LocalPlayer.Character
		local hrp = character and _FindFirstChild(character, "HumanoidRootPart")
		local hmm_origin = hrp and get_estimated_origin(LocalPlayer)
		for i, v in player_list do
			v.update_loop(delta, hmm_origin)
		end
	end))

	local lp = player_list[LocalPlayer]
	cheat.EspLibrary.get_team = LPH_NO_VIRTUALIZE(function(player, character, humanoid)
		local tp = player_list[player]
		return tp and lp.current_clan and tp.current_clan and lp.current_clan == tp.current_clan
	end)

	cheat.EspLibrary.get_gun = LPH_NO_VIRTUALIZE(function(player, character, humanoid)
		local tp = player_list[player]
		local current_weapon = tp and tp.current_weapon
		return current_weapon and current_weapon.Name
	end)
end

cheat.bullet_infos = {}

local ui = {
	window = Library:Window({
		namestart = "swim",
		nameend = "hub"
	})
}

ui.tabs = {
	combat = ui.window:Tab({name = "Combat", image = Images.Get("combat")}),
	visuals = ui.window:Tab({name = "Visuals", image = Images.Get("visuals")}),
	misc = ui.window:Tab({name = "Misc", image = Images.Get("misc")}),
	skins = ui.window:Tab({name = "Skins", image = Images.Get("misc")}),
	settings = ui.window:Tab({name = "Settings", image = Images.Get("config")})
}
ui.subtabs = {
	combat_aimbot = ui.tabs.combat:SubTab({Name = "Aimbot"}),
	combat_misc = ui.tabs.combat:SubTab({Name = "Misc"}),
	visuals_esp = ui.tabs.visuals:SubTab({Name = "Player ESP"}),
	visuals_esp_misc = ui.tabs.visuals:SubTab({Name = "Misc ESP"}),
	visuals_lighting = ui.tabs.visuals:SubTab({Name = "Lighting"}),
	visuals_misc = ui.tabs.visuals:SubTab({Name = "Misc"}),
	skins_main = ui.tabs.skins:SubTab({Name = "Main"}),
	misc_main = ui.tabs.misc:SubTab({Name = "Main"}),
	misc_antiaim = ui.tabs.misc:SubTab({Name = "Anti-aim"}),
	misc_exploit = ui.tabs.misc:SubTab({Name = "Exploits"}),
	settings_main = ui.tabs.settings:SubTab({Name = "Main"}),
	settings_theme = ui.tabs.settings:SubTab({Name = "Themeing"})
}
ui.sections = {
	aimbot_main = ui.subtabs.combat_aimbot:Section({Name = "Aimbot", Side = "Left"}),
	aimbot_misc = ui.subtabs.combat_aimbot:Section({Name = "Misc", Side = "Right"}),
	
	aimbot_effects = ui.subtabs.combat_misc:Section({Name = "Effects/Logs", Side = "Left"}),
	gunmods = ui.subtabs.combat_misc:Section({Name = "Gun mods", Side = "Right"}),
	skins_items = ui.subtabs.skins_main:Section({Name = "Skins", Side = "Left"}),
	skins_cats = ui.subtabs.skins_main:Section({Name = "Categories", Side = "Right"}),

	player_esp = ui.subtabs.visuals_esp:Section({Name = "Players", Side = "Left"}),
	esp_settings = ui.subtabs.visuals_esp:Section({Name = "Settings", Side = "Right"}),
	item_esp = ui.subtabs.visuals_esp_misc:Section({Name = "Items", Side = "Left"}),
	other_esp = ui.subtabs.visuals_esp_misc:Section({Name = "Other", Side = "Right"}),
	world_main_changer = ui.subtabs.visuals_lighting:Section({Name = "Lighting", Side = "Left"}),
	world_misc_changer = ui.subtabs.visuals_lighting:Section({Name = "Misc", Side = "Right"}),
	visuals_misc = ui.subtabs.visuals_misc:Section({Name = "View", Side = "Left"}),
	visuals_local = ui.subtabs.visuals_misc:Section({Name = "Local", Side = "Right"}),

	movement = ui.subtabs.misc_main:Section({Name = "Movement", Side = "Left"}),
	misc = ui.subtabs.misc_main:Section({Name = "Misc", Side = "Right"}),
	staff = ui.subtabs.misc_main:Section({Name = "Staff checker", Side = "Right"}),
	antiaim = ui.subtabs.misc_antiaim:Section({Name = "Antiaim", Side = "Left"}),
	antiaim_animations = ui.subtabs.misc_antiaim:Section({Name = "Animation", Side = "Right"}),
	custom_desync = ui.subtabs.misc_exploit:Section({Name = "Custom desync", Side = "Left"}),
	exploit = ui.subtabs.misc_exploit:Section({Name = "Exploit", Side = "Right"}),

	settings_config = ui.subtabs.settings_main:Section({Name = "Config", Side = "Left"}),
	settings_personalization = ui.subtabs.settings_main:Section({Name = "Personalization", Side = "Right"}),
	theme_config = ui.subtabs.settings_theme:Section({Name = "Config", Side = "Left"}),
	theme_colors = ui.subtabs.settings_theme:Section({Name = "Colors", Side = "Right"})
}

do 
	ui.tabs.combat.Set(true)

	ui.subtabs.combat_aimbot.Set(true)
	ui.subtabs.visuals_esp.Set(true)
	ui.subtabs.misc_main.Set(true)
	ui.subtabs.settings_main.Set(true)
end

do 

	local staffsec = ui.sections.staff
	local STAFF_GROUP = 3765739
	local STAFF_OWNER_ID = 17953224
	local staff_enabled = true
	local staff_interval = 3
	local staff_extra = { [""] = true } 
	local staff_seen = {}

	local gui = Instance.new("ScreenGui")
	gui.Name = "StaffChecker"
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 200
	gui.ResetOnSpawn = false
	local lbl = Instance.new("TextLabel")
	lbl.Name = "StaffLabel"
	lbl.AnchorPoint = Vector2.new(0.5, 0.5)
	lbl.Position = UDim2.new(0.5, 0, 0.32, 0)
	lbl.Size = UDim2.new(0, 600, 0, 30)
	lbl.BackgroundTransparency = 1
	lbl.TextSize = 18
	lbl.Font = Enum.Font.GothamBold
	lbl.TextStrokeTransparency = 0
	lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	lbl.Text = ""
	lbl.Visible = false
	lbl.Parent = gui
	pcall(function()
		local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
		if pg then gui.Parent = pg end
	end)

	local function staff_role(plr)
		if not (plr and plr ~= LocalPlayer) then return nil end
		if staff_extra[plr.Name] then return "List" end
		if plr.UserId == STAFF_OWNER_ID then return "Owner" end
		local ok, role = pcall(function()
			if plr:GetRankInGroup(4502303) >= 100 then return "Group100+" end
			if plr:GetRankInGroup(13810797) >= 1 then return "Group1+" end
			if plr:GetRankInGroup(3765739) >= 5 then return "Group5+" end
			local fok, fr = pcall(plr.IsFriendsWith, plr, STAFF_OWNER_ID)
			if fok and fr then return "Friend" end
			return nil
		end)
		if ok and role then return role end
		
		local ok2, role2 = pcall(function()
			local rf = game:GetService("ReplicatedStorage"):FindFirstChild("Players")
			local rp = rf and rf:FindFirstChild(plr.Name)
			local st = rp and rp:FindFirstChild("Status")
			local ct = st and st:FindFirstChild("ChatTags")
			if not ct then return nil end
			local parts = {}
			for _, folder in ipairs(ct:GetChildren()) do
				if folder:IsA("Folder") and folder.Name ~= "gamePasses" then
					for _, tag in ipairs(folder:GetChildren()) do
						local t = tag:GetAttribute("tagText") or tag:GetAttribute("TagText") or tag.Name
						parts[#parts + 1] = tostring(t)
					end
				end
			end
			if #parts > 0 then return table.concat(parts, "+") end
			return nil
		end)
		if ok2 and role2 then return role2 end
		return nil
	end

	local function is_staff(plr)
		return staff_role(plr) ~= nil
	end

	local function refresh()
		pcall(function()
			local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
			if pg and not gui.Parent then gui.Parent = pg end
		end)
		if not staff_enabled then lbl.Visible = false return end
		local found = {}
		pcall(function()
			for _, plr in ipairs(Players:GetPlayers()) do
				if is_staff(plr) then found[#found + 1] = plr.Name end
			end
		end)
		if #found > 0 then
			lbl.Visible = true
			lbl.TextColor3 = Color3.fromRGB(255, 60, 60)
			local parts = {}
			pcall(function()
				for _, plr in ipairs(Players:GetPlayers()) do
					local role = staff_role(plr)
					if role then parts[#parts + 1] = plr.Name .. " [" .. role .. "]" end
				end
			end)
			lbl.Text = "STAFF IN GAME: " .. table.concat(parts, ", ")
			for _, n in ipairs(found) do
				if not staff_seen[n] then
					staff_seen[n] = true
					Library.Notification("Staff in game: " .. n, 5)
				end
			end
			for n in pairs(staff_seen) do
				if not table.find(found, n) then staff_seen[n] = nil end
			end
		else
			staff_seen = {}
			lbl.Visible = true
			lbl.TextColor3 = Color3.fromRGB(80, 255, 120)
			lbl.Text = "No staff in server"
		end
	end

	staffsec:Toggle({Name = "Staff checker", Value = true, Flag = "staff_checker", Callback = function(b)
		staff_enabled = b
		if not b then lbl.Visible = false else refresh() end
	end})
	staffsec:Slider({Name = "Check interval", Min = 1, Max = 30, Float = 1, Value = 3, Flag = "staff_check_interval", Callback = function(v)
		staff_interval = math.floor(v)
	end})
	staffsec:Button({Name = "Check now", Confirm = false, Callback = function()
		refresh()
	end})
	task.spawn(function()
		while true do
			task.wait(staff_interval)
			pcall(refresh)
		end
	end)
	pcall(function()
		Players.PlayerAdded:Connect(function() task.wait(1) refresh() end)
		Players.PlayerRemoving:Connect(function() task.wait(1) refresh() end)
		Players.PlayerAdded:Connect(function(plr)
			task.wait(1.5)
			pcall(function()
				local role = staff_enabled and staff_role(plr)
				if role then
					Library.Notification("[!] Staff " .. plr.DisplayName .. " joined (" .. role .. ")", 5)
				end
			end)
		end)
		Players.PlayerRemoving:Connect(function(plr)
			pcall(function()
				if staff_enabled and staff_seen[plr.Name] then
					Library.Notification("[!] Staff " .. plr.DisplayName .. " left", 5)
				end
			end)
		end)
	end)
	task.delay(2, function() pcall(refresh) end)
	do
		local genv = (getgenv and getgenv()) or _G
		genv.zzzhub_cleanup = genv.zzzhub_cleanup or {}
		table.insert(genv.zzzhub_cleanup, function()
			pcall(function() gui:Destroy() end)
		end)
	end
end

local heli_names = { ["MI24V"] = true, ["Mi-24V"] = true, ["Mi24V"] = true }
local heli_cache, heli_cache_time

local function find_helis()
	local now = tick()
	if heli_cache and heli_cache_time and (now - heli_cache_time) < 2 then
		return heli_cache
	end
	local list = {}
	for _, obj in workspace:GetDescendants() do
		if obj:IsA("Model") and heli_names[obj.Name] then
			list[#list + 1] = obj
		end
	end
	heli_cache = list
	heli_cache_time = now
	return list
end

local underground_resolver, underground_resolver_depth = false, 8

local get_targets_in_fov = LPH_NO_VIRTUALIZE(function(
	fov_size,
	aimbot_part,
	aimbot_team_check,
	aimbot_dead_check,
	aimbot_dist_check,
	aimbot_max_distance,
	aimbot_npc_check,
	aimbot_screen_check
)
	local player_list = Players:GetPlayers()
	local target_list = table.create(#player_list)

	local maximum_distance = fov_size

	local mousepos = UserInputService:GetMouseLocation()
	local campos = Camera.CFrame.Position

	local get_team = cheat.EspLibrary.get_team

	local aimbot_ignore_list = getgenv().aimbot_ignore_list or {}
	local aimbot_ignore_friends = getgenv().aimbot_ignore_friends ~= false
	local friend_cache = getgenv().aimbot_friend_cache or {}
	getgenv().aimbot_friend_cache = friend_cache

	for _, player in player_list do
		if not (player and player ~= LocalPlayer) then continue end

		local is_friend = false
		if aimbot_ignore_friends then
			if friend_cache[player.UserId] == nil then
				local ok, res = pcall(player.IsFriendsWith, player, LocalPlayer.UserId)
				friend_cache[player.UserId] = ok and res or false
			end
			is_friend = friend_cache[player.UserId]
		end
		if (table.find(aimbot_ignore_list, player.Name) or table.find(aimbot_ignore_list, player.DisplayName)) or is_friend then
			continue
		end

		local character = player.Character
		local root = character and _FindFirstChild(character, "HumanoidRootPart")
		local humanoid = character and _FindFirstChildOfClass(character, "Humanoid")
		local aimpart = character and _FindFirstChild(character, aimbot_part or "Head")
		local mainpart = aimpart or root

		if not (mainpart) then continue end

		if (aimbot_team_check) and get_team(player) then
			continue
		end
		if (aimbot_dead_check) and (not humanoid or humanoid.Health <= 0) then
			continue
		end
		if (aimbot_dist_check) and ((campos - mainpart.Position).Magnitude > aimbot_max_distance) then
			continue
		end

		local position, on_screen = _WorldToViewportPoint(Camera, mainpart.Position)
		local distance = (
			_Vector2new(
				position.X, position.Y
			) - mousepos
		).Magnitude

		local below_ground = underground_resolver and (mainpart.Position.Y < ground_y - underground_resolver_depth)

		if (aimbot_screen_check or on_screen or below_ground) and distance <= maximum_distance then
			table.insert(target_list, {mainpart, player, character, distance})
		end
	end

	for _, obj in find_helis() do
		for _, part in obj:GetDescendants() do
			if not part:IsA("BasePart") then continue end
			local part_name = part.Name
			local valid = part_name == "CollisionPilot"
			if not valid then continue end

			local mainpart = part
			if (aimbot_dist_check) and ((campos - mainpart.Position).Magnitude > aimbot_max_distance) then
				continue
			end

			local position = _WorldToViewportPoint(Camera, mainpart.Position)
			if not position then continue end
			local on_screen = position and position.Z > 0
			local distance = (
				_Vector2new(position.X, position.Y) - mousepos
			).Magnitude

			if (aimbot_screen_check or on_screen) and distance <= maximum_distance then
				table.insert(target_list, {mainpart, obj, obj, distance})
			end
		end
	end

	if aimbot_npc_check then
		table.sort(target_list, function(a, b)
			return (a[4] or 1/0) < (b[4] or 1/0)
		end)
		return target_list
	end

	if not get_targets_in_fov_npc_cache or os.clock() - (get_targets_in_fov_npc_time or 0) > 1 then
		get_targets_in_fov_npc_cache = {}
		if aimbot_npc_check then
			for _, aizone in project_delta.aizones:GetChildren() do
				for _, npc in aizone:GetChildren() do
					local root = _FindFirstChild(npc, "HumanoidRootPart")
					local humanoid = _FindFirstChildOfClass(npc, "Humanoid")
					local aimpart = _FindFirstChild(npc, aimbot_part or "Head")
					local mainpart = aimpart or root
					if mainpart then
						get_targets_in_fov_npc_cache[#get_targets_in_fov_npc_cache + 1] = { mainpart, humanoid, npc }
					end
				end
			end
		end
		get_targets_in_fov_npc_time = os.clock()
	end
	for _, cached in ipairs(get_targets_in_fov_npc_cache) do
		local mainpart, humanoid, npc = cached[1], cached[2], cached[3]
		if mainpart and mainpart.Parent then

			if (aimbot_dead_check) and (not humanoid or humanoid.Health <= 0) then
				continue
			end
			if (aimbot_dist_check) and ((campos - mainpart.Position).Magnitude > aimbot_max_distance) then
				continue
			end

			local position, on_screen = _WorldToViewportPoint(Camera, mainpart.Position)
			local distance = (
				_Vector2new(
					position.X, position.Y
				) - mousepos
			).Magnitude

			if (aimbot_screen_check or on_screen) and distance <= maximum_distance then
				table.insert(target_list, {mainpart, npc, npc, distance})
			end
		end
	end
	
	table.sort(target_list, function(a, b)
		return (a[4] or 1/0) < (b[4] or 1/0)
	end)
	return target_list
end)


local aimbot_mode = "Camera"
local target_part, target_player, target_character
local silent_forcehit = false
local instant_reload, instant_equip, instant_aim = false, false, false
local hit_sound, hit_sound_instance, hit_sound_speed, hit_sound_volume = false, cheat.hitsounds["Bameware"], 1, 1
local hit_logs, hit_logs_duration = false, 0
local no_recoil = false
local aimbot_hitchance, aimbot_hitbox_rand, aimbot_head_chance, recoil_humanizer = 100, false, 70, 0
local silent_aim_hit_part, silent_aim_hit_active = nil, false

local function randomized_hitbox(hitbox_character, default_part)
	if not (aimbot_hitbox_rand and hitbox_character) then
		return default_part
	end
	if math.random(100) <= aimbot_head_chance then
		for _, hitbox_name in ipairs({"Head", "FaceHitBox", "HeadTopHitBox"}) do
			local part = _FindFirstChild(hitbox_character, hitbox_name)
			if part then
				return part
			end
		end
	else
		for _, hitbox_name in ipairs({"UpperTorso", "LowerTorso"}) do
			local part = _FindFirstChild(hitbox_character, hitbox_name)
			if part then
				return part
			end
		end
	end
	return default_part
end

local function resolve_aim_point(aim_character, aim_part)
	local chosen_part = randomized_hitbox(aim_character, aim_part)
	local aim_point = chosen_part.Position
	if aimbot_hitchance < 100 and math.random(100) > aimbot_hitchance then
		local spread_cf = chosen_part.CFrame
		local spread = 1.5 + (Camera.CFrame.Position - aim_point).Magnitude * 0.06
		aim_point = aim_point
			+ spread_cf.RightVector * ((math.random() * 2 - 1) * spread)
			+ spread_cf.UpVector * ((math.random() * 2 - 1) * spread)
	end
	return aim_point
end
do
	local aimsec = ui.sections.aimbot_main
	local mscsec = ui.sections.aimbot_misc
	local samsec = ui.sections.aimbot_silent
	local effsec = ui.sections.aimbot_effects
	local gunsec = ui.sections.gunmods

	local aimbot_enabled, aimbot_enabled_key, aimbot_part, aimbot_smoothness = false, false, "Head", 0.7
	local aimbot_team_check, aimbot_dead_check, aimbot_dist_check, aimbot_max_distance, aimbot_npc_check, aimbot_visible_check, aimbot_screen_check = false, false, false, 600, false, false, false
	local fov_show, fov_color, fov_outline, fov_size, fov_sides = false, Color3.new(1,1,1), false, 100, 67
	local autoshoot, autoshoot_key, autowall = false, false, false
	local hitscan_hitboxes = {"FaceHitBox", "HeadTopHitBox", "Head"}

	local indicator = cheat.IndicatorLibrary:new_indicator()

	local heli_names = { ["MI24V"] = true, ["Mi-24V"] = true, ["Mi24V"] = true }
	local heli_cache_objects = nil
	local heli_cache_time = 0
	local heli_cache_interval = 2
	local heli_last_pilot = nil

	local function heli_find_root()
		local best, best_dist = nil, math.huge
		local cam_pos = Camera and Camera.CFrame and Camera.CFrame.Position
		for _, obj in ipairs(heli_cache_objects) do
			if obj:IsA("Model") and heli_names[obj.Name] then
				local root = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
				if root then
					local dist = cam_pos and (cam_pos - root.Position).Magnitude or 0
					if dist < best_dist then
						best, best_dist = root, dist
					end
				end
			end
		end
		return best
	end

	local function heli_find_pilot(heli_root)
		local best, best_dist = nil, math.huge
		local heli_pos = heli_root.Position
		local cam_pos = Camera and Camera.CFrame and Camera.CFrame.Position
		for _, obj in ipairs(heli_cache_objects) do
			if obj:IsA("Model") then
				local obj_root = obj:FindFirstChild("HumanoidRootPart")
				local hum = obj:FindFirstChildOfClass("Humanoid")
				if obj_root and hum and hum.Health > 0 then
					local dist = (obj_root.Position - heli_pos).Magnitude
					if dist <= 30 then
						local d = cam_pos and (cam_pos - obj_root.Position).Magnitude or 0
						if d < best_dist then
							best, best_dist = obj_root, d
						end
					end
				end
			end
		end
		return best
	end

	local function heli_pilot_target()
		local now = os.clock()
		if not heli_cache_objects or now - heli_cache_time > heli_cache_interval then
			heli_cache_time = now
			heli_cache_objects = workspace:GetDescendants()
			local root = heli_find_root()
			heli_last_pilot = root and heli_find_pilot(root) or nil
		end
		return heli_last_pilot
	end

	do
		local desync_resolver, angle_resolver = false, false

		local aim_keybind; aim_keybind = aimsec:Toggle({Name = "Enabled", Value = false, Flag = "aimbot_enable", Callback = function(bool)
			aimbot_enabled = bool
		end}):Keybind({Name = "Aimbot", Mode = "Hold", Key = Enum.KeyCode.E, Value = false, Flag = "aimbot_enabled_keybind", Callback = function(bool)
			aimbot_enabled_key = aimbot_enabled and bool
			aim_keybind.Set(aimbot_enabled_key, true)
		end})
		aimsec:Dropdown({Name = "Aim part", Values = {"Head", "UpperTorso"}, Value = "Head", Flag = "aimbot_hitpart", Multi = false, Callback = function(str)
			aimbot_part = str
		end})
		aimsec:Dropdown({Name = "Aim mode", Values = {"Camera", "Mouse", "Silent", "Crosshair"}, Value = "Camera", Flag = "aimbot_mode", Multi = false, Callback = function(str)
			aimbot_mode = str
		end})

		local skypeek, skypeek_height, skypeek_base = false, 30, nil
		local sk_keybind; sk_keybind = aimsec:Toggle({Name = "Sky peek", Value = false, Flag = "sky_peek", Callback = function(bool)
			skypeek = bool
			if bool then
				local c = LocalPlayer.Character
				local r = c and _FindFirstChild(c, "HumanoidRootPart")
				skypeek_base = r and r.Position.Y or nil
			else
				skypeek_base = nil
			end
		end}):Keybind({Name = "Sky peek", Mode = "Toggle", Key = Enum.KeyCode.Unknown, Value = false, Flag = "sky_peek_key", Callback = function(bool)
			sk_keybind.Set(skypeek and bool, true)
			if skypeek and bool then
				local c = LocalPlayer.Character
				local r = c and _FindFirstChild(c, "HumanoidRootPart")
				skypeek_base = r and r.Position.Y or skypeek_base
			end
		end})
		aimsec:Slider({Name = "Sky height", Min = 5, Max = 200, Float = 1, Value = 30, Suffix = "%sst", Callback = function(int)
			skypeek_height = int
		end})
		local tppeek, tppeek_height, tppeek_timeout, tppeek_base, tp_peek_key = false, 20, 1.5, nil, false
		local tppeek_handle
		local function tppeek_off()
			if tppeek then
				local c2 = LocalPlayer.Character
				local r2 = c2 and tppeek_base and _FindFirstChild(c2, "HumanoidRootPart")
				if r2 then r2.CFrame = tppeek_base end
				tppeek = false
				tppeek_base = nil
			end
			if tppeek_handle then tppeek_handle:Set(false, true) end
		end
		tppeek_handle = aimsec:Toggle({Name = "TP peek", Value = false, Flag = "tp_peek", Callback = function(bool)
			tppeek = bool
			if bool then
				local c = LocalPlayer.Character
				local r = c and _FindFirstChild(c, "HumanoidRootPart")
				if not r then tppeek_off() return end
				tppeek_base = r.CFrame
				r.CFrame = CFrame.new(r.Position + _Vector3new(0, tppeek_height, 0)) * (r.CFrame - r.CFrame.Position)
				task.delay(tppeek_timeout, function()
					tppeek_off()
				end)
			else
				tppeek_base = nil
			end
		end}):Keybind({Name = "TP peek", Mode = "Toggle", Key = Enum.KeyCode.Unknown, Value = false, Flag = "tp_peek_key", Callback = function(bool)
			tp_peek_key = tppeek and bool
		end})
		aimsec:Slider({Name = "TP height", Min = 5, Max = 100, Float = 1, Value = 20, Suffix = "%sst", Callback = function(int)
			tppeek_height = int
		end})
		aimsec:Slider({Name = "TP timeout", Min = 0.5, Max = 5, Float = 0.1, Value = 1.5, Suffix = "%ss", Callback = function(int)
			tppeek_timeout = int
		end})
		cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
			if not skypeek then return end
			local c = LocalPlayer.Character
			local r = c and _FindFirstChild(c, "HumanoidRootPart")
			if not (r and skypeek_base) then return end
			local cf = r.CFrame
			r.CFrame = CFrame.new(cf.X, skypeek_base + skypeek_height, cf.Z) * (cf - cf.Position)
		end))
		aimsec:Slider({Name = "Aim smoothness", Min = 0.01, Max = 1, Float = 0.01, Value = 0.7, Flag = "aimbot_smoothness", Suffix = "%sx" , Callback = function(int)
			aimbot_smoothness = int
		end})
		

		aimsec:Toggle({Name = "Desync resolver", Value = false, Flag = "desync_resolver", Callback = function(bool)
			desync_resolver = bool
		end})
		aimsec:Toggle({Name = "Angle resolver", Value = false, Flag = "angle_resolver", Callback = function(bool)
			angle_resolver = bool
		end})

		local player_list = cheat.player_list
		RunService.PreRender:Connect(LPH_JIT(function()
			if not (desync_resolver or angle_resolver) then return end
			for player, player_object in player_list do
				if player == LocalPlayer then continue end
				local server_position = player_object.server_position
				local character = player.Character
				local hrp = character and _FindFirstChild(character, "HumanoidRootPart")
				if desync_resolver and hrp and server_position then
					hrp.CFrame = _CFramenew(server_position) * hrp.CFrame.Rotation
				end
				if angle_resolver and character then
					character:SetAttribute("UpAngle", 0)
				end
			end
		end))
	end
	do
		mscsec:Dropdown({Name = "Checks", Values = {"Team check", "Dead check", "Distance check", "NPC check", "Include off-screen"}, Value = {}, Flag = "aimbot_checks", Multi = true, Callback = function(tbl)
			local funny = {
				["Team check"] = "team_check",
				["Dead check"] = "dead_check",
				["Distance check"] = "dist_check",
				["NPC check"] = "npc_check",
				["Include off-screen"] = "screen_check"
			}
			local uhh = {}
			for flag_text, esp_var in funny do
				uhh[esp_var] = false
			end
			for flag_text, esp_var in funny do
				for _, check_name in tbl do
					if (check_name ~= flag_text or uhh[esp_var]) then
						continue
					end
					uhh[esp_var] = true
				end
			end
			aimbot_team_check = uhh["team_check"]
			aimbot_dead_check = uhh["dead_check"]
			aimbot_dist_check = uhh["dist_check"]
			aimbot_npc_check = uhh["npc_check"]
			aimbot_screen_check = uhh["screen_check"]
		end})
		mscsec:Slider({Name = "Max distance", Min = 0, Max = 2000, Float = 10, Value = 200, Flag = "aimbot_max_distance", Callback = function(int)
			aimbot_max_distance = int * 3
		end})
		mscsec:Slider({Name = "Aim size", Min = 0, Max = 180, Float = 1, Value = 10, Flag = "aimbot_fov_size", Suffix = "%s\194\176" , Callback = function(int)
			fov_size = int
		end})

		mscsec:Toggle({Name = "Silent force-hit", Value = false, Flag = "silent_forcehit", Callback = function(bool)
			silent_forcehit = bool
		end})

		mscsec:Slider({Name = "Hit chance", Min = 0, Max = 100, Float = 1, Value = 100, Flag = "legit_hitchance", Suffix = "%s%%", Callback = function(int)
			aimbot_hitchance = int
		end})
		mscsec:Toggle({Name = "Random hitboxes", Value = false, Flag = "legit_hitbox_rand", Callback = function(bool)
			aimbot_hitbox_rand = bool
		end})
		mscsec:Slider({Name = "Head chance", Min = 0, Max = 100, Float = 1, Value = 70, Flag = "legit_head_chance", Suffix = "%s%%", Callback = function(int)
			aimbot_head_chance = int
		end})
		mscsec:Slider({Name = "Recoil humanizer", Min = 0, Max = 100, Float = 1, Value = 0, Flag = "legit_recoil_humanizer", Suffix = "%s%%", Callback = function(int)
			recoil_humanizer = int
		end})
		mscsec:Toggle({Name = "Underground resolver", Value = false, Flag = "underground_resolver", Callback = function(bool)
			underground_resolver = bool
		end})
		mscsec:Slider({Name = "Underground depth", Min = 0, Max = 50, Float = 1, Value = 8, Suffix = "%sst", Callback = function(int)
			underground_resolver_depth = int
		end})
		

		local autoshoot_keybind; autoshoot_keybind = mscsec:Toggle({Name = "Silent auto-shoot", Value = false, Flag = "aimbot_autoshoot", Callback = function(bool)
			autoshoot = bool
		end}):Keybind({Name = "Auto-shoot", Mode = "Toggle", Key = Enum.KeyCode.G, Value = false, Flag = "aimbot_autoshoot_keybind", Callback = function(bool)
			autoshoot_key = autoshoot and bool
			autoshoot_keybind.Set(autoshoot_key, true)
		end})

		mscsec:Toggle({Name = "Auto-wall penetration", Value = false, Flag = "silent_autowall", Callback = function(bool)
			autowall = bool
		end})

		mscsec:Dropdown({Name = "Auto-shoot hitscan", Values = {
			"FaceHitBox",
			"HeadTopHitBox",
			"Head",
			"UpperTorso",
			"LowerTorso",
			"LeftUpperArm",
			"LeftLowerArm",
			"LeftHand",
			"RightUpperArm",
			"RightLowerArm",
			"RightHand",
			"RightUpperLeg",
			"RightLowerLeg",
			"RightFoot",
			"LeftUpperLeg",
			"LeftLowerLeg",
			"LeftFoot"
		}, Value = {"FaceHitBox", "HeadTopHitBox", "Head"}, Flag = "aimbot_autoshoot_hitscan", Multi = true, Callback = function(tbl)
			hitscan_hitboxes = {}
			for index, hitbox in project_delta.hitboxes_priority do
				for _, chosen in tbl do
					if chosen ~= hitbox then
						continue
					end
					table.insert(hitscan_hitboxes, chosen)
				end
			end
		end})

		do
			local holdbullets_keybind; holdbullets_keybind = mscsec:Toggle({Name = "Hold bullets", Value = false, Flag = "aimbot_holdbullets", Callback = function(bool)
				holdbullets = bool
			end}):Keybind({Name = "fye \240\159\169\184\240\159\169\184\240\159\169\184", Mode = "Toggle", Key = Enum.KeyCode.X, Value = false, Flag = "aimbot_holdbullets_keybind", Callback = function(bool)
				holdbullets_key = holdbullets and bool
				holdbullets_keybind.Set(holdbullets_key, true)
			end})

			local main_wireframe = Instance.new("WireframeHandleAdornment")
			main_wireframe.Parent = game:GetService("CoreGui").RobloxGui
			main_wireframe.Adornee = workspace
			main_wireframe.Color3 = Color3.new(1, 1, 1)
			main_wireframe.Transparency = 0
			main_wireframe.AlwaysOnTop = true
			main_wireframe.CFrame = CFrame.new()
			main_wireframe.Scale = Vector3.one
			main_wireframe.Thickness = 1
			main_wireframe.AdornCullingMode = Enum.AdornCullingMode.Automatic

			cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
				main_wireframe:Clear()
			end))
		end
	end
	do
		local bullet_tracers, bullet_tracers_color = false, Color3.new(1, 1, 1)
		

		effsec:Toggle({Name = "Aimbot FOV", Value = false, Flag = "fov_enabled", Callback = function(bool)
			fov_show = bool
		end}):Colorpicker({Name = "FOV Color", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "fov_color", Callback = function(color)
			fov_color = color.c
		end})
		effsec:Toggle({Name = "FOV Outline", Value = false, Flag = "fov_outline", Callback = function(bool)
			fov_outline = bool
		end})
		effsec:Slider({Name = "FOV Sides", Min = 3, Max = 100, Float = 1, Value = 67, Flag = "fov_sides", Suffix = "%s", Callback = function(int)
			fov_sides = int
		end})

		do
			local inventory_holder = Instance.new("Frame")
			inventory_holder.Parent = game:GetService("CoreGui").RobloxGui
			inventory_holder.BackgroundColor3 = Color3.new(0, 0, 0)
			inventory_holder.BackgroundTransparency = 0.3
			inventory_holder.BorderSizePixel = 0
			inventory_holder.Position = UDim2.new(0, -GuiInset.X, 0, -GuiInset.Y)
			inventory_holder.Size = UDim2.new(0, 360, 0, 8)
			inventory_holder.AutomaticSize = Enum.AutomaticSize.Y
			inventory_holder.ZIndex = 2
			inventory_holder.Visible = false
			local inventory_cap = Instance.new("UISizeConstraint")
			inventory_cap.Parent = inventory_holder
			inventory_cap.MinSize = Vector2.new(360, 80)
			inventory_cap.MaxSize = Vector2.new(360, 640)
			local inventory_corner = Instance.new("UICorner")
			inventory_corner.Parent = inventory_holder
			inventory_corner.CornerRadius = UDim.new(0, 6)

			local inventory_default_font = Fonts.Get("SmallestPixel7")

			local inventory_scroll = Instance.new("ScrollingFrame")
			inventory_scroll.Parent = inventory_holder
			inventory_scroll.AnchorPoint = Vector2.new(0, 0)
			inventory_scroll.Position = UDim2.new(0, 4, 0, 4)
			inventory_scroll.Size = UDim2.new(1, -8, 0, 4)
			inventory_scroll.AutomaticSize = Enum.AutomaticSize.Y
			inventory_scroll.BackgroundTransparency = 1
			inventory_scroll.BorderSizePixel = 0
			inventory_scroll.ScrollBarThickness = 6
			inventory_scroll.ScrollBarImageColor3 = Color3.new(1, 1, 1)
			inventory_scroll.ScrollBarImageTransparency = 0.5
			inventory_scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			inventory_scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			inventory_scroll.ScrollingDirection = Enum.ScrollingDirection.Y
			inventory_scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

			local inventory_list = Instance.new("UIListLayout")
			inventory_list.Parent = inventory_scroll
			inventory_list.SortOrder = Enum.SortOrder.LayoutOrder
			inventory_list.Padding = UDim.new(0, 1)

			local inventory_font = inventory_default_font
			local inventory_textcolor = Color3.new(1, 1, 1)
			local inventory_textalpha = 0
			local inventory_textsize = 8

			local function inventory_apply_style(item)
				item.FontFace = inventory_font
				item.TextColor3 = inventory_textcolor
				item.TextTransparency = inventory_textalpha
				item.TextSize = inventory_textsize
			end

			local function inventory_addrow(text, color, height, layoutorder)
				local row = Instance.new("TextLabel")
				row.Parent = inventory_scroll
				row.BackgroundTransparency = 1
				row.BorderSizePixel = 0
				row.Size = UDim2.new(1, 0, 0, height)
				row.TextXAlignment = Enum.TextXAlignment.Left
				row.TextYAlignment = Enum.TextYAlignment.Center
				row.Text = text
				row.LayoutOrder = layoutorder or 0
				inventory_apply_style(row)
				if color then
					row.TextColor3 = color
					row.TextTransparency = inventory_textalpha
				end
				return row
			end

			local function inventory_clear()
				for _, child in inventory_scroll:GetChildren() do
					if child:IsA("TextLabel") or child:IsA("Frame") then
						child:Destroy()
					end
				end
			end

			effsec:Toggle({Name = "Inventory viewer", Value = false, Flag = "inventory_viewer", Callback = function(bool)
				inventory_holder.Visible = bool
			end}):Colorpicker({Name = "Viewer Color", Value = Color3.new(1, 1, 1), Usealpha = true, Flag = "inventory_viewer_color", Callback = function(color)
				inventory_textcolor = color.c
				inventory_textalpha = color.a
			end})
			effsec:Colorpicker({Name = "Background", Value = Color3.new(), Alpha = 0.7, Usealpha = true, Flag = "inventory_viewer_background", Callback = function(color)
				inventory_holder.BackgroundColor3 = color.c
				inventory_holder.BackgroundTransparency = color.a
			end})
			effsec:Dropdown({Name = "Viewer font", Values = {
				"Tahoma",
				"TahomaXP",
				"Comfortaa",
				"Verdana",
				"SmallestPixel7",
				"Proggy",
			}, Value = {"SmallestPixel7"}, Flag = "inventory_viewer_font", Multi = false, Callback = function(str)
				inventory_font = Fonts.Get(str or "SmallestPixel7") or inventory_default_font
			end})
			effsec:Slider({Name = "Viewer size", Min = 1, Max = 30, Float = 1, Value = 8, Flag = "inventory_viewer_size", Suffix = "%spx", Callback = function(int)
				inventory_textsize = int
			end})
			effsec:Slider({Name = "Viewer X", Min = 0, Max = 100, Float = 1, Value = 5, Flag = "inventory_viewer_x", Suffix = "%s%%", Callback = function(int)
				inventory_holder.Position = UDim2.new(int / 100, -GuiInset.X, inventory_holder.Position.Y.Scale, -GuiInset.Y)
			end})
			effsec:Slider({Name = "Viewer Y", Min = 0, Max = 100, Float = 1, Value = 5, Flag = "inventory_viewer_y", Suffix = "%s%%", Callback = function(int)
				inventory_holder.Position = UDim2.new(inventory_holder.Position.X.Scale, -GuiInset.X, int / 100, -GuiInset.Y)
				
			end})

			local player_list = cheat.player_list

			local weapon_slots = {
				ItemBack1 = 1,
				ItemBack2 = 2,
				ItemHip1 = 3,
				Melee = 4
			}

			local armor_slots = {
				ClothingHeadware = 1,
				ClothingChestRig = 2,
				ClothingMask = 3,
				ClothingLegArmor = 4
			}

			local get_weapon_loadedammo = LPH_NO_VIRTUALIZE(function(weapon)
				local weapon_loadedammo = weapon:GetAttribute("LoadedAmmo")
				if weapon_loadedammo then
					return weapon_loadedammo
				end

				local attachments = _FindFirstChild(weapon, "Attachments")
				if not attachments then
					return 0
				end

				for _, attachment in attachments:GetChildren() do
					local loadedammo = attachment:GetAttribute("LoadedAmmo")
					if loadedammo then
						return loadedammo
					end
				end

				return 0
			end)

			local get_player_inventory = LPH_NO_VIRTUALIZE(function(player)
				local player_object = player_list[player]
				local game_data = player_object and player_object.game_data
				if not game_data then
					return ""
				end

				local inventory = _FindFirstChild(game_data, "Inventory")
				if not (inventory) then
					return ""
				end

				

				
				local weapon, armor, inventoried, last = {}, {}, {}, {}
				for _, item in inventory:GetChildren() do
					local item_name = item.Name
					local slot = item:GetAttribute("Slot")
					if not slot then
						last[#last + 1] = {item_name}
						continue
					end

					local found_slot = weapon_slots[slot]
					if found_slot then
						local durability = item:GetAttribute("Durability") or 1
						local max_durability = item:GetAttribute("MaxDurability") or 1
						weapon[found_slot] = {item_name, get_weapon_loadedammo(item), mathfloor(durability / max_durability * 100)}
						continue
					end

					found_slot = armor_slots[slot]
					if found_slot then
						armor[found_slot] = {item_name}
					end

					local inventory = _FindFirstChild(item, "Inventory")
					if not inventory then
						if not found_slot then
							last[#last + 1] = {item_name}
						end
						continue
					end

					local current_inventory = {}
					inventoried[#inventoried + 1] = {item_name, current_inventory}

					for _, subitem in inventory:GetChildren() do
						local subitem_name = subitem.Name
						local amount = subitem:GetAttribute("Amount") or 1
						if current_inventory[subitem_name] then
							current_inventory[subitem_name] += amount
						else
							current_inventory[subitem_name] = amount
						end
					end
				end

				table.sort(inventoried, function(a, b)
					return a[1] < b[1]
				end)
				table.sort(last, function(a, b)
					return a[1] < b[1]
				end)

				

				return {
					Name = player.Name,
					Weapon = weapon,
					Armor = armor,
					Inventory = inventoried,
					Other = last,
				}
			end)
			local inventory_title_color = Color3.fromRGB(255, 255, 255)
			local inventory_section_colors = {
				Weapon = Color3.fromRGB(255, 130, 130),
				Armor = Color3.fromRGB(130, 205, 255),
				Inventory = Color3.fromRGB(255, 225, 130),
				Other = Color3.fromRGB(180, 180, 180),
			}

			local function inventory_header(text, color, layoutorder)
				local bar = Instance.new("Frame")
				bar.Parent = inventory_scroll
				bar.BackgroundColor3 = color
				bar.BackgroundTransparency = 0.82
				bar.BorderSizePixel = 0
				bar.Size = UDim2.new(1, 0, 0, 14)
				bar.LayoutOrder = layoutorder or 0

				local label = Instance.new("TextLabel")
				label.Parent = bar
				label.BackgroundTransparency = 1
				label.BorderSizePixel = 0
				label.Size = UDim2.new(1, -4, 1, 0)
				label.Position = UDim2.new(0, 4, 0, 0)
				label.Text = text
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.TextYAlignment = Enum.TextYAlignment.Center
				label.TextColor3 = Color3.new(1, 1, 1)
				inventory_apply_style(label)
				return bar
			end

			local invt_key = ""
			local invt_order = 0
			local inv_tick = 0

			cheat.utility.new_heartbeat(LPH_JIT(function(delta)
				if not inventory_holder.Visible then return end

				inv_tick += delta
				if inv_tick < 0.3 then return end
				inv_tick = 0

				local data = target_player and get_player_inventory(target_player)
				if type(data) ~= "table" then
					if invt_key ~= "" then
						inventory_clear()
						invt_key = ""
					end
					return
				end

				local player_object = player_list[target_player]
				local hp = nil
				local character = target_player and target_player.Character
				local hum = character and _FindFirstChildOfClass(character, "Humanoid")
				if hum and hum.Health > 0 then
					hp = math.floor(hum.Health / hum.MaxHealth * 100 + 0.5)
				end

				local key = data.Name
				key = key .. "|" .. (hp or "") .. "|" .. #data.Weapon .. #data.Armor .. #data.Inventory .. #data.Other
				for _, w in ipairs(data.Weapon) do key = key .. ";" .. tostring(w[1]) .. ":" .. tostring(w[2]) .. ":" .. tostring(w[3]) end
				for _, a in ipairs(data.Armor) do key = key .. ";" .. tostring(a[1]) end
				for _, inv in ipairs(data.Inventory) do
					key = key .. ";" .. tostring(inv[1])
					for sub, amt in pairs(inv[2]) do key = key .. ":" .. sub .. "=" .. tostring(amt) end
				end
				for _, o in ipairs(data.Other) do key = key .. ";" .. tostring(o[1]) end

				if key == invt_key then
					return
				end
				invt_key = key
				invt_order = 0

				inventory_clear()

				local function oj()
					invt_order = invt_order + 1
					return invt_order
				end

				local title = data.Name and (data.Name .. "'s Inventory") or "Inventory"
				if hp then
					title = title .. "  |  " .. "HP " .. tostring(hp) .. "%"
				end
				inventory_header(title, inventory_title_color, oj())

				if #data.Weapon > 0 then
					inventory_header("[ Weapons ]", inventory_section_colors.Weapon, oj())
					for _, item in ipairs(data.Weapon) do
						inventory_addrow("    " .. tostring(item[1] or "") .. "  |  ammo " .. tostring(item[2]) .. "  |  " .. tostring(item[3]) .. "%", nil, 16, oj())
					end
				end

				if #data.Armor > 0 then
					inventory_header("[ Armor ]", inventory_section_colors.Armor, oj())
					for _, item in ipairs(data.Armor) do
						inventory_addrow("    " .. tostring(item[1] or ""), nil, 16, oj())
					end
				end

				if #data.Inventory > 0 then
					inventory_header("[ Inventory ]", inventory_section_colors.Inventory, oj())
					for _, item in ipairs(data.Inventory) do
						inventory_addrow("    " .. tostring(item[1] or ""), inventory_section_colors.Inventory, 16, oj())
						for sub, amt in pairs(item[2]) do
							inventory_addrow("        " .. tostring(sub) .. "  x" .. tostring(amt), nil, 15, oj())
						end
					end
				end

				if #data.Other > 0 then
					inventory_header("[ Other ]", inventory_section_colors.Other, oj())
					for _, item in ipairs(data.Other) do
						inventory_addrow("    " .. tostring(item[1] or ""), nil, 16, oj())
					end
				end
			end))
		end

		effsec:Toggle({Name = "Bullet tracers", Value = false, Flag = "bullet_tracers", Callback = function(bool)
			bullet_tracers = bool
		end}):Colorpicker({Name = "FOV Color", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "bullet_tracers_color", Callback = function(color)
			bullet_tracers_color = color.c
		end})

		effsec:Toggle({Name = "Hit sound", Value = false, Flag = "hit_sound", Callback = function(bool)
			hit_sound = bool
		end})

		effsec:Slider({Name = "Hit sound volume", Min = 0.1, Max = 10, Float = 0.1, Value = 1, Flag = "hit_sound_volume", Suffix = "%s", Callback = function(int)
			hit_sound_volume = int
		end})
		effsec:Slider({Name = "Hit sound speed", Min = 0.1, Max = 3, Float = 0.1, Value = 1, Flag = "hit_sound_speed", Suffix = "%s", Callback = function(int)
			hit_sound_speed = int
		end})
		
		effsec:Dropdown({Name = "Hit sound selection", Values = (function()
			local hitsounds = {}
			for name, _ in cheat.hitsounds do
				table.insert(hitsounds, name)
			end
			return hitsounds
		end)(), Value = "Bameware", Flag = "hit_sound_id", Multi = false, Callback = function(str)
			hit_sound_instance = cheat.hitsounds[str]
		end})
		
		effsec:Toggle({Name = "Hit logs", Value = false, Flag = "hit_logs", Callback = function(bool)
			hit_logs = bool
		end})
		effsec:Slider({Name = "Log duration", Min = 0, Max = 10, Float = 0.1, Value = 5, Flag = "hit_logs_duration", Suffix = "%ss", Callback = function(int)
			hit_logs_duration = int
		end})

		do
			local picture_on_kill, picture_on_kill_no_background, picture_duration, fade_duration = false, false, 0.05, 0.5

			effsec:Toggle({Name = "Picture on kill", Value = false, Flag = "picture_on_kill", Callback = function(bool)
				picture_on_kill = bool
			end})
			effsec:Toggle({Name = "No picture background", Value = false, Flag = "picture_on_kill_no_background", Callback = function(bool)
				picture_on_kill_no_background = bool
			end})
			effsec:Slider({Name = "Picture duration", Min = 0, Max = 10, Float = 0.1, Value = 0.05, Flag = "picture_on_kill_duration", Suffix = "%ss", Callback = function(int)
				picture_duration = int
			end})
			effsec:Slider({Name = "Picture fade duration", Min = 0, Max = 10, Float = 0.1, Value = 5, Flag = "picture_on_kill_fade_duration", Suffix = "%ss", Callback = function(int)
				fade_duration = int
			end})
			effsec:Button({Name = "Reload pictures", Confirm = false, Callback = function()
				PicturesOnKill.Reload()
			end})
			effsec:Button({Name = "Download furries", Confirm = false, Callback = function()
				Library.Notification("no", 2.5)
			end})
			if firesignal then
				effsec:Button({Name = "Test picture on kill", Confirm = false, Callback = function()
					local success = pcall(firesignal, game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("NotificationMessage").OnClientEvent, "Killed", 1, 5)
					if not success then
						Library.Notification("Failed to test. (firesignal errored)", 2.5)
					end
				end})
			end

			local TweenService = game:GetService("TweenService")

			local PictureHolder = Instance.new("ScreenGui", game:GetService("CoreGui"))
			PictureHolder.ResetOnSpawn = false
			PictureHolder.IgnoreGuiInset = true

			game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("NotificationMessage").OnClientEvent:Connect(function(text, duration, color)
				if picture_on_kill and (text:find("Killed") or text:find("Incapacitated")) then
					task.spawn(function()
						local imagelabel = Instance.new("ImageLabel")
						imagelabel.Image = PicturesOnKill.GetNextPicture()
						imagelabel.Size = UDim2.new(1, 0, 1, 0)
						imagelabel.Position = UDim2.new(0, 0, 0, 0)
						imagelabel.BackgroundTransparency = picture_on_kill_no_background and 1 or 0
						imagelabel.ImageTransparency = 0
						imagelabel.Parent = PictureHolder

						task.wait(picture_duration)
					
						local connection; connection = RunService.RenderStepped:Connect(function(d)
							if imagelabel.BackgroundTransparency < 1 then
								imagelabel.BackgroundTransparency += d * (1/fade_duration)
							end
							if imagelabel.ImageTransparency < 1 then
								imagelabel.ImageTransparency += d * (1/fade_duration)
							else
								connection:Disconnect()
								imagelabel:Destroy()
							end
						end)
					end)
				end
			end)
		end

		local make_beam = cheat.make_beam
		local bullet_module = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules").FPS.Bullet)
		local old_createbullet = bullet_module.CreateBullet

		local fake_part = Instance.new("Part")
		fake_part.Anchored = true
		fake_part.Parent = game:GetService("ReplicatedStorage")

		bullet_module.CreateBullet = LPH_NO_VIRTUALIZE(function(...)
			local args = {...}
			fake_part.CFrame = args[5].CFrame
			args[5] = fake_part
			
			local origin = project_delta.get_estimated_origin(LocalPlayer)

			if aimbot_mode == "Silent" and target_part then
				silent_aim_hit_active = false
				local hit_part = randomized_hitbox(target_character, target_part)
				if silent_forcehit or aimbot_hitchance >= 100 or math.random(100) <= aimbot_hitchance then
					silent_aim_hit_part = hit_part
					silent_aim_hit_active = true
					fake_part.CFrame = CFrame.lookAt(origin, silent_aim_hit_part.Position)
				end
			end
			if bullet_tracers then
				make_beam(origin, origin + fake_part.CFrame.LookVector * 3300, bullet_tracers_color)
			end
			return old_createbullet(unpack(args))
		end)
	end
	do
		local force_auto, rapid_fire, rapid_fire_speed, loadbyhand_delay, loadbyhand_async = false, false, 1/60, 0.15, false

		local spring_disablers = {
			["sprintCycle"] = false,
			["leanAlpha"] = false,
			["strafeTilt"] = false,
			["walkCycle"] = false,
			["jumpCameraTilt"] = false,
			["recoilRot"] = false,
			["gunSway"] = false,
			["jumpTilt"] = false,
			["cameraRecoil"] = false,
			["recoilPos"] = false,
			["wallTouchTilt"] = false,
			["sway"] = false
		}
		local aliases = {
			["Recoil"] = {"recoilPos", "recoilRot", "cameraRecoil"},
			["Bobbing"] = {"sprintCycle", "walkCycle", "jumpTilt"},
			["Sway"] = {"gunSway", "sway", "strafeTilt"},
			["Jump shake"] = {"jumpCameraTilt"},
			["Wall touch"] = {"wallTouchTilt"}
		}
		gunsec:Dropdown({Name = "Removals", Values = (function()
			local new = {}
			for i, v in aliases do
				new[#new + 1] = i
			end
			return new
		end)(), Value = {}, Flag = "gunmods_removals", Multi = true, Callback = function(tbl)
			no_recoil = false
			for spring_name, value in spring_disablers do
				spring_disablers[spring_name] = false
			end
			for _, alias in tbl do
				if alias == "Recoil" then
					no_recoil = true
				end
				for _, spring_name in aliases[alias] do
					spring_disablers[spring_name] = true
				end
			end
		end})
		gunsec:Toggle({Name = "Instant reload", Value = false, Flag = "gunmods_instant_reload", Callback = function(bool)
			instant_reload = bool
		end})
		gunsec:Toggle({Name = "LBH async delay", Value = false, Flag = "gunmods_loadbyhand_async", Callback = function(bool)
			loadbyhand_async = bool
		end})
		gunsec:Slider({Name = "LBH delay", Min = 0, Max = 0.5, Float = 0.01, Value = 0.15, Flag = "gunmods_loadbyhand_delay", Suffix = "%ss", Callback = function(int)
			loadbyhand_delay = int
		end})
		gunsec:Toggle({Name = "Instant equip", Value = false, Flag = "gunmods_instant_equip", Callback = function(bool)
			instant_equip = bool
		end})
		gunsec:Toggle({Name = "Instant aim", Value = false, Flag = "gunmods_instant_aim", Callback = function(bool)
			instant_aim = bool
		end})

		gunsec:Toggle({Name = "Force auto", Value = false, Flag = "gunmods_force_auto", Callback = function(bool)
			force_auto = bool
		end})
		gunsec:Toggle({Name = "Rapid fire", Value = false, Flag = "gunmods_rapid_fire", Callback = function(bool)
			rapid_fire = bool
		end})
		gunsec:Slider({Name = "Rounds per second", Min = 10, Max = 100, Float = 1, Value = 60, Flag = "gunmods_rapid_fire_speed", Suffix = "1s/%s", Callback = function(int)
			rapid_fire_speed = 1/int
		end})

		do
			local auto_reload, auto_refill = false

			local newlclosure = newlclosure or LPH_NO_VIRTUALIZE(function(f)
				return function(...)
					return f(...)
				end
			end)

			local success, old_remove
			success, old_remove = pcall(hookfunction, project_delta.remove_bullet, newlclosure(function(fps_object, ...)
				local hmm = {old_remove(fps_object, ...)}

				if not auto_reload then
					return unpack(hmm)
				end
				if fps_object.Bullets > 0 then
					return unpack(hmm)
				end

				task.spawn(fps_object.reload, fps_object)

				return unpack(hmm)
			end))

			if not success then
				print("failed to hook remove_bullet", old_remove, getgenv().newlclosure)
			else
				
				gunsec:Toggle({Name = "Auto reload", Value = false, Flag = "gunmods_auto_reload", Callback = function(bool)
					auto_reload = bool
				end})
				
			end
		end

		local old_reload_magazine, old_reload_loadbyhand = project_delta.fps_reloadtypes.magazine, project_delta.fps_reloadtypes.loadByHand
		local get_compatible_mag, get_compatible_ammo = project_delta.get_compatible_mag, project_delta.get_compatible_ammo
		local update_fps = project_delta.update_fps or function() end

		local reload_remote, inventorymove_remote, equip_remote = project_delta.reload_remote, project_delta.inventorymove_remote, project_delta.equip_remote

		local local_gameplayvars, lpo = project_delta.local_game_data.Status.GameplayVariables, cheat.player_list[LocalPlayer]

		project_delta.fps_reloadtypes.magazine = LPH_JIT(function(fps_object, arg_mag)
			if not instant_reload then
				return old_reload_magazine(fps_object, arg_mag)
			end

			local mag = arg_mag or get_compatible_mag(fps_object)
			if not mag then
				return
			end

			local equipped_item = lpo.current_weapon
			local equip_id = local_gameplayvars:GetAttribute("EquipId")
			if not (equipped_item and equip_id) then
				return
			end


			
			equip_remote:FireServer()
			task.defer(function()
				local s = 0
				local oldparent = mag.Parent
				repeat
					s += task.wait()
				until s > 1 or (mag and oldparent and mag.Parent and mag.Parent ~= oldparent)
				if s > 1 then
					return print('reload timeout, terminating...')
				end
				update_fps(project_delta.fps_object)
			end)
			inventorymove_remote:FireServer(
				mag:GetAttribute("Slot") or mag:GetAttribute("SlotType"),
				"Magazine",
				mag.Parent,
				equipped_item.Attachments,
				nil
			)
			equip_remote:FireServer(equipped_item, equip_id)
		end)

		project_delta.fps_reloadtypes.loadByHand = LPH_JIT(function(fps_object, arg_ammo)
			if not instant_reload then
				return old_reload_loadbyhand(fps_object, arg_ammo)
			end

			local ammo, ammo_amount = get_compatible_ammo(fps_object, arg_ammo)
			
			if not ammo then
				return
			end
			for i = 0, ammo_amount - 1 do
				if loadbyhand_async then
					reload_remote:InvokeServer(nil, 1, ammo)
					update_fps(fps_object)
				else
					task.delay(i * loadbyhand_delay, function()
						reload_remote:InvokeServer(nil, 1, ammo)
						update_fps(fps_object)
					end)
				end
			end
		end)

		project_delta.add_fps_hook(function()
			local fps_object = project_delta.fps_object
			for name, spring in fps_object.springs do
				local old_shove, old_update = spring.shove, spring.update
				spring.shove = LPH_NO_VIRTUALIZE(function(...)
					if spring_disablers[name] then return end
					return old_shove(...)
				end)
				spring.update = LPH_NO_VIRTUALIZE(function(...)
					if spring_disablers[name] then
						if recoil_humanizer > 0 and (name == "recoilPos" or name == "recoilRot" or name == "cameraRecoil") then
							local ok_update, update_result = pcall(old_update, ...)
							if ok_update and typeof(update_result) == "Vector3" then
								return update_result * ((recoil_humanizer / 100) * (0.4 + math.random() * 0.6))
							end
							return ok_update and update_result or Vector3.zero
						end
						return Vector3.zero
					end
					return old_update(...)
				end)
			end
		end)

		local old_updateclient
		local new_update = LPH_NO_VIRTUALIZE(function(fps_object, delta)
			if instant_aim then
				fps_object.AimInSpeed = 0
				fps_object.AimOutSpeed = 0
			end
			if force_auto or rapid_fire then
				if rapid_fire then fps_object.FireRate = rapid_fire_speed end
				local firemodes = fps_object.FireModes or {"Auto"}
				for i = 1, #firemodes do
					firemodes[i] = "Auto"
				end
				fps_object.FireModes = firemodes
			end
			return old_updateclient(fps_object, delta)
		end)

		project_delta.add_fps_hook(function()
			local fps_object = project_delta.fps_object
			old_updateclient = fps_object.updateClient
			fps_object.updateClient = new_update
		end)
	end

	local CircleOutline = cheat.utility.new_drawing("Circle", {
		Thickness = 3,
		Color = Color3.new(),
		ZIndex = 1
	})
	local CircleInline = cheat.utility.new_drawing("Circle", {
		Transparency = 1,
		Thickness = 1,
		ZIndex = 2
	})

	local ammo_types = {}
	for i, v in game:GetService("ReplicatedStorage").AmmoTypes:GetChildren() do
		ammo_types[v.Name] = v
	end

	local fps_usetypes, get_estimated_origin = project_delta.fps_usetypes, project_delta.get_estimated_origin
	local is_visible, valid_hitboxes = cheat.is_visible, project_delta.hitboxes
	local target_wall_penetration = project_delta.target_wall_penetration
	task.spawn(LPH_NO_VIRTUALIZE(function()
		local fallback_list = {}
		while task.wait(0.03) do
			local indtxt = ""

			target_part, target_player, target_character = nil, nil, nil

			do
				local genv0 = (getgenv and getgenv() or _G)
				if genv0.zzzhub_legit then
					indicator.text = indtxt
					continue
				end
			end
			if not aimbot_enabled then
				indicator.text = indtxt
				continue
			end

			local heli_ovr_part = heli_pilot_target()
			local heli_ovr_active = heli_ovr_part and heli_ovr_part.Parent
			if heli_ovr_active then
				target_part, target_player, target_character = heli_ovr_part, nil, heli_ovr_part.Parent
			else
				if aimbot_mode == "Crosshair" then
					local char = LocalPlayer.Character
					local origin = Camera.CFrame.Position
					local params = RaycastParams.new()
					params.FilterType = Enum.RaycastFilterType.Exclude
					local filter = {Camera}
					if char then table.insert(filter, 1, char) end
					params.FilterDescendantsInstances = filter
					params.IgnoreWater = true
					local range = (aimbot_dist_check and aimbot_max_distance > 0) and aimbot_max_distance or 1000
					local hit = workspace:Raycast(origin, Camera.CFrame.LookVector * range, params)
					local hpart = hit and hit.Instance
					local hmodel = hpart and hpart.Parent
					while hmodel and not _FindFirstChildOfClass(hmodel, "Humanoid") do
						hmodel = hmodel.Parent
					end
					local hum = hmodel and _FindFirstChildOfClass(hmodel, "Humanoid")
					local plr = hmodel and Players:GetPlayerFromCharacter(hmodel)
					if hpart and hmodel and hum and plr and plr ~= LocalPlayer then
						local ok = true
						if aimbot_team_check and cheat.EspLibrary.get_team(plr) then ok = false end
						if ok and aimbot_dead_check and hum.Health <= 0 then ok = false end
						if ok and aimbot_dist_check and ((origin - hpart.Position).Magnitude > aimbot_max_distance) then ok = false end
						if ok then
							local ap = _FindFirstChild(hmodel, aimbot_part or "Head") or hpart
							target_part, target_player, target_character = ap, plr, hmodel
							fallback_list = {{ap, plr, hmodel}}
						end
					end
				else
					local max_overall_distance = (Camera.ViewportSize.X * (fov_size / Camera.FieldOfView)) / 2
					fallback_list = get_targets_in_fov(max_overall_distance, aimbot_part, aimbot_team_check, aimbot_dead_check, aimbot_dist_check, aimbot_max_distance, aimbot_npc_check, aimbot_screen_check)
					if #fallback_list > 0 then
						target_part, target_player, target_character = unpack(fallback_list[1])
					end
				end
			end

			if aimbot_mode ~= "Silent" and aimbot_mode ~= "Crosshair" then continue end

			if not (autoshoot and autoshoot_key and target_part) then continue end

			local character = LocalPlayer.Character
			local hrp = character and _FindFirstChild(character, "HumanoidRootPart")
			local hmm_origin = hrp and get_estimated_origin(LocalPlayer)

			if not hmm_origin then continue end
			
			local picked_target = false

			local fps_object = project_delta.fps_object
			local bullet_type, penetration_power
			if autowall then
				if fps_object and fps_object.Bullets and fps_object.Bullets > 0 then
					local bullets_list = fps_object.BulletsList
					if bullets_list and #bullets_list > 0 then
						local last = #bullets_list
						if bullets_list[last] and bullets_list[last].Amount > 0 then
							bullet_type = bullets_list[last].AmmoType
						elseif bullets_list[last - 1] then
							bullet_type = bullets_list[last - 1].AmmoType
						end
					end
				end
				if bullet_type then
					bullet_stats = ammo_types[bullet_type]
				end
			end

			if heli_ovr_active then
				picked_target = true
			else
				local checked = 0
				for _, target in fallback_list do
					checked += 1
					if checked > 3 then break end
					local aimpart, player, character, distance = unpack(target)

				for _, hitbox in hitscan_hitboxes do
					local hitscan_part = _FindFirstChild(character, hitbox)
					if not hitscan_part then continue end
					
					if autowall and bullet_stats then
						if not target_wall_penetration(hmm_origin, character, hitscan_part, hitscan_part.Position, bullet_stats) then continue end
						
						target_part, target_player, target_character = hitscan_part, player, character
						picked_target = true

						break
					end
					local vis, res = is_visible(hmm_origin, character, hitscan_part)
					if not (vis and valid_hitboxes[res.Instance.Name]) then continue end
					
					target_part, target_player, target_character = hitscan_part, player, character
					picked_target = true

					break
				end

				if picked_target then
					break
				end
				end

			end

			if not picked_target then
				continue
			end
			
			local fps_object = project_delta.fps_object
			local use_module_name = fps_object and fps_object.useModuleName
			local use_func = use_module_name and fps_usetypes[use_module_name]
			if type(fps_object) == "table" and use_module_name == "RangedWeaponDefault" then
				pcall(use_func, fps_object)
			end
		end
	end))
	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
		local mpos = UserInputService:GetMouseLocation()
		if fov_show then
			local viewportsize = Camera.ViewportSize
			local new_fov_size = (viewportsize.X * (fov_size / Camera.FieldOfView)) / 2

			CircleInline.Position = mpos
			CircleInline.Radius = new_fov_size
			CircleInline.Color = fov_color
			CircleInline.Visible = true
			CircleInline.NumSides = fov_sides

			CircleOutline.Position = mpos
			CircleOutline.Radius = new_fov_size
			CircleOutline.Visible = fov_outline
			CircleOutline.NumSides = fov_sides
		else
			CircleInline.Visible = false
			CircleOutline.Visible = false
		end
		if aimbot_enabled and aimbot_enabled_key and target_part and target_character then
			local new_pos = resolve_aim_point(target_character, target_part)
			if aimbot_mode == "Mouse" then
				local pos = _WorldToViewportPoint(Camera, new_pos)
				local mpos = UserInputService:GetMouseLocation()
				mousemoverel(math.ceil((pos.X - mpos.X) * aimbot_smoothness), math.ceil((pos.Y - mpos.Y) * aimbot_smoothness))
			end
			if aimbot_mode == "Camera" then
				Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, new_pos), aimbot_smoothness)
			end
			-- Crosshair mode: already aiming at target, no camera move needed
		end
	end))
end

do
	local sknsec = ui.sections.skins_items
	local sknsec_right = ui.sections.skins_cats
	local skins_folder = game:GetService("ReplicatedStorage"):FindFirstChild("Skins")
	local skin_helpers = { Textures = true, Materials = true, SubParts = true, SpecialProperties = true }
	local skin_item_name, skin_skin_name, skin_category = nil, nil, "All"
	local skin_choices = {}
	local skin_last_item, skin_last_skin = nil, nil
	local skin_item_dropdown, skin_skin_dropdown, skin_category_dropdown
	local skin_paint_family_live 
	local skin_cfg_name = "skinchanger_cfg.txt"
	local function skin_save_choices()
		local lines = {}
		for k, v in pairs(skin_choices) do
			lines[#lines + 1] = k .. "=" .. v
		end
		if skin_last_item and skin_last_skin then
			lines[#lines + 1] = "!" .. skin_last_item .. "=" .. skin_last_skin
		end
		pcall(writefile, skin_cfg_name, table.concat(lines, "\n"))
	end
	local function skin_load_choices()
		local ok, data = pcall(readfile, skin_cfg_name)
		if not (ok and data and #data > 0) then return false end
		for line in string.gmatch(data, "[^\n]+") do
			local last = string.sub(line, 1, 1) == "!"
			local s = last and string.sub(line, 2) or line
			local eq = string.find(s, "=", 1, true)
			if eq then
				local k, v = string.sub(s, 1, eq - 1), string.sub(s, eq + 1)
				if #k > 0 and #v > 0 then
					skin_choices[k] = v
					if last then skin_last_item, skin_last_skin = k, v end
				end
			end
		end
		return true
	end

	local function skin_get_inventory()
		local players_folder = game:GetService("ReplicatedStorage"):FindFirstChild("Players")
		local rs_player = players_folder and LocalPlayer and players_folder:FindFirstChild(LocalPlayer.Name)
		return rs_player and rs_player:FindFirstChild("Inventory")
	end

	local function skin_find_entry(inv_item)
		if not (skins_folder and inv_item and inv_item.Value) then return nil end
		local entry = skins_folder:FindFirstChild(inv_item.Value.Name)
		if entry then return entry end
		local tpmodels = game:GetService("ReplicatedStorage"):FindFirstChild("ThirdPersonModels")
		local tpmodel = tpmodels and tpmodels:FindFirstChild(inv_item.Value.Name)
		if tpmodel and tpmodel:FindFirstChild("DamagePoint", true) then
			return skins_folder:FindFirstChild("Melee")
		end
		return nil
	end

	local function skin_get_inv_items(name)
		local out = {}
		local inventory = skin_get_inventory()
		if not (inventory and name and skins_folder) then return out end
		for _, obj in ipairs(inventory:GetChildren()) do
			if obj:IsA("ObjectValue") and obj.Value then
				if obj.Value.Name == name then
					out[#out + 1] = obj
				else
					local entry = skin_find_entry(obj)
					if entry and entry.Name == name then
						out[#out + 1] = obj
					end
				end
			end
		end
		return out
	end

	local function skin_item_category(name)
		if name == "Melee" then return "Melee" end
		if name == "Lighter" then return "Misc" end
		local itemslist = game:GetService("ReplicatedStorage"):FindFirstChild("ItemsList")
		local def = itemslist and name and itemslist:FindFirstChild(name)
		local ip = def and def:FindFirstChild("ItemProperties")
		local cat = ip and ip:GetAttribute("ItemType")
		if cat then return cat end
		return "Other"
	end

	local skin_cat_order = { Melee = 1, Weapon = 2, Attachment = 3, Magazine = 4, Clothing = 5, Helmet = 6, Vest = 7, Misc = 8, Other = 9 }
	local function skin_category_names()
		local out = {}
		local seen = {}
		if not skins_folder then return { "All" } end
		for _, child in ipairs(skins_folder:GetChildren()) do
			if child:IsA("Folder") and not skin_helpers[child.Name] then
				local cat = skin_item_category(child.Name)
				if not seen[cat] then
					seen[cat] = true
					out[#out + 1] = cat
				end
			end
		end
		table.sort(out, function(a, b)
			local oa, ob = skin_cat_order[a] or 50, skin_cat_order[b] or 50
			if oa ~= ob then return oa < ob end
			return a < b
		end)
		table.insert(out, 1, "All")
		out[#out + 1] = "Full Builds"
		return out
	end

	local skin_build_bases = { "M4", "AKMN", "AKM", "SVD", "AsVal", "Groza", "TFZ98S", "R700", "PKM", "Mosin", "MP5SD", "Saiga12", "FAL", "ADAR15" }

	local function skin_item_names()
		local out = {}
		if not skins_folder then return out end
		if skin_category == "Full Builds" then
			for _, name in ipairs(skin_build_bases) do
				local f = skins_folder:FindFirstChild(name)
				if f and f:IsA("Folder") then out[#out + 1] = name end
			end
			return out
		end
		for _, child in ipairs(skins_folder:GetChildren()) do
			if child:IsA("Folder") and not skin_helpers[child.Name] then
				if skin_category == "All" or skin_item_category(child.Name) == skin_category then
					out[#out + 1] = child.Name
				end
			end
		end
		table.sort(out)
		return out
	end

	local function skin_skin_names(item_name)
		local out = {}
		local entry = skins_folder and item_name and skins_folder:FindFirstChild(item_name)
		if not entry then return out end
		for _, child in ipairs(entry:GetChildren()) do
			if child:IsA("Folder") and not skin_helpers[child.Name] then
				out[#out + 1] = child.Name
			end
		end
		table.sort(out)
		return out
	end

	local function skin_collect_parts(model)
		local out = {}
		if not model then return out end
		for _, part in ipairs(model:GetDescendants()) do
			if (part:IsA("MeshPart") or part:IsA("BasePart")) and part:GetAttribute("Skinnable") then
				out[#out + 1] = part
			end
		end
		return out
	end

	local skin_template_backup = {}
	local skin_tool_backup = {}
	local skin_last_error = "none"

	local function skin_find_template(name)
		if not name then return nil end
		local rs = game:GetService("ReplicatedStorage")
		local tpmodels = rs:FindFirstChild("ThirdPersonModels")
		local tpl = tpmodels and tpmodels:FindFirstChild(name)
		if tpl then return tpl end
		local ilmodels = rs:FindFirstChild("ItemsListModels")
		return ilmodels and ilmodels:FindFirstChild(name) or nil
	end

	local function skin_edit_template(tpl_name, src_name)
		local rs = game:GetService("ReplicatedStorage")
		local tpmodels = rs:FindFirstChild("ThirdPersonModels")
		local ilmodels = rs:FindFirstChild("ItemsListModels")
		for _, folder in ipairs({ tpmodels, ilmodels }) do
			local tpl = folder and tpl_name and folder:FindFirstChild(tpl_name)
			if not tpl then continue end
			if tpl:GetAttribute("SkinTemplateEdit") == src_name then continue end
			local key = folder.Name .. "/" .. tpl_name
			if src_name == tpl_name then
				local b = skin_template_backup[key]
				if b then
					local rc = b:Clone()
					rc.Name = tpl_name
					rc.Parent = folder
					tpl:Destroy()
				end
				continue
			end
			if not skin_template_backup[key] then
				skin_template_backup[key] = tpl:Clone()
			end
			local src = folder:FindFirstChild(src_name)
			if not src then continue end
			local ok, nc = pcall(function()
				return src:Clone()
			end)
			if not (ok and nc) then continue end
			nc.Name = tpl_name
			for _, d in ipairs(nc:GetDescendants()) do
				if d:IsA("BasePart") then
					d.Anchored = false
					d.CanCollide = false
					d.CanTouch = false
					d.CanQuery = false
					d.Massless = true
				end
			end
			nc:SetAttribute("SkinTemplateEdit", src_name)
			nc.Parent = folder
			tpl:Destroy()
		end
	end

	local function skin_apply_model_skin(skin, model, base_name, edit_template)
		if not (skin and model and model.Parent) then return end
		local src_name = skin:GetAttribute("ModelSkin") or skin.Name
		if not src_name then return end
		if edit_template ~= false and base_name then
			pcall(skin_edit_template, base_name, src_name)
		end
		if edit_template ~= false then
			local itemslist = rs:FindFirstChild("ItemsList")
			local src_def = itemslist and itemslist:FindFirstChild(src_name)
			local dst_def = itemslist and base_name and itemslist:FindFirstChild(base_name)
			local src_ip = src_def and src_def:FindFirstChild("ItemProperties")
			local dst_ip = dst_def and dst_def:FindFirstChild("ItemProperties")
			local src_tool = src_ip and src_ip:FindFirstChild("Tool")
			local dst_tool = dst_ip and dst_ip:FindFirstChild("Tool")
			if src_tool and dst_tool then
				if src_tool == dst_tool then
					local b = skin_tool_backup[dst_tool]
					if b then
						for k, v in pairs(b) do
							pcall(function()
								dst_tool:SetAttribute(k, v)
							end)
						end
					end
				else
					if not skin_tool_backup[dst_tool] then
						local b = {}
						for k, v in pairs(dst_tool:GetAttributes()) do
							b[k] = v
						end
						skin_tool_backup[dst_tool] = b
					end
					for k, v in pairs(src_tool:GetAttributes()) do
						pcall(function()
							dst_tool:SetAttribute(k, v)
						end)
					end
				end
			end
		end
		if model:GetAttribute("SkinSwapped") == src_name then skin_last_error = "already swapped " .. tostring(src_name) return end
		local src = skin_find_template(src_name)
		if not src then skin_last_error = "no src " .. tostring(src_name) return end
		local src_root = src:FindFirstChild("ItemRoot", true)
		local old_root = model:FindFirstChild("ItemRoot", true)
		if not (src_root and old_root and old_root:IsA("BasePart")) then skin_last_error = "no root src=" .. tostring(src_root ~= nil) .. " old=" .. tostring(old_root ~= nil) .. " for " .. tostring(src_name) return end
		local ok, clone = pcall(function()
			return src:Clone()
		end)
		if not (ok and clone) then skin_last_error = "clone fail " .. tostring(src_name) return end
		clone.Name = model.Name
		for _, d in ipairs(clone:GetDescendants()) do
			if d:IsA("BasePart") then
				d.Anchored = false
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
				d.Massless = true
			end
		end
		local clone_root = clone:FindFirstChild("ItemRoot", true)
		if clone_root and clone_root:IsA("BasePart") then
			pcall(function()
				clone:PivotTo(model:GetPivot())
				clone_root.CFrame = old_root.CFrame
			end)
		end
		local itemslist = game:GetService("ReplicatedStorage"):FindFirstChild("ItemsList")
		local src_def = itemslist and itemslist:FindFirstChild(src_name)
		local src_ip = src_def and src_def:FindFirstChild("ItemProperties")
		local off3p = src_ip and src_ip:GetAttribute("Offset3P")
		local offFP = src_ip and src_ip:GetAttribute("OffsetFP")
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("Motor6D") or d:IsA("Weld") or d:IsA("WeldConstraint") then
				pcall(function()
					local p1 = d.Part1
					if p1 and p1:IsDescendantOf(model) then
						local target = nil
						if p1 == old_root then
							target = clone_root
						else
							target = clone:FindFirstChild(p1.Name, true)
						end
						if target and target:IsA("BasePart") then
							local nm = d:Clone()
							nm.Part0 = d.Part0
							nm.Part1 = target
							nm.Parent = target
							if nm:IsA("Motor6D") or nm:IsA("Weld") then
								if nm.Part0 and nm.Part0.Name == "UpperTorso" then
									if off3p then
										nm.C1 = off3p
									end
								elseif offFP then
									nm.C1 = offFP
								end
							end
						end
					end
				end)
			end
		end
		for k, v in pairs(model:GetAttributes()) do
			if k ~= "SkinSwapped" then
				pcall(function()
					clone:SetAttribute(k, v)
				end)
			end
		end
		local invs = skin_get_inv_items(base_name)
		if #invs > 0 then
			local ref = clone:FindFirstChild("SelfRef")
			if not ref then
				ref = Instance.new("ObjectValue")
				ref.Name = "SelfRef"
				ref.Parent = clone
			end
			ref.Value = invs[1]
		end
		clone:SetAttribute("SkinSwapped", src_name)
		clone.Parent = model.Parent
		model:Destroy()
	end

	local function skin_collect_parts(model)
		
		local out = {}
		if not model then return out end
		for _, child in ipairs(model:GetChildren()) do
			if (child:IsA("MeshPart") or child:IsA("BasePart")) and child:GetAttribute("Skinnable") then
				out[#out + 1] = child
			end
			for _, grand in ipairs(child:GetChildren()) do
				if (grand:IsA("MeshPart") or grand:IsA("BasePart")) and grand:GetAttribute("Skinnable") then
					out[#out + 1] = grand
				end
			end
		end
		return out
	end
	local function skin_paint_one(skin, part)
		
		local did = false
		local textures = skin:FindFirstChild("Textures")
		if textures then
			local tex = textures:FindFirstChild(part:GetAttribute("Skinnable"))
			if tex then
				for _, child in ipairs(part:GetChildren()) do
					if child:IsA(tex.ClassName) then
						child:Destroy()
					end
				end
				local clone = tex:Clone()
				clone.Name = "SurfaceAppearance"
				clone.Parent = part
				if clone:GetAttribute("Transparency") then
					if part.Transparency ~= 1 then
						part.Transparency = clone:GetAttribute("Transparency")
					end
					if part:GetAttribute("Transparency") then
						part:SetAttribute("Transparency", clone:GetAttribute("Transparency"))
					end
				end
				did = true
			end
		end
		local materials = skin:FindFirstChild("Materials")
		if materials then
			local mat = materials:FindFirstChild(part:GetAttribute("Skinnable"))
			if mat then
				for _, child in ipairs(part:GetChildren()) do
					if child:IsA("SurfaceAppearance") then
						child:Destroy()
					end
				end
				part.Color = mat:GetAttribute("Color")
				part.Transparency = mat:GetAttribute("Transparency")
				part.Material = Enum.Material[mat:GetAttribute("Name")]
				did = true
			end
		end
		return did
	end
	local function skin_apply_skin(skin, model, base_name, edit_template, scope)
		if not (skin and model and model.Parent) then return end
		local parts = {}
		if scope == nil or scope == "" then
			parts = skin_collect_parts(model)
		else
			
			local sub = nil
			for _, d in ipairs(model:GetDescendants()) do
				if d.Name == scope and d:IsA("Model") then sub = d break end
			end
			if not sub then
				for _, d in ipairs(model:GetDescendants()) do
					if d:IsA("Model") and (string.find(d.Name, scope, 1, true) or string.find(scope, d.Name, 1, true)) then sub = d break end
				end
			end
			if sub then
				parts = skin_collect_parts(sub)
			else
				for _, d in ipairs(model:GetDescendants()) do
					if (d:IsA("MeshPart") or d:IsA("BasePart")) and (d.Name == scope or string.find(d.Name, scope, 1, true) or string.find(scope, d.Name, 1, true)) then
						parts[#parts + 1] = d
					end
				end
			end
		end
		local changed = 0
		for _, part in ipairs(parts) do
			if part and part.Parent and pcall(skin_paint_one, skin, part) then
				changed += 1
			end
		end
		if changed == 0 then
			pcall(skin_apply_model_skin, skin, model, base_name, edit_template)
		end
	end

	local skin_scope_keywords = { "Front", "Stock", "Handle", "Grip", "Magazine", "Mag", "Sight", "Scope", "Muzzle", "Suppressor", "FlashHider", "Barrel" }	local function skin_scope_of(name)
		for _, kw in ipairs(skin_scope_keywords) do
			if string.find(name, kw, 1, true) then
				if kw == "Mag" then return "Magazine" end
				return kw
			end
		end
		return ""
	end
	local function skin_set_family_atts(inv_list, tags, skin_name)
		
		if not (skins_folder and tags and skin_name) then return 0 end
		if not inv_list then
			inv_list = {}
			local inventory = skin_get_inventory()
			if inventory then
				for _, obj in ipairs(inventory:GetChildren()) do
					if obj:IsA("ObjectValue") and obj.Value then
						for _, tag in ipairs(tags) do
							if string.find(obj.Value.Name, tag, 1, true) or string.find(obj.Name, tag, 1, true) then
								inv_list[#inv_list + 1] = obj
								break
							end
						end
					end
				end
			end
		end
		local n = 0
		for _, it in ipairs(inv_list) do
			local atts = it and it:FindFirstChild("Attachments")
			if atts then
				for _, att in ipairs(atts:GetChildren()) do
					local folder = skins_folder:FindFirstChild(att.Name)
					if folder and folder:FindFirstChild(skin_name) then
						pcall(function() att:SetAttribute("Skin", skin_name) end)
						n += 1
					end
				end
			end
		end
		return n
	end
	local function skin_paint_attachments(inv_item, model)
		
		if not (inv_item and model and model.Parent) then return end
		local atts = inv_item:FindFirstChild("Attachments")
		if not atts then return end
		for _, att in ipairs(atts:GetChildren()) do
			local an, asn = att.Name, att:GetAttribute("Skin")
			if asn and skins_folder then
				local folder = skins_folder:FindFirstChild(an)
				local askin = folder and folder:FindFirstChild(asn)
				if askin then
					pcall(skin_apply_skin, askin, model, an, false, skin_scope_of(an))
				end
			end
		end
	end
	local function skin_apply_to_model(inv_item, model)
		if not (skins_folder and inv_item and inv_item.Value and model and model.Parent) then return end
		local entry = skin_find_entry(inv_item)
		local skin = entry and entry:FindFirstChild(inv_item:GetAttribute("Skin") or "")
		if not skin then return end
		skin_apply_skin(skin, model, inv_item.Name, true)
		skin_paint_attachments(inv_item, model)
	end

	local skin_preview_model = nil

	local function skin_clear_preview()
		if skin_preview_model then
			pcall(function()
				skin_preview_model:Destroy()
			end)
			skin_preview_model = nil
		end
	end

	local function skin_preview_current()
		skin_clear_preview()
		if not (skin_item_name and skin_skin_name and skins_folder and Camera) then return end
		local entry = skins_folder:FindFirstChild(skin_item_name)
		local skin = entry and entry:FindFirstChild(skin_skin_name)
		if not skin then return end
		local rs = game:GetService("ReplicatedStorage")
		local tpmodels = rs:FindFirstChild("ThirdPersonModels")
		local src = tpmodels and (tpmodels:FindFirstChild(skin:GetAttribute("ModelSkin") or "") or tpmodels:FindFirstChild(skin_item_name))
		if not src then
			local ilmodels = rs:FindFirstChild("ItemsListModels")
			src = ilmodels and (ilmodels:FindFirstChild(skin:GetAttribute("ModelSkin") or "") or ilmodels:FindFirstChild(skin_item_name))
		end
		if not src then
			Library.Notification("Skinchanger: no model for " .. skin_item_name, 2.5)
			return
		end
		local ok, model = pcall(function()
			local m = src:Clone()
			for _, d in ipairs(m:GetDescendants()) do
				if d:IsA("BasePart") then
					d.Anchored = true
					d.CanCollide = false
					d.CanTouch = false
					d.CanQuery = false
				end
			end
			return m
		end)
		if not (ok and model) then return end
		pcall(skin_apply_skin, skin, model, skin_item_name, false)
		pcall(function()
			model:PivotTo(Camera.CFrame * CFrame.new(0, 0.5, -6))
			model.Parent = workspace
		end)
		if model.Parent then
			skin_preview_model = model
		end
	end

	local function skin_selection_valid()
		if not (skins_folder and skin_item_name and skin_skin_name) then return false end
		local entry = skins_folder:FindFirstChild(skin_item_name)
		return entry and entry:FindFirstChild(skin_skin_name) ~= nil
	end
	local function skin_apply_current()
		if not skin_selection_valid() then
			skin_refresh_items()
			Library.Notification("Skinchanger: select item + skin first", 2.5)
			return
		end
		if skin_category == "Full Builds" then
			local base = string.gsub(skin_item_name, "^(Front|Stock|Handle|TacticalFront|TacticalStock|Impr|PolymerStock|DefaultFront|DefaultStock)", "")
			local tags = { skin_item_name }
			if #base >= 3 then tags[#tags + 1] = base end
			local n = 0
			if skins_folder then
				for _, folder in ipairs(skins_folder:GetChildren()) do
					if not (folder:IsA("Folder") and not skin_helpers[folder.Name]) then continue end
					local hit = false
					for _, tag in ipairs(tags) do
						if string.find(folder.Name, tag, 1, true) then hit = true break end
					end
					if not hit then continue end
					if not folder:FindFirstChild(skin_skin_name) then continue end
					for _, it in ipairs(skin_get_inv_items(folder.Name)) do
						pcall(function() it:SetAttribute("Skin", skin_skin_name) end)
						n += 1
					end
					skin_choices[folder.Name] = skin_skin_name
				end
			end
			pcall(skin_save_choices)
			pcall(skin_reapply_all)
			pcall(skin_paint_family_live, tags, skin_skin_name)
			pcall(skin_set_family_atts, nil, tags, skin_skin_name)
			task.delay(0.7, function()
				pcall(skin_paint_family_live, tags, skin_skin_name)
			end)
			Library.Notification("Build " .. skin_item_name .. " " .. skin_skin_name .. ": " .. n .. " item(s)", 2.5)
			return
		end
		skin_choices[skin_item_name] = skin_skin_name
		skin_last_item, skin_last_skin = skin_item_name, skin_skin_name
		pcall(skin_save_choices)
		local targets = skin_get_inv_items(skin_item_name)
		if #targets == 0 then
			
			local entry0 = skins_folder and skins_folder:FindFirstChild(skin_item_name)
			local skin0 = entry0 and entry0:FindFirstChild(skin_skin_name)
			local ms0 = skin0 and not skin0:FindFirstChild("Textures") and not skin0:FindFirstChild("Materials")
			if ms0 then
				pcall(skin_edit_template, skin_item_name, skin0:GetAttribute("ModelSkin") or skin_skin_name)
			elseif skin0 then
				
				local bases = { skin_item_name, (string.gsub(skin_item_name, "Visor$", "")) }
				local character0 = LocalPlayer and LocalPlayer.Character
				if character0 then
					for _, model in ipairs(character0:GetChildren()) do
						if model:IsA("Model") then
							for _, b in ipairs(bases) do
								if #b >= 3 and (model.Name == b or string.find(model.Name, b, 1, true)) then
									pcall(skin_apply_skin, skin0, model, skin_item_name, false)
									break
								end
							end
						end
					end
				end
			end
			Library.Notification("Skinchanger: " .. skin_item_name .. " saved (no inventory)", 2.5)
			return
		end
		local inv_item = targets[1]
		for _, it in ipairs(targets) do
			pcall(function()
				it:SetAttribute("Skin", skin_skin_name)
			end)
		end
		local itemslist = game:GetService("ReplicatedStorage"):FindFirstChild("ItemsList")
		local def = itemslist and inv_item.Value and itemslist:FindFirstChild(inv_item.Value.Name)
		local ip = def and def:FindFirstChild("ItemProperties")
		if ip then
			local entry = skin_find_entry(inv_item)
			local skin = entry and entry:FindFirstChild(skin_skin_name)
			local disp = skin and skin:GetAttribute("Name") or skin_skin_name
			if disp then
				pcall(function()
					ip:SetAttribute("CallSign", disp)
				end)
			end
		end
		local entry = skin_find_entry(inv_item)
		local skin = entry and entry:FindFirstChild(skin_skin_name)
		local model_skin = skin and not skin:FindFirstChild("Textures") and not skin:FindFirstChild("Materials")
		if model_skin then
			local newval = itemslist and itemslist:FindFirstChild(skin:GetAttribute("ModelSkin") or skin_skin_name)
			if newval then
				for _, it in ipairs(targets) do
					pcall(function()
						it.Value = newval
					end)
				end
			end
		end
		local applied = 0
		local function try_apply(model)
			if not (model and model.Parent) then return end
			pcall(skin_apply_to_model, inv_item, model)
			applied += 1
		end
		local character = LocalPlayer and LocalPlayer.Character
		if character then
			for _, model in ipairs(character:GetChildren()) do
				if model:IsA("Model") then
					local ref = model:FindFirstChild("SelfRef")
					if ref and ref.Value == inv_item then
						try_apply(model)
					elseif model_skin and model:FindFirstChild("DamagePoint", true) then
						try_apply(model)
					elseif not model_skin and (model.Name == inv_item.Value.Name or model.Name == inv_item.Name) then
						try_apply(model)
					end
				end
			end
		end
		if Camera then
			local hold_match = false
			pcall(function()
				local character = LocalPlayer and LocalPlayer.Character
				local holding = character and character:FindFirstChild("Holding")
				local hv = holding and holding.Value
				if hv and inv_item then
					hold_match = (hv == inv_item) or (hv.Value and inv_item.Value and hv.Value.Name == inv_item.Value.Name)
				end
			end)
			if hold_match then
				for _, vm in ipairs(Camera:GetChildren()) do
					if vm:IsA("Model") then
						local item = _FindFirstChild(vm, "Item")
						if item then
							try_apply(item)
						elseif model_skin and vm:FindFirstChild("DamagePoint", true) then
							try_apply(vm)
						end
					end
				end
			end
		end
		if not model_skin then
			local base = (string.gsub(skin_item_name, "^(Front|Stock|Handle|TacticalFront|TacticalStock|Impr|PolymerStock|DefaultFront|DefaultStock)", ""))
			local tags = { skin_item_name }
			if #base >= 3 then tags[#tags + 1] = base end
			if skin_paint_family_live then
				pcall(skin_paint_family_live, tags, skin_skin_name)
				pcall(skin_set_family_atts, targets, tags, skin_skin_name)
				
				task.delay(0.7, function()
					pcall(skin_paint_family_live, tags, skin_skin_name)
				end)
			end
		end
		Library.Notification("Skinchanger: " .. skin_skin_name .. " -> " .. applied .. " model(s)", 2.5)
	end

	local tune_px, tune_py, tune_pz, tune_rx, tune_ry, tune_rz = 0, 0, 0, 0, 0, 0
	local function skin_melee_tune_cf()
		return CFrame.new(tune_px, tune_py, tune_pz) * CFrame.Angles(math.rad(tune_rx), math.rad(tune_ry), math.rad(tune_rz))
	end
	local function skin_tune_motor(m)
		if not (m and (m:IsA("Motor6D") or m:IsA("Weld"))) then return end
		local base = m:GetAttribute("MeleeBaseC0")
		if base == nil then
			base = m.C0
			pcall(function()
				m:SetAttribute("MeleeBaseC0", base)
			end)
		end
		pcall(function()
			m.C0 = base * skin_melee_tune_cf()
		end)
	end
	local function skin_apply_melee_tune()
		local function tune_model(model)
			if not (model and model.Parent) then return end
			local root = model:FindFirstChild("ItemRoot", true)
			if not root then return end
			for _, d in ipairs(model:GetDescendants()) do
				if (d:IsA("Motor6D") or d:IsA("Weld")) and d.Part1 == root then
					skin_tune_motor(d)
				end
			end
		end
		local character = LocalPlayer and LocalPlayer.Character
		if character then
			for _, model in ipairs(character:GetChildren()) do
				if model:IsA("Model") and model:FindFirstChild("DamagePoint", true) then
					tune_model(model)
				end
			end
		end
		if Camera then
			for _, vm in ipairs(Camera:GetChildren()) do
				if vm:IsA("Model") then
					local item = _FindFirstChild(vm, "Item")
					if item then
						tune_model(item)
					end
				end
			end
		end
	end

	local function skin_reapply_all()
		if not (skins_folder and next(skin_choices)) then return end
		local itemslist = game:GetService("ReplicatedStorage"):FindFirstChild("ItemsList")
		
		for item_name, sn in pairs(skin_choices) do
			local targets = skin_get_inv_items(item_name)
			if #targets == 0 then continue end
			local entry = skin_find_entry(targets[1])
			local skin = entry and entry:FindFirstChild(sn)
			if not skin then continue end
			for _, it in ipairs(targets) do
				if it:GetAttribute("Skin") ~= sn then
					pcall(function() it:SetAttribute("Skin", sn) end)
				end
			end
			if not skin:FindFirstChild("Textures") and not skin:FindFirstChild("Materials") then
				local newval = itemslist and itemslist:FindFirstChild(skin:GetAttribute("ModelSkin") or sn)
				if newval then
					for _, it in ipairs(targets) do
						if it.Value ~= newval then
							pcall(function() it.Value = newval end)
						end
					end
				end
			end
		end
		local character = LocalPlayer and LocalPlayer.Character
		if character then
			for item_name, sn in pairs(skin_choices) do
				local targets = skin_get_inv_items(item_name)
				if #targets == 0 then continue end
				local entry = skin_find_entry(targets[1])
				local skin = entry and entry:FindFirstChild(sn)
				if not skin then continue end
				local model_skin_re = not skin:FindFirstChild("Textures") and not skin:FindFirstChild("Materials")
				for _, model in ipairs(character:GetChildren()) do
					if model:IsA("Model") then
						local ref = model:FindFirstChild("SelfRef")
						if ref and ref.Value == targets[1] then
							pcall(skin_apply_skin, skin, model, item_name, true)
							pcall(skin_paint_attachments, targets[1], model)
						elseif model_skin_re and model:FindFirstChild("DamagePoint", true) then
							pcall(skin_apply_skin, skin, model, item_name, true)
						elseif not model_skin_re and (model.Name == targets[1].Value.Name or model.Name == targets[1].Name or model.Name == item_name) then
							pcall(skin_apply_skin, skin, model, item_name, true)
							pcall(skin_paint_attachments, targets[1], model)
						end
					end
				end
			end
		end
		if Camera and skin_last_item and skin_last_skin then
			local targets = skin_get_inv_items(skin_last_item)
			if #targets > 0 then
				local entry = skin_find_entry(targets[1])
				local skin = entry and entry:FindFirstChild(skin_last_skin)
				if skin then
					for _, vm in ipairs(Camera:GetChildren()) do
						if vm:IsA("Model") then
							local item = _FindFirstChild(vm, "Item")
							if item then
								pcall(skin_apply_skin, skin, item, skin_last_item, true)
							end
						end
					end
				end
			end
		end
		
		if skin_paint_family_live then
			for item_name, sn in pairs(skin_choices) do
				local entry = skins_folder and skins_folder:FindFirstChild(item_name)
				local skin = entry and entry:FindFirstChild(sn)
				if skin and (skin:FindFirstChild("Textures") or skin:FindFirstChild("Materials")) then
					local base = (string.gsub(item_name, "^(Front|Stock|Handle|TacticalFront|TacticalStock|Impr|PolymerStock|DefaultFront|DefaultStock)", ""))
					local tags = { item_name }
					if #base >= 3 then tags[#tags + 1] = base end
					pcall(skin_paint_family_live, tags, sn)
					pcall(skin_set_family_atts, nil, tags, sn)
				end
			end
		end
	end

	local skin_reapply_tick = 0
	local function skin_schedule_reapply()
		if not next(skin_choices) then return end
		pcall(skin_hook_inventory)
		local t = os.clock()
		skin_reapply_tick = t
		task.delay(0.5, function()
			if skin_reapply_tick == t then
				pcall(skin_reapply_all)
			end
		end)
	end

	if Camera then
		Camera.ChildAdded:Connect(function()
			skin_schedule_reapply()
		end)
	end
	LocalPlayer.CharacterAdded:Connect(function(c)
		c.ChildAdded:Connect(function()
			skin_schedule_reapply()
		end)
		skin_schedule_reapply()
	end)
	if LocalPlayer.Character then
		LocalPlayer.Character.ChildAdded:Connect(function()
			skin_schedule_reapply()
		end)
	end
	local skin_inv_hooked = nil
	local function skin_hook_inventory()
		local inv = skin_get_inventory()
		if inv and inv ~= skin_inv_hooked then
			skin_inv_hooked = inv
			inv.ChildAdded:Connect(function()
				skin_schedule_reapply()
			end)
		end
	end

	local function skin_refresh_items()
		local names = skin_item_names()
		if #names == 0 then return end
		skin_item_dropdown.Refresh(names)
		if skin_item_name and table.find(names, skin_item_name) then
			skin_item_dropdown.Set(skin_item_name, true)
		else
			skin_item_name = names[1]
			if skin_item_name then
				skin_item_dropdown.Set(skin_item_name, true)
			end
		end
		local skins = skin_skin_names(skin_item_name)
		if #skins == 0 then skin_skin_name = nil return end
		skin_skin_dropdown.Refresh(skins)
		local targets = skin_get_inv_items(skin_item_name)
		local current = targets[1] and targets[1]:GetAttribute("Skin")
		if current and table.find(skins, current) then
			skin_skin_name = current
			skin_skin_dropdown.Set(current, true)
		else
			skin_skin_name = nil
		end
	end

	skin_category_dropdown = sknsec_right:Dropdown({Name = "Category", Values = skin_category_names(), Value = "All", Flag = "skinchanger_category", Multi = false, Callback = function(str)
		skin_category = str or "All"
		if not skin_item_dropdown then return end
		skin_refresh_items()
	end})
	skin_item_dropdown = sknsec:Dropdown({Name = "Item", Values = skin_item_names(), Value = nil, Flag = "skinchanger_item", Multi = false, Callback = function(str)
		skin_item_name = str
		if not skin_skin_dropdown then return end
		local skins = skin_skin_names(str)
		skin_skin_dropdown.Refresh(skins)
		local targets = skin_get_inv_items(str)
		local current = targets[1] and targets[1]:GetAttribute("Skin")
		if current and table.find(skins, current) then
			skin_skin_name = current
			skin_skin_dropdown.Set(current, true)
		else
			skin_skin_name = nil
		end
	end})
	skin_skin_dropdown = sknsec:Dropdown({Name = "Skin", Values = {}, Value = nil, Flag = "skinchanger_skin", Multi = false, Callback = function(str)
		skin_skin_name = str
	end})
	sknsec:Button({Name = "Apply skin", Confirm = false, Callback = function()
		skin_apply_current()
	end})
	sknsec:Button({Name = "Preview skin", Confirm = false, Callback = function()
		skin_preview_current()
	end})
	sknsec:Button({Name = "Clear preview", Confirm = false, Callback = function()
		skin_clear_preview()
	end})
	sknsec:Button({Name = "Debug knife", Confirm = false, Callback = function()
		local lines = {}
		local function add(s)
			lines[#lines + 1] = s
		end
		add("item=" .. tostring(skin_item_name) .. " skin=" .. tostring(skin_skin_name))
		local inventory = skin_get_inventory()
		if inventory then
			for _, o in ipairs(inventory:GetChildren()) do
				add("invChild:" .. o.ClassName .. ":" .. o.Name .. (o:IsA("ObjectValue") and (" val=" .. tostring(o.Value and o.Value.Name)) or ""))
			end
		else
			add("no inventory")
		end
		local invs = skin_get_inv_items(skin_item_name)
		add("inv_matches=" .. #invs)
		for _, it in ipairs(invs) do
			add("match:" .. it.Name .. " value=" .. tostring(it.Value and it.Value.Name) .. " skinattr=" .. tostring(it:GetAttribute("Skin")))
		end
		local entry = skin_find_entry(invs[1])
		add("entry=" .. tostring(entry and entry.Name))
		local character = LocalPlayer and LocalPlayer.Character
		if character then
			for _, m in ipairs(character:GetChildren()) do
				if m:IsA("Model") then
					local ref = m:FindFirstChild("SelfRef")
					add("charModel:" .. m.Name .. " selfref=" .. tostring(ref and ref.Value and ref.Value.Name) .. " dmg=" .. tostring(m:FindFirstChild("DamagePoint", true) ~= nil))
				end
			end
		else
			add("no character")
		end
		if Camera then
			for _, vm in ipairs(Camera:GetChildren()) do
				if vm:IsA("Model") then
					local item = _FindFirstChild(vm, "Item")
					add("camModel:" .. vm.Name .. " item=" .. tostring(item and item.Name) .. " dmg=" .. tostring(vm:FindFirstChild("DamagePoint", true) ~= nil))
					if item then
						local n, first = 0, nil
						for _, d in ipairs(item:GetDescendants()) do
							if d:IsA("MeshPart") or d:IsA("BasePart") then
								n += 1
								if not first then first = d.Name .. "/" .. d.ClassName end
							end
						end
						add("itemParts=" .. n .. " first=" .. tostring(first))
					end
				end
			end
		end
		pcall(writefile, "skinchanger_debug.txt", table.concat(lines, "\n"))
		Library.Notification("Skinchanger: debug saved (" .. #lines .. " lines)", 2.5)
	end})
	sknsec:Button({Name = "Debug model", Confirm = false, Callback = function()
		local lines = {}
		local function dumpmodel(tag, model)
			if not (model and model.Parent) then
				lines[#lines + 1] = tag .. ":nil"
				return
			end
			lines[#lines + 1] = tag .. ":" .. model:GetFullName() .. " swapped=" .. tostring(model:GetAttribute("SkinSwapped"))
			for _, d in ipairs(model:GetDescendants()) do
				if d:IsA("MeshPart") or d:IsA("BasePart") then
					local mid = d:IsA("MeshPart") and d.MeshId or "-"
					if #mid > 12 then mid = "..." .. string.sub(mid, -8) end
					lines[#lines + 1] = "  part:" .. d.Name .. "/" .. d.ClassName .. " t=" .. d.Transparency .. " size=" .. tostring(d.Size) .. " mesh=" .. mid .. " marked=" .. tostring(d:GetAttribute("SkinSwappedPart"))
				end
			end
		end
		local character = LocalPlayer and LocalPlayer.Character
		if character then
			for _, m in ipairs(character:GetChildren()) do
				if m:IsA("Model") and m:FindFirstChild("DamagePoint", true) then
					dumpmodel("knife-char", m)
				end
			end
		end
		if Camera then
			for _, vm in ipairs(Camera:GetChildren()) do
				if vm:IsA("Model") then
					local item = _FindFirstChild(vm, "Item")
					if item then
						dumpmodel("knife-vm-item", item)
					elseif vm:FindFirstChild("DamagePoint", true) then
						dumpmodel("knife-vm", vm)
					end
				end
			end
		end
		pcall(writefile, "skinchanger_model.txt", "lasterr=" .. tostring(skin_last_error) .. "\n" .. table.concat(lines, "\n"))
		Library.Notification("Skinchanger: model saved (" .. #lines .. " lines)", 2.5)
	end})
	skin_paint_family_live = function(family, skin_name)
		if not (skins_folder and family and skin_name) then return 0 end
		local tags = (type(family) == "table" and family) or { family }
		
		pcall(function()
			local inventory = skin_get_inventory()
			if inventory then
				for _, obj in ipairs(inventory:GetChildren()) do
					if obj:IsA("ObjectValue") and obj.Value then
						local isbase = false
						for _, tag in ipairs(tags) do
							if string.find(obj.Value.Name, tag, 1, true) or string.find(obj.Name, tag, 1, true) then isbase = true break end
						end
						if isbase then
							local atts = obj:FindFirstChild("Attachments")
							if atts then
								for _, att in ipairs(atts:GetChildren()) do
									if not table.find(tags, att.Name) then tags[#tags + 1] = att.Name end
								end
							end
						end
					end
				end
			end
		end)
		local partskins = {}
		for _, folder in ipairs(skins_folder:GetChildren()) do
			if not (folder:IsA("Folder") and not skin_helpers[folder.Name]) then continue end
			local hit = false
			for _, tag in ipairs(tags) do
				if string.find(folder.Name, tag, 1, true) then hit = true break end
			end
			if not hit then continue end
			local s = folder:FindFirstChild(skin_name)
			if s and (s:FindFirstChild("Textures") or s:FindFirstChild("Materials")) then
				
				local rest = folder.Name
				for _, tag in ipairs(tags) do
					rest = string.gsub(rest, tag, "")
				end
				local scope = rest
				local kw = skin_scope_of(folder.Name)
				if kw ~= "" then scope = kw end
				partskins[#partskins + 1] = { skin = s, scope = scope, fname = folder.Name }
			end
		end
		if #partskins == 0 then return 0 end
		
		local base = {}
		local inv_targets = {}
		local inventory = skin_get_inventory()
		if inventory then
			for _, obj in ipairs(inventory:GetChildren()) do
				if obj:IsA("ObjectValue") and obj.Value then
					for _, tag in ipairs(tags) do
						if string.find(obj.Value.Name, tag, 1, true) or string.find(obj.Name, tag, 1, true) then
							base[obj] = true
							inv_targets[#inv_targets + 1] = obj
							break
						end
					end
				end
			end
		end
		local models = {}
		local character = LocalPlayer and LocalPlayer.Character
		if character then
			for _, m in ipairs(character:GetChildren()) do
				if m:IsA("Model") then
					local ref = m:FindFirstChild("SelfRef")
					if ref and base[ref.Value] then
						models[#models + 1] = m
					else
						for _, tag in ipairs(tags) do
							if string.find(m.Name, tag, 1, true) then
								models[#models + 1] = m
								break
							end
						end
					end
				end
			end
		end
		if Camera then
			local held_ok = false
			pcall(function()
				local character = LocalPlayer and LocalPlayer.Character
				local holding = character and character:FindFirstChild("Holding")
				local hv = holding and holding.Value
				if hv then
					for _, tag in ipairs(tags) do
						if string.find(hv.Name, tag, 1, true) or string.find(hv.Value.Name, tag, 1, true) then held_ok = true break end
					end
				end
			end)
			if held_ok then
				for _, vm in ipairs(Camera:GetChildren()) do
					if vm:IsA("Model") then
						local item = _FindFirstChild(vm, "Item")
						if item then models[#models + 1] = item end
					end
				end
			end
		end
		local painted = 0
		for _, model in ipairs(models) do
			for _, ps in ipairs(partskins) do
				if model and model.Parent then
					if pcall(skin_apply_skin, ps.skin, model, ps.fname, false, ps.scope) then
						painted += 1
					end
				end
			end
		end
		return painted
	end
	local function skin_apply_preset(family, skin_name)
		if not (skins_folder and family and skin_name) then return 0 end
		local n = 0
		for _, folder in ipairs(skins_folder:GetChildren()) do
			if not (folder:IsA("Folder") and not skin_helpers[folder.Name]) then continue end
			local fname = folder.Name
			local hit = (fname == family)
			if not hit then
				for _, tag in ipairs(family) do
					if string.find(fname, tag, 1, true) then hit = true break end
				end
			end
			if not hit then continue end
			if not folder:FindFirstChild(skin_name) then continue end
			for _, it in ipairs(skin_get_inv_items(fname)) do
				pcall(function() it:SetAttribute("Skin", skin_name) end)
				n += 1
			end
			skin_choices[fname] = skin_name
		end
		skin_last_item, skin_last_skin = nil, nil
		pcall(skin_save_choices)
		pcall(skin_reapply_all)
		pcall(skin_paint_family_live, family, skin_name)
		pcall(skin_set_family_atts, nil, (type(family) == "table" and family) or { family }, skin_name)
		task.delay(0.7, function()
			pcall(skin_paint_family_live, family, skin_name)
		end)
		return n
	end
	local skin_presets = nil 
	sknsec:Button({Name = "Apply skin to FAMILY", Confirm = false, Callback = function()
		if not (skin_item_name and skin_skin_name) then return end
		local base = string.gsub(skin_item_name, "^(Front|Stock|Handle|TacticalFront|TacticalStock|Impr|PolymerStock|DefaultFront|DefaultStock)", "")
		local tags = { skin_item_name }
		if #base >= 3 then tags[#tags + 1] = base end
		local n = skin_apply_preset(tags, skin_skin_name)
		Library.Notification("Family " .. skin_skin_name .. ": " .. n .. " item(s)", 2.5)
	end})
	sknsec:Button({Name = "Refresh items", Confirm = false, Callback = function()
		skins_folder = game:GetService("ReplicatedStorage"):FindFirstChild("Skins")
		skin_refresh_items()
	end})
	local function skin_sproof_ownership()
		
		local rs = game:GetService("ReplicatedStorage")
		local rf = rs:FindFirstChild("Players")
		local rp = rf and LocalPlayer and rf:FindFirstChild(LocalPlayer.Name)
		local st = rp and rp:FindFirstChild("Status")
		local pur = st and st:FindFirstChild("Purchases")
		local ps = pur and pur:FindFirstChild("Skins")
		if not (skins_folder and ps) then return 0 end
		local n = 0
		for _, folder in ipairs(skins_folder:GetChildren()) do
			if not (folder:IsA("Folder") and not skin_helpers[folder.Name]) then continue end
			local own = ps:FindFirstChild(folder.Name)
			if not own then
				own = Instance.new("Folder")
				own.Name = folder.Name
				own.Parent = ps
			end
			for _, skin in ipairs(folder:GetChildren()) do
				if not (skin:IsA("Folder") and not skin_helpers[skin.Name]) then continue end
				if not own:FindFirstChild(skin.Name) then
					local v = Instance.new("StringValue")
					v.Name = skin.Name
					v.Parent = own
					n += 1
				end
			end
		end
		return n
	end
	sknsec:Button({Name = "Spoof ownership", Confirm = false, Callback = function()
		local n = 0
		pcall(function() n = skin_sproof_ownership() end)
		Library.Notification("Skinchanger: ownership spoofed (" .. n .. " new)", 2.5)
	end})
	sknsec:Button({Name = "Vanilla apply", Confirm = false, Callback = function()
		if not (skin_item_name and skin_skin_name) then return end
		local msg = "?"
		pcall(function()
			local rs = game:GetService("ReplicatedStorage")
			local remotes = rs:FindFirstChild("Remotes")
			local remote = remotes and remotes:FindFirstChild("ChangeSkin")
			if not remote then msg = "no remote" return end
			local targets = skin_get_inv_items(skin_item_name)
			if #targets == 0 then msg = "no inventory" return end
			local ok2, res2 = pcall(remote.InvokeServer, remote, targets[1], skin_skin_name, true)
			if not ok2 then msg = "invoke err" return end
			msg = "server=" .. tostring(res2)
		end)
		Library.Notification("Skinchanger: vanilla " .. msg, 3)
		pcall(writefile, "skinchanger_vanilla.txt", "item=" .. tostring(skin_item_name) .. " skin=" .. tostring(skin_skin_name) .. " res=" .. msg)
	end})
	sknsec_right:Button({Name = "Save skins", Confirm = false, Callback = function()
		pcall(skin_save_choices)
		Library.Notification("Skinchanger: saved", 2.5)
	end})
	sknsec_right:Button({Name = "Load skins", Confirm = false, Callback = function()
		if pcall(skin_load_choices) then
			skin_refresh_items()
			pcall(skin_reapply_all)
			Library.Notification("Skinchanger: loaded", 2.5)
		end
	end})
	task.spawn(function()
		for _ = 1, 60 do
			task.wait(1)
			skins_folder = game:GetService("ReplicatedStorage"):FindFirstChild("Skins")
			if skins_folder and #skins_folder:GetChildren() > 0 then
				pcall(skin_load_choices)
				skin_category_dropdown.Refresh(skin_category_names())
				skin_category_dropdown.Set(skin_category, true)
				skin_refresh_items()
				pcall(skin_reapply_all)
				break
			end
		end
	end)
	
	do
		local genv = (getgenv and getgenv()) or _G
		genv.zzzhub_cleanup = genv.zzzhub_cleanup or {}
		table.insert(genv.zzzhub_cleanup, function()
			pcall(skin_clear_preview)
			local rs = game:GetService("ReplicatedStorage")
			for key, b in pairs(skin_template_backup) do
				pcall(function()
					local folder_name, tpl_name = string.match(key, "^(.-)/(.+)$")
					local folder = folder_name and rs:FindFirstChild(folder_name)
					if folder and b then
						local cur = folder:FindFirstChild(tpl_name)
						if cur then cur:Destroy() end
						local rc = b:Clone()
						rc.Name = tpl_name
						rc.Parent = folder
					end
				end)
			end
			for tool, attrs in pairs(skin_tool_backup) do
				pcall(function()
					if tool and tool.Parent then
						for k, v in pairs(attrs) do tool:SetAttribute(k, v) end
					end
				end)
			end
		end)
	end
end

local fov_changer, fov_changer_size = false, 100
local zoom, zoom_key, zoom_size = false, false, 10
local aspect_ratio, aspect_ratio_x, aspect_ratio_y = false, 1, 1
local thirdperson, thirdperson_key, thirdperson_distance = false, false, 10
do
	
	local espsec = ui.sections.player_esp
	local setsec = ui.sections.esp_settings
	local itmsec = ui.sections.item_esp
	local othsec = ui.sections.other_esp
	local mscsec = ui.sections.visuals_misc
	local lclsec = ui.sections.visuals_local

	local enemy_sets = cheat.EspLibrary.settings.enemy
	local enemy_main_sets = cheat.EspLibrary.settings.enemy.main_settings

	local item_sets = cheat.EspLibrary.settings.item
	local item_main_sets = cheat.EspLibrary.settings.item.main_settings

	local corpse_sets = cheat.EspLibrary.settings.corpse
	local corpse_main_sets = cheat.EspLibrary.settings.corpse.main_settings


	do 
		espsec:Toggle({Name = "Enabled", Value = false, Flag = "esp_enabled", Callback = function(bool)
			enemy_sets.enabled = bool
			cheat.EspLibrary.icaca()
		end})

		do
			local toggle = espsec:Toggle({Name = "Box", Value = false, Flag = "esp_box", Callback = function(bool)
				enemy_sets.box = bool
				cheat.EspLibrary.icaca()
			end})
			toggle:Colorpicker({Name = "Box color left", Value = Color3.new(1, 1, 1), Usealpha = true, Flag = "esp_box_color_left", Callback = function(color)
				enemy_sets.box_color[1] = color.c
				enemy_sets.box_color[3] = color.a
				cheat.EspLibrary.icaca()
			end})
			toggle:Colorpicker({Name = "Box color right", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_box_color_right", Callback = function(color)
				enemy_sets.box_color[2] = color.c
				cheat.EspLibrary.icaca()
			end})
			espsec:Slider({Name = "Box rotation", Min = 0, Max = 20, Float = 0.1, Value = 0, Flag = "esp_box_rotation", Callback = function(int)
				enemy_sets.box_rotation = int * 18
				cheat.EspLibrary.icaca()
			end})
			local outline_toggle = espsec:Toggle({Name = "Box outline", Value = false, Flag = "esp_box_outline", Callback = function(bool)
				enemy_sets.box_outline = bool
				cheat.EspLibrary.icaca()
			end})
			outline_toggle:Colorpicker({Name = "Box outline color left", Value = Color3.new(), Usealpha = true, Flag = "esp_box_outline_color_left", Callback = function(color)
				enemy_sets.box_outline_color[1] = color.c
				enemy_sets.box_outline_color[2] = color.a
				cheat.EspLibrary.icaca()
			end})
			outline_toggle:Colorpicker({Name = "Box outline color right", Value = Color3.new(), Usealpha = true, Flag = "esp_box_outline_color_right", Callback = function(color)
				enemy_sets.box_outline_color[3] = color.c
				enemy_sets.box_outline_color[4] = color.a
				cheat.EspLibrary.icaca()
			end})
		end

		do
			local toggle = espsec:Toggle({Name = "Health bar", Value = false, Flag = "esp_health_bar", Callback = function(bool)
				enemy_sets.health_bar = bool
				cheat.EspLibrary.icaca()
			end})
			toggle:Colorpicker({Name = "Bar color top", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_health_bar_color_top", Callback = function(color)
				enemy_sets.health_bar_color[1] = color.c
				cheat.EspLibrary.icaca()
			end})
			toggle:Colorpicker({Name = "Bar color bottom", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_health_bar_color_bottom", Callback = function(color)
				enemy_sets.health_bar_color[2] = color.c
				cheat.EspLibrary.icaca()
			end})
		end

		for _, element in {
			{"Name", "name"},
			{"Distance", "distance"},
			{"Weapon", "weapon"},
			{"Health text", "health_text"},
			{"Flags", "flags"},
			{"Skeleton", "skeleton"},
			} do
			espsec:Toggle({Name = element[1], Value = false, Flag = `esp_{element[2]}`, Callback = function(bool)
				enemy_sets[element[2]] = bool
				cheat.EspLibrary.icaca()
			end}):Colorpicker({Name = `{element[1]} color`, Value = Color3.new(1, 1, 1), Usealpha = true, Flag = `esp_{element[2]}_color`, Callback = function(color)
				enemy_sets[`{element[2]}_color`] = {color.c, color.a}
				cheat.EspLibrary.icaca()
			end})
		end

		espsec:Slider({Name = "Skeleton update rate", Min = 0, Max = 1, Float = 0.01, Value = 0, Flag = "esp_skeleton_rate", Callback = function(int)
			enemy_main_sets.skeleton_rate = int
			cheat.EspLibrary.icaca()
		end})

		espsec:Toggle({Name = "Chams", Value = false, Flag = "esp_chams", Callback = function(bool)
			enemy_sets.chams = bool
			cheat.EspLibrary.icaca()
		end})
		espsec:Colorpicker({Name = "Chams color", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "esp_chams_color", Callback = function(color)
			enemy_sets.chams_color = {color.c, color.a}
			cheat.EspLibrary.icaca()
		end})
		espsec:Slider({Name = "Chams glow factor", Min = 0, Max = 100, Float = 0.1, Value = 3, Flag = "esp_chams_glow_factor", Callback = function(int)
			enemy_sets.chams_glow_factor = int
			cheat.EspLibrary.icaca()
		end})
	end
	do 
		local player_list = cheat.player_list
		local report_list = cheat.report_list
		local flag_settings = {
			["Target"] = false,
			["Team"] = false,
			["Friend"] = false,
			["Visor"] = false,
			["Desynced"] = false,
			["Visible"] = false,
			["NPC"] = false,
			["KD"] = false,
			["Suspiciousness"] = false
		}
		setsec:Dropdown({Name = "Flags", Values = {"Target", "Team", "Friend", "Visor", "Desynced", "Visible", "NPC", "KD", "Suspiciousness"}, Value = {}, Flag = "esp_selected_flags", Multi = true, Callback = function(tbl)
			for flag, value in flag_settings do
				flag_settings[flag] = false
			end
			for _, flag in tbl do
				flag_settings[flag] = true
			end
		end})
		
		local get_team = cheat.EspLibrary.get_team
		cheat.EspLibrary.register_flag("TARGET", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			return flag_settings["Target"] and player == target_player
		end))
		cheat.EspLibrary.register_flag("TEAM", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			return flag_settings["Team"] and get_team(player)
		end))
		cheat.EspLibrary.register_flag("FRIEND", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			local tp = player_list[player]
			return flag_settings["Friend"] and tp and tp.friend
		end))
		cheat.EspLibrary.register_flag("VISOR", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			local tp = player_list[player]
			return flag_settings["Visor"] and tp and tp.visor
		end))
		cheat.EspLibrary.register_flag("DSYNC", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			local tp = player_list[player]
			local server_position = tp and tp.server_position
			local hrp = _FindFirstChild(character, "HumanoidRootPart")
			return flag_settings["Desynced"] and server_position and hrp and (server_position - hrp.CFrame.Position).Magnitude > 3
		end))
		cheat.EspLibrary.register_flag("VIS", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			local tp = player_list[player]	
			return flag_settings["Visible"] and tp and tp.visible
		end))
		cheat.EspLibrary.register_flag("NPC", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			return flag_settings["NPC"] and player == character
		end))
		cheat.EspLibrary.register_flag("... KD", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			local tp = player_list[player]
			if not (flag_settings["KD"] and tp) then
				return false
			end
			local stats = tp.statistics
			if not stats then
				return true, "? KD"
			end
			local kills = stats:GetAttribute("Kills")
			local deaths = stats:GetAttribute("Deaths")
			if not (kills and deaths) then
				return true, "? KD"
			end
			deaths = (deaths == 0 and 1 or deaths)
			return true, ("%.1f KD"):format(kills/deaths)
		end))
		
		cheat.EspLibrary.register_flag("SUSSY", LPH_NO_VIRTUALIZE(function(player, character, humanoid)
			if not flag_settings["Suspiciousness"] then
				return false
			end


			local player_object = player_list[player]
			if not player_object then
				return false
			end

			local report_object = report_list[player.Name]

			local text = ""

			if report_object then
				if report_object.mw > 0 then
					text ..= "!! CHEATER !!"
				end
				if report_object.rr > 0 then
					text ..= ("%*RR: %*"):format(text ~= "" and " " or "", report_object.rr)
				end
			end

			if player_object.reports then
				text ..= ("%*%*"):format(text ~= "" and " " or "", `:: {player_object.reports}`)
			end

			local wipe = player_object.game_data and player_object.wipe_statistics
			local wipe_time = wipe and wipe:GetAttribute("TimePlayed")
			local session = player_object.session_start
			if wipe_time then
				local hours = wipe_time
				if session then
					hours += math.max(0, os.time() - session)
				end
				text ..= ("%*%*h"):format(text ~= "" and " " or "", mathround(hours / 3600 * 100) / 100)
			end

			return true, text
		end))
	end
	do 
		setsec:Dropdown({Name = "Checks", Values = {"Team check", "Dead check", "Distance check", "NPC check"}, Value = {}, Flag = "esp_checks", Multi = true, Callback = function(tbl)
			local funny = {
				["Team check"] = "team_check",
				["Dead check"] = "dead_check",
				["Distance check"] = "dist_check",
				["NPC check"] = "npc_check"
			}
			for flag_text, esp_var in funny do
				enemy_main_sets[esp_var] = false
			end
			for flag_text, esp_var in funny do 
				for _, check_name in tbl do
					if (check_name ~= flag_text or enemy_main_sets[esp_var]) then
						continue
					end
					enemy_main_sets[esp_var] = true
					
				end
			end
			cheat.EspLibrary.icaca()
		end})
		setsec:Slider({Name = "Max distance", Min = 0, Max = 2000, Float = 10, Value = 200, Flag = "esp_max_distance", Callback = function(int)
			enemy_main_sets.max_distance = int * 3
			cheat.EspLibrary.icaca()
		end})
		setsec:Toggle({Name = "Gradient spin", Value = false, Flag = "esp_gradient_spin", Callback = function(bool)
			enemy_main_sets.gradient_spin = bool
			cheat.EspLibrary.icaca()
		end})
		setsec:Slider({Name = "Gradient speed", Min = -20, Max = 20, Float = 0.1, Value = 0, Flag = "esp_gradient_speed", Callback = function(int)
			enemy_main_sets.gradient_speed = int * 18
			cheat.EspLibrary.icaca()
		end})
		setsec:Toggle({Name = "Holder spin", Value = false, Flag = "esp_holder_spin", Callback = function(bool)
			enemy_main_sets.holder_spin = bool
			cheat.EspLibrary.icaca()
		end})
		setsec:Slider({Name = "Holder speed", Min = -20, Max = 20, Float = 0.1, Value = 0, Flag = "esp_holder_speed", Callback = function(int)
			enemy_main_sets.holder_speed = int * 18
			cheat.EspLibrary.icaca()
		end})
	end
	do 
		itmsec:Toggle({Name = "Item ESP", Value = false, Flag = "esp_item", Callback = function(bool)
			item_sets.enabled = bool
			cheat.EspLibrary.icaca()
		end}):Colorpicker({Name = "Item Color", Value = Color3.new(1, 1, 1), Usealpha = true, Flag = "esp_item_color", Callback = function(color)
			item_sets.text_color = {color.c, color.a}
			cheat.EspLibrary.icaca()
		end})
		itmsec:Toggle({Name = "Show distance", Value = false, Flag = "esp_item_distance", Callback = function(bool)
			item_sets.distance = bool
			cheat.EspLibrary.icaca()
		end})
		itmsec:Toggle({Name = "Show amount", Value = false, Flag = "esp_item_amount", Callback = function(bool)
			item_sets.amount = bool
			cheat.EspLibrary.icaca()
		end})
		itmsec:Toggle({Name = "Show durability", Value = false, Flag = "esp_item_durability", Callback = function(bool)
			item_sets.durability = bool
			cheat.EspLibrary.icaca()
		end})
		itmsec:Toggle({Name = "Show durability bar", Value = false, Flag = "esp_item_durability_bar", Callback = function(bool)
			item_sets.durability_bar = bool
			cheat.EspLibrary.icaca()
		end})
		itmsec:Slider({Name = "Max distance (0 = inf)", Min = 0, Max = 200, Float = 1, Value = 10, Flag = "esp_item_max_distance", Callback = function(int)
			item_main_sets.dist_check = int > 0
			item_main_sets.max_distance = int * 3
			cheat.EspLibrary.icaca()
		end})
	end
	do 
		othsec:Toggle({Name = "Corpse ESP", Value = false, Flag = "esp_corpse", Callback = function(bool)
			corpse_sets.enabled = bool
			cheat.EspLibrary.icaca()
		end}):Colorpicker({Name = "Corpse Color", Value = Color3.new(1, 1, 1), Usealpha = true, Flag = "esp_corpse_color", Callback = function(color)
			corpse_sets.text_color = {color.c, color.a}
			cheat.EspLibrary.icaca()
		end})
		othsec:Toggle({Name = "Show distance", Value = false, Flag = "esp_corpse_distance", Callback = function(bool)
			corpse_sets.distance = bool
			cheat.EspLibrary.icaca()
		end})
		othsec:Slider({Name = "Max distance (0 = inf)", Min = 0, Max = 1000, Float = 10, Value = 100, Flag = "esp_corpse_max_distance", Callback = function(int)
			corpse_main_sets.dist_check = int > 0
			corpse_main_sets.max_distance = int * 3
			cheat.EspLibrary.icaca()
		end})
		local player_table, player_table_text, player_table_tick = false, nil, 0
		othsec:Toggle({Name = "Player table", Value = false, Flag = "player_table", Callback = function(bool)
			player_table = bool
			if bool then
				if not player_table_text then
					player_table_text = cheat.utility.new_drawing("Text", {
						Text = "",
						Size = 14,
						Position = _Vector2new(10, 200),
						Color = Color3.new(1, 1, 1),
						Outline = true,
						Visible = true,
					})
				else
					player_table_text.Visible = true
				end
			elseif player_table_text then
				player_table_text.Visible = false
			end
		end})
		cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
			if not (player_table and player_table_text) then return end
			local now = tick()
			if now - player_table_tick < 0.5 then return end
			player_table_tick = now
			local char = LocalPlayer.Character
			local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
			local lines = {}
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character then
					local root = _FindFirstChild(plr.Character, "HumanoidRootPart")
					if root then
						local d = hrp and math.floor((hrp.Position - root.Position).Magnitude) or 0
						lines[#lines + 1] = plr.DisplayName .. " [" .. d .. "m]"
						if #lines >= 15 then break end
					end
				end
			end
			player_table_text.Text = table.concat(lines, "\n")
		end))
	end

	local no_screen_effects, viewmodel_changer, gun_changer, arm_changer = false, false, false, false
	local gun_color, gun_material, arm_color, arm_material = Color3.new(1, 1, 1), Enum.Material.ForceField, Color3.new(1, 1, 1), Enum.Material.ForceField
	local viewmodel_x, viewmodel_y, viewmodel_z = 0, 0, 0
	local leftarm_old, rightarm_old, itemroot_old, motor6d_old

	local function vmpos(vm)
		if not viewmodel_changer then return end
		local hrp = _FindFirstChild(vm, "HumanoidRootPart")
		local vec = _Vector3new(viewmodel_x, thirdperson_key and -100 or viewmodel_y, thirdperson_key and 100 or viewmodel_z)
		local leftarm_weld = hrp and _FindFirstChild(hrp, "LeftUpperArm")
		local rightarm_weld = hrp and _FindFirstChild(hrp, "RightUpperArm")
		local itemroot_weld = hrp and _FindFirstChild(hrp, "ItemRoot")
		local motor6d_weld = hrp and _FindFirstChild(hrp, "Motor6D")
		if leftarm_weld then
			if not leftarm_old then leftarm_old = leftarm_weld.C0 end
			leftarm_weld.C0 = leftarm_old + vec
		end
		if rightarm_weld then
			if not rightarm_old then rightarm_old = rightarm_weld.C0 end
			rightarm_weld.C0 = rightarm_old + vec
		end
		if itemroot_weld then
			if not itemroot_old then itemroot_old = itemroot_weld.C0 end
			itemroot_weld.C0 = itemroot_old + vec
		end
		if motor6d_weld then
			if not motor6d_old then motor6d_old = motor6d_weld.C0 end
			motor6d_weld.C0 = motor6d_old + vec
		end
	end
	local function vmunpos()
		if not viewmodel_changer then return end
		leftarm_old, rightarm_old, motor6d_old = nil, nil, nil
	end
	local vmchams = LPH_NO_VIRTUALIZE(function()
		local vm = _FindFirstChildOfClass(Camera, "Model")
		if not vm then return end
		local viewmodel_item = _FindFirstChild(vm, "Item")
		if gun_changer and viewmodel_item then 
			for _, v in viewmodel_item:GetDescendants() do
				local surfaceappearance = _FindFirstChildOfClass(v, "SurfaceAppearance")
				if _IsA(v, "BasePart") then
					v.Material = gun_material
					v.Color = gun_color
				end
				if surfaceappearance then
					surfaceappearance:Destroy()
				end
			end
		end
		if arm_changer then
			for _, vm_item in vm:GetChildren() do
				if _IsA(vm_item, "BasePart") then
					if vm_item.Name:find("Hand") or vm_item.Name:find("Arm") then
						vm_item.Material = arm_material
						vm_item.Color = arm_color
					end
				end
				if vm_item.ClassName == "Model" and (_FindFirstChild(vm_item, "LL") or _FindFirstChild(vm_item, "LH")) then
					for _, shirt_item in (vm_item:GetChildren()) do
						local surfaceappearance = _FindFirstChildOfClass(shirt_item, "SurfaceAppearance")
						shirt_item.Material = arm_material
						shirt_item.Color = arm_color
						if surfaceappearance then
							surfaceappearance:Destroy()
						end
					end
				end
			end
		end
	end)

	do 
		local old_fov = Camera.FieldOfView
		mscsec:Toggle({Name = "FOV Changer", Value = false, Flag = "view_fov_changer", Callback = function(bool)
			fov_changer = bool
			Camera.FieldOfView = (zoom and zoom_key and zoom_size) or (fov_changer and fov_changer_size) or old_fov
		end})
		mscsec:Slider({Name = "Desired FOV", Min = 50, Max = 120, Float = 1, Value = 100, Flag = "view_fov_changer_size", Callback = function(int)
			fov_changer_size = int
			Camera.FieldOfView = (zoom and zoom_key and zoom_size) or (fov_changer and fov_changer_size) or old_fov
		end})
		local zoom_keybind; zoom_keybind = mscsec:Toggle({Name = "Zoom", Value = false, Flag = "view_zoom", Callback = function(bool)
			zoom = bool
			Camera.FieldOfView = (zoom and zoom_key and zoom_size) or (fov_changer and fov_changer_size) or old_fov
		end}):Keybind({Name = "Zoom", Mode = "Toggle", Key = Enum.KeyCode.Z, Value = false, Flag = "view_zoom_keybind", Callback = function(bool)
			zoom_key = zoom and bool
			zoom_keybind.Set(zoom_key, true)
			Camera.FieldOfView = (zoom and zoom_key and zoom_size) or (fov_changer and fov_changer_size) or old_fov
		end})
		mscsec:Slider({Name = "Desired zoom", Min = 1, Max = 50, Float = 1, Value = 20, Flag = "view_zoom_size", Callback = function(int)
			zoom_size = int
			Camera.FieldOfView = (zoom and zoom_key and zoom_size) or (fov_changer and fov_changer_size) or old_fov
		end})
		
		do
			local freecam, freecam_key, freecam_speed = false, false, 750
			local fc_keybind; fc_keybind = mscsec:Toggle({Name = "Freecam", Value = false, Flag = "view_freecam", Callback = function(bool)
				freecam = bool
			end}):Keybind({Name = "Freecam", Mode = "Toggle", Key = Enum.KeyCode.L, Value = false, Flag = "view_freecam_keybind", Callback = function(bool)
				freecam_key = freecam and bool
				fc_keybind.Set(freecam_key, true)
			end})
			mscsec:Slider({Name = "Freecam speed", Min = 100, Max = 1000, Float = 10, Value = 750, Flag = "view_freecam_speed", Callback = function(int)
				freecam_speed = int
			end})

			local new_camera_pos

			task.spawn(function()
				while task.wait(4) do
					local closest, distance = nil, math.huge
					if (freecam and freecam_key and new_camera_pos) then
						LPH_NO_VIRTUALIZE(function()
							for i, model in workspace:GetDescendants() do
								if not _IsA(model, "Model") then continue end
								local primarypart = model.PrimaryPart
								if not primarypart then continue end
								local pos = primarypart.Position
								local ts_dist = (new_camera_pos - pos).Magnitude
								if ts_dist < distance then
									closest, distance = primarypart, ts_dist
								end
							end
						end)()
					end
					if freecam and freecam_key and new_camera_pos then
						LocalPlayer.ReplicationFocus = closest
					end
				end
			end)

			game:GetService("RunService").PreRender:Connect(LPH_NO_VIRTUALIZE(function(delta)
				local character = LocalPlayer.Character
				local hrp = character and _FindFirstChild(character, "HumanoidRootPart")

				if not (freecam and freecam_key) then
					new_camera_pos = nil
					if hrp then
						hrp.Anchored = false
					end
					return
				end
				if not new_camera_pos then
					new_camera_pos = Camera.CFrame.Position
				end

				local cameralook = Camera.CFrame.LookVector
				local direction = _Vector3new(0, 0, 0)
				direction = _IsKeyDown(UserInputService, Enum.KeyCode.W)         and direction + cameralook or direction;
				direction = _IsKeyDown(UserInputService, Enum.KeyCode.S)         and direction - cameralook or direction;
				direction = _IsKeyDown(UserInputService, Enum.KeyCode.D)         and direction + _Vector3new(-cameralook.Z, 0, cameralook.X) or direction;
				direction = _IsKeyDown(UserInputService, Enum.KeyCode.A)         and direction + _Vector3new(cameralook.Z, 0, -cameralook.X) or direction;
				direction = _IsKeyDown(UserInputService, Enum.KeyCode.Space)     and direction + Vector3.yAxis or direction;
				direction = _IsKeyDown(UserInputService, Enum.KeyCode.LeftControl) and direction - Vector3.yAxis or direction;
				
				if direction.Magnitude > 0 then direction = direction.Unit end
				new_camera_pos += direction * delta * (_IsKeyDown(UserInputService, Enum.KeyCode.LeftShift) and freecam_speed / 10 or freecam_speed)
				Camera.CFrame = CFrame.new(new_camera_pos) * Camera.CFrame.Rotation
				if hrp then
					hrp.Anchored = true
				end
			end))
		end
		
		local tp_keybind; tp_keybind = mscsec:Toggle({Name = "Thirdperson", Value = false, Flag = "view_thirdperson", Callback = function(bool)
			thirdperson = bool
		end}):Keybind({Name = "Thirdperson", Mode = "Toggle", Key = Enum.KeyCode.N, Value = false, Flag = "view_thirdperson_keybind", Callback = function(bool)
			thirdperson_key = thirdperson and bool
			tp_keybind.Set(thirdperson_key, true)

			local viewmodel = _FindFirstChildOfClass(Camera, "Model")
			if viewmodel then
				vmpos(viewmodel)
			end
		end})
		mscsec:Slider({Name = "Thirdperson distance", Min = 0, Max = 15, Float = 0.1, Value = 5, Flag = "view_thirdperson_distance", Callback = function(int)
			thirdperson_distance = int
		end})
		
		mscsec:Toggle({Name = "Aspect ratio", Value = false, Flag = "view_aspect_ratio", Callback = function(bool)
			aspect_ratio = bool
		end})
		mscsec:Slider({Name = "Aspect X", Min = 0.5, Max = 1.1, Float = 0.01, Value = 1, Flag = "aspect_ratio_x", Callback = function(int)
			aspect_ratio_x = int
		end})
		mscsec:Slider({Name = "Aspect Y", Min = 0.5, Max = 1.1, Float = 0.01, Value = 1, Flag = "aspect_ratio_y", Callback = function(int)
			aspect_ratio_y = int
		end})
		

		local avatar_changer = false
		local avatar_changer_used = false

		local change_avatar = function()
			if not avatar_changer then return end

			avatar_changer_used = true

			local user_id = Library.Flags["view_avatar_userid"]
			local success, result = pcall(tonumber, user_id)
			if not success then
				return Library.Notification("Invalid number inputted", 2.5)
			end

			local valid_parts = {
				["Head"] = true,
				["LeftFoot"] = true,
				["LeftHand"] = true,
				["LeftLowerArm"] = true,
				["LeftLowerLeg"] = true,
				["LeftUpperArm"] = true,
				["LeftUpperLeg"] = true,
				["RightFoot"] = true,
				["RightHand"] = true,
				["RightLowerArm"] = true,
				["RightLowerLeg"] = true,
				["RightUpperArm"] = true,
				["RightUpperLeg"] = true,
				["LowerTorso"] = true,
				["UpperTorso"] = true
			}

			local success, wanted_plr_model = pcall(Players.CreateHumanoidModelFromUserId, Players, user_id)
			if not success then
				return Library.Notification("Invalid UserId inputted or try again later.", 2.5)
			end

			local character = LocalPlayer.Character

			if not character then
				return
			end

			for _, child in character:GetChildren() do
				local class = child.ClassName
				
				if class == "Accessory" then
					child:Destroy()
				end

				if child:GetAttribute("ItemType") then
					child:Destroy()
				end
			end

			for _, child in wanted_plr_model:GetChildren() do
				local class = child.ClassName
				
				if class == "Shirt" or class == "Pants" then
					local stuff = character:FindFirstChildOfClass(class)
					if not stuff then continue end

					stuff[class.."Template"] = child[class.."Template"]
				end

				if class == "Accessory" then
					local handle = child:FindFirstChild("Handle")
					local weld = handle and handle:FindFirstChild("AccessoryWeld")
					if not weld then continue end
					
					local weld_part = character:FindFirstChild(weld.Part1.Name)
					if not weld_part then continue end

					weld.Part1 = weld_part
					child.Parent = character
				end

				if class == "MeshPart" and valid_parts[child.Name] then
					local grrr = character:FindFirstChild(child.Name)
					if not grrr then continue end
					
					grrr.Color = child.Color
				end
			end

			wanted_plr_model:Destroy()
		end

		mscsec:Toggle({Name = "Avatar changer", Value = false, Flag = "view_avatar_changer", Callback = function(bool)
			avatar_changer = bool
			task.spawn(change_avatar)
		end})
		
		mscsec:Textbox({
			Name = "Avatar UserId",
			Value = "80254",
			Flag = "view_avatar_userid",
			Callback = function()
				task.spawn(change_avatar)
			end
		})

		local character_childadded
		if LocalPlayer.Character then
			task.spawn(change_avatar)
			character_childadded = LocalPlayer.Character.ChildAdded:Connect(function(child)
				if avatar_changer_used and child:GetAttribute("ItemType") then child:Destroy() end
			end)
		end
		LocalPlayer.CharacterAdded:Connect(function(character)
			avatar_changer_used = false
			task.spawn(change_avatar)
			character_childadded = character.ChildAdded:Connect(function(child)
				if avatar_changer_used and child:GetAttribute("ItemType") then child:Destroy() end
			end)
		end)

		LocalPlayer.CharacterRemoving:Connect(function(character)
			if character_childadded then character_childadded:Disconnect() end
		end)

		Camera.DescendantAdded:Connect(function()
			if not avatar_changer_used then return end
			local vm = _FindFirstChildOfClass(Camera, "Model")
			if not vm then return end
			for _, vm_item in vm:GetChildren() do
				if vm_item.ClassName == "Model" and (_FindFirstChild(vm_item, "LL") or _FindFirstChild(vm_item, "LH")) then
					vm_item:Destroy()
				end
			end
		end)

		Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
			if Camera.FieldOfView ~= zoom_size and Camera.FieldOfView ~= fov_changer_size then
				old_fov = Camera.FieldOfView
			end
			if not (zoom and zoom_key or fov_changer) then return end 
			Camera.FieldOfView = (zoom and zoom_key and zoom_size) or (fov_changer and fov_changer_size)
		end)

		local NeckDefaultC0 = CFrame.new(0, 0.8, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		local WaistDefaultC0 = CFrame.new(0, 0.2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		local RightShoulderDefaultC0 = CFrame.new(1, 0.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		local LeftShoulderDefaultC0 = CFrame.new(-1, 0.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)

		local update_neck_loop = function(Character)
			while Character and LocalPlayer.Character == Character do
				local Delta, Head
				repeat
					Delta = task.wait(1/60) / 0.2
					Head = _FindFirstChild(Character, "Head")
				until Head
				local Humanoid = _FindFirstChild(Character, "Humanoid")
				if not (Humanoid and Humanoid.Health ~= 0) then
					continue
				end
				local UpperTorso	= _FindFirstChild(Character, "UpperTorso")
				local RightUpperArm = _FindFirstChild(Character, "RightUpperArm")
				local LeftUpperArm  = _FindFirstChild(Character, "LeftUpperArm")
				if not (UpperTorso and RightUpperArm and LeftUpperArm) then continue end
				local Waist		 = _FindFirstChild(UpperTorso, "Waist")
				local Neck		  = _FindFirstChild(Head, "Neck")
				local RightShoulder = _FindFirstChild(RightUpperArm, "RightShoulder")
				local LeftShoulder  = _FindFirstChild(LeftUpperArm, "LeftShoulder")
				if not (Waist and Neck and RightShoulder and LeftShoulder) then continue end

				local LookAt = _FindFirstChild(Character, "LookAt")
				if LookAt then
					local NewUpAngle
					if LookAt.Value then
						local FunnyMath = _CFramenew(Character:GetPivot().Position, LookAt.Value:GetPivot().Position).lookVector.Y * 0.55
						NewUpAngle = math.asin(FunnyMath) or 0
					else
						NewUpAngle = 0
					end
					Character:SetAttribute("UpAngle", NewUpAngle)
				end
				local UpAngle	   = (thirdperson and thirdperson_key) and Character:GetAttribute("UpAngle") or 0
				local SideAngle	 = (thirdperson and thirdperson_key) and Character:GetAttribute("SideAngle") or 0
				local HeadUpAngle   = (thirdperson and thirdperson_key) and Character:GetAttribute("HeadUpAngle") or 0
				local HeadSideAngle = (thirdperson and thirdperson_key) and Character:GetAttribute("HeadSideAngle") or 0
				local CalculatedCFrame = nil
				if Humanoid.SeatPart then
					if Humanoid.SeatPart.ClassName == "VehicleSeat" then
						CalculatedCFrame = CFrame.Angles(UpAngle, SideAngle / 3, 0)
						Neck.C0 = Neck.C0:lerp(NeckDefaultC0 * CalculatedCFrame, Delta)
					else
						CalculatedCFrame = CFrame.Angles(UpAngle, SideAngle / 4, 0)
						Waist.C0 = Waist.C0:lerp(WaistDefaultC0 * CFrame.Angles(UpAngle / 4, SideAngle / 3, 0), Delta)
						Neck.C0 = Neck.C0:lerp(NeckDefaultC0 * CalculatedCFrame, Delta)
						RightShoulder.C0 = RightShoulder.C0:lerp(RightShoulderDefaultC0 * CalculatedCFrame, Delta)
						LeftShoulder.C0 = LeftShoulder.C0:lerp(LeftShoulderDefaultC0 * CalculatedCFrame, Delta)
					end
				elseif HeadSideAngle == 0 then
					CalculatedCFrame = CFrame.Angles(UpAngle, 0, 0)
					Waist.C0 = Waist.C0:lerp(WaistDefaultC0 * CalculatedCFrame, Delta)
					Neck.C0 = Neck.C0:lerp(NeckDefaultC0 * CalculatedCFrame, Delta)
					RightShoulder.C0 = RightShoulder.C0:lerp(RightShoulderDefaultC0 * CalculatedCFrame, Delta)
					LeftShoulder.C0 = LeftShoulder.C0:lerp(LeftShoulderDefaultC0 * CalculatedCFrame, Delta)
				else
					Neck.C0 = Neck.C0:lerp(NeckDefaultC0 * CFrame.Angles(HeadUpAngle, HeadSideAngle, 0), Delta)
				end
				if CalculatedCFrame then
					for _, part in Character:GetChildren() do
						if part.ClassName == "Model" and part:FindFirstChild("ItemRoot") then
							local Motor6D = part.ItemRoot:FindFirstChild("Motor6D")
							if Motor6D then
								Motor6D.C0 = Motor6D.C0:lerp(CFrame.new(0, 0, -UpAngle * 0.5) * CalculatedCFrame, Delta)
							end
						end
					end
				end
			end
		end

		if LocalPlayer.Character then task.spawn(update_neck_loop, LocalPlayer.Character) end
		LocalPlayer.CharacterAdded:Connect(update_neck_loop)
	end
	do 
		do
			local indicator_holder = Instance.new("Frame")
			indicator_holder.Parent = game:GetService("CoreGui").RobloxGui
			indicator_holder.BackgroundTransparency = 1
			indicator_holder.BorderSizePixel = 0
			indicator_holder.Position = UDim2.new(0, -GuiInset.X, 0, -GuiInset.Y)
			indicator_holder.ZIndex = 2

			local default_font = Fonts.Get("SmallestPixel7")

			local indicator_text = Instance.new("TextLabel")
			indicator_text.Parent = indicator_holder
			indicator_text.AnchorPoint = Vector2.new(0, 0)
			indicator_text.BackgroundTransparency = 1
			indicator_text.BorderSizePixel = 0
			indicator_text.Position = UDim2.new(0, 2, 0, 0)
			indicator_text.FontFace = default_font
			indicator_text.Text = ""
			indicator_text.TextColor3 = Color3.new(1, 1, 1)
			indicator_text.TextSize = 9
			indicator_text.TextStrokeTransparency = 0
			indicator_text.TextXAlignment = Enum.TextXAlignment.Left
			indicator_text.TextYAlignment = Enum.TextYAlignment.Top

			local off_color, on_color = Color3.new(1, 0.1, 0.1), Color3.new(0.1, 1, 0.1)
			local off_transparency, on_transparency = 0, 0

			do
				local toggle = lclsec:Toggle({Name = "Visor indicator", Value = false, Flag = "visor_indicator", Callback = function(bool)
					indicator_holder.Visible = bool
				end})
				toggle:Colorpicker({Name = "Indicator Off Color", Value = Color3.new(1, 0.3, 0.3), Usealpha = true, Flag = "visor_indicator_off_color", Callback = function(color)
					off_color = color.c
					off_transparency = color.a
				end})
				toggle:Colorpicker({Name = "Indicator On Color", Value = Color3.new(0.3, 1, 0.3), Usealpha = true, Flag = "visor_indicator_on_color", Callback = function(color)
					on_color = color.c
					on_transparency = color.a
				end})
			end
			lclsec:Dropdown({Name = "Indicator font", Values = {
				"Tahoma",
				"TahomaXP",
				"Comfortaa",
				"Verdana",
				"SmallestPixel7",
				"Proggy",
			}, Value = {"SmallestPixel7"}, Flag = "visor_indicator_font", Multi = false, Callback = function(str)
				indicator_text.FontFace = Fonts.Get(str or "SmallestPixel7") or default_font
			end})
			lclsec:Slider({Name = "Indicator size", Min = 1, Max = 30, Float = 1, Value = 9, Flag = "visor_indicator_size", Suffix = "%spx", Callback = function(int)
				indicator_text.TextSize = int
			end})
			lclsec:Slider({Name = "Indicator X", Min = 0, Max = 100, Float = 1, Value = 5, Flag = "visor_indicator_x", Suffix = "%s%%", Callback = function(int)
				indicator_holder.Position = UDim2.new(int / 100, -GuiInset.X, indicator_holder.Position.Y.Scale, -GuiInset.Y)
				indicator_text.TextXAlignment = int < 50 and Enum.TextXAlignment.Left or int > 50 and Enum.TextXAlignment.Right or Enum.TextXAlignment.Center
				indicator_text.Position = UDim2.new(int < 50 and 0 or int > 50 and 1 or 0.5, 0, 0, 0)
				indicator_text.AnchorPoint = Vector2.new(int < 50 and 0 or int > 50 and 1 or 0.5, 0)
			end})
			lclsec:Slider({Name = "Indicator Y", Min = 0, Max = 100, Float = 1, Value = 5, Flag = "visor_indicator_y", Suffix = "%s%%", Callback = function(int)
				indicator_holder.Position = UDim2.new(indicator_holder.Position.X.Scale, -GuiInset.X, int / 100, -GuiInset.Y)
				
			end})

			local lpo = cheat.player_list[LocalPlayer]
			cheat.utility.new_heartbeat(LPH_JIT(function()		
				if lpo.visor then
					indicator_text.Text = "visor on"
					indicator_text.TextColor3 = on_color
					indicator_text.TextTransparency = on_transparency
				else
					indicator_text.Text = "visor off"
					indicator_text.TextColor3 = off_color
					indicator_text.TextTransparency = off_transparency
				end
			end))
		end
		lclsec:Toggle({Name = "Remove screen effects", Value = false, Flag = "no_screen_effects", Callback = function(bool)
			no_screen_effects = bool
		end})

		lclsec:Toggle({Name = "Gun changer", Value = false, Flag = "gun_changer", Callback = function(bool)
			gun_changer = bool
		end})
		lclsec:Colorpicker({Name = "Gun color", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "gun_color", Callback = function(color)
			gun_color = color.c
		end})
		lclsec:Dropdown({Name = "Gun material", Values = {"ForceField", "Neon", "SmoothPlastic", "Glass"}, Value = "ForceField", Flag = "gun_material", Multi = false, Callback = function(str)
			gun_material = str and Enum.Material[str] or Enum.Material.ForceField
		end})

		lclsec:Toggle({Name = "Arm changer", Value = false, Flag = "arm_changer", Callback = function(bool)
			arm_changer = bool
		end})
		lclsec:Colorpicker({Name = "Arm color", Value = Color3.new(1, 1, 1), Usealpha = false, Flag = "arm_color", Callback = function(color)
			arm_color = color.c
		end})
		lclsec:Dropdown({Name = "Arm material", Values = {"ForceField", "Neon", "SmoothPlastic", "Glass"}, Value = "ForceField", Flag = "arm_material", Multi = false, Callback = function(str)
			arm_material = str and Enum.Material[str] or Enum.Material.ForceField
		end})

		lclsec:Toggle({Name = "Viewmodel changer", Value = false, Flag = "viewmodel_changer", Callback = function(bool)
			viewmodel_changer = bool
		end})
		lclsec:Slider({Name = "X offset", Min = -5, Max = 5, Float = 0.1, Value = 0, Flag = "viewmodel_x", Callback = function(int)
			viewmodel_x = int
			if not viewmodel_changer then
				return
			end
			local viewmodel = _FindFirstChildOfClass(Camera, "Model")
			if viewmodel then
				vmpos(viewmodel)
			end
		end})
		lclsec:Slider({Name = "Y offset", Min = -5, Max = 5, Float = 0.1, Value = 0, Flag = "viewmodel_y", Callback = function(int)
			viewmodel_y = int
			if not viewmodel_changer then
				return
			end
			local viewmodel = _FindFirstChildOfClass(Camera, "Model")
			if viewmodel then
				vmpos(viewmodel)
			end
		end})
		lclsec:Slider({Name = "Z offset", Min = -5, Max = 5, Float = 0.1, Value = 0, Flag = "viewmodel_z", Callback = function(int)
			viewmodel_z = int
			if not viewmodel_changer then
				return
			end
			local viewmodel = _FindFirstChildOfClass(Camera, "Model")
			if viewmodel then
				vmpos(viewmodel)
			end
		end})

		Camera.ChildAdded:Connect(vmpos)
		Camera.DescendantAdded:Connect(vmchams)
		Camera.ChildRemoved:Connect(vmunpos)

		task.spawn(function()
			while task.wait(0.5) do
				local playergui = LocalPlayer.PlayerGui
				local noinsetgui = playergui and _FindFirstChild(playergui, "NoInsetGui")
				local mainframe = noinsetgui and _FindFirstChild(noinsetgui, "MainFrame")
				local screeneffects = mainframe and _FindFirstChild(mainframe, "ScreenEffects")
				if screeneffects then screeneffects.Visible = not no_screen_effects end
			end
		end)
	end
end

local antiaim, antiaim_pitch, antiaim_pitch_value = false, false, 0

do
	local movebox = ui.sections.movement
	local miscbox = ui.sections.misc
	local antibox = ui.sections.antiaim
	local animbox = ui.sections.antiaim_animations

	local speedhack, speedhack_speed = false, 18.2
	local speedhack_autospeed, speedhack_autospeed_offset = false, 3.5

	local jumphack, jumphack_height = false, 5

	local flyhack, flyhack_key, flyhack_speed, flyhack_speed_y = false, false, 100, 100

	local jesus, nowater, bunnyhop = false, false, false

	local antiaim_yaw, antiaim_jitter, antiaim_spin = false, false, false
	local antiaim_amongus = false
	local antiaim_yaw_value, antiaim_jitter_value, antiaim_spin_value = 180, 0, 0
	do
		miscbox:Button({Name = "Rejoin", Confirm = true, Callback = function()
			if #Players:GetPlayers() <= 1 then
				LocalPlayer:Kick("\nRejoining...")
				wait()
				game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
			else
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
			end
		end})

		miscbox:Toggle({Name = "Hide server info", Value = false, Flag = "hide_server_info", Callback = function(bool)
			local playergui = LocalPlayer.PlayerGui
			local serverinfo = _FindFirstChild(playergui, "ServerInfo")
			local frame = serverinfo and _FindFirstChild(serverinfo, "Frame")
			local textlabel = frame and _FindFirstChild(frame, "serverInfo")
			if textlabel then
				textlabel.Visible = not bool
			end
		end})

		local shitcode, shitcode_tick, shitcode_factor = false, tick(), (mathrandom() - 0.5) * 5
		miscbox:Toggle({Name = "Old swimhub mode", Flag = "old_swimhub_mode", Value = false, Callback = function(v)
			shitcode = v
			shitcode_tick = tick()
			task.spawn(function()
				while shitcode do
					if tick() - shitcode_tick > 1/(24 + shitcode_factor) then
						shitcode_tick = tick()
						shitcode_factor = (mathrandom() - 0.5) * 5
						RunService.RenderStepped:Wait()
					end
					task.wait()
				end
			end)
		end})

		local cross_script_chat; cross_script_chat = miscbox:Toggle({Name = "Cross-script chat", Flag = "cross_script_chat", Value = false, Callback = function(v)
			if v and not cheat.CrossScriptChat then
				cross_script_chat.Set(false, true)
				return Library.Notification("Cross-script chat is loading at the moment. Please wait.", 2.5)
			end
			if cheat.CrossScriptChat then
				cheat.CrossScriptChat.SetSendingEnabled(v)
			end
		end})

		local remove_landmines = false
		local mine_names = { MON50 = true, PMN2 = true, Claymore = true }
		miscbox:Toggle({Name = "Remove Landmines (PMN2 + MON50)", Value = false, Flag = "remove_landmines", Callback = function(bool)
			remove_landmines = bool
		end})
		task.spawn(function()
			local function sweep_mines()
				if not remove_landmines then return end
				pcall(function()
					local az = Workspace:FindFirstChild("AiZones")
					local mines = az and az:FindFirstChild("OutpostLandmines")
					if mines then
						for _, v in ipairs(mines:GetChildren()) do
							v:Destroy()
						end
					end
				end)
			end
			sweep_mines()
			Workspace.DescendantAdded:Connect(function(v)
				if remove_landmines and mine_names[v.Name] then
					pcall(function() v:Destroy() end)
				end
			end)
			while task.wait(15) do
				sweep_mines()
				if remove_landmines then
					pcall(function()
						for _, v in ipairs(Workspace:GetDescendants()) do
							if mine_names[v.Name] then
								v:Destroy()
							end
						end
					end)
				end
			end
		end)
	end
	do
		local nofall = false

		movebox:Toggle({Name = "No fall damage", Value = false, Flag = "no_fall_damage", Callback = function(bool)
			nofall = bool
		end})

		local falling_states = {
			Enum.HumanoidStateType.FallingDown,
			Enum.HumanoidStateType.Freefall,
			Enum.HumanoidStateType.PlatformStanding
		}

		local character = LocalPlayer.Character
		local hum = character and _FindFirstChildOfClass(character, "Humanoid")
		local old_nofall_pos, should_no_fall = nil, false

		

		task.spawn(function()
			while RunService.Heartbeat:Wait() do
				local character = LocalPlayer.Character
				if not character then
					continue
				end

				local hrp = _FindFirstChild(character, "HumanoidRootPart")
				local hum = _FindFirstChildOfClass(character, "Humanoid")
				if not (hrp and hum) then
					continue
				end

				local currpos = hrp.CFrame.Position

				if not nofall or not table.find(falling_states, hum:GetState()) then
					should_no_fall = false
					continue
				end

				hum:ChangeState(Enum.HumanoidStateType.Running)
				should_no_fall = true
			end
		end)

		local state_changed = LPH_NO_VIRTUALIZE(function(old, new)
			if should_no_fall and table.find(falling_states, new) then
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)
		local state_connection
		if hum then
			state_connection = hum.StateChanged:Connect(state_changed)
		end
		LocalPlayer.CharacterAdded:Connect(function(character)
			local humanoid = character:WaitForChild("Humanoid")
			if state_connection then state_connection:Disconnect() end
			state_connection = humanoid.StateChanged:Connect(state_changed)
		end)
	end
	do
		antibox:Toggle({Name = "Enabled", Value = false, Flag = "antiaim_enabled", Callback = function(bool)
			antiaim = bool
		end})

		antibox:Toggle({Name = "Pitch modifier", Value = false, Flag = "antiaim_pitch", Callback = function(bool)
			antiaim_pitch = bool
		end})
		antibox:Slider({Name = "Pitch value", Min = -1, Max = 1, Float = 0.05, Value = 0, Flag = "antiaim_pitch_value", Callback = function(int)
			antiaim_pitch_value = int
		end})

		antibox:Toggle({Name = "Yaw modifier", Value = false, Flag = "antiaim_yaw", Callback = function(bool)
			antiaim_yaw = bool
		end})
		antibox:Slider({Name = "Yaw value", Min = -180, Max = 180, Float = 5, Value = 0, Flag = "antiaim_yaw_value", Callback = function(int)
			antiaim_yaw_value = math.rad(int)
		end})

		antibox:Toggle({Name = "Yaw jitter", Value = false, Flag = "antiaim_jitter", Callback = function(bool)
			antiaim_jitter = bool
		end})
		antibox:Slider({Name = "Jitter strength", Min = 0, Max = 90, Float = 1, Value = 45, Flag = "antiaim_jitter_value", Callback = function(int)
			antiaim_jitter_value = math.rad(int)
		end})

		antibox:Toggle({Name = "Yaw spin", Value = false, Flag = "antiaim_spin", Callback = function(bool)
			antiaim_spin = bool
		end})
		antibox:Slider({Name = "Spin speed", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "antiaim_spin_value", Callback = function(int)
			antiaim_spin_value = math.rad(int * 36)
		end})
		antibox:Toggle({Name = "Amongus", Value = false, Flag = "antiaim_amongus", Callback = function(bool)
			antiaim_amongus = bool
		end})

		local updatetilt_remote = project_delta.updatetilt_remote
		local jitter_side, jitter_timer, spin_timer = false, 0, 0
		cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
			local char = LocalPlayer.Character
			local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
			local hum = char and _FindFirstChildOfClass(char, "Humanoid")

			if not (hrp and hum) then return end

			hum.AutoRotate = not antiaim
			if antiaim then
				local _, calc_yaw, _ = Camera.CFrame:ToOrientation()

				if antiaim_amongus then
					updatetilt_remote:FireServer(-1, 0)
				elseif antiaim_pitch then
					updatetilt_remote:FireServer(antiaim_pitch_value, 0)
				end
				if antiaim_yaw then
					calc_yaw += antiaim_yaw_value
				end
				if antiaim_jitter then
					jitter_timer += delta
					if jitter_side then
						calc_yaw += antiaim_jitter_value
					else
						calc_yaw -= antiaim_jitter_value
					end
					if jitter_timer > 1/32 then
						jitter_side = not jitter_side
						jitter_timer = jitter_timer % (1/32)
					end
				end
				if antiaim_spin then
					calc_yaw += ((tick() * antiaim_spin_value) % 1) * (math.pi * 2)
				end

				local hrp_x, _, hrp_z = hrp.CFrame:ToOrientation()
				if antiaim_amongus then
					hrp_x = -1.25
				end
				hrp.CFrame = _CFramenew(hrp.Position) * CFrame.Angles(hrp_x, calc_yaw, hrp_z)
			end
		end))
	end
	do
		movebox:Toggle({Name = "Speedhack", Value = false, Flag = "speedhack", Callback = function(bool)
			speedhack = bool
		end})
		movebox:Toggle({Name = "Speedhack auto speed", Value = false, Flag = "speedhack_autospeed", Callback = function(bool)
			speedhack_autospeed = bool
		end})
		movebox:Slider({Name = "Speedhack speed", Min = 1, Max = 24, Float = 0.1, Value = 18.2, Flag = "speedhack_speed", Callback = function(int)
			speedhack_speed = int
		end})
		movebox:Slider({Name = "Auto speed offset", Min = -5, Max = 5, Float = 0.1, Value = 3.5, Flag = "speedhack_autospeed_offset", Callback = function(int)
			speedhack_autospeed_offset = int
		end})

		movebox:Toggle({Name = "Jumphack", Value = false, Flag = "jumphack", Callback = function(bool)
			jumphack = bool
		end})
		movebox:Slider({Name = "Jumphack height", Min = 1, Max = 10, Float = 0.1, Value = 5, Flag = "jumphack_height", Callback = function(int)
			jumphack_height = int
		end})

		local fh_keybind; fh_keybind = movebox:Toggle({Name = "Flyhack", Value = false, Flag = "flyhack", Callback = function(bool)
			flyhack = bool
		end}):Keybind({Name = "Flyhack", Mode = "Toggle", Key = Enum.KeyCode.X, Value = false, Flag = "flyhack_key", Callback = function(bool)
			flyhack_key = flyhack and bool
			fh_keybind.Set(flyhack_key, true)
		end})
		movebox:Slider({Name = "Flyhack speed", Min = 0, Max = 50, Float = 1, Value = 25, Flag = "flyhack_speed", Callback = function(int)
			flyhack_speed = int
		end})
		movebox:Slider({Name = "Flyhack speed Y", Min = 0, Max = 50, Float = 1, Value = 25, Flag = "flyhack_speed_y", Callback = function(int)
			flyhack_speed_y = int
		end})
		movebox:Toggle({Name = "Jesus", Value = false, Flag = "jesus", Callback = function(bool)
			jesus = bool
		end})
		movebox:Toggle({Name = "No Water Physics", Value = false, Flag = "no_water_physics", Callback = function(bool)
			nowater = bool
		end})
		movebox:Toggle({Name = "Bunnyhop", Value = false, Flag = "bunnyhop", Callback = function(bool)
			bunnyhop = bool
		end})
		movebox:Toggle({Name = "No Drown", Value = false, Flag = "no_drown", Callback = function(bool)
			((getgenv and getgenv()) or _G).zzzhub_no_drown = bool
		end})
	end

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		local char = LocalPlayer.Character
		local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
		local hum = char and _FindFirstChildOfClass(char, "Humanoid")

		if not (hrp and hum) then return end

		local calcspeed = speedhack_autospeed and project_delta.calculate_speed(hrp) + speedhack_autospeed_offset or speedhack_speed
		if speedhack then
			hum.WalkSpeed = calcspeed
		end
		if jumphack then
			hum.JumpHeight = jumphack_height
		end

		if jesus or nowater or bunnyhop then
			local in_water = (hum.FloorMaterial == Enum.Material.Water)
			local water_y = nil
			if jesus or nowater then
				local water_params = RaycastParams.new()
				water_params.FilterType = Enum.RaycastFilterType.Exclude
				water_params.FilterDescendantsInstances = {char}
				water_params.IgnoreWater = false
				local hit = workspace:Raycast(hrp.Position, _Vector3new(0, -6, 0), water_params)
				if hit and hit.Instance and hit.Instance.Material == Enum.Material.Water then
					in_water = true
					water_y = hit.Position.Y
				end
			end
			if jesus and in_water and water_y then
				hrp.CFrame = CFrame.new(hrp.Position.X, water_y + 3.1, hrp.Position.Z)
				hrp.AssemblyLinearVelocity = _Vector3new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
			end
			if nowater and in_water then
				local vel = hrp.AssemblyLinearVelocity
				hrp.AssemblyLinearVelocity = _Vector3new(vel.X * 1.35, vel.Y, vel.Z * 1.35)
			end
			if bunnyhop and not in_water and hum.FloorMaterial ~= Enum.Material.Air then
				pcall(function() hum.Jump = true end)
			end
		end

		local cameralook = (_Vector3new(1, 0, 1) * Camera.CFrame.LookVector).Unit
		local direction = _Vector3new(0, 0, 0)
		direction = _IsKeyDown(UserInputService, Enum.KeyCode.W) and direction + cameralook or direction;
		direction = _IsKeyDown(UserInputService, Enum.KeyCode.S) and direction - cameralook or direction;
		direction = _IsKeyDown(UserInputService, Enum.KeyCode.D) and direction + _Vector3new(-cameralook.Z, 0, cameralook.X) or direction;
		direction = _IsKeyDown(UserInputService, Enum.KeyCode.A) and direction + _Vector3new(cameralook.Z, 0, -cameralook.X) or direction;
		if direction ~= Vector3.zero then
			direction = direction.Unit
		end
		if flyhack and flyhack_key then
			local ydir = Vector3.zero
			ydir = _IsKeyDown(UserInputService, Enum.KeyCode.Space)	      and ydir + Vector3.yAxis or ydir;
			ydir = _IsKeyDown(UserInputService, Enum.KeyCode.LeftControl) and ydir - Vector3.yAxis or ydir;
			hrp.AssemblyLinearVelocity = _Vector3new(0, 0, 0)
			hrp.CFrame = hrp.CFrame + (_Vector3new(1, 0, 1) * direction * flyhack_speed * delta + flyhack_speed_y * ydir * delta)
		elseif speedhack then
			local hmm = direction * calcspeed
			hrp.AssemblyLinearVelocity = _Vector3new(hmm.X, hrp.AssemblyLinearVelocity.Y, hmm.Z)
		end
	end))
end

local character, hrp, head

do
	local dscsec = ui.sections.custom_desync
	local expsec = ui.sections.exploit

	local desync_visualize = false
	local desync_x_offset, desync_y_offset, desync_z_offset = 0, 0, 0
	local desync_x_rotate, desync_y_rotate, desync_z_rotate = 0, 0, 0
	local desync_random_rotation, desync_random_position = false, false
	local desync_random_position_range = 5

	local desync_velocity = false
	local desync_velocity_x, desync_velocity_y, desync_velocity_z = 0, 0, 0

	local raksync, raksync_key, raksync_replicate_next = false, false, false

	local main_wireframe = Instance.new("WireframeHandleAdornment")
	main_wireframe.Parent = game:GetService("CoreGui").RobloxGui
	main_wireframe.Adornee = workspace
	main_wireframe.Color3 = Color3.new(1, 1, 1)
	main_wireframe.Transparency = 0
	main_wireframe.AlwaysOnTop = true
	main_wireframe.CFrame = CFrame.new()
	main_wireframe.Scale = Vector3.one
	main_wireframe.Thickness = 1
	main_wireframe.AdornCullingMode = Enum.AdornCullingMode.Automatic

	do 
		local original_rate, original_bandwidth = getfflag("S2PhysicsSenderRate"), getfflag("PhysicsSenderMaxBandwidthBps")

		local desync_freeze, desync_freeze_key, desync_freeze_factor = false, false, 100
		local desync_ready, desync_turned_on = true, false

		local set_physics_rate = function(rate, bandwidth)
			setfflag("S2PhysicsSenderRate", tostring(rate))
			setfflag("PhysicsSenderMaxBandwidthBps", tostring(bandwidth))
		end

		local get_hrp = function()
			local character = LocalPlayer.Character
			return character and _FindFirstChild(character, "HumanoidRootPart")
		end

		local toggle_desync = function(state, reason)
			if not state then
				desync_turned_on = false
				if reason then
					Library.Notification(reason, 2.5)
				end
				return set_physics_rate(original_rate, original_bandwidth)
			end

			local hrp = get_hrp()
			if not hrp then return toggle_desync(false, "No character found.") end

			forced_cframe = nil

			set_physics_rate(32767, 32767 * 32)

			desync_turned_on = true
			RunService.Heartbeat:Wait()

			for _ = 1, 3 do
				hrp.AssemblyLinearVelocity += Vector3.new(0, 1, 0)
				RunService.Heartbeat:Wait()
				if not hrp then
					return toggle_desync(false, "Character destroyed in preparation process.")
				end
			end

			desync_ready = false
			forced_cframe = hrp.CFrame

			local recorded_time = tick()
			repeat until tick() - recorded_time > 0.8

			Library.Notification("Don't move for until this notification goes away.", 3)

			task.wait(3)

			set_physics_rate(15, 15 * 32)

			desync_ready = true
			forced_cframe = nil
		end

		local des_keybind; des_keybind = expsec:Toggle({Name = "Freeze desync", Value = false, Flag = "desync_freeze", Callback = function(bool)
			desync_freeze = bool
			if not desync_freeze then
				toggle_desync(false)
			end
		end}):Keybind({Name = "Freeze desync", Mode = "Toggle", Key = Enum.KeyCode.M, Value = false, Flag = "desync_freeze_key", Callback = function(bool)
			if not desync_ready then
				des_keybind.Set(false, true)
				return Library.Notification("Freeze is not ready yet!", 2.5)
			end

			desync_freeze_key = desync_freeze and bool
			des_keybind.Set(desync_freeze_key, true)
			if desync_freeze_key then
				task.spawn(toggle_desync, desync_freeze_key)
			end
		end})

		expsec:Slider({Name = "Freeze factor", Min = 0, Max = 500, Float = 10, Value = 100, Flag = "desync_freeze_factor", Callback = function(int)
			desync_freeze_factor = int
		end})

		local detonation_mode = "All"
		expsec:Dropdown({Name = "Detonation mode", Values = {"All", "One"}, Value = "All", Flag = "detonation_mode", Callback = function(str)
			detonation_mode = str
		end})
		expsec:Button({Name = "Explode Landmines", Confirm = true, Callback = function()
			local char = LocalPlayer.Character
			local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
			if not hrp then return end
			if typeof(firetouchinterest) ~= "function" then
				Library.Notification("Executor lacks firetouchinterest.", 3)
				return
			end
			local az = workspace:FindFirstChild("AiZones")
			local mines = az and az:FindFirstChild("OutpostLandmines")
			if not mines then
				Library.Notification("No landmines found.", 3)
				return
			end
			local n = 0
			for _, m in ipairs(mines:GetChildren()) do
				local trig = m:FindFirstChild("Trigger")
				if trig and trig:IsA("BasePart") then
					pcall(function()
						firetouchinterest(hrp, trig, 0)
						task.wait()
						firetouchinterest(hrp, trig, 1)
					end)
					n += 1
					if detonation_mode ~= "All" then break end
				end
			end
			Library.Notification(n > 0 and ("Detonated " .. n) or "No triggers found.", 3)
		end})
		local uaz_spawn_type = "Nearest"
		expsec:Dropdown({Name = "UAZ Spawn Type", Values = {"Farthest", "Nearest", "Random"}, Value = "Nearest", Flag = "uaz_spawn_type", Callback = function(str)
			uaz_spawn_type = str
		end})
		expsec:Button({Name = "Spawn UAZ", Confirm = true, Callback = function()
			local char = LocalPlayer.Character
			local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
			if not hrp then return end
			local found = {}
			for _, model in ipairs(workspace:GetDescendants()) do
				if model:IsA("Model") and string.find(model.Name, "UAZ", 1, true) then
					local root = model.PrimaryPart or _FindFirstChild(model, "HumanoidRootPart") or _FindFirstChild(model, "Body")
					if root then found[#found + 1] = model end
				end
			end
			if #found == 0 then
				Library.Notification("No UAZ found.", 3)
				return
			end
			local pick = found[1]
			if uaz_spawn_type == "Random" then
				pick = found[math.random(1, #found)]
			else
				local bestd = uaz_spawn_type == "Nearest" and math.huge or -1
				for _, model in ipairs(found) do
					local root = model.PrimaryPart or _FindFirstChild(model, "HumanoidRootPart") or _FindFirstChild(model, "Body")
					local d = (root.Position - hrp.Position).Magnitude
					if (uaz_spawn_type == "Nearest" and d < bestd) or (uaz_spawn_type ~= "Nearest" and d > bestd) then
						bestd, pick = d, model
					end
				end
			end
			pcall(function()
				pick:PivotTo(hrp.CFrame * CFrame.new(0, 0, -10))
			end)
			Library.Notification("UAZ moved to you (" .. uaz_spawn_type .. ").", 3)
		end})
		local selected_traders = {"Blaze", "Mihkel", "Nurse", "Seryozha"}
		expsec:Dropdown({Name = "Traders", Values = {"Anna", "Blaze", "Boss", "Designer", "Jake", "Mihkel", "Nurse", "Seryozha"}, Value = {"Blaze", "Mihkel", "Nurse", "Seryozha"}, Flag = "selected_traders", Multi = true, Callback = function(tbl)
			selected_traders = tbl
		end})
		expsec:Button({Name = "Teleport Traders", Confirm = true, Callback = function()
			local char = LocalPlayer.Character
			local hrp = char and _FindFirstChild(char, "HumanoidRootPart")
			if not (hrp and selected_traders and #selected_traders > 0) then return end
			local n = 0
			for i, npc_name in ipairs(selected_traders) do
				local npc = workspace:FindFirstChild(npc_name)
				local root = npc and _FindFirstChild(npc, "HumanoidRootPart")
				if root then
					local a = i / #selected_traders * math.pi * 2
					pcall(function()
						root.CFrame = CFrame.lookAt(hrp.Position + _Vector3new(math.cos(a) * 6, 0, math.sin(a) * 6), hrp.Position)
						for _, p in ipairs(npc:GetDescendants()) do
							if p:IsA("BasePart") then p.CanCollide = false end
						end
					end)
					n += 1
				end
			end
			Library.Notification(n > 0 and ("Summoned " .. n .. " traders.") or "Traders not found.", 3)
		end})
		expsec:Button({Name = "Unlock Traders", Callback = function()
			for _, npc_name in ipairs({"Boss", "Jake"}) do
				local npc = workspace:FindFirstChild(npc_name)
				if npc then
					pcall(function()
						npc:SetAttribute("Hidden", false)
						for _, p in ipairs(npc:GetDescendants()) do
							if p:IsA("BasePart") then
								local par = p.Parent
								if not (par and par.Name == "Hint") and p.Name ~= "HumanoidRootPart" and p.Name ~= "FaceHitBox" and p.Name ~= "HeadTopHitBox" then
									p.Transparency = 0
								end
							elseif p:IsA("Decal") and p.Name == "face" then
								p.Transparency = 0
							elseif p:IsA("BillboardGui") and p.Parent and (p.Parent.Name == "TargetAttachment" or p.Parent.Name == "Head") then
								p.Enabled = true
							end
						end
					end)
				end
			end
			Library.Notification("Traders unlocked.", 3)
		end})

		local old = 0
		local isSleeping = false
		RunService.Heartbeat:Connect(function()
			if not (desync_turned_on) then
				return
			end

			local hrp = get_hrp()
			if not hrp then return end

			local now = tick()
			local factor = 1 / desync_freeze_factor
			if now - old >= factor then
				old = now
				isSleeping = not isSleeping
				sethiddenproperty(hrp, "NetworkIsSleeping", isSleeping)
				
				
			end
		end)

		

		
		
	end

	if type(raknet) == "table" then

		local rak_keybind; rak_keybind = expsec:Toggle({Name = "Raksync", Value = false, Flag = "desync_raksync", Callback = function(bool)
			raksync = bool
		end}):Keybind({Name = "Raksync", Mode = "Toggle", Key = Enum.KeyCode.M, Value = false, Flag = "desync_raksync_key", Callback = function(bool)
			raksync_key = raksync and bool
			rak_keybind.Set(raksync_key, true)
		end})
		

		local function disect(packetData)
			local iter = 0
			local hextable = {}
			local hex = buffer.tostring(packetData):gsub(".", function(char)
				iter += 1
				local st = string.format("%x", char:byte())
				local rs = (#st == 1 and "0" or "") .. st
				hextable[iter - 1] = rs
				return rs .. " " .. (iter % 8 == 0 and "\n" or "")
			end)
			return hextable, hex
		end

		local old_packet_timer

		if ({identifyexecutor()})[1] == "Synapse Z" then

		elseif typeof(raknet) == "table" and raknet.add_send_hook then
			raknet.add_send_hook(function(packetData)
				local ok, err = pcall(function()
					local packetId = buffer.readu8(packetData, 0)
					if packetId == 0x1B then
						if not (raksync and raksync_key) then
							old_packet_timer = nil
							return true
						end

						local hextable, hex = disect(packetData)

						local packet_timer = ""
						local packet_id = ""
						for i = 1, 8 do
							packet_timer ..= hextable[i]
						end
						for i = 9, 16 do
							packet_id ..= hextable[i]
						end

						packet_timer, packet_id = tonumber(packet_timer, 16), tonumber(packet_id, 16)

						if not old_packet_timer then
							old_packet_timer = packet_timer
						end

						packet_timer = old_packet_timer

						local axx = buffer.create(4)
						buffer.writeu32(axx, 0, packet_timer)
						local packet_timer_hex = disect(axx)
						for i = 0, 3 do
							local n = tonumber(packet_timer_hex[i],16)
							buffer.writeu8(packetData, 8 - i , n)
						end
						local hextable, hex = disect(packetData)
					end
				end)
				if not ok then
					return true
				end
				return true
			end)
		end
	end

	getgenv().animbreaker_x = 0
	getgenv().animbreaker_y = 0
	getgenv().animbreaker_z = 0

	expsec:Slider({Name = "X animbreaker", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "animbreaker_x_offset", Callback = function(int)
		getgenv().animbreaker_x = int
	end})
	expsec:Slider({Name = "Y animbreaker", Min = -1.4, Max = 1.4, Float = 0.1, Value = 0, Flag = "animbreaker_y_offset", Callback = function(int)
		getgenv().animbreaker_y = int
	end})
	expsec:Slider({Name = "Z animbreaker", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "animbreaker_z_offset", Callback = function(int)
		getgenv().animbreaker_z = int * 100000
	end})
	
	local shitcode, shitcode_tick, shitcode_factor = false, tick(), 60
	expsec:Toggle({Name = "FPS limiter", Flag = "old_swimhub_mode", Value = false, Callback = function(v)
		shitcode = v
		shitcode_tick = tick()
		task.spawn(function()
			while shitcode do
				if tick() - shitcode_tick > 1/shitcode_factor then
					shitcode_tick = tick()
					RunService.RenderStepped:Wait()
				end
				task.wait()
			end
		end)
	end})
	expsec:Slider({Name = "FPS Limit", Min = 2, Max = 60, Float = 0.1, Value = 0, Flag = "shitcode_factor", Callback = function(int)
		shitcode_factor = int
	end})

	
	do
		local fake_pda_enabled = false
		local fake_pda_item = nil
		local fake_pda_def = nil

		local function get_player_rs()
			local rs = game:GetService("ReplicatedStorage")
			local players = rs:FindFirstChild("Players")
			if not players then return nil end
			local lp = game.Players and game.Players.LocalPlayer
			if not lp then return nil end
			return players:FindFirstChild(lp.Name)
		end

		local function get_inventory()
			local rs_player = get_player_rs()
			return rs_player and rs_player:FindFirstChild("Inventory")
		end

		local function find_in_tree(root, name)
			for _, child in pairs(root:GetDescendants()) do
				if child.Name == name then return child end
			end
			return nil
		end

		local function has_real_pda(inventory)
			for _, child in pairs(inventory:GetChildren()) do
				if child:IsA("ObjectValue") and child.Name == "PDA" then
					local val = child.Value
					if val then
						local ip = val:IsA("ObjectValue") and val.Value and val.Value:FindFirstChild("ItemProperties") or val:FindFirstChild("ItemProperties")
						if ip and ip:GetAttribute("SlotType") == "EquipmentGPS" then
							return true
						end
					end
				end
			end
			return false
		end

		local function build_pda_definition()
			local itemslist = game:GetService("ReplicatedStorage"):FindFirstChild("ItemsList")
			local base = nil
			if itemslist then
				local direct = itemslist:FindFirstChild("PDA")
				if direct and direct:FindFirstChild("ItemProperties") then
					base = direct
				end
				if not base then
					local compass = itemslist:FindFirstChild("EquipmentCompass")
					if compass and compass:FindFirstChild("ItemProperties") then
						base = compass
					end
				end
				if not base then
					for _, item in pairs(itemslist:GetChildren()) do
						local ip = item:FindFirstChild("ItemProperties")
						if ip and ip:FindFirstChild("ItemIcon") then
							base = item
							break
						end
					end
				end
			end
			local def
			if base then
				def = base:Clone()
			else
				def = Instance.new("Folder")
				def.Name = "PDA"
			end
			def.Name = "PDA"
			local ip = def:FindFirstChild("ItemProperties")
			if not ip then
				ip = Instance.new("Folder")
				ip.Name = "ItemProperties"
				ip.Parent = def
			end
			ip:SetAttribute("SlotType", "EquipmentGPS")
			if not ip:GetAttribute("CallSign") then
				ip:SetAttribute("CallSign", "PDA")
			end
			return def
		end

		local function create_fake_pda()
			local inventory = get_inventory()
			if not inventory then
				Library.Notification("Inventory not found, retrying...", 2.5)
				return
			end
			if fake_pda_item and fake_pda_item.Parent == inventory then return end
			if has_real_pda(inventory) then return end

			local def = fake_pda_def or build_pda_definition()
			fake_pda_def = def
			if def.Parent == nil then
				local host = game:GetService("ReplicatedStorage")
				local holder = host:FindFirstChild("FakePDAHolder")
				if not holder then
					holder = Instance.new("Folder")
					holder.Name = "FakePDAHolder"
					holder.Parent = host
				end
				def.Parent = holder
			end

			local ov = Instance.new("ObjectValue")
			ov.Name = "PDA"
			ov.Value = def
			local props = def and def:FindFirstChild("ItemProperties")
			if props then
				local max_dur = props:GetAttribute("MaxDurability")
				if max_dur then
					ov:SetAttribute("Durability", max_dur)
					ov:SetAttribute("MaxDurability", max_dur)
				end
				local stack = props:GetAttribute("StackSize")
				if stack then
					ov:SetAttribute("Amount", stack)
				end
			end
			if not ov:GetAttribute("Slot") then
				ov:SetAttribute("Slot", "EquipmentGPS")
			end
			ov.Parent = inventory
			fake_pda_item = ov
			Library.Notification("Fake PDA spawned.", 2.5)
		end

		local function remove_fake_pda()
			if fake_pda_item and fake_pda_item.Parent then
				fake_pda_item:Destroy()
			end
			fake_pda_item = nil
		end

		local fake_map_clone = nil

		local function force_self_marker()
			local ok, err = pcall(function()
				local mapframe = nil
				for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
					mapframe = find_in_tree(gui, "MapFrame")
					if mapframe then break end
				end
				if not mapframe then return end
				local main = mapframe:FindFirstChild("MainFrame")
				if not main then return end
				if mapframe.Visible == false then return end
				local markers = main:FindFirstChild("Markers")
				if not markers then return end
				local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not hrp then return end
				local marker = markers:FindFirstChild("SelfMarker")
				if not marker then
					local tpl = main:FindFirstChild("MarkerArrowTemplate")
					if not tpl then return end
					marker = tpl:Clone()
					marker.Name = "SelfMarker"
					marker.Visible = true
					marker.Parent = markers
				end
				local sizereal = 1
				for _, m in pairs(mapframe:GetDescendants()) do
					if m:GetAttribute("SizeReal") then
						sizereal = m:GetAttribute("SizeReal")
						break
					end
				end
				if fake_map_clone and fake_map_clone:GetAttribute("SizeReal") then
					sizereal = fake_map_clone:GetAttribute("SizeReal")
				end
				marker.Position = UDim2.new(0.5 + (hrp.Position.X - 208) / sizereal, 0, 0.5 + (hrp.Position.Z + 203) / sizereal, 0)
				marker.Rotation = math.deg(math.atan2(hrp.CFrame.LookVector.Z, hrp.CFrame.LookVector.X)) + 90
				marker.Visible = true
				markers.Visible = true
			end)
		end

		local function ensure_map_clone()
			local ok, err = pcall(function()
				local mapid = game.ReplicatedFirst.ServerInfo:GetAttribute("MapId")
				local wsname = workspace:GetAttribute("MapName")
				if not mapid then return end
				local maps = nil
				for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
					maps = find_in_tree(gui, "Maps")
					if maps then break end
				end
				if not maps then return end
				local want = mapid .. "Map"
				for _, m in pairs(maps:GetChildren()) do
					if m.Name == want then
						fake_map_clone = nil
						return
					end
				end
				local template = nil
				for _, m in pairs(maps:GetChildren()) do
					if m:IsA("ImageLabel") or m:IsA("ImageButton") or m:IsA("GuiObject") then
						template = m
						break
					end
					if (m:FindFirstChild("ImageLabel") or m:FindFirstChild("ImageButton")) then
						template = m
						break
					end
				end
				if not template then return end
				local c = template:Clone()
				if wsname then c:SetAttribute("MapName", wsname) end
				if not c:GetAttribute("SizeReal") then
					local src = template:GetAttribute("SizeReal")
					if src then c:SetAttribute("SizeReal", src) end
				end
				c.Name = want
				c.Visible = false
				c.Parent = maps
				fake_map_clone = c
				if Library.Notification then
					Library.Notification("Map " .. want .. " added for marker.", 3)
				end
			end)
		end

		expsec:Toggle({Name = "Fake PDA (compass+GPS)", Value = false, Flag = "fake_pda", Callback = function(bool)
			fake_pda_enabled = bool
			if fake_pda_enabled then
				create_fake_pda()
				ensure_map_clone()
			else
				remove_fake_pda()
			end
		end})

		task.spawn(function()
			while not get_inventory() do
				task.wait(0.5)
			end
			local inventory = get_inventory()
			inventory.ChildRemoved:Connect(function(child)
				if not fake_pda_enabled then return end
				if fake_pda_item and child == fake_pda_item then
					fake_pda_item = nil
					create_fake_pda()
				end
			end)
		end)

		task.spawn(function()
			while true do
				task.wait(0.2)
				if not fake_pda_enabled then continue end
				local inventory = get_inventory()
				if not inventory then continue end
				force_self_marker()
				if fake_pda_item and fake_pda_item.Parent == inventory then continue end
				if has_real_pda(inventory) then continue end
				create_fake_pda()
				ensure_map_clone()
			end
		end)
	end

	local ds_keybind; ds_keybind = dscsec:Toggle({Name = "Enabled", Value = false, Flag = "desync_enabled", Callback = function(bool)
		desync_enabled = bool
	end}):Keybind({Name = "Desync", Mode = "Toggle", Key = Enum.KeyCode.B, Value = false, Flag = "desync_enabled_key", Callback = function(bool)
		desync_enabled_key = desync_enabled and bool
		ds_keybind.Set(desync_enabled_key, true)
	end})

	dscsec:Toggle({Name = "Visualize desync", Value = false, Flag = "desync_visualize", Callback = function(bool)
		desync_visualize = bool
	end}):Colorpicker({Name = "Visualization color", Value = Color3.new(1, 1, 1), Usealpha = true, Flag = "desync_visualize_color", Callback = function(color)
		main_wireframe.Color3 = color.c
		main_wireframe.Transparency = color.a
	end})

	dscsec:Slider({Name = "X offset", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "desync_x_offset", Callback = function(int)
		desync_x_offset = int
	end})
	dscsec:Slider({Name = "Y offset", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "desync_y_offset", Callback = function(int)
		desync_y_offset = int
	end})
	dscsec:Slider({Name = "Z offset", Min = -10, Max = 10, Float = 0.1, Value = 0, Flag = "desync_z_offset", Callback = function(int)
		desync_z_offset = int
	end})

	dscsec:Slider({Name = "X rotate", Min = 0, Max = 20, Float = 0.1, Value = 0, Flag = "desync_x_rotate", Callback = function(int)
		desync_x_rotate = math.rad(int * 18)
	end})
	dscsec:Slider({Name = "Y rotate", Min = 0, Max = 20, Float = 0.1, Value = 0, Flag = "desync_y_rotate", Callback = function(int)
		desync_y_rotate = math.rad(int * 18)
	end})
	dscsec:Slider({Name = "Z rotate", Min = 0, Max = 20, Float = 0.1, Value = 0, Flag = "desync_z_rotate", Callback = function(int)
		desync_z_rotate = math.rad(int * 18)
	end})

	dscsec:Toggle({Name = "Random rotation", Value = false, Flag = "desync_random_rotation", Callback = function(bool)
		desync_random_rotation = bool
	end})
	dscsec:Toggle({Name = "Random position", Value = false, Flag = "desync_random_position", Callback = function(bool)
		desync_random_position = bool
	end})
	dscsec:Slider({Name = "Random range", Min = 0, Max = 25, Float = 0.1, Value = 0, Flag = "desync_random_position_range", Callback = function(int)
		desync_random_position_range = int
	end})

	dscsec:Toggle({Name = "Velocity desync", Value = false, Flag = "desync_velocity", Callback = function(bool)
		desync_velocity = bool
	end})
	dscsec:Slider({Name = "Velocity X", Min = -16384, Max = 16384, Float = 512, Value = 0, Flag = "desync_velocity_x", Callback = function(int)
		desync_velocity_x = int
	end})
	dscsec:Slider({Name = "Velocity Y", Min = -16384, Max = 16384, Float = 512, Value = 0, Flag = "desync_velocity_y", Callback = function(int)
		desync_velocity_y = int
	end})
	dscsec:Slider({Name = "Velocity Z", Min = -16384, Max = 16384, Float = 512, Value = 0, Flag = "desync_velocity_z", Callback = function(int)
		desync_velocity_z = int
	end})

	RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
		replicated_hrp_cframe = nil

		character = LocalPlayer.Character
		if not character then return end
		humanoid = _FindFirstChildOfClass(character, "Humanoid")
		hrp = _FindFirstChild(character, "HumanoidRootPart")
		head = _FindFirstChild(character, "Head")

		if not (humanoid and hrp) then return end
		do
			local genv0 = (getgenv and getgenv() or _G)
			if genv0.zzzhub_legit then return end
		end
		if not (desync_enabled and desync_enabled_key) then
			return
		end
		pcall(function()
			for _, tr in ipairs(humanoid:GetPlayingAnimationTracks()) do
				if tr.Looped then
					tr:Stop()
				end
			end
		end)

		old_cframe = hrp.CFrame
		old_velocity = hrp.AssemblyLinearVelocity

		local hrp_offset = _CFramenew()

		if not (forced_cframe) then
			hrp_offset = _CFramenew(
				desync_x_offset,
				desync_y_offset,
				desync_z_offset
			) * CFrame.Angles(
				desync_x_rotate,
				desync_y_rotate,
				desync_z_rotate
			)
			if desync_random_position then
				hrp_offset = hrp_offset + (
					CFrame.Angles(
						(mathrandom() - mathrandom()) * 2 * math.pi,
						(mathrandom() - mathrandom()) * 2 * math.pi,
						(mathrandom() - mathrandom()) * 2 * math.pi
					) * CFrame.new(0, 0, -desync_random_position_range)
				).Position
			end
			if desync_random_rotation then
				hrp_offset = hrp_offset * CFrame.Angles(
					(mathrandom() - mathrandom()) * 2 * math.pi,
					(mathrandom() - mathrandom()) * 2 * math.pi,
					(mathrandom() - mathrandom()) * 2 * math.pi
				)
			end
		end

		replicated_hrp_cframe = forced_cframe or old_cframe * hrp_offset

		hrp.CFrame = replicated_hrp_cframe
		
		if desync_velocity then
			hrp.AssemblyLinearVelocity = _Vector3new(
				desync_velocity_x,
				desync_velocity_y,
				desync_velocity_z
			)
		end

		RunService.RenderStepped:Wait()
		if not hrp then return end

		hrp.CFrame = old_cframe
		if desync_velocity then
			hrp.AssemblyLinearVelocity = old_velocity
		end
	end))

	local VERTICES = {
		
		_Vector3new(-1,-1,-1), _Vector3new(-1, 1,-1),
		_Vector3new(-1, 1,-1), _Vector3new(-1, 1, 1),
		_Vector3new(-1, 1, 1), _Vector3new(-1,-1, 1),
		_Vector3new(-1,-1, 1), _Vector3new(-1,-1,-1),
		
		_Vector3new( 1,-1,-1), _Vector3new( 1, 1,-1),
		_Vector3new( 1, 1,-1), _Vector3new( 1, 1, 1),
		_Vector3new( 1, 1, 1), _Vector3new( 1,-1, 1),
		_Vector3new( 1,-1, 1), _Vector3new( 1,-1,-1),
		
		_Vector3new(-1,-1,-1), _Vector3new( 1,-1,-1),
		_Vector3new(-1, 1,-1), _Vector3new( 1, 1,-1),
		_Vector3new(-1, 1, 1), _Vector3new( 1, 1, 1),
		_Vector3new(-1,-1, 1), _Vector3new( 1,-1, 1),
	}

	local skeleton_order = {
		["LeftFoot"] = true,
		["LeftLowerLeg"] = true,
		["LeftUpperLeg"] = true,
		["RightFoot"] = true,
		["RightLowerLeg"] = true,
		["RightUpperLeg"] = true,
		["LeftHand"] = true,
		["LeftLowerArm"] = true,
		["LeftUpperArm"] = true,
		["RightHand"] = true,
		["RightLowerArm"] = true,
		["RightUpperArm"] = true,
		["LowerTorso"] = true,
		["UpperTorso"] = true
	}

	local valid_parts = {
		["LeftFoot"] = true,
		["LeftLowerLeg"] = true,
		["LeftUpperLeg"] = true,
		["RightFoot"] = true,
		["RightLowerLeg"] = true,
		["RightUpperLeg"] = true,
		["LeftHand"] = true,
		["LeftLowerArm"] = true,
		["LeftUpperArm"] = true,
		["RightHand"] = true,
		["RightLowerArm"] = true,
		["RightUpperArm"] = true,
		["LowerTorso"] = true,
		["UpperTorso"] = true,
		["Head"] = true
	}

	local function isBodyPart(name)
		return valid_parts[name]
	end

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		main_wireframe:Clear()

		if not (desync_visualize) then return end
		if not (desync_enabled and desync_enabled_key) then return end
		if not (replicated_hrp_cframe) then return end

		local character = LocalPlayer.Character
		if not (character) then return end

		local parts = table.create(15)
		local c = 0
		for _, v in character:GetChildren() do
			if _IsA(v, "BasePart") and isBodyPart(v.Name) then
				c += 1
				parts[c] = {v.CFrame, v.Size}
			end
		end
		if c == 0 then return end

		local visual_cframe = replicated_hrp_cframe

		local points = table.create(24 * c)
		c = 0
		for _, part in parts do
			for _, vertex in VERTICES do
				c += 1
				local v = vertex
				points[c] = (visual_cframe):PointToWorldSpace(
					old_cframe:PointToObjectSpace(part[1]:PointToWorldSpace(v * part[2] * 0.5))
				) - workspace.WorldPivot.Position
			end
		end

		main_wireframe:AddLines(points)
	end))
end

do
	local worldbox = ui.sections.world_main_changer
	local miscbox = ui.sections.world_misc_changer
	do
		local lighting_changer, lighting_changing = false, false
		local old_lighting = {
			Ambient = Lighting.Ambient,
			OutdoorAmbient = Lighting.OutdoorAmbient,
			Brightness = Lighting.Brightness,
			ColorShift_Bottom = Lighting.ColorShift_Bottom,
			ColorShift_Top = Lighting.ColorShift_Top,
			GlobalShadows = Lighting.GlobalShadows,
			FogColor = Lighting.FogColor,
			FogEnd = Lighting.FogEnd,
			FogStart = Lighting.FogStart,
			ClockTime = Lighting.ClockTime,
		}
		local lighting_values = {
			Ambient = Color3.fromRGB(70, 70, 70),
			OutdoorAmbient = Color3.fromRGB(70, 70, 70),
			Brightness = 3,
			ColorShift_Bottom = Color3.new(),
			ColorShift_Top = Color3.new(),
			GlobalShadows = true,
			FogColor = Color3.fromRGB(192, 192, 192),
			FogEnd = 10000,
			FogStart = 0,
			ClockTime = 14.5,
		}

		local append_changes = function()
			lighting_changing = true
			for k, v in (lighting_changer and lighting_values or old_lighting) do
				Lighting[k] = v
			end
			lighting_changing = false
		end

		worldbox:Toggle({Name = 'Lighting changer', Flag = 'world_lighting_changer', Value = false, Callback = function(first)
			lighting_changer = first
			append_changes()
		end})
		worldbox:Colorpicker({Name = 'Ambient', Flag = 'world_lighting_ambient', Value = Color3.fromRGB(70, 70, 70), Usealpha = false, Callback = function(Value)
			lighting_values.Ambient = Value.c
			append_changes()
		end})
		worldbox:Colorpicker({Name = 'OutdoorAmbient', Flag = 'world_lighting_outdoorambient', Value = Color3.fromRGB(70, 70, 70), Usealpha = false, Callback = function(Value)
			lighting_values.OutdoorAmbient = Value.c
			append_changes()
		end})
		worldbox:Slider({Name = 'Brightness', Flag = 'world_lighting_brightness', Value = 1, Min = -5, Max = 15, Float = 0.01, Callback = function(State)
			lighting_values.Brightness = State
			append_changes()
		end})
		worldbox:Colorpicker({Name = 'ColorShift_Bottom', Flag = 'world_lighting_colorshift_bottom', Value = Color3.new(), Usealpha = false, Callback = function(Value)
			lighting_values.ColorShift_Bottom = Value.c
			append_changes()
		end})
		worldbox:Colorpicker({Name = 'ColorShift_Top', Flag = 'world_lighting_colorshift_top', Value = Color3.new(), Usealpha = false, Callback = function(Value)
			lighting_values.ColorShift_Bottom = Value.c
			append_changes()
		end})
		worldbox:Toggle({Name = 'GlobalShadows', Flag = 'world_lighting_globalshadows', Value = true, Callback = function(first)
			lighting_values.GlobalShadows = first
			append_changes()
		end})

		worldbox:Colorpicker({Name = 'FogColor', Flag = 'world_lighting_fogcolor', Value = Color3.fromRGB(192, 192, 192), Usealpha = false, Callback = function(Value)
			lighting_values.FogColor = Value.c
			append_changes()
		end})
		worldbox:Slider({Name = 'FogEnd', Flag = 'world_lighting_fogend', Value = 100,Min = 0,Max = 10000,Float = 100,Callback = function(State)
			lighting_values.FogEnd = State
			append_changes()
		end})
		worldbox:Slider({Name = 'FogStart', Flag = 'world_lighting_fogstart', Value = 0,Min = 0,Max = 10000,Float = 100,Callback = function(State)
			lighting_values.FogStart = State
			append_changes()
		end})

		worldbox:Slider({Name = 'ClockTime', Flag = 'world_lighting_clocktime', Value = 14.5,Min = 0,Max = 24,Float = 0.1,Callback = function(State)
			lighting_values.ClockTime = State
			append_changes()
		end})

		for _, method in {"Ambient", "OutdoorAmbient", "Brightness", "ColorShift_Bottom", "ColorShift_Top", "GlobalShadows", "FogColor", "FogEnd", "FogStart", "ClockTime"} do
			Lighting:GetPropertyChangedSignal(method):Connect(function()
				if not lighting_changing then
					old_lighting[method] = Lighting[method]
				end
				if not lighting_changer then return end
				Lighting[method] = lighting_values[method]
			end)
		end
	end

	do
		miscbox:Toggle({Name = 'No grass', Flag = 'no_grass', Value = false, Callback = function(first)
			sethiddenproperty(workspace.Terrain, "Decoration", not first)
		end})
		do
			local atmosphere = _FindFirstChildOfClass(Lighting, "Atmosphere")
			if not atmosphere then
				atmosphere = Instance.new("Atmosphere")
				atmosphere.Parent = Lighting
			end
			local atmosphere_changer, atmosphere_changing = false, false
			local old_atmosphere = {
				Density = atmosphere.Density,
				Offset = atmosphere.Offset,
				Color = atmosphere.Color,
				Decay = atmosphere.Decay,
				Glare = atmosphere.Glare,
				Haze = atmosphere.Haze
			}
			local atmosphere_values = {
				Density = 0.28,
				Offset = 1,
				Color = Color3.new(1, 1, 1),
				Decay = Color3.new(0.8, 0.8, 0.8),
				Glare = 1,
				Haze = 1
			}

			local append_changes = function()
				atmosphere_changing = true
				for k, v in (atmosphere_changer and atmosphere_values or old_atmosphere) do
					atmosphere[k] = v
				end
				atmosphere_changing = false
			end

			miscbox:Toggle({Name = 'Atmosphere changer', Flag = 'world_atmosphere_changer', Value = false,Callback = function(first)
				atmosphere_changer = first
				append_changes()
			end})
			miscbox:Slider({Name = 'Density', Flag = 'world_atmosphere_density', Value = 0.9,Min = 0,Max = 1,Float = 0.01,Callback = function(State)
				atmosphere_values.Density = State
				append_changes()
			end})
			miscbox:Slider({Name = 'Offset', Flag = 'world_atmosphere_offset', Value = 1,Min = 0,Max = 1,Float = 0.01,Callback = function(State)
				atmosphere_values.Offset = State
				append_changes()
			end})
			miscbox:Colorpicker({Name = 'Color', Flag = 'world_atmosphere_color', Value = Color3.new(1, 1, 1), Usealpha = false, Callback = function(Value)
				atmosphere_values.Color = Value.c
				append_changes()
			end})
			miscbox:Colorpicker({Name = 'Decay', Flag = 'world_atmosphere_decay', Value = Color3.new(0.8, 0.8, 0.8), Usealpha = false, Callback = function(Value)
				atmosphere_values.Decay = Value.c
				append_changes()
			end})
			miscbox:Slider({Name = 'Glare', Flag = 'world_atmosphere_glare', Value = 1,Min = 0,Max = 20,Float = 0.1,Callback = function(State)
				atmosphere_values.Glare = State
				append_changes()
			end})
			miscbox:Slider({Name = 'Haze', Flag = 'world_atmosphere_haze', Value = 1,Min = 0,Max = 20,Float = 0.1,Callback = function(State)
				atmosphere_values.Haze = State
				append_changes()
			end})

			for _, method in {"Density", "Offset", "Color", "Decay", "Glare", "Haze"} do
				atmosphere:GetPropertyChangedSignal(method):Connect(function()
					if not atmosphere_changing then
						old_atmosphere[method] = atmosphere[method]
					end
					if not atmosphere_changer then return end
					atmosphere[method] = atmosphere_values[method]
				end)
			end
		end
		do
			local bloom = _FindFirstChildOfClass(Lighting, "BloomEffect")
			if not bloom then
				bloom = Instance.new("BloomEffect")
				bloom.Parent = Lighting
				
			end
			local bloom_changer, bloom_changing = false, false
			local old_bloom = {
				Enabled = bloom.Enabled,
				Intensity = bloom.Intensity,
				Size = bloom.Size,
				Threshold = bloom.Threshold
			}
			local bloom_values = {
				Enabled = 0.28,
				Intensity = 1,
				Size = 56,
				Threshold = 2
			}

			local append_changes = function()
				bloom_changing = true
				for k, v in (bloom_changer and bloom_values or old_bloom) do
					bloom[k] = v
				end
				bloom_changing = false
			end

			miscbox:Toggle({Name = 'Bloom changer', Flag = 'world_bloom_changer', Value = false,Callback = function(first)
				bloom_changer = first
				append_changes()
			end})
			miscbox:Toggle({Name = 'Enabled', Flag = 'world_bloom_enabled', Value = false,Callback = function(first)
				bloom_values.Enabled = first
				append_changes()
			end})
			miscbox:Slider({Name = 'Intensity', Flag = 'world_bloom_intensity', Value = 1,Min = 0,Max = 5,Float = 0.01,Callback = function(State)
				bloom_values.Intensity = State
				append_changes()
			end})
			miscbox:Slider({Name = 'Size', Flag = 'world_bloom_size', Value = 56,Min = 0,Max = 80,Float = 1,Callback = function(State)
				bloom_values.Size = State
				append_changes()
			end})
			miscbox:Slider({Name = 'Threshold', Flag = 'world_bloom_threshold', Value = 2,Min = 0,Max = 10,Float = 0.1,Callback = function(State)
				bloom_values.Threshold = State
				append_changes()
			end})

			for _, method in {"Intensity", "Size", "Threshold"} do
				bloom:GetPropertyChangedSignal(method):Connect(function()
					if not bloom_changing then
						old_bloom[method] = bloom[method]
					end
					if not bloom_changer then return end
					bloom[method] = bloom_values[method]
				end)
			end
		end
	end
end

do
	local Settings = ui.tabs.settings do
		local Main = ui.subtabs.settings_main do
			local Config = ui.sections.settings_config do
				local _, Files = Utility.GetFiles(ConfigFolder, { ".cfg" })
				local LastFiles = Files
				local ConfigName;
				local ConfigList = Config:List({
					Values = Files,
					Value = Files[1] or "",
					Size = 135,
					Name = "",
					Flag = "settings_config_list",
					Search = true,
					Callback = function(v)
						if ConfigName and v then
							ConfigName.Set(v)
						end
					end
				})

				ConfigName = Config:Textbox({
					Name = "Name",
					Value = "",
					Flag = "settings_config_name"
				})

				Config:Button({
					Name = "Save",
					Confirm = true,
					Callback = function()
						local ConfigName = Library.Flags["settings_config_name"]

						if ConfigName and ConfigName ~= "" then
							local ConfigFilePath = string.format("%s%s.cfg", ConfigFolder, ConfigName)

							if isfile(ConfigFilePath) then
								writefile(ConfigFilePath, Library:GetConfig())

								Library.Notification(
									string.format( "Successfully saved config (%s.cfg).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)

								local _, Files = Utility.GetFiles(ConfigFolder, { ".cfg" })

								ConfigList.Refresh(Files)

								ConfigList.Set(ConfigName)
							else
								writefile(ConfigFilePath, Library:GetConfig())

								Library.Notification(
									string.format( "Successfully created config (%s.cfg).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)

								local _, Files = Utility.GetFiles(ConfigFolder, { ".cfg" })

								ConfigList.Refresh(Files)

								ConfigList.Set(ConfigName)
							end
						else
							Library.Notification(
								string.format( "Invalid config name (%s).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
							)
						end
					end, 
				})

				Config:Button({
					Name = "Load",
					Confirm = true,
					Callback = function()
						local ConfigName = Library.Flags["settings_config_list"]

						if ConfigName and ConfigName ~= "" then
							local ConfigFilePath = string.format("%s%s.cfg", ConfigFolder, ConfigName)

							if isfile(ConfigFilePath) then
								Library.LoadConfig(readfile(ConfigFilePath))

								Library.Notification(
									string.format( "Successfully loaded config (%s.cfg).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)
							else
								Library.Notification(
									string.format( "Couldn't find config (%s.cfg).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)
							end
						end
					end,
				})

				Config:Button({
					Name = "Delete",
					Confirm = true,
					Callback = function()
						local ConfigName = Library.Flags["settings_config_list"]

						if ConfigName and ConfigName ~= "" then
							local ConfigFilePath = string.format("%s%s.cfg", ConfigFolder, ConfigName)

							if isfile(ConfigFilePath) then
								delfile(ConfigFilePath)

								Library.Notification(
									string.format( "Successfully deleted config (%s.cfg).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)

								local _, Files = Utility.GetFiles(ConfigFolder, { ".cfg" })

								ConfigList.Refresh(Files)

								ConfigList.Set(Files[1] or "")
							end
						end
					end,
				})

				local function panic_unload()
					local genv = (getgenv and getgenv() or _G)
					genv.zzzhub_legit = true
					if genv.zzzhub_cleanup then
						for _, fn in ipairs(genv.zzzhub_cleanup) do
							pcall(fn)
						end
						genv.zzzhub_cleanup = {}
					end
					pcall(function() genv.Library.Unload() end)
				end
				Config:Button({
					Name = "Unload hub",
					Confirm = true,
					Callback = function()
						panic_unload()
					end,
				})
				Config:Keybind({Name = "PANIC (unload)", Mode = "Hold", Key = Enum.KeyCode.Insert, Value = false, Flag = "panic_key", Callback = function(bool)
					if bool then
						panic_unload()
					end
				end})

				task.spawn(function()
					while task.wait(5) do
						if ui.window.Visible then
							local _, Files = Utility.GetFiles(ConfigFolder, { ".cfg" })

							if #Files ~= #LastFiles then
								LastFiles = Files

								ConfigList.Refresh(Files)

								ConfigList.Set(Files[1] or "")
							end
						end
					end
				end)
			end

			local Personalization = ui.sections.settings_personalization
			do
				local TweenTypes = {}
				for _,v in Enum.EasingStyle:GetEnumItems() do 
					table.insert(TweenTypes, v.Name)
				end
				Personalization:Keybind({Name = "Window Key", Ignore = true, Key = Enum.KeyCode.Delete, Flag = "menu_key", Callback = function()
					ui.window.Open()
				end})

				local Watermark = Library:Watermark({
					titlestart = "swim",
					titleend = "hub"
				})
				local WatermarkText;
				Personalization:Toggle({Name = "Watermark", Flag = "menu_watermark", Value = true, Callback = function(v)
					Watermark.SetVisible(v)
					if WatermarkText then
						WatermarkText.State(v)
					end
				end})
				WatermarkText = Personalization:Textbox({
					Name = "Watermark Text",
					Value = "ping: {ping}ms | fps: {fps} | user: {user} | {date}",
					Flag = "menu_watermark_text",
					Callback = function(v)
						Watermark.SetText(v)
					end
				}) 
				Personalization:Toggle({Name = "Keybind List", Flag = "menu_keybind_list", Value = true, Callback = function(v)
					Library.KeybindsList.Status(v)
				end})
				Personalization:Toggle({Name = "Info reports", Flag = "menu_info_reports", Value = true, Callback = function(v)
					if Library.InfosList then Library.InfosList.Status(v) end
				end})
				Personalization:Slider({Name = "Animations", Min = 0, Max = 100, Value = 40, Flag = "menu_animation_speed", Callback = function(v)
					Library.TweenSpeed = v / 100
				end})
				Personalization:Dropdown({Name = "", Values = TweenTypes, Value = "Exponential", Flag = "menu_animation_type", Callback = function(v)
					Library.TweenStyle = Enum.EasingStyle[v]
				end})
			end
		end
		local Theme = ui.subtabs.settings_theme do
			local ThemeColorpickers = { }

			local Config = ui.sections.theme_config do
				local _, Files = Utility.GetFiles(ThemeFolder, { ".cfg" })
				local LastFiles = Files
				local ThemeName;
				local ThemeList = Config:List({
					Values = Files,
					Value = Files[1] or "",
					Size = 135,
					Name = "",
					Flag = "settings_theme_list",
					Search = true,
					Callback = function(v)
						if ThemeName and v then
							ThemeName.Set(v)
						end
					end
				})
				ThemeName = Config:Textbox({
					Name = "Name",
					Value = "",
					Flag = "settings_theme_name"
				})

				Config:Button({
					Name = "Save",
					Confirm = true,
					Callback = function()
						local ConfigName = Library.Flags["settings_theme_name"]

						if ConfigName and ConfigName ~= "" then
							local ConfigFilePath = string.format("%s%s.cfg", ThemeFolder, ConfigName)

							if isfile(ConfigFilePath) then
								writefile(ConfigFilePath, Library.GetTheme())

								Library.Notification(
									string.format( "Successfully saved theme (%s.theme).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)

								local _, Files = Utility.GetFiles(ThemeFolder, { ".cfg" })

								ThemeList.Refresh(Files)

								ThemeList.Set(ConfigName)
							else
								writefile(ConfigFilePath, Library.GetTheme())

								Library.Notification(
									string.format( "Successfully created theme (%s.theme).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)

								local _, Files = Utility.GetFiles(ThemeFolder, { ".cfg" })

								ThemeList.Refresh(Files)

								ThemeList.Set(ConfigName)
							end
						else
							Library.Notification(
								string.format( "Invalid theme name (%s).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
							)
						end
					end, 
				})

				Config:Button({
					Name = "Load",
					Confirm = true,
					Callback = function()
						local ConfigName = Library.Flags["settings_theme_list"]

						if ConfigName and ConfigName ~= "" then
							local ConfigFilePath = string.format("%s%s.cfg", ThemeFolder, ConfigName)

							if isfile(ConfigFilePath) then
								local Data = Library.GetThemeData(readfile(ConfigFilePath))

								for theme, v in Data do
									ThemeColorpickers[theme].Set({c = v, a = 0})
								end

								Library.Notification(
									string.format( "Successfully loaded theme (%s.theme).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)
							else
								Library.Notification(
									string.format( "Couldn't find theme (%s.theme).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)
							end
						end
					end,
				})

				Config:Button({
					Name = "Delete",
					Confirm = true,
					Callback = function()
						local ConfigName = Library.Flags["settings_theme_list"]

						if ConfigName and ConfigName ~= "" then
							local ConfigFilePath = string.format("%s%s.cfg", ThemeFolder, ConfigName)

							if isfile(ConfigFilePath) then
								delfile(ConfigFilePath)

								Library.Notification(
									string.format( "Successfully deleted theme (%s.theme).", Utility.RichText( ConfigName, Library.Theme.accent ) ), 5
								)

								local _, Files = Utility.GetFiles(ThemeFolder, { ".cfg" })

								ThemeList.Refresh(Files)

								ThemeList.Set(Files[1] or "")
							end
						end
					end,
				})

				task.spawn(function()
					while task.wait(5) do
						if ui.window.Visible then
							local _, Files = Utility.GetFiles(ThemeFolder, { ".cfg" })

							if #Files ~= #LastFiles then
								LastFiles = Files

								ThemeList.Refresh(Files)

								ThemeList.Set(Files[1] or "")
							end
						end
					end
				end)
			end

			local Colors = ui.sections.theme_colors do
				for theme, color in (Library.Theme) do
					ThemeColorpickers[theme] = Colors:Colorpicker({Name = Utility.ToTitleCase(theme), Flag = "settings_" .. theme, Usealpha = true, Ignore = true, Value = color, Callback = function(v)
						Library.UpdateTheme(theme, v.c)
					end})
				end
			end
		end
	end
end
do
	local TweenService = game:GetService("TweenService")
	local GuiService = game:GetService("GuiService")

	local bullet_infos = cheat.bullet_infos 
		

	local get_estimated_origin = project_delta.get_estimated_origin

	local __newindex; __newindex = hookmetamethod(game, "__newindex", newcclosure(LPH_NO_VIRTUALIZE(function(self, idx, val)
		if self == Camera and idx == "CFrame" then
			if thirdperson and thirdperson_key then
				val = val + (val.LookVector * -thirdperson_distance)
			end
			if aspect_ratio then
				val = val * _CFramenew(
					0, 0, 0,
					aspect_ratio_x, 0, 0,
					0, aspect_ratio_y, 0,
					0, 0, 1
				)
			end
		end
		return __newindex(self, idx, val)
	end)))

	local __index; __index = hookmetamethod(game, '__index', newcclosure(LPH_NO_VIRTUALIZE(function(self, key)
		if checkcaller() then return __index(self, key) end
		if key == 'CFrame' and (self == hrp or self == head) and desync_enabled and desync_enabled_key and old_cframe then
			if self == hrp then
				return old_cframe
			end
			if self == head then
				return old_cframe * _CFramenew(
					0,
					hrp.Size.Y / 2 + head.Size.Y / 2,
					0
				) or _CFramenew()
			end
		end
		if key == "ReducedMotionEnabled" and no_recoil and self == GuiService then
			return true
		end
		return __index(self, key)
	end)))

	local __namecall; __namecall = hookmetamethod(game, "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(self, ...)
		local args = {...}
		local method = getnamecallmethod()

		if method == "Raycast" and aimbot_mode == "Silent" then
			local hitpart = target_part
			if not (hitpart and debugtraceback():find("Bullet")) then
				return __namecall(self, ...)
			end

			

			if not silent_aim_hit_active and not silent_forcehit then
				return __namecall(self, ...)
			end

			local hitpos = silent_aim_hit_part and silent_aim_hit_part.Position or hitpart.Position

			if silent_forcehit then
				return {
					Instance = hitpart,
					Position = hitpos,
					Distance = (hitpos - args[1]).Magnitude,
					Normal = _Vector3new(1, 0, 0),
					Material = hitpart.Material
				}
			end

			local origin = args[1]
			local direction = args[2]

			args[2] = (hitpos - origin)

			return __namecall(self, unpack(args))
		end
		if self == TweenService and method == "Create" and args[1] == Camera and (zoom and zoom_key or fov_changer) then
			args[3]["FieldOfView"] = nil
			return __namecall(self, unpack(args))
		end
		if method == "Play" and self.ClassName == "AnimationTrack" then
			local name = self.Name
			if name == "Equip" and instant_equip then
				__namecall(self, ...)
				self.TimePosition = self.Length
				return
			end
		end
		if method == "GetAttribute" then
			local attribute = args[1]
			if attribute == "AccuracyDeviation" then
				return 0
			end
		end
		if method == "InvokeServer" then
			local remote_name = self.Name
			if remote_name == "FireProjectile" and aimbot_mode == "Silent" then
				
				local r = table.create(3)
				r[1] = args[2]
				r[2] = args[3]
				r[3] = args[1]
				bullet_infos[args[2]] = r
				return __namecall(self, unpack(args))
			end
		end
		if method == "FireServer" then
			local remote_name = self.Name
			if remote_name == "Drowning" and ((getgenv and getgenv()) or _G).zzzhub_no_drown then
				return
			end
			if remote_name == "ProjectileInflict" then
				if debugtraceback():find("CharacterController") then
					return coroutine.yield()
				end
				if aimbot_mode == "Silent" then
					args[4] = bullet_infos[args[3]][2] + 5
				end
				if hit_sound then
					task.defer(function()
						local sound = hit_sound_instance:Clone()
						sound.Volume = hit_sound_volume
						sound.PlaybackSpeed = hit_sound_speed
						sound.Parent = SoundService
						sound.PlayOnRemove = true
						sound:Destroy()
					end)
                end
				if hit_logs then
					local parent_model = args[1]
					repeat parent_model = parent_model.Parent until parent_model == nil or parent_model.ClassName == "Model"
					if parent_model then
						notification_queue[#notification_queue + 1] = {
							text = `Hit {Utility.RichText(parent_model.Name, Library.Theme.accent)} in the {Utility.RichText(args[1].Name, Library.Theme.accent)}`,
							duration = hit_logs_duration
						}
					end
				end
				
				return __namecall(self, unpack(args))
			end
			if remote_name == "UpdateTilt" and antiaim and antiaim_pitch then
				args[1] = antiaim_pitch_value
				args[2] = 0
				args[3] = nil
				args[4] = nil
				return __namecall(self, unpack(args))
			end
		end

		return __namecall(self, ...)
	end)))
end

cheat.EspLibrary.load()

if project_delta.fps_object then
	project_delta.fps_bindable:Fire()
end

task.spawn(function()
	

	cheat.CrossScriptChat = {SetSendingEnabled=function(...)end}
end)

do
	
	local vehsec = ui.sections.other_esp
	local vehicle_esp = false
	local vehicle_tags = { ["MI24V"] = true, ["Mi24V"] = true, ["Mi24V "] = true, ["BTR-80"] = true, ["BTR80"] = true, ["BTR"] = true, ["UAZ"] = true }

	vehsec:Toggle({Name = "Vehicles ESP", Value = false, Flag = "vehicles_esp", Callback = function(bool)
		vehicle_esp = bool
	end})

	local veh_gui = Instance.new("ScreenGui")
	veh_gui.Name = "VehiclesESP"
	veh_gui.IgnoreGuiInset = true
	veh_gui.DisplayOrder = 99
	veh_gui.ResetOnSpawn = false

	local known = {}
	local update_timer = 0

	local function ensure_gui()
		if veh_gui.Parent then return end
		local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
		if pg then veh_gui.Parent = pg end
	end

	local heli_names = { ["MI24V"] = true, ["Mi24V"] = true, ["Mi-24V"] = true }
	local veh_name_tags = { "MI24V", "Mi24V", "Mi-24V", "BTR", "UAZ" }
	local function is_vehicle(model)
		if vehicle_tags[model.Name] then return true end
		for _, t in ipairs(veh_name_tags) do
			if string.find(model.Name, t, 1, true) then return true end
		end
		if model:FindFirstChildOfClass("VehicleSeat") then return true end
		if model:FindFirstChild("SeatFR", true) then return true end
		if model:FindFirstChildOfClass("Seat") then return true end
		return false
	end
	local function veh_anchor_pos(model)
		
		local seat = model:FindFirstChildOfClass("VehicleSeat")
		if seat then return seat.Position end
		if not Camera then return nil end
	local campos = Camera.CFrame.Position

	local local_char = LocalPlayer.Character
	local local_root = local_char and _FindFirstChild(local_char, "HumanoidRootPart")
	local ground_y = local_root and local_root.Position.Y or campos.Y
		local best, bestd = nil, math.huge
		local n = 0
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				n += 1
				if n > 40 then break end
				local d = (part.Position - campos).Magnitude
				if d < bestd then bestd = d best = part.Position end
			end
		end
		if best then return best end
		local pp = model.PrimaryPart
		if pp then return pp.Position end
		local ok, piv = pcall(function() return model:GetPivot() end)
		if ok and piv then return piv.Position end
		return nil
	end

	local function update()
		ensure_gui()
		local ws = workspace
		local found = {}
		for _, model in ipairs(ws:GetDescendants()) do
			if model:IsA("Model") and is_vehicle(model) then
				found[model] = true
				local info = known[model]
				if not (info and info.gui and info.gui.Parent) then
					if info then pcall(function() info.gui:Destroy() end) end
					local bg = Instance.new("BillboardGui")
					bg.Name = "VehicleTag"
					bg.AlwaysOnTop = true
					bg.Adornee = model
					bg.Size = UDim2.new(0, 200, 0, 24)
					bg.MaxDistance = 1200
					local lbl = Instance.new("TextLabel")
					lbl.Name = "Tag"
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundTransparency = 1
					lbl.BorderSizePixel = 0
					lbl.TextSize = 12
					lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
					lbl.TextStrokeTransparency = 0
					lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
					lbl.Font = Enum.Font.GothamSemibold
					lbl.Text = model.Name
					lbl.Parent = bg
					bg.Parent = veh_gui
					known[model] = { gui = bg, lbl = lbl }
				end
			end
		end
		for model, info in pairs(known) do
			if not found[model] then
				pcall(function() info.gui:Destroy() end)
				known[model] = nil
			end
		end
	end

	local label_timer = 0
	local function label_updater(delta)
		label_timer = label_timer + delta
		if label_timer < 0.2 then return end
		label_timer = 0
		local lp = LocalPlayer
		local root = lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		local cam_pos = Camera and Camera.CFrame and Camera.CFrame.Position
		for model, info in pairs(known) do
			if info.gui and info.gui.Parent then
				local is_heli = heli_names[model.Name] == true
				local hum = model:FindFirstChildOfClass("Humanoid")
				local hp = hum and math.floor(hum.Health + 0.5) or nil
				if hp == nil and not is_heli then
					local attr
					pcall(function() attr = model:GetAttribute("Health") end)
					if attr ~= nil then hp = tonumber(attr) end
				end
				local dist = ""
				if cam_pos then
					local pos = veh_anchor_pos(model)
					if pos then
						dist = string.format("  %.0fm", (cam_pos - pos).Magnitude)
					end
				end
				local txt = model.Name
				if hp then txt = txt .. "  |  HP " .. tostring(hp) end
				info.lbl.Text = txt .. dist
			end
		end
	end

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		if not vehicle_esp then return end
		update_timer = update_timer + delta
		if update_timer > 5 then
			update_timer = 0
			update()
		end
		label_updater(delta)
	end))

	if workspace.DescendantAdded then
		workspace.DescendantAdded:Connect(function(child)
			if not vehicle_esp then return end
			if child:IsA("Model") and (is_vehicle(child) or known[child]) then
				update()
			end
		end)
	end

	pcall(function()
		workspace.DescendantRemoved:Connect(function(child)
			if not vehicle_esp then return end
			if known[child] then
				update()
			end
		end)
	end)
	do
		local genv = (getgenv and getgenv()) or _G
		genv.zzzhub_cleanup = genv.zzzhub_cleanup or {}
		table.insert(genv.zzzhub_cleanup, function()
			pcall(function() veh_gui:Destroy() end)
			for _, info in pairs(known) do
				pcall(function() info.gui:Destroy() end)
			end
		end)
	end
end

do
	
	local loctsec = ui.sections.other_esp
	local loot_magnet = false
	local loot_range = 300
	local loot_strength = 1
	local loot_parts = {}
	local loot_cache_t = 0
	local loot_apply_t = 0

	local function collect_loot_parts()
		local out = {}
		for _, obj in ipairs(workspace:GetDescendants()) do
			if not obj:IsA("Model") then continue end
			if obj == LocalPlayer.Character then continue end
			if obj:FindFirstChildOfClass("VehicleSeat") then continue end
			local hum = obj:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then continue end
			local part = obj.PrimaryPart
			if (not part or part.Anchored) and obj:FindFirstChild("HumanoidRootPart") then
				part = obj:FindFirstChild("HumanoidRootPart")
			end
			if part and part:IsA("BasePart") and not part.Anchored then
				out[#out + 1] = { model = obj, part = part }
			end
		end
		return out
	end

	loctsec:Toggle({Name = "Loot magnet", Value = false, Flag = "loot_magnet", Callback = function(bool)
		loot_magnet = bool
	end})
	loctsec:Slider({Name = "Loot range", Min = 10, Max = 1000, Float = 10, Value = 300, Flag = "loot_magnet_range", Callback = function(int)
		loot_range = int
	end})
	loctsec:Slider({Name = "Loot strength", Min = 0.5, Max = 3, Float = 0.1, Value = 1, Flag = "loot_magnet_strength", Callback = function(int)
		loot_strength = int
	end})

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		if not loot_magnet then return end
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local pr = root.Position
		local now = os.clock()
		if now - loot_cache_t > 1 or #loot_parts == 0 then
			loot_cache_t = now
			loot_parts = collect_loot_parts()
		end
		if now - loot_apply_t < 0.04 then return end
		loot_apply_t = now
		for i = 1, #loot_parts do
			local entry = loot_parts[i]
			if not entry then continue end
			local part = entry.part
			if not part or not part.Parent then continue end
			local d = pr - part.Position
			local mag = d.Magnitude
			if mag > 2 and mag < loot_range then
				pcall(function()
					part.AssemblyLinearVelocity = d.Unit * math.clamp(mag * 2 * loot_strength, 20, 120)
					if mag > 6 then
						local target = part.CFrame + d.Unit * math.min(mag * 0.15 * loot_strength, 5 * loot_strength)
						entry.model:PivotTo(target)
					end
				end)
			end
		end
	end))
end

do
	
	local bosssec = ui.sections.other_esp
	local boss_check = false
	local boss_names = { ["Dozer"] = true, ["Whisper"] = true, ["Anton"] = true, ["ScavKing"] = true, ["Scav King"] = true, ["MI24V"] = true, ["Mi-24V"] = true, ["Mi24V"] = true, ["BTR80"] = true, ["BTR-80"] = true }
	local known_bosses = {}
	local added_conn
	local removed_conn

	local boss_panel_gui = Instance.new("ScreenGui")
	boss_panel_gui.Name = "BossCheckerPanel"
	boss_panel_gui.IgnoreGuiInset = true
	boss_panel_gui.DisplayOrder = 101
	boss_panel_gui.ResetOnSpawn = false

	local panel_frame = Instance.new("Frame")
	panel_frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	panel_frame.BackgroundTransparency = 0.25
	panel_frame.BorderSizePixel = 0
	panel_frame.Position = UDim2.new(1, -220, 0, 12)
	panel_frame.Size = UDim2.new(0, 200, 0, 24)
	panel_frame.Parent = boss_panel_gui

	local panel_title = Instance.new("TextLabel")
	panel_title.Text = "Bosses"
	panel_title.Size = UDim2.new(1, 0, 0, 20)
	panel_title.BackgroundTransparency = 1
	panel_title.TextSize = 14
	panel_title.TextColor3 = Color3.fromRGB(255, 170, 60)
	panel_title.TextXAlignment = Enum.TextXAlignment.Left
	panel_title.Font = Enum.Font.GothamBlack
	panel_title.Parent = panel_frame

	local boss_labels = {}

	local function panel_update()
		local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
		if pg and not boss_panel_gui.Parent then boss_panel_gui.Parent = pg end
		panel_frame.Visible = boss_check
		local sorted = {}
		for obj, info in pairs(known_bosses) do
			local hum = obj:FindFirstChildOfClass("Humanoid")
			local hp = hum and hum.Health or nil
			if hp == nil then
				local attr
				pcall(function() attr = obj:GetAttribute("Health") end)
				if attr ~= nil then hp = tonumber(attr) end
			end
			local dead
			if hum and hum.Health then dead = hum.Health <= 0
			elseif hp ~= nil then dead = hp <= 0
			else dead = nil end
			table.insert(sorted, { name = obj.Name, dead = dead })
		end
		table.sort(sorted, function(a, b) return a.name < b.name end)
		panel_frame.Size = UDim2.new(0, 200, 0, 20 + #sorted * 20)
		for i = 1, #sorted do
			local row = boss_labels[i]
			if not row then
				row = Instance.new("TextLabel")
				row.Size = UDim2.new(1, 0, 0, 20)
				row.BackgroundTransparency = 1
				row.TextSize = 13
				row.TextXAlignment = Enum.TextXAlignment.Left
				row.Font = Enum.Font.Gotham
				row.Parent = panel_frame
				boss_labels[i] = row
			end
			local hit = sorted[i]
			local state = "?"
			local color = Color3.fromRGB(220, 220, 220)
			if hit.dead == true then
				state = "DEAD"
				color = Color3.fromRGB(255, 90, 90)
			elseif hit.dead == false then
				state = "ALIVE"
				color = Color3.fromRGB(120, 255, 120)
			end
			row.Text = string.format("%s  %s", state, hit.name)
			row.TextColor3 = color
			row.Position = UDim2.new(0, 4, 0, 20 + (i - 1) * 20)
			row.Visible = true
		end
		for i = #sorted + 1, #boss_labels do
			boss_labels[i].Visible = false
		end
	end

	local function is_boss(obj)
		return obj:IsA("Model") and boss_names[obj.Name]
	end

	local function add_boss(obj)
		if is_boss(obj) then known_bosses[obj] = true end
	end

	local function scan_bosses_once()
		for _, obj in ipairs(workspace:GetDescendants()) do
			add_boss(obj)
		end
	end

	if not added_conn then
		added_conn = workspace.DescendantAdded:Connect(function(child)
			if boss_check then add_boss(child) end
		end)
	end
	if not removed_conn then
		removed_conn = workspace.DescendantRemoving:Connect(function(child)
			if known_bosses[child] then known_bosses[child] = nil end
		end)
	end

	bosssec:Toggle({Name = "Boss checker", Value = false, Flag = "boss_checker", Callback = function(bool)
		boss_check = bool
		if bool then scan_bosses_once() end
		panel_update()
	end})

	cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
		if not boss_check then return end
		boss_update_timer = (boss_update_timer or 0) + delta
		if boss_update_timer > 0.5 then
			boss_update_timer = 0
			panel_update()
		end
	end))
end

do
	
	local miscbox = ui.sections.misc
	local RS = game:GetService("ReplicatedStorage")
	local inv_move = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("InventoryMove")
	local vault_cfg = { MoveDelay = 0.05, TrashThreshold = 1000 }
	local vault_sorting = false

	local CAT_ORDER = {
		"Keys", "Weapons", "Attachments", "Ammo", "Magazines", "Armor",
		"Clothing", "Backpacks", "Fabrics", "Utility", "Medical", "Treasure", "Trash", "Rubles"
	}
	local CAT_IDX = {}
	for i, c in ipairs(CAT_ORDER) do CAT_IDX[c] = i end
	local function cat_rank(c) return CAT_IDX[c] or 999 end

	local function fetch_props(item_name)
		local items = RS:FindFirstChild("ItemsList")
		if not items then return nil end
		local entry = items:FindFirstChild(item_name)
		if not entry then return nil end
		local props = entry:FindFirstChild("ItemProperties")
		if not props then return nil end
		local function attr_or(name)
			local a = props:GetAttribute(name)
			if a ~= nil then return a end
			local child = props:FindFirstChild(name)
			if child then return child.Value end
			return nil
		end
		local cost = tonumber(attr_or("Cost") or attr_or("Price")) or 0
		return { ItemType = attr_or("ItemType") or "", SlotType = attr_or("SlotType") or "", Cost = cost }
	end

	local function categorize(name, p)
		if not p then return "Trash" end
		local it, st, cost = p.ItemType, p.SlotType, p.Cost
		if it == "Material" and name == "Rubles" then return "Rubles" end
		if it == "Key" or it == "Keycard" then return "Keys" end
		if it == "Ammo" then return "Ammo" end
		if it == "Magazine" then return "Magazines" end
		if it == "Grenade" or (it == "RangedWeapon" and st ~= "FlareGun") then return "Weapons" end
		if it == "Handle" or it == "Stock" or it == "Front" or it == "Muzzle" or it == "Sight" or it == "Extra" then return "Attachments" end
		if it == "Visor" or (it == "Clothing" and (st == "ClothingChestRig" or st == "ClothingHeadware" or st == "ClothingLegArmor")) then return "Armor" end
		if it == "Filter" or (it == "Clothing" and (st == "ClothingMask" or st == "ClothingShirt" or st == "ClothingPants" or st == "ClothingGloves")) then return "Clothing" end
		if it == "Clothing" and st == "ClothingBackpack" then return "Backpacks" end
		if it == "Barter" and name:find("Fabric") then return "Fabrics" end
		if it == "Medical" then return "Medical" end
		if it == "Equipment" or it == "Buildable" or it == "RepairKit" then return "Utility" end
		return (cost > vault_cfg.TrashThreshold) and "Treasure" or "Trash"
	end

	local function vault_inventory()
		local me = RS:FindFirstChild("Players") and RS.Players:FindFirstChild(LocalPlayer.Name)
		if not me then return nil end
		local vs = me:FindFirstChild("VaultStorage")
		if not vs then return nil end
		return vs:FindFirstChild("Inventory")
	end

	local function at_vault()
		local ok, cur = pcall(function()
			return RS.Players[LocalPlayer.Name].Status.GameplayVariables.CurrentContainer.Value
		end)
		return ok and cur and cur == workspace:FindFirstChild("VaultManager")
	end

	local function slot_num(slot)
		local text, num = slot:match("^([a-zA-Z]+)(%d+)$")
		return text, num and tonumber(num) or 0
	end

	local function iAt(prefix, idx)
		return prefix .. idx
	end

	local function sort_vault(silent)
		if vault_sorting then
			if not silent then Library.Notification("Sorting is already in progress", 2) end
			return
		end
		if not inv_move then
			if not silent then Library.Notification("Remote not found", 2) end
			return
		end
		local vault_inv = vault_inventory()
		if not vault_inv then
			if not silent then Library.Notification("Vault not found", 2.5) end
			return
		end
		if not at_vault() then
			if not silent then Library.Notification("Stand next to the vault", 2.5) end
			return
		end
		vault_sorting = true
		task.spawn(function()
			local ok, err = pcall(function()
				local data = {}
				local prefix
				local max_num = 0
				for _, obj in ipairs(vault_inv:GetChildren()) do
					local slot = obj:GetAttribute("Slot")
					if slot then
						local text, num = slot_num(slot)
						if text and num > 0 then
							if not prefix then prefix = text end
							if num > max_num then max_num = num end
							local p = fetch_props(obj.Name)
							table.insert(data, {
								obj = obj,
								name = obj.Name,
								slot = slot,
								cat = categorize(obj.Name, p),
								cost = p and p.Cost or 0,
								durability = obj:GetAttribute("Durability") or 0,
								skin = obj:GetAttribute("Skin") or "",
								loadedAmmo = obj:GetAttribute("LoadedAmmo") or 0,
								amount = obj:GetAttribute("Amount") or 1,
							})
						end
					end
				end
				if #data == 0 then return end

				local rubles = {}
				local normal = {}
				for _, item in ipairs(data) do
					if item.cat == "Rubles" then
						table.insert(rubles, item)
					else
						table.insert(normal, item)
					end
				end
				table.sort(normal, function(a, b)
					if a.cat ~= b.cat then return cat_rank(a.cat) < cat_rank(b.cat) end
					if a.cat == "Treasure" and a.cost ~= b.cost then return a.cost > b.cost end
					local ta, tb = a.name .. "|" .. a.skin, b.name .. "|" .. b.skin
					if ta ~= tb then return ta < tb end
					if a.durability ~= b.durability then return a.durability > b.durability end
					if a.loadedAmmo ~= b.loadedAmmo then return a.loadedAmmo > b.loadedAmmo end
					return a.amount > b.amount
				end)
				table.sort(rubles, function(a, b) return a.amount > b.amount end)

				local ordered = {}
				for _, item in ipairs(normal) do table.insert(ordered, item) end
				for _, item in ipairs(rubles) do table.insert(ordered, item) end

				local dirty = false
				for i, item in ipairs(ordered) do
					if item.slot ~= iAt(prefix, i) then
						dirty = true
						break
					end
				end
				if not dirty then
					if not silent then Library.Notification("Vault is already sorted", 2) end
					return
				end

				local capacity = math.max(max_num, 200)
				local empty = nil
				for i = 1, capacity do
					local name = iAt(prefix, i)
					local taken = false
					for _, item in ipairs(data) do
						if item.slot == name then taken = true break end
					end
					if not taken then empty = name break end
				end
				if not empty then
					if not silent then Library.Notification("Vault is full - no room to sort", 2.5) end
					return
				end

				local by_slot = {}
				for _, item in ipairs(data) do
					by_slot[item.slot] = item
				end

				local function fire(src_slot, dst_slot)
					pcall(function()
						inv_move:FireServer(src_slot, dst_slot, vault_inv, vault_inv, nil)
					end)
					task.wait(vault_cfg.MoveDelay)
				end

				local function slot_of(item)
					for slot, it in pairs(by_slot) do
						if it == item then return slot end
					end
					return nil
				end

				for i = 1, #ordered do
					local want = iAt(prefix, i)
					local need = ordered[i]
					if slot_of(need) ~= want then
						local blocker = by_slot[want]
						if blocker then
							fire(want, empty)
							by_slot[want] = nil
							by_slot[empty] = blocker
							empty = want
						end
						local src = slot_of(need)
						if src then
							fire(src, want)
							by_slot[src] = nil
							by_slot[want] = need
							empty = src
						end
					end
				end
				if not silent then Library.Notification("Vault sorted", 2) end
			end)
			vault_sorting = false
			if not ok and not silent then
				Library.Notification("Sort failed: " .. tostring(err), 3)
			end
		end)
	end

	miscbox:Button({
		Name = "Sort vault now",
		Confirm = false,
		Callback = function()
			sort_vault(false)
		end
	})
end