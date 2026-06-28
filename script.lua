-- PARTE 1 DE 3: CONFIGURACIÓN GENERAL Y BOTÓN MAESTRO
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Limpiar ejecuciones viejas
if CoreGui:FindFirstChild("DragonTransparentKey") then
    CoreGui.DragonTransparentKey:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonTransparentKey"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- ÍCONO MAESTRO: EL RUBÍ CON EL DRAGÓN ADENTRO
local RubiMaster = Instance.new("ImageButton")
RubiMaster.Name = "RubiMaster"
RubiMaster.Size = UDim2.new(0, 45, 0, 45)
RubiMaster.Position = UDim2.new(0.5, -22, 0, 10)
RubiMaster.BackgroundColor3 = Color3.fromRGB(35, 5, 5)
RubiMaster.BackgroundTransparency = 0.3
RubiMaster.BorderSizePixel = 0
RubiMaster.Active = true
RubiMaster.Draggable = true
RubiMaster.Parent = ScreenGui

local RubiCorner = Instance.new("UICorner")
RubiCorner.CornerRadius = UDim.new(0, 10)
RubiCorner.Parent = RubiMaster

local RubiStroke = Instance.new("UIStroke")
RubiStroke.Color = Color3.fromRGB(255, 30, 60)
RubiStroke.Thickness = 2
RubiStroke.Parent = RubiMaster

local DragonIcon = Instance.new("TextLabel")
DragonIcon.Size = UDim2.new(1, 0, 1, 0)
DragonIcon.BackgroundTransparency = 1
DragonIcon.Text = "🐉"
DragonIcon.TextSize = 22
DragonIcon.Font = Enum.Font.GothamBold
DragonIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
DragonIcon.Parent = RubiMaster

-- CONTENEDORES DE TECLAS TRANSPARENTES
local LeftBlock = Instance.new("Frame")
LeftBlock.Name = "LeftBlock"
LeftBlock.Size = UDim2.new(0, 190, 0, 190)
LeftBlock.Position = UDim2.new(0, 20, 1, -210)
LeftBlock.BackgroundTransparency = 1
LeftBlock.Active = true
LeftBlock.Draggable = true
LeftBlock.Parent = ScreenGui

local RightBlock = Instance.new("Frame")
RightBlock.Name = "RightBlock"
RightBlock.Size = UDim2.new(0, 290, 0, 240)
RightBlock.Position = UDim2.new(1, -310, 1, -260)
RightBlock.BackgroundTransparency = 1
RightBlock.Active = true
RightBlock.Draggable = true
RightBlock.Parent = ScreenGui

local TecladoVisible = true
RubiMaster.MouseButton1Click:Connect(function()
    TecladoVisible = not TecladoVisible
    LeftBlock.Visible = TecladoVisible
    RightBlock.Visible = TecladoVisible
    if TecladoVisible then
        RubiStroke.Color = Color3.fromRGB(255, 30, 60)
        RubiMaster.BackgroundColor3 = Color3.fromRGB(35, 5, 5)
    else
        RubiStroke.Color = Color3.fromRGB(80, 20, 30)
        RubiMaster.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
    end
end)
-- PARTE 2 DE 3: ESTILO DE CRISTAL Y BLOQUE IZQUIERDO DE MOVIMIENTO
local ShiftActivo = false

local function AplicarEstiloBoton(BotonFrame, Letra, Subtexto, ColorNeon)
    BotonFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
    BotonFrame.BackgroundTransparency = 0.35

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = BotonFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = ColorNeon
    Stroke.Thickness = 1.4
    Stroke.Transparency = 0.2
    Stroke.Parent = BotonFrame

    local MainLabel = Instance.new("TextLabel")
    MainLabel.Size = UDim2.new(1, 0, 0.6, 0)
    MainLabel.Position = UDim2.new(0, 0, 0, 3)
    MainLabel.BackgroundTransparency = 1
    MainLabel.Text = Letra
    MainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainLabel.Font = Enum.Font.GothamBold
    MainLabel.TextSize = 15
    MainLabel.Parent = BotonFrame

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, 0, 0.35, 0)
    SubLabel.Position = UDim2.new(0, 0, 0.6, -1)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = Subtexto
    SubLabel.TextColor3 = ColorNeon
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextSize = 7
    SubLabel.Parent = BotonFrame

    local ClickTrigger = Instance.new("TextButton")
    ClickTrigger.Size = UDim2.new(1, 0, 1, 0)
    ClickTrigger.BackgroundTransparency = 1
    ClickTrigger.Text = ""
    ClickTrigger.Parent = BotonFrame

    return ClickTrigger, Stroke
