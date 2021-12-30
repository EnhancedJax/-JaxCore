function Initialize()
end

function start(variant, title, description, iconpath, timeout)
	local File = SKIN:GetVariable('SKINSPATH')..'#JaxCore\\Accessories\\Toast\\Main.ini'
    if variant ~= nil then variant = 'Standard' end
	if iconpath ~= nil then iconpath = '#SKINSPATH##JaxCore\\@Resources\\Images\\CoreAssets\\'..SKIN:GetVariable('Set.IconStyle')..'Logo.png' end
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Variant', variant, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Title', title, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Description', description, File)
    SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Icon', iconpath, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Timeout', timeout, File)
	SKIN:Bang('!Activateconfig', '#JaxCore\\Accessories\\Toast')
end

function GroupVar(SectionExtract, Option)
	Option = Option or 'SecVar'
	config = SectionExtract:match("(.+:).*")
	Meter = SKIN:GetMeter(config)
	GetVar = Meter:GetOption(Option, 'Error')
	return GetVar
end

function LocalVar(Section, Option)
	Meter = SKIN:GetMeter(Section)
	GetVar = Meter:GetOption(Option, 'Error')
	return GetVar
end

function returnBool(Variable, Match, ReturnStringT, ReturnStringF)

	Var = SKIN:GetVariable(Variable)

	ReturnStringT = ReturnStringT or '1'
	ReturnStringF = ReturnStringF or '0'
	if Var == Match then
		return(ReturnStringT)
	  else
		return(ReturnStringF)
	end
end

function trim(Text, Match, Replace)
	return Text:gsub(Match, Replace)
end

function processInput(EditingVar, EditedVal)
	local Valuetype = SKIN:GetMeter(EditingVar:gsub('Opacity', '')):GetOption('Type', 'Any')
	local Clamp1 = tonumber(Valuetype:match('.*|(.*)|.*'))
	local Clamp2 = tonumber(Valuetype:match('.*|.*|(.*)'))
	-- if Clamp1 == nil then Clamp1 = -100 end
	-- if Clamp2 == nil then Clamp2 = 100 end
	local SaveLocation = SKIN:GetVariable('Sec.SaveLocation')

	local function saveAndProceed()
		SKIN:Bang('!WriteKeyValue', 'Variables', EditingVar, EditedVal, SaveLocation)
		SKIN:Bang('!SetVariable', EditingVar, EditedVal)
		SKIN:Bang('!UpdateMeter', '*')
		SKIN:Bang('!Redraw')
		SKIN:Bang('!UpdateMeasure', 'Auto_Refresh:M')
	end
	
	-- ------------------------------ any / no type ----------------------------- --
	if Valuetype:match('Any') then 
		saveAndProceed()
	-- ------------------------------ integers type ----------------------------- --
	elseif Valuetype:match('Int') then
		if EditedVal:match("^%-?%d+$") ~= nil then
			if Clamp1 ~= nil then
				if tonumber(EditedVal) >= Clamp1 and tonumber(EditedVal) <= Clamp2 then 
					saveAndProceed()
				else
					start('', 'Format error', 'You can only input integers between '..Clamp1..' and '..Clamp2, '', '1000')
				end
			else
				saveAndProceed()
			end
		else
			start('', 'Format error', 'You can only input integers in this field', '', '1000')
		end
	-- ------------------------------ Num type ------------------------------ --
	elseif Valuetype:match('Num') then
		if EditedVal:match("^%-?%d+%.*%d*$") ~= nil then
			if Clamp1 ~= nil then
				if tonumber(EditedVal) >= Clamp1 and tonumber(EditedVal) <= Clamp2 then 
					saveAndProceed()
				else
					start('', 'Format error', 'You can only input numbers between '..Clamp1..' and '..Clamp2, '', '1000')
				end
			else
				saveAndProceed()
			end
		else
			start('', 'Format error', 'You can only input numbers in this field', '', '1000')
		end
	-- -------------------------------- time type ------------------------------- --
	elseif Valuetype:match('Time') then
		if EditedVal:find('^%d+[hms]%d*[hms]?%d*[hms]?') then
			saveAndProceed()
		else
			start('', 'Format error', 'You can only input time durations in this field, example: 1h20m30s', '', '1000')
		end
	-- -------------------------------- Text type ------------------------------- --
	elseif Valuetype:match('Txt') then
		if not EditedVal:find('[%d.]') then
			saveAndProceed()
		else
			start('', 'Format error', 'You can only input text in this field', '', '1000')
		end
	end
end

