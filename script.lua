-- PARTE 1 DE 4: INYECTOR DE ENTORNO PC REAL Y SISTEMA DE TAMAÑOS
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ========================================================
-- 💻 PARCHE DE ENGAÑO TOTAL: FORZAR ROBLOX EN MODO PC
-- ========================================================
local metatable = getrawmetatable(game)
local old_index = metatable.__index
setreadonly(metatable, false)

metatable.__index = newcclosure(function(self, key)
    if self == UserInputService then
        if key == "TouchEnabled" then
            return false -- Oculta los controles y joysticks gigantes de celular
        elseif key == "KeyboardEnabled" then
            return true -- Fuerza al juego a cargar barras de PC y habilidades abajo
        elseif key == "MouseEnabled" then
            return true -- Fuerza la visualización de menús de computadora
        end
    end
    return old_index(self, key)
end)
setreadonly(metatable, true)

-- Forzar recarga visual inmediata de las interfaces de Roblox
pcall(function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)

-- Limpiar código anterior para evitar bugs de duplicado
if CoreGui:FindFirstChild("DragonPojavKeyboard") then
    CoreGui.DragonPojavKeyboard:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonPojavKeyboard"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- ÍCONO MAESTRO: DRAGÓN EN RUBÍ (TOGGLE GENERAL)
local RubiMaster = Instance.new("ImageButton")
RubiMaster.Name = "RubiMaster"
RubiMaster.Size = UDim2.new(0, 45, 0, 45)
RubiMaster.Position = UDim2.new(0.5, -22, 0, 5)
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

-- PUNTERO VISUAL DEL MOUSE
local MousePointer = Instance.new("TextLabel")
MousePointer.Name = "MousePointer"
MousePointer.Size = UDim2.new(0, 20, 0, 20)
MousePointer.Position = UDim2.new(0.5, 0, 0.5, 0)
MousePointer.BackgroundTransparency = 1
MousePointer.Text = "🖲️"
MousePointer.TextSize = 18
MousePointer.ZIndex = 12
MousePointer.Visible = false
MousePointer.Parent = ScreenGui

-- BLOQUES LATERALES (100% TRANSPARENTES)
local LeftBlock = Instance.new("Frame")
LeftBlock.Name = "LeftBlock"
LeftBlock.Size = UDim2.new(0, 160, 0, 190)
LeftBlock.Position = UDim2.new(0, 15, 1, -205)
LeftBlock.BackgroundTransparency = 1
LeftBlock.Active = true
LeftBlock.Draggable = true
LeftBlock.Parent = ScreenGui

local RightBlock = Instance.new("Frame")
RightBlock.Name = "RightBlock"
RightBlock.Size = UDim2.new(0, 290, 0, 240)
RightBlock.Position = UDim2.new(1, -305, 1, -255)
RightBlock.BackgroundTransparency = 1
RightBlock.Active = true
RightBlock.Draggable = true
RightBlock.Parent = ScreenGui

-- Ocultar / Mostrar con el Rubí
local TecladoVisible = true
RubiMaster.MouseButton1Click:Connect(function()
    TecladoVisible = not TecladoVisible
    LeftBlock.Visible = TecladoVisible
    RightBlock.Visible = TecladoVisible
    if not TecladoVisible then MousePointer.Visible = false end
    RubiStroke.Color = TecladoVisible and Color3.fromRGB(255, 30, 60) or Color3.fromRGB(80, 20, 30)
    RubiMaster.BackgroundColor3 = TecladoVisible and Color3.fromRGB(35, 5, 5) or Color3.fromRGB(15, 5, 5)
end)