end

local PosicionesIzquierdas = {
    {Teclado = "W", Sub = "ADELANTE", Code = Enum.KeyCode.W, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 54, 0, 5)},
    {Teclado = "A", Sub = "IZQUIERDA", Code = Enum.KeyCode.A, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 2, 0, 53)},
    {Teclado = "S", Sub = "ATRÁS", Code = Enum.KeyCode.S, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 54, 0, 53)},
    {Teclado = "D", Sub = "DERECHA", Code = Enum.KeyCode.D, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 106, 0, 53)},
    {Teclado = "Q", Sub = "DASH", Code = Enum.KeyCode.Q, Color = Color3.fromRGB(180, 50, 220), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 2, 0, 101)},
    {Teclado = "SHF", Sub = "CORRER", Code = Enum.KeyCode.LeftShift, Color = Color3.fromRGB(0, 130, 200), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 106, 0, 101)},
    {Teclado = "SPC", Sub = "SALTAR", Code = Enum.KeyCode.Space, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 100, 0, 36), Pos = UDim2.new(0, 28, 0, 149)},
}

for _, data in ipairs(PosicionesIzquierdas) do
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Size = data.Size
    BtnFrame.Position = data.Pos
    BtnFrame.Parent = LeftBlock

    local Trigger, NeonBorder = AplicarEstiloBoton(BtnFrame, data.Teclado, data.Sub, data.Color)

    if data.Teclado == "SHF" then
        Trigger.MouseButton1Click:Connect(function()
            ShiftActivo = not ShiftActivo
            VirtualInputManager:SendKeyEvent(ShiftActivo, data.Code, false, nil)
            if ShiftActivo then
                NeonBorder.Color = Color3.fromRGB(255, 30, 60)
                BtnFrame.BackgroundColor3 = Color3.fromRGB(40, 5, 10)
            else
                NeonBorder.Color = data.Color
                BtnFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
            end
        end)
    else
        Trigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                BtnFrame.BackgroundColor3 = data.Color
                VirtualInputManager:SendKeyEvent(true, data.Code, false, nil)
            end
        end)
        Trigger.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                BtnFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
                VirtualInputManager:SendKeyEvent(false, data.Code, false, nil)
            end
        end)
    end
end
-- PARTE 3 DE 3: MATRIZ DE COMBATE DERECHA Y NUEVA LOGICA NATIVA PARA TAB

local PosicionesDerechas = {
    -- Habilidades Principales (Rojo Fuego)
    {Teclado = "Z", Sub = "HABILID. 1", Code = Enum.KeyCode.Z, Color = Color3.fromRGB(240, 70, 40), Pos = UDim2.new(0, 5, 0, 52)},
    {Teclado = "X", Sub = "HABILID. 2", Code = Enum.KeyCode.X, Color = Color3.fromRGB(240, 120, 30), Pos = UDim2.new(0, 60, 0, 52)},
    {Teclado = "C", Sub = "HABILID. 3", Code = Enum.KeyCode.C, Color = Color3.fromRGB(220, 180, 30), Pos = UDim2.new(0, 115, 0, 52)},
    
    -- Especiales y Transformación (Verde / Morado)
    {Teclado = "V", Sub = "HABILID. 4", Code = Enum.KeyCode.V, Color = Color3.fromRGB(40, 200, 100), Pos = UDim2.new(0, 5, 0, 103)},
    {Teclado = "F", Sub = "USAR SKILL", Code = Enum.KeyCode.F, Color = Color3.fromRGB(0, 180, 220), Pos = UDim2.new(0, 60, 0, 103)},
    {Teclado = "T", Sub = "V4 DESPERT", Code = Enum.KeyCode.T, Color = Color3.fromRGB(150, 60, 200), Pos = UDim2.new(0, 115, 0, 103)},
    
    -- Interactuar y Utilidades (Gris / Azul Eléctrico)
    {Teclado = "E", Sub = "INTERACTUAR", Code = Enum.KeyCode.E, Color = Color3.fromRGB(0, 180, 220), Pos = UDim2.new(0, 5, 0, 154)},
    {Teclado = "J", Sub = "HAKI ARM.", Code = Enum.KeyCode.J, Color = Color3.fromRGB(70, 130, 180), Pos = UDim2.new(0, 60, 0, 154)},
    {Teclado = "M", Sub = "INVENTARIO", Code = Enum.KeyCode.M, Color = Color3.fromRGB(200, 160, 40), Pos = UDim2.new(0, 115, 0, 154)},
    
    -- Botón de Ataque Continuo / Click Izquierdo
    {Teclado = "CLK", Sub = "ATACAR (L)", Code = Enum.UserInputType.MouseButton1, Color = Color3.fromRGB(220, 50, 50), Pos = UDim2.new(0, 172, 0, 52), CustomSize = UDim2.new(0, 54, 0, 138)}
}

