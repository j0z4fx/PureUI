local a={cache={}::any}do do local function __modImpl()return function(b)
error(("PureUI %s is not implemented yet"):format(b),2)
end end function a.a():typeof(__modImpl())local b=a.cache.a if not b then b={c=__modImpl()}a.cache.a=b end return b.c end end do local function __modImpl()

local b=a.a()

local c={}
c.__index=c

function c.new()
b"Button"
end

return c end function a.b():typeof(__modImpl())local b=a.cache.b if not b then b={c=__modImpl()}a.cache.b=b end return b.c end end do local function __modImpl()

local b={}
b.__index=b
local c=game:GetService"TweenService"
local d=TweenInfo.new(0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)

function b.new(e,f)
f=f or{}

local g=Instance.new"TextButton"
g.Name=f.Name or"Toggle"
g.Size=UDim2.new(1,0,0,32)
g.BackgroundTransparency=1
g.BorderSizePixel=0
g.AutoButtonColor=false
g.Text=""
g.Parent=e

local h=Instance.new"TextLabel"
h.Size=UDim2.new(1,-96,1,0)
h.Position=UDim2.fromOffset(8,0)
h.BackgroundTransparency=1
h.Font=Enum.Font.Gotham
h.Text=f.Name or"Toggle"
h.TextColor3=Color3.fromRGB(220,223,228)
h.TextSize=13
h.TextXAlignment=Enum.TextXAlignment.Left
h.Parent=g

local i=Instance.new"Frame"
i.AnchorPoint=Vector2.new(1,0.5)
i.Position=UDim2.new(1,-8,0.5,0)
i.Size=UDim2.fromOffset(36,18)
i.BorderSizePixel=0
i.Parent=g

local j=Instance.new"Frame"
j.AnchorPoint=Vector2.new(0,0.5)
j.Position=UDim2.fromOffset(2,9)
j.Size=UDim2.fromOffset(14,14)
j.BorderSizePixel=0
j.Parent=i

local k=setmetatable({
Row=g,
Track=i,
Knob=j,
Label=h,
Value=f.Default==true,
Callback=f.Callback,
},b)

k.Connection=g.MouseButton1Click:Connect(function()
if k.SuppressClick then
return
end
k:SetValue(not k.Value)
end)
k.HoverConnection=g.MouseEnter:Connect(function()
c:Create(h,d,{TextColor3=Color3.fromRGB(248,249,251)}):Play()
end)
k.LeaveConnection=g.MouseLeave:Connect(function()
c:Create(h,d,{TextColor3=Color3.fromRGB(220,223,228)}):Play()
end)

k:SetValue(k.Value,true,true)
return k
end

function b.SetValue(e,f,g,h)
assert(type(f)=="boolean","PureUI toggle value must be boolean")
e.Value=f
e.Knob.BackgroundColor3=Color3.fromRGB(245,246,248)

local i=if f then Color3.fromRGB(88,130,255)else Color3.fromRGB(61,65,76)
local j=if f then UDim2.fromOffset(20,9)else UDim2.fromOffset(2,9)
if h then
e.Track.BackgroundColor3=i
e.Knob.Position=j
else
c:Create(e.Track,d,{BackgroundColor3=i}):Play()
c:Create(e.Knob,d,{Position=j}):Play()
end

if not g and type(e.Callback)=="function"then
task.spawn(e.Callback,f)
end

return e
end

function b.GetValue(e)
return e.Value
end

function b.Destroy(e)
e.Connection:Disconnect()
e.HoverConnection:Disconnect()
e.LeaveConnection:Disconnect()
e.Row:Destroy()
end

return b end function a.c():typeof(__modImpl())local b=a.cache.c if not b then b={c=__modImpl()}a.cache.c=b end return b.c end end do local function __modImpl()

local b=game:GetService"UserInputService"
local c=game:GetService"TweenService"

local d={}
d.__index=d
local e=TweenInfo.new(0.14,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)

local f={
MouseButton1="MB1",
MouseButton2="MB2",
MouseButton3="MB3",
Insert="INS",
Delete="DEL",
}

local function inputName(g)
if g.UserInputType==Enum.UserInputType.Keyboard then
return g.KeyCode.Name
end
return g.UserInputType.Name
end

function d.new(g,h)
h=h or{}

local i=Instance.new"TextButton"
i.Name="Keypicker"
i.AnchorPoint=Vector2.new(1,0.5)
i.Position=UDim2.new(1,-52,0.5,0)
i.Size=UDim2.fromOffset(28,18)
i.BackgroundColor3=Color3.fromRGB(45,48,57)
i.BorderSizePixel=0
i.AutoButtonColor=false
i.Font=Enum.Font.GothamMedium
i.TextColor3=Color3.fromRGB(220,223,228)
i.TextSize=11
i.TextXAlignment=Enum.TextXAlignment.Center
i.TextYAlignment=Enum.TextYAlignment.Center
i.Parent=g.Row

local j=setmetatable({
Button=i,
Key=h.Default or"None",
Callback=h.Callback,
Listening=false,
},d)

j:SetKey(j.Key,true)
j.PressConnection=i.MouseButton1Down:Connect(function()
g.SuppressClick=true
task.defer(function()
g.SuppressClick=false
end)
end)
j.ClickConnection=i.MouseButton1Click:Connect(function()
j.Listening=true
j:SetDisplay"..."
end)
j.HoverConnection=i.MouseEnter:Connect(function()
c:Create(i,e,{
BackgroundColor3=Color3.fromRGB(58,62,73),
TextColor3=Color3.fromRGB(248,249,251),
}):Play()
end)
j.LeaveConnection=i.MouseLeave:Connect(function()
c:Create(i,e,{
BackgroundColor3=Color3.fromRGB(45,48,57),
TextColor3=Color3.fromRGB(220,223,228),
}):Play()
end)
j.InputConnection=b.InputBegan:Connect(function(k)
if not j.Listening then
return
end
j.Listening=false
j:SetKey(inputName(k))
end)

return j
end

function d.SetDisplay(g,h)
local i=c:Create(g.Button,e,{TextTransparency=1})
i:Play()
i.Completed:Once(function()
g.Button.Text=h
c:Create(g.Button,e,{TextTransparency=0}):Play()
end)
end

function d.SetKey(g,h,i)
assert(type(h)=="string"and h~="","PureUI keypicker key must be a string")
g.Key=h
local j=f[h]or h
if i then
g.Button.Text=j
else
g:SetDisplay(j)
end

if not i and type(g.Callback)=="function"then
task.spawn(g.Callback,h)
end

return g
end

function d.GetKey(g)
return g.Key
end

function d.Destroy(g)
g.PressConnection:Disconnect()
g.ClickConnection:Disconnect()
g.HoverConnection:Disconnect()
g.LeaveConnection:Disconnect()
g.InputConnection:Disconnect()
g.Button:Destroy()
end

return d end function a.d():typeof(__modImpl())local b=a.cache.d if not b then b={c=__modImpl()}a.cache.d=b end return b.c end end do local function __modImpl()

local b=a.c()
local c=a.d()

local d={}
d.__index=d

function d.new(e,f)
f=f or{}

local g=Instance.new"Frame"
g.Name=f.Name or"Groupbox"
g.Size=UDim2.new(1,0,0,f.Height or 120)
g.BackgroundColor3=Color3.fromRGB(27,30,36)
g.BorderSizePixel=0
g.Parent=e

local h=Instance.new"Frame"
h.Name="TitleBar"
h.Size=UDim2.new(1,0,0,25)
h.BackgroundColor3=Color3.fromRGB(37,40,48)
h.BorderSizePixel=0
h.Parent=g

local i=Instance.new"TextLabel"
i.Name="Title"
i.Size=UDim2.new(1,-16,1,0)
i.Position=UDim2.fromOffset(8,0)
i.BackgroundTransparency=1
i.Font=Enum.Font.GothamMedium
i.Text=f.Name or"Groupbox"
i.TextColor3=Color3.fromRGB(235,237,240)
i.TextSize=13
i.TextXAlignment=Enum.TextXAlignment.Left
i.Parent=h

local j=Instance.new"Frame"
j.Name="Content"
j.Position=UDim2.fromOffset(0,25)
j.Size=UDim2.new(1,0,1,-25)
j.BackgroundTransparency=1
j.Parent=g

local k=Instance.new"UIPadding"
k.PaddingTop=UDim.new(0,4)
k.PaddingBottom=UDim.new(0,4)
k.Parent=j

local l=Instance.new"UIListLayout"
l.SortOrder=Enum.SortOrder.LayoutOrder
l.Parent=j

return setmetatable({
Frame=g,
TitleBar=h,
Title=i,
Content=j,
Toggles={},
},d)
end

function d.CreateToggle(e,f)
local g=b.new(e.Content,f)
e.Toggles[f.Name or"Toggle"]=g
return g
end

function d.CreateKeypicker(e,f)
f=f or{}
local g=e.Toggles[f.Toggle]
assert(g,"PureUI keypicker Toggle must name an existing toggle in this groupbox")
return c.new(g,f)
end

function d.Destroy(e)
e.Frame:Destroy()
end

return d end function a.e():typeof(__modImpl())local b=a.cache.e if not b then b={c=__modImpl()}a.cache.e=b end return b.c end end do local function __modImpl()

local b=a.b()
local c=a.e()

local d={}
d.__index=d

function d.new(e,f)
f=f or{}

local g=Instance.new"TextButton"
g.Name=f.Name or"Tab"
g.BackgroundColor3=Color3.fromRGB(31,34,41)
g.BorderSizePixel=0
g.AutoButtonColor=false
g.Font=Enum.Font.GothamMedium
g.Text=f.Name or"Tab"
g.TextColor3=Color3.fromRGB(145,149,160)
g.TextSize=13
g.Parent=e.TabBar

local h=Instance.new"Frame"
h.Name=g.Name.."Content"
h.Position=UDim2.fromOffset(0,60)
h.Size=UDim2.new(1,0,1,-60)
h.BackgroundTransparency=1
h.Visible=false
h.Parent=e.Panel

local i=Instance.new"UIPadding"
i.PaddingTop=UDim.new(0,8)
i.PaddingBottom=UDim.new(0,8)
i.PaddingLeft=UDim.new(0,8)
i.PaddingRight=UDim.new(0,8)
i.Parent=h

local j=Instance.new"UIListLayout"
j.FillDirection=Enum.FillDirection.Horizontal
j.Padding=UDim.new(0,8)
j.SortOrder=Enum.SortOrder.LayoutOrder
j.Parent=h

local k={}
local l={"Left","Center","Right"}
for m=1,3 do
local n=Instance.new"ScrollingFrame"
n.Name=l[m]
n.LayoutOrder=m
n.Size=UDim2.new(0.3333333333333333,-5.333333333333333,1,0)
n.BackgroundTransparency=1
n.BorderSizePixel=0
n.AutomaticCanvasSize=Enum.AutomaticSize.Y
n.CanvasSize=UDim2.fromOffset(0,0)
n.ScrollingDirection=Enum.ScrollingDirection.Y
n.ElasticBehavior=Enum.ElasticBehavior.Always
n.ScrollBarThickness=1
n.ScrollBarImageTransparency=1
n.Parent=h

local o=Instance.new"UIListLayout"
o.Padding=UDim.new(0,8)
o.SortOrder=Enum.SortOrder.LayoutOrder
o.Parent=n

k[l[m] ]=n
end

local m=setmetatable({
Window=e,
Button=g,
Content=h,
Columns=k,
Connection=nil,
},d)

m.Connection=g.MouseButton1Click:Connect(function()
e:SelectTab(m)
end)

table.insert(e.Tabs,m)
if#e.Tabs==1 then
e:SelectTab(m)
end

return m
end

function d.CreateButton(e,f)
return b.new()
end

function d.CreateGroupbox(e,f)
f=f or{}
local g=e.Columns[f.Column or"Left"]
assert(g,"PureUI groupbox Column must be Left, Center, or Right")
return c.new(g,f)
end

function d.SetActive(e,f)
e.Content.Visible=f
e.Button.BackgroundColor3=if f then Color3.fromRGB(42,46,55)else Color3.fromRGB(31,34,41)
e.Button.TextColor3=if f then Color3.fromRGB(240,242,245)else Color3.fromRGB(145,149,160)
end

function d.Destroy(e)
e.Connection:Disconnect()
e.Button:Destroy()
e.Content:Destroy()
end

return d end function a.f():typeof(__modImpl())local b=a.cache.f if not b then b={c=__modImpl()}a.cache.f=b end return b.c end end do local function __modImpl()

local b=a.f()
local c=game:GetService"UserInputService"
local d=game:GetService"RunService"
local e=game:GetService"TweenService"

local f={}
f.__index=f

local function getParent()
if type(gethui)=="function"then
return gethui()
end

return game:GetService"CoreGui"
end

function f.new()
local g=Instance.new"ScreenGui"
g.Name="PureUI"
g.IgnoreGuiInset=true
g.ResetOnSpawn=false
g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

local h=Instance.new"Frame"
h.Name="Background"
h.AnchorPoint=Vector2.new(0.5,0.5)
h.Position=UDim2.fromScale(0.5,0.5)
h.Size=UDim2.fromOffset(800,450)
h.BackgroundColor3=Color3.fromRGB(20,22,27)
h.BorderSizePixel=0
h.Parent=g

local i=Instance.new"Frame"
i.Name="TitleBar"
i.Size=UDim2.new(1,0,0,30)
i.BackgroundColor3=Color3.fromRGB(27,30,36)
i.BorderSizePixel=0
i.Parent=h

local j=Instance.new"TextLabel"
j.Name="Title"
j.Size=UDim2.fromScale(1,1)
j.BackgroundTransparency=1
j.Font=Enum.Font.GothamMedium
j.Text="Pure"
j.TextColor3=Color3.fromRGB(235,237,240)
j.TextSize=14
j.Parent=i

