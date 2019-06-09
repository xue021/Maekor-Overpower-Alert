
-- initialize alert frame and all subframes
local function initAlert()

	--create base frame
	AlertFrame = CreateFrame("Frame", "AlertFrame", UIParent)
	AlertFrame:SetSize(50, 50)
	
	-- set initial position on first log on
	if POSX == nil or POSY == nil then
		AlertFrame:SetPoint("CENTER",100, 0)
		_, _, _, POSX, POSY = AlertFrame:GetPoint()		
	else -- if not first log in, load saved position from SavedVariables: POSX and POSY
		AlertFrame:SetPoint("CENTER",POSX, POSY)
	end
	
	-- the base alert frame is just a black square which will work as a background (makes the cooldown timer effect look better too)
	AlertFrame.texture = AlertFrame:CreateTexture()
	AlertFrame.texture:SetAllPoints()
	AlertFrame.texture:SetColorTexture(0.0, 0.0, 0.0, 1)
	
	-- create overpower icon frame
	AlertFrameIcon = CreateFrame("StatusBar", nil, AlertFrame)
	AlertFrameIcon:SetSize(50, 50)
	AlertFrameIcon:SetPoint("TOP", 0, 0)
	AlertFrameIcon.texture = AlertFrameIcon:CreateTexture()
	AlertFrameIcon.texture:SetAllPoints(true)	
	AlertFrameIcon.texture:SetTexture("Interface\\Icons\\ability_meleedamage")

	-- this is the frame used to create the cooldown swipe / fade out animation
	AlertFrameFade = CreateFrame("StatusBar", nil, AlertFrameIcon)
	AlertFrameFade:SetSize(50, 50)
	AlertFrameFade:SetPoint("TOP", 0, 0)
	AlertFrameFade.texture = AlertFrameFade:CreateTexture()
	AlertFrameFade.texture:SetAllPoints(true)	
	AlertFrameFade.texture:SetColorTexture(0.0, 0.0, 0.0, 0.5)

	-- this is the text that shows the remaning time on the current overpower window
	timerText = AlertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	timerText:SetPoint("CENTER",0,-25-5)
	timerText:SetText("")


	-- makes the alert frame moveable 
	AlertFrame:SetMovable(true)
	AlertFrame:EnableMouse(true)
	AlertFrame:RegisterForDrag("LeftButton")
	AlertFrame:SetScript("OnDragStart", AlertFrame.StartMoving)	
	function setFramePos()
		AlertFrame:StopMovingOrSizing()
		_, _, _, POSX, POSY = AlertFrame:GetPoint() -- saves points POSX and POSY to saved variables
		
	end
	AlertFrame:SetScript("OnDragStop",setFramePos)

	AlertFrame:Hide() -- hide the frame after done initializing

end




local function triggerAlert()
	
	-- show the frame
	AlertFrame:Show()
	
	
	-- set a few useful variables
	local START = 0
	local END = 5
	local timer = 0
	AlertFrameFade:SetMinMaxValues(START, END)

	--this is the script for the timer
	AlertFrameFade:SetScript("OnUpdate", function(self, elapsed)
		timer = timer + elapsed -- add the amount of time elapsed since last update to current timer
		percDone = timer / END -- get percentage of total time elapsed 
		AlertFrameFade:SetSize(50, 50*percDone) -- update the fade frame to reflect time remaining
		timerText:SetText(string.format("%.1f", END - timer))--update the timer below the alert
		
	
		
		-- when timer has reached the desired value, as defined by END (seconds), restart it by setting it to 0, as defined by START
		if timer >= END then
			timer = START -- reset timer to 0			
			AlertFrame:Hide() -- hide the frame since completed
			
			
		end
	end)
	
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

-- create a /command to test the alert
SLASH_MOA_TEST1 = "/moa"
SlashCmdList["MOA_TEST"] = function(msg)
   triggerAlert()  
end 



-- created hidden frame, register it to look at combat log events, on each combat log event load OnEvent() function
local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "player")
f:SetScript("OnEvent", OnEvent)


print("Maekor Overpower Alert loaded.")

initAlert() -- initialize the alert frame