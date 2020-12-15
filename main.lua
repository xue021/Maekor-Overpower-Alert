
-- initialize alert frame and all subframes
local function initAlert()

	--create base frame
	MOAAlertFrame = CreateFrame("Frame", nil, UIParent)
	MOAAlertFrame:SetSize(50, 50)

	--init DummyFrame (used to move frame later)
	DummyFrame = CreateFrame("Frame", nil, UIParent)
	
	-- set initial position on first log on
	if POSX == nil or POSY == nil then
		MOAAlertFrame:SetPoint("CENTER",100, 0)
		_, _, _, POSX, POSY = MOAAlertFrame:GetPoint()		
	else -- if not first log in, load saved position from SavedVariables: POSX and POSY
		MOAAlertFrame:SetPoint("CENTER",POSX, POSY)
	end
	
	-- the base alert frame is just a black square which will work as a background (makes the cooldown timer effect look better too)
	MOAAlertFrame.texture = MOAAlertFrame:CreateTexture()
	MOAAlertFrame.texture:SetAllPoints()
	MOAAlertFrame.texture:SetColorTexture(0.0, 0.0, 0.0, 1)
	
	
	-- create overpower icon frame
	MOAAlertFrameIcon = CreateFrame("StatusBar", nil, MOAAlertFrame)
	MOAAlertFrameIcon:SetSize(50, 50)
	MOAAlertFrameIcon:SetPoint("TOP", 0, 0)
	MOAAlertFrameIcon.texture = MOAAlertFrameIcon:CreateTexture()
	MOAAlertFrameIcon.texture:SetAllPoints(true)	
	MOAAlertFrameIcon.texture:SetTexture("Interface\\Icons\\ability_meleedamage")
	

	-- this is the frame used to create the cooldown swipe / fade out animation
	MOAAlertFrameFade = CreateFrame("StatusBar", nil, MOAAlertFrameIcon)
	MOAAlertFrameFade:SetSize(50, 50)
	MOAAlertFrameFade:SetPoint("TOP", 0, 0)
	MOAAlertFrameFade.texture = MOAAlertFrameFade:CreateTexture()
	MOAAlertFrameFade.texture:SetAllPoints(true)	
	MOAAlertFrameFade.texture:SetColorTexture(0.0, 0.0, 0.0, 0.5)
	


	-- this is the text that shows the remaning time on the current overpower window
	timerText = MOAAlertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	timerText:SetPoint("CENTER",0,-25-5)
	timerText:SetText("")


	

	MOAAlertFrame:Hide() -- hide the frame after done initializing

end


local function unlock()
	
	
	-- create dummy frame to position alert frame (initialized in init func)	
	DummyFrame:Show()
	DummyFrame:SetSize(50, 50)
	DummyFrame:SetPoint("CENTER",POSX, POSY)
	DummyFrame.texture = DummyFrame:CreateTexture()
	DummyFrame.texture:SetAllPoints()
	DummyFrame.texture:SetTexture("Interface\\Icons\\ability_meleedamage")


	-- make DummyFrame moveable and save it's position
	DummyFrame:SetMovable(true)
	DummyFrame:EnableMouse(true)
	DummyFrame:RegisterForDrag("LeftButton")
	DummyFrame:SetScript("OnDragStart", DummyFrame.StartMoving)	
	function setFramePos()
		DummyFrame:StopMovingOrSizing()
		_, _, _, POSX, POSY = DummyFrame:GetPoint() -- saves points POSX and POSY to saved variables
		
	end
	DummyFrame:SetScript("OnDragStop",setFramePos)


	-- create text to help user
	moveText = DummyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	moveText:SetPoint("TOP",0,12)
	moveText:SetText("Move me!")

	lockText = DummyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	lockText:SetPoint("BOTTOM",0,-12)
	lockText:SetText("'/moa lock' to lock")

end

local function lock()
	--MOAAlertFrame:SetMovable(false)
	DummyFrame:EnableMouse(false)
	DummyFrame:Hide()
end

-- event that is triggered after a dodge occurs
local function triggerAlert()
	

	lock()
	MOAAlertFrame:SetPoint("CENTER",POSX, POSY)

	-- show the frame
	MOAAlertFrame:Show()
	
	
	-- set a few useful variables
	local START = 0
	local END = 5
	local timer = 0
	MOAAlertFrameFade:SetMinMaxValues(START, END)

	--this is the script for the timer
	MOAAlertFrameFade:SetScript("OnUpdate", function(self, elapsed)
		timer = timer + elapsed -- add the amount of time elapsed since last update to current timer
		percDone = timer / END -- get percentage of total time elapsed 
		MOAAlertFrameFade:SetSize(50, 50*percDone) -- update the fade frame to reflect time remaining
		timerText:SetText(string.format("%.1f", END - timer))--update the timer below the alert
		
	
		
		-- when timer has reached the desired value, as defined by END (seconds), restart it by setting it to 0, as defined by START
		if timer >= END then
			timer = START -- reset timer to 0			
			MOAAlertFrame:Hide() -- hide the frame since completed
			
			
		end
	end)
	
end




-- combat log function
local eventSearchingFor = "DODGE" -- name of event to be searched for
local arr = {}
local function OnEvent(self, event)
	if(GetSpellInfo(NAME_OVERPOWER)) then -- only load if player knows the spell
		arr[1], arr[2], arr[3], arr[4],arr[5],arr[6],arr[7],arr[8],arr[9],arr[10],arr[11],arr[12],arr[13],arr[14],arr[15],arr[16],arr[17],arr[18],arr[19],arr[20] = CombatLogGetCurrentEventInfo() 
		
		-- read thru players combat log
		if arr[5] == UnitName("player") then
			
			
			

			--this will hide alert after player overpowers successfully
			if(arr[2]=="SPELL_CAST_SUCCESS" and arr[13]==NAME_OVERPOWER) then 
				MOAAlertFrame:Hide()
				
			end



			-- below works (on swings and spell)
			if arr[12]==eventSearchingFor or arr[15] == eventSearchingFor then
				triggerAlert()
				
			end
		end
		
		-- this code fades out overpower alert when overpower is still on cd
		local start, duration, enabled, _ = GetSpellCooldown(NAME_OVERPOWER)
		local opCD = start + duration - GetTime()
			if(opCD > 1.5) then
			MOAAlertFrame:SetAlpha(.2)
		else
			MOAAlertFrame:SetAlpha(1)
		end
	end


end

-- create a /command to test the alert
SLASH_MOA_TEST1 = "/moa"
SlashCmdList["MOA_TEST"] = function(msg)
	

	if(msg=="test" or msg=="t") then
		triggerAlert()
		
	elseif(msg=="unlock" or msg=="u" or msg=="ul") then
		print("Unlocking frame.")
		unlock()
	elseif(msg=="lock" or msg=="l") then
		print("Locking frame.")
		lock()
	elseif(msg=="reset") then
		print("Reseting position.")
		POSX = 100
		POSY = 0
	else 
		print("-- Maekor's Overpower Alert --")
		print("Commands:")
		print("   '/moa unlock' - unlocks frames to be moved")
		print("   '/moa lock'   - locks frame in place")
		print("   '/moa reset'  - reset the position of the alert frame")
		print("   '/moa test'   - test the alert out")
	end
   	
end 



-- created hidden frame, register it to look at combat log events, on each combat log event load OnEvent() function
local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "player")
f:SetScript("OnEvent", OnEvent)

NAME_OVERPOWER = GetSpellInfo(11585)



initAlert() -- initialize the alert frame
print("Maekor Overpower Alert loaded.")