local k=Instance.new"Frame"
k.Name="TabBar"
k.Position=UDim2.fromOffset(0,30)
k.Size=UDim2.new(1,0,0,30)
k.BackgroundColor3=Color3.fromRGB(24,26,32)
k.BorderSizePixel=0
k.Parent=h

local l=Instance.new"UIGridLayout"
l.CellPadding=UDim2.fromOffset(0,0)
l.CellSize=UDim2.new(1,0,1,0)
l.FillDirectionMaxCells=1
l.SortOrder=Enum.SortOrder.LayoutOrder
l.Parent=k

local m=Instance.new"Frame"
m.Name="ResizeHandle"
m.AnchorPoint=Vector2.new(0.5,0.5)
m.Position=UDim2.fromScale(1,1)
m.Size=UDim2.fromOffset(14,14)
m.BackgroundTransparency=1
m.BorderSizePixel=0
m.Active=true
m.ZIndex=20
m.Parent=h

local n=Instance.new"Frame"
n.AnchorPoint=Vector2.new(1,1)
n.Position=UDim2.fromScale(1,1)
n.Size=UDim2.fromOffset(14,4)
n.BackgroundColor3=Color3.fromRGB(120,124,136)
n.BackgroundTransparency=0.35
n.BorderSizePixel=0
n.Parent=m

local o=Instance.new"Frame"
o.AnchorPoint=Vector2.new(1,1)
o.Position=UDim2.fromScale(1,1)
o.Size=UDim2.fromOffset(4,14)
o.BackgroundColor3=Color3.fromRGB(120,124,136)
o.BackgroundTransparency=0.35
o.BorderSizePixel=0
o.Parent=m

local function setResizeHover(p)
local q=if p then 0.05 else 0.35
local r=if p then Color3.fromRGB(180,184,196)else Color3.fromRGB(120,124,136)
for s,t in ipairs{n,o}do
e:Create(t,TweenInfo.new(0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
BackgroundColor3=r,
BackgroundTransparency=q,
}):Play()
end
end

local p={}
local q=false
local r
local s
local t=h.Position
local u=false
local v
local w
local x=h.Size

local function clampToScreen(y)
local z=g.AbsoluteSize
local A=h.AbsoluteSize
local B=A.X*h.AnchorPoint.X
local C=A.Y*h.AnchorPoint.Y
local D=y.X.Offset+z.X*y.X.Scale
local E=y.Y.Offset+z.Y*y.Y.Scale

return UDim2.fromOffset(
if A.X>z.X then z.X/2 else math.clamp(D,B,z.X-(A.X-B)),
if A.Y>z.Y then z.Y/2 else math.clamp(E,C,z.Y-(A.Y-C))
)
end

local function beginDrag(y)
if y.UserInputType~=Enum.UserInputType.MouseButton1
and y.UserInputType~=Enum.UserInputType.Touch
then
return
end

q=true
r=y.Position
s=h.Position
t=h.Position
end

table.insert(p,i.InputBegan:Connect(beginDrag))
table.insert(p,m.InputBegan:Connect(function(y)
if y.UserInputType~=Enum.UserInputType.MouseButton1
and y.UserInputType~=Enum.UserInputType.Touch
then
return
end

u=true
setResizeHover(true)
v=y.Position
w=h.Size
x=h.Size
end))

table.insert(p,c.InputEnded:Connect(function(y)
if q
and(y.UserInputType==Enum.UserInputType.MouseButton1
or y.UserInputType==Enum.UserInputType.Touch)
then
q=false
t=h.Position
end
if u
and(y.UserInputType==Enum.UserInputType.MouseButton1
or y.UserInputType==Enum.UserInputType.Touch)
then
u=false
setResizeHover(false)
end
end))
table.insert(p,m.MouseEnter:Connect(function()
if not u then
setResizeHover(true)
end
end))
table.insert(p,m.MouseLeave:Connect(function()
if not u then
setResizeHover(false)
end
end))

table.insert(p,c.InputChanged:Connect(function(y)
if y.UserInputType~=Enum.UserInputType.MouseMovement
and y.UserInputType~=Enum.UserInputType.Touch
then
return
end

if q then
local z=y.Position-r
t=clampToScreen(UDim2.new(
s.X.Scale,
s.X.Offset+z.X,
s.Y.Scale,
s.Y.Offset+z.Y
))
end

if u then
local z=y.Position-v
local A=g.AbsoluteSize
local B=math.max(560,A.X)
local C=math.max(350,A.Y)
x=UDim2.fromOffset(
math.clamp(w.X.Offset+z.X*2,560,B),
math.clamp(w.Y.Offset+z.Y*2,350,C)
)
end
end))

table.insert(p,d.RenderStepped:Connect(function(y)
local z=Vector2.new(
x.X.Offset-h.Size.X.Offset,
x.Y.Offset-h.Size.Y.Offset
)
if u or z.Magnitude>0.5 then
h.Size=h.Size:Lerp(x,1-math.exp(-10*y))
t=clampToScreen(h.Position)
elseif z.Magnitude>0 then
h.Size=x
end

if not q then
return
end

t=clampToScreen(t)
local A=t.X.Offset-h.Position.X.Offset
local B=t.Y.Offset-h.Position.Y.Offset
if A*A+B*B<0.25 then
h.Position=t
return
end

h.Position=h.Position:Lerp(t,1-math.exp(-6*y))
end))

g.Parent=getParent()

local y=setmetatable({
ScreenGui=g,
Panel=h,
TitleBar=i,
Title=j,
TabBar=k,
ResizeHandle=m,
Tabs={},
Connections=p,
},f)

b.new(y,{Name="Demo 1"})
b.new(y,{Name="Demo 2"})
y:UpdateTabLayout()

local z=y.Tabs[1]:CreateGroupbox{Name="Controls",Column="Left",Height=70}
z:CreateToggle{Name="Demo Toggle"}
z:CreateKeypicker{Toggle="Demo Toggle",Default="K"}

return y
end

function f.CreateTab(g,h)
local i=b.new(g,h)
g:UpdateTabLayout()
return i
end

function f.UpdateTabLayout(g)
local h=#g.Tabs
g.TabBar.UIGridLayout.FillDirectionMaxCells=h
g.TabBar.UIGridLayout.CellSize=UDim2.new(1/h,0,1,0)
end

function f.SelectTab(g,h)
for i,j in ipairs(g.Tabs)do
j:SetActive(j==h)
end
g.SelectedTab=h
end

function f.Destroy(g)
for h,i in ipairs(g.Connections)do
i:Disconnect()
end
table.clear(g.Connections)

for h,i in ipairs(g.Tabs)do
i:Destroy()
end
table.clear(g.Tabs)

if g.ScreenGui then
g.ScreenGui:Destroy()
g.ScreenGui=nil
g.Panel=nil
g.TitleBar=nil
g.Title=nil
g.TabBar=nil
g.ResizeHandle=nil
g.SelectedTab=nil
end
end

return f end function a.g():typeof(__modImpl())local b=a.cache.g if not b then b={c=__modImpl()}a.cache.g=b end return b.c end end do local function __modImpl()

local b=game:GetService"HttpService"

local c={}
c.__index=c

local function validName(d)
return type(d)=="string"and d~=""and d:match"^[%w _%-]+$"~=nil
end

local function filesystemAvailable()
return type(isfile)=="function"
and type(isfolder)=="function"
and type(makefolder)=="function"
and type(readfile)=="function"
and type(writefile)=="function"
end

local function attempt(d)
local e,f=pcall(d)
return e,e and f or tostring(f)
end

function c.new(d)
d=d or{}

local e=d.Folder or"PureUI"
local f=d.Name or"default"

assert(validName(e),"PureUI config Folder contains invalid characters")
assert(validName(f),"PureUI config Name contains invalid characters")

return setmetatable({
Folder=e,
Name=f,
Path=e.."/configs/"..f..".json",
Values={},
Bindings={},
},c)
end

function c.IsSupported(d)
return filesystemAvailable()
end

function c.Register(d,e,f,g)
assert(validName(e),"PureUI config flag contains invalid characters")
assert(type(f)=="function","PureUI config getter must be a function")
assert(type(g)=="function","PureUI config setter must be a function")

d.Bindings[e]={Get=f,Set=g}
return d
end

function c.Set(d,e,f)
assert(validName(e),"PureUI config flag contains invalid characters")
d.Values[e]=f
return d
end

function c.Get(d,e,f)
local g=d.Values[e]
return g==nil and f or g
end

function c.Save(d)
if not filesystemAvailable()then
return false,"filesystem API unavailable"
end

local e
local f,g=attempt(function()
for f,g in pairs(d.Bindings)do
d.Values[f]=g.Get()
end

e=b:JSONEncode{
version=1,
values=d.Values,
}

if not isfolder(d.Folder)then
makefolder(d.Folder)
end

local f=d.Folder.."/configs"
if not isfolder(f)then
makefolder(f)
end

writefile(d.Path,e)
end)

return f,g
end

function c.Load(d)
if not filesystemAvailable()then
return false,"filesystem API unavailable"
end

local e
local f,g=attempt(function()
if not isfile(d.Path)then
error("config file does not exist",0)
end

e=b:JSONDecode(readfile(d.Path))
if type(e)~="table"or type(e.values)~="table"then
error("invalid config data",0)
end
end)

if not f then
return false,g
end

d.Values=e.values
for h,i in pairs(d.Bindings)do
if d.Values[h]~=nil then
local j,k=attempt(function()
i.Set(d.Values[h])
end)
if not j then
return false,("failed to apply %s: %s"):format(h,k)
end
end
end

return true,d.Values
end

function c.Delete(d)
if type(isfile)~="function"or type(delfile)~="function"then
return false,"delete filesystem API unavailable"
end
if not isfile(d.Path)then
return false,"config file does not exist"
end

return attempt(function()
delfile(d.Path)
end)
end

return c end function a.h():typeof(__modImpl())local b=a.cache.h if not b then b={c=__modImpl()}a.cache.h=b end return b.c end end do local function __modImpl()

local b={}

local c=false

if writefile and readfile and isfile and isfolder and makefolder and getcustomasset then
if not isfolder"lucide-icons"then
makefolder"lucide-icons"
end

if not isfile"lucide-icons/version.txt"then
writefile("lucide-icons/version.txt","2026-06-01T02:15:52.057378077+00:00")
end

local d=readfile"lucide-icons/version.txt"~="2026-06-01T02:15:52.057378077+00:00"

if d then
writefile("lucide-icons/version.txt","2026-06-01T02:15:52.057378077+00:00")
end

for e=1,2 do
if isfile(`lucide-icons/{e}.png`)and not d then
continue
end

writefile(
`lucide-icons/{e}.png`,
game:HttpGet(
`https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/spritesheets/{e}.png`
)
)
end local

e=pcall(function()
return getcustomasset"lucide-icons/1.png"
end)

c=not e
end