function startDrop(variant, handler, skin, arg1)
	local function clamp(v, minValue, maxValue)
		if v < minValue then
			return minValue
		end
		return v
	end
	local skin = skin or SKIN:GetVariable('Skin.Name')
	local File = SKIN:GetVariable('ROOTCONFIGPATH')..'Accessories\\Dropdown\\Main.ini'
	local MyMeter = SKIN:GetMeter(handler)
	local PosX = SKIN:GetX() + MyMeter:GetX()
	local PosY = SKIN:GetY() + MyMeter:GetY()
	local DimW = clamp(MyMeter:GetW(), 150, 1000)
	local scalemeasure = SKIN:GetMeasure('Set.S')
	if scalemeasure ~= nil then scale = scalemeasure:GetValue() else scale = tonumber(SKIN:GetVariable('Sec.S')) end
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.name', skin, File)
	if variant:match('\\') then
		SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Variant', variant, File)
	else
		SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Variant', 'Variants\\'..skin..variant..'.inc', File)
	end
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.S', scale, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.W', DimW, File)
	if arg1 then SKIN:Bang('!WriteKeyvalue', 'Variables', 'arg1', arg1, File) end
	SKIN:Bang('!Activateconfig', '#JaxCore\\Accessories\\Dropdown')
	SKIN:Bang('!Move', PosX, PosY, '#JaxCore\\Accessories\\Dropdown')
end

function startPopup(variant, style)
	local style = style or 'classic'
	local File = SKIN:GetVariable('ROOTCONFIGPATH')..'Accessories\\Popup\\Main.ini'
	local scale = SKIN:GetMeasure('Set.S'):GetValue()
	if variant:match('^Info:') then 
		local arg1 = tonumber(SKIN:GetMeter(variant):GetY()) - 40 * SKIN:GetMeasure('Set.S'):GetValue()
		local arg2 = SKIN:GetMeter(variant:gsub('^Info:','')):GetOption('FontSize')
		SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.arg1', arg1, File)
		SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.arg2', arg2, File)
		variant = SKIN:GetVariable('SKINSPATH')..SKIN:GetVariable('Skin.Name')..'\\Core\\Info\\'..SKIN:GetVariable('Skin.Set_Page')..'\\'..variant:gsub('^Info:','')..'.inc'
	else
		SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.arg1', variant, File)
		variant = 'Variants\\'..variant..'.inc'
	end
	if style == 'classic' then
		DimW = 400
		DimH = 500
	elseif style == 'Left' then
		DimW = 650
		DimH = 650
	elseif style == 'info' then
		DimW = tonumber(SKIN:GetMeter('ContentCOntainer'):GetW())
		DimH = tonumber(SKIN:GetMeter('ContentCOntainer'):GetH())
		PosX = SKIN:GetX() + tonumber(SKIN:GetMeter('ContentCOntainer'):GetX())
		PosY = SKIN:GetY() + tonumber(SKIN:GetMeter('ContentCOntainer'):GetY())
	end
	local PosX = PosX or SKIN:GetX() + SKIN:GetW() / 2 - DimW * scale / 2
	local PosY = PosY or SKIN:GetY() + SKIN:GetH() / 2 - DimH * scale / 2
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Variant', variant, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Style', style, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.S', scale, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.W', DimW * scale, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.H', DimH * scale, File)
	SKIN:Bang('!Activateconfig', '#JaxCore\\Accessories\\Popup')
	SKIN:Bang('!Move', PosX, PosY, '#JaxCore\\Accessories\\Popup')
end

function startBox(variant, arg1, arg2, arg3, arg4)
	local File = SKIN:GetVariable('ROOTCONFIGPATH')..'Accessories\\Box\\Main.ini'
	local scale = SKIN:GetMeasure('Set.S'):GetValue()
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Variant', variant, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.S', scale, File)
	if arg1 then SKIN:Bang('!WriteKeyvalue', 'Variables', 'arg1', arg1, File) end
	if arg2 then SKIN:Bang('!WriteKeyvalue', 'Variables', 'arg2', arg2, File) end
	if arg3 then SKIN:Bang('!WriteKeyvalue', 'Variables', 'arg3', arg3, File) end
	if arg4 then SKIN:Bang('!WriteKeyvalue', 'Variables', 'arg4', arg4, File) end
	SKIN:Bang('!DeactivateConfig', '#JaxCore\\Accessories\\Box')
	SKIN:Bang('!Activateconfig', '#JaxCore\\Accessories\\Box')
	-- SKIN:Bang('!Move', PosX, PosY, '#JaxCore\\Accessories\\Box')
end

function startSide(variant, num)
	local File = SKIN:GetVariable('ROOTCONFIGPATH')..'Accessories\\Overlay\\Main.ini'
	local scale = SKIN:GetMeasure('Set.S'):GetValue()
	local PosX = SKIN:GetX() + SKIN:GetW() - 400 * scale
	local PosY = SKIN:GetY()
	local DimH = SKIN:GetH()
	local SkinName = SKIN:GetVariable('Skin.Name')
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Variant', variant, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.S', scale, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.H', DimH, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Skin.Name', SkinName, File)
	if num ~= nil then 
		SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Num', num, File) 
	else
		SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Num', '', File) 
	end
	SKIN:Bang('!Activateconfig', '#JaxCore\\Accessories\\Overlay')
	SKIN:Bang('!Move', PosX, PosY, '#JaxCore\\Accessories\\Overlay')
end

function interactionBox(variant, arg1)
	local File = SKIN:GetVariable('ROOTCONFIGPATH')..'Accessories\\GenericInteractionBox\\Main.ini'
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Variant', variant, File)
	SKIN:Bang('!WriteKeyvalue', 'Variables', 'Sec.Arg1', arg1, File)
	SKIN:Bang('!Activateconfig', '#JaxCore\\Accessories\\GenericInteractionBox')
end