-- PARTE 1: BASE GENERAL Y CONFIGURACIÓN DE MOVIMIENTO
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Limpiar versiones viejas para evitar errores
if CoreGui:FindFirstChild("DragonNeonKeyboard") then
    CoreGui.DragonNeonKeyboard:Destroy()
end

-- Contenedor de Pantalla
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonNeonKeyboard"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Marco Principal (Fondo Oscuro Gamer)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 390)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 11, 19)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 12)
UICorner_Main.Parent = MainFrame

-- Detalle de Marca (Línea de Dragón)
local BrandLine = Instance.new("Frame")
BrandLine.Size = UDim2.new(1, 0, 0, 3)
BrandLine.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
BrandLine.BorderSizePixel = 0
BrandLine.Parent = MainFrame

-- Encabezado con Nombre Discreto
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Position = UDim2.new(0, 20, 0, 5)
LogoLabel.Size = UDim2.new(0, 200, 0, 25)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "⚡ DRAGON OS v1.0"
LogoLabel.TextColor3 = Color3.fromRGB(90, 115, 145)
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextSize = 11
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left
LogoLabel.Parent = Header

-- Botón para Cerrar (✕)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(120, 130, 140)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Panel donde se acomodan los botones
local GridFrame = Instance.new("Frame")
GridFrame.Name = "GridFrame"
GridFrame.Size = UDim2.new(1, -30, 1, -55)
GridFrame.Position = UDim2.new(0, 15, 0, 40)
GridFrame.BackgroundTransparency = 1
GridFrame.Parent = MainFrame

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellSize = UDim2.new(0, 68, 0, 60)
UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 10)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = GridFrame

-- Esquina inferior derecha para agrandar/achicar (◢)
local ResizeGrabber = Instance.new("TextButton")
ResizeGrabber.Name = "ResizeGrabber"
ResizeGrabber.Size = UDim2.new(0, 22, 0, 22)
ResizeGrabber.Position = UDim2.new(1, -22, 1, -22)
ResizeGrabber.BackgroundTransparency = 1
ResizeGrabber.Text = "◢"
ResizeGrabber.TextColor3 = Color3.fromRGB(90, 115, 145)
ResizeGrabber.TextSize = 14
ResizeGrabber.Font = Enum.Font.GothamBold
ResizeGrabber.ZIndex = 15
ResizeGrabber.Parent = MainFrame

local Resizing = false
local BaseSize = Vector2.new()
local BaseTouchPos = Vector2.new()

ResizeGrabber.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Resizing = true
        BaseSize = Vector2.new(MainFrame.AbsoluteSize.X, MainFrame.AbsoluteSize.Y)
        BaseTouchPos = Vector2.new(input.Position.X, input.Position.Y)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Resizing = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Resizing and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local CurrentPos = Vector2.new(input.Position.X, input.Position.Y)
        local DragDelta = CurrentPos - BaseTouchPos
        local TargetWidth = math.clamp(BaseSize.X + DragDelta.X, 450, 900)
        local TargetHeight = math.clamp(BaseSize.Y + DragDelta.Y, 260, 550)
        MainFrame.Size = UDim2.new(0, TargetWidth, 0, TargetHeight)
        UIGridLayout.CellSize = UDim2.new(0, (TargetWidth - 65) / 6, 0, (TargetHeight - 85) / 5)
    end
end)
-- PARTE 2: CONFIGURACIÓN DE TECLAS Y SISTEMA DE ENTRADA