-- SISTEMA DE REDIMENSIÓN AJUSTABLE INDEPENDIENTE (◢)
local function ConfigurarRedimension(TargetFrame, MinW, MinH, MaxW, MaxH)
    local ResizeBtn = Instance.new("TextButton")
    ResizeBtn.Name = "ResizeBtn"
    ResizeBtn.Size = UDim2.new(0, 16, 0, 16)
    ResizeBtn.Position = UDim2.new(1, -16, 1, -16)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Text = "◢"
    ResizeBtn.TextColor3 = Color3.fromRGB(255, 30, 60)
    ResizeBtn.TextSize = 12
    ResizeBtn.Font = Enum.Font.GothamBold
    ResizeBtn.ZIndex = 8
    ResizeBtn.Parent = TargetFrame

    local Resizing = false
    local StartSize, StartPos

    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            StartSize = Vector2.new(TargetFrame.AbsoluteSize.X, TargetFrame.AbsoluteSize.Y)
            StartPos = Vector2.new(input.Position.X, input.Position.Y)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Resizing = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local Delta = Vector2.new(input.Position.X, input.Position.Y) - StartPos
            local NewW = math.clamp(StartSize.X + Delta.X, MinW, MaxW)
            local NewH = math.clamp(StartSize.Y + Delta.Y, MinH, MaxH)
            TargetFrame.Size = UDim2.new(0, NewW, 0, NewH)
        end
    end)
end

ConfigurarRedimension(LeftBlock, 120, 150, 250, 300)
ConfigurarRedimension(RightBlock, 240, 200, 450, 380)
-- PARTE 2 DE 4: SISTEMA DE TOUCHPAD INTERACTIVO CON LIBERACIÓN DE ENTORNO
local MouseActivado = false
local UltimaPosicionTouch = nil

-- Crear el panel de control del mouse invisible encima del bloque derecho
local TouchpadArea = Instance.new("Frame")
TouchpadArea.Name = "TouchpadArea"
TouchpadArea.Size = UDim2.new(1, 0, 1, 0)
TouchpadArea.BackgroundTransparency = 1
TouchpadArea.Active = false
TouchpadArea.Visible = false -- Inicia totalmente apagado para no interferir
TouchpadArea.ZIndex = 5
TouchpadArea.Parent = RightBlock

-- LÓGICA DE CONTROL PAD (DESLIZAR PARA MOVER EL PUNTERO)
TouchpadArea.InputBegan:Connect(function(input)
    if MouseActivado and input.UserInputType == Enum.UserInputType.Touch then
        UltimaPosicionTouch = input.Position
    end
end)

TouchpadArea.InputChanged:Connect(function(input)
    if MouseActivado and input.UserInputType == Enum.UserInputType.Touch and UltimaPosicionTouch then
        local Delta = input.Position - UltimaPosicionTouch
        UltimaPosicionTouch = input.Position
        
        -- Cálculo de coordenadas de movimiento en pantalla con sensibilidad pro
        local NuevaX = MousePointer.Position.X.Offset + (Delta.X * 1.4)
        local NuevaY = MousePointer.Position.Y.Offset + (Delta.Y * 1.4)
        
        local Viewport = workspace.CurrentCamera.ViewportSize
        NuevaX = math.clamp(NuevaX, 0, Viewport.X)
        NuevaY = math.clamp(NuevaY, 0, Viewport.Y)
        
        MousePointer.Position = UDim2.new(0, NuevaX, 0, NuevaY)
        
        -- Sincronizar coordenadas con el motor físico de Roblox
        VirtualInputManager:SendMouseMoveEvent(NuevaX, NuevaY, game)
    end
end)

TouchpadArea.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        UltimaPosicionTouch = nil
    end
end)

-- FUNCIÓN DE LIBERACIÓN TOTAL TÁCTIL PARA LAS HABILIDADES DE COMBATE
local function AlternarMouseVirtual(Estado)
    MouseActivado = Estado
    MousePointer.Visible = Estado
    
    -- Corrección crítica: Se remueve el bloqueo táctil al apagar el mouse
    TouchpadArea.Active = Estado 
    TouchpadArea.Visible = Estado
    
    if RightBlock:FindFirstChild("KeyFrame_CLK_IZQ") then
        RightBlock.KeyFrame_CLK_IZQ.Visible = Estado
    end
    if RightBlock:FindFirstChild("KeyFrame_CLK_DER") then
        RightBlock.KeyFrame_CLK_DER.Visible = Estado
    end
end
-- PARTE 3 DE 4: ESTILO VISUAL DE CRISTAL Y TECLAS DE MOVILIDAD IZQUIERDA
local ShiftActivo = false

