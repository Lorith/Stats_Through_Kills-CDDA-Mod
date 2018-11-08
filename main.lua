local MOD = {}
-- todo: count monsters differently so hulk isn't equal to a small blob or spore cloud
-- todo: remove .0 at end of number in stat choice

-- Configuration

-- Does the player specify the status to raise?
-- 0: randomly determined
-- 1: specify
-- 2: even distribution
local AssignStatMethod = 0

-- For even distribution method
local CurrentStatCycle = 0

-- Is this the first run?  Set on new character creation.
local FirstRun = 0

-- Do we want oops protection to avoid accidentally assigning stats?
local aoruns = 2

-- How many kills per increase to begin with?
local SetKillCount = 100

-- How many additional kills per increase
local AddKillCount = 10
-- When SetKillCount is 100 and AddKillCounter is 10
-- First increase is at 100 kills
-- The second is at the 210(110 more), the third at 330(120 more)
-- then 460(+130), 600, 750, etc

local StrUpMes = "Strength has increased"
local DexUpMes = "Dexterity has increased"
local IntUpMes = "Intelligence has increased"
local PerUpMes = "Perception has increased"




mods["StatsThroughKills"] = MOD

function MOD.on_new_player_created()
  config()
end

function MOD.on_minute_passed() -- MOD.on_day_passed()
	SetKillCount, AddKillCount, AssignStatMethod, CurrentStatCycle, FirstRun, aoruns = Mod_GetConfig()
  if FirstRun ~= 1 then config() end
	Mod_KillStat_Main()
end

function config()
  local menu = game.create_uimenu()
  menu.title = "Gain method"
  menu:addentry("Random Stat")
  menu:addentry("Choose Stat")
  menu:addentry("Equal Increase")
  menu:query(true)
  AssignStatMethod = menu.selected
  if AssignStatMethod == 1 then Menu_AntiOops() end
  Menu_Examples()
  FirstRun = 1
	Mod_KillStat_SetVar(SetKillCount, 0, 0, 0, 0, 0, SetKillCount, AddKillCount, AssignStatMethod, CurrentStatCycle, FirstRun, aoruns)
end

function Menu_AntiOops()
  local selection = 0
  local menu = game.create_uimenu()
  menu.title = "Anti-Oops checks: "..aoruns
  menu:addentry("+1")
  menu:addentry("-1")
  menu:addentry("Done")
  menu:query(true)
  selection = menu.selected
  if selection == 0 then -- +1
    aoruns = aoruns + 1
  elseif selection == 1 then -- -1
    aoruns = aoruns - 1
  end
  if aoruns < 0 then aoruns = 0 end -- we don't want negative numbers
  if selection ~= 2 then -- repeat menu until "Done" is selected
    Menu_AntiOops()
  end
end

function Menu_SetKillCount()
  local selection = 0
  local menu = game.create_uimenu()
  menu.title = "Initial Kills per Stat: "..SetKillCount
  menu:addentry("+1")
  menu:addentry("+10")
  menu:addentry("+100")
  menu:addentry("+1000")
  menu:addentry("-1")
  menu:addentry("-10")
  menu:addentry("-100")
  menu:addentry("-1000")
  menu:addentry("Done")
  menu:query(true)
  selection = menu.selected
  if selection == 0 then -- +1
    SetKillCount = SetKillCount + 1
  elseif selection == 1 then -- +10
    SetKillCount = SetKillCount + 10
  elseif selection == 2 then -- +100
    SetKillCount = SetKillCount + 100
  elseif selection == 3 then -- +1000
    SetKillCount = SetKillCount + 1000
  elseif selection == 4 then -- -1
    SetKillCount = SetKillCount - 1
  elseif selection == 5 then -- -10
    SetKillCount = SetKillCount - 10
  elseif selection == 6 then -- -100
    SetKillCount = SetKillCount - 100
  elseif selection == 7 then -- -1000
    SetKillCount = SetKillCount - 1000
  end
  if SetKillCount < 1 then SetKillCount = 1 end -- we don't want instant levelup or negative numbers
  if selection ~= 8 then -- repeat menu until "Done" is selected
    Menu_SetKillCount()
  end
end

