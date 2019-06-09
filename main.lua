
str = "DODGE"
x = str:find("GE")

print(x)


local function triggerAlert()
	local RedSquareTest = CreateFrame("Frame", nil, UIParent)
	RedSquareTest:SetSize(50, 50)
	RedSquareTest:SetPoint("CENTER", 0, 0)
	RedSquareTest.texture = RedSquareTest:CreateTexture(nil, "BACKGROUND")
	RedSquareTest.texture:SetAllPoints(true)
	RedSquareTest.texture:SetColorTexture(1.0, 0.0, 0.0, 0.5)
	
	C_Timer.After(3, function()RedSquareTest:Hide() end )
	
end


-- combat log addon
local function OnEvent(self, event)
	local eventSearchingFor = "DODGE" --or DODGE
	arr = {}
	arr[1], arr[2], arr[3], arr[4],arr[5],arr[6],arr[7],arr[8],arr[9],arr[10],arr[11],arr[12],arr[13],arr[14],arr[15],arr[16],arr[17],arr[18],arr[19],arr[20] = CombatLogGetCurrentEventInfo()
	--local arg1, arg2, arg3, arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20 = CombatLogGetCurrentEventInfo()
	
	
	
	
	
	if arr[5] == UnitName("player") then
	
		
	
		
		
		
		-- below works (on swings and spell)
		
		if arr[12]==eventSearchingFor or arr[15] == eventSearchingFor then
			print(CombatLogGetCurrentEventInfo())
			triggerAlert()
			
		end
		
		
		
	end
	
	
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "player")
f:SetScript("OnEvent", OnEvent)
print("hello")