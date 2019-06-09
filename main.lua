
local inTrigger = 0

local function triggerAlert()
	inTrigger = inTrigger + 1
	
	
	
	local AlertFrame = CreateFrame("Frame", "AlertFrame1", UIParent)
	AlertFrame:SetSize(50, 50)
	
	
	if POSX == nil or POSY == nil then
		AlertFrame:SetPoint("CENTER",100, 0)
		_, _, _, POSX, POSY = AlertFrame:GetPoint()
		
	else
		AlertFrame:SetPoint("CENTER",POSX, POSY)
	end
	
	
	AlertFrame.texture = AlertFrame:CreateTexture()
	AlertFrame.texture:SetAllPoints()
	AlertFrame.texture:SetColorTexture(0.0, 0.0, 0.0, 1)
	--AlertFrame.texture:SetTexture("Interface\\Icons\\ability_meleedamage")
	
	

	local AlertFrameIcon = CreateFrame("StatusBar", nil, AlertFrame)
	AlertFrameIcon:SetSize(50, 50)
	AlertFrameIcon:SetPoint("TOP", 0, 0)
	AlertFrameIcon.texture = AlertFrameIcon:CreateTexture()
	AlertFrameIcon.texture:SetAllPoints(true)	
	AlertFrameIcon.texture:SetTexture("Interface\\Icons\\ability_meleedamage")

	-- make move able
	AlertFrame:SetMovable(true)
	AlertFrame:EnableMouse(true)
	AlertFrame:RegisterForDrag("LeftButton")
	AlertFrame:SetScript("OnDragStart", AlertFrame.StartMoving)	

	function setFramePos()
		AlertFrame:StopMovingOrSizing()
		_, _, _, POSX, POSY = AlertFrame:GetPoint()
		
	end
	AlertFrame:SetScript("OnDragStop",setFramePos)
	
	local AlertFrameFade = CreateFrame("StatusBar", nil, AlertFrameIcon)
	AlertFrameFade:SetSize(50, 50)
	AlertFrameFade:SetPoint("TOP", 0, 0)
	AlertFrameFade.texture = AlertFrameFade:CreateTexture()
	AlertFrameFade.texture:SetAllPoints(true)	
	AlertFrameFade.texture:SetColorTexture(0.0, 0.0, 0.0, 0.5)
	
	


	local timerText = AlertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	timerText:SetPoint("CENTER",0,-25-5)
	timerText:SetText("")

	
	

	-- timer and relevant time related updates to alert go here


	
	local START = 0
	local END = 5
	local timer = 0
	AlertFrameFade:SetMinMaxValues(START, END)
	AlertFrameFade:SetScript("OnUpdate", function(self, elapsed)
		
		percDone = timer / END
		AlertFrameFade:SetSize(50, 50*percDone)
		timerText:SetText(string.format("%.1f", END - timer))
		timer = timer + elapsed
		if(inTrigger > 1) then
			AlertFrame:Hide()
			
			timer = START
				
			
			
			inTrigger = inTrigger -1
		end
		
		-- when timer has reached the desired value, as defined by global END (seconds), restart it by setting it to 0, as defined by global START
		if timer >= END then
			timer = START
			
			AlertFrame:Hide()
			inTrigger = inTrigger -1
			
			
		end
	end)
	--AlertFrame:Hide()
	
	
end


-- combat log function
local function OnEvent(self, event)
	local eventSearchingFor = "DODGE" --or DODGE
	arr = {}
	arr[1], arr[2], arr[3], arr[4],arr[5],arr[6],arr[7],arr[8],arr[9],arr[10],arr[11],arr[12],arr[13],arr[14],arr[15],arr[16],arr[17],arr[18],arr[19],arr[20] = CombatLogGetCurrentEventInfo()
	
	
	if arr[5] == UnitName("player") then
	
		-- below works (on swings and spell)
		
		if arr[12]==eventSearchingFor or arr[15] == eventSearchingFor then
			--print(CombatLogGetCurrentEventInfo())
			triggerAlert()
			
		end
		
		
		
	end
	
	
end

SLASH_MOA_TEST1 = "/moa"
SlashCmdList["MOA_TEST"] = function(msg)
   --print("Testing alert.")
   triggerAlert()  
end 




local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "player")
f:SetScript("OnEvent", OnEvent)
print("Maekor Overpower Alert loaded.")