-- Función constructora del look estético semi-transparente (Idéntico a tu foto)
local function AplicarEstiloBoton(BotonFrame, Letra, Subtexto, ColorNeon)
    BotonFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
    BotonFrame.BackgroundTransparency = 0.35 -- Efecto cristal: ves el juego detrás

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
    MainLabel.TextSize = 14
    MainLabel.Parent = BotonFrame

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Size = UDim2.new(1, 0, 0.35, 0)
    SubLabel.Position = UDim2.new(0, 0, 0.6, -1)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = Subtexto
    SubLabel.TextColor3 = ColorNeon
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.TextSize = 6.5
    SubLabel.Parent = BotonFrame

    local ClickTrigger = Instance.new("TextButton")
    ClickTrigger.Size = UDim2.new(1, 0, 1, 0)
    ClickTrigger.BackgroundTransparency = 1
    ClickTrigger.Text = ""
    ClickTrigger.ZIndex = 3
    ClickTrigger.Parent = BotonFrame

    return ClickTrigger, Stroke
end

-- Posiciones optimizadas de movilidad en la esquina inferior izquierda
local PosicionesIzquierdas = {
    {Teclado = "W", Sub = "ADELANTE", Code = Enum.KeyCode.W, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 54, 0, 5)},
    {Teclado = "A", Sub = "IZQUIERDA", Code = Enum.KeyCode.A, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 2, 0, 53)},
    {Teclado = "S", Sub = "ATRÁS", Code = Enum.KeyCode.S, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 54, 0, 53)},
    {Teclado = "D", Sub = "DERECHA", Code = Enum.KeyCode.D, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 106, 0, 53)},
    {Teclado = "Q", Sub = "DASH", Code = Enum.KeyCode.Q, Color = Color3.fromRGB(180, 50, 220), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 2, 0, 101)},
    {Teclado = "SHF", Sub = "CORRER", Code = Enum.KeyCode.LeftShift, Color = Color3.fromRGB(0, 130, 200), Size = UDim2.new(0, 48, 0, 44), Pos = UDim2.new(0, 106, 0, 101)},
    {Teclado = "SPC", Sub = "SALTAR", Code = Enum.KeyCode.Space, Color = Color3.fromRGB(0, 160, 255), Size = UDim2.new(0, 100, 0, 36), Pos = UDim2.new(0, 28, 0, 149)},
}

-- Construcción de la cruceta táctil izquierda
for _, data in ipairs(PosicionesIzquierdas) do
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Size = data.Size
    BtnFrame.Position = data.Pos
    BtnFrame.Parent = LeftBlock

    local Trigger, NeonBorder = AplicarEstiloBoton(BtnFrame, data.Teclado, data.Sub, data.Color)

    -- Lógica para dejar la carrera fija (Shift Lock Toggle)
    if data.Teclado == "SHF" then
        Trigger.MouseButton1Click:Connect(function()
            ShiftActivo = not ShiftActivo
            VirtualInputManager:SendKeyEvent(ShiftActivo, data.Code, false, nil)
            if ShiftActivo then
                NeonBorder.Color = Color3.fromRGB(255, 30, 60) -- Rojo neón cuando corre solo
                BtnFrame.BackgroundColor3 = Color3.fromRGB(40, 5, 10)
            else
                NeonBorder.Color = data.Color
                BtnFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
            end
        end)
    else
        -- Soporte multitáctil para que no interrumpa otros botones
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
-- PARTE 4 DE 4: MATRIZ DE COMBATE DERECHA, CLICKS Y TOGGLE DE CONTROL MOUSE

local PosicionesDerechas = {
    -- Habilidades Principales (Rojo / Naranja Fuego)
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
}

-- Construcción de la botonera de combate
for _, data in ipairs(PosicionesDerechas) do
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Size = UDim2.new(0, 50, 0, 46)
    BtnFrame.Position = data.Pos
    BtnFrame.Parent = RightBlock

    local Trigger, _ = AplicarEstiloBoton(BtnFrame, data.Teclado, data.Sub, data.Color)

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