local d={{"align-vertical-distribute-center","chevron-down","list-restart","table-cells-split","gavel","dna-off","refresh-ccw-dot","venus","bean","circle-question-mark","folder-code","bolt","heater","feather","align-horizontal-distribute-center","grip-vertical","pill-bottle","person-standing","badge-swiss-franc","between-horizontal-end","file-braces-corner","rotate-cw","house-plus","bus-front","shield-ellipsis","between-vertical-end","globe-lock","tags","concierge-bell","bookmark-minus","file-down","picture-in-picture","messages-square","scissors","file-check-corner","phone-call","anchor","hand-helping","text-wrap","birdhouse","wifi-off","cloud-alert","message-square","cloud-download","folder-plus","cctv-off","mirror-round","user-round","pointer","between-horizontal-start","chevrons-up-down","brush","message-circle-more","parentheses","book-up-2","flame","chevrons-up","square-dashed","square-mouse-pointer","superscript","signal","wifi-cog","hexagon","navigation-2-off","eye-off","arrows-up-from-line","file-code-corner","square-centerline-dashed-horizontal","panels-right-bottom","scaling","hash","arrow-left-from-line","ship","ticket-percent","calendar-clock","x","non-binary","voicemail","presentation","tree-palm","badge","captions-off","align-vertical-justify-center","download","mouse-right","lens-convex","focus","diamond-percent","arrow-big-up","volume-x","mouse-pointer-click","origami","hard-drive","grid-2x2-x","package-minus","cloud","pipette","corner-left-down","badge-cent","cloud-lightning","user-round-pen","arrow-left-to-line","book-open-text","monitor-cloud","parking-meter","cat","heart-handshake","dam","trees","ham","circle-pause","chess-king","bean-off","rat","separator-horizontal","ambulance","signal-zero","citrus","phone-missed","calendar-off","chart-column","battery-medium","square-minus","decimals-arrow-left","folder-output","menu","image-down","terminal","angry","circle-dot-dashed","medal","cake-slice","git-graph","armchair","tickets","qr-code","copy","goal","trending-down","creative-commons","ev-charger","user-star","road","nfc","align-center-horizontal","car","notebook-tabs","ear","videotape","sun-moon","chart-scatter","toolbox","calendar","calendar-cog","gallery-horizontal","clipboard-x","book-open","circle-pile","rectangle-ellipsis","badge-plus","badge-info","file-headphone","bow-arrow","clipboard-pen-line","user-round-key","folder-search","utensils-crossed","arrow-up","arrow-up-from-dot","align-vertical-justify-start","layers-minus","pause","shrub","flag","biceps-flexed","align-horizontal-distribute-end","donut","calendar-plus-2","move-vertical","file-pen-line","badge-russian-ruble","radius","pilcrow","corner-left-up","georgian-lari","cable","book-user","square-arrow-down","circle-plus","view","cctv","circle-arrow-left","volume","octagon-alert","panel-bottom-dashed","book-a","align-end-vertical","thumbs-up","globe","rabbit","layers-plus","banknote-arrow-down","message-square-off","dice-4","message-circle-x","folder-x","message-circle-warning","map","move","arrow-up-left","award","arrow-down-wide-narrow","unfold-horizontal","lens-concave","motorbike","music-4","shield-x","file-volume","disc-3","file-signal","columns-4","archive-x","square-dashed-kanban","mouse-pointer-2","clock-arrow-up","clock-fading","vegan","message-circle-plus","fast-forward","user-pen","chess-knight","wifi-pen","files","send-to-back","alarm-clock","shopping-basket","send","brush-cleaning","skip-back","book-audio","file-scan","message-square-dashed","chevrons-left","umbrella","skip-forward","clipboard-copy","map-pin-off","arrow-up-from-line","circle-chevron-up","circle-small","align-vertical-space-between","lamp-desk","circle-arrow-up","zap","beaker","paintbrush","broccoli","chevron-up","pen-tool","form","pencil-ruler","dna","arrow-big-down-dash","chart-area","bug-off","card-sim","map-pin-search","ellipse","spell-check","popcorn","blocks","washing-machine","microchip","badge-minus","cloud-sun","circle","shield-alert","map-minus","separator-vertical","ampersands","user-search","fence","square-user-round","sunrise","strikethrough","calendar-days","folder-bookmark","banknote-arrow-up","dollar-sign","message-square-quote","list-minus","cloud-hail","eye-closed","app-window-mac","ellipsis","copy-check","history","satellite","bookmark-plus","folder-key","coffee","circle-power","hourglass","tickets-plane","folder-git","bomb","layers-2","battery-full","user-minus","chart-gantt","folder-tree","command","badge-dollar-sign","align-start-vertical","briefcase-conveyor-belt","message-circle-question-mark","bluetooth-off","square-square","cannabis","book","grip-horizontal","circle-minus","audio-waveform","moon-star","arrow-down-narrow-wide","database-backup","wand","receipt-turkish-lira","calendar-minus-2","copy-minus","folder-input","book-image","mouse-left","shirt","server-off","move-up","plug-2","chess-rook","brackets","calendar-heart","list-ordered","mic-off","arrow-big-left","square-split-horizontal","clover","sun-snow","sofa","funnel-x","clock-2","calendar-fold","fish-off","baby","leaf","fold-vertical","hop","paperclip","cigarette","minus","smile-plus","diamond-plus","file-chart-column","triangle-dashed","git-pull-request-closed","badge-check","plug-zap","heading-4","chess-queen","graduation-cap","grid-3x2","zodiac-sagittarius","square-dashed-bottom-code","clock-7","ethernet-port","scan-text","shower-head","equal-not","move-down","clock-arrow-down","ticket-slash","ruler","circle-user-round","list-filter","map-pin-check","egg-off","cog","dog","swords","spotlight","panel-right-dashed","truck-electric","check-line","bubbles","bot","chart-bar-increasing","trash-2","air-vent","dot","file-symlink","clipboard-paste","chevron-last","book-heart","circle-parking","globe-check","cloud-check","panel-left","circle-chevron-right","squares-unite","arrow-down-up","git-fork","forward","brain-circuit","between-vertical-start","database","panel-right","log-out","git-branch-plus","clipboard-minus","file-text","table-rows-split","milk-off","tv-minimal","cloud-upload","banknote","drumstick","calendar-search","zoom-out","bell-ring","circle-chevron-left","zoom-in","arrow-down","arrow-up-down","folder-dot","zodiac-virgo","loader-pinwheel","whole-word","monitor","disc-2","trending-up-down","film","zodiac-pisces","underline","tv-minimal-play","circle-stop","align-vertical-space-around","zodiac-libra","zodiac-leo","zodiac-gemini","arrow-big-down","circle-parking-off","calendar-x-2","user-plus","move-diagonal-2","bandage","gallery-horizontal-end","panel-top-dashed","squircle","land-plot","tram-front","zodiac-aries","podcast","zodiac-aquarius","audio-lines","expand","x-line-top","square-chevron-up","flip-vertical-2","rocket","worm","ear-off","workflow","wine-off","wine","wind-arrow-down","printer","megaphone-off","weight","arrow-big-right","section","file-clock","plane-landing","toy-brick","square-chevron-down","dice-1","drill","app-window","shield-check","hand-metal","wifi-sync","spell-check-2","square-arrow-out-up-left","wifi-high","list-plus","wifi","rotate-ccw-key","wheat-off","chart-pie","wheat","weight-tilde","copy-slash","wind","reply","layout-panel-left","gamepad","circle-percent","webcam","circle-arrow-out-down-right","square-x","italic","chart-column-increasing","waypoints","step-forward","waves-vertical","a-arrow-down","container","sticker","waves-ladder","waves-horizontal","soap-dispenser-droplet","waves-arrow-down","watch","inspection-panel","import","badge-turkish-lira","square-terminal","file-music","wand-sparkles","beef","route-off","file-user","wallpaper","square-radical","wallet-minimal","image-upscale","book-type","smile","signpost-big","wallet-cards","cloudy","wallet","square-percent","vote","navigation-off","arrow-left","car-taxi-front","volume-off","skull","chevrons-right-left","volume-1","volleyball","utensils","video","telescope","vibrate","venus-and-mars","square-pause","align-end-horizontal","repeat-1","equal","megaphone","calendar-x","message-square-warning","vault","egg","badge-x","van","utility-pole","circle-pound-sterling","video-off","japanese-yen","users-round","users","user-x","library","file-terminal","circle-chevron-down","accessibility","user-round-x","square-library","amphora","user-round-search","tally-2","monitor-play","monitor-dot","user-round-cog","user-round-check","sheet","circle-check-big","user-lock","user-key","map-pinned","corner-down-left","circuit-board","stethoscope","square-arrow-up-right","user","maximize","folder-open-dot","book-dashed","upload","unplug","bluetooth","tree-pine","receipt-indian-rupee","square-slash","unlink","university","ungroup","unfold-vertical","book-plus","flask-conical","undo-2","funnel","square-star","folder-sync","undo","zodiac-ophiuchus","umbrella-off","type-outline","arrow-up-narrow-wide","fishing-hook","gamepad-directional","file-up","folder-root","frame","calendar-arrow-down","clock-12","turntable","turkish-lira","truck","images","lollipop","book-text","trophy","lamp-floor","file-plus-corner","image","ghost","badge-euro","bike","triangle-alert","triangle","trending-up","tree-deciduous","shell","transgender","chevron-left","option","train-front-tunnel","scroll-text","table-of-contents","move-3d","traffic-cone","tractor","toggle-right","tower-control","ferris-wheel","camera-off","salad","touchpad-off","touchpad","torus","tornado","group","tool-case","battery","toilet","tent-tree","toggle-left","rectangle-horizontal","timer-reset","rectangle-vertical","timer","bitcoin","timeline","battery-plus","database-search","ticket-x","file-diff","stretch-vertical","locate-fixed","shield-user","spline-pointer","move-left","axis-3d","heart-off","thermometer-sun","binoculars","thermometer-snowflake","thermometer","theater","rose","message-square-share","mail-minus","text-quote","phone-incoming","text-cursor-input","text-cursor","clipboard-pen","bottle-wine","alarm-clock-off","iteration-cw","list","text-align-justify","square-arrow-right","text-align-end","badge-pound-sterling","bookmark-check","text-align-center","test-tubes","test-tube-diagonal","a-arrow-up","clock-check","bug","tent","vibrate-off","mail-check","zodiac-cancer","tangent","file-code","snowflake","chart-column-big","locate","tally-3","cassette-tape","battery-low","list-video","tag","signpost","tablets","calendar-arrow-up","landmark","fish-symbol","tablet-smartphone","loader","bold","dice-2","file-type","clipboard-clock","beer","lectern","shield","table-properties","table-columns-split","binary","move-diagonal","table-cells-merge","door-closed","table-2","layout-template","table","syringe","save-off","bookmark-off","hand-heart","switch-camera","scan-qr-code","message-square-check","swiss-franc","bell-off","sunset","brain","sun-medium","sun-dim","folder-cog","key","clock-11","subscript","ticket-plus","arrow-up-0-1","bell-electric","stretch-horizontal","heading","book-open-check","panel-top-close","lasso-select","map-pin-x","stone","info","sticky-note-x","bus","chart-bar-stacked","bed-single","chart-no-axes-gantt","file-spreadsheet","file-minus-corner","clipboard-list","grid-2x2","contact-round","sticky-note-check","keyboard-off","sticky-note","file-badge","battery-warning","mail-question-mark","arrow-down-from-line","briefcase","biohazard","rectangle-circle","braces","scale-3d","panel-top-bottom-dashed","mail-x","square-dashed-mouse-pointer","user-cog","lock-open","step-back","pizza","list-indent-decrease","arrow-up-wide-narrow","star-off","clock-5","shield-cog","rotate-ccw","align-horizontal-justify-center","star","antenna","memory-stick","scan-eye","stamp","square-check","heart-plus","squirrel","map-pin-minus-inside","git-merge","gallery-vertical-end","component","hand-coins","zodiac-capricorn","wifi-low","heading-2","clock","file-pen","git-compare-arrows","cloud-sun-rain","align-horizontal-justify-start","squares-exclude","square-user","calculator","calendar-plus","square-stack","arrow-down-z-a","bath","square-split-vertical","unlink-2","square-sigma","square-scissors","folder-check","square-round-corner","book-key","ribbon","microwave","line-dot-right-horizontal","gallery-vertical","square-plus","square-play","square-dashed-text","map-pin-pen","move-up-left","square-pilcrow","folder-heart","square-pi","music-2","lock","arrow-up-a-z","square-parking","square-dashed-top-solid","panel-right-open","square-m","square-kanban","swatch-book","receipt-cent","spool","folder-archive","folder-symlink","columns-3","ban","message-square-x","paint-roller","square-equal","archive","square-dot","square-divide","building-2","circle-slash-2","square-dashed-bottom","cake","cloud-rain","chart-bar","square-code","wrench","list-indent-increase","square-chevron-left","search-alert","flag-triangle-right","square-chart-gantt","square-centerline-dashed-vertical","bell","square-bottom-dashed-scissors","square-asterisk","music-3","chart-bar-big","user-check","proportions","siren","plane","webhook-off","carrot","square-arrow-left","file-cog","circle-dashed","square-arrow-right-exit","square-arrow-right-enter","square-arrow-out-up-right","mailbox","squares-subtract","package-search","square-arrow-out-down-left","split","square-arrow-down-right","globe-x","forklift","monitor-pause","alarm-clock-minus","heart-x","eraser","book-marked","square","bluetooth-connected","rotate-ccw-square","chart-no-axes-column","cannabis-off","folder-kanban","sprout","mars-stroke","spray-can","sport-shoe","remove-formatting","file-box","speech","paint-bucket","glass-water","speaker","glasses","piggy-bank","sparkles","cuboid","cloud-off","check-check","activity","axe","plane-takeoff","sparkle","cloud-rain-wind","spade","flag-off","copy-x","file-axis-3d","radical","chart-column-decreasing","soup","bug-play","align-vertical-distribute-start","solar-panel","waves-arrow-up","tally-5","snail","smartphone-nfc","chevrons-left-right-ellipsis","circle-divide","smartphone","sliders-vertical","sliders-horizontal","life-buoy","saudi-riyal","mic-vocal","volume-2","battery-charging","russian-ruble","square-arrow-up-left","brick-wall-shield","footprints","signature","building","signal-medium","signal-low","git-branch","sigma","book-alert","link-2","astroid","bell-minus","image-up","closed-caption","drum","arrow-up-z-a","sun","fan","shrimp","file-key","house-heart","paintbrush-vertical","scissors-line-dashed","plug","shopping-bag","ship-wheel","ticket-check","combine","shield-question-mark","shield-plus","mountain","mars","picture-in-picture-2","radio-off","flower-2","shield-off","squares-intersect","shield-half","shield-cog-corner","keyboard-music","star-half","shield-ban","code-xml","pencil-line","mails","brain-cog","tablet","shelving-unit","pi","trash","book-down","hdmi-port","git-pull-request-draft","case-upper","circle-fading-arrow-up","share","croissant","shapes","settings-2","barcode","settings","server-crash","bed","server-cog","divide","grape","server","party-popper","file-chart-pie","send-horizontal","search-x","dice-6","search-slash","blender","search-code","zap-off","square-check-big","search","scroll","screen-share-off","laptop-minimal","screen-share","lock-keyhole","map-pin-minus","school","chart-spline","message-square-more","scan-search","chart-candlestick","list-music","arrow-down-a-z","circle-ellipsis","scan-face","move-horizontal","file-sliders","frown","scan-barcode","cup-soda","scan","rows-2","sword","infinity","package-open","earth","slice","dice-3","milk","mouse-pointer-ban","crown","circle-slash","circle-star","rotate-cw-square","atom","package-x","bed-double","satellite-dish","circle-dot","file-exclamation-point","hand-fist","message-circle-code","folder-git-2","message-square-code","sandwich","towel-rack","sailboat","arrow-big-left-dash","monitor-speaker","dumbbell","file-search-corner","rows-4","rows-3","scale","router","flashlight","panel-top-open","route","rotate-3d","notebook","redo-2","roller-coaster","square-menu","rewind","monitor-smartphone","laptop","scan-line","clock-4","square-arrow-up","book-minus","file-question-mark","replace-all","replace","repeat-off","arrow-down-to-line","repeat-2","refresh-ccw","venetian-mask","calendar-check-2","repeat","spline","banknote-x","git-pull-request-create-arrow","regex","circle-check","refrigerator","refresh-cw-off","refresh-cw","copyleft","redo","circle-play","timer-off","arrow-big-right-dash","rectangle-goggles","hard-hat","receipt-swiss-franc","backpack","receipt-russian-ruble","keyboard","receipt-japanese-yen","receipt-euro","rainbow","arrow-down-right","ratio","receipt","wifi-zero","radio-receiver","radio","radiation","radar","image-off","quote","pyramid","puzzle","projector","square-chevron-right","mail-search","printer-check","power-off","power","pound-sterling","popsicle","folder-search-2","tally-1","ampersand","plus","shopping-cart","align-vertical-justify-end","play-off","alarm-smoke","play","file-input","clock-8","hand-grab","cloud-cog","blend","hd","radio-tower","list-tree","droplet","pin-off","eye","crosshair","pill","banana","gpu","message-square-plus","pilcrow-left","circle-equal","pickaxe","piano","circle-alert","phone-off","text-initial","arrow-up-right","phone-forwarded","leafy-green","message-square-dot","file-chart-line","columns-3-cog","phone","grip","minimize-2","percent","pentagon","cone","pencil-off","file-image","diamond-minus","palette","barrel","gallery-thumbnails","pen-off","cpu","pen-line","thumbs-down","merge","hamburger","pc-case","hat-glasses","code","notepad-text","parasol","calendar-minus","panels-left-bottom","file-video-camera","panel-top","kanban","bone","apple","rocking-chair","bot-off","panel-right-close","panel-left-right-dashed","panel-left-open","circle-arrow-out-up-left","panel-left-dashed","cable-car","arrow-down-left","square-activity","hotel","cigarette-off","panel-bottom-close","message-circle","circle-arrow-out-up-right","panel-bottom","panda","fold-horizontal","shovel","calendar-1","cloud-moon","square-arrow-out-down-right","package-plus","clock-plus","save","cloud-snow","anvil","arrow-big-up-dash","dices","package-2","package","orbit","omega","logs","chevrons-down-up","clipboard-plus","circle-x","list-end","octagon-pause","octagon-minus","chevrons-right","move-right","message-square-reply","corner-down-right","nut-off","nut","lamp-wall-down","notepad-text-dashed","paw-print","ellipsis-vertical","globe-off","square-stop","arrow-up-1-0","align-horizontal-justify-end","scan-heart","align-vertical-distribute-end","heart-crack","airplay","newspaper","network","navigation-2","monitor-x","bell-check","navigation","square-pen","file-minus","move-up-right","dice-5","octagon","ticket","move-down-right","move-down-left","train-front","bookmark","microscope","album","mouse-pointer","chart-bar-decreasing","mouse-off","calendar-sync","funnel-plus","store","circle-arrow-down","notebook-pen","egg-fried","moon","monitor-up","corner-right-up","monitor-stop","ruler-dimension-line","user-round-plus","panel-left-close","monitor-off","pilcrow-right","user-round-minus","monitor-cog","monitor-check","mail-plus","layout-dashboard","heart-pulse","milestone","mouse-pointer-2-off","drone","slash","mic","aperture","arrow-right-left","case-sensitive","vector-square","circle-gauge","message-square-text","check","text-search","arrow-down-to-dot","monitor-down","message-square-lock","chef-hat","message-square-heart","message-square-diff","file-archive","signal-high","inbox","flip-horizontal-2","message-circle-off","image-play","align-horizontal-space-between","message-circle-heart","calendar-check","database-zap","droplets","message-circle-dashed","message-circle-check","meh","layout-list","file-search","maximize-2","alarm-clock-plus","circle-dollar-sign","usb","house","receipt-pound-sterling","list-check","map-pin-x-inside","id-card","mouse","minimize","map-pin-plus","diff","file-play","map-pin","book-x","mirror-rectangular","bird","mail","magnet","headphone-off","asterisk","circle-arrow-right","octagon-x","languages","log-in","alarm-clock-check","guitar","lock-keyhole-open","beer-off","scooter","square-parking-off","notebook-text","arrow-right-to-line","ticket-minus","tally-4","zodiac-taurus","loader-circle","door-open","flag-triangle-left","grid-3x3","file","diameter","pocket-knife","book-copy","castle","car-front","clock-alert","reply-all","cloud-moon-rain","clipboard-type","list-collapse","list-todo","printer-x","lamp-wall-up","list-start","list-chevrons-up-down","a-large-small","list-chevrons-down-up","list-checks","map-plus","link-2-off","link","line-style","line-squiggle","arrow-right-from-line","flame-kindling","square-power","calendar-range","bring-to-front","lightbulb","ligature","bell-plus","library-big","layout-panel-top","layout-grid","folders","mail-warning","layers","laugh","lasso","chevrons-left-right","chart-line","file-lock","cast","circle-fading-plus","clock-10","undo-dot","target","list-filter-plus","lamp-ceiling","drama","lamp","baseline","martini","contrast","key-square","candy-off","file-x-corner","book-check","kayak","book-lock","joystick","briefcase-medical","calendars","text-align-start","iteration-ccw","hop-off","warehouse","sticky-notes","drafting-compass","save-all","indian-rupee","image-plus","image-minus","id-card-lanyard","ice-cream-cone","fishing-rod","book-headphones","credit-card","ice-cream-bowl","house-wifi","house-plug","shredder","panel-bottom-open","hospital","highlighter","helicopter","balloon","map-pin-plus-inside","bookmark-x","badge-question-mark","pen","heart-minus","candy-cane","heart","headset","gamepad-2","file-x","heading-6","heading-5","heading-3","shield-minus","circle-off","dessert","eclipse","church","heading-1","cylinder","badge-japanese-yen","haze","receipt-text","hard-drive-upload","hard-drive-download","file-digit","handbag","file-output","disc-album","hand-platter","arrow-down-0-1","captions","hand","hammer","philippine-peso","badge-alert","flower","folder-pen","cross","grid-2x2-check","chevron-right","sticky-note-minus","square-arrow-down-left","share-2","git-pull-request-create","contact","folder-lock","git-merge-conflict","git-compare","git-commit-vertical","chess-pawn","git-commit-horizontal","briefcase-business","clipboard","message-circle-reply","gift","triangle-right","folder-clock","gem","gauge","type","webhook","fullscreen","align-horizontal-distribute-start","fuel","folder-up","pointer-off","turtle","camera","folder-open","folder-minus","git-pull-request","bluetooth-searching","arrow-up-to-line","squircle-dashed","clock-3","badge-percent","shuffle","folder-closed","folder","grid-2x2-plus","flask-round","box","flask-conical-off","clock-1","file-heart","flashlight-off","space","fish","fire-extinguisher","fingerprint-pattern","corner-up-left","clock-6","zodiac-scorpio","key-round","headphones","tv","file-type-corner","file-stack","rss","cookie","at-sign","map-pin-check-inside","sticky-note-off","music","handshake","file-check","circle-user","copy-plus","file-chart-column-increasing","file-braces","shrink","factory","external-link","search-check","clipboard-check","columns-2","euro","equal-approximately","align-center-vertical","earth-lock","droplet-off","club","cloud-fog","dock","disc","map-pin-house","package-check","chevron-first","pencil","cloud-drizzle","list-x","delete","computer","corner-up-right","currency","pin","crop","corner-right-down","badge-indian-rupee","copyright","redo-dot","brick-wall","align-start-horizontal","chart-column-stacked","file-plus","git-pull-request-arrow","construction","decimals-arrow-right","bell-dot","folder-down","compass","coins","align-horizontal-space-around","door-closed-locked","cloud-sync","diamond","blinds","cloud-backup","clock-9","book-search","git-branch-minus","clapperboard","recycle","mountain-snow","luggage","circle-arrow-out-down-left","bot-message-square","phone-outgoing","smartphone-charging","chevrons-down","train-track","chess-bishop","cherry","sticky-note-plus","chart-no-axes-column-increasing","chart-no-axes-column-decreasing","chart-network","chart-no-axes-combined","metronome","case-lower","arrow-down-1-0","caravan","candy","arrow-left-right","lightbulb-off","panels-top-left","beef-off","locate-off","annoyed","test-tube","brick-wall-fire","cooking-pot","boxes","boom-box","book-up","laptop-minimal-check","mail-open","square-function","baggage-claim","variable","arrow-right","archive-restore"},{if getcustomasset and not c then getcustomasset"lucide-icons/1.png"else"rbxassetid://89707116417717",if getcustomasset and not c then getcustomasset"lucide-icons/2.png"else"rbxassetid://101599128715386"},{[48]={{1,{24,24},{175,0}},{1,{24,24},{350,275}},{1,{24,24},{725,325}},{1,{24,24},{900,725}},{1,{24,24},{500,425}},{1,{24,24},{600,200}},{1,{24,24},{975,325}},{2,{24,24},{50,150}},{1,{24,24},{125,275}},{1,{24,24},{375,300}},{1,{24,24},{725,175}},{1,{24,24},{125,325}},{1,{24,24},{375,600}},{1,{24,24},{275,550}},{1,{24,24},{50,75}},{1,{24,24},{475,475}},{1,{24,24},{425,800}},{1,{24,24},{875,350}},{1,{24,24},{350,25}},{1,{24,24},{175,250}},{1,{24,24},{100,725}},{1,{24,24},{975,350}},{1,{24,24},{75,900}},{1,{24,24},{75,450}},{1,{24,24},{525,850}},{1,{24,24},{125,300}},{1,{24,24},{850,100}},{1,{24,24},{650,975}},{1,{24,24},{575,175}},{1,{24,24},{400,100}},{1,{24,24},{625,225}},{1,{24,24},{550,675}},{1,{24,24},{250,850}},{1,{24,24},{775,575}},{1,{24,24},{825,25}},{1,{24,24},{825,400}},{1,{24,24},{100,100}},{1,{24,24},{200,750}},{1,{24,24},{725,950}},{1,{24,24},{400,50}},{2,{24,24},{175,125}},{1,{24,24},{725,0}},{1,{24,24},{275,825}},{1,{24,24},{625,100}},{1,{24,24},{325,575}},{1,{24,24},{600,0}},{1,{24,24},{750,375}},{2,{24,24},{50,100}},{1,{24,24},{725,525}},{1,{24,24},{150,275}},{1,{24,24},{25,600}},{1,{24,24},{250,275}},{1,{24,24},{875,225}},{1,{24,24},{500,700}},{1,{24,24},{25,450}},{1,{24,24},{250,625}},{1,{24,24},{0,625}},{1,{24,24},{800,700}},{1,{24,24},{550,950}},{1,{24,24},{750,850}},{1,{24,24},{450,950}},{2,{24,24},{250,50}},{1,{24,24},{325,650}},{1,{24,24},{425,725}},{1,{24,24},{400,425}},{1,{24,24},{225,100}},{1,{24,24},{750,100}},{1,{24,24},{700,775}},{1,{24,24},{600,600}},{1,{24,24},{425,900}},{1,{24,24},{950,25}},{1,{24,24},{75,200}},{1,{24,24},{875,525}},{1,{24,24},{800,900}},{1,{24,24},{350,200}},{2,{24,24},{200,125}},{1,{24,24},{250,900}},{2,{24,24},{125,100}},{1,{24,24},{575,675}},{1,{24,24},{925,875}},{1,{24,24},{275,100}},{1,{24,24},{350,225}},{1,{24,24},{100,75}},{1,{24,24},{350,450}},{1,{24,24},{925,225}},{1,{24,24},{450,575}},{1,{24,24},{0,875}},{1,{24,24},{175,600}},{1,{24,24},{125,125}},{2,{24,24},{0,225}},{1,{24,24},{975,175}},{1,{24,24},{650,525}},{1,{24,24},{0,950}},{1,{24,24},{600,350}},{1,{24,24},{575,600}},{1,{24,24},{250,475}},{1,{24,24},{325,900}},{1,{24,24},{100,650}},{1,{24,24},{275,75}},{1,{24,24},{525,200}},{2,{24,24},{150,0}},{1,{24,24},{25,250}},{1,{24,24},{175,300}},{1,{24,24},{700,425}},{1,{24,24},{475,725}},{1,{24,24},{0,575}},{1,{24,24},{550,425}},{1,{24,24},{450,325}},{1,{24,24},{875,925}},{1,{24,24},{375,575}},{1,{24,24},{550,125}},{1,{24,24},{475,150}},{1,{24,24},{150,250}},{1,{24,24},{800,475}},{1,{24,24},{375,975}},{1,{24,24},{200,0}},{1,{24,24},{475,925}},{1,{24,24},{100,575}},{1,{24,24},{750,475}},{1,{24,24},{175,375}},{1,{24,24},{275,325}},{1,{24,24},{275,125}},{1,{24,24},{575,925}},{1,{24,24},{325,450}},{1,{24,24},{375,525}},{1,{24,24},{125,950}},{1,{24,24},{900,100}},{1,{24,24},{725,925}},{1,{24,24},{75,125}},{1,{24,24},{125,525}},{1,{24,24},{250,825}},{1,{24,24},{550,0}},{1,{24,24},{175,750}},{1,{24,24},{50,175}},{1,{24,24},{925,800}},{1,{24,24},{375,875}},{1,{24,24},{225,525}},{1,{24,24},{750,200}},{1,{24,24},{850,950}},{1,{24,24},{725,50}},{1,{24,24},{500,325}},{2,{24,24},{0,150}},{1,{24,24},{550,750}},{1,{24,24},{275,875}},{1,{24,24},{0,100}},{1,{24,24},{250,325}},{1,{24,24},{200,950}},{1,{24,24},{50,750}},{2,{24,24},{175,50}},{1,{24,24},{875,725}},{1,{24,24},{25,575}},{1,{24,24},{950,800}},{1,{24,24},{575,0}},{1,{24,24},{325,225}},{1,{24,24},{700,225}},{1,{24,24},{525,175}},{1,{24,24},{150,325}},{1,{24,24},{500,175}},{1,{24,24},{475,800}},{1,{24,24},{50,300}},{1,{24,24},{150,200}},{1,{24,24},{575,275}},{1,{24,24},{150,350}},{1,{24,24},{625,75}},{2,{24,24},{25,100}},{1,{24,24},{250,650}},{2,{24,24},{75,100}},{1,{24,24},{250,75}},{1,{24,24},{100,200}},{1,{24,24},{50,125}},{1,{24,24},{775,250}},{1,{24,24},{425,775}},{1,{24,24},{625,775}},{1,{24,24},{300,575}},{1,{24,24},{75,350}},{1,{24,24},{25,100}},{1,{24,24},{475,325}},{1,{24,24},{150,400}},{1,{24,24},{575,575}},{1,{24,24},{325,525}},{1,{24,24},{375,0}},{1,{24,24},{850,425}},{1,{24,24},{450,775}},{1,{24,24},{75,675}},{1,{24,24},{450,475}},{1,{24,24},{0,525}},{1,{24,24},{500,0}},{1,{24,24},{525,925}},{1,{24,24},{450,225}},{2,{24,24},{150,75}},{1,{24,24},{575,25}},{1,{24,24},{525,125}},{2,{24,24},{250,0}},{1,{24,24},{850,325}},{1,{24,24},{250,925}},{1,{24,24},{50,400}},{1,{24,24},{75,50}},{1,{24,24},{875,825}},{1,{24,24},{775,175}},{1,{24,24},{325,925}},{1,{24,24},{750,275}},{1,{24,24},{125,250}},{1,{24,24},{475,625}},{1,{24,24},{25,750}},{1,{24,24},{725,375}},{1,{24,24},{125,775}},{1,{24,24},{750,350}},{1,{24,24},{400,675}},{1,{24,24},{550,600}},{1,{24,24},{50,250}},{1,{24,24},{50,275}},{1,{24,24},{150,125}},{2,{24,24},{25,0}},{1,{24,24},{475,550}},{1,{24,24},{325,800}},{1,{24,24},{475,675}},{1,{24,24},{950,450}},{1,{24,24},{700,175}},{1,{24,24},{700,100}},{1,{24,24},{100,750}},{1,{24,24},{725,25}},{1,{24,24},{100,125}},{1,{24,24},{900,600}},{1,{24,24},{175,950}},{1,{24,24},{125,575}},{1,{24,24},{75,625}},{2,{24,24},{125,75}},{1,{24,24},{825,275}},{1,{24,24},{300,525}},{2,{24,24},{125,0}},{1,{24,24},{450,175}},{2,{24,24},{150,150}},{1,{24,24},{600,275}},{1,{24,24},{425,925}},{1,{24,24},{75,25}},{1,{24,24},{800,600}},{1,{24,24},{400,950}},{1,{24,24},{275,250}},{1,{24,24},{900,525}},{1,{24,24},{0,450}},{1,{24,24},{175,675}},{1,{24,24},{625,475}},{1,{24,24},{100,525}},{1,{24,24},{925,975}},{1,{24,24},{875,550}},{1,{24,24},{0,675}},{1,{24,24},{650,425}},{1,{24,24},{75,225}},{1,{24,24},{225,425}},{1,{24,24},{300,375}},{1,{24,24},{0,175}},{1,{24,24},{175,825}},{1,{24,24},{375,275}},{2,{24,24},{150,175}},{1,{24,24},{175,225}},{1,{24,24},{350,825}},{1,{24,24},{300,225}},{1,{24,24},{225,400}},{1,{24,24},{300,900}},{1,{24,24},{0,900}},{1,{24,24},{975,250}},{1,{24,24},{575,225}},{1,{24,24},{25,200}},{1,{24,24},{550,50}},{1,{24,24},{200,325}},{1,{24,24},{200,375}},{1,{24,24},{550,525}},{1,{24,24},{725,100}},{1,{24,24},{825,625}},{1,{24,24},{700,550}},{1,{24,24},{275,175}},{2,{24,24},{25,225}},{1,{24,24},{125,975}},{1,{24,24},{100,250}},{1,{24,24},{325,400}},{1,{24,24},{150,525}},{1,{24,24},{650,725}},{1,{24,24},{800,275}},{1,{24,24},{975,400}},{1,{24,24},{150,50}},{2,{24,24},{25,125}},{1,{24,24},{250,575}},{1,{24,24},{900,650}},{1,{24,24},{800,800}},{1,{24,24},{975,625}},{1,{24,24},{300,250}},{1,{24,24},{825,75}},{1,{24,24},{100,275}},{1,{24,24},{500,300}},{1,{24,24},{425,675}},{1,{24,24},{825,225}},{1,{24,24},{550,175}},{1,{24,24},{425,400}},{1,{24,24},{200,25}},{1,{24,24},{675,150}},{1,{24,24},{350,400}},{1,{24,24},{275,700}},{1,{24,24},{600,725}},{1,{24,24},{350,150}},{1,{24,24},{500,400}},{1,{24,24},{100,625}},{1,{24,24},{400,275}},{1,{24,24},{150,825}},{1,{24,24},{950,775}},{1,{24,24},{600,300}},{1,{24,24},{100,350}},{1,{24,24},{800,225}},{1,{24,24},{325,75}},{2,{24,24},{0,100}},{1,{24,24},{250,350}},{1,{24,24},{175,725}},{1,{24,24},{675,75}},{1,{24,24},{225,125}},{1,{24,24},{0,150}},{1,{24,24},{400,125}},{1,{24,24},{800,300}},{1,{24,24},{225,225}},{1,{24,24},{575,950}},{1,{24,24},{375,200}},{1,{24,24},{450,50}},{1,{24,24},{500,450}},{1,{24,24},{650,25}},{1,{24,24},{75,250}},{1,{24,24},{375,750}},{1,{24,24},{275,0}},{1,{24,24},{425,350}},{2,{24,24},{75,175}},{1,{24,24},{550,725}},{1,{24,24},{225,325}},{1,{24,24},{325,425}},{1,{24,24},{550,350}},{1,{24,24},{325,150}},{1,{24,24},{250,875}},{1,{24,24},{850,550}},{1,{24,24},{900,475}},{1,{24,24},{600,550}},{1,{24,24},{900,350}},{1,{24,24},{375,250}},{1,{24,24},{50,450}},{1,{24,24},{250,300}},{1,{24,24},{775,275}},{1,{24,24},{200,900}},{1,{24,24},{225,25}},{1,{24,24},{625,900}},{1,{24,24},{200,525}},{1,{24,24},{850,750}},{1,{24,24},{525,900}},{1,{24,24},{775,150}},{1,{24,24},{375,325}},{1,{24,24},{275,275}},{1,{24,24},{500,375}},{1,{24,24},{350,0}},{1,{24,24},{550,475}},{1,{24,24},{875,25}},{1,{24,24},{225,750}},{1,{24,24},{550,650}},{1,{24,24},{600,50}},{1,{24,24},{800,325}},{1,{24,24},{650,775}},{1,{24,24},{150,625}},{1,{24,24},{25,800}},{1,{24,24},{925,900}},{1,{24,24},{75,850}},{1,{24,24},{250,100}},{1,{24,24},{875,375}},{1,{24,24},{750,225}},{1,{24,24},{400,225}},{1,{24,24},{700,250}},{1,{24,24},{550,400}},{2,{24,24},{275,75}},{1,{24,24},{950,550}},{1,{24,24},{250,450}},{1,{24,24},{550,275}},{1,{24,24},{875,475}},{1,{24,24},{725,675}},{1,{24,24},{625,200}},{1,{24,24},{750,400}},{1,{24,24},{150,550}},{1,{24,24},{750,950}},{1,{24,24},{750,575}},{1,{24,24},{225,450}},{1,{24,24},{900,150}},{1,{24,24},{750,325}},{1,{24,24},{775,50}},{1,{24,24},{75,650}},{1,{24,24},{525,275}},{1,{24,24},{625,975}},{1,{24,24},{675,775}},{1,{24,24},{825,375}},{1,{24,24},{975,875}},{1,{24,24},{600,25}},{1,{24,24},{225,300}},{1,{24,24},{200,300}},{1,{24,24},{475,125}},{1,{24,24},{800,975}},{1,{24,24},{0,50}},{1,{24,24},{375,425}},{1,{24,24},{0,850}},{1,{24,24},{650,50}},{1,{24,24},{300,325}},{1,{24,24},{350,125}},{1,{24,24},{575,100}},{1,{24,24},{875,75}},{1,{24,24},{675,50}},{1,{24,24},{875,325}},{1,{24,24},{250,400}},{1,{24,24},{725,825}},{1,{24,24},{175,100}},{1,{24,24},{200,725}},{1,{24,24},{925,0}},{1,{24,24},{25,475}},{1,{24,24},{100,325}},{1,{24,24},{350,425}},{1,{24,24},{775,425}},{1,{24,24},{275,775}},{1,{24,24},{350,575}},{1,{24,24},{675,25}},{1,{24,24},{850,25}},{1,{24,24},{800,825}},{1,{24,24},{900,225}},{1,{24,24},{950,925}},{1,{24,24},{275,450}},{1,{24,24},{50,325}},{1,{24,24},{125,675}},{1,{24,24},{75,475}},{2,{24,24},{150,200}},{1,{24,24},{225,200}},{1,{24,24},{275,375}},{2,{24,24},{175,175}},{1,{24,24},{100,175}},{1,{24,24},{125,175}},{1,{24,24},{675,225}},{2,{24,24},{200,150}},{1,{24,24},{525,525}},{2,{24,24},{275,25}},{1,{24,24},{400,725}},{1,{24,24},{725,75}},{1,{24,24},{825,975}},{1,{24,24},{575,300}},{2,{24,24},{300,50}},{1,{24,24},{975,950}},{1,{24,24},{975,900}},{1,{24,24},{250,425}},{1,{24,24},{25,150}},{2,{24,24},{350,0}},{2,{24,24},{0,325}},{2,{24,24},{25,300}},{1,{24,24},{0,225}},{1,{24,24},{600,75}},{1,{24,24},{25,525}},{2,{24,24},{100,25}},{1,{24,24},{850,300}},{1,{24,24},{150,225}},{1,{24,24},{725,200}},{1,{24,24},{700,500}},{1,{24,24},{675,875}},{1,{24,24},{50,950}},{1,{24,24},{850,925}},{2,{24,24},{100,225}},{1,{24,24},{775,475}},{2,{24,24},{125,200}},{1,{24,24},{100,225}},{1,{24,24},{475,350}},{2,{24,24},{225,100}},{1,{24,24},{500,975}},{1,{24,24},{75,800}},{1,{24,24},{525,775}},{2,{24,24},{275,50}},{1,{24,24},{75,725}},{2,{24,24},{300,25}},{2,{24,24},{0,300}},{2,{24,24},{325,0}},{2,{24,24},{50,250}},{1,{24,24},{500,750}},{1,{24,24},{225,850}},{2,{24,24},{25,250}},{1,{24,24},{175,75}},{1,{24,24},{475,875}},{1,{24,24},{775,75}},{1,{24,24},{275,950}},{1,{24,24},{775,975}},{1,{24,24},{575,900}},{1,{24,24},{100,675}},{1,{24,24},{275,525}},{1,{24,24},{175,50}},{1,{24,24},{600,775}},{1,{24,24},{175,775}},{2,{24,24},{125,175}},{1,{24,24},{850,600}},{1,{24,24},{950,525}},{2,{24,24},{225,75}},{1,{24,24},{750,300}},{2,{24,24},{75,225}},{1,{24,24},{400,900}},{2,{24,24},{0,275}},{1,{24,24},{50,550}},{2,{24,24},{300,0}},{2,{24,24},{50,225}},{1,{24,24},{275,475}},{2,{24,24},{25,275}},{1,{24,24},{625,675}},{1,{24,24},{625,400}},{1,{24,24},{550,375}},{1,{24,24},{525,150}},{2,{24,24},{125,150}},{1,{24,24},{475,175}},{1,{24,24},{850,700}},{1,{24,24},{525,475}},{1,{24,24},{325,275}},{2,{24,24},{150,125}},{1,{24,24},{925,650}},{2,{24,24},{175,100}},{1,{24,24},{0,0}},{1,{24,24},{450,300}},{1,{24,24},{875,700}},{2,{24,24},{200,75}},{2,{24,24},{225,50}},{1,{24,24},{550,875}},{2,{24,24},{275,0}},{2,{24,24},{0,250}},{1,{24,24},{550,450}},{1,{24,24},{675,325}},{1,{24,24},{325,50}},{1,{24,24},{925,625}},{1,{24,24},{375,475}},{2,{24,24},{100,150}},{1,{24,24},{0,400}},{1,{24,24},{950,375}},{1,{24,24},{750,125}},{2,{24,24},{125,125}},{1,{24,24},{750,775}},{2,{24,24},{175,75}},{1,{24,24},{750,250}},{1,{24,24},{50,425}},{1,{24,24},{625,800}},{1,{24,24},{975,450}},{2,{24,24},{200,50}},{1,{24,24},{225,500}},{2,{24,24},{150,100}},{1,{24,24},{900,625}},{2,{24,24},{225,25}},{1,{24,24},{375,775}},{1,{24,24},{0,275}},{1,{24,24},{275,300}},{2,{24,24},{25,200}},{1,{24,24},{850,575}},{1,{24,24},{75,550}},{2,{24,24},{75,150}},{2,{24,24},{100,125}},{2,{24,24},{50,125}},{2,{24,24},{200,25}},{1,{24,24},{800,850}},{2,{24,24},{0,200}},{2,{24,24},{75,125}},{1,{24,24},{950,575}},{1,{24,24},{100,25}},{1,{24,24},{800,500}},{1,{24,24},{600,225}},{1,{24,24},{200,875}},{1,{24,24},{0,550}},{1,{24,24},{325,775}},{2,{24,24},{175,25}},{1,{24,24},{750,75}},{1,{24,24},{300,75}},{2,{24,24},{0,175}},{2,{24,24},{25,150}},{1,{24,24},{425,250}},{2,{24,24},{225,0}},{1,{24,24},{450,550}},{2,{24,24},{125,50}},{2,{24,24},{100,75}},{2,{24,24},{175,0}},{1,{24,24},{400,625}},{1,{24,24},{875,0}},{1,{24,24},{300,350}},{1,{24,24},{50,0}},{2,{24,24},{75,75}},{1,{24,24},{650,850}},{1,{24,24},{125,75}},{2,{24,24},{100,50}},{1,{24,24},{950,700}},{1,{24,24},{550,575}},{1,{24,24},{650,475}},{2,{24,24},{50,75}},{2,{24,24},{75,50}},{1,{24,24},{725,650}},{1,{24,24},{350,300}},{2,{24,24},{25,75}},{2,{24,24},{50,50}},{1,{24,24},{450,625}},{1,{24,24},{150,600}},{1,{24,24},{125,550}},{1,{24,24},{900,675}},{1,{24,24},{800,675}},{2,{24,24},{150,25}},{1,{24,24},{275,800}},{1,{24,24},{425,475}},{1,{24,24},{425,50}},{2,{24,24},{25,50}},{2,{24,24},{50,25}},{1,{24,24},{175,275}},{1,{24,24},{900,900}},{1,{24,24},{700,575}},{1,{24,24},{650,875}},{2,{24,24},{75,0}},{2,{24,24},{25,25}},{2,{24,24},{50,0}},{2,{24,24},{0,25}},{1,{24,24},{125,350}},{1,{24,24},{150,725}},{1,{24,24},{950,975}},{1,{24,24},{750,175}},{1,{24,24},{975,575}},{1,{24,24},{200,700}},{2,{24,24},{0,0}},{2,{24,24},{325,25}},{1,{24,24},{950,950}},{1,{24,24},{900,975}},{1,{24,24},{25,275}},{1,{24,24},{425,450}},{1,{24,24},{575,350}},{1,{24,24},{775,100}},{1,{24,24},{300,600}},{1,{24,24},{900,25}},{1,{24,24},{450,100}},{1,{24,24},{400,300}},{1,{24,24},{900,950}},{1,{24,24},{925,925}},{1,{24,24},{950,900}},{1,{24,24},{700,300}},{1,{24,24},{225,825}},{1,{24,24},{75,400}},{1,{24,24},{850,975}},{1,{24,24},{150,850}},{1,{24,24},{250,600}},{1,{24,24},{725,275}},{1,{24,24},{425,500}},{1,{24,24},{200,150}},{1,{24,24},{50,375}},{1,{24,24},{950,875}},{1,{24,24},{875,950}},{1,{24,24},{975,850}},{1,{24,24},{950,850}},{1,{24,24},{700,675}},{1,{24,24},{825,950}},{1,{24,24},{275,350}},{1,{24,24},{700,475}},{1,{24,24},{925,850}},{1,{24,24},{675,675}},{1,{24,24},{850,775}},{1,{24,24},{875,275}},{1,{24,24},{950,825}},{1,{24,24},{975,800}},{1,{24,24},{775,950}},{1,{24,24},{800,950}},{1,{24,24},{225,600}},{1,{24,24},{525,50}},{1,{24,24},{675,650}},{1,{24,24},{875,875}},{1,{24,24},{850,900}},{1,{24,24},{900,850}},{1,{24,24},{925,825}},{1,{24,24},{425,525}},{1,{24,24},{975,775}},{1,{24,24},{200,200}},{1,{24,24},{750,975}},{1,{24,24},{775,875}},{1,{24,24},{800,925}},{1,{24,24},{425,850}},{1,{24,24},{850,875}},{1,{24,24},{400,875}},{1,{24,24},{825,900}},{1,{24,24},{375,75}},{1,{24,24},{900,825}},{1,{24,24},{250,150}},{1,{24,24},{400,375}},{1,{24,24},{725,975}},{1,{24,24},{675,175}},{1,{24,24},{600,975}},{1,{24,24},{475,575}},{1,{24,24},{975,425}},{1,{24,24},{800,650}},{1,{24,24},{700,450}},{1,{24,24},{0,325}},{1,{24,24},{500,475}},{1,{24,24},{950,750}},{1,{24,24},{0,425}},{1,{24,24},{975,725}},{1,{24,24},{925,775}},{1,{24,24},{700,975}},{1,{24,24},{450,850}},{1,{24,24},{375,725}},{1,{24,24},{125,925}},{1,{24,24},{775,900}},{1,{24,24},{775,450}},{1,{24,24},{850,825}},{1,{24,24},{825,850}},{1,{24,24},{600,100}},{1,{24,24},{175,325}},{1,{24,24},{0,75}},{1,{24,24},{475,525}},{1,{24,24},{575,475}},{1,{24,24},{900,775}},{1,{24,24},{850,625}},{1,{24,24},{925,750}},{1,{24,24},{25,325}},{1,{24,24},{425,75}},{1,{24,24},{950,725}},{1,{24,24},{975,700}},{1,{24,24},{700,950}},{1,{24,24},{25,0}},{1,{24,24},{100,600}},{1,{24,24},{150,375}},{1,{24,24},{750,900}},{2,{24,24},{25,175}},{1,{24,24},{150,900}},{2,{24,24},{75,250}},{1,{24,24},{850,800}},{1,{24,24},{725,125}},{1,{24,24},{575,850}},{1,{24,24},{375,225}},{1,{24,24},{425,625}},{1,{24,24},{925,725}},{1,{24,24},{75,500}},{1,{24,24},{300,100}},{1,{24,24},{625,425}},{1,{24,24},{675,950}},{1,{24,24},{950,475}},{1,{24,24},{700,925}},{1,{24,24},{425,125}},{1,{24,24},{25,975}},{1,{24,24},{475,400}},{1,{24,24},{750,875}},{1,{24,24},{500,550}},{1,{24,24},{150,300}},{1,{24,24},{75,700}},{1,{24,24},{800,75}},{1,{24,24},{25,650}},{1,{24,24},{400,25}},{1,{24,24},{500,525}},{1,{24,24},{925,475}},{1,{24,24},{825,800}},{1,{24,24},{875,750}},{1,{24,24},{25,400}},{1,{24,24},{825,325}},{1,{24,24},{925,700}},{1,{24,24},{425,375}},{1,{24,24},{950,675}},{1,{24,24},{575,450}},{1,{24,24},{775,850}},{1,{24,24},{975,650}},{1,{24,24},{525,800}},{1,{24,24},{375,125}},{1,{24,24},{225,725}},{1,{24,24},{675,925}},{1,{24,24},{925,425}},{1,{24,24},{675,425}},{1,{24,24},{700,900}},{1,{24,24},{275,150}},{1,{24,24},{775,825}},{1,{24,24},{525,0}},{1,{24,24},{900,700}},{1,{24,24},{925,675}},{1,{24,24},{700,200}},{1,{24,24},{300,700}},{1,{24,24},{425,275}},{1,{24,24},{950,650}},{1,{24,24},{775,925}},{1,{24,24},{200,100}},{1,{24,24},{325,100}},{1,{24,24},{625,950}},{1,{24,24},{675,300}},{1,{24,24},{200,275}},{1,{24,24},{725,475}},{1,{24,24},{875,150}},{1,{24,24},{500,575}},{1,{24,24},{675,900}},{1,{24,24},{575,425}},{1,{24,24},{750,825}},{1,{24,24},{50,475}},{1,{24,24},{450,150}},{1,{24,24},{75,325}},{1,{24,24},{75,525}},{1,{24,24},{50,800}},{1,{24,24},{425,425}},{1,{24,24},{700,0}},{1,{24,24},{575,375}},{1,{24,24},{500,250}},{1,{24,24},{850,725}},{1,{24,24},{250,750}},{1,{24,24},{725,850}},{1,{24,24},{150,675}},{1,{24,24},{225,175}},{1,{24,24},{975,100}},{1,{24,24},{25,225}},{1,{24,24},{350,175}},{1,{24,24},{450,0}},{1,{24,24},{500,775}},{1,{24,24},{75,425}},{1,{24,24},{475,850}},{1,{24,24},{750,450}},{1,{24,24},{900,175}},{1,{24,24},{875,625}},{2,{24,24},{75,25}},{1,{24,24},{350,700}},{1,{24,24},{950,625}},{1,{24,24},{300,925}},{1,{24,24},{875,175}},{1,{24,24},{300,25}},{1,{24,24},{575,975}},{1,{24,24},{300,400}},{1,{24,24},{550,825}},{1,{24,24},{350,950}},{1,{24,24},{150,0}},{1,{24,24},{975,600}},{1,{24,24},{25,175}},{1,{24,24},{150,925}},{1,{24,24},{375,950}},{1,{24,24},{625,925}},{1,{24,24},{600,875}},{1,{24,24},{475,500}},{1,{24,24},{650,900}},{1,{24,24},{700,375}},{1,{24,24},{125,800}},{1,{24,24},{650,275}},{1,{24,24},{625,125}},{1,{24,24},{300,650}},{2,{24,24},{50,275}},{2,{24,24},{200,100}},{1,{24,24},{800,175}},{1,{24,24},{25,675}},{1,{24,24},{300,550}},{1,{24,24},{250,675}},{1,{24,24},{350,375}},{1,{24,24},{100,50}},{1,{24,24},{800,750}},{1,{24,24},{875,675}},{1,{24,24},{500,50}},{1,{24,24},{125,425}},{1,{24,24},{550,975}},{1,{24,24},{125,150}},{1,{24,24},{375,25}},{1,{24,24},{600,925}},{2,{24,24},{0,50}},{1,{24,24},{675,850}},{1,{24,24},{700,825}},{1,{24,24},{800,100}},{1,{24,24},{725,800}},{1,{24,24},{300,175}},{1,{24,24},{575,725}},{1,{24,24},{950,175}},{1,{24,24},{275,750}},{1,{24,24},{625,300}},{1,{24,24},{800,725}},{1,{24,24},{825,700}},{1,{24,24},{850,650}},{1,{24,24},{625,450}},{1,{24,24},{650,500}},{1,{24,24},{850,675}},{1,{24,24},{575,325}},{1,{24,24},{875,650}},{1,{24,24},{525,625}},{1,{24,24},{325,725}},{1,{24,24},{150,150}},{1,{24,24},{975,550}},{1,{24,24},{825,675}},{1,{24,24},{800,400}},{1,{24,24},{625,875}},{1,{24,24},{675,825}},{1,{24,24},{725,875}},{1,{24,24},{750,525}},{1,{24,24},{725,725}},{1,{24,24},{850,50}},{1,{24,24},{225,675}},{1,{24,24},{750,0}},{1,{24,24},{200,175}},{1,{24,24},{300,800}},{1,{24,24},{400,775}},{1,{24,24},{725,775}},{1,{24,24},{75,150}},{1,{24,24},{750,750}},{1,{24,24},{775,725}},{1,{24,24},{125,400}},{1,{24,24},{350,325}},{1,{24,24},{925,575}},{1,{24,24},{525,25}},{1,{24,24},{400,325}},{1,{24,24},{425,175}},{1,{24,24},{975,525}},{2,{24,24},{250,75}},{1,{24,24},{850,200}},{1,{24,24},{550,925}},{1,{24,24},{625,725}},{1,{24,24},{325,550}},{1,{24,24},{650,825}},{1,{24,24},{675,800}},{1,{24,24},{200,225}},{1,{24,24},{725,750}},{1,{24,24},{750,725}},{1,{24,24},{500,650}},{1,{24,24},{525,75}},{2,{24,24},{100,0}},{1,{24,24},{450,800}},{1,{24,24},{925,500}},{1,{24,24},{975,275}},{2,{24,24},{100,175}},{1,{24,24},{175,400}},{1,{24,24},{500,950}},{1,{24,24},{700,150}},{1,{24,24},{200,450}},{1,{24,24},{875,600}},{1,{24,24},{900,575}},{1,{24,24},{925,550}},{1,{24,24},{850,225}},{1,{24,24},{750,800}},{1,{24,24},{500,675}},{1,{24,24},{475,975}},{1,{24,24},{750,700}},{1,{24,24},{550,900}},{1,{24,24},{800,150}},{1,{24,24},{25,875}},{1,{24,24},{575,550}},{1,{24,24},{25,50}},{1,{24,24},{425,550}},{1,{24,24},{575,250}},{1,{24,24},{250,225}},{1,{24,24},{825,725}},{1,{24,24},{250,200}},{1,{24,24},{375,925}},{1,{24,24},{125,475}},{1,{24,24},{400,175}},{1,{24,24},{525,375}},{1,{24,24},{625,825}},{1,{24,24},{375,700}},{1,{24,24},{650,800}},{1,{24,24},{700,750}},{1,{24,24},{825,475}},{1,{24,24},{125,700}},{1,{24,24},{875,575}},{1,{24,24},{425,750}},{1,{24,24},{925,25}},{1,{24,24},{900,550}},{1,{24,24},{900,50}},{1,{24,24},{525,700}},{1,{24,24},{925,525}},{1,{24,24},{550,225}},{1,{24,24},{450,275}},{1,{24,24},{625,0}},{1,{24,24},{25,25}},{1,{24,24},{25,300}},{1,{24,24},{250,975}},{1,{24,24},{950,500}},{1,{24,24},{425,300}},{1,{24,24},{975,475}},{1,{24,24},{375,500}},{1,{24,24},{250,500}},{1,{24,24},{175,650}},{1,{24,24},{975,300}},{1,{24,24},{350,250}},{1,{24,24},{475,950}},{1,{24,24},{175,350}},{1,{24,24},{125,50}},{1,{24,24},{500,925}},{2,{24,24},{250,25}},{1,{24,24},{875,775}},{1,{24,24},{600,825}},{1,{24,24},{700,725}},{1,{24,24},{150,475}},{1,{24,24},{175,475}},{1,{24,24},{675,750}},{1,{24,24},{750,675}},{1,{24,24},{775,650}},{1,{24,24},{375,650}},{1,{24,24},{575,750}},{1,{24,24},{175,925}},{2,{24,24},{50,175}},{1,{24,24},{350,50}},{1,{24,24},{725,600}},{1,{24,24},{825,650}},{1,{24,24},{475,50}},{1,{24,24},{50,850}},{1,{24,24},{425,975}},{1,{24,24},{100,425}},{1,{24,24},{500,900}},{1,{24,24},{525,875}},{1,{24,24},{325,600}},{1,{24,24},{575,825}},{1,{24,24},{25,425}},{1,{24,24},{175,850}},{1,{24,24},{175,150}},{1,{24,24},{300,125}},{1,{24,24},{775,225}},{1,{24,24},{0,700}},{1,{24,24},{150,650}},{1,{24,24},{275,50}},{1,{24,24},{825,775}},{1,{24,24},{325,500}},{1,{24,24},{675,725}},{1,{24,24},{475,375}},{1,{24,24},{125,850}},{1,{24,24},{375,800}},{1,{24,24},{800,550}},{1,{24,24},{850,400}},{1,{24,24},{825,575}},{1,{24,24},{900,500}},{1,{24,24},{850,850}},{1,{24,24},{700,50}},{1,{24,24},{400,975}},{1,{24,24},{425,950}},{1,{24,24},{275,850}},{1,{24,24},{350,725}},{1,{24,24},{575,650}},{1,{24,24},{950,325}},{1,{24,24},{50,825}},{1,{24,24},{450,925}},{1,{24,24},{775,775}},{1,{24,24},{500,875}},{1,{24,24},{575,800}},{1,{24,24},{275,725}},{1,{24,24},{600,950}},{1,{24,24},{625,750}},{1,{24,24},{150,575}},{1,{24,24},{250,950}},{1,{24,24},{825,250}},{1,{24,24},{0,500}},{1,{24,24},{725,900}},{1,{24,24},{675,700}},{1,{24,24},{650,575}},{1,{24,24},{975,825}},{1,{24,24},{400,75}},{1,{24,24},{850,125}},{1,{24,24},{0,925}},{1,{24,24},{100,475}},{1,{24,24},{25,625}},{1,{24,24},{750,625}},{1,{24,24},{675,100}},{1,{24,24},{800,575}},{1,{24,24},{850,525}},{1,{24,24},{25,350}},{1,{24,24},{825,550}},{1,{24,24},{925,450}},{1,{24,24},{50,350}},{1,{24,24},{950,425}},{1,{24,24},{625,175}},{1,{24,24},{675,275}},{1,{24,24},{875,500}},{1,{24,24},{450,750}},{1,{24,24},{850,0}},{1,{24,24},{450,900}},{1,{24,24},{525,825}},{1,{24,24},{800,0}},{1,{24,24},{550,800}},{1,{24,24},{325,125}},{1,{24,24},{575,775}},{2,{24,24},{175,150}},{1,{24,24},{625,850}},{1,{24,24},{500,850}},{1,{24,24},{650,700}},{1,{24,24},{725,625}},{1,{24,24},{925,100}},{1,{24,24},{700,650}},{1,{24,24},{375,675}},{1,{24,24},{675,400}},{1,{24,24},{825,525}},{1,{24,24},{0,600}},{1,{24,24},{500,600}},{1,{24,24},{900,450}},{1,{24,24},{400,200}},{1,{24,24},{800,250}},{1,{24,24},{50,200}},{1,{24,24},{75,575}},{1,{24,24},{350,975}},{1,{24,24},{725,425}},{1,{24,24},{75,775}},{1,{24,24},{875,50}},{1,{24,24},{400,925}},{1,{24,24},{525,250}},{1,{24,24},{850,500}},{1,{24,24},{875,450}},{1,{24,24},{650,950}},{1,{24,24},{600,400}},{1,{24,24},{550,625}},{1,{24,24},{0,800}},{1,{24,24},{800,625}},{1,{24,24},{50,725}},{1,{24,24},{875,250}},{1,{24,24},{150,975}},{1,{24,24},{575,200}},{1,{24,24},{325,350}},{1,{24,24},{275,400}},{1,{24,24},{325,975}},{1,{24,24},{125,200}},{1,{24,24},{475,700}},{1,{24,24},{100,300}},{1,{24,24},{625,700}},{1,{24,24},{100,550}},{1,{24,24},{600,250}},{1,{24,24},{275,675}},{1,{24,24},{950,150}},{1,{24,24},{625,275}},{1,{24,24},{650,450}},{1,{24,24},{650,675}},{1,{24,24},{825,925}},{1,{24,24},{700,625}},{1,{24,24},{250,0}},{1,{24,24},{500,625}},{1,{24,24},{100,700}},{1,{24,24},{150,700}},{1,{24,24},{825,500}},{1,{24,24},{850,475}},{1,{24,24},{450,875}},{1,{24,24},{900,425}},{1,{24,24},{200,675}},{1,{24,24},{675,525}},{1,{24,24},{925,400}},{1,{24,24},{425,875}},{1,{24,24},{975,200}},{1,{24,24},{350,925}},{1,{24,24},{475,825}},{1,{24,24},{600,900}},{1,{24,24},{600,700}},{1,{24,24},{525,600}},{1,{24,24},{900,125}},{1,{24,24},{950,400}},{1,{24,24},{325,375}},{1,{24,24},{775,700}},{1,{24,24},{225,250}},{1,{24,24},{200,650}},{1,{24,24},{700,600}},{1,{24,24},{675,625}},{1,{24,24},{750,550}},{1,{24,24},{200,75}},{1,{24,24},{775,525}},{1,{24,24},{950,350}},{2,{24,24},{100,100}},{1,{24,24},{400,150}},{1,{24,24},{725,575}},{1,{24,24},{775,675}},{1,{24,24},{75,300}},{1,{24,24},{50,875}},{1,{24,24},{850,450}},{1,{24,24},{325,325}},{1,{24,24},{875,425}},{1,{24,24},{925,375}},{1,{24,24},{900,400}},{1,{24,24},{200,550}},{1,{24,24},{300,975}},{1,{24,24},{475,200}},{1,{24,24},{875,850}},{1,{24,24},{200,50}},{1,{24,24},{450,825}},{1,{24,24},{975,0}},{1,{24,24},{600,675}},{1,{24,24},{325,25}},{1,{24,24},{625,650}},{1,{24,24},{225,775}},{1,{24,24},{675,600}},{1,{24,24},{725,550}},{1,{24,24},{825,450}},{1,{24,24},{250,25}},{1,{24,24},{775,500}},{1,{24,24},{525,750}},{2,{24,24},{100,200}},{1,{24,24},{925,350}},{1,{24,24},{875,400}},{1,{24,24},{275,975}},{1,{24,24},{300,950}},{1,{24,24},{850,150}},{1,{24,24},{350,900}},{1,{24,24},{400,850}},{1,{24,24},{425,825}},{1,{24,24},{475,775}},{1,{24,24},{525,950}},{1,{24,24},{950,125}},{1,{24,24},{550,700}},{1,{24,24},{625,625}},{1,{24,24},{600,650}},{1,{24,24},{650,600}},{1,{24,24},{675,575}},{1,{24,24},{275,625}},{1,{24,24},{975,675}},{1,{24,24},{175,25}},{1,{24,24},{825,425}},{1,{24,24},{775,625}},{1,{24,24},{75,100}},{1,{24,24},{950,300}},{1,{24,24},{50,50}},{1,{24,24},{925,325}},{1,{24,24},{500,350}},{1,{24,24},{225,475}},{1,{24,24},{250,700}},{1,{24,24},{650,75}},{1,{24,24},{350,100}},{1,{24,24},{875,100}},{1,{24,24},{900,375}},{1,{24,24},{650,400}},{1,{24,24},{200,600}},{1,{24,24},{375,850}},{1,{24,24},{375,450}},{1,{24,24},{600,175}},{1,{24,24},{400,825}},{1,{24,24},{175,200}},{1,{24,24},{725,225}},{1,{24,24},{450,650}},{1,{24,24},{500,725}},{1,{24,24},{50,600}},{1,{24,24},{600,625}},{1,{24,24},{625,600}},{1,{24,24},{575,75}},{1,{24,24},{725,500}},{1,{24,24},{800,875}},{1,{24,24},{0,300}},{1,{24,24},{800,425}},{1,{24,24},{525,500}},{1,{24,24},{575,525}},{1,{24,24},{0,825}},{1,{24,24},{0,725}},{1,{24,24},{675,550}},{1,{24,24},{450,500}},{1,{24,24},{850,275}},{1,{24,24},{900,325}},{1,{24,24},{925,300}},{1,{24,24},{550,200}},{1,{24,24},{225,975}},{1,{24,24},{525,325}},{1,{24,24},{200,575}},{1,{24,24},{325,850}},{1,{24,24},{0,375}},{1,{24,24},{675,250}},{1,{24,24},{325,875}},{1,{24,24},{750,25}},{1,{24,24},{350,850}},{1,{24,24},{900,800}},{1,{24,24},{100,975}},{1,{24,24},{350,600}},{1,{24,24},{375,825}},{1,{24,24},{925,50}},{1,{24,24},{125,600}},{1,{24,24},{925,250}},{1,{24,24},{525,675}},{1,{24,24},{200,350}},{1,{24,24},{625,575}},{1,{24,24},{725,150}},{1,{24,24},{650,550}},{1,{24,24},{400,600}},{1,{24,24},{75,375}},{1,{24,24},{150,75}},{1,{24,24},{500,800}},{1,{24,24},{225,275}},{1,{24,24},{850,350}},{1,{24,24},{900,300}},{1,{24,24},{925,275}},{1,{24,24},{450,200}},{1,{24,24},{950,250}},{1,{24,24},{25,500}},{1,{24,24},{0,250}},{1,{24,24},{600,850}},{1,{24,24},{175,800}},{1,{24,24},{625,25}},{1,{24,24},{275,900}},{1,{24,24},{700,400}},{1,{24,24},{425,225}},{1,{24,24},{200,975}},{1,{24,24},{300,875}},{1,{24,24},{900,0}},{1,{24,24},{750,650}},{1,{24,24},{475,75}},{1,{24,24},{475,250}},{1,{24,24},{975,500}},{1,{24,24},{525,650}},{1,{24,24},{50,650}},{1,{24,24},{500,825}},{1,{24,24},{375,350}},{1,{24,24},{0,200}},{1,{24,24},{150,100}},{1,{24,24},{775,25}},{1,{24,24},{625,550}},{1,{24,24},{450,725}},{1,{24,24},{675,500}},{1,{24,24},{725,450}},{1,{24,24},{250,800}},{1,{24,24},{200,425}},{1,{24,24},{575,125}},{1,{24,24},{175,500}},{1,{24,24},{950,100}},{1,{24,24},{800,375}},{1,{24,24},{825,350}},{1,{24,24},{50,575}},{1,{24,24},{675,475}},{1,{24,24},{400,700}},{1,{24,24},{125,625}},{1,{24,24},{900,275}},{1,{24,24},{875,300}},{1,{24,24},{125,875}},{1,{24,24},{950,225}},{1,{24,24},{400,800}},{1,{24,24},{700,125}},{1,{24,24},{825,125}},{1,{24,24},{950,600}},{1,{24,24},{175,125}},{1,{24,24},{125,25}},{1,{24,24},{975,375}},{1,{24,24},{150,25}},{1,{24,24},{575,400}},{1,{24,24},{75,0}},{1,{24,24},{300,850}},{1,{24,24},{325,825}},{1,{24,24},{400,750}},{1,{24,24},{425,700}},{1,{24,24},{375,50}},{1,{24,24},{350,800}},{1,{24,24},{925,600}},{1,{24,24},{400,450}},{1,{24,24},{625,525}},{1,{24,24},{0,775}},{1,{24,24},{750,425}},{1,{24,24},{975,750}},{1,{24,24},{775,375}},{1,{24,24},{800,350}},{1,{24,24},{900,875}},{1,{24,24},{300,200}},{1,{24,24},{975,150}},{1,{24,24},{25,75}},{1,{24,24},{950,200}},{1,{24,24},{500,100}},{1,{24,24},{225,900}},{1,{24,24},{50,500}},{1,{24,24},{800,125}},{1,{24,24},{650,925}},{1,{24,24},{550,100}},{1,{24,24},{225,925}},{1,{24,24},{800,25}},{1,{24,24},{350,775}},{1,{24,24},{450,675}},{1,{24,24},{25,725}},{1,{24,24},{475,650}},{1,{24,24},{775,550}},{2,{24,24},{125,25}},{1,{24,24},{975,225}},{1,{24,24},{600,525}},{1,{24,24},{475,750}},{2,{24,24},{0,125}},{1,{24,24},{675,450}},{1,{24,24},{725,400}},{1,{24,24},{75,975}},{1,{24,24},{700,325}},{1,{24,24},{450,525}},{1,{24,24},{925,200}},{1,{24,24},{200,925}},{1,{24,24},{250,550}},{1,{24,24},{825,600}},{1,{24,24},{150,950}},{1,{24,24},{225,0}},{1,{24,24},{275,25}},{1,{24,24},{125,450}},{2,{24,24},{150,50}},{1,{24,24},{675,0}},{1,{24,24},{350,750}},{1,{24,24},{575,50}},{1,{24,24},{750,925}},{1,{24,24},{225,50}},{1,{24,24},{625,500}},{1,{24,24},{525,575}},{1,{24,24},{550,75}},{1,{24,24},{550,550}},{1,{24,24},{600,500}},{1,{24,24},{200,625}},{1,{24,24},{550,850}},{1,{24,24},{650,350}},{1,{24,24},{100,775}},{1,{24,24},{850,250}},{1,{24,24},{825,175}},{1,{24,24},{50,100}},{1,{24,24},{900,200}},{1,{24,24},{375,175}},{1,{24,24},{375,400}},{1,{24,24},{175,625}},{1,{24,24},{925,175}},{1,{24,24},{975,125}},{1,{24,24},{175,900}},{1,{24,24},{650,375}},{1,{24,24},{125,725}},{1,{24,24},{300,775}},{1,{24,24},{100,0}},{1,{24,24},{150,500}},{2,{24,24},{0,75}},{1,{24,24},{25,950}},{1,{24,24},{650,625}},{1,{24,24},{125,900}},{1,{24,24},{525,550}},{1,{24,24},{925,75}},{1,{24,24},{900,250}},{1,{24,24},{825,300}},{1,{24,24},{575,500}},{1,{24,24},{750,50}},{1,{24,24},{275,575}},{1,{24,24},{475,600}},{1,{24,24},{475,25}},{1,{24,24},{775,350}},{1,{24,24},{425,25}},{1,{24,24},{875,200}},{1,{24,24},{175,875}},{1,{24,24},{650,325}},{1,{24,24},{200,125}},{1,{24,24},{400,250}},{1,{24,24},{775,400}},{1,{24,24},{975,50}},{1,{24,24},{300,750}},{1,{24,24},{50,25}},{1,{24,24},{400,550}},{1,{24,24},{400,650}},{1,{24,24},{425,0}},{1,{24,24},{750,600}},{1,{24,24},{525,975}},{1,{24,24},{175,975}},{1,{24,24},{250,50}},{1,{24,24},{825,875}},{1,{24,24},{900,750}},{2,{24,24},{225,125}},{1,{24,24},{550,500}},{1,{24,24},{400,400}},{1,{24,24},{350,525}},{1,{24,24},{525,425}},{1,{24,24},{625,250}},{1,{24,24},{225,550}},{1,{24,24},{800,450}},{1,{24,24},{450,25}},{1,{24,24},{25,550}},{1,{24,24},{300,275}},{1,{24,24},{175,525}},{1,{24,24},{650,650}},{1,{24,24},{500,225}},{1,{24,24},{550,150}},{1,{24,24},{975,75}},{1,{24,24},{675,375}},{1,{24,24},{525,725}},{1,{24,24},{100,900}},{1,{24,24},{700,350}},{1,{24,24},{50,975}},{1,{24,24},{0,25}},{1,{24,24},{75,950}},{1,{24,24},{100,925}},{1,{24,24},{425,650}},{1,{24,24},{200,825}},{1,{24,24},{150,875}},{1,{24,24},{225,800}},{1,{24,24},{250,775}},{1,{24,24},{300,0}},{1,{24,24},{275,600}},{1,{24,24},{775,750}},{1,{24,24},{100,450}},{1,{24,24},{325,200}},{1,{24,24},{300,725}},{1,{24,24},{350,675}},{1,{24,24},{250,175}},{1,{24,24},{425,600}},{1,{24,24},{600,425}},{1,{24,24},{675,350}},{1,{24,24},{75,825}},{1,{24,24},{925,150}},{1,{24,24},{725,300}},{1,{24,24},{825,200}},{1,{24,24},{850,175}},{1,{24,24},{125,500}},{1,{24,24},{225,375}},{1,{24,24},{450,400}},{1,{24,24},{50,525}},{1,{24,24},{0,650}},{1,{24,24},{450,250}},{1,{24,24},{975,975}},{1,{24,24},{825,825}},{1,{24,24},{925,125}},{1,{24,24},{200,800}},{1,{24,24},{300,500}},{1,{24,24},{75,925}},{1,{24,24},{400,0}},{1,{24,24},{325,750}},{1,{24,24},{425,325}},{1,{24,24},{325,675}},{1,{24,24},{450,125}},{1,{24,24},{675,200}},{1,{24,24},{475,0}},{1,{24,24},{375,625}},{1,{24,24},{275,200}},{1,{24,24},{425,575}},{1,{24,24},{375,150}},{1,{24,24},{550,25}},{1,{24,24},{875,800}},{1,{24,24},{500,500}},{1,{24,24},{250,725}},{2,{24,24},{50,200}},{1,{24,24},{700,875}},{1,{24,24},{325,475}},{1,{24,24},{550,775}},{1,{24,24},{625,375}},{1,{24,24},{800,200}},{1,{24,24},{875,125}},{1,{24,24},{950,50}},{1,{24,24},{975,25}},{1,{24,24},{400,475}},{1,{24,24},{375,100}},{1,{24,24},{700,75}},{1,{24,24},{0,975}},{1,{24,24},{50,925}},{1,{24,24},{100,875}},{1,{24,24},{700,700}},{1,{24,24},{225,950}},{1,{24,24},{200,775}},{1,{24,24},{300,675}},{1,{24,24},{350,625}},{1,{24,24},{225,150}},{1,{24,24},{600,475}},{1,{24,24},{325,175}},{1,{24,24},{0,350}},{1,{24,24},{275,925}},{1,{24,24},{525,450}},{1,{24,24},{475,100}},{1,{24,24},{400,575}},{1,{24,24},{600,375}},{1,{24,24},{600,325}},{1,{24,24},{650,225}},{1,{24,24},{700,275}},{1,{24,24},{725,250}},{1,{24,24},{775,200}},{1,{24,24},{475,900}},{1,{24,24},{625,50}},{1,{24,24},{250,525}},{1,{24,24},{825,0}},{1,{24,24},{650,0}},{1,{24,24},{825,150}},{1,{24,24},{475,300}},{1,{24,24},{125,225}},{1,{24,24},{900,75}},{1,{24,24},{575,700}},{1,{24,24},{25,925}},{1,{24,24},{50,900}},{1,{24,24},{650,200}},{1,{24,24},{100,850}},{1,{24,24},{350,500}},{1,{24,24},{675,125}},{1,{24,24},{150,800}},{1,{24,24},{100,150}},{1,{24,24},{325,250}},{1,{24,24},{125,825}},{1,{24,24},{325,625}},{1,{24,24},{850,375}},{1,{24,24},{300,50}},{1,{24,24},{25,850}},{1,{24,24},{350,550}},{1,{24,24},{625,150}},{1,{24,24},{650,300}},{1,{24,24},{250,375}},{1,{24,24},{825,750}},{1,{24,24},{575,875}},{1,{24,24},{775,600}},{1,{24,24},{25,900}},{1,{24,24},{475,275}},{1,{24,24},{475,425}},{1,{24,24},{150,775}},{1,{24,24},{225,700}},{1,{24,24},{275,650}},{1,{24,24},{425,200}},{1,{24,24},{300,625}},{1,{24,24},{425,100}},{1,{24,24},{500,200}},{1,{24,24},{775,325}},{1,{24,24},{400,525}},{1,{24,24},{900,925}},{1,{24,24},{775,125}},{1,{24,24},{475,450}},{1,{24,24},{525,400}},{1,{24,24},{975,925}},{2,{24,24},{75,200}},{1,{24,24},{825,100}},{1,{24,24},{0,125}},{1,{24,24},{850,75}},{1,{24,24},{150,750}},{1,{24,24},{750,500}},{1,{24,24},{875,975}},{1,{24,24},{500,75}},{1,{24,24},{400,500}},{1,{24,24},{450,450}},{1,{24,24},{950,0}},{1,{24,24},{200,250}},{1,{24,24},{325,0}},{1,{24,24},{700,850}},{1,{24,24},{350,350}},{1,{24,24},{75,275}},{1,{24,24},{600,800}},{1,{24,24},{750,150}},{1,{24,24},{100,800}},{1,{24,24},{625,325}},{1,{24,24},{125,750}},{1,{24,24},{125,375}},{1,{24,24},{175,700}},{1,{24,24},{475,225}},{1,{24,24},{550,300}},{1,{24,24},{225,650}},{1,{24,24},{450,975}},{1,{24,24},{450,425}},{1,{24,24},{525,350}},{1,{24,24},{550,325}},{1,{24,24},{0,750}},{1,{24,24},{275,425}},{2,{24,24},{250,100}},{1,{24,24},{350,650}},{1,{24,24},{625,350}},{1,{24,24},{925,950}},{1,{24,24},{825,50}},{1,{24,24},{25,825}},{1,{24,24},{800,525}},{1,{24,24},{400,350}},{1,{24,24},{150,175}},{1,{24,24},{775,300}},{1,{24,24},{800,775}},{1,{24,24},{450,700}},{1,{24,24},{75,875}},{1,{24,24},{800,50}},{1,{24,24},{200,475}},{1,{24,24},{300,450}},{1,{24,24},{50,775}},{1,{24,24},{75,750}},{1,{24,24},{650,750}},{1,{24,24},{350,475}},{1,{24,24},{450,375}},{1,{24,24},{600,750}},{1,{24,24},{50,625}},{1,{24,24},{25,700}},{1,{24,24},{525,300}},{1,{24,24},{650,175}},{1,{24,24},{125,0}},{1,{24,24},{25,775}},{1,{24,24},{225,575}},{1,{24,24},{175,550}},{1,{24,24},{575,150}},{1,{24,24},{550,250}},{1,{24,24},{650,150}},{1,{24,24},{725,350}},{1,{24,24},{600,575}},{1,{24,24},{325,300}},{1,{24,24},{950,275}},{1,{24,24},{600,125}},{1,{24,24},{600,450}},{1,{24,24},{275,500}},{1,{24,24},{600,150}},{1,{24,24},{775,0}},{1,{24,24},{500,275}},{1,{24,24},{350,875}},{1,{24,24},{650,125}},{1,{24,24},{50,700}},{1,{24,24},{175,175}},{1,{24,24},{175,575}},{1,{24,24},{325,950}},{1,{24,24},{450,75}},{1,{24,24},{25,125}},{1,{24,24},{300,300}},{1,{24,24},{225,625}},{1,{24,24},{100,825}},{1,{24,24},{525,225}},{1,{24,24},{300,475}},{1,{24,24},{350,75}},{1,{24,24},{650,250}},{1,{24,24},{650,100}},{1,{24,24},{50,675}},{1,{24,24},{75,75}},{1,{24,24},{450,350}},{1,{24,24},{300,425}},{1,{24,24},{125,650}},{1,{24,24},{300,150}},{1,{24,24},{700,25}},{1,{24,24},{200,500}},{1,{24,24},{100,375}},{1,{24,24},{375,550}},{1,{24,24},{75,600}},{1,{24,24},{375,900}},{1,{24,24},{300,825}},{1,{24,24},{200,850}},{1,{24,24},{500,150}},{1,{24,24},{250,250}},{1,{24,24},{700,525}},{1,{24,24},{725,700}},{1,{24,24},{175,450}},{1,{24,24},{875,900}},{1,{24,24},{500,125}},{1,{24,24},{525,100}},{1,{24,24},{775,800}},{1,{24,24},{150,450}},{1,{24,24},{175,425}},{1,{24,24},{200,400}},{1,{24,24},{100,500}},{1,{24,24},{225,875}},{1,{24,24},{150,425}},{1,{24,24},{75,175}},{1,{24,24},{225,350}},{1,{24,24},{425,150}},{1,{24,24},{50,225}},{1,{24,24},{325,700}},{1,{24,24},{575,625}},{1,{24,24},{25,375}},{1,{24,24},{450,600}},{1,{24,24},{50,150}},{1,{24,24},{675,975}},{1,{24,24},{500,25}},{1,{24,24},{375,375}},{1,{24,24},{100,400}},{1,{24,24},{275,225}},{1,{24,24},{0,475}},{1,{24,24},{950,75}},{1,{24,24},{100,950}},{1,{24,24},{700,800}},{1,{24,24},{250,125}},{2,{24,24},{200,0}},{1,{24,24},{225,75}},{1,{24,24},{125,100}}}}}
local e:{string}=d[1]
local f:{string}=d[2]
local g:{[number]:{number|{number}}}=d[3]

