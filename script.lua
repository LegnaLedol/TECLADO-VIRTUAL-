local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- 💻 PARCHE DE ENTORNO PC
local metatable = getrawmetatable(game)
local old_index = metatable.__index
setreadonly(metatable, false)

metatable.__index = newcclosure(function(self, key)
    if self == UserInputService then
        if key == "TouchEnabled" then return false
        elseif key == "KeyboardEnabled" then return true
        elseif key == "MouseEnabled" then return true end
    end
    return old_index(self, key)
end)
setreadonly(metatable, true)

pcall(function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)

if CoreGui:FindFirstChild("DragonPojavKeyboard") then
    CoreGui.DragonPojavKeyboard:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonPojavKeyboard"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- 🖲️ MOUSE VIRTUAL (Puntero Avanzado)
local MouseActivado = false
local MousePointer = Instance.new("TextLabel")
MousePointer.Size = UDim2.new(0,22,0,22)
MousePointer.Text = "🎯" -- Usamos una mira para mejor precisión en PvP
MousePointer.TextSize = 20
MousePointer.Visible = false
MousePointer.ZIndex = 100
MousePointer.Parent = ScreenGui

-- 🐉 BOTÓN MAESTRO DRAGÓN
local RubiMaster = Instance.new("ImageButton")
RubiMaster.Size = UDim2.new(0,50,0,50)
RubiMaster.Position = UDim2.new(0.5,-25,0,10)
RubiMaster.BackgroundColor3 = Color3.fromRGB(40,5,5)
RubiMaster.BorderSizePixel = 2
RubiMaster.BorderColor3 = Color3.fromRGB(255,50,50)
RubiMaster.Active = true
RubiMaster.Draggable = true
RubiMaster.Parent = ScreenGui

local DragonIcon = Instance.new("TextLabel")
DragonIcon.Size = UDim2.new(1,0,1,0)
DragonIcon.BackgroundTransparency = 1
DragonIcon.Text = "🐉"
DragonIcon.TextSize = 24
DragonIcon.Parent = RubiMaster

-- 📦 CONTENEDOR ESTILIZADO (Bordes suaves tipo PC)
local function AplicarEstiloPanel(panel)
    panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    panel.BackgroundTransparency = 0.3
    panel.BorderSizePixel = 1
    panel.BorderColor3 = Color3.fromRGB(255, 60, 60) -- Neón Dragón sutil
    panel.Active = true
    panel.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = panel
end

local LeftBlock = Instance.new("Frame")
LeftBlock.Size = UDim2.new(0,165,0,165)
LeftBlock.Position = UDim2.new(0,20,1,-195)
AplicarEstiloPanel(LeftBlock)
LeftBlock.Parent = ScreenGui

local LeftGrid = Instance.new("UIGridLayout")
LeftGrid.CellSize = UDim2.new(0,48,0,48)
LeftGrid.Padding = UDim2.new(0,6,0,6)
LeftGrid.SortOrder = Enum.SortOrder.LayoutOrder
LeftGrid.Parent = LeftBlock

local RightBlock = Instance.new("Frame")
RightBlock.Size = UDim2.new(0,280,0,165)
RightBlock.Position = UDim2.new(1,-300,1,-195)
AplicarEstiloPanel(RightBlock)
RightBlock.Parent = ScreenGui

local RightGrid = Instance.new("UIGridLayout")
RightGrid.CellSize = UDim2.new(0,60,0,48)
RightGrid.Padding = UDim2.new(0,6,0,6)
RightGrid.SortOrder = Enum.SortOrder.LayoutOrder
RightGrid.Parent = RightBlock

-- 📐 REDIMENSIÓN TOTALMENTE CORREGIDA (Sin errores de mayúsculas/minúsculas)
local function ConfigurarRedimension(TargetFrame, MinW, MinH, MaxW, MaxH)
    local ResizeBtn = Instance.new("TextButton")
    ResizeBtn.Size = UDim2.new(0,18,0,18)
    ResizeBtn.Position = UDim2.new(1,-18,1,-18)
    ResizeBtn.Text = "◢"
    ResizeBtn.TextColor3 = Color3.fromRGB(255,60,60)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.ZIndex = 10
    ResizeBtn.Parent = TargetFrame

    local Resizing = false -- Definida correctamente
    local StartSize, StartPos

    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            Resizing = true -- Corregido el bug de asignación
            StartSize = TargetFrame.AbsoluteSize
            StartPos = input.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Resizing = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local Delta = input.Position - StartPos
            TargetFrame.Size = UDim2.new(0,
                math.clamp(StartSize.X + Delta.X, MinW, MaxW),
                0,
                math.clamp(StartSize.Y + Delta.Y, MinH, MaxH)
            )
        end
    end)
end

ConfigurarRedimension(LeftBlock,120,120,300,300)
ConfigurarRedimension(RightBlock,200,120,550,400)
-- 🕹️ LÓGICA DEL TOUCHPAD INTEGRADO EN EL FONDO DERECHO
local UltimaPosicionTouch
RightBlock.InputBegan:Connect(function(input)
    if MouseActivado and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        UltimaPosicionTouch = input.Position
    end
end)