-- Construcción de los botones de Combate
for _, data in ipairs(PosicionesDerechas) do
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Size = data.CustomSize or UDim2.new(0, 50, 0, 46)
    BtnFrame.Position = data.Pos
    BtnFrame.Parent = RightBlock

    local Trigger, _ = AplicarEstiloBoton(BtnFrame, data.Teclado, data.Sub, data.Color)

    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            BtnFrame.BackgroundColor3 = data.Color
            if data.Teclado == "CLK" then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            else
                VirtualInputManager:SendKeyEvent(true, data.Code, false, nil)
            end
        end
    end)
    Trigger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            BtnFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
            if data.Teclado == "CLK" then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            else
                VirtualInputManager:SendKeyEvent(false, data.Code, false, nil)
            end
        end
    end)
end

-- Barra superior de inventario rápido (1 al 5)
for i = 1, 5 do
    local SlotFrame = Instance.new("Frame")
    SlotFrame.Size = UDim2.new(0, 42, 0, 38)
    SlotFrame.Position = UDim2.new(0, 5 + ((i - 1) * 46), 0, 5)
    SlotFrame.Parent = RightBlock

    local Codes = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five}
    local Trigger, _ = AplicarEstiloBoton(SlotFrame, tostring(i), "SLOT " .. i, Color3.fromRGB(100, 110, 120))

    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            SlotFrame.BackgroundColor3 = Color3.fromRGB(100, 110, 120)
            VirtualInputManager:SendKeyEvent(true, Codes[i], false, nil)
        end
    end)
    Trigger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            SlotFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
            VirtualInputManager:SendKeyEvent(false, Codes[i], false, nil)
        end
    end)
end

-- BOTONES DE INTERFAZ GENERAL ALTA (ESC Y TAB NATIVO)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(0, 110, 0, 40)
TopBar.Position = UDim2.new(0, 10, 0, 10)
TopBar.BackgroundTransparency = 1
TopBar.Parent = ScreenGui

-- Tecla ESC
local EscFrame = Instance.new("Frame")
EscFrame.Size = UDim2.new(0, 50, 0, 35)
EscFrame.Position = UDim2.new(0, 0, 0, 0)
EscFrame.Parent = TopBar
local EscTrigger, _ = AplicarEstiloBoton(EscFrame, "ESC", "MENÚ", Color3.fromRGB(220, 50, 50))

EscTrigger.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        EscFrame.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, nil)
    end
end)
EscTrigger.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        EscFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Escape, false, nil)
    end
end)

-- Tecla TAB con Simulación Nativa de Clasificaciones
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 54, 0, 35)
TabFrame.Position = UDim2.new(0, 55, 0, 0)
TabFrame.Parent = TopBar
local TabTrigger, _ = AplicarEstiloBoton(TabFrame, "TAB", "LEADER", Color3.fromRGB(70, 100, 120))

TabTrigger.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        TabFrame.BackgroundColor3 = Color3.fromRGB(70, 100, 120)
        -- Envía la señal física de pulsar Tab de forma limpia
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Tab, false, nil)
    end
end)
TabTrigger.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        TabFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
        -- Suelta la tecla física Tab
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Tab, false, nil)
    end
end)
