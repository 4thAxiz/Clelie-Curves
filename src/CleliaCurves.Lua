-- @4thAxis
-- 5/26/21


local module = {}

--------------------------------------------------------------------
--------------------------  Imports  -------------------------------
--------------------------------------------------------------------

local RunService = game:GetService("RunService")
local Utils = require(script.Utils)

--------------------------------------------------------------------
-------------------------  Constants  ------------------------------
--------------------------------------------------------------------

local DefaultCleliaRatio = {
	Constant = 120, 
	Divisor = 250
}

--------------------------------------------------------------------
-------------------------  Functions  ------------------------------
--------------------------------------------------------------------

function module.NewSphereObject(CleliaRatio, SphereConstants)
	CleliaRatio = CleliaRatio or DefaultCleliaRatio	
	local Sphere = {}

	Sphere.Constants = Utils.PushDefaultsOn(SphereConstants)
	Sphere.FromCleliaCurve = CleliaRatio	
	Sphere.Segments = table.create(math.round((0.628318531 * CleliaRatio.Divisor)/Sphere.Constants.SegmentSize))

	return Sphere
end


function module.DrawCurves(Sphere)
	Sphere = Sphere or module.NewSphereObject()
	
	local Consts, CurveData = Sphere.Constants, Sphere.FromCleliaCurve
	local Size = Consts.SegmentSize
	local Curve = CurveData.Constant/CurveData.Divisor

	local CurrentSeg = 0
	local NextSeg, LastSeg, NextPos = CurrentSeg, nil, nil
	local Color = 0
	local SegmentInfo = {Parent = nil, Gap = Consts.Gap, Scale = CurveData.Scale}

	local CurrentPos, NewSeg
	for Step = 0, 0.62831853071796 * CurveData.Divisor, Consts.SegmentSize do
		SegmentInfo.Parent = SegmentInfo.Parent and LastSeg.Parent

		CurrentPos = Vector3.new(Utils.NewParametericClelia(Curve, Step, Consts.Radius))
		NewSeg = Utils.CreateSegmentAt("Segment["..CurrentSeg.."] To ["..CurrentSeg.."]", CurrentPos, NextPos, SegmentInfo)

		if NewSeg then
			NewSeg.Color = Color3.fromHSV(Color, 1, 1)
			table.insert(Sphere.Segments, NewSeg)
		end

		NextPos = CurrentPos
		NewSeg = CurrentSeg
		LastSeg = NewSeg
		CurrentSeg += 1

		Color = Color + 0.01 <= 1 and Color + 0.01 or 0
		
		if(CurrentSeg %30 == 0) then RunService.Stepped:Wait() end
	end
	
	
	return Sphere.Segments
end


function module.Rainbowify(TrailFlair, Segments)
	while RunService.Stepped:Wait() do
		for Step,Segment in ipairs(Segments or module.DrawCurves()) do
			local Hue = Color3.toHSV(Segment.Color)

			if TrailFlair then
				local Amp = math.abs(5 * math.cos(Hue * 5))*2
				Segment.Size = Vector3.new(Amp, Amp, Segment.Size.Z)
			end

			Hue = Hue + 0.05 < 1 and Hue + 0.05 or 0.001 
			Segment.Color = Color3.fromHSV(Hue, 1, 1) 
		end

	end
end


return module