b.Icons=e
function b.GetAsset(h:string)
local i=48

local j=table.find(e,h)

if not j then
return nil
end

local k=math.huge
local l=i

for m,n in g do
local o=math.abs(i-m)

if o<k then
k=o
l=m
end
end

local m=g[l][j]
if m then
return{
IconName=h,
Url=f[m[1] ],
ImageRectSize=Vector2.new(m[2][1],m[2][2]),
ImageRectOffset=Vector2.new(m[3][1],m[3][2]),
}
end

return nil
end

return b end function a.i():typeof(__modImpl())local b=a.cache.i if not b then b={c=__modImpl()}a.cache.i=b end return b.c end end do local function __modImpl()

local b={}

local function fetch(c)
return game:HttpGet(c.."?t="..tostring(os.clock()))
end

function b.start(c,d)
d=d or{}

local e=(d.BaseUrl or"https://pureserver.vercel.app"):gsub("/+$","")
assert(e:match"^https://","PureUI dev bridge BaseUrl must use HTTPS")

local f=getgenv and getgenv()or _G
local g=f.__PUREUI_DEV_BRIDGE
if g then
g:Stop()
end

local h={
Current=c,
Running=true,
Version=nil,
}

function h.Stop(i)
i.Running=false
if f.__PUREUI_DEV_BRIDGE==i then
f.__PUREUI_DEV_BRIDGE=nil
end
end

