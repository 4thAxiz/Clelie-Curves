-- @4thAxis
-- 5/26/21

local Util = {}

--------------------------------------------------------------------
--------------------------  Constants  -----------------------------
--------------------------------------------------------------------

local DefaultSettings = {
	SegmentScale = 10,
	Radius = 500,
	SegmentSize = 0.02,
	Gap = 0
}

--------------------------------------------------------------------
-------------------------  Privates  -------------------------------
--------------------------------------------------------------------

local function GetSegmentsGroup()
	local Model = workspace:FindFirstChild("PatternGroupDefault") 

	if not Model then
		Model = Instance.new("Model") 
		Model.Name = "Pattern Group Default" 
		Model.Parent = workspace
	end 

	return Model 
end


local function NewSegment(Name)
	local Segment = Instance.new("Part")

	Segment.Anchored = true
	Segment.CanCollide = false
	Segment.TopSurface = Enum.SurfaceType.Smooth
	Segment.BottomSurface = Enum.SurfaceType.Smooth
	Segment.Name = Name
	Segment.Locked = true

	return Segment
end

--------------------------------------------------------------------
------------------------- Functions  -------------------------------
--------------------------------------------------------------------

function Util.CreateSegmentAt(Name, StartPos, EndPos, SegmentData)
	if not EndPos then return end

	local Parent = SegmentData.Parent or GetSegmentsGroup()
	local SegmentScale = SegmentData.SegmentScale or 10
	local Gap = SegmentData.Gap or 0
	local Segment = Parent:FindFirstChild(Name) or NewSegment(Name)

	Segment.Size = Vector3.new(SegmentScale, SegmentScale, (StartPos - EndPos).Magnitude)
	Segment.Material = Enum.Material.Neon
	Segment.CFrame = CFrame.new( (StartPos + EndPos) / (2 + Gap), StartPos )
	Segment.Parent = Segment.Parent or Parent

	return Segment
end


function Util.PushDefaultsOn(Settings)
	if not Settings then return DefaultSettings end

	Settings.SegmentScale = Settings.SegmentScale or 10
	Settings.Radius = Settings.Radius or 500
	Settings.SegmentSize = Settings.SegmentSize or 0.02
	Settings.Gap = Settings.Gap or 0
	Settings.Parent = Settings.Parent or nil

	return Settings
end


function Util.NewParametericClelia(CleliaCurveRatio, Theta, Radius)
	Radius = Radius * math.cos(CleliaCurveRatio * Theta)

	local X = Radius * math.cos(Theta)
	local Y = Radius * math.sin(Theta)
	local Z = Radius * math.sin(CleliaCurveRatio * Theta) / math.cos(CleliaCurveRatio * Theta)

	return X, Y, Z
end


return Util