-- Diccionario con el mapeo de teclas, textos de abajo y colores neón de la foto
local KeyData = {
    -- Movimiento Base (Azul Cyan Neón)
    {text = "W", sub = "ADELANTE", code = Enum.KeyCode.W, neon = Color3.fromRGB(0, 160, 255)},
    {text = "A", sub = "IZQUIERDA", code = Enum.KeyCode.A, neon = Color3.fromRGB(0, 160, 255)},
    {text = "S", sub = "ATRÁS", code = Enum.KeyCode.S, neon = Color3.fromRGB(0, 160, 255)},
    {text = "D", sub = "DERECHA", code = Enum.KeyCode.D, neon = Color3.fromRGB(0, 160, 255)},
    {text = "ESC", sub = "MENÚ", code = Enum.KeyCode.Escape, neon = Color3.fromRGB(220, 50, 50)},
    
    -- Utilidades (Azul Eléctrico / Gris)
    {text = "SHIFT", sub = "CORRER", code = Enum.KeyCode.LeftShift, neon = Color3.fromRGB(0, 130, 200)},
    {text = "CTRL", sub = "AGACHASE", code = Enum.KeyCode.LeftControl, neon = Color3.fromRGB(0, 130, 200)},
    {text = "SPACE", sub = "SALTAR", code = Enum.KeyCode.Space, neon = Color3.fromRGB(0, 160, 255)},
    {text = "TAB", sub = "MENÚ/LEADER", code = Enum.KeyCode.Tab, neon = Color3.fromRGB(70, 100, 120)},
    
    -- Mecánicas Especiales (Morado Neón Dash & Skills)
    {text = "Q", sub = "DASH", code = Enum.KeyCode.Q, neon = Color3.fromRGB(180, 50, 220)},
    {text = "E", sub = "INTERACT", code = Enum.KeyCode.E, neon = Color3.fromRGB(0, 180, 220)},
    {text = "R", sub = "RECARGAR", code = Enum.KeyCode.R, neon = Color3.fromRGB(0, 180, 220)},
    {text = "F", sub = "USAR", code = Enum.KeyCode.F, neon = Color3.fromRGB(0, 180, 220)},
    
    -- Habilidades de Combate (Rojo y Naranja Neón)
    {text = "Z", sub = "HABILID. 1", code = Enum.KeyCode.Z, neon = Color3.fromRGB(240, 70, 40)},
    {text = "X", sub = "HABILID. 2", code = Enum.KeyCode.X, neon = Color3.fromRGB(240, 120, 30)},
    {text = "C", sub = "HABILID. 3", code = Enum.KeyCode.C, neon = Color3.fromRGB(220, 180, 30)},
    {text = "V", sub = "HABILID. 4", code = Enum.KeyCode.V, neon = Color3.fromRGB(40, 200, 100)},
    {text = "J", sub = "HAKI ARM.", code = Enum.KeyCode.J, neon = Color3.fromRGB(70, 130, 180)},
    {text = "T", sub = "V4 DESPERT", code = Enum.KeyCode.T, neon = Color3.fromRGB(150, 60, 200)},
    
    -- Slots de Inventario / Armas (Gris Neón)
    {text = "1", sub = "ITEM 1", code = Enum.KeyCode.One, neon = Color3.fromRGB(100, 110, 120)},
    {text = "2", sub = "ITEM 2", code = Enum.KeyCode.Two, neon = Color3.fromRGB(100, 110, 120)},
    {text = "3", sub = "ITEM 3", code = Enum.KeyCode.Three, neon = Color3.fromRGB(100, 110, 120)},
    {text = "4", sub = "ITEM 4", code = Enum.KeyCode.Four, neon = Color3.fromRGB(100, 110, 120)},
    {text = "5", sub = "ITEM 5", code = Enum.KeyCode.Five, neon = Color3.fromRGB(100, 110, 120)},
    {text = "M", sub = "INVENTAR.", code = Enum.KeyCode.M, neon = Color3.fromRGB(200, 160, 40)}
}

-- Bucle principal que genera visualmente cada botón en la pantalla
for i, data in ipairs(KeyData) do
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame_" .. data.text
    KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.LayoutOrder = i
    KeyFrame.Parent = GridFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = KeyFrame

    -- Borde de Neón Brillante (Look estético idéntico a la imagen)
    local GlowBorder = Instance.new("UIStroke")
    GlowBorder.Color = data.neon
    GlowBorder.Thickness = 1.2
    GlowBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    GlowBorder.Transparency = 0.3
    GlowBorder.Parent = KeyFrame

    -- Texto de la Letra Principal
    local LetterLabel = Instance.new("TextLabel")
    LetterLabel.Size = UDim2.new(1, 0, 0.6, 0)
    LetterLabel.Position = UDim2.new(0, 0, 0, 4)
    LetterLabel.BackgroundTransparency = 1
    LetterLabel.Text = data.text
    LetterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    LetterLabel.Font = Enum.Font.GothamBold
    LetterLabel.TextSize = 16
    LetterLabel.Parent = KeyFrame

    -- Subtexto descriptivo de abajo (Ej. "ADELANTE", "DASH")
    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, 0, 0.35, 0)
    SubLabel.Position = UDim2.new(0, 0, 0.6, -2)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = data.sub
    SubLabel.TextColor3 = data.neon
    SubLabel.Font = Enum.Font.Gotham
    SubLabel.TextSize = 7.5
    SubLabel.TextTransparency = 0.2
    SubLabel.Parent = KeyFrame

    -- Botón de pulsación invisible
    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Parent = KeyFrame

    -- Ejecución de simulación física del teclado en móviles
    ClickBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            KeyFrame.BackgroundColor3 = data.neon
            LetterLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            SubLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            VirtualInputManager:SendKeyEvent(true, data.code, false, game)
        end
    end)

    ClickBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
            LetterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SubLabel.TextColor3 = data.neon
            VirtualInputManager:SendKeyEvent(false, data.code, false, game)
        end
    end)
end
