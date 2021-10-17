
local CleliaCurves = require(script.CleliaCurves)
local SphereConfigs = {
	SegmentScale = 10,
	Radius = 500,
	TrailFlare = false,
	SegmentLength = 0.02,
	Gap = 0
}

local CleliaRatio = { -- Mess around with the proportions for cool patterns!
	Constant = 120, 
	Divisor = 250
}

local SphereObject = CleliaCurves.NewSphereObject(CleliaRatio, SphereConfigs)
CleliaCurves.DrawCurves(SphereObject)