function Menu_AddKillCount()
  local selection = 0
  local menu = game.create_uimenu()
  menu.title = "Added Kills per Stat: "..AddKillCount
  menu:addentry("+1")
  menu:addentry("+10")
  menu:addentry("+100")
  menu:addentry("+1000")
  menu:addentry("-1")
  menu:addentry("-10")
  menu:addentry("-100")
  menu:addentry("-1000")
  menu:addentry("Done")
  menu:query(true)
  selection = menu.selected
  if selection == 0 then -- +1
    AddKillCount = AddKillCount + 1
  elseif selection == 1 then -- +10
    AddKillCount = AddKillCount + 10
  elseif selection == 2 then -- +100
    AddKillCount = AddKillCount + 100
  elseif selection == 3 then -- +1000
    AddKillCount = AddKillCount + 1000
  elseif selection == 4 then -- -1
    AddKillCount = AddKillCount - 1
  elseif selection == 5 then -- -10
    AddKillCount = AddKillCount - 10
  elseif selection == 6 then -- -100
    AddKillCount = AddKillCount - 100
  elseif selection == 7 then -- -1000
    AddKillCount = AddKillCount - 1000
  end
  if AddKillCount < 0 then -- No negative numbers.
    AddKillCount = 0 
  end
  if selection ~= 8 then -- repeat menu until "Done" is selected
    Menu_AddKillCount()
  end
end

function Menu_Examples()
  local selection = 0
  local count = SetKillCount
  local menu = game.create_uimenu()
  menu.title = "Stat Addition Levels"
  menu:addentry("First stat: "..count)
  count = count + SetKillCount + AddKillCount
  menu:addentry("Second Stat: "..count)
  count = count + SetKillCount + (2 * AddKillCount)
  menu:addentry("Third Stat: "..count)
  count = count + SetKillCount + (3 * AddKillCount)
  menu:addentry("Fourth Stat: "..count)
  count = count + SetKillCount + (4 * AddKillCount)
  menu:addentry("Fifth Stat: "..count)
  menu:addentry("Change Initial Kills")
  menu:addentry("Change Added Kills")
  menu:addentry("Done")
  menu:query(true)
  selection = menu.selected
  if selection == 5 then -- change initial kills
    Menu_SetKillCount()
  elseif selection == 6 then -- changed added kills
    Menu_AddKillCount()
  end
  if selection ~= 7 then -- repeat menu until "Done" is selected
    Menu_Examples()
  end
  end
  
  function Anti_Oops()
      local nope = "Refresh"
      local okay = "Continue"
      local menu = game.create_uimenu()
      menu.title = "You have gained stats! Anti-Oops menu!"
      local correct = game.rng(0, 5)
      while correct == last_oops do correct = game.rng(0, 5) end
      for i=0, 5 do
        if i == correct then
          menu:addentry(okay)
        else
          menu:addentry(nope)
        end
      end
      menu:query(true)
      last_oops = menu.selected
      if menu.selected ~= correct then
        Anti_Oops()
      end
  end

