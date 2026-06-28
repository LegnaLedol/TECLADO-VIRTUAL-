local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

-- 🔄 LIMPIAR
if CoreGui:FindFirstChild("BloxKeyboardPro") then
    CoreGui.BloxKeyboardPro:Destroy()
end

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "BloxKeyboardPro"
gui.ResetOnSpawn = false

local Visible = true

-- 🧩 MAIN
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0,600,0,300)
Main.Position = UDim2.new(0.5,-300,1,-320)
Main.BackgroundTransparency = 1
Main.Active = true
Main.Draggable = true

-- 📦 FRAME DE TECLAS
local KeysFrame = Instance.new("Frame", Main)
KeysFrame.Size = UDim2.new(1,0,1,0)
KeysFrame.BackgroundTransparency = 1

-- 📐 GRID
local grid = Instance.new("UIGridLayout", KeysFrame)
grid.CellSize = UDim2.new(0,90,0,70)
grid.Padding = UDim2.new(0,8,0,8)
grid.SortOrder = Enum.SortOrder.LayoutOrder

-- 🎨 ESTILO
local function estilo(btn, color)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.35
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
end

-- 🔘 CREAR TECLA
local function key(txt,keycode,order,color)
    local b = Instance.new("TextButton")
    b.Text = txt
    b.LayoutOrder = order
    estilo(b,color)
    b.Parent = KeysFrame

    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            local base = grid.CellSize
            b:TweenSize(base - UDim2.new(0,6,0,6),"Out","Quad",0.05,true)
            VIM:SendKeyEvent(true,keycode,false,nil)
        end
    end)

    b.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            b:TweenSize(grid.CellSize,"Out","Quad",0.05,true)
            VIM:SendKeyEvent(false,keycode,false,nil)
        end
    end)
end

-- 🎮 MOVIMIENTO
key("W\n↑",Enum.KeyCode.W,1,Color3.fromRGB(0,120,255))
key("A\n←",Enum.KeyCode.A,2,Color3.fromRGB(0,120,255))
key("S\n↓",Enum.KeyCode.S,3,Color3.fromRGB(0,120,255))
key("D\n→",Enum.KeyCode.D,4,Color3.fromRGB(0,120,255))

-- ⚡ HABILIDADES
key("Z ⚡",Enum.KeyCode.Z,5,Color3.fromRGB(255,50,50))
key("X 💥",Enum.KeyCode.X,6,Color3.fromRGB(255,120,0))
key("C 🐉",Enum.KeyCode.C,7,Color3.fromRGB(255,200,0))
key("V 🌪️",Enum.KeyCode.V,8,Color3.fromRGB(0,255,120))
key("F 🛡️",Enum.KeyCode.F,9,Color3.fromRGB(0,180,255))

-- 🔢 ITEMS
key("1",Enum.KeyCode.One,10,Color3.fromRGB(120,120,120))
key("2",Enum.KeyCode.Two,11,Color3.fromRGB(120,255,120))
key("3",Enum.KeyCode.Three,12,Color3.fromRGB(120,180,255))
key("4",Enum.KeyCode.Four,13,Color3.fromRGB(200,120,255))
key("5",Enum.KeyCode.Five,14,Color3.fromRGB(255,180,0))

-- ⚡ CLICK LIMPIO (ANTI BUG CÁMARA)
local function safeClick()
    local cam = workspace.CurrentCamera
    local size = cam.ViewportSize
    local x = size.X / 2
    local y = size.Y / 2

    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.01) -- 🔥 10ms tap
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- 🔘