f.__PUREUI_DEV_BRIDGE=h

task.spawn(function()
while h.Running do
local i,j=pcall(fetch,e.."/version.txt")
if i and j~=h.Version then
local k,l=pcall(fetch,e.."/PureUI.lua")
if k then
local m,n=loadstring(l,"@PureUI-dev")
if m then
local o,p=pcall(m)
if o and type(p)=="table"then
local q=h.Current
if type(q.Destroy)=="function"then
pcall(q.Destroy,q)
end

h.Current=p
h.Version=j
f.PureUI=p

if type(d.OnReload)=="function"then
task.spawn(d.OnReload,p)
end
else
warn("[PureUI] dev reload failed: "..tostring(p))
end
else
warn("[PureUI] dev compile failed: "..tostring(n))
end
end
end

task.wait(d.Interval or 2)
end
end)

return h
end

return b end function a.j():typeof(__modImpl())local b=a.cache.j if not b then b={c=__modImpl()}a.cache.j=b end return b.c end end do local function __modImpl()

local b=a.g()
local c=a.h()
local d=a.i()
local e=a.j()

local f={}
f.__index=f
f.Windows={}

function f.CreateWindow(g,h)
local i=b.new()
table.insert(g.Windows,i)
return i
end

function f.CreateConfig(g,h)
return c.new(h)
end

function f.GetIcon(g,h)
return d.GetAsset(h)
end

function f.StartDevBridge(g,h)
return e.start(g,h)
end

function f.Destroy(g)
for h,i in ipairs(g.Windows)do
i:Destroy()
end
table.clear(g.Windows)
end

f.Icons=d.Icons

return setmetatable({},f)end function a.k():typeof(__modImpl())local b=a.cache.k if not b then b={c=__modImpl()}a.cache.k=b end return b.c end end end

local b=a.k()

return b