function Mod_KillStat_Main()
	local monster_types = game.get_monster_types()
	local i = 0
	local count = 0
	for _, monster_type in ipairs(monster_types) do
		i = i + 1
		local mtype = monster_type:obj()
		count = count + g:kill_count(mtype.id) -- Get the number of target kills
	end
	
	local next_count, str_bonus, dex_bonus, int_bonus, per_bonus, pre_add = Mod_KillStat_GetVar()
	local up = 0
	while count >= next_count do
		up = up + 1
		pre_add = pre_add + AddKillCount
		next_count = next_count + SetKillCount + pre_add
	end
  	
	if up > 0 then
    if AssignStatMethod == 1 then
      local last_oops = 0 -- prevent hitting same key multiple times going through anti-oops
      local no_oops = aoruns
      while no_oops > 0 do
        Anti_Oops()
        no_oops = no_oops - 1
      end
    end
		Mod_KillStat_PlayerDownRef(str_bonus, dex_bonus, int_bonus, per_bonus)
		for i=1, up do
			local stat = 0
			if AssignStatMethod == 0 then -- random
				stat = game.rng(0,3)
			elseif AssignStatMethod == 2 then -- cycle stats
        stat = CurrentStatCycle
        CurrentStatCycle = CurrentStatCycle + 1
        if CurrentStatCycle > 3 then CurrentStatCycle = 0 end
      else -- Player selection
        local temp, temp2 = 0
				local menu = game.create_uimenu()
				menu.title = "["..i.."/"..up.."]Select stat to increase"
        temp = player.str_max + str_bonus
        temp2 = temp + 1
				menu:addentry("Strength "..temp.."->"..temp2)
        temp = player.dex_max + dex_bonus
        temp2 = temp + 1
				menu:addentry("Dexterity "..temp.."->"..temp2)
        temp = player.int_max + int_bonus
        temp2 = temp + 1
				menu:addentry("Intelligence "..temp.."->"..temp2)
        temp = player.per_max + per_bonus
        temp2 = temp + 1
				menu:addentry("Perception "..temp.."->"..temp2)
        menu:addentry("Random")
				menu:query(true)
				stat = menu.selected
        if stat == 4 then stat = game.rng(0,3) end
			end
		
			local s = ""
			if stat == 0 then
				s = StrUpMes
				 str_bonus =  str_bonus + 1
			elseif stat == 1 then
				s = DexUpMes
				 dex_bonus =  dex_bonus + 1
			elseif stat == 2 then
				s = IntUpMes
				 int_bonus =  int_bonus + 1
			elseif stat == 3 then
				s = PerUpMes
				 per_bonus =  per_bonus + 1
			end
			game.add_msg(s)
		end
	
		-- Reflected status rise result (ステータス上昇結果反映)
		Mod_KillStat_PlayerUpRef(str_bonus, dex_bonus, int_bonus, per_bonus)
		-- Save for mod
		Mod_KillStat_SetVar(next_count, str_bonus, dex_bonus, int_bonus, per_bonus, pre_add, SetKillCount, AddKillCount, AssignStatMethod, CurrentStatCycle, FirstRun, aoruns)
	end
end

function Mod_KillStat_PlayerDownRef(str, dex, int, per)
	player.str_max = player.str_max - str
	player.dex_max = player.dex_max - dex
	player.int_max = player.int_max - int
	player.per_max = player.per_max - per
end

function Mod_KillStat_PlayerUpRef(str, dex, int, per)
	player.str_max = player.str_max + str
	player.dex_max = player.dex_max + dex
	player.int_max = player.int_max + int
	player.per_max = player.per_max + per
	player:recalc_hp()
end

function Mod_KillStat_SetVar(addcount, str, dex, int, per, up, skc, akc, apc, csc, fr, aoruns)
--function Mod_KillStat_SetVar(addcount, str, dex, int, per, up, skc, akc, apc, fr, aoruns)
	player:set_value("NextKillCount", tostring(addcount)) --set_value
	player:set_value("KillStr", tostring(str))
	player:set_value("KillDex", tostring(dex))
	player:set_value("KillInt", tostring(int))
	player:set_value("KillPer", tostring(per))
	player:set_value("KillPreUp", tostring(up))
	player:set_value("KillInitial", tostring(skc))
	player:set_value("KillAdd", tostring(akc))
	player:set_value("KillAsk", tostring(apc))
	player:set_value("KillCyc", tostring(csc))
	player:set_value("KillRun", tostring(fr))
	player:set_value("KillAO", tostring(aoruns))
end

function Mod_KillStat_GetVar()
	return tonumber(player:get_value("NextKillCount")) or SetKillCount, -- get_value
		tonumber(player:get_value("KillStr")) or 0,
		tonumber(player:get_value("KillDex")) or 0,
		tonumber(player:get_value("KillInt")) or 0,
		tonumber(player:get_value("KillPer")) or 0,
		tonumber(player:get_value("KillPreUp")) or 0
end

function Mod_GetConfig()
    return tonumber(player:get_value("KillInitial")) or 100,
    tonumber(player:get_value("KillAdd")) or 10,
    tonumber(player:get_value("KillAsk")) or 0,
   tonumber(player:get_value("KillCyc")) or 0,
    tonumber(player:get_value("KillRun")) or 0,
    tonumber(player:get_value("KillAO")) or 2
end