-- ========================================================
-- BOTONES DE MOUSE VIRTUAL: CLICK IZQ Y CLICK DER (Estilo Foto)
-- ========================================================
local MouseClicksData = {
    {Teclado = "CLK IZQ", Sub = "ATACAR", Tipo = 0, Color = Color3.fromRGB(40, 180, 100), Pos = UDim2.new(0, 172, 0, 103)},
    {Teclado = "CLK DER", Sub = "BLOQUEAR", Tipo = 1, Color = Color3.fromRGB(220, 60, 60), Pos = UDim2.new(0, 228, 0, 103)}
}

for _, mData in ipairs(MouseClicksData) do
    local ClickFrame = Instance.new("Frame")
    ClickFrame.Name = "KeyFrame_" .. mData.Teclado:gsub(" ", "_")
    ClickFrame.Size = UDim2.new(0, 52, 0, 97) -- Estilo de botón alargado idéntico a la foto
    ClickFrame.Position = mData.Pos
    ClickFrame.Visible = false -- Inician apagados con el mouse
    ClickFrame.Parent = RightBlock

    local Trigger, _ = AplicarEstiloBoton(ClickFrame, mData.Teclado, mData.Sub, mData.Color)

    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            ClickFrame.BackgroundColor3 = mData.Color
            -- Envía el click físico de mouse en la coordenada exacta de la flecha virtual
            VirtualInputManager:SendMouseButtonEvent(MousePointer.AbsolutePosition.X, MousePointer.AbsolutePosition.Y, mData.Tipo, true, game, 0)
        end
    end)
    Trigger.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            ClickFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
            VirtualInputManager:SendMouseButtonEvent(MousePointer.AbsolutePosition.X, MousePointer.AbsolutePosition.Y, mData.Tipo, false, game, 0)
        end
    end)
end

-- ========================================================
-- INTERRUPTOR ESPECIAL (TOGGLE MOUSE): ENCIENDE/APAGA EL MOUSE
-- ========================================================
local ToggleMouseFrame = Instance.new("Frame")
ToggleMouseFrame.Size = UDim2.new(0, 108, 0, 44)
ToggleMouseFrame.Position = UDim2.new(0, 172, 0, 52)
ToggleMouseFrame.ZIndex = 10 -- Corrección: Siempre por encima de la zona táctil
ToggleMouseFrame.Parent = RightBlock

local ToggleTrigger, ToggleBorder = AplicarEstiloBoton(ToggleMouseFrame, "MOUSE", "APAGADO", Color3.fromRGB(130, 140, 150))

ToggleTrigger.MouseButton1Click:Connect(function()
    local NuevoEstado = not MouseActivado
    AlternarMouseVirtual(NuevoEstado)
    
    if NuevoEstado then
        ToggleBorder.Color = Color3.fromRGB(0, 255, 150) -- Verde neón encendido
        ToggleMouseFrame.BackgroundColor3 = Color3.fromRGB(5, 35, 20)
        ToggleMouseFrame.TextLabel.Text = "MOUSE"
        ToggleMouseFrame.SubLabel.Text = "ENCENDIDO"
    else
        ToggleBorder.Color = Color3.fromRGB(130, 140, 150) -- Gris apagado
        ToggleMouseFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
        ToggleMouseFrame.TextLabel.Text = "MOUSE"
        ToggleMouseFrame.SubLabel.Text = "APAGADO"
    end
end)

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

-- INTERFAZ ALTA EXTERNA: ESC Y TAB NATIVO
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

-- Tecla TAB
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(0, 54, 0, 35)
TabFrame.Position = UDim2.new(0, 55, 0, 0)
TabFrame.Parent = TopBar
local TabTrigger, _ = AplicarEstiloBoton(TabFrame, "TAB", "LEADER", Color3.fromRGB(70, 100, 120))

TabTrigger.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        TabFrame.BackgroundColor3 = Color3.fromRGB(70, 100, 120)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Tab, false, nil)
    end
end)
TabTrigger.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        TabFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 24)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Tab, false, nil)
    end
end)