RightBlock.InputChanged:Connect(function(input)
    if MouseActivado and UltimaPosicionTouch and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local Delta = input.Position - UltimaPosicionTouch
        UltimaPosicionTouch = input.Position

        -- Sensibilidad balanceada para PvP móvil
        local Sensibilidad = 1.2 
        local x = MousePointer.Position.X.Offset + (Delta.X * Sensibilidad)
        local y = MousePointer.Position.Y.Offset + (Delta.Y * Sensibilidad)

        local ViewportSize = workspace.CurrentCamera.ViewportSize
        x = math.clamp(x, 0, ViewportSize.X)
        y = math.clamp(y, 0, ViewportSize.Y)

        MousePointer.Position = UDim2.new(0,x,0,y)
        VirtualInputManager:SendMouseMoveEvent(x,y,game)
    end
end)

-- 🔘 CONSTRUCTOR DE BOTONES CON ESTILO NEÓN
local function CrearBoton(parent, text, key, order)
    local f = Instance.new("TextButton")
    f.Text = text
    f.TextSize = 15
    f.Font = Enum.Font.SourceSansBold
    f.TextColor3 = Color3.fromRGB(240,240,240)
    f.BackgroundColor3 = Color3.fromRGB(30,30,30)
    f.LayoutOrder = order or 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = f
    f.Parent = parent

    f.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            VirtualInputManager:SendKeyEvent(true, key, false, nil)
            f.BackgroundColor3 = Color3.fromRGB(150,35,35) -- Feedback visual rápido
        end
    end)

    f.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            VirtualInputManager:SendKeyEvent(false, key, false, nil)
            f.BackgroundColor3 = Color3.fromRGB(30,30,30)
        end
    end)
end

-- 🕹️ Distribución WASD y Teclas de Menú (Bloque Izquierdo)
CrearBoton(LeftBlock, "W", Enum.KeyCode.W, 1)
CrearBoton(LeftBlock, "A", Enum.KeyCode.A, 2)
CrearBoton(LeftBlock, "S", Enum.KeyCode.S, 3)
CrearBoton(LeftBlock, "D", Enum.KeyCode.D, 4)
CrearBoton(LeftBlock, "ESC", Enum.KeyCode.Escape, 5)
CrearBoton(LeftBlock, "TAB", Enum.KeyCode.Tab, 6)
-- ⚔️ Distribución Habilidades y Controles (Bloque Derecho)
CrearBoton(RightBlock, "Z", Enum.KeyCode.Z, 1)
CrearBoton(RightBlock, "X", Enum.KeyCode.X, 2)
CrearBoton(RightBlock, "C", Enum.KeyCode.C, 3)
CrearBoton(RightBlock, "V", Enum.KeyCode.V, 4)
CrearBoton(RightBlock, "F", Enum.KeyCode.F, 5)
CrearBoton(RightBlock, "M", Enum.KeyCode.M, 6) -- Menú / Mapa
CrearBoton(RightBlock, "1 (Item)", Enum.KeyCode.One, 7) -- Slot 1 rápido

-- 🛑 BOTÓN DE CLICK IZQUIERDO (Atacar exactamente en la mira)
local ClickIzq = Instance.new("TextButton")
ClickIzq.Text = "L-CLICK"
ClickIzq.TextColor3 = Color3.fromRGB(255,255,255)
ClickIzq.BackgroundColor3 = Color3.fromRGB(45,45,45)
ClickIzq.Font = Enum.Font.SourceSansBold
ClickIzq.LayoutOrder = 8
local c1 = Instance.new("UICorner") c1.CornerRadius = UDim.new(0,5) c1.Parent = ClickIzq
ClickIzq.Parent = RightBlock

ClickIzq.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local x = MousePointer.Position.X.Offset
        local y = MousePointer.Position.Y.Offset
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        ClickIzq.BackgroundColor3 = Color3.fromRGB(40,120,40)
    end
end)

ClickIzq.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local x = MousePointer.Position.X.Offset
        local y = MousePointer.Position.Y.Offset
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        ClickIzq.BackgroundColor3 = Color3.fromRGB(45,45,45)
    end
end)

-- 🔄 INTERRUPTOR DE MOUSE (Corregido y sin errores)
local Toggle = Instance.new("TextButton")
Toggle.Text = "MOUSE: OFF"
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.BackgroundColor3 = Color3.fromRGB(120,40,40)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.LayoutOrder = 9
local c2 = Instance.new("UICorner") c2.CornerRadius = UDim.new(0,5) c2.Parent = Toggle
Toggle.Parent = RightBlock

Toggle.MouseButton1Click:Connect(function()
    MouseActivado = not MouseActivado
    MousePointer.Visible = MouseActivado
    if MouseActivado then
        Toggle.Text = "MOUSE: ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(40,120,40)
        -- Resetear cursor al centro de la pantalla si está en 0
        if MousePointer.Position.X.Offset == 0 then
            local ViewportSize = workspace.CurrentCamera.ViewportSize
            MousePointer.Position = UDim2.new(0, ViewportSize.X / 2, 0, ViewportSize.Y / 2)
        end
    else
        Toggle.Text = "MOUSE: OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(120,40,40)
    end
end)

-- 🔄 INTERRUPTOR DE VISIBILIDAD GENERAL (Botón Dragón)
local MenuVisible = true
RubiMaster.MouseButton1Click:Connect(function()
    MenuVisible = not MenuVisible
    LeftBlock.Visible = MenuVisible
    RightBlock.Visible = MenuVisible
end)
