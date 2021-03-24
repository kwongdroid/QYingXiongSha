module("extensions.xuexibao", package.seeall)
extension = sgs.Package("xuexibao")
sgs.LoadTranslationTable {
	 ["xuexibao"] = "英雄传奇",
}
xiajie = sgs.General(extension, "xiajie", "wu", 4)
jiabengcard = sgs.CreateSkillCard{
	name = "jiabengcard",
	target_fixed = false,
	will_throw = true,
	filter = function(self, targets, to_select)
		return to_select:objectName() ~= sgs.Self:objectName()
    end,
	on_effect = function(self, effect)
		local source = effect.from
		local dest = effect.to
		local room = source:getRoom()
        room:playSkillEffect("xiuluo",math.random(45,46))
			 local judge=sgs.JudgeStruct()
			 judge.pattern = sgs.QRegExp("(.*):(spade):(.*)")
			 judge.good = false
		     judge.reason = "jiabeng"
             judge.who = dest
             room:judge(judge)
		     if (not judge:isGood()) then
			     room:setEmotion(dest, "bad")
                 local damage=sgs.DamageStruct()
			     damage.damage=3
			     damage.nature=sgs.DamageStruct_Thunder
			     damage.chain=false
			     damage.to = effect.to
		         room:damage(damage)
			     return true
             else
			     room:setEmotion(dest, "good")
        end
	end
}
jiabengvs = sgs.CreateViewAsSkill{
	name = "jiabengvs",
	n = 0,
	view_as = function(self, cards)
	    local JBcard=jiabengcard:clone()
		JBcard:setSkillName("jiabeng")
		return JBcard
	end,
	enabled_at_play = function()
		return false
	end,
	enabled_at_response = function(self,player,pattern)
		return pattern == "@@jiabeng"
	end
}
jiabeng = sgs.CreateTriggerSkill{
	name = "jiabeng",
	frequency = sgs.Skill_NotFrequent,
	events={sgs.Dying},
	view_as_skill = jiabengvs,
	on_trigger=function(self,event,player,data)

		if event==sgs.Dying then
		local room=player:getRoom()
	    local selfplayer=room:findPlayerBySkillName("jiabeng")
		if(not room:askForSkillInvoke(selfplayer, "jiabeng")) then return false end
		if room:askForUseCard(selfplayer, "@@jiabeng", "@jiabengcard") then
            room:killPlayer(selfplayer)
            return true
		end
		return false
		end
	end
}
shenli = sgs.CreateTriggerSkill{
     name = "shenli",
     frequency = sgs.Skill_Compulsory,
     events = {sgs.Predamage},
	 on_trigger = function(self,event,player,data)
	      local damage = data:toDamage()
		  local room = player:getRoom()
		  local card = damage.card
		  if damage.from:isWounded() and damage.card:inherits("Slash") and damage.card:isRed() then
		         local log = sgs.LogMessage()
			     log.from = player
			     log.to:append(damage.to)
			     log.arg = tonumber(damage.damage)
			     log.arg2 = log.arg+1
			     room:sendLog(log)
                 room:playSkillEffect("xiuluo",math.random(47, 48))
			     damage.damage = damage.damage+1
			     data:setValue(damage)
          end
	 end
}
xiajie:addSkill(jiabeng)
xiajie:addSkill(shenli)
xiajie:addSkill("jijiang")
weizhongxian = sgs.General(extension, "weizhongxian", "shu", 3)
zhuxin_card=sgs.CreateSkillCard{
name="zhuxin_card",
target_fixed=false,
will_throw=false,
once=true,
filter=function(self,targets,to_select)
	if #targets>0 then return false end
	if to_select:isKongcheng() then return false end
    return true
end,
on_effect=function(self,effect)
  local room = effect.from:getRoom()
  local success = effect.from:pindian(effect.to, "zhuxin", self)
  if(success) then
	room:playSkillEffect("xiuluo",49)
    room:loseHp(effect.to)
    room:setPlayerFlag(effect.from,"zxused")
    return true
  else
    room:setPlayerFlag(effect.from,"zxused")
    return false
  end
end
}
zhuxin=sgs.CreateViewAsSkill{
name="zhuxin",
n=1,
view_filter=function(self, selected, to_select)
	return not  to_select:isEquipped()
end,
view_as=function(self, cards)
	if #cards==0 then return nil end
	local ZX_card=zhuxin_card:clone()
	ZX_card:addSubcard(cards[1])
	return ZX_card
end,
enabled_at_play=function()
	if  sgs.Self:getPhase()==sgs.Player_Finish then sgs.Self:getRoom():setPlayerFlag(sgs.Self,"-zxused") end
	return not sgs.Self:hasFlag("zxused")
end,
enabled_at_response=function(self,pattern)
	return false
end
}
xlianhuancard = sgs.CreateSkillCard{
	name = "xlianhuancard",
	target_fixed = ture,
	will_throw = true,
	filter = function(self, targets, to_select)
		return to_select:hasFlag("xlhused")
    end,
	on_effect = function(self, effect)
		local source = effect.from
		local dest = effect.to
		local room = source:getRoom()
        room:playSkillEffect("xiuluo",50)
                 local damage=sgs.DamageStruct()
			     damage.damage=1
			     damage.nature=sgs.DamageStruct_Thunder
			     damage.chain=false
			     damage.from=source
			     damage.to = effect.to
		         room:damage(damage)
                 room:setPlayerFlag(effect.to,"-xlhused")
        end
}
xlianhuanvs=sgs.CreateViewAsSkill{
name="xlianhuanvs",
n=1,
view_filter=function(self, selected, to_select)
	return not to_select:isEquipped()
end,
view_as=function(self, cards)
	if #cards==1 then
	local LHcard=xlianhuancard:clone()
	LHcard:addSubcard(cards[1])
    LHcard:setSkillName(self:objectName())
	return LHcard
	end
end,
enabled_at_play=function()
	return true
end,
enabled_at_response = function(self,player,pattern)
	return pattern == "@@xlianhuan"
	end
}
xlianhuan = sgs.CreateTriggerSkill{
	name = "xlianhuan",
	frequency = sgs.Skill_NotFrequent,
	events={sgs.Damage},
	view_as_skill = xlianhuanvs,
	on_trigger=function(self,event,player,data)
	    local room=player:getRoom()
	   	local damage = data:toDamage()
		if not damage.card:inherits("Slash") then return false end
        if damage.to:isDead() then return false end
          room:setPlayerFlag(damage.to,"xlhused")
		  if( room:askForSkillInvoke(player, "xlianhuan") and  room:askForUseCard(player, "@@xlianhuan", "@xlianhuancard") ) then
		     return true
		  end
		  room:setPlayerFlag(damage.to,"-xlhused")
		  return false
		  end
}
weizhongxian:addSkill(zhuxin)
weizhongxian:addSkill(xlianhuan)
gaoqiu = sgs.General(extension, "gaoqiu", "shu", 3)
zhuanquan = sgs.CreateProhibitSkill{
	name = "zhuanquan",
	is_prohibited = function(self, from, to, card)
		if(to:hasSkill("zhuanquan")) and (to:getArmor()==nil) then
			return card:inherits("Slash") and card:isBlack()
		end
	end,
}
duji_card=sgs.CreateSkillCard{
name="duji_card",
target_fixed=false,
will_throw=true,
filter=function(self,targets,to_select)
	return (#targets==0) and to_select:getMark("@duji")==0
end,
on_use=function(self,room,source,targets)
	local selfplayer=source
	room:throwCard(self)
	room:playSkillEffect("renshu",1)
	targets[1]:gainMark("@duji")
end,

}
dujivs=sgs.CreateViewAsSkill{
name="dujivs",
n=1,
view_filter=function(self, selected, to_select)
	return not to_select:isEquipped() and  to_select:isRed()
end,
view_as=function(self, cards)
	if #cards~=1 then return nil end
	local DJcard=duji_card:clone()
	for var=1,#cards,1 do
		DJcard:addSubcard(cards[var])
	end
	DJcard:setSkillName(self:objectName())
	return DJcard
end,
enabled_at_play=function()
	return true
end,
enabled_at_response=function(self, player, pattern)
	return false
end
}
duji=sgs.CreateTriggerSkill{
name="duji",
view_as_skill=dujivs,
events={sgs.PhaseChange},
frequency = sgs.Skill_NotFrequent,
can_trigger=function(self, player)
	local room=player:getRoom()
	local selfplayer=room:findPlayerBySkillName(self:objectName())
	if selfplayer==nil then return false end
	return selfplayer and selfplayer:isAlive()
    end,
on_trigger=function(self,event,player,data)
	local room=player:getRoom()
	local selfplayer=room:findPlayerBySkillName(self:objectName())
	local otherplayers=room:getOtherPlayers(selfplayer)
	if event==sgs.PhaseChange then
		if player:getMark("@duji")~=1 then return false end
		if player:getPhase()==sgs.Player_Start then
			local judge=sgs.JudgeStruct()
			judge.pattern=sgs.QRegExp("(.*):(heart|diamond):(.*)")
			judge.who=player
			judge.reason=self:objectName()
			room:judge(judge)
			if   judge:isGood() then
			     room:setEmotion(player, "good")
                 local damage=sgs.DamageStruct()
			     damage.damage=1
			     damage.nature=sgs.DamageStruct_Thunder
			     damage.chain=false
			     damage.from=selfplayer
			     damage.to = player
		         room:damage(damage)
                 player:loseMark("@duji")
                 room:playSkillEffect("renshu",1)
            else
			     room:setEmotion(player, "bad")
				 player:loseMark("@duji")
        	     end
	        end
        end
	end
}
gaoqiu:addSkill(zhuanquan)
gaoqiu:addSkill(duji)
xmh = sgs.General(extension, "xmh", "wu", 4)
xzhengcard = sgs.CreateSkillCard{ 
	name = "xzhengcard",
	handling_method = sgs.Card_MethodDiscard,
	target_fixed = true,
	on_use = function(self, room, source, targets)
	    room:throwCard(self)
		room:playSkillEffect("xiuluo",8)	
		local sp = source
		local playernos = room: getOtherPlayers(sp)
		local card = sgs.Sanguosha:getCard(self:getSubcards():first())
		local cardsuit = card:getSuitString()				
		for _,p in sgs.qlist(playernos) do
			if not room:askForCard(p, ".|"..cardsuit.."|.|hand", "@xzheng") then 
             room:loseHp(p,1)			
			end	
		end	
	end,
}
xzheng = sgs.CreateViewAsSkill{
	name = "xzheng",
	n = 2, 
	view_filter = function(self, selected, to_select)
        if #selected == 0 then return not sgs.Self:isJilei(to_select) end 
        if #selected == 1 then
            local cc = selected[1]:getSuit()
            return (not sgs.Self:isJilei(to_select)) and to_select:getSuit() == cc
        else 
			return false
        end        
	end,
	view_as = function(self, cards)
        if #cards ~= 2 then return nil end        
		local xzhcard = xzhengcard:clone()
        for var = 1, #cards do xzhcard:addSubcard(cards[var]) end	
        xzhcard:setSkillName(self:objectName())		
        return xzhcard
	end,
	enabled_at_play = function(self, player)
        return player:getCardCount(true) > 1
	end
}
xnman = sgs.CreateTriggerSkill{
	    name = "#xnman",
	    events = {sgs.Damage},
	    frequency = sgs.Skill_Compulsory,	
	    on_trigger = function(self,event,player,data)
                if event==sgs.Damage then 	
			        local room = player:getRoom()			      
				    local damage = data:toDamage()					
				    local player=room:findPlayerBySkillName(self:objectName())
                    if not damage.card:inherits("Slash") then return false end
				    if damage.from and (damage.from:objectName() == player:objectName()) then
                        local count = damage.to:getMark("@xnman")						
                        if count > 0 then return false end						
                        damage.to:gainMark("@xnman")
                       room:playSkillEffect("xiuluo",9)						
                        end 
					end
                end					
}
xnman_buff = sgs.CreateTriggerSkill{
    name = "xnman_buff",
    events = {sgs.PhaseChange},
    frequency = sgs.Skill_Compulsory,   
	can_trigger=function(self, player)
	    local room=player:getRoom()
	    local mh=room:findPlayerBySkillName("xnman_buff")
	    if mh==nil then return false end
	    return mh:isAlive()
    end,
    on_trigger=function(self,event,player,data)                    					
	    if event==sgs.PhaseChange then
            local room=player:getRoom()	
	        local mh=room:findPlayerBySkillName("xnman_buff")
	        local otherplayers=room:getOtherPlayers(mh)            			
	        if player:getMark("@xnman")~=1 then return false end	        	 
            if player:getPhase()==sgs.Player_Draw then					
			                room:playSkillEffect("xiuluo",9)				
                            player:loseMark("@xnman")                             
							local log1=sgs.LogMessage()
				            log1.type="$xnman_buff"
				            room:sendLog(log1)														 
                            return true                        									                                                                                        							                	           				                        
		    end                       
			if player:getPhase()==sgs.Player_Finish then
			                player:loseMark("@xnman") 
		    end			
        end			 
    end		
}      		
xmh:addSkill(xzheng)
xmh:addSkill(xnman)
xmh:addSkill(xnman_buff)
xzhurong = sgs.General(extension, "xzhurong", "shu", 4, false)
huoshen=sgs.CreateTriggerSkill{
	name="huoshen",
	frequency=sgs.Skill_Compulsory,
	events={sgs.CardEffected,sgs.Predamage,sgs.Damage},
	can_trigger = function(self, player)
	    return player:hasSkill("huoshen")
    end,
	on_trigger=function(self,event,player,data)
	    if event==sgs.CardEffected then
		   local card=data:toCardEffect().card
		   local room=player:getRoom()
		   if player:getHp()<4 then return end
		   if not (card:inherits("SavageAssault") or card:inherits("ArcheryAttack") ) then return false end
		   room:playSkillEffect("renshu",2)
		   local log1=sgs.LogMessage()
		   log1.type="$huoshen"
		   log1.from=player
		   room:sendLog(log1)
		   return true
	    end
        if event==sgs.Predamage then
           local room = player:getRoom()
	       local damage = data:toDamage()
		   local card = damage.card
		   if player:getHp()~=3 then return end
		   if not (damage.card:inherits("Slash") or damage.card:inherits("Duel")) then return false end
		         local log = sgs.LogMessage()
			     log.from = player
			     log.to:append(damage.to)
			     log.arg = tonumber(damage.damage)
			     log.arg2 = log.arg+1
			     room:sendLog(log)
                 room:playSkillEffect("renshu",3)
			     damage.damage = damage.damage+1
			     data:setValue(damage)
        end
        if event==sgs.Damage then
		   local room = player:getRoom()
		   local ziji = room:findPlayerBySkillName("huoshen")
	       if ziji == nil then return false end
		   if player:getHp()~=1 then return end
		   if ziji:getPhase()==sgs.Player_NotActive then return false end
		   local damage = data:toDamage()
		   local source = damage.from
           local target = damage.to
           if target~=ziji then
		         local recover = sgs.RecoverStruct()
		         recover.recover = 1
		         recover.who = ziji
		         room:recover(ziji,recover)
			     room:playSkillEffect("renshu",4)
	        end

        end
	end
}
huoshen1=sgs.CreateProhibitSkill{
 name = "#huoshen1",
 is_prohibited=function(self,from,to,card)
  if  (from:getPhase()~=sgs.Player_NotActive) and (to:hasSkill("#huoshen1")) and (to:getHp()==2)  then
   return  card:inherits("Slash")
  end
 end,
}
xzhurong:addSkill(huoshen)
xzhurong:addSkill(huoshen1)
-- equipmaker = sgs.General(extension, "equipmaker", "qun", 3, true, true,true)	
-- fenji_sword=sgs.Weapon(sgs.Card_Spade,5,5)
-- fenji_sword:setObjectName("fenji_sword")
-- fenji_sword:setParent(extension)
-- fenglaiqin=sgs.Armor(sgs.Card_Spade,6)
-- fenglaiqin:setObjectName("fenglaiqin")
-- fenglaiqin:setParent(extension)
-- local function causeDamage(from, to, num, nature, card)
	-- local damage = sgs.DamageStruct()
	-- damage.from = from
	-- damage.to = to
	-- if num then
		-- damage.damage = num
	-- else
		-- damage.damage = 1
	-- end
	-- if nature then
		-- if nature == "normal" then
			-- damage.nature = sgs.DamageStruct_Normal
		-- elseif nature == "fire" then
			-- damage.nature = sgs.DamageStruct_Fire
		-- elseif nature == "thunder" then
			-- damage.nature = sgs.DamageStruct_Thunder
		-- end
	-- else
		-- damage.nature = sgs.DamageStruct_Normal
	-- end
	-- if card then
		-- damage.card = card
	-- end
	-- local room = from:getRoom()
	-- room:damage(damage)
-- end
-- fenjiskillcard = sgs.CreateSkillCard{
        -- name = "fenjiskillcard",
        -- will_throw = false,
        -- target_fixed = false,
        -- filter = function(self, targets, to_select)
                -- if #targets>0 then return false end
                -- if to_select:objectName()==sgs.Self:objectName() then return false end
                        -- return true
        -- end,
        -- on_use = function(self, room, source, targets)
                -- room:moveCardTo(self, targets[1], sgs.Player_Equip, true)
                -- source:drawCards(1)
        -- end,
-- }
-- fenjiskillvs = sgs.CreateViewAsSkill{
        -- name = "fenjiskillvs",
        -- n = 1,
        -- view_filter = function(self, selected, to_select)
                -- return to_select:objectName() == "fenji_sword"
        -- end,
        -- view_as = function(self, cards)
                -- if #cards ~= 1 then return nil end
                -- local acard = fenjiskillcard:clone()
                -- for _,card in ipairs(cards) do
                        -- acard:addSubcard(card:getId())
                -- end
                -- return acard
        -- end,
        -- enabled_at_play = function()
                -- return true
        -- end,
        -- enabled_at_response = function(self, player, pattern)
                -- return false
        -- end,
-- }
-- fenjiskill=sgs.CreateTriggerSkill{
	-- name = "#fenjiskill",
	-- events = {sgs.Dying,sgs.AskForPeachesDone},
	-- priority = 11,
	-- can_trigger=function(self,player)
		-- return true
	-- end,
	-- on_trigger=function(self,event,player,data)
		-- local room = player:getRoom()
		-- local dying = data:toDying()
		-- local current = room:getCurrent()
		-- if event == sgs.Dying and dying.damage.from:objectName() == current:objectName() and (  dying.damage.card and  (dying.damage.card:inherits("Slash") or  dying.damage.card:inherits("Duel"))) and current:getWeapon():objectName()=="fenji_sword" and not current:hasSkill("wansha") and not current:hasSkill("LUAWanSha") and room:askForSkillInvoke(current, self:objectName(), data) then
		   -- room:acquireSkill(current,"LUAWanSha")
		-- elseif event == sgs.AskForPeachesDone and current:getGeneralName() ~= "jiaxu" and current:getGeneralName() ~= "sp_jiaxu" then
		   -- room:detachSkillFromPlayer(current,"LUAWanSha")
		-- end
	-- end,
-- }
-- texiao = sgs.CreateTriggerSkill{
-- name = "#texiao",		
-- events={sgs.CardUsed},
-- frequency = sgs.Skill_Compulsory,
-- priority=1,
-- can_trigger=function() 
-- return true
-- end,
-- on_trigger=function(self,event,player,data)	  
-- local room=player:getRoom()	
-- if event==sgs.CardUsed then 
-- local use=data:toCardUse()    		            
-- if use.card:inherits("Snatch") then				
-- room:setEmotion(player,"snatch")
-- end
-- if use.card:inherits("Dismantlement") then				    
-- room:setEmotion(player,"dismantlement")
-- end
-- if use.card:inherits("Collateral") then				    
-- room:setEmotion(player,"collateral")
-- end
-- if use.card:inherits("ArcheryAttack") then                    				
-- room:setEmotion(player,"archeryattack")
-- end           				
-- if use.card:inherits("SavageAssault") then                   				
-- room:setEmotion(player,"savageassault")
-- end
-- if use.card:objectName()=="nieying" or use.card:objectName()=="zhuifeng"  or use.card:objectName()=="huleibo"  or use.card:objectName()=="yushizi" or use.card:objectName()=="hualiu" or use.card:objectName()=="jueying" or use.card:objectName()=="zhuahuangfeidian" then                   			
-- room:setEmotion(player,"fangyuma")
-- end		
-- if use.card:objectName()=="chitu" or use.card:objectName()=="dilu" or use.card:objectName()=="wuzhui" or use.card:objectName()=="dawan" or use.card:objectName()=="dayuan"  or use.card:objectName()=="zixing"  then                    				
-- room:setEmotion(player,"jingongma")
-- end										
-- if use.card:inherits("Nullification") then                  			
-- room:setEmotion(player,"nullification")
-- end       			
-- if use.card:inherits("Lightning") then                  			
-- room:setEmotion(player,"lightning")
-- end       			
-- if use.card:inherits("AmazingGrace") then                  			
-- room:setEmotion(player,"amazinggrace")
-- end                     
-- if use.card:inherits("GodSalvation") then                  			
-- room:setEmotion(player,"godsalvation")
-- end   						
-- if use.card:inherits("ExNihilo") then                  			
-- room:setEmotion(player,"exnihilo")
-- end   												
-- if use.card:inherits("Indulgence") then                  			
-- room:setEmotion(player,"indulgence")
-- end 										    			
-- if use.card:inherits("Crossbow") then                   			
-- room:setEmotion(player,"hufuskill")
-- end		
-- if use.card:inherits("Axe") then                   			
-- room:setEmotion(player,"axeskill")
-- end	
-- if use.card:inherits("Blade") then                   			
-- room:setEmotion(player,"bladeskill")
-- end
-- if use.card:inherits("EightDiagram") then                   			
-- room:setEmotion(player,"eightdiagramskill")
-- end								
-- if use.card:inherits("Halberd") then                   			
-- room:setEmotion(player,"halberdskill")
-- end
-- if use.card:inherits("IceSword") then                   			
-- room:setEmotion(player,"iceswordskill")
-- end	        	
-- if use.card:inherits("KylinBow") then                   			
-- room:setEmotion(player,"kylinbowskill")
-- end											
-- if use.card:inherits("QinggangSword") then                   			
-- room:setEmotion(player,"qinggangswordskill")
-- end							
-- if use.card:inherits("Spear") then                   			
-- room:setEmotion(player,"spearskill")
-- end	
-- if use.card:inherits("Geanguanhuo") then                   			
-- room:setEmotion(player,"geanguanhuo")
-- end	
-- if use.card:inherits("Toulianghuanzhu") then                   			
-- room:setEmotion(player,"toulianghuanzhu")
-- end	
-- end
-- end		
-- }
-- LUAWanSha=sgs.CreateTriggerSkill{
	-- name="LUAWanSha",
	-- events=sgs.AskForPeaches,
	-- frequency=sgs.Skill_Compulsory,
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
		-- local current=room:getCurrent()
		-- if current:isAlive() and current:hasSkill("LUAWanSha") then
			-- local dying=data:toDying()
			-- local who=dying.who
			-- return not (player:getSeat()==current:getSeat() or player:getSeat()==who:getSeat())
		-- end
	-- end,
	-- can_trigger=function(self,player)
		-- return player and player:isAlive()
	-- end,
-- }
-- fenjiinvoke=sgs.CreateTriggerSkill{
	-- name = "#fenjiinvoke",
	-- events = {sgs.GameStart},
	-- on_trigger=function(self,event,player,data)
		-- local room = player:getRoom()
		-- room:attachSkillToPlayer(player,"fenjiskillvs")
	-- end,
-- }
-- fenglaiqinskill = sgs.CreateTriggerSkill{
	-- name = "#fenglaiqinskill",
	-- events = {sgs.CardLost},
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local move = data:toCardMove()
		-- local cd = sgs.Sanguosha:getCard(move.card_id)
		-- if move.from_place == sgs.Player_Equip and cd:objectName() == "fenglaiqin" and room:askForSkillInvoke(player, self:objectName(), data) then
		    -- local tos = sgs.SPlayerList()
			-- local list = room:getOtherPlayers(player)
			-- for _,p in sgs.qlist(list) do
			-- if not p:isProhibited(p, sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)) then
			-- tos:append(p)
			-- end
			-- end
			-- local target = room:askForPlayerChosen(player, tos, self:objectName())
			-- if target then
			-- local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
                -- slash:setSkillName(self:objectName())
                -- local use = sgs.CardUseStruct()
                -- use.from = player
                -- use.to:append(target)                                                        
                -- use.card = slash
                -- room:useCard(use,false)
			-- end
		-- end
	-- end,
-- }
-- fenglaiqin2skill = sgs.CreateTriggerSkill{
	-- name = "#fenglaiqin2skill",
	-- events = sgs.SlashEffected,
	-- frequency = sgs.Skill_Compulsory,	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()	
		-- local effect = data:toSlashEffect()
		-- if effect.slash:inherits("Slash")  and effect.to:objectName()==player:objectName() and player:hasArmorEffect("fenglaiqin") then
			-- local log = sgs.LogMessage()
			-- log.type = "#fenglaiqin_msg"
			-- log.from = player
			-- log.arg  = "fenglaiqin"
			-- room:sendLog(log)
			-- room:playSkillEffect("fenglaiqin")
			-- return true
		-- end
		-- return false		
	-- end,
-- }
-- tianlangbuff=sgs.CreateTriggerSkill{
 -- name = "#tianlangbuff",
 -- frequency = sgs.Skill_Compulsory,
 -- events = {sgs.SlashProceed},
 -- can_trigger = function(self, player)
	-- return player:hasSkill("paoxiao")	      
 -- end,
 -- on_trigger=function(self,event,player,data)
    -- local room = player:getRoom()
    -- if event==sgs.SlashProceed then   
        -- room:setEmotion(player,"paoxiao")  
    -- end
 -- end
-- }
-- bingshengff=sgs.CreateTriggerSkill{
 -- name = "#bingshengff",
 -- frequency = sgs.Skill_Compulsory,
 -- events = {sgs.PhaseChange},
 -- can_trigger = function(self, player)
	-- return player:hasSkill("bingsheng")	      
 -- end,
 -- on_trigger=function(self,event,player,data)
    -- local room = player:getRoom() 
	-- if event == sgs.PhaseChange and player:getPhase()==sgs.Player_Discard then  
        -- room:setEmotion(player,"bingsheng")  
    -- end
 -- end
-- }
-- qingminbuff=sgs.CreateTriggerSkill{
 -- name = "#qingminbuff",
 -- events = {sgs.CardEffected},
 -- can_trigger=function(self,player)
    -- return true 
 -- end,
 -- on_trigger=function(self,event,player,data)
    -- local room = player:getRoom()	
	-- local sq = room:findPlayerBySkillName("qingmin")	
    -- if event == sgs.CardEffected then
    -- if not (sq) then return end	 	
	-- local effect = data:toCardEffect()
        -- if effect.card:inherits("Snatch") and not effect.from:hasSkill("qingmin") then 	
        -- room:setEmotion(sq,"qingmin")
        -- room:playSkillEffect("shentou",1)		
        -- end
	-- end
 -- end
-- }
-- weimubuff=sgs.CreateTriggerSkill{
 -- name = "#weimubuff",
 -- events = {sgs.CardEffected},
 -- can_trigger=function(self,player)
    -- return true 
 -- end,
 -- on_trigger=function(self,event,player,data)
    -- local room = player:getRoom()
	-- local zg = room:findPlayerBySkillName("weimu")	
    -- if event == sgs.CardEffected then 
    -- if not (zg) then return end	
	-- local effect = data:toCardEffect()	
        -- if (effect.card:inherits("SavageAssault") or effect.card:inherits("ArcheryAttack")) and effect.card:getSuit()== sgs.Card_Spade and not effect.from:hasSkill("weimu") and not zg:hasFlag("RMLluansheing") then
        -- room:setEmotion(zg,"weimu")  
		-- room:setPlayerFlag(zg,"RMLluansheing")
        -- end
    -- end
 -- end
-- }
-- equipmaker:addSkill(fenjiskill)
-- equipmaker:addSkill(fenjiskillvs)
-- equipmaker:addSkill(fenjiinvoke)
-- equipmaker:addSkill(tianlangbuff)
-- equipmaker:addSkill(bingshengff)
-- equipmaker:addSkill(LUAWanSha)
-- equipmaker:addSkill(qingminbuff)
-- equipmaker:addSkill(weimubuff)
-- equipmaker:addSkill(fenglaiqinskill)
-- equipmaker:addSkill(texiao)
-- equipmaker:addSkill(fenglaiqin2skill)
-- local generalnames=sgs.Sanguosha:getLimitedGeneralNames()
-- local hidden={"sp_diaochan","sp_sunshangxiang","sp_pangde","sp_caiwenji","sp_machao","sp_jiaxu","anjiang","shenlvbu1","shenlvbu2"}
-- table.insertTable(generalnames,hidden)
-- for _, generalname in ipairs(generalnames) do
	-- local general = sgs.Sanguosha:getGeneral(generalname)
	-- if general then		
		-- general:addSkill("#fenjiinvoke")
		-- general:addSkill("#texiao") 
		-- general:addSkill("#fenjiskill")	
		-- general:addSkill("#tianlangbuff")  
        -- general:addSkill("#bingshengff")	
        -- general:addSkill("#fenglaiqinskill")
		-- general:addSkill("#qingminbuff")
		-- general:addSkill("#weimubuff")		
		-- general:addSkill("#fenglaiqin2skill")		
	-- end
-- end
liji = sgs.General(extension, "liji", "shu", 3, false)
mimou=sgs.CreateViewAsSkill{
    name="mimou",
	n=1,
	view_filter = function(self, selected, to_select)
		return to_select:getSuit() == sgs.Card_Diamond and  not to_select:isEquipped()
	end,
    view_as = function(self, cards)
	local invalid_condition=(#cards<1)
	if invalid_condition then return nil end
	local suit,number
	for _,card in ipairs(cards) do
		if suit and (suit~=card:getSuit()) then suit=sgs.Card_NoSuit else suit=card:getSuit() end
		if number and (number~=card:getNumber()) then number=-1 else number=card:getNumber() end
	end
	local view_as_card= sgs.Sanguosha:cloneCard("collateral", suit, number)
	for _,card in ipairs(cards) do
		view_as_card:addSubcard(card:getId())
	end
	view_as_card:setSkillName(self:objectName())
	return view_as_card
    end,
}
dihui = sgs.CreateTriggerSkill{
	    name = "dihui",
	    events = {sgs.Damage},
	    frequency = sgs.Skill_Compulsory,
	    on_trigger = function(self,event,player,data)
                if event==sgs.Damage then
			        local room = player:getRoom()
				    local damage = data:toDamage()
				    local player=room:findPlayerBySkillName(self:objectName())
                    if not damage.card:inherits("Slash") then return false end
				    if damage.from and (damage.from:objectName() == player:objectName()) then
                        damage.to:gainMark("@dihuivs")
		                local count = damage.to:getMark("@dihuivs")
                        if count > 1 then
					         damage.to:gainMark("@dihui")
                             return false
                             end
                        end
                    end
                end
}
dihui1 = sgs.CreateTriggerSkill{
	    name = "#dihui1",
	    events = {sgs.Damaged},
	    frequency = sgs.Skill_Compulsory,
        can_trigger = function(self, player)
	         return player:getMark("@dihui")>0
        end,
	    on_trigger = function(self,event,player,data)
                if event==sgs.Damaged then
	                local room = player:getRoom()
				    local damage = data:toDamage()
				    if not damage.card:inherits("Slash") then return false end
					if player:getMark("@dihui")~=1 then return false end
				         room:loseHp(player)
                         room:playSkillEffect("xiuluo",math.random(1, 2))
                         player:loseMark("@dihuivs",1)
                         player:loseMark("@dihui",1)
                         end
                end
}
mimoubuff=sgs.CreateTriggerSkill{
	name="#mimoubuff",
	frequency=sgs.Skill_Compulsory,
	events={sgs.CardUsed},		
	can_trigger = function(self, player)
	    return player:hasSkill("#mimoubuff")	      
    end,		
	on_trigger=function(self,event,player,data)
	local room=player:getRoom()
	local skillowner=room:findPlayerBySkillName(self:objectName())
	if event==sgs.CardUsed then
		local use=data:toCardUse()
		local card = use.card			
		if card:getSkillName()=="mimou" then
		room:getThread():delay(600)
        room:playSkillEffect("xiuluo",math.random(29, 30))   
        end							
    end
end
}
liji:addSkill(mimoubuff)
liji:addSkill(mimou)
liji:addSkill(dihui)
liji:addSkill(dihui1)
wsgui = sgs.General(extension, "wsgui", "wu", 4)
touji=sgs.CreateTriggerSkill{
	name="#touji",
	frequency=sgs.Skill_Compulsory,
	events = {sgs.SlashEffected},
	priority=2,
	on_trigger=function(self,event,player,data)
	if event==sgs.SlashEffected then
		local effect=data:toSlashEffect()
		local room=player:getRoom()
		local count = room:alivePlayerCount()
		if count < 4 then
		    room:playSkillEffect("xiuluo",3)
		    local log=sgs.LogMessage()
		    log.type ="#touji"
		    log.arg=player:getGeneralName()
		    log.from =effect.from
		    room:sendLog(log)
			if(room:askForCard(effect.from, "slash", "@touji-discard", data)) then
				return false
			else
		end
			log.type ="#toujinodiscard"
			room:sendLog(log)
			return true
		end
		return false
	end
end,
}
toujivs = sgs.CreateTriggerSkill{
    name = "toujivs",
    frequency = sgs.Skill_Compulsory,
    events = {sgs.Predamage},
    can_trigger = function(self,player)
		return player:hasSkill("toujivs")
	end,
	on_trigger = function(self,event,player,data)
    if event==sgs.Predamage then
	    local room = player:getRoom()
        local count = room:alivePlayerCount()
		if count >= 4 then
		        local damage = data:toDamage()
		        local card = damage.card
		        if damage.card:inherits("Slash") then
		            local log = sgs.LogMessage()
			        log.from = player
			        log.to:append(damage.to)
			        log.arg = tonumber(damage.damage)
			        log.arg2 = log.arg+1
			        room:sendLog(log)
                    room:playSkillEffect("xiuluo",3)
			        damage.damage = damage.damage+1
			        data:setValue(damage)
                end
        end
	end
end,
}
wsgui:addSkill(touji)
wsgui:addSkill(toujivs)
gcg1 = sgs.General(extension, "gcg1", "shu", 4)
xyuxues = sgs.CreateTriggerSkill{
	    name = "#xyuxues",
	    events = {sgs.Damage},
	    frequency = sgs.Skill_Compulsory,
	    on_trigger = function(self,event,player,data)
                if event==sgs.Damage then
			        local room = player:getRoom()
				    local damage = data:toDamage()
				    local player=room:findPlayerBySkillName(self:objectName())
				    if damage.from and (damage.from:objectName() == player:objectName()) then
                        local count = damage.to:getMark("@yuxue")
                        if count > 0 then return false end
						damage.to:gainMark("@yuxue")
						end
					end
                end
}
xyuxue = sgs.CreateTriggerSkill{
	    name = "#xyuxue",
	    events = {sgs.Damage},
        frequency = sgs.Skill_Frequent,
	    on_trigger = function(self,event,player,data)
                if event==sgs.Damage then
			        local room = player:getRoom()
				    local damage = data:toDamage()
				    local player=room:findPlayerBySkillName(self:objectName())
				    if damage.from and (damage.from:objectName() == player:objectName()) then
                        damage.to:gainMark("@xyuxueuse")
						room:playSkillEffect("guimian", 1)
						if not damage.to:isAlive() then
                            damage.to:loseAllMarks("@yuxue")
							damage.to:loseAllMarks("@xyuxueuse")
						end
						local xcount = 0
					    local players=sgs.SPlayerList()
					    for _,p in sgs.qlist(room:getOtherPlayers(player)) do
						    if p:getMark("@xyuxueuse")>0 then
					           xcount = xcount + p:getMark("@xyuxueuse")
					        end
                            if  xcount > 0  then
						       room:setPlayerFlag(player,"xguimianuse")
							end
							if  xcount <= 0  then
							   room:setPlayerFlag(player,"-xguimianuse")
							end
						end
					end
                end
        end
}
xyuxue_buff  = sgs.CreateTriggerSkill{
	    name = "xyuxue_buff",
		events = {sgs.PhaseChange},
	    frequency = sgs.Skill_Compulsory,
        can_trigger = function(self, player)
	         return player:hasSkill("xyuxue_buff")
        end,
	    on_trigger = function(self,event,player,data)
		    if event == sgs.PhaseChange and player:getPhase()==sgs.Player_Finish then
	                local room = player:getRoom()
                    local gcg = room:findPlayerBySkillName("xyuxue_buff")
                    if not (gcg) then return end
					room:setPlayerFlag(gcg,"-xguimianuse")
					local players=sgs.SPlayerList()
					for _,p in sgs.qlist(room:getOtherPlayers(gcg)) do
						if p:getMark("@xyuxueuse")>0 then
						   p:loseAllMarks("@xyuxueuse")
						end
					local count = 0
					local players=sgs.SPlayerList()
					for _,p in sgs.qlist(room:getOtherPlayers(gcg)) do
						if p:getMark("@yuxue")>0 then
					        count = count + p:getMark("@yuxue")
					    end
                        if  count > 2  then
					        for _,p in sgs.qlist(room:getOtherPlayers(gcg)) do
			                    if p:getMark("@yuxue")>0 then
				                    room:loseHp(p,1)
									room:playSkillEffect("yuxue",1)
			                        p:loseAllMarks("@yuxue")

						        end
                            end
                        end
				    end
                end
            end
		end

}
xguimian_card=sgs.CreateSkillCard{
name="xguimian_card",
target_fixed=true,
will_throw=false,
once=false,
on_use=function(self,room,source,targets)
		local card=room:askForCard(source, "slash", "@xguimian",sgs.QVariant())
		if not card then return	end
		local sp=sgs.SPlayerList()
		for _,p in sgs.qlist(room:getOtherPlayers(source)) do
		    if p:getMark("@xyuxueuse")>0 then
            sp:append(p)
			end
		end
		local t = room:askForPlayerChosen(source, sp, "xguimian")
		room:playSkillEffect("guimian", 1)
		room:cardEffect(card,source, t)
	    end
}
xguimian=sgs.CreateViewAsSkill{
name="xguimian",
n=0,
view_filter=function(self, selected, to_select)
	return false
end,
view_as=function(self, cards)
	local acard=xguimian_card:clone()
	acard:setSkillName(self:objectName())
	return acard
end,
enabled_at_play=function()
	return sgs.Self:hasFlag("xguimianuse")
end,
enabled_at_response=function(self,pattern)
	return false
end
}
gcg1:addSkill(xguimian)
gcg1:addSkill(xyuxues)
gcg1:addSkill(xyuxue)
gcg1:addSkill(xyuxue_buff)
gcg1:addSkill("hujia")
xiaozhuang = sgs.General(extension, "xiaozhuang", "shu", 3, false)
tianming_card = sgs.CreateSkillCard{
	name = "tianming_card",
	target_fixed = false,
	will_throw = false,
	filter = function(self,targets,to_select,player)
		if(to_select:getSeat() == player:getSeat()) then return false end
	return (#targets==0) and (to_select:getMark("@tianming")==0) and (not to_select:isKongcheng())
    end,
	on_effect = function(self,effect)
		local from = effect.from
		local to = effect.to
		local room = to:getRoom()
		local card_from=room:askForExchange(from,"@tianmingskill",1)
        local card_to=room:askForExchange(to,"@tianmingskill",1)
		room:moveCardTo(card_from,nil,sgs.Player_DiscardedPile)
		room:moveCardTo(card_to,nil,sgs.Player_DiscardedPile)
		room:playSkillEffect("xiuluo",math.random(4, 5))
		if (sgs.Sanguosha:getCard(card_from:getSubcards():first()):getSuit()==sgs.Sanguosha:getCard(card_to:getSubcards():first()):getSuit()) then
			to:gainMark("@tianming")
		end
	end,
}
tianming = sgs.CreateViewAsSkill{
	name = "tianming",
	n =0,
	view_as = function()
		return tianming_card:clone()
	end,
	enabled_at_play = function()
		return true
	end,
	enabled_at_response = function()
		return false
	end
}
tianming_buff = sgs.CreateTriggerSkill{
    name = "#tianming_buff",
    events = {sgs.PhaseChange},
    frequency = sgs.Skill_Compulsory,
	can_trigger=function(self, player)
	    local room=player:getRoom()
	    local xz=room:findPlayerBySkillName("#tianming_buff")
	    if xz==nil then return false end
	    return xz:isAlive()
    end,
    on_trigger=function(self,event,player,data)
	    if event==sgs.PhaseChange then
            local room=player:getRoom()
	        local xz=room:findPlayerBySkillName("tianming_buff")
	        local otherplayers=room:getOtherPlayers(xz)
	        if player:getMark("@tianming")~=1 then return false end
            if player:getPhase()==sgs.Player_Draw then
			            	room:playSkillEffect("xiuluo",6)
                            player:loseMark("@tianming")
							local log=sgs.LogMessage()
				            log.type="$tianming_buff"
				            room:sendLog(log)
                            return true
		    end			           
			if player:getPhase()==sgs.Player_Finish then
			                player:loseMark("@tianming")
		    end
        end
    end
}
youshui_card = sgs.CreateSkillCard{
	name = "youshui_card",
	once = true,
	target_fixed = false,
	will_throw = true,
	filter=function(self,targets,to_select)
	   if #targets > 1 then return false end
	   if to_select:objectName() == sgs.Self:objectName() then return false end	
	   return true
	end,
	on_use = function(self, room, source, targets)
	    if(#targets ~= 2) then return end
        room:throwCard(self)
	    targets[1]:gainMark("@youshui_f")
	    targets[2]:gainMark("@youshui_a")
		room:playSkillEffect("xiuluo",7)
		room:setPlayerFlag(source, "youshui-used")
	end,
}
youshui = sgs.CreateViewAsSkill{
	name = "youshui",
	n =2,
	view_filter=function(self, selected, to_select)
	    return not to_select:isEquipped()
    end,
	view_as = function(self, cards)
		if(#cards ~= 2) then return nil end
		local acard = youshui_card:clone()
		acard:addSubcard(cards[1])
		acard:addSubcard(cards[2])
		acard:setSkillName(self:objectName())
		return acard
	end,
	enabled_at_play=function(self, player)
	    return not sgs.Self:hasFlag("youshui-used")
    end,
	enabled_at_response = function()
		return false
	end
}
youshuiover = sgs.CreateTriggerSkill{
	name = "#youshuiover",
	frequency = sgs.Skill_Compulsory,
	events={sgs.TurnStart,sgs.Death},
	can_trigger = function(self, player)
	    return player:hasSkill("#youshuiover")
    end,
	on_trigger = function(self, event, player, data)
	    if (event==sgs.TurnStart) then
		    local room = player:getRoom()
		    local player=room:findPlayerBySkillName(self:objectName())
			local players=sgs.SPlayerList()
					    for _,p in sgs.qlist(room:getOtherPlayers(player)) do
						    if p:getMark("@youshui_f")>0 or p:getMark("@youshui_a")>0 then
							      p:loseAllMarks("@youshui_f")
								  p:loseAllMarks("@youshui_a")
							end
						end
		end
		if (event==sgs.Death) then
		    local room = player:getRoom()
			local player=room:findPlayerBySkillName(self:objectName())
                for _,p in sgs.qlist(room:getAllPlayers()) do
                    if p:getMark("@youshui_f")>0 or p:getMark("@youshui_a")>0 then
						p:loseAllMarks("@youshui_f")
					    p:loseAllMarks("@youshui_a")
					end
				end
		end
	end,

}
youshui_buff=sgs.CreateTriggerSkill{
name="#youshui_buff",
frequency = sgs.Skill_Compulsory,
events={sgs.Damage},
can_trigger = function(self, player)
	    return player:getMark("@youshui_f")>0
end,
on_trigger=function(self,event,player,data)
		local room = player:getRoom()
		if player:getMark("@youshui_f")~=1 then return false end
		if player:getPhase()==sgs.Player_NotActive then return false end
		local damage = data:toDamage()
		    for var=1,damage.damage,1 do
		 		local players=sgs.SPlayerList()
                for _,p in sgs.qlist(room:getAllPlayers()) do
								if p:getMark("@youshui_a")>0 then
								    if p:isWounded() then
			                            local recover = sgs.RecoverStruct()
			                            recover.who = p
			                            recover.recover = 1
			                            room:recover(p,recover)
										room:playSkillEffect("xiuluo",7)
									end
								end
				end
			end
		end

}
xiaozhuang:addSkill(youshui)
xiaozhuang:addSkill(tianming)
xiaozhuang:addSkill(youshuiover)
xiaozhuang:addSkill(youshui_buff)
xiaozhuang:addSkill(tianming_buff)
miyue = sgs.General(extension, "miyue", "wu", 3, false)
youmie_card = sgs.CreateSkillCard{
	name = "youmie_card",
	target_fixed = false,
	will_throw = true,	
	filter = function(self,targets,to_select,player)
		if(to_select:getSeat() == player:getSeat())then return false end
		if not to_select:getGeneral():isMale()  then return false end			
		if player:getMark("@youmieskill")>0  then return false end 			
		return (#targets == 0) 
	end,	
	on_effect = function(self,effect)
		local from = effect.from
		local to = effect.to
		local room = to:getRoom()		
            room:playSkillEffect("xiuluo",math.random(55,56)) 	
			from:gainMark("@youmieskill")		
			to:gainMark("@youmie")		
	end,
}
youmie = sgs.CreateViewAsSkill{
	name = "youmie",
	n =0,	
	view_as = function()
		return youmie_card:clone()
	end,	
	enabled_at_play=function(self, player)
		return not player:hasUsed("#youmie_card")		
	end,	
	enabled_at_response = function()
		return false
	end
}
youmiedraw = sgs.CreateTriggerSkill{
	name = "#youmiedraw",	
	events = {sgs.DrawNCards},
	frequency = sgs.Skill_NotFrequent,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local x = data:toInt()				
		for _,p in sgs.qlist(room:getAllPlayers()) do				
		    if  p:getMark("@youmie")>0  then
                if room:askForSkillInvoke(player, "youmie", data) then				               				       				   						
			        data:setValue(x-1)
					room:playSkillEffect("xiuluo",math.random(55,56))   
				    room:loseHp(p,1)
		        end
			end
	    end
	end,
}
youmieover = sgs.CreateTriggerSkill{
	name = "#youmieover",	
	frequency = sgs.Skill_Compulsory,	
	events={sgs.Death},			
	can_trigger = function(self, player)
	    return player:getMark("@youmie")>0 or player:getMark("@youmieskill")>0       
    end,
	on_trigger = function(self, event, player, data)		    
		if (event==sgs.Death) then 
		    local room = player:getRoom()
			local player=room:findPlayerBySkillName(self:objectName())             		    
                for _,p in sgs.qlist(room:getAllPlayers()) do
                    if p:getMark("@youmieskill")>0 or p:getMark("@youmie")>0 then
						p:loseAllMarks("@youmieskill")
					    p:loseAllMarks("@youmie")
					end
				end
		end
	end,	
}
youmiebuffcard = sgs.CreateSkillCard{
	name = "youmiebuffcard"
}
youmiebuff = sgs.CreateTriggerSkill{
	name = "#youmiebuff",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Dying},
	can_trigger = function(self, player)
	    return player:getMark("@youmie")>0  
    end,	
	on_trigger = function(self, event, player, data)
		if not player:isNude() then
			local room = player:getRoom()						
		    local my = room:findPlayerBySkillName("youmiebuff")								       				
			    local alives = room:getAlivePlayers()
			    for _,my in sgs.qlist(alives) do
				    if my:isAlive() and my:hasSkill(self:objectName()) then					
						local cards = player:getCards("he")
						if cards:length() > 0 then
							local allcard = youmiebuffcard:clone()
							for _,card in sgs.qlist(cards) do
								allcard:addSubcard(card)
							end
							room:obtainCard(my, allcard)	
                            room:playSkillEffect("xiuluo",math.random(55,56)) 						
						end																	
				    end
			    end
		end
    end,
}
zhangzheng = sgs.CreateTriggerSkill{
name = "zhangzheng",
frequency = sgs.Skill_Compulsory,	
events = {sgs.Predamaged},	
on_trigger = function(self, event, player, data)
	local room = player:getRoom()
	local damage = data:toDamage()	                 
    local from = damage.from 	
    for _,p in sgs.qlist(room:getAllPlayers()) do
        if p:getMark("@youmie")>0 then
		    if from:getMark("@youmie")==0 then
			    if not damage.card:inherits("Slash") then return end
				    for _,p in sgs.qlist(room:getAllPlayers()) do
                        if p:getMark("@youmie")>0 then
						room:playSkillEffect("xiuluo",math.random(57,58)) 
						    p:drawCards(1)			    	
	                        local log = sgs.LogMessage()			
	                        log.type = "$zhangzhengEffect"						
	                        room:sendLog(log)	
	                        local from = damage.from
	                        damage.to = p
                            data:setValue(damage)
	                        room:damage(damage)
                            return true	
						end
					end
				end
			end
		end
    end	
}
zhangzhengbuff = sgs.CreateTriggerSkill{	
	name = "#zhangzhengbuff",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.Damaged},	
	can_trigger = function(self, player)
	    return player:hasSkill("#zhangzhengbuff")	      
    end,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()        
		local xmy = room:findPlayerBySkillName(self:objectName()) 
        local damage = data:toDamage()		       
            if  xmy:getMark("@youmieskill")>0 then return false end			    				
			    if damage.card:inherits("Slash") then return false end
				room:playSkillEffect("xiuluo",math.random(57,58)) 
		            xmy:drawCards(1)               						    
	    end	
}
miyue:addSkill(youmie)
miyue:addSkill(youmiedraw)
miyue:addSkill(youmieover)
miyue:addSkill(youmiebuff)
miyue:addSkill(zhangzheng)
miyue:addSkill(zhangzhengbuff)
nvwa = sgs.General(extension, "nvwa", "wu", 4, false)
zaoren = sgs.CreateTriggerSkill{
	name = "zaoren",
    frequency = sgs.Skill_NotFrequent,	
	events = {sgs.DrawNCards},	
	can_trigger = function(self, player)
	    return player:hasSkill("zaoren")	      
    end,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local x = data:toInt()		
		if player:getMark("@ren")==3 then return false end
		if(room:askForSkillInvoke(player, "zaoren")) then											
			data:setValue(x-1)
            room:playSkillEffect("renshu",math.random(5, 6))			
			player:gainMark("@ren")
		end
	end
}
shenyou = sgs.CreateTriggerSkill{
	name = "shenyou",
	events = {sgs.HpRecover},
	can_trigger = function(self,player)
		return player:hasSkill("shenyou")
	end,
	on_trigger = function (self, event, player, data)
		local room = player:getRoom()
		local sp = room:getOtherPlayers(player)	
		local recover = data:toRecover()		
		if not recover.card:inherits("Peach") then return end
            local players=sgs.SPlayerList()		
            for _,p in sgs.qlist(room:getOtherPlayers(player)) do
			                    if not p:isWounded() then return end	
	        if  room:askForSkillInvoke(player, "shenyou") then 										
		        local target = room:askForPlayerChosen(player, sp, "shenyou") 
                    if not target:isWounded() then return end				
			            local recover = sgs.RecoverStruct()
			            recover.who = target
			            recover.recover = 1
			            room:recover(target,recover)
				       room:playSkillEffect("renshu",math.random(7, 8))	
					    return false
			end
		end	
	end,
}
wahuangcard = sgs.CreateSkillCard{
	name = "wahuangcard",	
	target_fixed = ture,	
	will_throw = true,	
	filter = function(self, targets, to_select)	        
		return to_select:hasFlag("wahuanguse")			
    end,						
	on_effect = function(self, effect)	   
		local source = effect.from
		local dest = effect.to
		local room = source:getRoom() 
        room:playSkillEffect("wansha",math.random(7, 8))   											    			 			 
                 local damage=sgs.DamageStruct()
			     damage.damage=1
			     damage.nature=sgs.DamageStruct_Thunder 
			     damage.chain=false 			     
			     damage.to = effect.to
		         room:damage(damage)
                 room:setPlayerFlag(effect.to,"-wahuanguse")					 
        end	        			
}
wahuangvs=sgs.CreateViewAsSkill{
name="wahuangvs",
n=0,
view_as = function()
		return wahuangcard:clone()
	end,
enabled_at_play=function()    
	return false
end,
enabled_at_response = function(self,player,pattern)
	return pattern == "@@wahuang"
	end	
}
wahuang = sgs.CreateTriggerSkill{
	name = "wahuang",	
	frequency = sgs.Skill_NotFrequent,
	events={sgs.Damage,sgs.Predamaged},
	view_as_skill = wahuangvs,
    can_trigger = function(self,player)
		return player:hasSkill("wahuang")
	end,		
	on_trigger=function(self,event,player,data)
	if event==sgs.Damage then
	    local room=player:getRoom()
	   	local damage = data:toDamage()		
        if damage.to:isDead() then return false end
          room:setPlayerFlag(damage.to,"wahuanguse")
		  if player:getMark("@ren")==0 then return end
		  if( room:askForSkillInvoke(player, "wahuang") and room:askForUseCard(player, "@@wahuang", "@wahuangcard") ) then 
             player:loseMark("@ren")                            		    		  
		     return true  
		  end
		  room:setPlayerFlag(damage.to,"-wahuanguse")
		  return false				
		  end
    if event==sgs.Predamaged then
        local room = player:getRoom()
		local damage = data:toDamage()						
		if player:getMark("@ren")==0 then return end		  
		if room:askForSkillInvoke(player, "wahuang") then 										
				damage.damage=damage.damage-1
				data:setValue(damage)
				room:playSkillEffect("xiuluo",math.random(51, 52))
				player:loseMark("@ren") 
		else
				return false
		end
	end
end,    			
}  	
nvwa:addSkill(zaoren)
nvwa:addSkill(shenyou)
nvwa:addSkill(wahuang)
-- hongyu = sgs.General(extension, "hongyu", "wei", 3, false)
-- jianwu = sgs.CreateTriggerSkill{
	-- name = "jianwu",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.PhaseChange,sgs.Predamage},
	-- can_trigger=function(self,target)
		-- return target:hasSkill(self:objectName())
	-- end,
	-- on_trigger=function(self,event,player,data)
	-- local room=player:getRoom()
	-- local damage=data:toDamage()
	-- if event == sgs.PhaseChange and player:getPhase()==sgs.Player_Draw then
		-- if (room:askForSkillInvoke(player,self:objectName())) then
		-- room:playSkillEffect(self:objectName())
		-- for i=1,4 do
		-- local card_Id = room:drawCard()
		-- local card = sgs.Sanguosha:getCard(card_Id)
			-- room:moveCardTo(card,nil,sgs.Player_Special,true)
			-- room:getThread():delay()
			-- if card:inherits("Slash") then
				-- player:addMark("slashnum")
			-- else
				-- room:obtainCard(player, card)
			-- end
		-- end
		    -- local x=player:getMark("slashnum")
			-- local log=sgs.LogMessage()
			-- log.from =player
			-- log.type ="#jianwu"
			-- log.arg = x
			-- room:sendLog(log)
		-- return true end
		-- end
	-- if event==sgs.Predamage then
		-- local y=player:getMark("slashnum")
		-- if damage.card:inherits("Slash") then
			-- damage.damage=damage.damage+y
			-- data:setValue(damage)
			-- player:setMark("slashnum",0)
		-- end
	-- end
	-- if (event==sgs.PhaseChange) and (player:getPhase()== sgs.Player_Finish) then
		-- player:setMark("slashnum",0)
	-- end
	-- end,
-- }
-- shuying=sgs.CreateTriggerSkill{
	-- name="shuying",
	-- frequency=sgs.Skill_NotFrequent,
	-- events={sgs.CardResponsed,sgs.CardUsed},
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
-- if event==sgs.CardResponsed then
		-- if player:getPhase()~=sgs.Player_NotActive then return end
		-- local card=data:toCard()
		-- if not card:inherits("BasicCard") then return false end
		-- card:setSkillName(self:objectName())
		-- if not player:askForSkillInvoke(self:objectName()) then return end
		-- local target=room:askForPlayerChosen(player,room:getAllPlayers(),self:objectName())
		-- local log= sgs.LogMessage()
			-- log.type = "#shuying"
			-- log.from = player
			-- log.to:append(target)
		-- room:sendLog(log)
		-- room:showAllCards(target,player)
		-- player:invoke("clearAG")
		-- local card_ids=target:handCards()
		-- room:fillAG(card_ids,player)
		-- local card_id
		-- local sucess=false
		-- local newcard
		-- while not sucess do
            -- card_id=room:askForAG(player, card_ids, true, self:objectName())
            -- if card_id == -1 then
                -- sucess=true
            -- else
                -- newcard=sgs.Sanguosha:getCard(card_id)
                -- if newcard:getType() == "basic" then
					-- sucess=true
				-- end
            -- end
        -- end
		-- player:invoke("clearAG")
		-- if card_id == -1 then return end
		-- target=room:askForPlayerChosen(player,room:getOtherPlayers(target),self:objectName())
		-- target:obtainCard(newcard)
-- elseif event==sgs.CardUsed then
		-- if player:getPhase()~=sgs.Player_NotActive then return end
		-- local use=data:toCardUse()
		-- if not use.card:inherits("BasicCard") then return false end
		-- use.card:setSkillName(self:objectName())
		-- if not player:askForSkillInvoke(self:objectName()) then return end
		-- local target=room:askForPlayerChosen(player,room:getAllPlayers(),self:objectName())
		-- local log= sgs.LogMessage()
			-- log.type = "#shuying"
			-- log.from = player
			-- log.to:append(target)
		-- room:sendLog(log)
		-- room:showAllCards(target,player)
		-- player:invoke("clearAG")
		-- local card_ids=target:handCards()
		-- room:fillAG(card_ids,player)
		-- local card_id
		-- local sucess=false
		-- local newcard
		-- while not sucess do
            -- card_id=room:askForAG(player, card_ids, true, self:objectName())
            -- if card_id == -1 then
                -- sucess=true
            -- else
                -- newcard=sgs.Sanguosha:getCard(card_id)
                -- if newcard:getType() == "basic" then
					-- sucess=true
				-- end
            -- end
        -- end
		-- player:invoke("clearAG")
		-- if card_id == -1 then return end
		-- target=room:askForPlayerChosen(player,room:getOtherPlayers(target),self:objectName())
		-- target:obtainCard(newcard)
		-- end
	-- end,
-- }
-- hongyu:addSkill(jianwu)
-- hongyu:addSkill(shuying)
-- huangrong = sgs.General(extension, "huangrong", "wei", 3, false)
-- linglong = sgs.CreateTriggerSkill{	
	-- name = "linglong",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.Damaged},	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local damage = data:toDamage()
		-- local source = damage.from
		-- local source_data = sgs.QVariant()
		-- source_data:setValue(source)
		-- if source then
			    -- if (not source:isKongcheng()) and (not player:isKongcheng()) then		        				
		            -- if room:askForSkillInvoke(player, "linglong") then							                       							 
						-- local to_exchange=source:wholeHandCards()  
                        -- local to_exchange2=player:wholeHandCards()						  
						-- room:moveCardTo(to_exchange,player,sgs.Player_Hand,true) 
                        -- room:moveCardTo(to_exchange2,source,sgs.Player_Hand,true)						
			            -- local log=sgs.LogMessage()
			            -- log.from =player
			            -- log.type ="#linglong"
		                -- log.arg  =source:getGeneralName()
			            -- room:sendLog(log)						 			 
                    -- end
                -- end							    
	    -- end
	-- end	
-- }
-- tianjiao_card = sgs.CreateSkillCard{
	-- name = "tianjiao_card",	
	-- target_fixed = false,	
	-- will_throw = true,	
	-- filter = function(self,targets,to_select,player)
		-- if #targets==1 then return false end		
		-- if to_select:getSeat()==player:getSeat() then return false end		
		-- return not to_select:isAllNude()
	-- end,		
	-- on_effect = function(self, effect)
		-- local from = effect.from
		-- local to = effect.to
		-- local room = to:getRoom()
		-- local card_id = room:askForCardChosen(from, to, "hej", "tianjiao")		
		-- room:throwCard(sgs.Sanguosha:getCard(card_id))		
		-- local slash=room:askForCard(to,"slash","tianjiaoskill")    
        -- if slash then						
			-- local use=sgs.CardUseStruct()
			 	-- use.card = slash
			 	-- use.from = to
			 	-- use.to:append(from)
			    -- room:useCard(use,false)
				-- return true	           						                				
		-- end				
	-- end,
-- }
-- tianjiao = sgs.CreateViewAsSkill{
	-- name = "tianjiao",
	-- n =0,	
	-- view_as = function()
		-- return tianjiao_card:clone()
	-- end,	
	-- enabled_at_play=function(self, player)
		-- return not player:hasUsed("#tianjiao_card")		
	-- end,	
	-- enabled_at_response = function()
		-- return false
	-- end
-- }
-- huangrong:addSkill(tianjiao)
-- huangrong:addSkill(linglong)
-- huangrong:addSkill("jiuyuanf")
-- hanli = sgs.General(extension, "hanli", "wei", 3)
-- qiangxiEXcard=sgs.CreateSkillCard{ 
-- name="qiangxiEX",
-- once=true,
-- will_throw=true,
-- filter=function(self,targets,to_select,player)       
          -- if (not self:getSubcards():isEmpty()) and player:getWeapon() == sgs.Sanguosha:getCard(self:getSubcards():first())  and not player:hasFlag("tianyi_success") then
                  -- return player:distanceTo(to_select) <= 1
          -- end
		  -- if to_select:objectName() == player:objectName() then return false end	
          -- return player:inMyAttackRange(to_select) and (#targets == 0)
-- end,
-- on_effect=function(self,effect)                
        -- local room=effect.from:getRoom() 
        -- local damage=sgs.DamageStruct() 
        -- damage.damage=1
        -- damage.nature=sgs.DamageStruct_Normal 
        -- damage.chain=false 
        -- if self:getSubcards():isEmpty() then 			
		        -- room:loseHp(effect.from)			              
        -- end		
        -- local log=sgs.LogMessage() 
        -- log.type = "#qiangxiEX"
        -- log.arg = effect.to:getGeneralName()
        -- room:sendLog(log)		
        -- damage.from=effect.from
        -- damage.to=effect.to
        -- room:damage(damage)		
       -- room:playSkillEffect("xiuluo",10)     
        -- room:setPlayerFlag(effect.from,"qxused") 
-- end                
-- }
-- qiangxiEX=sgs.CreateViewAsSkill{ 
-- name="qiangxiEX",
-- n=1,
-- view_filter=function(self, selected, to_select)
        -- return #selected==0 and to_select:inherits("Weapon") 
-- end,
-- view_as=function(self, cards)
        -- local acard=qiangxiEXcard:clone() 
        -- if #cards==0 then         
                -- return acard 
        -- elseif #cards==1 then 
                -- acard:addSubcard(cards[1])
            -- acard:setSkillName(self:objectName())     
                -- return acard
        -- end
-- end,
-- enabled_at_play=function(self,player) 
    -- if  player:getPhase()==sgs.Player_Finish then player:setFlags("-qxused") end 
        -- return not player:hasFlag("qxused")       
-- end,
-- enabled_at_response=function(self,player,pattern) 
        -- return false 
-- end
-- }
-- local skill=sgs.Sanguosha:getSkill("qiangxiEX")
-- if not skill then
	-- local skillList=sgs.SkillList()
	-- skillList:append(qiangxiEX)
	-- sgs.Sanguosha:addSkills(skillList)
-- end
-- lingping=sgs.CreateTriggerSkill{
-- name="lingping",
-- events={sgs.PhaseChange},
-- frequency = sgs.Skill_Frequent,
-- on_trigger=function(self,event,player,data)
	-- local room=player:getRoom()
	-- local selfplayer=room:findPlayerBySkillName(self:objectName())
	-- local otherplayers=room:getOtherPlayers(selfplayer)
	-- if selfplayer:getPhase()==sgs.Player_Finish then
	  -- if not selfplayer:isWounded() then return false end
		-- if (room:askForSkillInvoke(selfplayer,self:objectName())~=true) then return false end
		-- local id_t
		-- local card_t
		-- local numlist={0,0,0,0,0,0,0,0,0,0,0,0,0,0}
		-- local log=sgs.LogMessage()
		-- while true do
			-- id_t=room:drawCard()
			-- card_t=sgs.Sanguosha:getCard(id_t)
			-- room:moveCardTo(card_t,nil,sgs.Player_Special,true)
			-- room:getThread():delay()
			-- log.from=selfplayer
			-- log.type="#lingping"
			-- log.arg=card_t:getNumber()
			-- room:sendLog(log)
			-- room:obtainCard(selfplayer,id_t)
			-- if numlist[card_t:getNumber()]==0 then
				-- numlist[card_t:getNumber()]=1
			-- else
				-- break
			-- end
		-- end
	-- end
-- end,
-- }
-- zhanling=sgs.CreateTriggerSkill{
-- name="zhanling",
-- events={sgs.SlashEffected,sgs.Damaged},
-- frequency = sgs.Skill_Compulsory,
-- on_trigger=function(self,event,player,data)
	-- local room=player:getRoom()
	-- local selfplayer=room:findPlayerBySkillName(self:objectName())
	-- local otherplayers=room:getOtherPlayers(selfplayer)
	-- if event==sgs.SlashEffected then
		-- local effect=data:toSlashEffect()
		-- if not effect.to:hasSkill(self:objectName()) then return false end
		-- local from=effect.from
		-- local to=effect.to
		-- if from:hasFlag("zhanling_slash_ed") then return false end
		-- if from:hasFlag("zhanling_slash") then
			-- room:setPlayerFlag(from,"-zhanling_slash")
			-- room:setPlayerFlag(from,"zhanling_slash_ed")
			-- room:loseHp(from)
		-- else
			-- room:setPlayerFlag(from,"zhanling_slash")
		-- end
	-- elseif event==sgs.Damaged then
		-- local damage=data:toDamage()
		-- if not damage.to:hasSkill(self:objectName()) then return false end
		-- local from=damage.from
		-- local to=damage.to
		-- if from:hasFlag("zhanling_damage_ed") then return false end
		-- if from:hasFlag("zhanling_damage") then
			-- room:setPlayerFlag(from,"-zhanling_damage")
			-- room:setPlayerFlag(from,"zhanling_damage_ed")
			-- room:loseHp(from)
		-- else
			-- room:setPlayerFlag(from,"zhanling_damage")
		-- end
	-- end
-- end,
-- }
-- hanli:addSkill(lingping)
-- hanli:addSkill(zhanling)
-- muchanglan = sgs.General(extension, "muchanglan", "wei", 3, false)
-- wanjian=sgs.CreateTriggerSkill{
	-- name="wanjian",
	-- frequency=sgs.Skill_NotFrequent,
	-- events={sgs.Damage},	
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
		-- local player=room:findPlayerBySkillName(self:objectName())
		-- local damage=data:toDamage()
        -- if event==sgs.Damage and damage.to:isAlive() then
        -- if room:askForSkillInvoke(player,"wanjian") then		
		-- local slash=room:askForCard(player,"slash","@wanjian")        		
		-- if slash then
			-- slash:setSkillName(self:objectName())
			-- room:drawCards(damage.from,1)
			-- local use=sgs.CardUseStruct()
			 	-- use.card = slash
			 	-- use.from = player
			 	-- use.to:append(damage.to)
			    -- room:useCard(use,false)
				-- return true	
            -- end						                				
		-- end
	-- end
-- end
-- }
-- yanfang = sgs.CreateTriggerSkill{
      -- name = "yanfang",      
      -- events = {sgs.TurnStart},
      -- frequency = sgs.Skill_Frequent,
      -- priority = 99,
      -- on_trigger = function(self,event,player,data)
	       -- local room = player:getRoom()	
	       -- local selfplayer = room:findPlayerBySkillName(self:objectName())
	       -- local otherplayers = room:getOtherPlayers(selfplayer)	      
	       -- if event==sgs.TurnStart then
		      -- if player:hasSkill(self:objectName()) then return false end
			    -- local hd_x=selfplayer:getHandcardNum()
	            -- local Mhp_x=selfplayer:getMaxHP()
	            -- if hd_x>=Mhp_x then return false end
	            -- if not selfplayer:askForSkillInvoke(self:objectName()) then return false end	             
		        -- selfplayer:drawCards(Mhp_x-hd_x)
	       -- end	
      -- end,
      -- can_trigger = function(self, player)
	       -- local room=player:getRoom()
	       -- local selfplayer=room:findPlayerBySkillName(self:objectName())
	       -- if selfplayer==nil then return false end
	       -- return selfplayer:isAlive()
      -- end
-- }
-- muchanglan:addSkill(wanjian)
-- muchanglan:addSkill(yanfang)
-- liumengli = sgs.General(extension, "liumengli", "wei", 3, false)
-- lualieren = sgs.CreateTriggerSkill{
	-- name = "lualieren",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.Damage},
	-- can_trigger = function(self, player)
	    -- return player:hasSkill("lualieren")	      
    -- end,
	-- on_trigger = function(self, event, player, data)
	    -- local room = player:getRoom()
		-- local damage = data:toDamage()							
		-- if not damage.card:inherits("Slash") then return end		
		-- if player:isKongcheng()  or  damage.to:isKongcheng() or damage.to:objectName() == player:objectName() then return end			
		    -- if not room:askForSkillInvoke(player,self:objectName()) then return end
			   -- room:playSkillEffect("xiuluo",11)
		        -- local success=player:pindian(damage.to,self:objectName(),nil)							
				-- if success then 				
				-- if not damage.to:isNude() then															
					-- local card_id = room:askForCardChosen(player, damage.to, "he", self:objectName())
			        -- if( room:getCardPlace(card_id) == sgs.Player_Hand) then
				        -- room:moveCardTo(sgs.Sanguosha:getCard(card_id), player, sgs.Player_Hand, false)
			        -- else
				        -- room:obtainCard(player, card_id)
			        -- end								
				-- end
			-- end
		-- end			
-- }

-- local skill=sgs.Sanguosha:getSkill("lualieren")
-- if not skill then
	-- local skillList=sgs.SkillList()
	-- skillList:append(lualieren)
	-- sgs.Sanguosha:addSkills(skillList)
-- end
-- hunmengmeiqucard=sgs.CreateSkillCard{
	-- name="hunmengmeiqucard",
	-- target_fixed=false,
	-- will_throw=false,
	-- filter=function(self,targets,to_select)
		-- return not  (to_select:objectName()==sgs.Self:objectName()  or to_select:getHandcardNum()<sgs.Self:getHandcardNum())
	-- end,
	-- on_effect=function(self,effect)
		-- local room=effect.to:getRoom()		
		-- local card_id=room:askForCardChosen(effect.from,effect.to,"he",self:objectName())
		-- if room:getCardPlace(card_id)==sgs.Player_Hand then
			-- room:moveCardTo(sgs.Sanguosha:getCard(card_id),effect.from,sgs.Player_Hand,false)
		-- else
			-- room:obtainCard(effect.from,card_id)
		-- end
		-- room:setPlayerFlag(effect.from,"hunmengmeiquused")
	-- end
-- }
-- hunmengmeiqu=sgs.CreateViewAsSkill{
	-- name="hunmengmeiqu",
	-- n=0,
	-- view_filter=function()
		-- return false
	-- end,
	-- view_as=function()
		-- return hunmengmeiqucard:clone()
	-- end,		
	-- enabled_at_play=function()   
	    -- if  sgs.Self:getPhase()==sgs.Player_Finish then sgs.Self:getRoom():setPlayerFlag(sgs.Self,"-hunmengmeiquused") end 
	    -- return not sgs.Self:hasFlag("hunmengmeiquused")
    -- end,		
-- }
-- zuishengmengsi=sgs.CreateTriggerSkill{
	-- name="zuishengmengsi",
	-- frequency = sgs.Skill_Compulsory,
	-- events=sgs.CardLost,
	-- on_trigger = function(self,event,player,data)
		-- local room=player:getRoom()
		-- local move=data:toCardMove()
		-- if not move.to then return end
		-- if move.from:objectName()==move.to:objectName() then return end
		-- if move.to_place==sgs.Player_Judging then return end
		-- if move.to:hasSkill(self:objectName()) and (move.from_place==sgs.Player_Hand  or move.from_place==sgs.Player_Equip) then
			-- if move.to:getHp()<=move.from:getHp() then				
				-- local damage=sgs.DamageStruct()
				-- damage.damage=1
				-- damage.from=move.to
				-- damage.to=move.from
				-- damage.nature=sgs.DamageStruct_Normal
				-- damage.chain=false
				-- room:damage(damage)
				-- local log=sgs.LogMessage()
				-- log.type = "#zuishengmengsi"
				-- log.arg = move.to
				-- room:sendLog(log)
				-- end
		 -- end
	-- end,
	-- can_trigger=function()
		-- return true
	-- end
-- }
-- tianxuanwuyin=sgs.CreateTriggerSkill{
	-- name="tianxuanwuyin",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.Damaged},
	-- on_trigger = function(self,event,player,data)
		-- local room = player:getRoom()
		-- local s =room:findPlayerBySkillName(self:objectName())  
		-- local damage = data:toDamage()
        -- local card = damage.card
		-- local id = card:getId()
		-- if card==nil then return end
		-- if s:isKongcheng() then return end	
        -- for var = 1, damage.damage, 1 do		
		    -- if not room:askForSkillInvoke(s,self:objectName()) then return end
		    -- local carda=room:askForCard(s,".","tianxuanwuyinbuff")
		    -- if not carda then return false end		
		    -- if carda:sameColorWith(sgs.Sanguosha:getCard(id)) then				
		        -- local recover=sgs.RecoverStruct()
		        -- recover.who=s
		        -- recover.recover=1
		        -- room:recover(s,recover)
		    -- else
		        -- s:drawCards(1)
		    -- end
        -- end			
	-- end
-- }
-- liumengli:addSkill(tianxuanwuyin)
-- liumengli:addSkill(hunmengmeiqu)
-- liumengli:addSkill(zuishengmengsi)
-- hanlingsha = sgs.General(extension, "hanlingsha", "wei", 3, false)
-- luaxuanfengcard = sgs.CreateSkillCard{
	-- name = "luaxuanfengcard" ,
	-- filter = function(self, targets, to_select)
		-- if #targets >= 2 then return false end
		-- if to_select:objectName() == sgs.Self:objectName() then return false end
		-- return not to_select:isNude()
	-- end,
	-- on_use = function(self, room, source, targets)
		-- local map = {}
		-- local totaltarget = 0
		-- for _, sp in ipairs(targets) do
			-- map[sp] = 1
		-- end
		-- totaltarget = #targets
		-- if totaltarget == 1 then
			-- for _, sp in ipairs(targets) do
				-- map[sp] = map[sp] + 1
			-- end
		-- end
		-- for _, sp in ipairs(targets) do
			-- while map[sp] > 0 do
				-- if source:isAlive() and sp:isAlive() and        (not sp:isNude())        then
					-- local card_id = room:askForCardChosen(source, sp, "he", self:objectName())
					-- room:throwCard(card_id)
				-- end
				-- map[sp] = map[sp] - 1
			-- end
		-- end
	-- end
-- }
-- luaxuanfengvs = sgs.CreateViewAsSkill{
	-- name = "luaxuanfengvs" ,
	-- n = 0 ,
	-- view_as = function()
		-- return luaxuanfengcard:clone()
	-- end ,
	-- enabled_at_play = function()
		-- return false
	-- end ,
	-- enabled_at_response = function(self, target, pattern)
		-- return pattern == "@@luaxuanfeng"
	-- end
-- }
-- luaxuanfeng = sgs.CreateTriggerSkill{
	-- name = "luaxuanfeng",
	-- events = {sgs.CardLost,sgs.CardDiscarded,sgs.CardLostDone},	
	-- view_as_skill = luaxuanfengvs,
	-- frequency = sgs.Skill_NotFrequent,		
	-- on_trigger = function(self, event, player, data)		
	     -- local room=player:getRoom()
		 -- local move = data:toCardMove()
    -- if event == sgs.CardDiscarded then
        -- if player:getPhase() ~= sgs.Player_Discard then return false end  
        -- local card = data:toCard()
        -- if (card:subcardsLength() < 2) then return false end
        -- if not room:askForSkillInvoke(player,"luaxuanfeng") then return false end
		-- room:playSkillEffect("xiuluo",12)
        -- room:askForUseCard(player, "@@luaxuanfeng", "@luaxuanfengcard")
	-- end
	-- if event == sgs.CardLost then
       -- if (move.from_place==sgs.Player_Equip) then
	   -- room:setPlayerFlag(player,"equiplost")
	   -- end
	-- end
	-- if event == sgs.CardLostDone and player:hasFlag("equiplost") then
       -- room:setPlayerFlag(player,"-equiplost")
	   -- if not room:askForSkillInvoke(player,"luaxuanfeng") then return false end
	   -- room:playSkillEffect("xiuluo",12)
       -- room:askForUseCard(player, "@@luaxuanfeng", "@luaxuanfengcard")
    -- end
-- end					
-- }
-- local skill=sgs.Sanguosha:getSkill("luaxuanfeng")
-- if not skill then
	-- local skillList=sgs.SkillList()
	-- skillList:append(luaxuanfeng)
	-- sgs.Sanguosha:addSkills(skillList)
-- end
-- yanyuduohun=sgs.CreateTriggerSkill{
-- name="yanyuduohun",
-- events={sgs.CardEffected},
-- frequency = sgs.Skill_NotFrequent,
-- on_trigger=function(self,event,player,data)			
	-- if event==sgs.CardEffected then
	    -- local room=player:getRoom()	
		-- local selfplayer=room:findPlayerBySkillName(self:objectName())	  
		-- local effect=data:toCardEffect()		
        -- local card=effect.card
		-- if card:inherits("Slash") then 
			-- if (room:askForSkillInvoke(selfplayer,self:objectName(),data)~=true) then return false end			
			-- local card=room:askForCard(selfplayer,"EquipCard","yanyuduohunbuff",data)
	        -- if card==nil then return end
	        -- room:throwCard(card)
            -- local log=sgs.LogMessage()
		    -- log.type="#yanyuduohun"
			-- room:sendLog(log)			
			-- return true			
		-- end
	-- end	
-- end,
-- }
-- lingkongzhaixing = sgs.CreateTriggerSkill{
	    -- name = "lingkongzhaixing",
	    -- events = {sgs.Damage},	   
	    -- frequency = sgs.Skill_NotFrequent,	   
        -- can_trigger = function(self, player)
	        -- return player:hasSkill("lingkongzhaixing")	      
        -- end,			
	    -- on_trigger = function(self,event,player,data)
                -- if event==sgs.Damage then 	
			        -- local room = player:getRoom()
                    -- local x=room:findPlayerBySkillName(self:objectName())    					
				    -- local damage = data:toDamage()
                    -- local to = damage.to
                    -- if not damage.to:isKongcheng() then						
					    -- if math.random()<=0.5 then
					        -- if room:askForSkillInvoke(x, "lingkongzhaixing") then	
					            -- local card_id = room:askForCardChosen(x, damage.to, "he", "lingkongzhaixing")					   
						        -- x:obtainCard(sgs.Sanguosha:getCard(card_id))					    									    
					        -- end	   						                          					
                        -- end	
                    -- end
                -- end
            -- end				
-- }	
-- lingkongzhaixings = sgs.CreateTriggerSkill{	
	-- name = "#lingkongzhaixings",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.Damaged},	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local damage = data:toDamage()
		-- local source = damage.from
		-- local source_data = sgs.QVariant()
		-- source_data:setValue(source)
		-- if source then		   
			    -- if not source:isKongcheng() then
                    -- if math.random()<=0.5 then				
		                -- if room:askForSkillInvoke(player, "lingkongzhaixings") then		           
			                -- local card_id = room:askForCardChosen(player, source, "he", "lingkongzhaixings")			
				            -- room:obtainCard(player, card_id)						             
                        -- end
                    -- end					
		        -- end
	    -- end
	-- end
-- }
-- lianjianjue = sgs.CreateTriggerSkill{
	-- name = "lianjianjue",
	-- events = {sgs.PhaseChange},
	-- on_trigger = function(self, event, player, data)		
		-- if event==sgs.PhaseChange and player:getPhase() == sgs.Player_Start then
		    -- local room = player:getRoom()
			-- local player = room:findPlayerBySkillName(self:objectName())
			-- local targets = sgs.SPlayerList()
			-- for _,p in sgs.qlist(room:getOtherPlayers(player)) do
				-- if p:getHandcardNum() <= player:getHandcardNum() then
					-- if player:canSlash(p) then
						-- targets:append(p)
					-- end
				-- end
			-- end									
			-- if targets:length() <= 0 then return false end			
			-- if not player:askForSkillInvoke(self:objectName()) then return false end						
			-- local target = room:askForPlayerChosen(player, targets, "lianjianjue")			
			-- if not target then return false end
			-- local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			-- slash:setSkillName(self:objectName())			
			-- local card_use = sgs.CardUseStruct()
			-- card_use.from = player
			-- card_use.to:append(target)
			-- card_use.card = slash
			-- room:useCard(card_use, false)			
		-- elseif event==sgs.PhaseChange and player:getPhase() == sgs.Player_Finish then
		    -- local room = player:getRoom()
			-- local player = room:findPlayerBySkillName(self:objectName())
			-- local targets = sgs.SPlayerList()
			-- for _,p in sgs.qlist(room:getOtherPlayers(player)) do
				-- if p:getHp() <= player:getHp() then
					-- if player:canSlash(p) then
						-- targets:append(p)
					-- end
				-- end
			-- end			
			-- if targets:length() <= 0 then return false end			
			-- if not player:askForSkillInvoke(self:objectName()) then return false end			
			-- local target = room:askForPlayerChosen(player, targets, "lianjianjue")		
			-- if not target then return false end
			-- local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			-- slash:setSkillName(self:objectName())			
			-- local card_use = sgs.CardUseStruct()
			-- card_use.from = player
			-- card_use.to:append(target)
			-- card_use.card = slash
			-- room:useCard(card_use, false)
		-- end
	-- end
-- }
-- hanlingsha:addSkill(lingkongzhaixing)
-- hanlingsha:addSkill(lingkongzhaixings)
-- hanlingsha:addSkill(yanyuduohun)
-- hanlingsha:addSkill(lianjianjue)
-- xiaoyao = sgs.General(extension, "xiaoyao", "wei", 3, false)
-- yuanwansha=sgs.CreateTriggerSkill{
	-- name="yuanwansha",
	-- events=sgs.AskForPeaches,
	-- frequency=sgs.Skill_Compulsory,
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
		-- local current=room:getCurrent()
		-- if current:isAlive() and current:hasSkill("yuanwansha") then
			-- local dying=data:toDying()
			-- local who=dying.who
			 -- room:playSkillEffect("xiuluo",13)
			-- return not (player:getSeat()==current:getSeat() or player:getSeat()==who:getSeat())
		-- end
	-- end,
	-- can_trigger=function(self,player)
		-- return player and player:isAlive()
	-- end,
-- }
-- local skill=sgs.Sanguosha:getSkill("yuanwansha")
-- if not skill then
	-- local skillList=sgs.SkillList()
	-- skillList:append(yuanwansha)
	-- sgs.Sanguosha:addSkills(skillList)
-- end
-- zhaohuncard = sgs.CreateSkillCard{
	-- name = "zhaohuncard" ,
	-- targer_fixed = false,
	-- will_throw = true,
	-- filter = function(self,targets,to_select) 
		-- return #targets <= sgs.Self:getLostHp() - 1 and not to_select:hasFlag("zhaohuntarget") 
	-- end,
	-- on_effect = function(self,effect)
		-- local source = effect.from
		-- local dest = effect.to
		-- local room = source:getRoom()						 
        -- local damage=sgs.DamageStruct()
		-- damage.damage=1
	    -- damage.nature=sgs.DamageStruct_Normal
        -- damage.chain=false		
		-- damage.from=source
	    -- damage.to = dest
		-- room:damage(damage)						
	-- end,
	-- on_use = function(self, room, source, targets)
		-- local i = 0
		-- for _,p in sgs.list(targets) do
			-- room:cardEffect(self, source, p)
			-- i=i+1
		-- end
		-- local rec = sgs.RecoverStruct()
		-- rec.who = source
		-- rec.recover = i-1
		-- room:recover(source, rec)
	-- end

-- }
-- zhaohunvs = sgs.CreateViewAsSkill{
	-- name = "zhaohunvs",
	-- n = 0,
	-- view_as = function(self, cards)
		-- return zhaohuncard:clone()
	-- end,
    -- enabled_at_play = function(self, player)
        -- return false
    -- end,
    -- enabled_at_response = function(self, player, pattern)
        -- return pattern == "@@zhaohun"
	-- end
-- }
-- zhaohun = sgs.CreateTriggerSkill{
        -- name = "zhaohun",
        -- frequency = sgs.Skill_NotFrequent,		
        -- events = {sgs.TurnStart},		
        -- view_as_skill = zhaohunvs,	
        -- can_trigger=function()
            -- return true
        -- end,		
        -- on_trigger = function(self, event, player, data)
		    -- local room = player:getRoom()
			-- local s = room:findPlayerBySkillName(self:objectName())
            -- if not (s) then return end		
            -- if player:objectName()~=s:objectName() then return false end
            -- if not s:isWounded() then return end				
			-- local players = sgs.SPlayerList()
			-- for _, p in sgs.qlist(room:getOtherPlayers(player)) do
                -- if player:getHp() > p:getHp() then return end			
			    -- room:setPlayerFlag(player, "zhaohuntarget")
                -- room:askForUseCard(player, "@@zhaohun", "@zhaohun")
			    -- room:setPlayerFlag(player, "-zhaohuntarget")
                -- return false
            -- end
		-- end,	
-- }
-- chiqing = sgs.CreateTriggerSkill{
	-- name = "chiqing",
    -- events = {sgs.CardEffected},
	-- priority = 4,
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
		-- local effect=data:toCardEffect()
		-- local from=effect.from
		-- local to=effect.to
		-- if effect.card:inherits("Slash") or effect.card:inherits("Duel")  then	
			-- for _,theplayer in sgs.qlist(room:getAllPlayers()) do
				-- if theplayer:hasSkill("chiqing") and theplayer:getSeat()~=from:getSeat() and  theplayer:getSeat()~=to:getSeat() then
					-- if room:askForSkillInvoke(theplayer,"chiqing",data) then						
			-- local judge=sgs.JudgeStruct()
			-- judge.pattern=sgs.QRegExp("(.*):(spade|club):(.*)")
			-- judge.good=false
			-- judge.reason="chiqing"
			-- judge.who=theplayer
		    -- room:judge(judge)
		    -- if judge:isGood() then
		    -- room:setEmotion(theplayer,"good")		
		    -- theplayer:drawCards(2)
		    -- effect.to=theplayer
		    -- data:setValue(effect)						
		-- local hnum = theplayer:getHandcardNum() 
		-- local cdlist = sgs.IntList()  
		    -- cdlist:append(theplayer:handCards():at(hnum-1))   
		    -- cdlist:append(theplayer:handCards():at(hnum-2))   
		    -- room:askForYiji(theplayer, cdlist)  
		-- if(theplayer:getHandcardNum() == hnum-1) then
		    -- celist = sgs.IntList()
		    -- celist:append(theplayer:handCards():at(hnum-2))
	        -- room:askForYiji(theplayer, celist)
			-- end
		-- else
			-- room:setEmotion(theplayer,"bad")			
			-- if effect.from:isKongcheng() then return false end
			-- local card_id = room:askForCardChosen(theplayer, effect.from, "h", "chiqing")
			-- room:throwCard(sgs.Sanguosha:getCard(card_id))                        			
			-- effect.to=theplayer
			-- data:setValue(effect)
			-- return
		-- end	
						-- return false
					-- end
				-- end
			-- end
		-- end
	-- end,
	-- can_trigger=function(self,player)
		-- return player and player:isAlive()
	-- end,
-- }
-- xiaoyao:addSkill(zhaohun)
-- xiaoyao:addSkill(chiqing)
-- liurushi = sgs.General(extension, "liurushi", "wei", 3, false)
-- wanmei_card = sgs.CreateSkillCard{
	-- name = "wanmei_card",	
	-- target_fixed = false,	
	-- will_throw = false,	
	-- filter = function(self,targets,to_select,player)
		-- if #targets==1 then return false end		
		-- if to_select:getSeat()==player:getSeat() then return false end		
		-- return not to_select:isAllNude()
	-- end,		
	-- on_effect = function(self, effect)
		-- local from = effect.from
		-- local to = effect.to
		-- local room = to:getRoom()
		-- local card_id = room:askForCardChosen(from, to, "hej", "wanmei")
		-- local card = sgs.Sanguosha:getCard(card_id)
		-- room:moveCardTo(card, from, sgs.Player_Hand, false)			
		-- room:setPlayerFlag(from,"wanmeiused")		
	-- end,
-- }
-- wanmeivs = sgs.CreateViewAsSkill{
	-- name = "wanmeivs",	
	-- n = 0,	
	-- view_as = function()
		-- return wanmei_card:clone()		
	-- end,	
	-- enabled_at_play = function()
		-- return false
	-- end,	
	-- enabled_at_response = function(self, player, pattern)
		-- return pattern == "@@wanmei"
	-- end
-- }
-- wanmei = sgs.CreateTriggerSkill{
	-- name = "wanmei",
	-- view_as_skill = wanmeivs,
	-- events = {sgs.PhaseChange},	
	-- on_trigger = function(self, event, player, data)
		-- if player:getPhase() == sgs.Player_Start or player:getPhase() == sgs.Player_Finish then
		    -- if player:hasFlag("wanmeiused") then return false end
			-- local room = player:getRoom()
			-- local can_invoke = false	    
			-- local other = room:getOtherPlayers(player)    	
			-- for _,aplayer in sgs.qlist(other) do
				-- if  not aplayer:isAllNude() then
					-- can_invoke = true	
					-- break
				-- end
			-- end
			-- if(not room:askForSkillInvoke(player,"wanmei")) then return false end
			-- if(can_invoke and room:askForUseCard(player, "@@wanmei", "@wanmei_card")) then return false end
		-- return false
		-- end  
	-- end
-- }
-- shuhuaicard=sgs.CreateSkillCard{
	-- name="shuhuaicard",
	-- target_fixed=false,
	-- will_throw=false,
	-- on_use=function(self,room,source,targets)
		-- local room=source:getRoom()
		-- local target=targets[1]		
		-- local t=room:askForChoice(target,"shuhuai","basic+trick+equip")										
		-- local card=nil
		-- local carda=nil		
		-- if t=="basic" then 		
			-- carda=room:askForCard(source,".","basic")			
			-- if carda and carda:getTypeId()==sgs.Card_Basic then card=carda end											
		-- end
		-- if t=="trick" then 
			-- carda=room:askForCard(source,".","trick")
			-- if carda and carda:getTypeId()==sgs.Card_Trick then card=carda end
		-- end
		-- if t=="equip" then 
			-- carda=room:askForCard(source,".","equip")
			-- if carda and carda:getTypeId()==sgs.Card_Equip then card=carda end
		-- end
		-- if carda then source:obtainCard(carda) end   	
		-- if card then
			-- room:moveCardTo(card,target,sgs.Player_Hand,true)		
			-- local f=room:askForChoice(source,"shuhuai","drawcard+recover")
			-- if f=="drawcard" then			  
				-- source:drawCards(2)				
			-- else
				-- local recover=sgs.RecoverStruct()   
				-- recover.recover=1 
				-- recover.who=source   
				-- room:recover(source,recover)			
			-- end
		-- end
		-- room:setPlayerFlag(source,"shuhuaiused")
	-- end,
-- }
-- shuhuai=sgs.CreateViewAsSkill{
	-- name="shuhuai",
	-- n=0,
	-- view_as=function()
		-- acard=shuhuaicard:clone()
		-- return acard
	-- end,
	-- enabled_at_play=function()
		-- return not sgs.Self:hasFlag("shuhuaiused")
	-- end,
	-- enabled_at_response=function()
		-- return false
	-- end
-- }
-- liurushi:addSkill(wanmei)
-- liurushi:addSkill(shuhuai)
-- sgklvbu = sgs.General(extension, "sgklvbu", "qun", 5)
-- kuangbaowrath = sgs.CreateTriggerSkill{
	-- name = "kuangbaowrath",
	-- events = {sgs.GameStart},
	-- frequency = sgs.Skill_Compulsory,
	-- can_trigger = function(self, player)
	    -- return player:hasSkill("kuangbaowrath")	      
    -- end,
	-- on_trigger = function(self, event, player, data)
	    -- local room = player:getRoom()		
	    -- player:gainMark("@wrath",2)		         	
	    -- end
-- }
-- kuangbao1 = sgs.CreateTriggerSkill{
	    -- name = "#kuangbao1",
	    -- events = {sgs.Damage},
	    -- frequency = sgs.Skill_Compulsory,	
	    -- on_trigger = function(self,event,player,data)
                -- if event==sgs.Damage then 	
			        -- local room = player:getRoom()
                    -- local player=room:findPlayerBySkillName(self:objectName()) 					
				    -- local damage = data:toDamage()				                     
				    -- if damage.from and (damage.from:objectName() == player:objectName()) then   
                       	-- for var=1,damage.damage,1 do
		                    -- player:gainMark("@wrath")			                        											                        
						-- end   
					-- end	   						                          					
                -- end
        -- end,				
-- }
-- kuangbao2 = sgs.CreateTriggerSkill{
    -- name = "#kuangbao2",
	-- frequency = sgs.Skill_Frequent,
    -- events = {sgs.Damaged},      	
    -- on_trigger=function(self,event,player,data)
       	-- if event==sgs.Damaged then 
		    -- local room = player:getRoom()		
		    -- local damage = data:toDamage()	
            -- for var=1,damage.damage,1 do
		        -- player:gainMark("@wrath")								
            -- end
        -- end	
    -- end,		
-- }      
-- wumou = sgs.CreateTriggerSkill{
	-- name = "wumou" ,
	-- frequency = sgs.Skill_Compulsory ,
	-- events = {sgs.CardUsed, sgs.CardResponded} ,
	-- on_trigger = function(self, event, player, data)
	    -- local room = player:getRoom()
		-- local card
		-- if event == sgs.CardUsed then
			-- local use = data:toCardUse()
			-- card = use.card
		-- elseif event == sgs.CardResponded then
			-- card = data:toCardResponse().m_card
		-- end
		-- if card:isNDTrick() then
			-- local num = player:getMark("@wrath")
			-- if num >= 1 then						  				
				-- if room:askForChoice(player,self:objectName(),"losebiaoji+losehp")=="losebiaoji" then						
					-- player:loseMark("@wrath")
				-- else
					-- room:loseHp(player)					
				-- end
			-- else
				-- room:loseHp(player)
			-- end
		-- end
	-- end
-- }
-- wuqiancard = sgs.CreateSkillCard{
	-- name = "wuqiancard",
	-- filter = function(self, targets, to_select)
		-- return (#targets == 0) and (to_select:objectName() ~= sgs.Self:objectName())
	-- end,
	-- on_effect = function(self, effect)
		-- local room = effect.to:getRoom()		
		-- effect.from:loseMark("@wrath", 2)		
		-- room:acquireSkill(effect.from, "wushuang")		
		-- effect.from:setFlags("wuqiansource")
		-- effect.to:setFlags("wuqiantarget")					
		-- effect.to:addMark("armor_nullified")
	-- end
-- }
-- wuqianvs = sgs.CreateViewAsSkill{
	-- name = "wuqianvs",
	-- view_as = function()
		-- return wuqiancard:clone()
	-- end,
	-- enabled_at_play = function(self, player)
		-- return player:getMark("@wrath") >= 2
	-- end
-- }
-- wuqian = sgs.CreateTriggerSkill{
	-- name = "wuqian",
	-- events = {sgs.PhaseChange,sgs.Death},		
	-- view_as_skill = wuqianvs,
	-- on_trigger = function(self, event, player, data)
	    -- local room = player:getRoom()
		-- local ziji = room:findPlayerBySkillName("wuqian")
	    -- if ziji == nil then return false end
		-- if ziji:getPhase()==sgs.Player_NotActive then return false end				
		-- if event == sgs.Death then
			-- local death = data:toDeath()
			-- if death.who:objectName() ~= player:objectName() then
				-- return false
			-- end
		-- end		
		-- for _, p in sgs.qlist(room:getAllPlayers()) do		
			-- if p:hasFlag("wuqiantarget") then
				-- p:setFlags("-wuqiantarget")				
				-- if p:getMark("armor_nullified")>0 then				    
					-- p:removeMark("armor_nullified")
				-- end
			-- end
		-- end
		-- room:detachSkillFromPlayer(player,"wushuang")		
		-- return false
	-- end,
	-- can_trigger = function(self, target)
		-- return target and target:hasFlag("wuqiansource")
	-- end
-- }
-- wuqian_buff=sgs.CreateTriggerSkill{
-- name="#wuqian_buff",
-- events={sgs.CardUsed},
-- frequency = sgs.Skill_Compulsory,
-- priority=2,
-- can_trigger=function(self, player)
	-- local room=player:getRoom()
	-- local selfplayer=room:findPlayerBySkillName(self:objectName())
	-- if selfplayer==nil then return false end
	-- return selfplayer:isAlive()
-- end,
-- on_trigger=function(self,event,player,data)
	-- local room=player:getRoom()	
	-- local selfplayer=room:findPlayerBySkillName(self:objectName())
	-- local otherplayers=room:getOtherPlayers(selfplayer)	
	-- if event==sgs.CardUsed then
		-- local use=data:toCardUse()
		-- if not use.from:hasSkill(self:objectName()) then return false end
		-- local b1=false
		-- local b2=false
		-- if use.card:inherits("Slash") then b1=true end
		-- if use.card:inherits("ArcheryAttack") then b1=true end			
		-- if use.card:inherits("SavageAssault") then b1=true end
        -- if use.card:inherits("Fuzhou") then b1=true end						
		-- if not selfplayer:hasFlag("wuqiansource") then return false end		
		-- for _,p in sgs.qlist(use.to) do
		  -- if p:hasFlag("wuqiantarget") then
			-- b2=false
			-- if p:getArmor()~=nil then
			    -- b2=true end
			-- else
				-- if p:hasSkill("bazhen") then b2=true end
			-- end
			-- if b1 and b2 then				
				-- p:addMark("qinggang")
			-- end	
          -- end			
		-- end		
		-- room:useCard(use,false)		
		-- for _,p in sgs.qlist(use.to) do
			-- if p:getMark("qinggang")>0 then
				-- p:removeMark("qinggang")
			-- end						
		-- end
		-- return true		
	-- end	
-- }
-- shenfencard=sgs.CreateSkillCard{
	-- name="shenfencard",
	-- target_fixed = true,
	-- will_throw = true,
	-- on_use=function(self, room, source, targets)
		-- source:loseMark("@wrath",6)		
		-- local players = room:getOtherPlayers(source)		       
		-- for _,player in sgs.qlist(players) do
		-- local damage=sgs.DamageStruct()
			-- damage.damage=1			
			-- damage.from=source
			-- damage.to = player
		    -- room:damage(damage)
		-- end		
		-- for _,player in sgs.qlist(players) do
			-- player:throwAllEquips()
		-- end						
		-- for _,player in sgs.qlist(players) do
			-- if not player:isKongcheng() then
		        -- local id1 = room:askForCardChosen(source, player, "h", "xshenfen")
			    -- local dis1 = sgs.Sanguosha:getCard(id1)
			    -- room:throwCard(dis1)
			-- end
		-- end		
		-- for _,player in sgs.qlist(players) do
			-- if not player:isKongcheng() then
		        -- local id2 = room:askForCardChosen(source, player, "h", "xshenfen")
			    -- local dis2 = sgs.Sanguosha:getCard(id2)
			    -- room:throwCard(dis2)
			-- end
		-- end		
		-- for _,player in sgs.qlist(players) do
			-- if not player:isKongcheng() then
		        -- local id3 = room:askForCardChosen(source, player, "h", "xshenfen")
			    -- local dis3 = sgs.Sanguosha:getCard(id3)
			    -- room:throwCard(dis3)
			-- end
		-- end		
		-- for _,player in sgs.qlist(players) do
			-- if not player:isKongcheng() then
		        -- local id4 = room:askForCardChosen(source, player, "h", "xshenfen")
			    -- local dis4 = sgs.Sanguosha:getCard(id4)
			    -- room:throwCard(dis4)
			-- end
		-- end		  
        -- source:turnOver()	    
	-- end,
-- }
-- xshenfen=sgs.CreateViewAsSkill{
	-- name="xshenfen",
	-- n=0,
	-- view_as=function()				
		-- return shenfencard:clone()
	-- end,
	-- enabled_at_play=function(self, player)
		-- return player:getMark("@wrath")>=6 and not player:hasUsed("#shenfencard")
	-- end,
-- }
-- sgklvbu:addSkill(kuangbao1)
-- sgklvbu:addSkill(kuangbao2)
-- sgklvbu:addSkill(kuangbaowrath)
-- sgklvbu:addSkill(wumou)
-- sgklvbu:addSkill(wuqian)
-- sgklvbu:addSkill(wuqian_buff)
-- sgklvbu:addSkill(xshenfen)
-- sgkcaocao = sgs.General(extension, "sgkcaocao", "qun", 3)
-- guixin = sgs.CreateTriggerSkill{	
	-- name = "guixin",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.Damaged},	
    -- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()				           
		-- local damage = data:toDamage()
        -- local player=room:findPlayerBySkillName(self:objectName())
        -- if player:isAlive() then		
		-- for var=1,damage.damage,1 do
		    -- local can_invoke = false
			-- for _,p in sgs.qlist(room:getOtherPlayers(player)) do			
				-- if not p:isAllNude() then
					-- can_invoke = true
					-- break
				-- end
			-- end
			-- if not can_invoke then break end				
		         	-- if (room:askForSkillInvoke(player,self:objectName(),data)~=true) then return end
                        -- room:playSkillEffect("xiuluo",math.random(39, 40))					
				        -- for _,p in sgs.qlist(room:getOtherPlayers(player)) do
					        -- if not p:isAllNude() then
					     	    -- local card_id = room:askForCardChosen(player,p, "hej", self:objectName())
								-- room:obtainCard(player, card_id)													    	    					    	    
					        -- end	
                        -- end
					    -- player:turnOver()					
                    -- end                               																
		-- end
	-- end
-- }
-- feiying = sgs.CreateDistanceSkill{
	-- name = "feiying",
	-- correct_func = function(self, from, to)
		-- if to:hasSkill("feiying") then
			-- return 1
		-- end
	-- end,
-- }
-- sgkcaocao:addSkill(guixin)
-- sgkcaocao:addSkill(feiying)
-- litaibai = sgs.General(extension, "litaibai", "wei", 3)
-- shenbi = sgs.CreateTriggerSkill{
	    -- name = "#shenbi",
	    -- events = {sgs.TurnStart,sgs.Damage},
	    -- frequency = sgs.Skill_Compulsory,	
		-- can_trigger = function(self, player)
	        -- return player:hasSkill("#shenbi")	      
        -- end,
	    -- on_trigger = function(self,event,player,data)
		        -- if (event==sgs.TurnStart) then
                    -- local room = player:getRoom()
		            -- local player=room:findPlayerBySkillName(self:objectName()) 
                    -- if player:getMark("@qinglianbuff1")>0 or player:getMark("@qinglianbuff2")>0  then
					    -- player:loseMark("@qinglianbuff1")
						-- player:loseMark("@qinglianbuff2")
					-- end
				-- end                          									
                -- if event==sgs.Damage then 	
			        -- local room = player:getRoom()
                    -- local player=room:findPlayerBySkillName(self:objectName()) 					
				    -- local damage = data:toDamage()				                     
				    -- if damage.from and (damage.from:objectName() == player:objectName()) then 
                            -- local count = player:getMark("@qinglian")
                            -- if count > 5 then return false end 							
		                    -- player:gainMark("@qinglian")			                        											                        						   
					-- end	   						                          					
                -- end
            -- end				
-- }
-- shenbiss = sgs.CreateTriggerSkill{
    -- name = "shenbiss",
	-- frequency = sgs.Skill_NotFrequent,
    -- events = {sgs.Damaged},      	
    -- on_trigger=function(self,event,player,data)
       	-- if event==sgs.Damaged then 
		    -- local room = player:getRoom()
            -- local player=room:findPlayerBySkillName(self:objectName()) 				
		    -- local damage = data:toDamage()			
			-- if player:getMark("@qinglian")<=0 then return end
			-- if room:askForSkillInvoke(player,self:objectName(),data) then  
			    -- player:loseMark("@qinglian")
                -- local targets=room:getOtherPlayers(player)																
				-- local newtarget = room:askForPlayerChosen(player, targets, self:objectName())												
				-- local use=sgs.CardUseStruct()
	            -- use.card=sgs.Sanguosha:cloneCard("slash",sgs.Card_NoSuit,0)
	            -- use.from=player
	            -- use.to:append(newtarget)
	            -- room:useCard(use,false)                				
			    -- local count = player:getMark("@qinglianbuff1")
                -- if count > 0 then return false end 									                   						
				-- player:gainMark("@qinglianbuff1")							          		       							
            -- end
        -- end	
    -- end		
-- }      
-- qinglianbuff1 = sgs.CreateProhibitSkill{
     -- name = "#qinglianbuff1",
     -- is_prohibited = function(self, from, to, card)
     -- if (to:hasSkill("#qinglianbuff1")) and (to:getMark("@qinglianbuff1")>0) then
     -- return (card:inherits("Duel") or card:inherits("Snatch") or card:inherits("Dismantlement") or card:inherits("Toulianghuanzhu"))  
     -- end
     -- end
-- }
-- qinglianbuff1s=sgs.CreateTriggerSkill{
	-- name="#qinglianbuff1s",
	-- frequency=sgs.Skill_Compulsory,
	-- events={sgs.CardEffected},	
	-- can_trigger = function(self, player)
	    -- return player:hasSkill("#qinglianbuff1s")	      
    -- end,
	-- on_trigger=function(self,event,player,data)
	    -- if event==sgs.CardEffected then
		   -- local card=data:toCardEffect().card
		   -- local room=player:getRoom()
		   -- local player=room:findPlayerBySkillName(self:objectName())
		   -- if player:getMark("@qinglianbuff1")>0 then		   		  
		        -- if (card:inherits("SavageAssault") or card:inherits("ArcheryAttack")) then 		   		  		     	  		           
					-- return true
	            -- end
		   -- end
		-- end
	-- end
-- }	   	   	   	   	 	   
-- jiangecard=sgs.CreateSkillCard{
	-- name="jiangecard",
	-- target_fixed =false,
	-- will_throw = true,
	-- once=true,
	-- filter = function(self,targets,to_select,player)
	-- if(to_select:getSeat() == player:getSeat())then return false end	
       -- return (#targets == 0) 	
    -- end,
	-- on_effect = function(self, effect)
        -- local source = effect.from
		-- local dest = effect.to
		-- local room = source:getRoom() 	
		-- source:loseMark("@qinglian",4)			
		-- source:throwAllCards()
        -- source:gainMark("@qinglianbuff2")		
		-- local damage=sgs.DamageStruct()
			-- damage.damage=1			
			-- damage.from=source
			-- damage.to = dest
		    -- room:damage(damage)            		
		-- if not dest:isNude() then
		        -- local id1 = room:askForCardChosen(source, dest, "he", "jiange")
			    -- local dis1 = sgs.Sanguosha:getCard(id1)
			    -- room:throwCard(dis1)									
			-- if not dest:isNude() then
		        -- local id2 = room:askForCardChosen(source, dest, "he", "jiange")
			    -- local dis2 = sgs.Sanguosha:getCard(id2)
			    -- room:throwCard(dis2)
			-- end
		-- end						
        -- source:turnOver()       	    
	-- end
-- }
-- jiange=sgs.CreateViewAsSkill{
	-- name="jiange",
	-- n=0,
	-- view_as=function()				
		-- return jiangecard:clone()
	-- end,
	-- enabled_at_play=function(self, player)
		-- return player:getMark("@qinglian")>=4 and not player:hasUsed("#jiangecard")
	-- end,
-- }	   	   	   
-- qinglianbuff2=sgs.CreateProhibitSkill{
 -- name = "#qinglianbuff2",
 -- is_prohibited=function(self,from,to,card)
   -- if (to:hasSkill("#qinglianbuff2")) and (to:getMark("@qinglianbuff2")>0) then
   -- return card:inherits("Slash") 
  -- end
 -- end,
-- }		   	   	   	   	   	   	   
-- litaibai:addSkill(shenbi)
-- litaibai:addSkill(shenbiss)
-- litaibai:addSkill(qinglianbuff1)
-- litaibai:addSkill(qinglianbuff1s)
-- litaibai:addSkill(jiange)
-- litaibai:addSkill(qinglianbuff2)
-- zhaozilong = sgs.General(extension, "zhaozilong", "shu", 3)
-- ldtmp={}
-- Longdanwz = sgs.CreateViewAsSkill{
	-- name = "Longdanwz",
	-- n = 1,	
	-- view_filter = function(self, selected, to_select)
		-- if ldtmp[1] == "slash" then return to_select:inherits("Jink") end
		-- if ldtmp[1] == "jink" then return to_select:inherits("Slash") end
	-- end,	
	-- view_as = function(self, cards)
		-- if #cards == 1 then
			-- local card = cards[1]
			-- local xjncard = sgs.Sanguosha:cloneCard(ldtmp[1], cards[1]:getSuit(), cards[1]:getNumber())
			-- xjncard:addSubcard(cards[1])
			-- xjncard:setSkillName(self:objectName())
			-- return xjncard
		-- end
	-- end,	
	-- enabled_at_play = function(self, player, pattern) 
		-- ldtmp[1] = "slash"
		-- return (sgs.Self:canSlashWithoutCrossbow()) or (sgs.Self:getWeapon() and sgs.Self:getWeapon():className() == "Crossbow")
	-- end,	
	-- enabled_at_response = function(self, player, pattern)
		-- if (pattern == "jink") or (pattern == "slash") then 
			-- ldtmp[1] = pattern
			-- return true 
		-- end
	-- end,
-- }
-- Chongzhenwz = sgs.CreateTriggerSkill{
	-- name = "Chongzhenwz",
	-- events = {sgs.CardEffected, sgs.CardEffect, sgs.CardResponsed},			
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()						
		-- if event == sgs.CardEffected then
			-- local effect = data:toCardEffect()
			-- local value = sgs.QVariant()
			-- value:setValue(effect.from)
			-- room:setTag("ChongzhenwzTo", value)
		-- elseif event == sgs.CardEffect then
			-- local effect = data:toCardEffect()
			-- if effect.to:isKongcheng() then return end			
			-- if effect.card:getSkillName() == "Longdanwz" then
       			-- if room:askForSkillInvoke(player, "Chongzhenwz") then
				    -- local card_id = room:askForCardChosen(effect.from, effect.to, "h", "Chongzhenwz")					
				    -- room:moveCardTo(sgs.Sanguosha:getCard(card_id), effect.from, sgs.Player_Hand, false)
				-- end
			-- end		
		-- elseif event == sgs.CardResponsed then
			-- local card = data:toCard()
			-- local target = room:getTag("ChongzhenwzTo"):toPlayer()			
			-- if not target then return end
            -- if target:isKongcheng() then return end			
			-- if card:getSkillName() == "Longdanwz" then			
			    -- if room:askForSkillInvoke(player, "Chongzhenwz") then 			
			        -- local card_id = room:askForCardChosen(player, target, "h", "Chongzhenwz")					
			        -- room:moveCardTo(sgs.Sanguosha:getCard(card_id), player, sgs.Player_Hand, false)
		        -- end
	        -- end
		-- end
	-- end
-- }
-- zhaozilong:addSkill(Longdanwz)
-- zhaozilong:addSkill(Chongzhenwz)
-- sgklvmeng = sgs.General(extension, "sgklvmeng", "qun", 3)
-- shelie = sgs.CreateTriggerSkill{
	-- name = "shelie",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.PhaseChange},
	-- on_trigger = function(self, event, player, data)
	    -- local room = player:getRoom()
		-- if(event == sgs.PhaseChange and player:getPhase() == sgs.Player_Draw) then 	    				
		-- if not player:askForSkillInvoke(self:objectName()) then return false end
		-- local card_ids = room:getNCards(5)
		-- room:fillAG(card_ids,nil)
		-- while (not card_ids:isEmpty()) do
			-- local card_id = room:askForAG(player, card_ids, false, self:objectName())
			-- card_ids:removeOne(card_id)
			-- local card = sgs.Sanguosha:getCard(card_id)
			-- local suit = card:getSuit()
			-- room:takeAG(player, card_id)
			-- local removelist = {}
			-- for _,id in sgs.qlist(card_ids) do
				-- local c = sgs.Sanguosha:getCard(id)
				-- if c:getSuit() == suit then
					-- room:takeAG(nil, c:getId())
					-- table.insert(removelist, id)
				-- end
			-- end									
			-- if #removelist > 0 then
				-- for _,id in ipairs(removelist) do
					-- if card_ids:contains(id) then
						-- card_ids:removeOne(id)
					-- end
				-- end												
			-- end		                        			
		-- end										
		-- player:invoke("clearAG")			
		-- local players=sgs.SPlayerList()
		-- for _,p in sgs.qlist(room:getOtherPlayers(player)) do
		-- p:invoke("clearAG")	
		-- end
        -- return true		
	-- end
-- end
-- }
-- gongxinxxcard = sgs.CreateSkillCard{
	-- name = "gongxinxx" ,
	-- filter=function(self,targets,to_select,player)
		-- return not to_select:isKongcheng()  and (#targets == 0) and (to_select:getSeat()~=player:getSeat())
	-- end ,
	-- on_effect = function(self, effect)        	
		-- local source = effect.from
		-- local dest = effect.to
		-- local room = source:getRoom() 
		-- room:setPlayerFlag(effect.from,"gongxinxxused")
		-- room:doGongxin(effect.from, effect.to)		    		
	-- end
-- }
-- gongxinxx = sgs.CreateViewAsSkill{
	-- name = "gongxinxx" ,
	-- n = 0 ,
	-- view_as = function()
		-- return gongxinxxcard:clone()
	-- end ,
	-- enabled_at_play=function()   
	    -- if sgs.Self:getPhase()==sgs.Player_Finish then sgs.Self:getRoom():setPlayerFlag(sgs.Self,"-gongxinxxused") end 
	-- return not sgs.Self:hasFlag("gongxinxxused") 
    -- end,
-- }
-- sgklvmeng:addSkill(shelie)
-- sgklvmeng:addSkill(gongxinxx)
-- sunwukong = sgs.General(extension, "sunwukong", "qun", 4)
-- fstmp={}
-- fenshenvs = sgs.CreateViewAsSkill{
	-- name = "fenshenvs",
	-- n = 0,
	-- view_as = function(self, cards)
		-- if #cards == 0 then
			-- local ld_card = sgs.Sanguosha:cloneCard(fstmp[1], sgs.Card_NoSuit, 0)
			-- ld_card:setSkillName(self:objectName())
			-- return ld_card
		-- end
	-- end,
	-- enabled_at_play = function(self,player) 
		-- fstmp[1] = "slash"
		-- return sgs.Slash_IsAvailable(player)
	-- end,
	-- enabled_at_response = function(self, player, pattern)
		-- if(pattern == "jink") then 
			-- fstmp[1] = pattern
			-- return true 
		-- end
	-- end,
-- }
-- fenshen = sgs.CreateTriggerSkill{
	-- name = "fenshen",
	-- events = {sgs.CardUsed,sgs.CardResponsed,sgs.CardAsked},
	-- view_as_skill = fenshenvs,
	-- on_trigger = function(self,event,player,data)
	    -- local room = player:getRoom()
		-- local use = data:toCardUse()
		-- local cd = data:toCard()
		-- local card = data:toString()
	-- if event == sgs.CardUsed and use.card:getSkillName() == "fenshenvs" then
	    -- room:loseHp(player)
	-- end
	-- if event == sgs.CardResponsed and cd:getSkillName() == "fenshenvs" then
	    -- room:loseHp(player)
	-- end
	-- if event == sgs.CardAsked and card == "slash" and room:askForSkillInvoke(player,"fenshen") then
	    -- room:loseHp(player)
		-- if player:isAlive() then
		    -- local slash_card = sgs.Sanguosha:cloneCard ("slash",sgs.Card_NoSuit,0)
		    -- slash_card:setSkillName(self:objectName())
		    -- room:provide(slash_card)
			-- return true
		-- end
	-- end
	-- if event == sgs.CardAsked and card == "jink" and room:askForSkillInvoke(player,"fenshen") then
	    -- room:loseHp(player)
		-- if player:isAlive() then
		    -- local jink_card = sgs.Sanguosha:cloneCard ("jink",sgs.Card_NoSuit,0)
		    -- jink_card:setSkillName(self:objectName())
		    -- room:provide(jink_card)
			-- return true
		-- end
	-- end	
-- end
-- }
-- huoyancard=sgs.CreateSkillCard{
	-- name="huoyan",
	-- filter=function(self,targets,to_select,player)
		-- return not to_select:isKongcheng() and to_select:getSeat()~=player:getSeat() and not to_select:hasFlag("huoyantarget")
	-- end,
	-- on_use=function(self,room,source,targets)
		-- room:throwCard(self)
		-- local target=targets[1]							
		-- local card_ids=target:handCards()
		-- room:fillAG(card_ids,source)
		
		-- local card_id 						
		-- local newcard		
        -- card_id=room:askForAG(source, card_ids, true, "huoyan")                         
        -- newcard=sgs.Sanguosha:getCard(card_id)              
		-- source:invoke("clearAG")			
		-- room:throwCard(newcard)
		
		-- if newcard:inherits("BasicCard") then
		   	-- local duel=sgs.Sanguosha:cloneCard("duel",sgs.Card_NoSuit,0)
			-- duel:setSkillName("huoyan")
			-- local use=sgs.CardUseStruct()
			-- use.card=duel
			-- use.from=source
			-- use.to:append(target)
			-- room:useCard(use)			
			-- room:setPlayerFlag(target,"huoyantarget")
		-- end
		-- target:drawCards(1)
	-- end,
-- }
-- huoyan=sgs.CreateViewAsSkill{
	-- name="huoyan",
	-- n=0,	
	-- view_as=function()					
	    -- return huoyancard:clone()		
	-- end,
	-- enabled_at_play = function(self, player)
		-- return true
	-- end
-- }
-- luahuoyan=sgs.CreateTriggerSkill{
	-- name="#luahuoyan",
	-- events=sgs.PhaseChange,
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
		-- if player:getPhase()==sgs.Player_Play then
			-- for _,p in sgs.qlist(room:getOtherPlayers(player)) do
				-- room:setPlayerFlag(p,"-huoyantarget")
			-- end
		-- end
	-- end,
-- }
-- sunwukong:addSkill(fenshen)
-- sunwukong:addSkill(luahuoyan)
-- sunwukong:addSkill(huoyan)
-- sunshangxiang = sgs.General(extension, "sunshangxiang", "shu", 4, false)
-- honglian = sgs.CreateTriggerSkill{
	-- name = "honglian",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.CardUsed,sgs.CardResponsed},
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
	-- if event == sgs.CardUsed then
	    -- local use = data:toCardUse()
		-- if use.card:inherits("Slash") and not player:isKongcheng() then
			-- if (not room:askForSkillInvoke(player, self:objectName(), data)) then return false end
			 -- room:getThread():delay(1000)
            -- room:askForDiscard(player,"honglian",1,false,false)
			        -- local tos = sgs.SPlayerList()
					-- for _,p in sgs.qlist(room:getOtherPlayers(player)) do
					-- if player:inMyAttackRange(p) then
						-- tos:append(p)
						-- end
					-- end
			-- local target = room:askForPlayerChosen(player, tos, "honglian")
			-- local acard = room:askForCard(target,"jink","@honglian",data)
			    -- if target then
				    -- if not acard then
						-- local damage = sgs.DamageStruct()
						-- damage.damage = 1
						-- damage.nature = sgs.DamageStruct_Normal
						-- damage.from = player
						-- damage.to = target
						-- room:damage(damage)
					-- end
				-- end
			-- elseif use.card:inherits("Jink") then
			    -- if (not room:askForSkillInvoke(player, self:objectName(), data)) then return false end
				 -- room:getThread():delay(1000)
				-- local tot = sgs.SPlayerList()
					-- for _,q in sgs.qlist(room:getOtherPlayers(player)) do
					-- if player:canSlash(q, true) and not q:isProhibited(q, sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)) then
						-- tot:append(q)
						-- end
					-- end
			-- local targett = room:askForPlayerChosen(player, tot, "honglian")
		        -- local slashe = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
				-- slashe:setSkillName("honglian")
				-- local usee = sgs.CardUseStruct()
				-- usee.from = player
				-- usee.to:append(targett)
				-- usee.card = slashe
				-- player:turnOver()
				-- room:useCard(usee,false)
			-- end
		-- elseif event == sgs.CardResponsed then
		    -- local cd = data:toCard()
			-- if cd:inherits("Jink") then
			    -- if (not room:askForSkillInvoke(player, self:objectName(), data)) then return false end
				 -- room:getThread():delay(1000)
				-- local tou = sgs.SPlayerList()
					-- for _,r in sgs.qlist(room:getOtherPlayers(player)) do
					-- if player:canSlash(r, true) and not r:isProhibited(r, sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)) then
						-- tou:append(r)
						-- end
					-- end
			-- local targetr = room:askForPlayerChosen(player, tou, "honglian")
		        -- local slashr = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
				-- slashr:setSkillName("honglian")
				-- local user = sgs.CardUseStruct()
				-- user.from = player
				-- user.to:append(targetr)
				-- user.card = slashr
				-- player:turnOver()
				-- room:useCard(user,false)
			-- end
		-- end
	-- end
-- }
-- sunshangxiang:addSkill(honglian)
-- sunshangxiang:addSkill("hujia")
-- guili = sgs.General(extension, "guili", "wei", 3)
-- meiying = sgs.CreateTriggerSkill{
    -- name = "meiying",
	-- frequency = sgs.Skill_NotFrequent,	
	-- events = {sgs.CardEffected,sgs.FinishJudge},	
    -- on_trigger = function(self, event, player, data) 	
	-- if event == sgs.CardEffected then	
        -- local room = player:getRoom()
        -- local player = room:findPlayerBySkillName(self:objectName())	  
	    -- local effect=data:toCardEffect()
	    -- if effect.from:objectName()~=player:objectName()then   	       
			    -- if effect.card:inherits("Slash") or effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement") or effect.card:inherits("Duel")  then				
                            -- if (effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement")) and (effect.from:isNude()) then return false end
	                        -- if (effect.card:inherits("Slash") or effect.card:inherits("Duel")) and (effect.from:hasSkill("kongcheng") and effect.from:isKongcheng()) then return false end
                            -- if effect.card:inherits("Duel") and effect.from:hasSkill("nvquan")  then return false end
                            -- if ((effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement") or effect.card:inherits("Duel")) and effect.card:getSuit() == sgs.Card_Spade) and (effect.from:hasSkill("weimu")) then return false end
                            -- if effect.card:inherits("Slash") and effect.from:getMark("@feigong2") > 0  then return false end
                            -- if effect.card:inherits("Slash") and  (player:getMark("@feigong1") > 0 and effect.from:getMark("@feigong3") > 0)  then return false end
                            -- if effect.card:inherits("Slash") and effect.card:getSuit() == sgs.Card_Spade and effect.from:hasSkill("heimian") and  effect.from:getArmor()==nil then return false end
                            -- if effect.card:inherits("Slash") and  (effect.from:hasSkill("meiguo") and effect.from:getHp() == 1) then return false end
                            -- if effect.card:inherits("Slash") and effect.from:getMark("@tongling2") > 0 then return false end
                            -- if effect.card:inherits("Slash") and  effect.card:isBlack() and  (effect.from:hasSkill("zhuanquan") and effect.from:getArmor()==nil) then return false end									
							-- if effect.card:inherits("Snatch") and effect.from:hasSkill("qingmin")  then return false end									
                            -- if (effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement"))  and  (effect.from:hasSkill("kongju") and effect.from:getHandcardNum() < effect.from:getMaxHp())  then return false end			               				
                            -- if player:askForSkillInvoke(self:objectName(),data)then
						    	-- local msg = sgs.LogMessage()
	                            -- local judge = sgs.JudgeStruct()																								
	                            -- judge.reason = self:objectName()
	                            -- judge.who = player
	                            -- room:judge(judge)  
	                            -- local color1 
								-- if effect.card:isRed()then
	                               -- color1 ="red" 
								-- else
								   -- color1 ="black"
							    -- end 
	                            -- local color2 
							    -- if judge.card:isRed() then
	                                -- color2 ="red" 
							    -- else
    						    	-- color2 ="black"
							    -- end 
	                            -- if color1 == color2 then																   									
									-- local msg = sgs.LogMessage()
	                                -- local use = sgs.CardUseStruct()
	                                -- use.card = effect.card
	                                -- use.from = player
	                                -- use.to:append(effect.from)
	                                -- room:useCard(use)																			
								    -- return true
                                    -- end									
	                        -- end    
	            -- end
        -- end			
	-- end
-- end,
-- }
-- dadao = sgs.CreateTriggerSkill{
	-- name = "dadao",	
	-- frequency = sgs.Skill_Frequent,
	-- events = {sgs.FinishJudge},	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local judge = data:toJudge()
		-- local card = judge.card
		-- data_card = sgs.QVariant(0)
		-- data_card:setValue(card)
		-- if(player:askForSkillInvoke("dadao", data_card)) then
			-- player:obtainCard(judge.card)			
			-- return true
		-- end
		-- return false
	-- end
-- }
-- guili:addSkill(meiying)
-- guili:addSkill(dadao)
-- guijidiy = sgs.General(extension, "guijidiy", "qun", 4,true,true,true)
-- xyuanwansha=sgs.CreateTriggerSkill{
	-- name="xyuanwansha",
	-- events=sgs.AskForPeaches,
	-- frequency=sgs.Skill_Compulsory,
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
		-- local current=room:getCurrent()
		-- if current:isAlive() and current:hasSkill("xyuanwansha") then
			-- local dying=data:toDying()
			-- local who=dying.who			
			-- return not (player:getSeat()==current:getSeat() or player:getSeat()==who:getSeat())
		-- end
	-- end,
	-- can_trigger=function(self,player)
		-- return player and player:isAlive()
	-- end,
-- }
-- guijidiy:addSkill(xyuanwansha)	
-- spdiaochan = sgs.General(extension, "spdiaochan", "wei", 3, false)
-- LihunCard = sgs.CreateSkillCard{
	-- name = "LihunCard",	
	-- filter = function(self, selected, to_select)
		-- if not to_select:getGeneral():isMale() or #selected>=1 then
			-- return false
		-- end
		-- if not #selected == 0 then
			-- return false
		-- end		
		-- return true
	-- end, 
	-- on_effect = function(self, effect)
		-- local room = effect.from:getRoom()
		-- room:throwCard(self)		
		-- effect.from:turnOver()
		-- for _,cd in sgs.qlist(effect.to:getHandcards()) do
			-- room:moveCardTo(cd, effect.from, sgs.Player_Hand, false)
		-- end
		-- local value = sgs.QVariant()
		-- value:setValue(effect.to)
		-- room:setTag("LihunTarget", value)		
		-- effect.from:setFlags("Lihun_used")
	-- end,
-- }
-- lihunvs = sgs.CreateViewAsSkill{
	-- name = "lihunvs",
	-- n = 1,
	-- view_filter = function(self, selected, to_selected)
		-- return true
	-- end,
	-- view_as = function(self, cards)
	-- if #cards == 0 then return end
		-- local acard = LihunCard:clone()
		-- acard:addSubcard(cards[1])
		-- return acard
	-- end,
	-- enabled_at_play = function(self, player)
		-- return not player:hasUsed("#LihunCard")
	-- end,
-- }
-- lihun = sgs.CreateTriggerSkill{
	-- name = "lihun",
	-- events = sgs.PhaseChange,
	-- view_as_skill = lihunvs,
	-- priority = 3,
	-- can_trigger = function(self, player)
		-- return player:hasSkill(self:objectName()) and player:hasUsed("#LihunCard")
	-- end,
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- if event == sgs.PhaseChange and player:getPhase() == sgs.Player_Discard then
			-- local card_ids = sgs.IntList()
			-- local target = room:getTag("LihunTarget"):toPlayer()			
			-- if(player:getCards("he"):length() <= target:getHp()) then
				-- for _,cd in sgs.qlist(player:getCards("he")) do
					-- if player:isNude() then return false end
					-- local cd_id = cd:getEffectiveId()
					-- if room:getCardPlace(cd_id) == sgs.Player_Hand then
						-- room:moveCardTo(cd, target, sgs.Player_Hand, false)
					-- else
						-- room:moveCardTo(cd, target, sgs.Player_Hand, true)
					-- end
				-- end
			-- else
				-- local x = target:getHp()
				-- local card_ids = sgs.IntList()
				-- for _,cd in sgs.qlist(player:getCards("he")) do
					-- local cd_id = cd:getEffectiveId()
					-- card_ids:append(cd_id)
				-- end
				-- for v =1 , x, 1 do
					-- room:fillAG(card_ids, player)
					-- local card_id = room:askForAG(player, card_ids, false, self:objectName())
					-- local card = sgs.Sanguosha:getCard(card_id)
					-- if room:getCardPlace(card_id) == sgs.Player_Hand then
						-- room:moveCardTo(card, target, sgs.Player_Hand, false)
					-- else
						-- room:moveCardTo(card, target, sgs.Player_Hand, true)
					-- end
					-- card_ids:removeOne(card_id)
					-- player:invoke("clearAG")                    
				-- end
			-- end
		-- end
		-- return false
	-- end,
-- }
-- xbiyue = sgs.CreateTriggerSkill{
	-- name = "xbiyue",
	-- events = {sgs.PhaseChange},
	-- frequency = sgs.Skill_Frequent,	
	-- on_trigger = function(self, event, player, data)
		-- if(player:getPhase() == sgs.Player_Finish) then
			-- local room = player:getRoom()
			-- if(room:askForSkillInvoke(player, "xbiyue")) then
                -- room:playSkillEffect("biyue",2)				
				-- player:drawCards(1)
			-- end
		-- end
		-- return false
	-- end
-- }
-- spdiaochan:addSkill(lihun)
-- spdiaochan:addSkill(xbiyue)
-- zhongwuyan = sgs.General(extension, "zhongwuyan", "shu", 4, false)
-- zhenshecard=sgs.CreateSkillCard{
        -- name = "zhenshe",
        -- will_throw = false,
        -- once = true,
        -- filter = function(self,targets,to_select,player)
        -- if (#targets>0) then return false end
		-- if to_select:isKongcheng() then return false end
        -- return to_select:objectName() ~= player:objectName()
        -- end,
        -- on_effect=function(self,effect)          
                -- local room = effect.from:getRoom()
                -- if (effect.from:pindian(effect.to,"zhenshe",self)) then
				    -- room:setPlayerFlag(effect.from, "zhenshe_success")                  
					-- room:setPlayerFlag(effect.to, "zhenshet")					
					-- room:acquireSkill(effect.from, "paoxiao")					
                -- else
				    -- room:setPlayerFlag(effect.from, "zhenshe_failed")
					-- effect.from:skip(sgs.Player_Discard)
					-- if room:askForSkillInvoke(effect.from,"zhenshe") then
					-- local froms = sgs.SPlayerList()
					-- for _,r in sgs.qlist(room:getAlivePlayers()) do
					-- if r:getEquips():length() > 0 then
					    -- froms:append(r)
						-- end
					-- end
					-- local from = room:askForPlayerChosen(effect.from, froms, "zhenshe")
					-- if from:hasEquip() then
					-- local card_id = room:askForCardChosen(effect.from, from, "e", self:objectName())
					-- local card = sgs.Sanguosha:getCard(card_id)
					-- local place = room:getCardPlace(card_id)
					-- local tos = sgs.SPlayerList()
					-- local list = room:getAlivePlayers()
					-- for _,p in sgs.qlist(list) do
					-- if card:inherits("Weapon")  or card:inherits("Armor")  or card:inherits("DefensiveHorse")  or card:inherits("OffensiveHorse")  then
						-- tos:append(p)
						-- end
					-- end
					-- local tag = sgs.QVariant()
					-- tag:setValue(from)
					-- room:setTag("zhenshetarget", tag)
					-- local to = room:askForPlayerChosen(effect.from, tos, "zhenshe")
					-- if to then
						-- room:moveCardTo(card, to, place, true)
					-- end
					-- room:removeTag("zhenshetarget")
					-- end
				-- end
			-- end
        -- end,
-- }
-- zhenshevs=sgs.CreateViewAsSkill{
        -- name = "zhenshe",
        -- n = 1,
        -- view_filter = function(self, selected, to_select)
                -- return not to_select:isEquipped()
        -- end,
        -- view_as=function(self, cards)
		-- if #cards == 1 then
                        -- local acard = zhenshecard:clone()
                        -- acard:addSubcard(cards[1])                
                        -- acard:setSkillName("zhenshe")
                        -- return acard
						-- end
        -- end,
        -- enabled_at_play = function(self,player)
                -- return not (player:hasFlag("zhenshe_success") or player:hasFlag("zhenshe_failed"))
        -- end,
        -- enabled_at_response = function(self,player,pattern) 
                -- return false
        -- end
-- }
-- zhenshe=sgs.CreateTriggerSkill{
	-- name="zhenshe",
	-- events={sgs.PhaseChange,sgs.Death},
	-- view_as_skill = zhenshevs,
	-- on_trigger=function(self,event,player,data)
		-- local room = player:getRoom()
	-- if (event == sgs.PhaseChange and player:getPhase() == sgs.Player_Finish) or (event == sgs.Death) then
	    -- room:detachSkillFromPlayer(player,"paoxiao")
		-- for _,p in sgs.qlist(room:getOtherPlayers(player)) do		
		-- if p:hasFlag("zhenshet") then
		-- room:setPlayerFlag(p,"-zhenshet")
		-- end
		-- end
		-- end
	-- end,
-- }
-- zhenshedis = sgs.CreateDistanceSkill{
   -- name = "#zhenshedis",
   -- correct_func = function(self, from, to)
       -- if from:hasSkill("zhenshe") and from:hasFlag("zhenshe_success") and to and to:hasFlag("zhenshet") then
       -- return -998
    -- end
-- end,
-- }
-- zhongwuyan:addSkill(zhenshe)
-- zhongwuyan:addSkill(zhenshedis)
-- fuwan = sgs.General(extension, "fuwan", "shu",4)
-- moukui=sgs.CreateTriggerSkill{
-- name = "moukui",
-- frequency=sgs.Skill_NotFrequent,
-- events = {sgs.CardEffect},
-- can_trigger = function(self, player)
	-- return  player:hasSkill("moukui")	      
-- end,
-- on_trigger=function(self,event,player,data)
        -- local room=player:getRoom()	      
		-- local effect=data:toCardEffect()	
        -- local to = effect.to		
        -- local card=effect.card
		-- if card:inherits("Slash") then 
			-- if (room:askForSkillInvoke(player,self:objectName(),data)~=true) then return false end		  
            -- if room:askForChoice(player,self:objectName(),"moukuidraw+moukuithrow")=="moukuidraw" then		   
                   -- player:drawCards(1)
                   -- room:playSkillEffect("renshu",9) 				   
				-- if player:getMark("@moukui")>0 then				 
				   -- player:loseAllMarks("@moukui")
				-- end												
            -- else
			    -- if not to:isAllNude() then
				    -- card_id=room:askForCardChosen(player,to,"hej","moukui")
			        -- room:throwCard(card_id)
					-- player:gainMark("@moukui")
					-- room:playSkillEffect("wansha",9) 
				-- else
				    -- player:drawCards(1)	
					-- room:playSkillEffect("renshu",9) 
                    -- if player:getMark("@moukui")>0 then				 
				        -- player:loseAllMarks("@moukui")
				    -- end                    					
                -- end
            -- end
   		-- end	
-- end		
-- }
-- moukuibuff=sgs.CreateTriggerSkill{
	-- name="#moukuibuff",
	-- frequency=sgs.Skill_Compulsory,
	-- events={sgs.SlashMissed},
	-- on_trigger=function(self,event,player,data)
	-- local room=player:getRoom()
	-- local effect=data:toSlashEffect()
	-- local splayer=room:findPlayerBySkillName(self:objectName())
	-- if not splayer then return end	
	-- if splayer:getMark("@moukui")>0 then
        -- if effect.from:objectName() == splayer:objectName() then   
            -- splayer:loseAllMarks("@moukui")	 			
		    -- if not splayer:isAllNude() then
				-- card_id=room:askForCardChosen(effect.to,splayer,"hej","moukui")
			    -- room:throwCard(card_id)	                      
			-- end
		-- end
	-- end	
-- end	
-- }
-- moukuis = sgs.CreateTriggerSkill{
	    -- name = "#moukuis",
	    -- events = {sgs.Damage},
	    -- frequency = sgs.Skill_Compulsory,	
	    -- on_trigger = function(self,event,player,data)
                -- if event==sgs.Damage then 	
			        -- local room = player:getRoom()			      
				    -- local damage = data:toDamage()
				    -- local player=room:findPlayerBySkillName(self:objectName()) 
                    -- if not damage.card:inherits("Slash") then return false end						
				    -- if damage.from and damage.from:objectName() == player:objectName() then   					
					    -- if damage.from:getMark("@moukui")>0 then				 
				            -- damage.from:loseAllMarks("@moukui")
				        -- end                    						                      
					-- end	   						                          					
                -- end
        -- end				
-- }
-- fuwan:addSkill(moukui)
-- fuwan:addSkill(moukuibuff)
-- fuwan:addSkill(moukuis)
-- fuwan:addSkill("hujia")
-- shenguilvbu = sgs.General(extension, "shenguilvbu", "qun", 4)
-- shenqubuff = sgs.CreateTriggerSkill{
	-- name = "#shenqubuff",
    -- frequency = sgs.Skill_Frequent,	
	-- events = {sgs.Damaged},	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local damage = data:toDamage()				
		-- if not player:isKongcheng() then 		       
		-- room:askForUseCard(player, "peach","@shenqubuff")
		-- room:playSkillEffect("xiuluo",14)
		-- end	
        -- end		
-- }
-- shenqu=sgs.CreateTriggerSkill{
-- name="shenqu",
-- priority=1,
-- can_trigger=function() 
-- return true
-- end,
-- events={sgs.TurnStart}, 
-- on_trigger=function(self,event,player,data)        		
        -- if (event==sgs.TurnStart) then 
                -- local room=player:getRoom()        
                -- local shenguilvbu=room:findPlayerBySkillName(self:objectName())                      					 
				-- if shenguilvbu:getHandcardNum()<=shenguilvbu:getMaxHp() then											 
                -- if room:askForSkillInvoke(shenguilvbu,self:objectName()) then
                -- room:playSkillEffect("xiuluo",15)				
                -- shenguilvbu:drawCards(2)
                -- end
            -- end
        -- end
    -- end		
-- }
-- luawushuang = sgs.CreateTriggerSkill{
        -- name = "luawushuang",
        -- events = {sgs.CardEffect, sgs.CardFinished, sgs.CardAsked},
        -- can_trigger = function(self, player)
                -- return true
        -- end,        
        -- on_trigger = function(self, event, player, data)
                -- local room = player:getRoom()
                -- local skillowner = room:findPlayerBySkillName(self:objectName())
                -- if not skillowner then return false end              
                -- if event == sgs.CardEffect then
                        -- local effect = data:toCardEffect()
                        -- if effect.card:inherits("Duel") or effect.card:inherits("Slash") then
                                -- local value = sgs.QVariant()
                                -- if effect.from:objectName() == skillowner:objectName() then
                                        -- value:setValue(effect.to)
                                        -- room:setTag("WushuangTarget", value)
                                        -- value:setValue(effect.from)
                                        -- room:setTag("WushuangSource", value)
                                -- elseif effect.to:objectName() == skillowner:objectName() then
                                        -- value:setValue(effect.from)
                                        -- room:setTag("WushuangTarget", value)
                                        -- value:setValue(effect.to)
                                        -- room:setTag("WushuangSource", value)
                                -- end
                        -- end
                        -- return false
                -- elseif event == sgs.CardFinished then
                        -- room:removeTag("WushuangTarget")
                        -- room:removeTag("WushuangSource")
                        -- return false
                -- elseif event == sgs.CardAsked then
                        -- local pattern = data:toString()
                        -- local ask_str = ""
                        -- if pattern == "slash" then 
                                -- ask_str = "Slash"
                        -- elseif pattern == "jink" then
                                -- ask_str = "Jink"
                        -- else
                                -- return false
                        -- end
                        -- local reason = "@"..self:objectName()..pattern
                        -- local ask_card = nil
                        -- local wushuangTarget = room:getTag("WushuangTarget"):toPlayer()
                        -- local wushuangSource = room:getTag("WushuangSource"):toPlayer()
                        -- if wushuangTarget and player:objectName() == wushuangTarget:objectName() then						                               
								-- room:playSkillEffect("xiuluo",math.random(16, 17))								
                                -- ask_card = room:askForCard(wushuangTarget, ask_str, reason..":"..wushuangSource:getGeneralName())
                        -- else
                                -- return false
                        -- end
                        -- if ask_card == nil then
                                -- room:provide(nil)
                                -- return true
                        -- else
                                -- return false                        
                        -- end
                -- end
        -- end,
-- }
-- jiwucard = sgs.CreateSkillCard{
	-- name = "jiwu",
	-- target_fixed = true,
	-- will_throw=true,
	-- on_use=function(self,room,source,targets)
	    -- room:throwCard(self)
		-- room:playSkillEffect("xiuluo",18)
	    -- local shenguilvbu=source 								
		-- local choices = {}
		-- if not shenguilvbu:hasFlag("qiangxiEX")  then
			-- table.insert(choices,"qiangxiEX")
		-- end
		-- if not shenguilvbu:hasFlag("yuanwansha") then
			-- table.insert(choices,"yuanwansha")
		-- end							
		-- if not shenguilvbu:hasFlag("lualieren") then
			-- table.insert(choices,"lualieren")
		-- end							
		-- if not shenguilvbu:hasFlag("luaxuanfeng") then
			-- table.insert(choices,"luaxuanfeng")
		-- end							
		-- local choice = room:askForChoice(shenguilvbu,"jiwu",table.concat(choices,"+"))		
		-- if choice == "yuanwansha" then
			-- room:setPlayerFlag(shenguilvbu, "yuanwansha")
			-- room:acquireSkill(shenguilvbu, "yuanwansha")			
		-- end
		-- if choice == "qiangxiEX" then
			-- room:setPlayerFlag(shenguilvbu, "qiangxiEX")
			-- room:acquireSkill(shenguilvbu, "qiangxiEX")           			
		-- end							
		-- if choice == "lualieren" then
			-- room:setPlayerFlag(shenguilvbu, "lualieren")
			-- room:acquireSkill(shenguilvbu, "lualieren")           			
		-- end							
		-- if choice == "luaxuanfeng" then
			-- room:setPlayerFlag(shenguilvbu, "luaxuanfeng")
			-- room:acquireSkill(shenguilvbu, "luaxuanfeng")          			
		-- end						
	-- end	
-- }
-- jiwu = sgs.CreateViewAsSkill{
	-- name = "jiwu" ,
    -- n=1,
	-- view_filter = function(self, selected, to_select)
	-- if to_select:isEquipped() then return false end                       
		-- return true 
	-- end,
	-- view_as = function(self, cards)
		-- if(#cards ~= 1) then return nil end
		-- local lcard = jiwucard:clone()
		-- lcard:addSubcard(cards[1])
		-- lcard:setSkillName(self:objectName())
		-- return lcard
	-- end,
	-- enabled_at_play = function(self,player)
		-- return  ((not player:hasSkill("qiangxiEX")) or (not player:hasSkill("yuanwansha")) or (not player:hasSkill("lualieren")) or (not player:hasSkill("luaxuanfeng")))
	-- end
-- }
-- jiwuclear = sgs.CreateTriggerSkill{
	-- name = "#jiwuclear",
	-- frequency = sgs.Skill_Frequent,
	-- events = {sgs.PhaseChange},
	-- can_trigger = function(self,player)
		-- return player and player:isAlive() and player:hasSkill(self:objectName())
	-- end,
	-- on_trigger = function(self, event, player, data)	
	    -- local room = player:getRoom()						
		-- if event == sgs.PhaseChange and player:getPhase() == sgs.Player_Finish then 
		    -- if player:hasSkill("qiangxiEX")  or  player:hasSkill("yuanwansha") or player:hasSkill("lualieren") or player:hasSkill("luaxuanfeng") or player:hasFlag("qiangxiEX") or player:hasFlag("yuanwansha") or player:hasFlag("lualieren") or player:hasFlag("luaxuanfeng") then 
	            -- room:detachSkillFromPlayer(player,"qiangxiEX")
			    -- room:detachSkillFromPlayer(player,"yuanwansha")
				-- room:detachSkillFromPlayer(player,"lualieren")
				-- room:detachSkillFromPlayer(player,"luaxuanfeng")
				-- room:setPlayerFlag(player,"-qiangxiEX")
				-- room:setPlayerFlag(player,"-yuanwansha")
				-- room:setPlayerFlag(player,"-lualieren")
				-- room:setPlayerFlag(player,"-luaxuanfeng")
			-- end
        -- end			
    -- end	
-- }
-- shenguilvbu:addSkill(luawushuang)
-- shenguilvbu:addSkill(shenqubuff)
-- shenguilvbu:addSkill(shenqu)
-- shenguilvbu:addSkill(jiwu)
-- shenguilvbu:addSkill(jiwuclear)
-- mamengqi = sgs.General(extension, "mamengqi", "shu", 4)
-- benxi=sgs.CreateTriggerSkill{
 -- name = "benxi",
 -- frequency = sgs.Skill_Compulsory,
 -- events = {sgs.SlashProceed},
 -- on_trigger=function(self,event,player,data)
    -- local room = player:getRoom()
	-- local effect=data:toSlashEffect()	
    -- if event==sgs.SlashProceed then 
        -- local effect=data:toSlashEffect()	 
	    -- local acard = room:askForCard(effect.to, "EquipCard", "@benxi", data)	
        -- room:playSkillEffect("xiuluo",19) 		
	    -- if acard==nil then 	   
		    -- room:slashResult(effect, nil)	 	      
            -- return true
		-- else
		    -- return false			 	 
        -- end
    -- end
 -- end
-- }
-- benxibuff=sgs.CreateDistanceSkill{
-- name= "#benxibuff",
-- correct_func=function(self,from,to)
	-- if from:hasSkill("benxi") then 
	    -- return -1	
	-- end
-- end
-- }
-- yaozhan_card=sgs.CreateSkillCard{
-- name="yaozhan_card",
-- target_fixed=false,
-- will_throw=false,
-- once=true,
-- filter = function(self,targets,to_select,player)
	-- if(to_select:getSeat() == player:getSeat())then return false end
	-- if #targets>0 then return false end
	-- if to_select:isKongcheng() then return false end	
    -- return true	
-- end,
-- on_effect=function(self,effect)
  -- local room = effect.from:getRoom()
  -- room:playSkillEffect("xiuluo",20) 
  -- local success = effect.from:pindian(effect.to, "yaozhan", self)
  -- if(success) then  
    -- local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
	-- slash:setSkillName("yaozhan")			
	-- local card_use = sgs.CardUseStruct()
	-- card_use.from = effect.from
	-- card_use.to:append(effect.to)
	-- card_use.card = slash
	-- room:useCard(card_use, false)						  	   
  -- else    
   -- local slash=room:askForCard(effect.to,"slash","yaozhan")    
        -- if slash then						
			-- local use=sgs.CardUseStruct()
			 	-- use.card = slash
			 	-- use.from = effect.to
			 	-- use.to:append(effect.from)
			    -- room:useCard(use,false)	
        -- end				
  -- end
-- end
-- }
-- yaozhan=sgs.CreateViewAsSkill{
-- name="yaozhan",
-- n=1,
-- view_filter=function(self, selected, to_select)
	-- return not  to_select:isEquipped()
-- end,
-- view_as=function(self, cards)
	-- if #cards==0 then return nil end
	-- local ZXcard=yaozhan_card:clone()	
	-- ZXcard:addSubcard(cards[1])    	
	-- return ZXcard
-- end,
-- enabled_at_play=function(self, player)
		-- return not player:hasUsed("#yaozhan_card")		
-- end,
-- enabled_at_response=function(self,pattern) 
	-- return false 
-- end
-- }
-- mamengqi:addSkill(benxi)
-- mamengqi:addSkill(benxibuff)
-- mamengqi:addSkill(yaozhan)
-- sgkzhouyu = sgs.General(extension, "sgkzhouyu", "qun", 4)
-- qinyinxx  = sgs.CreateTriggerSkill{
	    -- name = "qinyinxx",	    
		-- events = {sgs.PhaseChange},
	    -- frequency=sgs.Skill_NotFrequent,
        -- can_trigger = function(self, player)
	         -- return player:hasSkill("qinyinxx")	  
        -- end,		
	    -- on_trigger = function(self,event,player,data)  
            -- local room = player:getRoom()
            -- local a = player:getEquips():length()
            -- local b = player:getHandcardNum()			
		    -- if event == sgs.PhaseChange and player:getPhase()==sgs.Player_Discard then  
                -- if (not room:askForSkillInvoke(player,self:objectName())) then return false end	
                -- room:playSkillEffect("qinlv", 1)				
                -- if room:askForChoice(player,"qinyinxx","qinyinxxdraw+qinyinxxthrow")=="qinyinxxdraw" then	
				    -- player:drawCards(2)				     				                   
					-- local players=sgs.SPlayerList()
					-- for _,p in sgs.qlist(room:getAlivePlayers()) do						   
						-- room:loseHp(p,1)
                    -- end                
                -- else    
                    -- if a+b>=2 then				
			            -- room:askForDiscard(player, "qinyinxx", 2, false, true)
						-- local players=sgs.SPlayerList()
					    -- for _,p in sgs.qlist(room:getAlivePlayers()) do													   				
			                    -- local recover = sgs.RecoverStruct()
			                    -- recover.who = p
			                    -- recover.recover = 1
			                    -- room:recover(p,recover)
				        -- end
					-- else
					    -- player:drawCards(2)				     				                   
					    -- local players=sgs.SPlayerList()
					    -- for _,p in sgs.qlist(room:getAlivePlayers()) do						   
						    -- room:loseHp(p,1)
                        -- end                												                 
					-- end
				-- end						                   		
		    -- end
        -- end			
-- }	
-- yeyanxxcard = sgs.CreateSkillCard{
	-- name = "yeyanxxcard",
	-- targer_fixed = false,
	-- will_throw = true,
	-- filter = function(self,targets,to_select)	    
	    -- if to_select:objectName() == sgs.Self:objectName() then return false end			
		-- return #targets < 2	
	-- end,
	-- on_effect = function(self,effect)
	    -- local x = self:subcardsLength()	
		-- local source = effect.from
		-- local dest = effect.to
		-- local room = source:getRoom()  
        -- if x>=3 then		    
			-- if source:getMark("@yeyanxxused") > 0 then
			-- room:loseHp(source,3)		
			-- source:loseAllMarks("@yeyanxxused")  			
			-- end					   
			-- if not source:isAlive() then return end
		    -- local damage=sgs.DamageStruct()
		    -- damage.nature=sgs.DamageStruct_Normal 
	        -- damage.chain=true 
		    -- damage.damage=x	     		
		    -- damage.from=source
		    -- damage.to = dest
		    -- room:damage(damage) 
            -- source:loseAllMarks("@yeyanxx")            			                      						                  			
        -- else	
            -- local damage=sgs.DamageStruct()
		    -- damage.nature=sgs.DamageStruct_Normal 
	        -- damage.chain=true 
		    -- damage.damage=x	     		
		    -- damage.from=source
		    -- damage.to = dest
		    -- room:damage(damage)       
            -- source:loseAllMarks("@yeyanxx")						 		
	    -- end
	-- end
-- }
-- yeyanxxvs = sgs.CreateViewAsSkill{
	-- name = "yeyanxxvs",
	-- n = 4,
	-- view_filter = function(self, selected, to_select)
		-- if #selected >= 4 then return false end
            -- if to_select:isEquipped() then return false end
            -- for _,card in ipairs(selected) do
                -- if card:getSuit() == to_select:getSuit() then return false end
            -- end
            -- return true
        -- end,
	-- view_as = function(self, cards)
	    -- if #cards == 0 then return nil end	
	    -- if #cards > 4 then return nil end			
		-- local YCard = yeyanxxcard:clone()
		-- for _,card in ipairs(cards) do
			-- YCard:addSubcard(card)
		-- end
		-- return YCard
		-- end,			
	-- enabled_at_play = function(self, player)
		-- return player:getMark("@yeyanxx") == 1
	    -- end,
-- }	
-- yeyanxx = sgs.CreateTriggerSkill{
	-- name = "yeyanxx" ,
	-- frequency = sgs.Skill_Limited,
	-- events = {sgs.GameStart},
	-- view_as_skill = yeyanxxvs,
	-- on_trigger = function(self, event, player, data)
		-- player:gainMark("@yeyanxx")	
		-- player:gainMark("@yeyanxxused")  		
	-- end
-- }	
-- sgkzhouyu:addSkill(qinyinxx)
-- sgkzhouyu:addSkill(yeyanxx)
-- spguanyu = sgs.General(extension, "spguanyu", "shu", 4)
-- xxbudao = sgs.CreateTriggerSkill{
    -- name = "xxbudao",
    -- events = {sgs.Damage},
    -- priority=3,	
    -- can_trigger=function(self,player)
	-- return true
    -- end, 
-- on_trigger = function(self,event,player,data)
    -- local room = player:getRoom()	
    -- local selfplayer=room:findPlayerBySkillName(self:objectName())   
    -- if event == sgs.Damage then  					  
    -- local damage = data:toDamage()		
    -- if selfplayer:getPhase()~=sgs.Player_NotActive then return end	
    -- if damage.card:inherits("Slash") and damage.to:isAlive() then 
    -- if (not selfplayer:isNude()) and selfplayer:inMyAttackRange(damage.to) then 	
        -- if room:askForSkillInvoke(selfplayer,"xxbudao",data) then    
            -- local slash=room:askForCard(selfplayer,"slash","@xxbudao")  
            -- if slash~=nil  then	
                -- room:playSkillEffect("budao",math.random(1, 2))              			
                -- local use=sgs.CardUseStruct()
                -- use.card = slash
                -- use.from = selfplayer
                -- use.to:append(damage.to)
                -- room:useCard(use,false)
            -- end              			       		
        -- end	   						                          					   
    -- end
    -- end
    -- end	
-- end	
-- }	
-- xxxbudao = sgs.CreateTriggerSkill{
	-- name = "#xxxbudao",	
	-- events = {sgs.Damaged},	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local damage = data:toDamage()
		-- if player:getPhase()~=sgs.Player_NotActive then 		
		-- if damage.card:inherits("Slash") and player:isAlive() then
		-- if not player:isNude()  then 			
		-- if room:askForSkillInvoke(player, "xxbudao",data) then 		
		-- local slash=room:askForCard(player,"slash","@xxbudao")  
        -- if slash~=nil  then	
                -- room:playSkillEffect("budao",math.random(1, 2))               
                -- local use=sgs.CardUseStruct()
                -- use.card = slash
                -- use.from = player
                -- use.to:append(player)
                -- room:useCard(use,false)
				-- end
			-- end
		-- end
	-- end
	-- end
-- end
-- }
-- chituma=sgs.CreateDistanceSkill{
-- name= "chituma",
-- correct_func=function(self,from,to)
	-- if from:hasSkill("chituma") then 
	    -- return -1	
	-- end
-- end
-- }
-- spguanyu:addSkill(xxxbudao)
-- spguanyu:addSkill(xxbudao)
-- spguanyu:addSkill(chituma)
-- spguanyu:addSkill("hujia")
-- srhuangyueying = sgs.General(extension,"srhuangyueying","wei",3,false)
-- srqicai = sgs.CreateTriggerSkill{
	-- name = "srqicai",
	-- events = {sgs.CardLost},
	-- frequency = sgs.Skill_NotFrequent,	
	-- on_trigger = function(self, event, player, data)
		-- move = data:toCardMove()
		-- if(move.from_place == sgs.Player_Hand) then
			-- local room = player:getRoom()
			-- if(room:askForSkillInvoke(player, "srqicai")) then
			    -- local judge=sgs.JudgeStruct()
                -- judge.pattern=sgs.QRegExp("(.*):(heart|diamond):(.*)")
                -- judge.good=true
                -- judge.reason=self:objectName()
                -- judge.who=player
                -- room:judge(judge)
                -- if (judge:isGood()) then				
					-- room:playSkillEffect("xiuluo",21)						
				    -- player:drawCards(1)					
			    -- end
		    -- end
	    -- end
	-- end
-- }	
-- srhuangyueying:addSkill(srqicai)	
-- srhuangyueying:addSkill("jiuyuanf")
-- sgkguanyinping = sgs.General(extension, "sgkguanyinping", "shu", 3, false)
-- LuaXueji_Card = sgs.CreateSkillCard{
	-- name = "LuaXueji_Card" ,
	-- filter = function(self, targets, to_select)
		-- if #targets >= sgs.Self:getLostHp() then return false end
		-- if to_select:objectName() == sgs.Self:objectName() then return false end	
		-- return true  
	-- end ,
	-- on_use = function(self, room, source, targets)
	    -- room:throwCard(self)
		-- local damage = sgs.DamageStruct()
		-- damage.damage=1
		-- damage.from = source
		-- damage.reason = "LuaXueji"
		-- for _, p in ipairs(targets) do
			-- damage.to = p
			-- room:damage(damage)
		-- end
		-- for _, p in ipairs(targets) do
			-- if p:isAlive() then
				-- p:drawCards(1)
			-- end
		-- end
	-- end
-- }
-- LuaXueji = sgs.CreateViewAsSkill{
	-- name = "LuaXueji" ,
	-- n = 1 ,
	-- view_filter = function(self, selected, to_select)
		-- if #selected >= 1 then return false end
		-- if to_select:isEquipped() then return false end                        
		-- return to_select:isRed() and (not sgs.Self:isJilei(to_select))
	-- end ,
	-- view_as = function(self, cards)
		-- if #cards ~= 1 then return nil end
		-- local first = LuaXueji_Card:clone()
		-- first:addSubcard(cards[1]:getId())
		-- first:setSkillName(self:objectName())
		-- return first
	-- end ,
	-- enabled_at_play = function(self, player)
		-- return (player:getLostHp() > 0) and (not player:isNude()) and (not player:hasUsed("#LuaXueji_Card"))
	-- end
-- }
-- longpao = sgs.CreateTriggerSkill{
	-- name = "longpao",
	-- frequency=sgs.Skill_Compulsory,
	-- events = {sgs.SlashMissed},
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local effect = data:toSlashEffect()		
		-- if player:getPhase()==sgs.Player_NotActive then return false end		      	   
		    -- room:askForUseCard(player, "slash","@longpao")
		-- end		
-- }
-- LuaWujiCount = sgs.CreateTriggerSkill{
	-- name = "#LuaWujiCount",
	-- frequency=sgs.Skill_Compulsory,
	-- events = {sgs.Damage},	
	-- can_trigger = function(self,player)
		-- return player:hasSkill("#LuaWujiCount")
	-- end,				
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local damage = data:toDamage()
		-- if event == sgs.Damage then
			-- local damage = data:toDamage()	          		
			-- if player:getPhase()==sgs.Player_NotActive then return false end				
			-- if player and player:isAlive() and (player:getMark("LuaWuji")==0) then				 
			    -- player:gainMark("@LuaWujidamage", damage.damage)										
			-- end
		-- end	
	-- end 	
-- }
-- LuaWuji = sgs.CreateTriggerSkill{
	-- name = "LuaWuji",
	-- frequency = sgs.Skill_Wake,
	-- events = {sgs.PhaseChange},
	-- can_trigger = function(self, player)
		-- return player and player:isAlive() and player:hasSkill("LuaWuji")				
	-- end,
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()	
        -- if event == sgs.PhaseChange and player:getPhase()==sgs.Player_Finish then
		-- if player:getMark("@LuaWujidamage") < 3 then
		-- player:loseAllMarks("@LuaWujidamage")		
        -- elseif player:getMark("@LuaWujidamage") >= 3 and player:getMark("LuaWuji")==0 then			
		-- player:addMark("LuaWuji")					
	    -- local log = sgs.LogMessage()
		-- log.type = "#LuaWujiMAXHP"
		-- log.from = player
		-- log.arg = tonumber(player:getMaxHP()+1)
		-- log.arg2 = self:objectName()
		-- room:setPlayerProperty(player, "maxhp", sgs.QVariant(player:getMaxHP() + 1))
		-- room:sendLog(log)		
		-- local recover = sgs.RecoverStruct()
		-- recover.who = player
		-- room:recover(player, recover)
		-- room:detachSkillFromPlayer(player, "longpao")
		-- player:loseAllMarks("@LuaWujidamage")
		-- end 
        -- end
        -- end    	
-- }
-- sgkguanyinping:addSkill(LuaXueji)
-- sgkguanyinping:addSkill(longpao)
-- sgkguanyinping:addSkill(LuaWujiCount)
-- sgkguanyinping:addSkill(LuaWuji)
-- sgkguanyinping:addSkill("hujia")
-- xhuamulan = sgs.General(extension, "xhuamulan", "wei", 3, false)
-- xtujin = sgs.CreateDistanceSkill{
   -- name = "xtujin",
   -- correct_func = function(self, from, to)
       -- if from:hasSkill("xtujin") and to:getHandcardNum() >= from:getHandcardNum() then
	   -- return -998
    -- end
	   -- if to:hasSkill("xtujin") and to:getHandcardNum() <= from:getHandcardNum() then
	   -- return 1
	-- end
-- end,
-- }
-- jianfeng = sgs.CreateTriggerSkill{
	-- name = "jianfeng",
	-- events = {sgs.Predamage},
	-- frequency = sgs.Skill_NotFrequent,
-- on_trigger = function(self, event, player, data)
		-- local room=player:getRoom()
		-- local damage = data:toDamage()
		-- local card = damage.card
		-- if(event == sgs.Predamage and card:inherits("Slash")) then
		  -- if (not room:askForSkillInvoke(player, self:objectName(), data)) then return false end		  
		    -- damage.damage = damage.damage+(damage.to:getEquips():length())
				-- data:setValue(damage)
				-- return false
	-- end
-- end,
-- }
-- xhuamulan:addSkill(xtujin)
-- xhuamulan:addSkill(jianfeng)
-- xhuamulan:addSkill("jiuyuanf")
-- zhouzhiruo = sgs.General(extension, "zhouzhiruo", "wei", 3, false)
-- lengao = sgs.CreateTriggerSkill{
	-- name = "lengao",
	-- events = {sgs.SlashEffected},
	-- on_trigger=function(self,event,player,data)
		-- local room = player:getRoom()
		-- local effect = data:toSlashEffect()
	-- if player:getCards("he"):length() >= player:getHp() and room:askForSkillInvoke(player,self:objectName(),data) then
	    -- room:askForDiscard(player,self:objectName(),player:getHp(),false,true)
		-- player:drawCards(effect.from:getHp())
	-- end
	-- end,
-- } 
-- jiuyang = sgs.CreateTriggerSkill{
	-- name = "jiuyang",
	-- frequency=sgs.Skill_Compulsory,
	-- events = {sgs.CardResponsed,sgs.SlashProceed,sgs.CardFinished},
	-- on_trigger=function(self,event,player,data)
		-- local room = player:getRoom()
		-- local card = data:toCard()
		-- local effect = data:toSlashEffect()
		-- local use = data:toCardUse()
	-- if event == sgs.CardResponsed and card:inherits("Jink") then
	    -- room:setPlayerMark(player,"jiuyang",1)
	-- elseif event == sgs.SlashProceed and player:getMark("jiuyang") > 0 then
	    -- room:setPlayerMark(player,"jiuyang",0)
		-- effect.nature = sgs.DamageStruct_Thunder
		-- data:setValue(effect)
		-- room:slashResult(effect, nil)
		-- return true
	-- elseif event == sgs.CardFinished and use.card:inherits("Slash") and player:getMark("jiuyang") > 0 then
	    -- room:setPlayerMark(player,"jiuyang",0)
	-- end
	-- end,
-- } 
-- yinzhua=sgs.CreateTriggerSkill{
-- name="yinzhua",
-- events={sgs.AskForPeaches},
-- frequency = sgs.Skill_Compulsory,
-- on_trigger=function(self,event,player,data)
	-- local room=player:getRoom()	
	-- local selfplayer=room:findPlayerBySkillName(self:objectName())
	-- local otherplayers=room:getOtherPlayers(selfplayer)	
	-- if event==sgs.AskForPeaches then
		-- if player:objectName()==selfplayer:objectName() then return false end
		-- return true
	-- end
-- end,
-- can_trigger=function(self, player)
	-- local room=player:getRoom()
	-- local selfplayer=room:findPlayerBySkillName(self:objectName())
	-- if selfplayer==nil then return false end
	-- return selfplayer:isAlive()
-- end
-- }
-- local skill=sgs.Sanguosha:getSkill("yinzhua")
-- if not skill then
	-- local skillList=sgs.SkillList()
	-- skillList:append(yinzhua)
	-- sgs.Sanguosha:addSkills(skillList)
-- end
-- jiuyangbuff = sgs.CreateTriggerSkill{
	-- name = "#jiuyangbuff",
    -- frequency = sgs.Skill_Compulsory,	
	-- events = {sgs.Damaged},	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local damage = data:toDamage()
		-- local from = damage.from 		
		-- if (event == sgs.Damaged and from:getGeneral():isMale() and player:getMark("@jiuyang") == 0) then             		
		    -- room:acquireSkill(player,"yinzhua")		   
            -- room:detachSkillFromPlayer(player,"jiuyang")
            -- player:addMark("@jiuyang")			
		-- end
	-- end
-- }
-- zhouzhiruo:addSkill(jiuyangbuff)
-- zhouzhiruo:addSkill(jiuyang)
-- zhouzhiruo:addSkill(lengao)
-- zhouzhiruo:addSkill("jiuyuanf")
spwenjiang = sgs.General(extension, "spwenjiang", "shu", 3, false)
xiezhengcard=sgs.CreateSkillCard{
name="xiezhengcard",
target_fixed=false,
will_throw=false,
filter=function(self,targets,to_select)
	if #targets>0 then return false end
	if to_select:isKongcheng() then return false end	
    return true	
end,
on_effect=function(self,effect)
    local room = effect.from:getRoom()	
	local id = self:getSubcards():first()
	local suit = sgs.Sanguosha:getCard(id):getSuit()	
	room:showCard(effect.from, id)   
    room:playSkillEffect("zhenglue",2)	
    local carda=sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 1)
	local cardb=sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 2)			 
    local card_ids = effect.from:handCards()
    --room:showAllCards(effect.from)	
	for _,id in sgs.qlist(card_ids) do
	    local c = sgs.Sanguosha:getCard(id)
		if c:getSuit() == suit then								
			carda:addSubcard(id)   
		end
	end																														
	local ids = effect.to:handCards()					
	--room:showAllCards(effect.to)																									   				
	for _,id in sgs.qlist(ids) do
	    local c = sgs.Sanguosha:getCard(id)
	    if c:getSuit() == suit then	
            room:setPlayerFlag(effect.from,"xiezhenguse")		
		    cardb:addSubcard(id)   
		end
	end	
	if not effect.from:hasFlag("xiezhenguse") then	
	    effect.to:obtainCard(carda)
		room:setPlayerFlag(effect.from,"xiezheng")        
    else
        effect.to:obtainCard(carda)
		effect.from:obtainCard(cardb)
		room:setPlayerFlag(effect.from,"xiezheng")
        room:setPlayerFlag(effect.from,"-xiezhenguse")	       			
	end						 
end
}  
xiezheng = sgs.CreateViewAsSkill{
	name = "xiezheng",
	n = 1,
	view_filter = function(self, selected, to_select)	
	    return not to_select:isEquipped()			
	end,
	view_as = function(self, cards)
	    if #cards==0 then return nil end
		if #cards == 1 then
			local card = xiezhengcard:clone()
			card:addSubcard(cards[1])
			card:setSkillName(self:objectName())			
			return card
		end
	end,
	enabled_at_play=function()   
	    if sgs.Self:getPhase()==sgs.Player_Finish then sgs.Self:getRoom():setPlayerFlag(sgs.Self,"-xiezheng") end 
	    return not (sgs.Self:hasFlag("xiezheng") or sgs.Self:isKongcheng())
    end,
}
wencai=sgs.CreateTriggerSkill{
	name="wencai",			
	frequency = sgs.Skill_NotFrequent,
	events={sgs.DrawNCards,sgs.PhaseChange},
	can_trigger = function(self, player)
	    return player:hasSkill("wencai")	      
    end,
	on_trigger=function(self,event,player,data)				
		if event==sgs.DrawNCards then 	
		    local room=player:getRoom()
		    local player=room:findPlayerBySkillName(self:objectName()) 
		    local x = data:toInt()
			if(room:askForSkillInvoke(player, "wencai")) then			
			    room:playSkillEffect("zhenglue",1)	
				player:setFlags("wencai")				
			    data:setValue(x+2)
			end
		end		
		if event==sgs.PhaseChange then 	
		    local room=player:getRoom()
		    local player=room:findPlayerBySkillName(self:objectName()) 					
		    if player:getPhase()~=sgs.Player_Discard then return end	
			if(player:hasFlag("wencai") and player:isAlive()) then				
		    local x=player:getHandcardNum()-player:getHp()				
			if player:getHp()<=2 then
			    player:throwAllHandCards()
				room:playSkillEffect("beide",1)
			else									
			    room:askForDiscard(player,"wencai",x+2,false,false)			
			    room:playSkillEffect("beide",1)
				return true
			end		
		end
        end		
	end
}
spwenjiang:addSkill(wencai)
spwenjiang:addSkill(xiezheng)
spwenjiang:addSkill("hujia")
-- srluxun = sgs.General(extension, "srluxun", "shu", 3)
-- srdailao_card = sgs.CreateSkillCard{
	-- name = "srdailao_card", 
	-- target_fixed = false, 
	-- will_throw = false, 
	-- filter = function(self, targets, to_select) 
		-- return #targets == 0 and to_select:objectName() ~= sgs.Self:objectName()
	-- end,
	-- on_use = function(self, room, source, targets)			
		-- local room = source:getRoom() 	
		-- room:playSkillEffect("xiuluo",math.random(22, 23))   
		-- local choice = ""
		-- if source:isKongcheng() or targets[1]:isKongcheng() then 
			-- choice = "srdraw"
		-- else
			-- room:setPlayerFlag(targets[1],"dailao_target")
			-- choice = room:askForChoice(source,"srdailao","srdraw+srdiscard")
		-- end
		-- if choice == "srdraw" then
			-- if source:isAlive() then source:drawCards(1) end
			-- if targets[1]:isAlive() then targets[1]:drawCards(1) end
		-- else
			-- if not source:isNude() then
				-- room:askForDiscard(source,"srdailao",1,false,true)
			-- end
			-- if not targets[1]:isNude() then
				-- room:askForDiscard(targets[1],"srdailao",1,false,true)
			-- end
		-- end
		-- if source:isAlive() then source:turnOver() end
		-- if targets[1]:isAlive() then targets[1]:turnOver() end		
	-- end
-- }
-- srdailao = sgs.CreateViewAsSkill{
	-- name = "srdailao", 
	-- n = 0, 
	-- view_as = function(self, cards)
		-- return srdailao_card:clone()
	-- end, 
	-- enabled_at_play = function(self, player)
		-- return not player:hasUsed("#srdailao_card")
	-- end
-- }
-- srruya=sgs.CreateTriggerSkill{ 
	-- name="srruya",
	-- events=sgs.CardLost,  
	-- frequency=sgs.Skill_NotFrequent,
	-- on_trigger = function(self,event,player,data)
		-- local room=player:getRoom()
		-- local move=data:toCardMove()		
		-- if player:isKongcheng() and move.from_place==sgs.Player_Hand then        
			-- if room:askForSkillInvoke(player,self:objectName())==true then 		    
				-- local x = player:getMaxHP()
				-- player:drawCards(x)
                -- room:playSkillEffect("xiuluo",24)				
				-- player:turnOver()
			-- end	
		-- end	
	-- end	
-- }
-- srluxun:addSkill(srdailao)	
-- srluxun:addSkill(srruya)	
-- srluxun:addSkill("hujia")
xnianshou = sgs.General(extension, "xnianshou", "god", 4)
shiren = sgs.CreateTriggerSkill{
	name = "shiren",	
	events = {sgs.DrawNCards,sgs.TurnStart},
	frequency = sgs.Skill_Frequent,	
	can_trigger = function(self, player)
	    return player:hasSkill("shiren")	
		
    end,	
	on_trigger = function(self, event, player, data)
	if (event==sgs.DrawNCards) then 
		local room = player:getRoom()
		local player=room:findPlayerBySkillName(self:objectName()) 
		local x = data:toInt()
		if(room:askForSkillInvoke(player, "shiren")) then	
            room:playSkillEffect("wansha",12)						
			data:setValue(1)
		end
	end
	if (event==sgs.TurnStart) then 
	   local room = player:getRoom()
	   local player=room:findPlayerBySkillName(self:objectName()) 	   
            player:setMark("mm",0)
	end
end
}
shirenbuff=sgs.CreateTriggerSkill{
name="#shirenbuff",
priority=2,
events = {sgs.HpLost,sgs.Damage},
frequency = sgs.Skill_Frequent,
can_trigger=function() 
   return true
end,
on_trigger=function(self,event,player,data)
        local room=player:getRoom()        
        local xnianshou=room:findPlayerBySkillName(self:objectName()) 
		if event==sgs.HpLost then 
            if xnianshou:getPhase()~=sgs.Player_NotActive then return false end				                    
            if room:askForSkillInvoke(xnianshou,"shiren") then                   
                if xnianshou:getMark("mm") > 3 then return false end
                    xnianshou:drawCards(1)	
                    room:playSkillEffect("wansha",12)									
				    xnianshou:addMark("mm")				               			
            end
        end		
		if event == sgs.Damage then
            local damage = data:toDamage()
            if xnianshou:getPhase()~=sgs.Player_NotActive then return false end				                    
            if room:askForSkillInvoke(xnianshou,"shiren") then                   
                if xnianshou:getMark("mm") > 3 then return false end
                    xnianshou:drawCards(1)	
					room:playSkillEffect("xiuluo",54)				
				    xnianshou:addMark("mm")				               			
            end
        end	  						
    end		
}
bianpaocard = sgs.CreateSkillCard{
	name = "bianpao",	
	target_fixed = false,	
	will_throw = false,	
	filter = function(self, targets, to_select)
	if #targets >= sgs.Self:getLostHp() then return false end
	if to_select:objectName() == sgs.Self:objectName() then return false end	
		return true  
	end,					
	on_effect = function(self, effect)
        local room = effect.from:getRoom() 		   
        room:loseHp(effect.to)		             	       		
	end
}
bianpaovs = sgs.CreateViewAsSkill{
	name = "bianpaovs",	
	n = 0,	
	view_as = function(self, cards)	
	    local Jcard=bianpaocard:clone()
		Jcard:setSkillName("bianpao")
		return Jcard
	end,			
	enabled_at_play = function()
		return false
	end,		
	enabled_at_response = function(self,player,pattern)
		return pattern == "@@bianpao"
	end	
}
bianpao = sgs.CreateTriggerSkill{
	name = "bianpao",
	frequency = sgs.Skill_NotFrequent,	
	view_as_skill = bianpaovs,
	events = {sgs.PhaseChange},
	can_trigger = function(self, player)
	    return player:hasSkill("bianpao")	      
    end,	
	on_trigger = function(self, event, player, data)
	    local room = player:getRoom()
		local player=room:findPlayerBySkillName(self:objectName()) 	
	    if event==sgs.PhaseChange and player:getPhase() == sgs.Player_Finish then			
		    if player:getHandcardNum() >= player:getHp() then			
			    if room:askForSkillInvoke(player, "bianpao") then                
				    room:playSkillEffect("xiuluo",53)				
					room:loseHp(player)				
			        room:askForUseCard(player, "@@bianpao", "@bianpao") 								       			        		  				        	
		        end
			end
		end							           							
	end
}
xnianshou:addSkill(shiren)
xnianshou:addSkill(shirenbuff)
xnianshou:addSkill(bianpao)
-- meiji = sgs.General(extension, "meiji", "shu", 3, false)
-- meinvcardname = nil
-- ismeinvdiscard = false
-- ismeinvjiesuan = false
-- meinv = sgs.CreateTriggerSkill{
	-- name = "meinv",
	-- frequency = sgs.Skill_NotFrequent,
	-- events = {sgs.PhaseChange,sgs.CardLost,sgs.CardLostDone},	
	-- can_trigger = function(self, target)
        -- return true 
    -- end,
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
		-- local curp = room:getCurrent()
		-- if event==sgs.PhaseChange and player:hasSkill("meinv") then
			-- if player:getPhase() == sgs.Player_Play then															
				-- if player:isKongcheng() then return false end
                -- if (room:askForSkillInvoke(player,self:objectName())) then 				
					-- local card_ids = sgs.IntList()
					-- for _,cd in sgs.qlist(player:getHandcards()) do
						-- local id = cd:getEffectiveId()
						-- card_ids:append(id)
					-- end
					-- room:fillAG(card_ids, player)
					-- local cdid = room:askForAG(player, card_ids, false, self:objectName())
					-- room:showCard(player, cdid)
					-- local meinvc = sgs.Sanguosha:getCard(cdid)
					-- meinvcardname = meinvc:objectName()
					-- player:invoke("clearAG")
                -- end					
			-- elseif player:getPhase() == sgs.Player_Discard then
				-- meinvcardname = nil
			-- end
		
		-- elseif event==sgs.CardLost and not player:hasSkill("meinv") and curp:hasSkill("meinv") and ismeinvjiesuan==false then
			-- move = data:toCardMove()
			-- if(move.to_place == sgs.Player_DiscardedPile) then
				-- local meinvdiscardid = data:toCardMove().card_id
				-- local meinvdiscard = sgs.Sanguosha:getCard(meinvdiscardid)
				-- if(meinvdiscard:match(meinvcardname)) then
					-- ismeinvdiscard = true
					-- ismeinvjiesuan = true
				-- end
			-- end
		-- elseif event==sgs.CardLostDone and not player:hasSkill("meinv") and curp:hasSkill("meinv") and ismeinvdiscard==true and ismeinvjiesuan==true then 
			-- ismeinvdiscard = false						
			-- if room:askForChoice(curp,"meinv","drawx+losex")=="drawx" then														
				-- curp:drawCards(1) 				
			-- else				
				-- local damage=sgs.DamageStruct()
			    -- damage.damage=1
			    -- damage.nature=sgs.DamageStruct_Thunder 
			    -- damage.chain=false 
			    -- damage.from=curp
			    -- damage.to=player
		        -- room:damage(damage)			     		
			-- end
			-- ismeinvjiesuan = false
		-- end	
	-- end,
-- }
-- jiaoyan = sgs.CreateTriggerSkill{
	-- name = "jiaoyan",
	-- events = {sgs.Predamaged},	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local from = data:toDamage().from		
		-- source = sgs.QVariant(0)
		-- source:setValue(from)		
		-- if from and from:isAlive() and player:getHp()<from:getHp() then
			-- if(not room:askForDiscard(from, "jiaoyan", 2, true)) then	
                -- room:playSkillEffect("jieming",2)			
				-- return true
			-- end				
		-- end		
		-- return false		
	-- end
-- }
-- meiji:addSkill(meinv)
-- meiji:addSkill(jiaoyan)
-- meiji:addSkill("hujia")
tpgz = sgs.General(extension, "tpgz", "shu", 3, false)
zhenguoCard = sgs.CreateSkillCard{
	name = "zhenguoCard"
}
zhenguo = sgs.CreateTriggerSkill{
	name = "zhenguo",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Death},
	on_trigger = function(self, event, player, data)
		if not player:isAllNude() then
			local room = player:getRoom()			
			local damage = data:toDamageStar()
		    local tpgz = room:findPlayerBySkillName("zhenguo")		    
	        if damage.from:getGeneralName() == tpgz:getGeneralName()  then 					
			        local alives = room:getAlivePlayers()
			        for _,tpgz in sgs.qlist(alives) do
				if tpgz:isAlive() and tpgz:hasSkill(self:objectName()) then
					if room:askForSkillInvoke(tpgz, self:objectName(), data) then
						local cards = player:getCards("hej")
						if cards:length() > 0 then
							local allcard = zhenguoCard:clone()
							for _,card in sgs.qlist(cards) do
								allcard:addSubcard(card)
							end
							room:obtainCard(tpgz, allcard)
							room:playSkillEffect("xiuluo",math.random(25, 26))	
						end
						break
						
					end
				end
			end
		end
		return false
		end
	end,
	can_trigger = function(self, target)
		if target then
			return not target:hasSkill(self:objectName())
		end
		return false
	end
}
taiping=sgs.CreateTriggerSkill{	
	name = "taiping",
	frequency=sgs.Skill_Compulsory, 
	events={sgs.Predamaged}, 	
	on_trigger = function(self, event, player, data)	    					
		local room = player:getRoom()
		local tpgz = room:findPlayerBySkillName("taiping")						
        local damage = data:toDamage()        
        local from = damage.from 	
		if (event == sgs.Predamaged and from:getGeneral():isMale()) then 							    			 										
			  if room:askForCard(tpgz, ".", "@taiping") then 
                 local log1=sgs.LogMessage()
		         log1.type="$taiping"
		         log1.from=tpgz
		         room:sendLog(log1)	
                 room:playSkillEffect("xiuluo",math.random(27, 28))				 
			     return true
              end
              return false			  
		end	
    end,   		
}			
tpgz:addSkill(zhenguo)
tpgz:addSkill(taiping)
tpgz:addSkill("hujia")
-- nguijianshi = sgs.General(extension, "nguijianshi", "wei", 4, false)
-- hunci_card=sgs.CreateSkillCard{
	-- name="hunci_card",
	-- target_fixed = false,
	-- will_throw=false,
	-- filter = function(self, targets, to_select, player)					
		-- if (to_select:isProhibited(to_select, sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0))) then return false end
		-- return sgs.Self:canSlash(to_select, true)  and  to_select:objectName() ~= sgs.Self:objectName() 			
	-- end,
	-- on_effect=function(self,effect)                   
		-- local room = effect.from:getRoom()		
		-- if effect.from:getMark("@hunci") == 0 then
		-- room:loseHp(effect.from)
        -- end				
		-- if not effect.from:isAlive() then return end		
		-- local slash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
		-- slash:setSkillName("hunci")
		-- local use = sgs.CardUseStruct()
		-- use.from = effect.from
		-- use.to:append(effect.to)
		-- use.card = slash
		-- room:useCard(use,false)						
		-- local count = effect.from:getMark("@hunci")                        						
        -- if count > 0 then return false end						                        					
		-- effect.from:gainMark("@hunci")							
	    -- end
-- }
-- hunci=sgs.CreateViewAsSkill{
	-- name="hunci",
	-- n=0,
	-- view_as=function(self, cards)
			-- if #cards==0 then
				-- local acard=hunci_card:clone()         
				-- acard:setSkillName(self:objectName())     
				-- return acard
			-- end
	-- end,
	-- enabled_at_play=function(self,player)
	        -- return not player:hasUsed("#hunci_card")  			
	-- end,
	-- enabled_at_response=function(self,player,pattern) 
			-- return false
	-- end
-- }
-- huncibuff = sgs.CreateTriggerSkill{
    -- name = "#huncibuff",
    -- events = {sgs.PhaseChange},
    -- frequency = sgs.Skill_Compulsory,   
	-- can_trigger = function(self, player)
	    -- return player:hasSkill("#huncibuff")	      
    -- end,
    -- on_trigger=function(self,event,player,data) 
        -- local room=player:getRoom()	
		-- local player=room:findPlayerBySkillName(self:objectName()) 
	    -- if event==sgs.PhaseChange and player:getPhase()==sgs.Player_Finish then           		          			
	        -- player:loseAllMarks("@hunci")	   	            						               
        -- end			 
    -- end		
-- }      	
-- mingsi = sgs.CreateTriggerSkill{
	-- name = "mingsi",
	-- frequency = sgs.Skill_Frequent,
	-- events = {sgs.DrawNCards},	
    -- can_trigger = function(self, player)
	    -- return player:hasSkill("mingsi")	      
    -- end,	
	-- on_trigger = function(self, event, player, data)
	    -- local room = player:getRoom()
		-- local player=room:findPlayerBySkillName(self:objectName())    
		-- local count = data:toInt() + (math.min(4, player:getHp()) - 2)		 
		-- if(room:askForSkillInvoke(player, "mingsi")) then							    									
			-- data:setValue(count)		   
		-- end
	-- end
-- }
-- nguijianshi:addSkill(hunci)
-- nguijianshi:addSkill(huncibuff)
-- nguijianshi:addSkill(mingsi)
-- nguijianshi:addSkill("jiuyuanf")
-- Katarina = sgs.General(extension, "Katarina", "wei", 3, false)
-- tanlan=sgs.CreateTriggerSkill{
        -- name="tanlan",
        -- events=sgs.CardUsed,
		-- priority=1,
        -- frequency=sgs.Skill_NotFrequent,
        -- on_trigger=function(self,event,player,data)
        -- local room=player:getRoom()
		-- local use=data:toCardUse()
        -- local cd = use.card
        -- if event==sgs.CardUsed and cd:inherits("Slash") and room:askForSkillInvoke(player, self:objectName()) then
		        -- local card_id = room:drawCard() 
				-- local card=sgs.Sanguosha:getCard(card_id)
                -- room:moveCardTo(card,nil,sgs.Player_Special,true)
                -- room:getThread():delay()
				-- if(card:inherits("Slash") or card:inherits("EquipCard") or card:inherits("Collateral"))then
				-- room:obtainCard(player,card_id)
                -- else
                    -- room:throwCard(card_id)
					-- end
					-- end
					-- end
-- }
-- lianhuacard=sgs.CreateSkillCard{
-- name="lianhua",
-- once=true,
-- will_throw=true,
-- filter=function(self,targets,to_select,player)
    -- if #targets > 0 then return false end
        -- return to_select:objectName() ~= player:objectName()
-- end,
-- on_effect=function(self,effect)                
        -- local room=effect.from:getRoom() 
		-- room:throwCard(self)
        -- local damage=sgs.DamageStruct()
        -- damage.damage=(self:subcardsLength())
        -- damage.nature=sgs.DamageStruct_Normal 
        -- damage.chain=false 
		-- damage.from=effect.from
        -- damage.to=effect.to
		-- room:askForDiscard(effect.from,"lianhua",self:subcardsLength(),false,false)				
        -- local log=sgs.LogMessage()
        -- log.type = "#lianhua"
        -- log.arg = effect.to:getGeneralName()
        -- room:sendLog(log)
        -- damage.from=effect.from
        -- damage.to=effect.to
		-- room:setPlayerFlag(effect.from,"lianhuaused")
        -- room:damage(damage)
-- end                
-- }
-- lianhua=sgs.CreateViewAsSkill{
-- name="lianhua",
-- n=998,
-- view_filter=function(self, selected, to_select)
        -- return to_select:isEquipped()
-- end,
-- view_as = function(self, cards)
		-- if ((sgs.Self:getEquips():length()) > (sgs.Self:getHandcardNum())) then return end
		-- if #cards > 0 then
			-- local new_card = lianhuacard:clone()
			-- local i = 0
			-- while(i < #cards) do
				-- i = i + 1
				-- local card = cards[i]
				-- new_card:addSubcard(card:getId())
			-- end
			-- new_card:setSkillName("lianhua")
			-- return new_card
		-- else return nil
		-- end
	-- end,
	-- enabled_at_play=function() 
        -- if sgs.Self:getPhase()==sgs.Player_Finish then sgs.Self:getRoom():setPlayerFlag(sgs.Self,"-lianhuaused") end 
	        -- return not sgs.Self:hasFlag("lianhuaused")
    -- end,
-- }
-- Katarina:addSkill(tanlan)
-- Katarina:addSkill(lianhua)
-- Katarina:addSkill("jiuyuanf")
-- sgzhangfei = sgs.General(extension, "sgzhangfei", "god", 5)
-- shayicard = sgs.CreateSkillCard{
	-- name = "shayicard",
	-- target_fixed = false,	
	-- will_throw = true,			
	-- filter = function(self,targets,to_select,player)
		-- if (to_select:getSeat() == player:getSeat())then return false end
        -- if (to_select:isProhibited(to_select, sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0))) then return false end		
		-- return (#targets == 0) 
	-- end,		
	-- on_effect = function(self,effect)	    	   
		-- local source = effect.from
		-- local dest = effect.to
		-- local room = source:getRoom()
		-- local cdid = self:getEffectiveId()
		-- local cardx = sgs.Sanguosha:getCard(cdid)		
		-- local slash = sgs.Sanguosha:cloneCard("an_slash", cardx:getSuit(), cardx:getNumber())						
	    -- slash:setSkillName("shayi")			
	    -- local card_use = sgs.CardUseStruct()
	    -- card_use.from = effect.from
	    -- card_use.to:append(effect.to)
	    -- card_use.card = slash
	    -- room:useCard(card_use, false)
        -- room:playSkillEffect("xiuluo",math.random(31, 32))         		
	-- end
-- }
-- shayi = sgs.CreateViewAsSkill{
	-- name = "shayi",
	-- n = 1,	
	-- view_filter = function(self, selected, to_select)		                  
		-- return not to_select:isRed() 
	-- end,	
	-- view_as = function(self, cards) 
        -- if #cards==0 then return nil end
        -- if #cards==1 then    
        -- local SYcard=shayicard:clone() 
	    -- SYcard:addSubcard(cards[1])
        -- SYcard:setSkillName(self:objectName())     
	        -- return SYcard
	    -- end         										
	-- end,	
	-- enabled_at_play = function()
		-- return  sgs.Self:hasFlag("shayibuff") 
	-- end
-- }	
-- shayibuff = sgs.CreateTriggerSkill{
	-- name = "#shayibuff",	
	-- events = {sgs.PhaseChange},    
    -- can_trigger = function(self,player)
		-- return player:hasSkill("#shayibuff")
	-- end,	
	-- on_trigger=function(self,event,player,data)
		-- local room=player:getRoom()
		-- local player=room:findPlayerBySkillName(self:objectName())   		
		-- if event==sgs.PhaseChange and player:getPhase() == sgs.Player_Play then
		    -- if player:isKongcheng() then return false end
			-- if room:askForSkillInvoke(player, "shayi", data) then
                    -- room:acquireSkill(player, "paoxiao")							                       					
					-- local n=0			   																
				    -- local card_ids = player:handCards()								
				    -- for _,id in sgs.qlist(card_ids) do
				        -- local c = sgs.Sanguosha:getCard(id)
						    -- room:showCard(player, id)  
				            -- if c:inherits("Slash") then												        				
				                -- n=n+1				            
						    -- end				
				    -- end				    
                    -- if n>0 then
					    -- player:drawCards(n)
						-- room:playSkillEffect("xiuluo",33)                        						
					-- else
					    -- room:setPlayerFlag(player,"shayibuff")
						-- room:playSkillEffect("xiuluo",34)	
					-- end
			-- end
		-- end               			
		-- if event==sgs.PhaseChange and player:getPhase() == sgs.Player_Finish then					
		    -- room:setPlayerFlag(player,"-shayibuff")
		-- end				
	-- end
-- }							
-- sgzhangfei:addSkill(shayi)	
-- sgzhangfei:addSkill(shayibuff)	
-- sgsimayi = sgs.General(extension, "sgsimayi", "god", 4)
-- renjie = sgs.CreateTriggerSkill{
        -- name = "renjie",
        -- events = {sgs.Damaged,sgs.CardDiscarded},
        -- frequency = sgs.Skill_Compulsory,
        -- can_trigger = function(self, player)
            -- return player:hasSkill("renjie")
        -- end,
        -- on_trigger = function(self, event, player, data)
                -- local room = player:getRoom()
                -- local player = room:findPlayerBySkillName(self:objectName())				 
				-- if event == sgs.CardDiscarded then                 
                    -- if player:getPhase() == sgs.Player_Discard then
					    -- local card = data:toCard()
                        -- if card:subcardsLength() == 0 then return false end										                       										
					    -- if card:subcardsLength() > 0 then
						    -- player:gainMark("@bear",card:subcardsLength())
							
						-- end                     
                    -- end				 
				-- elseif event == sgs.Damaged then
			        -- local damage = data:toDamage()
			        -- player:gainMark("@bear",damage.damage)
					
		        -- end
		        -- return false
	    -- end                    
-- }
-- baiyin = sgs.CreateTriggerSkill{
	-- name = "baiyin",
	-- frequency = sgs.Skill_Wake,
	-- events = {sgs.PhaseChange},
	-- can_trigger = function(self,player)
		-- return (player and player:isAlive() and player:hasSkill(self:objectName()))				
				-- and (player:getMark("baiyin") == 0)
				-- and (player:getMark("@bear") >= 4)
	-- end,
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()						
		-- if event == sgs.PhaseChange and player:getPhase() == sgs.Player_Start then            						
		    -- room:loseMaxHp(player,1) 
			-- room:setEmotion(player,"baiyin")			
			-- room:setPlayerMark(player,"baiyin",1)			
			-- room:acquireSkill(player, "jilve")					
			-- player:gainMark("@jilve",1)			
		-- end		
	-- end	
-- } 
-- jilve_guicai = sgs.CreateTriggerSkill{
	-- name = "#jilve_guicai",
	-- events = sgs.AskForRetrial,		
	-- can_trigger = function(self, player)
		-- return player and player:isAlive() and player:hasSkill(self:objectName()) and player:getMark("@bear") > 0 and player:getMark("@jilve") == 1
	-- end,
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local simashi = room:findPlayerBySkillName(self:objectName())		
		-- if simashi:isKongcheng() then return end		
		-- local judge = data:toJudge()	    
		-- simashi:setTag("Judge",data)	
		-- if (room:askForSkillInvoke(simashi, self:objectName()) ~= true) then return false end           
            -- local card = room:askForCard(simashi,".","@jilve_guicai")						    
			-- if card ~= nil then         
				-- room:throwCard(judge.card) 
				-- judge.card = sgs.Sanguosha:getCard(card:getEffectiveId()) 
				-- room:moveCardTo(judge.card, nil, sgs.Player_Special) 				
				-- local log = sgs.LogMessage()  
				-- log.type = "$ChangedJudge"
				-- log.from = player
				-- log.to:append(judge.who)
				-- log.card_str = card:getEffectIdString()
				-- room:sendLog(log)                
				-- simashi:loseMark("@bear")                 			
				-- room:sendJudgeResult(judge)			
			-- end
		-- return false 
	-- end,        
-- }  
-- jilve_jizhi = sgs.CreateTriggerSkill{
	-- name = "#jilve_jizhi",
	-- events = {sgs.CardUsed},		
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- if event == sgs.CardUsed then			
			-- local use = data:toCardUse()
			-- if use.card and use.card:isNDTrick() and player:askForSkillInvoke(self:objectName(),data) then								 				
				-- player:loseMark("@bear")				
				-- player:drawCards(1) 
			-- end		
		-- end
	-- end,
	-- can_trigger = function(self, player)
		-- return player and player:isAlive() and player:hasSkill(self:objectName()) and player:getMark("@bear") > 0 and player:getMark("@jilve") == 1
	-- end
-- }  
-- jilve_fangzhu = sgs.CreateTriggerSkill{
	-- name = "#jilve_fangzhu",
	-- events = {sgs.Damaged},		
    -- can_trigger = function(self, player)
		-- return player and player:isAlive() and player:hasSkill(self:objectName()) and player:getMark("@bear") > 0 and player:getMark("@jilve") == 1
	-- end,	
	-- on_trigger = function(self, event, player, data)
		    -- local room = player:getRoom()
		    -- local damage = data:toDamage()
            -- local list = room:getOtherPlayers(player)			
			-- if player:askForSkillInvoke(self:objectName(),data) then                
			-- local target = room:askForPlayerChosen(player,list,"jilve_fangzhutarget")
			-- if target then				
				-- local x = player:getLostHp()
				-- target:drawCards(x)			
				-- target:turnOver()                			
				-- player:loseMark("@bear")
				-- end
			-- end					
	-- end        
-- }
-- jilvecard = sgs.CreateSkillCard{
	-- name = "jilve",
	-- target_fixed = true,
	-- will_throw=false,
	-- on_use=function(self,room,source,targets)
	    -- local shensimayi=source 								
		-- local choices = {}
		-- if not shensimayi:hasFlag("yuanzhiheng") and not shensimayi:isNude() then
			-- table.insert(choices,"yuanzhiheng")
		-- end
		-- if not shensimayi:hasFlag("xyuanwansha") then
			-- table.insert(choices,"xyuanwansha")
		-- end		       	
		-- local choice = room:askForChoice(shensimayi,"jilve",table.concat(choices,"+"))		
		-- if choice == "xyuanwansha" then
			-- room:setPlayerFlag(shensimayi, "xyuanwansha")
			-- room:acquireSkill(shensimayi, "xyuanwansha")
			-- shensimayi:loseMark("@bear")
		-- end
		-- if choice == "yuanzhiheng" then
			-- room:setPlayerFlag(shensimayi, "yuanzhiheng")
			-- room:acquireSkill(shensimayi, "yuanzhiheng")
            -- shensimayi:loseMark("@bear")			
		-- end					
	-- end	
-- }
-- jilve = sgs.CreateViewAsSkill{
	-- name = "jilve" ,
    -- n=0,
	-- view_as = function()
		-- return jilvecard:clone()
	-- end,
	-- enabled_at_play = function(self,player)
		-- return player:getMark("@bear") > 0  and ((not player:hasSkill("yuanzhiheng")) or (not  player:hasSkill("xyuanwansha")))
	-- end
-- }
-- local skill=sgs.Sanguosha:getSkill("jilve")
-- if not skill then
	-- local skillList=sgs.SkillList()
	-- skillList:append(jilve)
	-- sgs.Sanguosha:addSkills(skillList)
-- end
-- yuanzhihengcard = sgs.CreateSkillCard{
	-- name = "yuanzhiheng",
	-- target_fixed = true,
	-- will_throw = true,	
	-- on_use = function(self, room, source, targets)
		-- if(source:isAlive()) then
			-- room:drawCards(source, self:subcardsLength())
			-- room:setPlayerFlag(source, "yuanzhiheng_used")		
			-- room:throwCard(self)			
		-- end
	-- end,
-- }
-- yuanzhiheng = sgs.CreateViewAsSkill{
	-- name = "yuanzhiheng",
	-- n = 998,
	-- view_filter = function(self, selected, to_select)
		-- return true
	-- end,	
	-- view_as = function(self, cards)
		-- if #cards > 0 then
			-- local new_card = yuanzhihengcard:clone()
			-- local i = 0
			-- while(i < #cards) do
				-- i = i + 1
				-- local card = cards[i]
				-- new_card:addSubcard(card:getId())
			-- end
			-- new_card:setSkillName("yuanzhiheng")
			-- return new_card
		-- else return nil
		-- end
	-- end,	
	-- enabled_at_play = function()
		-- return not sgs.Self:hasFlag("yuanzhiheng_used")
	-- end
-- }
-- local skill=sgs.Sanguosha:getSkill("yuanzhiheng")
-- if not skill then
	-- local skillList=sgs.SkillList()
	-- skillList:append(yuanzhiheng)
	-- sgs.Sanguosha:addSkills(skillList)
-- end
-- jilveclear = sgs.CreateTriggerSkill{
	-- name = "#jilveclear",
	-- frequency = sgs.Skill_Frequent,
	-- events = {sgs.PhaseChange},
	-- can_trigger = function(self,player)
		-- return player and player:isAlive()  and  player:getMark("@jilve") == 1 and player:hasSkill(self:objectName())
	-- end,
	-- on_trigger = function(self, event, player, data)	
	    -- local room = player:getRoom()						
		-- if event == sgs.PhaseChange and player:getPhase() == sgs.Player_Finish then 
		    -- if player:hasSkill("yuanzhiheng")  or  player:hasSkill("xyuanwansha") or player:hasFlag("yuanzhiheng") or player:hasFlag("xyuanwansha") then 
	            -- room:detachSkillFromPlayer(player,"yuanzhiheng")
			    -- room:detachSkillFromPlayer(player,"xyuanwansha")
				-- room:setPlayerFlag(player,"-yuanzhiheng")
				-- room:setPlayerFlag(player,"-xyuanwansha")
			-- end
        -- end			
    -- end	
-- }
-- xlianpo = sgs.CreateTriggerSkill{
	-- name = "xlianpo",
	-- frequency=sgs.Skill_Compulsory,
	-- events = {sgs.Death},
	-- can_trigger = function(self, player)
		-- return true 
	-- end,
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local damage = data:toDamageStar()
		-- local smy = room:findPlayerBySkillName("xlianpo")
		-- if smy == nil then return false end
		-- if (damage.from:getGeneralName() == smy:getGeneralName() and smy:getMark("@xlianpo") == 0) then 			
			-- smy:gainMark("@xlianpo", 1)			
		-- end
	-- end
-- }  
-- xlianpobuff=sgs.CreateTriggerSkill{
	-- name="#xlianpobuff",
	-- events={sgs.PhaseChange},
	-- priority=8,
	-- frequency = sgs.Skill_Frequent,
	-- can_trigger=function()
	    -- return true
	-- end,
	-- on_trigger=function(self,event,player,data)
	    -- local room=player:getRoom()
		-- local smy=room:findPlayerBySkillName(self:objectName())
	    -- if event==sgs.PhaseChange and player:getPhase() == sgs.Player_Finish then 	
		    -- if smy==nil then return false end		
		    -- if smy:getMark("@xlianpo")==1 then			    
				-- smy:loseMark("@xlianpo")                			
			    -- smy:play()               			
			-- end
		-- end
	-- end	
-- }
-- sgsimayi:addSkill(renjie)
-- sgsimayi:addSkill(baiyin)
-- sgsimayi:addSkill(jilve_guicai)
-- sgsimayi:addSkill(jilve_jizhi)
-- sgsimayi:addSkill(jilve_fangzhu)
-- sgsimayi:addSkill(jilveclear)
-- sgsimayi:addSkill(xlianpo)
-- sgsimayi:addSkill(xlianpobuff)
-- yadianna = sgs.General(extension, "yadianna", "god", 3, false)
-- shengqiang=sgs.CreateTriggerSkill{
    -- name = "shengqiang",
    -- frequency=sgs.Skill_Compulsory,
    -- events = {sgs.SlashProceed},
    -- can_trigger = function(self, player)
	    -- return player:hasSkill("shengqiang")	      
    -- end,	
    -- on_trigger=function(self,event,player,data)
        -- if event==sgs.SlashProceed then
            -- local room = player:getRoom()
            -- local selfplayer = room:findPlayerBySkillName(self:objectName()) 
            -- if selfplayer:getWeapon() ~= nil and selfplayer:getMark("@an") == 0 then           
                -- local effect=data:toSlashEffect()              
                -- local log=sgs.LogMessage()
		        -- log.type="$shengqiang"
		        -- log.from=selfplayer
		        -- room:sendLog(log)
                -- room:slashResult(effect, nil) 								
                -- return true
            -- end
        -- end
	-- end
-- }
-- shengdun=sgs.CreateTriggerSkill{
	-- name = "#shengdun",	
 	-- frequency = sgs.Skill_NotFrequent,
 	-- events = {sgs.Predamaged},	
	-- can_trigger=function() 
        -- return true
    -- end,	
 	-- on_trigger=function(self,event,player,data)	       
	    -- if(event == sgs.Predamaged)then
		    -- local room=player:getRoom()
			-- local ydn=room:findPlayerBySkillName(self:objectName())		    
		    -- if not ydn then return false end		
		    -- if ydn:getMark("@an") > 2 then return end
			-- if room:askForSkillInvoke(ydn,"shengdunbuff") then            					     		      
	            -- local count = ydn:getMark("@an")
                -- if count > 2 then return false end 
                -- ydn:gainMark("@an")						
				-- local log=sgs.LogMessage()
		        -- log.type="$shengdun"
		        -- log.from=ydn
		        -- room:sendLog(log)					
                -- return true 
		    -- end	        
        -- end
    -- end		
-- }		
-- shengdunbuffcard = sgs.CreateSkillCard{
	-- name = "shengdunbuffcard",			
	-- filter = function(self, targets, to_select)	  
		-- return (#targets == 0) and (to_select:objectName()== sgs.Self:objectName())
	-- end,
	-- on_effect = function(self, effect)		           
		-- local room = effect.to:getRoom()		
		-- effect.from:loseMark("@an", 1)					  
	-- end
-- }
-- shengdunbuff = sgs.CreateViewAsSkill{
	-- name = "shengdunbuff",
	-- n =1,	
	-- view_filter=function(self, selected, to_select)	     	
        -- return to_select:inherits("BasicCard") and to_select:isRed()  
    -- end,		
	-- view_as=function(self, cards)
	    -- if #cards==0 then return nil end
	    -- local SDcard=shengdunbuffcard:clone()	
	    -- SDcard:addSubcard(cards[1])    	
	    -- return SDcard
    -- end,	
	-- enabled_at_play=function(self, player)
		-- return player:getMark("@an") >0	
	-- end
-- }
-- qiyuan=sgs.CreateTriggerSkill{ 
	-- name="qiyuan",	
	-- frequency = sgs.Skill_Compulsory,
	-- events = {sgs.PhaseChange},
	-- can_trigger = function(self, player)
	    -- return player:hasSkill("qiyuan")	      
    -- end,		
	-- on_trigger=function(self,event,player,data)	
	    -- if event==sgs.PhaseChange then
            -- local room=player:getRoom()
		    -- local player = room:findPlayerBySkillName(self:objectName())
            -- if player:getMark("@an")~=3 then return false end	 		
            -- if player:getPhase() == sgs.Player_Start then					       																		
				-- for i=1,3,1 do 
					-- local card_id = room:drawCard() 
					-- local card=sgs.Sanguosha:getCard(card_id)
               	 	-- room:moveCardTo(card,nil,sgs.Player_Special,true)
                	-- room:getThread():delay()
					-- if(card:getSuit() == sgs.Card_Spade or card:getSuit() == sgs.Card_Club)then     					
					    -- room:loseHp(player)			            				      																
                	-- else 
                  	  -- room:obtainCard(player,card_id)	
					-- end	
				-- end
                -- player:loseAllMarks("@an")				
			-- end
		-- end
    -- end		
-- }
-- yadianna:addSkill(shengqiang)
-- yadianna:addSkill(shengdun)
-- yadianna:addSkill(shengdunbuff)
-- yadianna:addSkill(qiyuan)
-- Akali = sgs.General(extension, "Akali", "wei", 3, false)
-- cangfei=sgs.CreateTriggerSkill{
-- name = "cangfei",
-- frequency = sgs.Skill_NotFrequent,
-- events={sgs.DrawNCards},
-- on_trigger=function(self,event,player,data)
  -- local room=player:getRoom()
  -- if event==sgs.DrawNCards then
  -- if (not room:askForSkillInvoke(player, self:objectName())) then return end
   -- room:drawCards(player,1)
   -- data:setValue(0)
   -- for i=1,3,1 do 
				-- local card_id = room:drawCard() 
				-- local card=sgs.Sanguosha:getCard(card_id)
                -- room:moveCardTo(card,nil,sgs.Player_Special,true)
                -- room:getThread():delay()
				-- if(card:isRed())then
				-- room:obtainCard(player,card_id)
                -- elseif not(card:isRed())then 
                    -- room:throwCard(card_id)
				-- end	
			-- end
		-- end
	-- end
-- }
-- sanhuacard = sgs.CreateSkillCard{
	-- name = "sanhua",	
	-- target_fixed = false,	
	-- will_throw = true,
	-- filter = function(self, targets, to_select, player)
		-- if(#targets >= self:subcardsLength()) then return false end
		-- return to_select:isAlive() and to_select:objectName()~=player:objectName()
	-- end,
	-- on_effect = function(self, effect)
		-- local room = effect.to:getRoom()
		-- local damage=sgs.DamageStruct()
        -- damage.damage=1
        -- damage.nature=sgs.DamageStruct_Normal
        -- damage.chain=false
        -- damage.from=effect.from
        -- damage.to=effect.to		
        -- room:damage(damage)
	-- end,
-- }
-- sanhuavs = sgs.CreateViewAsSkill{
	-- name = "sanhua",	
	-- n = 998,
	-- view_filter = function(self, selected, to_select)
        -- return to_select:isRed() 
    -- end,	
	-- view_as = function(self, cards)
	-- if #cards > 0 then
			-- local new_card = sanhuacard:clone()
			-- local i = 0
			-- while(i < #cards) do
				-- i = i + 1
				-- local card = cards[i]
				-- new_card:addSubcard(card:getId())
			-- end
			-- new_card:setSkillName("sanhua")
			-- return new_card
		-- else return nil
		-- end	
	-- end,
	-- enabled_at_play = function()
		-- return false
	-- end,
	-- enabled_at_response = function(self, player, pattern)
		-- return pattern == "@@sanhua"
	-- end
-- }
-- sanhua = sgs.CreateTriggerSkill{
	-- name = "sanhua",
	-- view_as_skill = sanhuavs,
	-- events = {sgs.Damaged},
	-- on_trigger = function(self, event, player, data)
	-- if event == sgs.Damaged then
			-- local room = player:getRoom()
			-- local damage = data:toDamage()
			-- local can_invoke = false
			-- local other = room:getOtherPlayers(player)
			-- for _,aplayer in sgs.qlist(other) do
				-- if (aplayer:isAlive()) then
					-- can_invoke = true
					-- break
				-- end
			-- end
			-- if player:isNude() then return false end
			-- if(not room:askForSkillInvoke(player, "sanhua")) then return false end
			-- if(can_invoke and room:askForUseCard(player, "@@sanhua", "@sanhua")) then return true end
		-- return false
		-- end
	-- end
-- }
-- Akali:addSkill(cangfei)
-- Akali:addSkill(sanhua)
-- Akali:addSkill("jiuyuanf")
moxi = sgs.General(extension, "moxi", "shu", 3, false)
yaoji = sgs.CreateTriggerSkill{
    name = "yaoji",
    events = {sgs.Damaged,sgs.PhaseChange},
    frequency = sgs.Skill_Compulsory,   
	can_trigger=function(self, player)
	    local room=player:getRoom()
	    local moxi=room:findPlayerBySkillName("yaoji")
	    if moxi==nil then return false end
	    return moxi:isAlive()
    end,
    on_trigger=function(self,event,player,data)
        if event==sgs.Damaged then		
		    local room = player:getRoom()		
		    local damage = data:toDamage()			
			local player=room:findPlayerBySkillName(self:objectName())
		    if damage.from and (damage.from:objectName() ~= player:objectName()) and damage.to and (damage.to:objectName() == player:objectName()) then
                room:playSkillEffect("xiuluo",math.random(35, 36)) 			
		        local count = damage.from:getMark("@yaoji")
                if count > 0 then return false end 	
                damage.from:gainMark("@yaoji")
                end
            end				              					
	    if event==sgs.PhaseChange then
            local room=player:getRoom()	
	        local moxi=room:findPlayerBySkillName("yaoji")
	        local otherplayers=room:getOtherPlayers(moxi)            			
	        if player:getMark("@yaoji")~=1 then return false end	        	 
            if player:getPhase()==sgs.Player_Play then		
			            local judge = sgs.JudgeStruct()
			            judge.pattern = sgs.QRegExp("(.*):(spade):(.*)")
						judge.good = false
			            judge.who = player
			            judge.reason = "yaoji"
			            room:judge(judge)
			            if (not judge:isGood()) then
			                room:setEmotion(player, "bad")					
                            player:loseMark("@yaoji")                            
							local log1=sgs.LogMessage()
				            log1.type="#yaoji"
				            room:sendLog(log1)														
                            return true                        						
			            else
                            room:setEmotion(player, "good")							
				            player:loseMark("@yaoji")
                            return false                                                                               							                	           			
	                    end
		    end			
        end			 
    end		
}      				 	    
liebo_card = sgs.CreateSkillCard{ 
	name = "liebo_card",
	target_fixed = false,
	will_throw = true,	
	filter = function(self, targets, to_select, player)
		return #targets==0 and (to_select:objectName()~=player:objectName()) and not to_select:isKongcheng()
	end,	
	on_use = function(self, room, source, targets)
    local dest=targets[1]
	local num=targets[1]:getHandcardNum()
	local y = source:getHandcardNum()	
	if self:getSubcards():length() < y then
	    local cd_t=room:askForExchange(dest,"liebo_card",math.min(self:getSubcards():length(),num))
	    room:moveCardTo(self,dest,sgs.Player_Hand,false)
	    room:moveCardTo(cd_t,source,sgs.Player_Hand,false)
		room:playSkillEffect("xiuluo",math.random(37, 38))
	end
	if self:getSubcards():length()==y then
	    local to_exchange=dest:wholeHandCards()  
        local to_exchange2= source:wholeHandCards()  
        room:moveCardTo(to_exchange,source, sgs.Player_Hand, false) 
        room:moveCardTo(to_exchange2,dest, sgs.Player_Hand, false)
        room:playSkillEffect("xiuluo",math.random(37, 38))		
	end
end,	
}
liebo= sgs.CreateViewAsSkill{
name = "liebo",
n = 998,	
enabled_at_play=function(self, player)
		return not player:hasUsed("#liebo_card") and not player:isKongcheng()
end,	
view_filter = function(self, selected, to_select)
		return not  to_select:isEquipped()
end,	
view_as = function(self, cards)		
		local qcard = liebo_card:clone()
		for _, p in ipairs(cards) do
			qcard:addSubcard(p)
		end
		qcard:setSkillName(self:objectName())
		return qcard
end
}			
moxi:addSkill(yaoji)
moxi:addSkill(liebo)
moxi:addSkill("hujia")
-- luna = sgs.General(extension, "luna", "wei", 3, false)
-- feixicard=sgs.CreateSkillCard{
-- name="feixicard",
-- target_fixed=false,
-- will_throw=true,
-- filter = function(self,targets,to_select,player)
    -- if(to_select:getSeat() == player:getSeat())then return false end
	-- return (#targets==0) and to_select:getMark("@yue")==0
-- end,
-- on_use=function(self,room,source,targets)
	-- local selfplayer=source
	-- room:throwCard(self)		
	-- targets[1]:gainMark("@yue")	
-- end,
-- }
-- feixi=sgs.CreateViewAsSkill{
-- name="feixi",
-- n=1,
-- view_filter=function(self, selected, to_select)                         
	-- return to_select:isBlack()
-- end,
-- view_as=function(self, cards)
	-- if #cards~=1 then return nil end
	-- local fxcard=feixicard:clone()
	-- for var=1,#cards,1 do
		-- fxcard:addSubcard(cards[var])
	-- end	
	-- fxcard:setSkillName(self:objectName())
	-- return fxcard
-- end,
-- enabled_at_play=function()	
	-- return true
-- end
-- }
-- yuezhan = sgs.CreateTriggerSkill{
	-- name = "yuezhan",	
	-- frequency = sgs.Skill_NotFrequent,
	-- events={sgs.Predamaged},	  
	-- on_trigger=function(self,event,player,data)	
        -- if event==sgs.Predamaged then
            -- local room = player:getRoom()
		    -- local damage = data:toDamage()       	             
		    -- if not damage.card:inherits("Slash") then return end	
            -- if damage.from:getMark("@yue")>0 then							  
		        -- if room:askForSkillInvoke(player, "yuezhan") then 										
				    -- damage.damage=damage.damage-1
				    -- data:setValue(damage)				
				    -- damage.from:loseMark("@yue")
                -- end      				
		    -- else
				-- return false
			-- end
		-- end
	-- end   			
-- }  	
-- jianmang=sgs.CreateTriggerSkill{
	-- name="jianmang",
	-- frequency = sgs.Skill_Compulsory,	
	-- events = {sgs.Damage}, 	 	
	-- can_trigger = function(self, player)
	    -- return player:hasSkill("jianmang")	  
    -- end,	
	-- on_trigger=function(self,event,player,data)
		-- local room = player:getRoom()
		-- local ln = room:findPlayerBySkillName("jianmang")
		-- local damage = data:toDamage()		
		-- local x = damage.damage
		-- if not damage.card:inherits("Slash") then return end
		-- if damage.to:getMark("@yue")>0 then
            -- damage.to:loseMark("@yue")				
		    -- local players=sgs.SPlayerList()
			-- for _,p in sgs.qlist(room:getOtherPlayers(ln)) do
				-- if p:getMark("@yue")>0 then
				    -- local damagex = sgs.DamageStruct()
			        -- damagex.damage = x
			        -- damagex.from = ln
			        -- damagex.to = p
			        -- room:damage(damagex)												
					-- p:loseAllMarks("@yue")
				-- end						
		    -- end			
	    -- end
	-- end
-- }
-- luna:addSkill(feixi)
-- luna:addSkill(yuezhan)
-- luna:addSkill(jianmang)
-- luna:addSkill("jiuyuanf")	
-- xiahoulinxiu = sgs.General(extension, "xiahoulinxiu", "wei", 4, false)
-- jiaorong=sgs.CreateTriggerSkill{
    -- name="jiaorong",
    -- frequency=sgs.Skill_Compulsory,
    -- events={sgs.SlashEffect,sgs.SlashEffected},		
    -- on_trigger=function(self,event,player,data)
    -- local room=player:getRoom()
    -- local use=data:toCardUse()
	-- local effect = data:toSlashEffect()
    -- if ((event==sgs.SlashEffect and effect.to:getGeneral():isMale()) or(event==sgs.SlashEffected and effect.from:getGeneral():isMale())) then				
	-- local log1=sgs.LogMessage()
    -- log1.type="$jiaorong"
    -- log1.from=player
	-- room:sendLog(log1)		   	  	
    -- player:drawCards(1)
	-- end
-- end
-- }
-- LuaYinYuanCard=sgs.CreateSkillCard{
	-- name="LuaYinYuan",
	-- will_throw=true,
	-- filter=function(self,targets,to_select,player)
		-- return to_select:getGeneral():isMale() and #targets==0
	-- end,
	-- on_use=function(self,room,source,targets)
		-- room:setPlayerFlag(source,"LuaYinYuanUsed")
		-- local card=nil
		-- local suitnum={0,0,0,0}
		-- local cdid=0
		-- local cards=self:getSubcards()
		-- local target=targets[1]
		-- local t=true
		-- local count=0
		-- local newcard=LuaYinYuanCard:clone()
		-- local suitstr=""
		-- while t and cards:length()>0 do
			-- t=nil
			-- room:fillAG(cards,target)			
			-- cdid=room:askForAG(target,cards,true,"LuaYinYuan")
			-- target:invoke("clearAG")
			-- if cdid==-1 then break end
			-- cards:removeOne(cdid)
			-- local card=sgs.Sanguosha:getCard(cdid)
			-- newcard:addSubcard(card)
			-- x=card:getSuit()
			-- local suitstr=card:getSuitString()
			-- local pattern=".|"..suitstr.."|."
			-- t=room:askForCard(target,pattern,"LuaYinYuanbuff")
			-- if t then
			    -- newcard:addSubcard(card)
				-- room:moveCardTo(t,source,sgs.Player_Hand,true)
				-- count=count+1
			-- end
		-- end
		-- if count==0 then
			-- local damagex=sgs.DamageStruct()
			-- damagex.damage=1
			-- damagex.from=source
			-- damagex.to=target
			-- room:damage(damagex)
		-- else
			-- room:moveCardTo(newcard,target,sgs.Player_Hand,true)
		-- end
	-- end,
-- }
-- LuaYinYuan=sgs.CreateViewAsSkill{
	-- name="LuaYinYuan",
	-- n=998,
	-- view_filter=function(self,selected,to_select)
		-- if to_select:isEquipped() then return false end
		-- return true 
	-- end,
	-- view_as=function(self,cards)
		-- if #cards==0 then return nil end
		-- local acard=LuaYinYuanCard:clone()
		-- for var=1,#cards,1 do   
			-- acard:addSubcard(cards[var])
		-- end
		-- return acard
	-- end,
	-- enabled_at_play=function(self,player)
		-- return not sgs.Self:hasFlag("LuaYinYuanUsed")
	-- end,
-- }
-- LuaZhaoQinCard=sgs.CreateSkillCard{
	-- name="LuaZhaoQin",
	-- target_fixed=true,
	-- on_use=function(self,room,source,targets)
		-- local player=source
		-- player:loseAllMarks("@LuaZhaoQin")		
		-- local bignumber=0
		-- local smallnumber=14
		-- local bigplayer=nil
		-- local smallplayer=nil
		-- for _,p in sgs.qlist(room:getOtherPlayers(source)) do
			-- if p:isAlive() and p:getGeneral():isMale() and not p:isKongcheng() then
				-- local carda=room:askForCardShow(p,p,"LuaZhaoQin")
				-- local number=carda:getNumber()
				-- if number>=bignumber then
					-- bignumber=number
					-- bigplayer=p
				-- end
				-- if number<smallnumber then
					-- smallnumber=number
					-- smallplayer=p
				-- end
				-- self:addSubcard(carda)
			-- end
		-- end
		-- room:throwCard(self)
		-- local recover=sgs.RecoverStruct()
		-- recover.recover=1
		-- recover.who=player
		-- room:recover(player,recover)
		-- if bigplayer then room:recover(bigplayer,recover) end
		-- if smallplayer then
			-- local damagex=sgs.DamageStruct()
			-- damagex.damage=1
			-- damagex.to=smallplayer
			-- room:damage(damagex)
		-- end
	-- end,
-- }
-- LuaZhaoQin=sgs.CreateViewAsSkill{
	-- name="LuaZhaoQin",
	-- view_as=function()
		-- acard=LuaZhaoQinCard:clone()
		-- return acard
	-- end,
	-- enabled_at_play=function()
		-- return sgs.Self:getMark("@LuaZhaoQin")==1
	-- end,
-- }
-- LuaZhaoQinTR=sgs.CreateTriggerSkill{
	-- name="#LuaZhaoQinTR",
	-- events=sgs.GameStart,
	-- frequency=sgs.Skill_Compulsory,
	-- on_trigger=function(self,event,player,data)
		-- player:gainMark("@LuaZhaoQin",1)
		-- return false
	-- end,
-- }				
-- xiahoulinxiu:addSkill(LuaYinYuan)	
-- xiahoulinxiu:addSkill(jiaorong)	
-- xiahoulinxiu:addSkill(LuaZhaoQin)
-- xiahoulinxiu:addSkill(LuaZhaoQinTR)	
-- xiahoulinxiu:addSkill("jiuyuanf")	
-- newhuahua = sgs.General(extension, "newhuahua", "wei", 4)
-- huahuacard = sgs.CreateSkillCard{
	-- name = "huahuacard",
	-- target_fixed = false,
	-- will_throw = true,
	-- filter = function(self, targets, to_select)	        
		-- return true		
    -- end,	
	-- on_effect = function(self, effect)	   
		-- local source = effect.from
		-- local dest = effect.to
		-- local room = source:getRoom() 
        -- room:throwCard(self)            	
		-- local x = source:getLostHp()		
		-- for _,c in sgs.qlist(self:getSubcards()) do
		    -- if sgs.Sanguosha:getCard(c):inherits("Weapon") then			   										    												
			    -- local tslash = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
			    -- tslash:setSkillName("huahua")
				-- if dest:isProhibited(dest, sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)) then return false end
			    -- local use = sgs.CardUseStruct()
			    -- use.from = source
			    -- use.to:append(dest)
			    -- use.card = tslash
			    -- room:useCard(use,false)				
                -- if not dest:isChained() then 
					-- room:setPlayerProperty(dest, "chained", sgs.QVariant(true))
		        -- end
				-- room:setPlayerFlag(source,"hd")
            -- end				
		    -- if sgs.Sanguosha:getCard(c):inherits("Armor") then			   	   								
				-- local choice = room:askForChoice(source, self:objectName(), "lshp+recover")
				-- if choice == "lshp" then					
					-- room:loseHp(dest)								
				-- else				   
					-- local recover = sgs.RecoverStruct()
					-- recover.recover = 1
					-- recover.who = dest
					-- room:recover(dest,recover)									
				-- end
				-- room:setPlayerFlag(source,"hd")
			-- end
			-- if sgs.Sanguosha:getCard(c):inherits("DefensiveHorse") or sgs.Sanguosha:getCard(c):inherits("OffensiveHorse") then			    		   
				-- if not dest:isNude() then
				-- room:moveCardTo(sgs.Sanguosha:getCard(room:askForCardChosen(source, dest, "he", self:objectName())), source, sgs.Player_Hand, false)
				-- room:setPlayerFlag(source,"hd")
				-- end
			-- end
            -- if (sgs.Sanguosha:getCard(c):inherits("BasicCard") or sgs.Sanguosha:getCard(c):inherits("TrickCard")) and  not source:hasFlag("hd") then
                -- if dest:hasFlag("hdv") then	return false end		
			    -- dest:drawCards(x+1)   
                -- room:setPlayerFlag(dest,"hdv")                				
		    -- end
		-- end
	-- end
-- }
-- huahua=sgs.CreateViewAsSkill{
    -- name = "huahua",
    -- n = 2,
    -- view_filter=function(self, selected, to_select)
    -- if #selected ==0 then return to_select end
    -- if #selected == 1 then
            -- if selected[1]:inherits("Weapon") then
			    -- return to_select:inherits("IronChain")
			-- elseif selected[1]:inherits("Armor") then
			    -- return to_select:inherits("Slash")
		    -- elseif selected[1]:inherits("DefensiveHorse") or selected[1]:inherits("OffensiveHorse") then
			    -- return to_select:inherits("Jink")
			-- elseif selected[1]:inherits("IronChain") then
			    -- return to_select:inherits("Weapon") or to_select:inherits("BasicCard")
			-- elseif selected[1]:inherits("Slash") then
			    -- return to_select:inherits("Armor") or to_select:inherits("TrickCard")
			-- elseif selected[1]:inherits("Jink") then
			    -- return to_select:inherits("DefensiveHorse") or to_select:inherits("OffensiveHorse") or to_select:inherits("TrickCard")
			-- elseif selected[1]:inherits("BasicCard") and not selected[1]:inherits("Slash") and not selected[1]:inherits("Jink") then
                -- return to_select:inherits("TrickCard")
			-- elseif selected[1]:inherits("TrickCard") then
			    -- return to_select:inherits("BasicCard")
			-- else return false
			-- end
    -- else return false
    -- end
 -- end,
    -- view_as = function(self, cards)
		-- if #cards == 2 then
			-- local new_card = huahuacard:clone()
			-- local i = 0
			-- while(i < #cards) do
				-- i = i + 1
				-- local card = cards[i]
				-- new_card:addSubcard(card:getId())
			-- end
			-- new_card:setSkillName(self:objectName())
			-- return new_card
	-- else return nil
	-- end
-- end,
    -- enabled_at_play = function(self,player)
        -- return not player:hasUsed("#huahuacard")
    -- end,
	-- enabled_at_response = function(self, player, pattern)
            -- return false
-- end,
-- }
-- xyingxi = sgs.CreateTriggerSkill{
 -- name="xyingxi",
 -- events={sgs.PhaseChange ,sgs.HpRecover},
 -- can_trigger = function(self, player)
	-- return true
 -- end,
 -- on_trigger=function(self,event,player,data)
  -- local room = player:getRoom()
  -- local selfplayer = room:findPlayerBySkillName(self:objectName())
  -- if (event==sgs.HpRecover) then
  -- if not selfplayer:isAlive() then return end
  -- if(player:getPhase()== sgs.Player_NotActive) then return end
  -- if player:hasSkill("xyingxi") then return end
  -- local recover = data:toRecover()
    -- for var=1,recover.recover,1 do
	-- if room:askForSkillInvoke(selfplayer, self:objectName(), data) then
    -- player:gainMark("@xyingxi",1)
    -- end
    -- end
	-- end
  -- if (event==sgs.PhaseChange) and (player:getPhase()== sgs.Player_Discard) and (player:getMark("@xyingxi") >= 1) then
  -- if not selfplayer:isAlive() then return end
  -- local x=player:getHp()
  -- local y=player:getMark("@xyingxi")
  -- local z = player:getHandcardNum()
   -- if z <= (x-y) then
   -- return true
   -- else
      -- local e = z-(x-y)
	  -- if e > z then
	  -- room:askForDiscard(player,"xyingxi",z,false,false) 
      -- else room:askForDiscard(player,"xyingxi",e,false,false)
	  -- return true
  -- end
  -- end
-- end  
  -- if (event==sgs.PhaseChange) and (player:getPhase()== sgs.Player_Finish) and (player:getMark("@xyingxi") >= 1) then
  -- local y=player:getMark("@xyingxi")
  -- player:loseMark("@xyingxi",y)
  -- end
  -- end
-- }
-- shenlou = sgs.CreateTriggerSkill{	
	-- name = "shenlou",	
	-- events = {sgs.Damaged},	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local damage = data:toDamage()
		-- local source = damage.from
		-- local source_data = sgs.QVariant()
		-- source_data:setValue(source)
		-- if player:isAlive() then
		    -- for var=1,damage.damage,1 do
			    -- if room:askForSkillInvoke(player, "shenlou") then					
					-- if room:askForChoice(player,"shenlou","mdraw+mdo")=="mdo" then	
					    -- room:doGuanxing(player,room:getNCards(3),false)
						-- player:drawCards(1)
					-- else
					    -- if source then 
						-- if not source:isNude() then
					    -- local card_id = room:askForCardChosen(player, source, "he", "shenlou")	
			            -- room:throwCard(sgs.Sanguosha:getCard(card_id))
			            -- player:drawCards(1)
                        -- source:drawCards(1)
                        -- else
						-- player:drawCards(1)
                        -- source:drawCards(1)
						-- end
						-- else
						-- room:doGuanxing(player,room:getNCards(3),false)
						-- player:drawCards(1)									            	           			             						         
                    -- end
                -- end					
		    -- end
	    -- end
	-- end
-- end
-- }
-- newhuahua:addSkill(huahua)
-- newhuahua:addSkill(xyingxi)
-- newhuahua:addSkill(shenlou)
-- newhuahua:addSkill("jiuyuan")		
-- wzjingke = sgs.General(extension, "wzjingke", "wei", 4, false) 
-- liren=sgs.CreateTriggerSkill{
	-- name="liren",
	-- frequency = sgs.Skill_Frequent,
	-- events={sgs.Damage,sgs.SlashMissed},
	-- on_trigger=function(self,event,player,data)
	-- local room=player:getRoom()
	-- local splayer=room:findPlayerBySkillName(self:objectName())	
	-- if event==sgs.Damage then 
	    -- local damage = data:toDamage()
		-- if not damage.card:inherits("Slash") then return end
	    -- if damage.from and (damage.from:objectName() == splayer:objectName()) and (damage.to:isAlive())  then
	        -- if room:askForSkillInvoke(splayer,"liren") then 	         					
	        -- damage.to:turnOver()
			-- end
		-- end
	-- end	
	-- if event==sgs.SlashMissed then
	    -- local effect=data:toSlashEffect()		
	    -- if not splayer then return end	 
        -- if effect.from:objectName() == splayer:objectName() then	
	        -- if room:askForSkillInvoke(splayer,"liren") then 
            -- splayer:turnOver()
			-- end
		-- end
	-- end
-- end	
-- }
-- liaoya = sgs.CreateTriggerSkill{
	-- name = "liaoya",
	-- events = {sgs.Damage},
	-- frequency = sgs.Skill_NotFrequent,
    -- can_trigger = function(self,player)
		-- return player:hasSkill("liaoya")
	-- end,		
	-- on_trigger = function(self,event,player,data)              	
	    -- local room = player:getRoom()
        -- local player=room:findPlayerBySkillName(self:objectName())      		
		-- local damage = data:toDamage()				 
        -- if not damage.card:inherits("Slash") then return end			
		-- if not player:isWounded() then return end	
        -- if (not room:askForSkillInvoke(player,self:objectName())) then return false end 				
            -- local judge=sgs.JudgeStruct()
            -- judge.pattern=sgs.QRegExp("(.*):(heart|diamond):(.*)")
            -- judge.good=true
            -- judge.reason=self:objectName()
            -- judge.who=player
            -- room:judge(judge)
            -- if (judge:isGood()) then
                -- local recover = sgs.RecoverStruct()
			    -- recover.who = player
			    -- recover.recover = 1
			    -- room:recover(player,recover)		        		                          					
            -- end
        -- end			
-- }
-- wzjingke:addSkill(liren)
-- wzjingke:addSkill(liaoya)
-- wzjingke:addSkill("jiuyuanf")
-- xhuangdi = sgs.General(extension, "xhuangdi", "wu", 4)
-- xxzhibacard = sgs.CreateSkillCard{
	-- name = "xxzhiba",
	-- target_fixed = true,
	-- will_throw = true,	
	-- on_use = function(self, room, source, targets)
		-- if(source:isAlive()) then
		    -- room:throwCard(self)
			-- room:playSkillEffect("zhiheng",3)
			-- room:drawCards(source, self:subcardsLength())
			-- source:loseMark("@xzhiba",1)					
		-- end
	-- end,
-- }
-- xxzhibavs = sgs.CreateViewAsSkill{
	-- name = "xxzhibavs",
	-- n = 998,		
	-- view_filter = function(self, selected, to_select)
		-- return true
	-- end,	
	-- view_as = function(self, cards)
		-- if #cards > 0 then
			-- local new_card = xxzhibacard:clone()
			-- local i = 0
			-- while(i < #cards) do
				-- i = i + 1
				-- local card = cards[i]
				-- new_card:addSubcard(card:getId())
			-- end
			-- new_card:setSkillName("xxzhiba")
			-- return new_card
		-- else return nil
		-- end
	-- end,	
	-- enabled_at_play=function(self, player)
		-- return player:getMark("@xzhiba")>0
	-- end
-- }
-- xxzhiba=sgs.CreateTriggerSkill{
-- name="xxzhiba",
-- view_as_skill=xxzhibavs,
-- events={sgs.PhaseChange},
-- can_trigger = function(self, player)
   -- return player:hasSkill("xxzhiba")	  
-- end,
-- on_trigger=function(self,event,player,data)
	-- local room=player:getRoom()	
	-- local player=room:findPlayerBySkillName(self:objectName())
	-- if event==sgs.PhaseChange then
	    -- if player:getPhase()==sgs.Player_Start then		
		    -- local x = player:getLostHp()+1		
            -- player:gainMark("@xzhiba",x)
		-- end		
		-- if player:getPhase()==sgs.Player_Finish then
		    -- player:loseAllMarks("@xzhiba")
		-- end					
	-- end
-- end
-- }
-- xxzhibas = sgs.CreateTriggerSkill{
    -- name = "#xxzhibas",
	-- frequency = sgs.Skill_Frequent,
    -- events = {sgs.Damaged},      	
    -- on_trigger=function(self,event,player,data)
       	-- if event==sgs.Damaged then 
		    -- local room = player:getRoom()		
		    -- local damage = data:toDamage()
            -- if player:getPhase()==sgs.Player_NotActive then return end					
            -- for var=1,damage.damage,1 do
		        -- player:gainMark("@xzhiba")								
            -- end
        -- end	
    -- end,		
-- }      
-- xhuangdi:addSkill(xxzhiba)
-- xhuangdi:addSkill(xxzhibas)
-- xhuangdi:addSkill("jijiang")			
-- zhuchongba = sgs.General(extension, "zhuchongba", "wu", 4)	
-- qiangyun = sgs.CreateTriggerSkill{
	-- name = "qiangyun",
	-- events = {sgs.CardLost},
	-- frequency = sgs.Skill_Frequent,	
	-- on_trigger = function(self, event, player, data)
		-- local room = player:getRoom()
		-- local move = data:toCardMove()	
		-- if player:getMark("qiangyun") <= 0 then		
		    -- if player:isKongcheng() and move.from_place == sgs.Player_Hand then      
			    -- if room:askForSkillInvoke(player, self:objectName()) == true then
                    -- room:setEmotion(player,"lianying") 
                    -- room:playSkillEffect("lianying",math.random(1, 2))   					
				    -- player:drawCards(2)				
				    -- room:setPlayerMark(player,"qiangyun",1)	
                -- end
            -- end				
		-- else			
			-- if not player:isKongcheng() and move.from_place == sgs.Player_Hand then
			    -- if room:askForSkillInvoke(player, self:objectName()) == true then
                    -- room:setEmotion(player,"lianying") 
					-- room:playSkillEffect("lianying",math.random(1, 2))   					
				    -- player:drawCards(2)
				    -- room:setPlayerMark(player,"qiangyun",0)
			    -- end	
		    -- end
        -- end			
-- end
-- }
-- qiangyunbuff=sgs.CreateTriggerSkill{
	-- name="#qiangyunbuff",
	-- frequency=sgs.Skill_Compulsory,
	-- events={sgs.PhaseChange},
	-- priority=1,
    -- can_trigger=function() 
        -- return true
    -- end,	
	-- on_trigger=function(self,event,player,data)		
    -- local room = player:getRoom()			      				                       
	-- local zyz=room:findPlayerBySkillName(self:objectName()) 
	-- if not (zyz) then return end	
	-- if event == sgs.PhaseChange and player:getPhase()==sgs.Player_Finish then  	 	 		
	    -- room:setPlayerMark(zyz,"qiangyun",0)
		-- end
	-- end					
-- }		
-- zhuchongba:addSkill(qiangyun)
-- zhuchongba:addSkill(qiangyunbuff)		
-- zhuchongba:addSkill("jijiang")			
-- wangyi = sgs.General(extension, "wangyi", "shu", 3, false)
-- zhenlie=sgs.CreateTriggerSkill{
        -- name="zhenlie",
        -- events={sgs.AskForRetrial},
        -- frequency = sgs.Skill_NotFrequent,
        -- on_trigger=function(self,event,player,data)
                -- local room=player:getRoom()
                -- local selfplayer=room:findPlayerBySkillName(self:objectName())
				-- if event == sgs.AskForRetrial then
                -- local judge = data:toJudge()
				-- if judge.who:objectName() ~= selfplayer:objectName() then return false end
				-- selfplayer:setTag("Judge",data)
				-- if (room:askForSkillInvoke(selfplayer,self:objectName())~=true) then return false end              		
                -- room:throwCard(judge.card)	
                -- room:playSkillEffect("xiuluo",math.random(41, 42))						
                -- local idlist=room:getNCards(1)
				-- for _,id in sgs.qlist(idlist) do
				    -- card = sgs.Sanguosha:getCard(id)
			    -- end
                -- judge.card = sgs.Sanguosha:getCard(card:getEffectiveId())
                -- room:moveCardTo(judge.card, nil, sgs.Player_Special)
				-- local log=sgs.LogMessage()
                -- log.type = "$ChangedJudge"
                -- log.from = selfplayer
                -- log.to:append(judge.who)
                -- log.card_str = card:getEffectIdString()
                -- room:sendLog(log)
                -- room:sendJudgeResult(judge)
			    -- end			  			
                -- return false
        -- end       
-- }	
-- miji = sgs.CreateTriggerSkill{
	-- name = "miji" ,
	-- events = {sgs.PhaseChange} ,	
	-- on_trigger = function(self, event, player, data)
		-- if not player:isWounded() then return false end
		-- if (player:getPhase() == sgs.Player_Start) or (player:getPhase() == sgs.Player_Finish) then
			-- if not player:askForSkillInvoke(self:objectName()) then return false end		
			-- local room = player:getRoom()
			-- room:playSkillEffect("xiuluo",math.random(43, 44)) 
			-- local judge = sgs.JudgeStruct()
			-- judge.pattern = sgs.QRegExp("(.*):(spade|club):(.*)")
			-- judge.good = true
			-- judge.reason = self:objectName()
			-- judge.who = player
			-- room:judge(judge)			
			-- if judge:isGood() and player:isAlive() then								
				-- local pile_ids = room:getNCards(player:getLostHp())				
				-- room:fillAG(pile_ids, player)
				-- local target = room:askForPlayerChosen(player, room:getAllPlayers(), self:objectName())								
				-- player:invoke("clearAG")				
				-- local dummy = sgs.Sanguosha:cloneCard("slash", sgs.Card_NoSuit, 0)
				-- for _, id in sgs.qlist(pile_ids) do
					-- dummy:addSubcard(id)
				-- end										
				-- target:obtainCard(dummy)								
			-- end
		-- end
		-- return false
	-- end
-- }
-- wangyi:addSkill(zhenlie)
-- wangyi:addSkill(miji)
-- wangyi:addSkill("hujia")	 		 	
sgs.LoadTranslationTable{
    ["wsgui"] = "SP吴三桂",
	["&wsgui"] = "SP吴三桂",
	["#wsgui"] = "吴周太祖",
	["designer:wsgui"] = "轨迹",
	["cv:wsgui"] = "暂无",
	["~wsgui"] = "红颜何在/功者功之，罪者罪之",
	["illustrator:wsgui"] = "英雄传奇",
	["xiajie"] = "夏桀",
	["&xiajie"] = "夏桀",
	["#xiajie"] = "荒淫暴君",
	["designer:xiajie"] = "轨迹",
	["cv:xiajie"] = "暂无",
	["~xiajie"] = "莫非这太阳已经陨落/气数将尽孤犹不悔",
	["illustrator:xiajie"] = "英雄传奇",
	["weizhongxian"] = "魏忠贤",
	["&weizhongxian"] = "魏忠贤",
	["#weizhongxian"] = "九千岁",
	["designer:weizhongxian"] = "轨迹",
	["cv:weizhongxian"] = "暂无",
	["~weizhongxian"] = "人间无道",
	["illustrator:weizhongxian"] = "英雄传奇",
	["gaoqiu"] = "高俅",
	["&gaoqiu"] = "高俅",
	["#gaoqiu"] = "北宋奸臣",
	["designer:gaoqiu"] = "轨迹",
	["cv:gaoqiu"] = "暂无",
	["~gaoqiu"] = "此一时彼一时",
	["illustrator:gaoqiu"] = "英雄传奇",
	["xzhurong"] = "祝融",
	["&xzhurong"] = "祝融",
	["#xzhurong"] = "刺美人",
	["designer:xzhurong"] = "轨迹",
	["cv:xzhurong"] = "暂无",
	["~xzhurong"] = "花开焉能不败/刹那芳华胜似萤火微光",
	["illustrator:xzhurong"] = "英雄传奇",
	["liji"] = "骊姬",
	["&liji"] = "骊姬",
	["#liji"] = "绝色妖后",
	["designer:liji"] = "轨迹",
	["cv:liji"] = "暂无",
	["~liji"] = "何其忍心/我何曾乱晋，是他们太蠢",
	["illustrator:liji"] = "英雄传奇",
	["gcg1"] = "兰陵王",
	["&gcg1"] = "兰陵王",
	["#gcg1"] = "北齐战神",
	["designer:gcg1"] = "轨迹",
	["cv:gcg1"] = "暂无",
	["~gcg1"] = "伤春逝水，邵华东流",
	["illustrator:gcg1"] = "英雄传奇",
    ["muchanglan"] = "暮菖兰",
	["&muchanglan"] = "暮菖兰",
	["#muchanglan"] = "冷艳霸气",
	["designer:muchanglan"] = "轨迹",
	["cv:muchanglan"] = "暂无",
	["~muchanglan"] = "暂无",
	["illustrator:muchanglan"] = "仙剑奇侠传5前传",	
	["miyue"] = "芈月",
	["&miyue"] = "芈月",
	["#miyue"] = "秦宣太后",
	["designer:miyue"] = "轨迹",
	["cv:miyue"] = "暂无",
	["~miyue"] = "这天下终归我大秦/宫中的女人就不能左右自己的命运吗？",
	["illustrator:miyue"] = "英雄传奇",					
	["youmie"] = "诱灭",
	["youmie_card"] = "诱灭",    
	[":youmie"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以与1名其他男性角色形成【诱灭】状态; 摸牌阶段，你可以少摸1张牌，该角色掉1血; 当该角色濒死时，你立即获得该角色所有的牌（手牌及装备区的牌）。（只能同时存在1个【诱灭】状态）",						
	["#youmiedraw"] = "诱灭",
    [":#youmiedraw"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以与1名其他男性角色形成【诱灭】状态; 摸牌阶段，你可以少摸1张牌，该角色掉1血; 当该角色濒死时，你立即获得该角色所有的牌（手牌及装备区的牌）。（只能同时存在1个【诱灭】状态）",			
	["youmieover"] = "诱灭",
	["youmiebuffcard"] = "诱灭",
	["youmiebuff"] = "诱灭",				
	["zhangzheng"] = "掌政",
	[":zhangzheng"] = "<font color=\"blue\"><b>被动技</b></font>，若场上带有【诱灭】状态，每当你受到【诱灭】状态外角色【杀】的伤害时，带有【诱灭】状态的男性角色摸1张牌，本次伤害转移给该角色; 若场上没有【诱灭】状态，每当你受到非【杀】的伤害后，你摸1张牌",
	["#zhangzhengbuff"] = "掌政",		
	[":#zhangzhengbuff"] = "<font color=\"blue\"><b>被动技</b></font>，若场上带有【诱灭】状态，每当你受到【诱灭】状态外角色【杀】的伤害时，带有【诱灭】状态的男性角色摸1张牌，本次伤害转移给该角色; 若场上没有【诱灭】状态，每当你受到非【杀】的伤害后，你摸1张牌",		
    ["$zhangzhengEffect"] = "【掌政】技能效果被触发，本次伤害转移给带有【诱灭】状态的男性角色",												
	["toujivs"]="投机",
    [":toujivs"]="<font color=\"blue\"><b>被动技</b></font>，当场上角色数量小于4时，你获得防御加成，其他角色在他的回合主动对你发起进攻必须同时打出两张【杀】; 当场上角色数量大于或等于4时，你获得攻击加成，你回合内的所有【杀】都可对目标额外造成1点伤害",
    ["#touji"]="%arg的技能“<b><font color='yellow'>投机</font></b>”被触发,%from须额外打出1张【杀】才能使该【杀】生效",
    ["#toujinodiscard"]="%from使用的【杀】对%arg无效",
	["@touji-discard"]="请再打出一张【杀】",
	["jiabeng"] = "驾崩",
    [":jiabeng"] = "<font color=\"red\"><b>主动技</b></font>，当你进入濒死状态时，你可以选择不向任何人求【药】，若如此做，则可令场内任意数量的角色立刻依次进行判定，若判定结果为黑桃，需要扣除3点血。发动该技能后，你无法复活",
	["@jiabengcard"] = "请选择任意数量的角色以发动技能【驾崩】",
	["jiabengcard"] = "驾崩",
	["shenli"] = "神力",
	[":shenli"] = "<font color=\"blue\"><b>被动技</b></font>，当你的血量不满时，你所打出的红色花色【杀】的伤害+1",
	["mamengqi"] = "马孟起",
	["&mamengqi"] = "马孟起",
	["#mamengqi"] = "一骑当千",
	["designer:mamengqi"] = "轨迹",
	["illustrator:mamengqi"] = "三国KILL",	
	["~mamengqi"] = "可恶，绝不轻饶！",	
	["benxi"] = "奔袭",
	[":benxi"] = "<font color=\"blue\"><b>被动技</b></font>，你计算与其他角色的距离时始终-1；你使用【杀】选择目标后，目标角色须弃置一张装备牌，否则此【杀】不可被【闪】响应。",		
    ["@benxi"] = "请弃置一张装备牌，否则此【杀】不可被【闪】响应",	
	["yaozhan"] = "邀战",			
    [":yaozhan"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以与一名其他角色拼点：若你赢，视为对其使用一张【杀】（此【杀】不计入每回合的使用限制）；若你没赢，该角色可以对你使用一张【杀】。",  		
	["yaozhan_card"] = "邀战",	
	["xmh"] = "孟获",
	["&xmh"] = "孟获",
	["#xmh"] = "南蛮之主",
	["designer:xmh"] = "轨迹",
	["cv:xmh"] = "暂无",
	["~xmh"] = "我不服",
	["illustrator:xmh"] = "英雄传奇",			
    ["xzheng"] = "纵横",
	[":xzheng"] ="<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以打出任意两张相同花色的牌（手牌和装备区的牌），其他角色必须打出一张相同花色的手牌，无法打出者流失1点血量",
	["@xzheng"] = "请打出一张相同花色的手牌",
	["xzhengcard"] = "纵横",	
	["xnman_buff"] = "南蛮",
	[":xnman_buff"] ="<font color=\"blue\"><b>被动技</b></font>，受到你的伤害的目标，在他的回合直接跳过摸牌阶段",	
	["$xnman_buff"] = "【南蛮】技能效果被触发，目标角色跳过他的摸牌阶段",		
	["zhuxin"] = "诛心",
    [":zhuxin"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可找其他角色拼点，若你胜利，则目标角色流失1点血量（每回合限用一次）",
	["xlianhuan"] = "连环",
    [":xlianhuan"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你的【杀】对目标造成伤害后，可选择丢弃一张手牌，对目标造成1点额外伤害",
	["xlianhuancard"] = "连环",
	["@xlianhuancard"] = "请弃置一张手牌以发动技能【连环】",
	["zhuanquan"] = "专权",
	[":zhuanquan"] = "<font color=\"blue\"><b>被动技</b></font>，你没有装备防具时，黑色【杀】无法对你使用",
	["duji"] = "毒计",
	[":duji"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以打出一张红色手牌，埋下一条定时生效的毒计，再轮到目标回合开始阶段必须进行一次判定，若为红色则受到一点伤害",
	["duji_card"] = "毒计",
	["huoshen"] = "火神",
	[":huoshen"] = "<font color=\"blue\"><b>被动技</b></font>，当你的血量不少于4时，所有群体伤害性锦囊对你无效; 当你的血量为3时，在你的回合内主动打出的【杀】和【决斗】都可以对目标额外造成1点伤害; 当你的血量为2时，其他角色在自己的回合不能主动对你出【杀】; 当你的血量为1时，回合内成功对其他角色造成伤害可立即恢复1点血",
	["$huoshen"] = "【火神】技能被触发，此群体伤害性锦囊对祝融无效",		
	["qiangxiEX"] = "强袭",
	[":qiangxiEX"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以失去1点血量或弃置一张武器牌，对你攻击范围内的一名角色造成1点伤害。",		
    ["#qiangxiEX"] = "强袭",		
	["lualieren"] = "烈刃",
	[":lualieren"] = "<font color=\"red\"><b>主动技</b></font>，每当你使用【杀】对目标角色造成一次伤害后，可与其拼点，若你赢，你获得该角色的一张牌。",		 	
	["luaxuanfeng"] = "旋风",
	[":luaxuanfeng"] = "<font color=\"red\"><b>主动技</b></font>，当你失去装备区里的牌时，或于弃牌阶段弃置了两张或更多的手牌后，你可以依次弃置一至两名其他角色的共计两张牌。",		 
	["@luaxuanfengcard"] = "请选择一至两名有手牌或装备区的牌的其他角色",
	["luaxuanfengcard"] = "旋风",
	["yuanwansha"] = "完杀",
	[":yuanwansha"] = "<font color=\"blue\"><b>被动技</b></font>，在你的回合，除你以外，只有处于濒死状态的角色才能使用【药】",				
    ["huoshen1"] = "火神",
	[":huoshen1"] = "<font color=\"blue\"><b>被动技</b></font>，当你的血量不少于4时，所有群体伤害性锦囊对你无效; 当你的血量为3时，在你的回合内主动打出的【杀】和【决斗】都可以对目标额外造成1点伤害; 当你的血量为2时，其他角色在自己的回合不能主动对你出【杀】; 当你的血量为1时，回合内成功对其他角色造成伤害可立即恢复1点血",
	["mimou"]="密谋",
    [":mimou"]="<font color=\"red\"><b>主动技</b></font>，你的方块手牌可以当作【借刀杀人】",
	["dihui"] = "诋毁",
	[":dihui"] = "<font color=\"blue\"><b>被动技</b></font>，你的【杀】生效后，目标会受到一个衰弱效果，下一次被你【杀】时，额外受到1点伤害",
    ["xguimian"] = "鬼面",
    [":xguimian"] = "<font color=\"red\"><b>主动技</b></font>，只要你对一名对象造成了伤害，本回合内可以无限对其出【杀】",
	["@xguimian"] = "请打出一张【杀】，发动技能【鬼面】",
	["xguimian_card"] = "鬼面",
	["xyuxue_buff"] = "浴血",
	[":xyuxue_buff"] = "<font color=\"blue\"><b>被动技</b></font>，每当你对1个目标造成伤害时，立即为其增加1个标记; 在你的回合结束后，当场上同时存在3个或以上的标记时，所有被标记的目标流失1点血量并清空标记（每个目标身上的标记最多只能存在1个）",
	["hongyu"] = "红玉",
	["&hongyu"] = "红玉",
	["#hongyu"] = "千古剑灵",
	["designer:hongyu"] = "轨迹",
	["cv:hongyu"] = "暂无",
	["~hongyu"] = "暂无",
	["illustrator:hongyu"] = "古剑奇谭",
	["wanjian"] = "玩剑诀",
    [":wanjian"] = "<font color=\"red\"><b>主动技</b></font>，每当你对一名角色造成伤害后，你可以对目标角色使用一张【杀】,同时每使用一张【杀】时，你摸一张牌", 
    ["@wanjian"] = "【玩剑诀】技能效果触发,你可以对目标角色使用一张【杀】",			
    ["yanfang"] = "皓华燕芳诀",
    [":yanfang"] = "<font color=\"blue\"><b>被动技</b></font>，其他角色的回合即将开始时，若你的手牌数小于血量上限，可立即将手牌数补至血量上限",		
	["jianwu"] = "剑舞",
    [":jianwu"] = "<font color=\"red\"><b>主动技</b></font>，摸牌阶段你可以放弃摸牌，并展示牌堆顶4张牌，你获得除【杀】外的展示牌，且在回合内你首次【杀】造成的伤害＋Ｘ（Ｘ=展示牌中【杀】的张数）",
    ["#jianwu"] = "【剑舞】技能效果触发,%from本回合首次【杀】造成的伤害增加%arg点",
	["shuying"] = "疏影",
    [":shuying"] = "<font color=\"red\"><b>主动技</b></font>, 在你的回合外，每当使用或打出一张【基本牌】时，可观看一名其他角色的手牌，若其手牌中有【基本牌】，则你可以获得其中的一张【基本牌】，并将此牌交给任意一名角色",
	["#shuying"] = "疏影",
	["xiaozhuang"] = "孝庄",
	["&xiaozhuang"] = "孝庄",
	["#xiaozhuang"] = "圣母皇太后",
	["designer:xiaozhuang"] = "轨迹",
	["cv:xiaozhuang"] = "暂无",
	["~xiaozhuang"] = "辅佐四帝，我心无悔/天佑大清",
	["illustrator:xiaozhuang"] = "英雄传奇",
	["tianming"] = "天命",
    [":tianming"] = "<font color=\"red\"><b>主动技</b></font>，你可以在出牌阶段发动，要求一个目标和你各弃一张手牌，若你们弃掉的花色相同，则该目标下回合跳过摸牌阶段",
	["tianming_buff"] = "天命",
	[":tianming_buff"] = "<font color=\"blue\"><b>被动技</b></font>，你可以在出牌阶段发动，要求一个目标和你各弃一张手牌，若你们弃掉的花色相同，则该目标下回合跳过摸牌阶段",
	["tianming_card"] = "天命",
	["$tianming_buff"] = "【天命】技能效果被触发，目标角色跳过他的摸牌阶段",
	["youshui"] = "游说",
    [":youshui"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以丢弃两张手牌，指定除自己外的两个目标角色，前者在自己回合内每主动造成一点伤害都立即为后者回复相应的血量直到满血",
	["youshui_card"] = "游说",
	["youshuiover"] = "游说",
	[":youshuiover"] = "<font color=\"blue\"><b>被动技</b></font>，出牌阶段，你可以丢弃两张手牌，指定除自己外的两个目标角色，前者在自己回合内每主动造成一点伤害都立即为后者回复相应的血量直到满血",
	["youshui_buff"] = "游说",
	[":youshui_buff"] = "<font color=\"blue\"><b>被动技</b></font>，出牌阶段，你可以丢弃两张手牌，指定除自己外的两个目标角色，前者在自己回合内每主动造成一点伤害都立即为后者回复相应的血量直到满血",
	["nvwa"] = "女娲",
	["&nvwa"] = "女娲",
	["#nvwa"] = "女阴娘娘",
	["designer:nvwa"] = "轨迹",
	["cv:nvwa"] = "暂无",
	["~nvwa"] = "不周将倾，需炼石补天/回归混沌之初",
	["illustrator:nvwa"] = "英雄传奇",	
    ["zaoren"]="造人",     
    [":zaoren"]="<font color=\"red\"><b>主动技</b></font>，摸牌阶段，你可以选择少摸一张牌，获得【人】标记（标记上限3）",
	["shenyou"]="神佑",     
    [":shenyou"]="<font color=\"red\"><b>主动技</b></font>，你对自己使用【药】进行血量恢复后，可以指定一名其他角色恢复一点血量",
	["wahuang"]="娲皇",     
    [":wahuang"]="<font color=\"red\"><b>主动技</b></font>，在你造成或受到伤害时，可以使用一个【人】标记实现：1.对伤害角色追加1点伤害，2.抵消你所受到的1点伤害",
	["wahuangcard"] = "娲皇",
	["@wahuangcard"] = "请选择目标，发动技能【娲皇】",	
	["hanli"] = "韩立",
	["&hanli"] = "韩立",
	["#hanli"] = "韩老魔",
	["designer:hanli"] = "轨迹",
	["cv:hanli"] = "暂无",
	["~hanli"] = "暂无",
	["illustrator:hanli"] = "凡人修仙传",
	["lingping"]="掌天瓶",
    [":lingping"]="<font color=\"blue\"><b>被动技</b></font>，回合结束时，若你的血量不满，则你可从牌堆顶展示一张牌，直至出现相同点数的牌为止，所有展示的牌均收入你的手牌",
	["#lingping"]="【掌天瓶】技能被触发,此展示的牌收入你的手牌",
	["zhanling"]="玄天斩灵",
    [":zhanling"]="<font color=\"blue\"><b>被动技</b></font>，当一名角色在其回合内对你使用第二张【杀】或在其回合内对你造成第二次伤害时，该角色流失1点血量", 
    ["liumengli"] = "柳梦璃",
	["&liumengli"] = "柳梦璃",
	["#liumengli"] = "织梦行云",
	["designer:liumengli"] = "轨迹",
	["cv:liumengli"] = "暂无",
	["~liumengli"] = "暂无",
	["illustrator:liumengli"] = "仙剑奇侠传4",						
	["hunmengmeiqu"] = "魂梦魅曲",
	[":hunmengmeiqu"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以从任意手牌数不少于你的其他角色处获得1张牌（手牌或装备区的牌）",
    ["hunmengmeiqucard"] = "魂梦魅曲",		
	["zuishengmengsi"] = "醉生梦死",
	[":zuishengmengsi"] = "<font color=\"blue\"><b>被动技</b></font>，当你从其他角色处获得手牌或装备区的牌时，若该角色的血量值不小于你，则你对该角色造成1点伤害",
	["#zuishengmengsi"] = "%arg 的技能【醉生梦死】被触发，对目标角色造成1点伤害",			
    ["tianxuanwuyin"] = "天玄五音",
    [":tianxuanwuyin"] = "<font color=\"red\"><b>主动技</b></font>，你每受到1点伤害时，可以弃置1张手牌，若此手牌与对你造成伤害的牌颜色相同，你回复1点血量; 若颜色不相同，你摸1张牌",
	["tianxuanwuyinbuff"]="你可以弃置1张手牌，发动技能【天玄五音】",
	["hanlingsha"] = "韩菱纱",
	["&hanlingsha"] = "韩菱纱",
	["#hanlingsha"] = "玉水明沙",
	["designer:hanlingsha"] = "轨迹",
	["cv:hanlingsha"] = "暂无",
	["~hanlingsha"] = "暂无",
	["illustrator:hanlingsha"] = "仙剑奇侠传4",	
    ["LUAWanSha"] = "屠戮",
	[":LUAWanSha"] = "<font color=\"blue\"><b>被动技</b></font>，在你的回合，除你以外，只有处于濒死状态的角色才能使用【药】",			
    ["yanyuduohun"] = "烟雨夺魂",	
    [":yanyuduohun"] = "<font color=\"red\"><b>主动技</b></font>，当你成为【杀】的目标时，你可以弃置1张装备牌，然后此【杀】对你无效",
    ["yanyuduohunbuff"] = "请弃置1张装备牌",
	["#yanyuduohun"] = "【烟雨夺魂】技能被触发，此【杀】无效",	
    ["lingkongzhaixing"]="凌空摘星",     
    [":lingkongzhaixing"]="<font color=\"red\"><b>主动技</b></font>，当你对一名角色造成伤害时或受到其他角色对你造成的伤害时，有50%几率你可以获得该角色的1张牌(手牌或装备区的牌)",	
    ["lingkongzhaixings"]="凌空摘星",     
    [":lingkongzhaixings"]="<font color=\"red\"><b>主动技</b></font>，当你对一名角色造成伤害时或受到其他角色对你造成的伤害时，有50%几率你可以获得该角色的1张牌(手牌或装备区的牌)",		
    ["lianjianjue"] = "无影连剑诀",
	[":lianjianjue"] = "<font color=\"red\"><b>主动技</b></font>，在你的回合开始阶段开始时，你可以视为对手牌数不大于你的一名其他角色（其在你的攻击范围内）使用一张【杀】; 在你的回合结束阶段开始时，你可以视为对当前血量值不大于你的一名其他角色（其在你的攻击范围内）使用一张【杀】",
	["xiaoyao"] = "碧瑶",
	["&xiaoyao"] = "碧瑶",
	["#xiaoyao"] = "笑靥如花",
	["designer:xiaoyao"] = "轨迹",
	["cv:xiaoyao"] = "暂无",
	["~xiaoyao"] = "暂无",
	["illustrator:xiaoyao"] = "诛仙",		
	["zhaohun"] = "招魂",
    [":zhaohun"] = "<font color=\"red\"><b>主动技</b></font>, 在你的回合开始阶段开始时，若你已受伤，且你的血量值是全场最少的或之一，则你可以选择至多X名其他角色，对其各造成1点伤害，然后你回复Y-1点血量（X为你已损失的血量值，Y为你使用【招魂】造成的伤害值）",	
    ["zhaohuncard"] = "招魂",
	["@zhaohun"] = "请选择至多X名其他角色（X为你已损失的血量值）",
	["@@zhaohun"] = "招魂",	
	["chiqing"] = "情咒", 
    [":chiqing"] = "<font color=\"red\"><b>主动技</b></font>，当一名角色成为其他角色【杀】或【决斗】的目标时（均除你外），你可以代替其成为此目标并进行一次判定，若结果为红色，你摸２张牌并任意分配，若结果为黑色，你弃掉此牌来源的角色的1张手牌",   
    ["liurushi"] = "柳如是",
	["&liurushi"] = "柳如是",
	["#liurushi"] = "风华绝代",
	["designer:liurushi"] = "轨迹",
	["cv:liurushi"] = "暂无",
	["~liurushi"] = "暂无",
	["illustrator:liurushi"] = "互联网",		       
    ["wanmei"] = "婉媚",
    [":wanmei"] = "<font color=\"red\"><b>主动技</b></font>，在你的回合开始阶段或回合结束阶段，你可以获得场上1名其他角色区域里（手牌区，装备区和判定区）的1张牌",
    ["wanmei_card"] = "婉媚",
    ["@wanmei_card"] = "请选择一名其他角色",			
    ["shuhuai"] = "抒怀",
    [":shuhuai"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以指定1名其他角色并令其声明一种牌的类型，若你交给该角色1张相同类型的手牌，则你可以选择回复1点血量或摸2张牌（每回合限一次）",
    ["shuhuaicard"] = "抒怀",	
    ["basic"] = "基本牌",
    ["trick"] = "锦囊牌",
    ["equip"] = "装备牌",	
    ["recover"] = "回复1点血量",
    ["drawcard"] = "摸2张牌",   	
	["fenji_sword"] = "焚寂",
	["#fenjiskill"] = "焚寂",
	[":#fenjiskill"] = "在你的回合内，若你以【杀】或【决斗】使一名角色进入濒死状态时，你可以发动技能【屠戮】(在你的回合，除你以外，只有处于濒死状态的角色才能使用【药】)。",
	["fenjiskillvs"] = "焚寂",
	[":fenjiskillvs"] = "<font color=\"red\"><b>焚寂专属</b></font>",	
	["fenjiskillcard"] = "焚寂",
	[":fenjiskill"] = "出牌阶段，你可以将此武器置于一名其他角色的装备区里，然后你摸1张牌；在你的回合内，若你以【杀】或【决斗】使一名角色进入濒死状态时，你可以发动技能【屠戮】（<font color=\"blue\"><b>屠戮</b></font>，在你的回合，除你以外，只有处于濒死状态的角色才能使用【药】）",
	[":fenji_sword"] = "装备牌·武器\
	攻击范围：5\
	武器特效：出牌阶段，你可以将此武器置于一名其他角色的装备区里，然后你摸1张牌；在你的回合内，若你以【杀】或【决斗】使一名角色进入濒死状态时，你可以发动技能【屠戮】（<font color=\"blue\"><b>屠戮</b></font>，在你的回合，除你以外，只有处于濒死状态的角色才能使用【药】）",	
	["fenglaiqin"] = "凤来琴",
	["#fenglaiqinskill"] = "凤来琴",
	[":#fenglaiqinskill"] = "当你从装备区里失去此装备时，你可以指定一名其他角色，视为对其使用一张【杀】",
	[":fenglaiqin"] = "装备牌·防具\
	防具特效：任何【杀】均对你无效。\
	当你从装备区里失去此装备时，你可以指定一名其他角色，视为对其使用一张【杀】",
	["#fenglaiqin_msg"] = "【%arg】技能被触发，【杀】对其无效",					 	 		
    ["sgklvbu"] = "魂·吕布",
	["&sgklvbu"] = "魂·吕布",
	["#sgklvbu"] = "飞将",
	["designer:sgklvbu"] = "轨迹",
	["cv:sgklvbu"] = "暂无",
	["~sgklvbu"] = "暂无",
	["illustrator:sgklvbu"] = "三国KILL",					
	["kuangbaowrath"]="狂暴",     
    [":kuangbaowrath"]="<font color=\"blue\"><b>被动技</b></font>，游戏开始时你获得2个“暴怒”标记；游戏中你每受到或造成1点伤害，获得1个“暴怒”标记",
	["@wrath"]="暴怒", 	
	["wumou"]="无谋",     
    [":wumou"]="<font color=\"blue\"><b>被动技</b></font>，你每使用一张非延时类锦囊（在它结算前），弃掉1个“暴怒”标记或失去1点血量",
    ["losebiaoji"]="弃掉1个暴怒标记",  
    ["losehp"]="失去1点血量", 					
    ["wuqian"]="无前",     
    [":wuqian"]="<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以弃2个“暴怒”标记并指定一名其他角色，这名角色的防具无效且你获得技能【霸王】，直到回合结束",	
	["xshenfen"]="神愤",     
    [":xshenfen"]="<font color=\"red\"><b>主动技</b></font>，出牌阶段，弃6个“暴怒”标记，你对每名其他角色各造成1点伤害，其他角色先弃掉各自装备区里所有的牌，再各弃4张手牌，然后将你的武将牌翻面（每回合限一次）",
    ["shenfencard"]="神愤", 	
	["sgkcaocao"] = "魂·曹孟德",
	["&sgkcaocao"] = "魂·曹孟德",
	["#sgkcaocao"] = "超世之英杰",
	["designer:sgkcaocao"] = "轨迹",
	["cv:sgkcaocao"] = "暂无",
	["~sgkcaocao"] = "暂无",
	["illustrator:sgkcaocao"] = "三国KILL",			
	["guixin"] = "归心",	
	[":guixin"] = "<font color=\"red\"><b>主动技</b></font>，每当你受到1点伤害后，若至少1名其他角色的区域里有牌，你可以获得每名其他角色区域里的1张牌，然后将武将牌翻面",						
	["feiying"]="飞影",     
    [":feiying"]="<font color=\"blue\"><b>被动技</b></font>，其他角色与你的距离+1",
	["litaibai"] = "李太白",
	["&litaibai"] = "李太白",
	["#litaibai"] = "青莲居士",
	["designer:litaibai"] = "轨迹",
	["cv:litaibai"] = "暂无",
	["~litaibai"] = "暂无",
	["illustrator:litaibai"] = "王者荣耀",			
	["shenbiss"] = "神笔",
    [":shenbiss"] = "<font color=\"red\"><b>主动技</b></font>，你每造成一次伤害，立即获得1个【青莲】标记（标记上限为6），当你受到伤害时，你可以弃置1个【青莲】标记，视为你对一名其他角色使用了一张无距离限制的【杀】，然后直到你的下个回合开始前，你不能成为【决斗】，【探囊取物】，【釜底抽薪】，【偷梁换柱】的目标，【烽火狼烟】，【万箭齐发】对你无效",
	["@qinglian"] = "青莲",	   					   
	["jiange"] = "剑歌",
    [":jiange"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以弃置4个【青莲】标记和所有的牌，对一名其他角色造成1点伤害并弃置其2张牌(手牌或装备区的牌)，然后你的武将牌翻面，且你不能成为【杀】的目标直到你的下个回合开始",
	["jiangecard"] = "剑歌",	   	   	  	   	   	 	 	  	   	              			
	["zhaozilong"] = "赵子龙",
	["&zhaozilong"] = "赵子龙",
	["#zhaozilong"] = "苍天翔龙",
	["designer:zhaozilong"] = "轨迹",
	["cv:zhaozilong"] = "暂无",
	["~zhaozilong"] = "暂无",
	["illustrator:zhaozilong"] = "王者荣耀",			
	["Longdanwz"] = "龙胆",
    [":Longdanwz"] = "<font color=\"red\"><b>主动技</b></font>，你可以将一张【杀】当【闪】使用或打出，或将一张【闪】当【杀】使用或打出",   		
	["Chongzhenwz"] = "冲阵",
    [":Chongzhenwz"] = "<font color=\"red\"><b>主动技</b></font>，每当你发动【龙胆】使用或打出一张手牌时，你可以获得对方的一张手牌",  			
	["sgklvmeng"] = "魂·吕蒙",
	["&sgklvmeng"] = "魂·吕蒙",
	["#sgklvmeng"] = "圣光之国士",
	["designer:sgklvmeng"] = "轨迹",
	["cv:sgklvmeng"] = "暂无",
	["~sgklvmeng"] = "暂无",
	["illustrator:sgklvmeng"] = "三国KILL",			
	["shelie"] = "涉猎",
    [":shelie"] = "<font color=\"red\"><b>主动技</b></font>，摸牌阶段开始时，你可以放弃摸牌并亮出牌堆顶的五张牌：若如此做，你获得其中每种花色的牌各一张，然后将其余的牌置入弃牌堆。",   	
	["gongxinxx"] = "攻心",
    [":gongxinxx"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以观看一名其他角色的手牌，然后选择其中一张红桃牌并选择一项：弃置之，或将之置于牌堆顶。",   
	["put"] = "置于牌堆顶",	
	["sunwukong"] = "孙悟空",
	["&sunwukong"] = "孙悟空",
	["#sunwukong"] = "美猴王",
	["designer:sunwukong"] = "轨迹",
	["cv:sunwukong"] = "暂无",
	["~sunwukong"] = "暂无",
	["illustrator:sunwukong"] = "互联网",			
    ["huoyan"]="火眼",
    [":huoyan"]="<font color=\"red\"><b>主动技</b></font>，出牌阶段每名角色限一次，你可以观看有手牌的一名其他角色的全部手牌并弃置其中的一张牌,若此牌为【基本牌】,视为你对该角色使用一张【决斗】; 技能结算完毕后，该角色摸一张牌。",
	["fenshen"] = "分身",
	["fenshenvs"] = "分身",
    [":fenshen"] = "<font color=\"red\"><b>主动技</b></font>，当你需要使用或打出一张【杀】或【闪】时，你可以流失1点血量视为你使用或打出之", 						
	["sunshangxiang"] = "孙尚香",
	["&sunshangxiang"] = "孙尚香",
	["#sunshangxiang"] = "千斤重弩",
	["designer:sunshangxiang"] = "轨迹",
	["cv:sunshangxiang"] = "暂无",
	["~sunshangxiang"] = "暂无",
	["illustrator:sunshangxiang"] = "王者荣耀",	
	["honglian"] = "红莲",
	[":honglian"] = "<font color=\"red\"><b>主动技</b></font>，当你使用【杀】时，你可以弃置一张手牌，令攻击范围内的一名其他角色打出一张【闪】，否则你对之造成1点伤害；当你使用（或打出）【闪】时，你可以将武将牌翻面，视为对一个目标使用一张【杀】。",
    ["@honglian"] = "请打出一张【闪】",
	["huangrong"] = "黄蓉",
	["&huangrong"] = "黄蓉",
	["#huangrong"] = "天之娇女",
	["designer:huangrong"] = "轨迹",
	["cv:huangrong"] = "暂无",
	["~huangrong"] = "暂无",
	["illustrator:huangrong"] = "射雕英雄传",				
    ["linglong"]="玲珑",
    [":linglong"]="<font color=\"red\"><b>主动技</b></font>，当你受到伤害后，你可以与伤害来源交换所有手牌。",
    ["#linglong"]="由于%from的【玲珑】 %arg与之交换了所有手牌",
	["tianjiao"]="天娇",
	["tianjiao_card"]="天娇",
    [":tianjiao"]="<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以弃置一名其他角色的一张牌，然后该角色可以对你使用一张【杀】。",
	["tianjiaoskill"]="请打出一张【杀】",				
	["guili"] = "鬼厉",
	["&guili"] = "鬼厉",
	["#guili"] = "血公子",
	["designer:guili"] = "轨迹",
	["cv:guili"] = "暂无",
	["~guili"] = "暂无",
	["illustrator:guili"] = "诛仙",											
	["meiying"] = "魅影",
    [":meiying"] = "<font color=\"red\"><b>主动技</b></font>, 当你成为【杀】、【决斗】、【探囊取物】或【釜底抽薪】的目标时，你可以进行一次判定，若判定牌与此牌颜色相同，则你成为此牌（或此技能）的使用者，之前此牌（或此技能）使用者成为此牌目标",	
	["dadao"] = "天道",
    [":dadao"] = "<font color=\"blue\"><b>被动技</b></font>，在你的判定牌生效后，你获得此牌",				
	["zhongwuyan"] = "钟无艳",
	["&zhongwuyan"] = "钟无艳",
	["#zhongwuyan"] = "王者之锤",
	["designer:zhongwuyan"] = "轨迹",
	["cv:zhongwuyan"] = "暂无",
	["~zhongwuyan"] = "暂无",
	["illustrator:zhongwuyan"] = "王者荣耀",		
	["zhenshe"] = "震慑",
	[":zhenshe"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以与一名其他角色拼点。若你赢，你与该角色的距离始终视为1，你获得技能【天狼】直到回合结束。若你没赢，你可以将场上的一张装备牌置于一名角色的装备区里，你跳过该回合的弃牌阶段。",	
	["spdiaochan"] = "貂蝉",
	["&spdiaochan"] = "貂蝉",
	["#spdiaochan"] = "暗黑的傀儡师",
	["designer:spdiaochan"] = "轨迹",
	["cv:spdiaochan"] = "暂无",
	["~spdiaochan"] = "暂无",
	["illustrator:spdiaochan"] = "王者荣耀",								
	["lihun"] = "离魂",
    [":lihun"] = "<font color=\"red\"><b>主动技</b></font>，你可以弃置1张牌将武将牌翻面，并选择一名男性角色：若如此做，你获得该角色的所有手牌，且出牌阶段结束时，你交给该角色X张牌（X为该角色的血量值）",
	["LihunCard"] = "离魂",			
	["xbiyue"] = "闭月",
    [":xbiyue"] = "<font color=\"red\"><b>主动技</b></font>，结束阶段开始时，你可以摸一张牌",	
	["fuwan"] = "伏完",
	["&fuwan"] = "伏完",
	["#fuwan"] = "沉毅的国丈",
	["designer:fuwan"] = "轨迹",	
	["~fuwan"] = "暂无",
	["illustrator:fuwan"] = "三国KILL",	
	["~fuwan"] = "有心除贼，无力回天",		
	["moukui"] = "谋溃",			
    [":moukui"] = "<font color=\"red\"><b>主动技</b></font>，当你使用【杀】指定一个目标后，你可以选择一项：1.摸一张牌; 2.弃置其一张牌。若如此做，当此【杀】被其使用的【闪】抵消时，你令其弃置你的一张牌。",  		
	["moukuidraw"] = "摸一张牌",	
	["moukuithrow"] = "弃置其一张牌",	
	["shenguilvbu"] = "吕布",
	["&shenguilvbu"] = "吕布",
	["#shenguilvbu"] = "神鬼无前",
	["designer:shenguilvbu"] = "轨迹",
	["cv:shenguilvbu"] = "暂无",
	["~shenguilvbu"] = "我在地狱等着你们！",
	["illustrator:shenguilvbu"] = "三国杀",					
	["luawushuang"] = "无双",
    [":luawushuang"] = "<font color=\"blue\"><b>被动技</b></font>，你使用的【杀】需两张【闪】才能抵消; 与你进行【决斗】的角色每次需打出两张【杀】。",
    ["@luawushuangjink"] = "吕布拥有【无双】技能，您必须连续出两张【闪】",
    ["@luawushuangslash"] = "吕布向您决斗，由于他有【无双】技能，您必须打出两张【杀】",			
	["shenqu"] = "神躯",
	[":shenqu"] = "<font color=\"red\"><b>主动技</b></font>，每名角色的回合开始时，若你的手牌数少于或等于你的血量上限数，你可以摸两张牌; 当你受到伤害后，你可以使用一张【药】。",		
    ["@shenqubuff"] = "【神躯】技能效果被触发，你可以使用一张【药】",			   
	["jiwu"] = "极武",
	[":jiwu"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以弃置一张手牌，然后获得一项：【强袭】、【烈刃】、【旋风】、【完杀】，直到回合结束。",				
	["sgkzhouyu"] = "魂·周瑜",
	["&sgkzhouyu"] = "魂·周瑜",
	["#sgkzhouyu"] = "大都督",	
	["cv:sgkzhouyu"] = "暂无",
	["~sgkzhouyu"] = "暂无",
	["illustrator:sgkzhouyu"] = "三国KILL",			
	["qinyinxx"] = "琴音",			
    [":qinyinxx"] = "<font color=\"red\"><b>主动技</b></font>，弃牌阶段开始时，你可以选择一项：1.摸两张牌，然后令所有角色各失去1点血量；2.弃置两张牌，然后令所有角色各回复1点血量。",  		
	["qinyinxxdraw"] = "摸两张牌，然后令所有角色各失去1点血量",	
	["qinyinxxthrow"] = "弃置两张牌，然后令所有角色各回复1点血量",			
	["yeyanxx"] = "业炎",			
    [":yeyanxx"] = "<font color=\"purple\"><b>限制技</b></font>，出牌阶段，你可以弃置至少一种花色不同的手牌，然后对一至两名角色各造成等量的伤害，若你以此法弃置的牌花色数不少于三种，你须先失去三点血量。",  		
	["yeyanxxcard"] = "业炎",		
	["spguanyu"] = "关羽",
	["&spguanyu"] = "关羽",
	["#spguanyu"] = "武圣",
	["designer:spguanyu"] = "轨迹",	
	["~spguanyu"] = "身虽陨，名可垂于诸国也/大哥...三弟...我先走一步了...",
	["illustrator:spguanyu"] = "英雄杀",			
	["xxbudao"] = "青龙偃月刀",
	[":xxbudao"] = "<font color=\"red\"><b>主动技</b></font>，在你的回合外，有角色（该角色需在你的攻击范围内）被【杀】造成伤害后，你可以对该角色打出一张【杀】，如果此【杀】造成了伤害，你可以继续对其出【杀】。",
	["@xxbudao"] = "你可以对该角色使用一张【杀】",		
	["chituma"] = "赤兔",
    [":chituma"] = "<font color=\"blue\"><b>被动技</b></font>，默认装备一匹距离为1的进攻马。",	
	["srhuangyueying"] = "黄月英",
	["&srhuangyueying"] = "黄月英",
	["#srhuangyueying"] = "归隐的杰女",	
	["designer:srhuangyueying"] = "轨迹",	
	["~srhuangyueying"] = "孔明大人，请一定要赢~",
	["illustrator:srhuangyueying"] = "三国KILL",		
	["srqicai"] = "奇才",
	[":srqicai"] = "<font color=\"red\"><b>主动技</b></font>，每当你失去一张手牌时，你可以进行判定，若结果为红色，你摸一张牌。",		
	["sgkguanyinping"] = "关银屏",
	["&sgkguanyinping"] = "关银屏",
	["#sgkguanyinping"] = "武姬",		
	["~sgkguanyinping"] = "暂无",
	["illustrator:sgkguanyinping"] = "三国KILL",			
	["LuaXueji"] = "血祭",
	[":LuaXueji"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以弃置一张红色手牌并选择至多X名其他角色（X为你已损失的血量值），对这些角色各造成1点伤害，然后这些角色各摸一张牌。",		
	["LuaXueji_Card"] = "血祭",		
	["longpao"] = "龙咆",
	[":longpao"] = "<font color=\"blue\"><b>被动技</b></font>，每当你于出牌阶段内使用的【杀】被【闪】抵消时，你可以继续使用一张【杀】。",	
    ["@longpao"] = "【龙咆】技能效果被触发，你可以继续使用一张【杀】",	
	["LuaWuji"] = "武继",
    [":LuaWuji"] = "<font color=\"purple\"><b>觉醒技</b></font>，结束阶段开始时，若你于此回合内造成过至少3点伤害，你加1点血量上限，回复1点血量，然后失去【龙咆】。",
    ["#LuaWujiMAXHP"] = "%from 的觉醒技【%arg2】被触发，增加了一点血量上限，目前血量上限是 %arg", 	
	["xhuamulan"] = "花木兰",
	["&xhuamulan"] = "花木兰",
	["#xhuamulan"] = "剑舞者",
	["designer:xhuamulan"] = "轨迹",
	["cv:xhuamulan"] = "暂无",
	["~xhuamulan"] = "暂无",
	["illustrator:xhuamulan"] = "王者荣耀",	
	["xtujin"] = "突进",
	[":xtujin"] = "<font color=\"blue\"><b>被动技</b></font>，任何其他角色的手牌数大于或等于你的手牌数时，你计算与这些角色的距离始终视为1；这些角色计算与你的距离时，始终+1。", 
    ["jianfeng"] = "剑锋",
	[":jianfeng"] = "<font color=\"red\"><b>主动技</b></font>，当你使用【杀】时，你可令该【杀】即将造成的伤害+X。（X为目标当前装备区里的牌数）",	
	["zhouzhiruo"] = "周芷若",
	["&zhouzhiruo"] = "周芷若",
	["#zhouzhiruo"] = "峨嵋派掌门",
	["designer:zhouzhiruo"] = "轨迹",
	["cv:zhouzhiruo"] = "暂无",
	["~zhouzhiruo"] = "暂无",
	["illustrator:zhouzhiruo"] = "倚天屠龙记",	
	["jiuyang"] = "九阳",
	[":jiuyang"] = "<font color=\"blue\"><b>被动技</b></font>，当你使用或打出一张【闪】时，你的下一张使用的【杀】不可被【闪】响应。当你受到一次男性角色的伤害时，失去该技能，并获得技能【阴爪】。（<font color=\"blue\"><b>被动技</b></font>，当你使一名其他角色进入濒死状态时，其立即死亡。）",	
	["lengao"] = "冷傲",
	[":lengao"] = "<font color=\"red\"><b>主动技</b></font>，当你成为【杀】的目标时，你可以弃置X张牌（X为你当前血量值），然后摸等同于对方血量值的牌。",
	["yinzhua"] = "阴爪",
	[":yinzhua"] = "<font color=\"blue\"><b>被动技</b></font>，当你使一名其他角色进入濒死状态时，其立即死亡。",
    ["spwenjiang"] = "文姜",
	["&spwenjiang"] = "文姜",
	["#spwenjiang"] = "妖艳春秋",		
	["~spwenjiang"] = "奈何？为何？/哥哥……",
	["illustrator:spwenjiang"] = "英雄传奇",						
	["xiezheng"] = "协政",
    [":xiezheng"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以指定一张手牌，你与一个任意其他角色交换所有与被指定手牌的花色相同的手牌。（每回合限1次）",		
	["wencai"]="文才",     
    [":wencai"]="<font color=\"red\"><b>主动技</b></font>，摸牌阶段，你可以多摸2张牌，若如此做，你的弃牌阶段手牌上限-2。",
	["xiezhengcard"] = "协政",
	["srluxun"] = "陆逊",
	["&srluxun"] = "陆逊",
	["#srluxun"] = "儒生雄才",	
	["designer:srluxun"] = "轨迹",	
	["~srluxun"] = "吾尚不堪大任！",
	["illustrator:srluxun"] = "三国KILL",		
	["srdailao"] = "待劳",
	["srdailao_card"] = "待劳",
	[":srdailao"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以令一名其他角色与你各摸一张牌"..
"或各弃置一张牌，然后你与其依次将武将牌翻面。",
    ["srdraw"] = "摸一张牌",
    ["srdiscard"] = "弃置一张牌",
	["srruya"] = "儒雅",
	[":srruya"] = "<font color=\"red\"><b>主动技</b></font>，当你失去最后的手牌时，你可以将手牌补至你血量上限的张数，然后将你的武将牌翻面。",	
      ["xnianshou"] = "年兽",
	["&xnianshou"] = "年兽",
	["#xnianshou"] = "除夕凶兽",
	["designer:xnianshou"] = "轨迹",
	["cv:xnianshou"] = "暂无",
	["~xnianshou"] = "唔",	
	["shiren"] = "噬人",
    [":shiren"] = "<font color=\"blue\"><b>被动技</b></font>，摸牌时，你只能摸1张牌。回合外每有角色掉血时，你立即摸1张牌。（每轮摸牌上限为4张）",    		
	["bianpao"] = "鞭炮",
	[":bianpao"] = "<font color=\"red\"><b>主动技</b></font>，回合结束，当你的手牌数不小于你的血量时，你可以掉1点血，然后指定最多X名其他角色掉1点血。（X等于你的已掉血量）",
	["@bianpao"] = "请选择最多X名其他角色（X等于你的已掉血量）发动技能【鞭炮】",	
	["meiji"] = "柳生义仙",
	["&meiji"] = "柳生义仙",
	["#meiji"] = "百花缭乱",
	["designer:meiji"] = "轨迹",
	["cv:meiji"] = "暂无",
	["~meiji"] = "暂无",
	["illustrator:meiji"] = "互联网",			
	["meinv"] = "魅惑",
	[":meinv"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段开始时，你可以展示自己的一张手牌，则当前阶段内，其他角色与此牌同名的牌进入弃牌堆时，你可以选择一项：你摸一张牌或你对其造成一点伤害。",
	["drawx"] = "你摸一张牌",
	["losex"] = "你对其造成一点伤害",	
	["jiaoyan"] = "娇艳",
    [":jiaoyan"] = "<font color=\"blue\"><b>被动技</b></font>，血量值大于你的角色对你造成伤害时，须弃置两张手牌，否则你防止此次伤害。",
	["tpgz"] = "太平公主",
	["&tpgz"] = "太平公主",
	["#tpgz"] = "方额广颐",
	["designer:tpgz"] = "轨迹",
	["cv:tpgz"] = "暂无",
	["~tpgz"] = "何不能为皇太女/本宫不会善罢甘休的",
	["illustrator:tpgz"] = "英雄传奇",	
	["zhenguo"]="镇国",     
    [":zhenguo"]="<font color=\"red\"><b>主动技</b></font>，你可以获得被你杀死的玩家的所有的牌（包括手牌，装备区的牌和判定区的牌）",
	["taiping"]="修道",     
    [":taiping"]="<font color=\"blue\"><b>被动技</b></font>，男性角色对你造成伤害结算前，你可以弃掉1张手牌使此伤害无效",
    ["@taiping"] = "请弃掉1张手牌, 发动技能【修道】",
    ["$taiping"] = "【修道】技能被触发，此伤害无效",	
	["sgzhangfei"] = "神·张飞",
	["&sgzhangfei"] = "神·张飞",
	["#sgzhangfei"] = "杀意震魂",
	["designer:sgzhangfei"] = "轨迹",
	["illustrator:sgzhangfei"] = "三国KILL",
	["~sgzhangfei"] = "汝等...杂碎，还吾...头来！！！",		
	["shayi"] = "杀意",
	["shayicard"] = "杀意",
	[":shayi"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段开始时，你可以展示所有手牌，其中每有一张【杀】，你摸1张牌; 若没有【杀】，你于本阶段可以将黑色牌当无距离限制的【暗杀】对一名其他角色使用。你使用【杀】无次数限制。",		
	["nguijianshi"] = "女鬼剑士",
	["&nguijianshi"] = "女鬼剑士",
	["#nguijianshi"] = "帝国剑士",
	["designer:nguijianshi"] = "轨迹",
	["cv:nguijianshi"] = "暂无",
	["~nguijianshi"] = "暂无",
	["illustrator:nguijianshi"] = "DNF",			
	["hunci"] = "魂刺",
	[":hunci"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以失去一点血量，然后视为对你攻击范围内的任意名其他角色依次使用一张不计入回合使用限制的【杀】。",
	["hunci_card"] = "魂刺",		
	["mingsi"] = "冥思",
    [":mingsi"] = "<font color=\"blue\"><b>被动技</b></font>，摸牌阶段，你摸X张牌。（X为你的当前血量值且至多为4）",    
	["Katarina"] = "卡特琳娜",
	["&Katarina"] = "卡特琳娜",
	["#Katarina"] = "不祥之刃",
	["designer:Katarina"] = "轨迹",
	["cv:Katarina"] = "暂无",
	["~Katarina"] = "暂无",
	["illustrator:Katarina"] = "英雄联盟",			
	["tanlan"] = "贪婪",
	[":tanlan"]="<font color=\"red\"><b>主动技</b></font>，当你使用一张【杀】时，你可以展示牌堆顶的一张牌，若为【杀】、【借刀杀人】或装备牌，你将之收入手牌；若不是，将之置入弃牌堆。",	  
	["lianhua"] = "莲华",
	[":lianhua"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以弃置X张装备区里的牌，以及X张手牌，然后对任意一名其他角色造成X点伤害。",
	["#lianhua"] = "莲华",		
    ["sgsimayi"] = "神·司马懿",
	["&sgsimayi"] = "神·司马懿",
	["#sgsimayi"] = "晋国之祖",
	["designer:sgsimayi"] = "轨迹",
	["cv:sgsimayi"] = "暂无",
	["~sgsimayi"] = "我已谋划至此，奈何……",
	["illustrator:sgsimayi"] = "三国杀",			
	["renjie"] = "忍戒",
    [":renjie"] = "<font color=\"blue\"><b>被动技</b></font>，当你受到伤害或于弃牌阶段弃牌时，获得等同于受到伤害（或弃牌）等量的“忍”标记。",				
    ["baiyin"] = "拜印",
    [":baiyin"] = "<font color=\"purple\"><b>觉醒技</b></font>，回合开始阶段开始时，若你拥有4个或更多的“忍”标记，须减1点血量上限，并获得技能【极略】（弃掉一枚“忍”标记发动下列一项技能：【鬼才】、【放逐】、【完杀】、【制衡】、【集智】）。",     		
	["@jilve_guicai"] = "请打出一张手牌使用【鬼才】技能来修改判定",	
	["#jilve_guicai"] = "极略（鬼才）",			
    [":#jilve_guicai"] = "弃掉一枚“忍”标记发动下列一项技能：【鬼才】、【放逐】、【完杀】、【制衡】、【集智】",   		
	["#jilve_jizhi"] = "极略（集智）",			
    [":#jilve_jizhi"] = "弃掉一枚“忍”标记发动下列一项技能：【鬼才】、【放逐】、【完杀】、【制衡】、【集智】",   		
	["#jilve_fangzhu"] = "极略（放逐）",			
    [":#jilve_fangzhu"] = "弃掉一枚“忍”标记发动下列一项技能：【鬼才】、【放逐】、【完杀】、【制衡】、【集智】",   	
	["jilve_fangzhutarget"] = "<font color=\"red\"><b>【放逐】</b></font>，每当你受到一次伤害后，可令一名其他角色摸X张牌（X为你已损失的血量值），然后该角色将其武将牌翻面",			
	["jilve"] = "极略",			
    [":jilve"] = "<font color=\"red\"><b>主动技</b></font>，弃掉一枚“忍”标记发动下列一项技能：【鬼才】、【放逐】、【完杀】、【制衡】、【集智】",   			
	["yuanzhiheng"] = "制衡",			
    [":yuanzhiheng"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以弃置任意数量的牌，然后摸等量的牌。",   				
	["xyuanwansha"] = "完杀",
	[":xyuanwansha"] = "<font color=\"blue\"><b>被动技</b></font>，在你的回合，除你以外，只有处于濒死状态的角色才能使用【药】",		
	["xlianpo"] = "连破",
	[":xlianpo"] = "<font color=\"blue\"><b>被动技</b></font>，若你于一回合内杀死至少一名角色，可于此回合结束后，进行一个额外的回合。",	
    ["yadianna"] = "雅典娜",
	["&yadianna"] = "雅典娜",
	["#yadianna"] = "战争女神",
	["designer:yadianna"] = "轨迹",
	["cv:yadianna"] = "暂无",
	["~yadianna"] = "暂无",
	["illustrator:yadianna"] = "王者荣耀",		
	["shengqiang"] = "圣枪",
    [":shengqiang"] = "<font color=\"blue\"><b>被动技</b></font>，当你的装备区有武器牌且【暗】标记为0时，你的【杀】对目标直接命中",
	["$shengqiang"] = "%from的<font color=\"yellow\"><b>【圣枪】</b></font>技能被触发，此【杀】不可闪避，直接命中",		  	
	["@an"] = "暗",	
	["shengdunbuff"] = "圣盾",
    [":shengdunbuff"] = "<font color=\"red\"><b>主动技</b></font>，当任意一名角色受到伤害时，你可以使此伤害对其无效，然后你获得1个【暗】标记（标记上限为3，当标记达到上限时则无法发动）；在你的出牌阶段，你可以弃置1张红色的【基本牌】取消1个【暗】标记",
    ["shengdunbuffcard"] = "圣盾",			
	["$shengdun"] = "%from的<font color=\"yellow\"><b>【圣盾】</b></font>技能被触发，此次伤害无效",						
	["qiyuan"] = "祈愿",
    [":qiyuan"] = "<font color=\"blue\"><b>被动技</b></font>，你的回合开始阶段开始时，若【暗】标记为3，则你弃掉所有【暗】标记，并展示牌堆顶3张牌，其中每有1张黑色牌你流失1点血量，其余的牌收入你的手牌",	
	["Akali"] = "阿卡丽",
	["&Akali"] = "阿卡丽",
	["#Akali"] = "暗影之拳",
	["designer:Akali"] = "轨迹",
	["cv:Akali"] = "暂无",
	["~Akali"] = "暂无",
	["illustrator:Akali"] = "英雄联盟",		
	["cangfei"] = "苍绯",
	[":cangfei"]="<font color=\"red\"><b>主动技</b></font>，摸牌阶段，你可以少摸一张牌，然后展示牌堆顶的三张牌，你获得其中的红色牌，然后将其余的牌置入弃牌堆。", 		
    ["sanhua"] = "散华",
	[":sanhua"]="<font color=\"red\"><b>主动技</b></font>，当你受到一次伤害后，你可以弃置任意数量的红色牌，然后对等量名其他角色各造成1点伤害。",	 	
	["@sanhua"] = "弃置任意数量的<font color=\"red\"><b>红色</b></font>牌，然后选择等量名其他角色",
	["moxi"] = "妺喜",
	["&moxi"] = "妺喜",
	["#moxi"] = "千古妖姬",
	["designer:moxi"] = "轨迹",
	["cv:moxi"] = "暂无",
	["~moxi"] = "与其钟情一人,不如祸害苍生/臣妾何罪",
	["illustrator:moxi"] = "英雄传奇",
	["yaoji"] = "妖姬",
	[":yaoji"] = "<font color=\"blue\"><b>被动技</b></font>，对你造成伤害的角色将获得一个【仇恨】标记，在其回合开始阶段进行判定，若为黑桃，则跳过他的出牌阶段。若判定前此玩家已中【画地为牢】，则该标记延后至下一回合开始判定，该标记无法叠加",	
	["#yaoji"] = "【妖姬】技能被触发，目标角色跳过他的出牌阶段",	
	["liebo"]="裂帛",
    [":liebo"]="<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以使用任意张手牌与场内指定目标交换对应数量的手牌，或使用全部手牌与指定目标交换全部手牌（每回合限用1次）",
    ["luna"] = "露娜",
	["&luna"] = "露娜",
	["#luna"] = "月光之女",
	["designer:luna"] = "轨迹",
	["cv:luna"] = "暂无",
	["~luna"] = "暂无",
	["illustrator:luna"] = "王者荣耀",		
	["feixi"] = "飞袭",
    [":feixi"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以弃置1张黑色牌并选择一名其他角色，该角色获得1个【月】标记（每个目标身上的标记最多只能存在1个）",
	["feixicard"] = "飞袭",
	["@yue"] = "月",				
	["yuezhan"] = "月斩",
    [":yuezhan"] = "<font color=\"red\"><b>主动技</b></font>，拥有【月】标记的角色出【杀】对你造成伤害结算前，你可以弃置其【月】标记，抵消你所受到的1点伤害",					
	["jianmang"] = "剑芒",
    [":jianmang"] = "<font color=\"blue\"><b>被动技</b></font>，你的【杀】对拥有【月】标记的角色造成伤害时，若该角色未死亡，则场内其他拥有【月】标记的角色也会受到你对其同等的伤害，然后场上所有的【月】标记清零",		   	   	  	   	   	 	 	  	   	          		
    ["xiahoulinxiu"] = "夏侯琳秀",
    ["&xiahoulinxiu"] = "夏侯琳秀",
    ["#xiahoulinxiu"] = "群友DIY",
    ["designer:xiahoulinxiu"] = "轨迹",
    ["cv:xiahoulinxiu"] = "暂无",
    ["illustrator:xiahoulinxiu"] = "暂时没有",
    ["~xiahoulinxiu"] = "你们不要调戏我......",	
    ["LuaYinYuan"]="姻缘",
    ["LuaYinYuanbuff"]="请用一张相同花色的牌与之交换",
    [":LuaYinYuan"]="<font color=\"red\"><b>主动技</b></font>，出牌阶段，你可以展示至少一张手牌，并选择一名男性角色，其须用相同花色的手牌与你展示的牌进行一对一的交换，若其没有依此法交换任何牌，则你对其造成1点伤害。\n★当你展示的牌不止一张时，目标角色可以交换任意张牌，但如果交换的牌数小于1，则其受到1点伤害。",			
    ["jiaorong"] = "娇容", 
    ["$jiaorong"]="你们这些男人，为何总要打打杀杀？",
    [":jiaorong"] = "<font color=\"blue\"><b>被动技</b></font>，你对男性角色使用【杀】或男性角色对你使用【杀】时，你摸１张牌。",						
    ["LuaZhaoQin"]="招亲",
    [":LuaZhaoQin"]="<font color=\"red\"><b>限制技</b></font>，出牌阶段，你可以令所有手牌数不为0的男性角色进行集体拼点，点数最大的角色与你各恢复1点体力，点数最小的角色受到1点无来源的伤害。",	
    ["newhuahua"] = "花落",
    ["&newhuahua"] = "花落",
    ["#newhuahua"] = "群友DIY",
    ["designer:newhuahua"] = "轨迹",
    ["cv:newhuahua"] = "暂无",
    ["illustrator:newhuahua"] = "暂时没有",
    ["~newhuahua"] = "我竟无言以对......",	
    ["huahua"] = "霸体",	
    ["huahuacard"] = "霸体",	
    [":huahua"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以按下列规则各弃置一张牌并选择任意数量的角色：\
    >武器牌+【合纵连横】：你依次对这些角色各使用一张不计入回合使用限制且无距离限制的【杀】,然后这些角色进入“连横”状态，\
    >防具牌+【杀】：你须对这些角色各选择一项：流失1点血量，或回复1点血量\
    >坐骑牌+【闪】：你获得这些角色各一张牌（手牌或装备区的牌）\
    >基本牌+锦囊牌：这些角色各摸X+1张牌\
   （X为你已损失的血量值）",
   ["lshp"] = "流失1点血量",
   ["recover"] = "回复1点血量",		
   ["xyingxi"] = "影袭",  
   [":xyingxi"] = "<font color=\"red\"><b>主动技</b></font>，其他角色在回合内每回复1点血量时，你可以令其立即获得一枚“袭”标记，每有一枚“袭”标记，手牌上限-1，回合结束之后，弃置其全部的“袭”标记。",	
   ["shenlou"]="蜃楼",     
   [":shenlou"]="<font color=\"red\"><b>主动技</b></font>，每当你受到1点伤害后，你可以选择一项：先弃置伤害来源一张牌，然后你与其各摸一张牌，或你观看牌堆顶的3张牌，将任意数量的牌置于牌堆顶，将其余的牌置于牌堆底,然后你摸一张牌。", 
   ["mdo"]="观看牌堆顶的3张牌，然后你摸一张牌",  
   ["mdraw"]="弃置伤害来源一张牌，然后你与其各摸一张牌",  	
 	["wzjingke"] = "荆轲",
	["&wzjingke"] = "荆轲",
	["#wzjingke"] = "致命诱惑",
	["designer:wzjingke"] = "轨迹",
	["cv:wzjingke"] = "暂无",
	["~wzjingke"] = "暂无",
	["illustrator:wzjingke"] = "王者荣耀",
	["liren"] = "利刃",
	[":liren"] = "<font color=\"blue\"><b>被动技</b></font>，若你的【杀】对目标角色造成伤害，则目标角色武将牌翻面; 若你使用的【杀】被闪避，则你将武将牌翻面。", 
    ["liaoya"] = "獠牙",
	[":liaoya"] = "<font color=\"red\"><b>主动技</b></font>，你的【杀】对目标角色造成伤害后，你可以进行一次判定，若判定牌为红色花色，则你回复一点血量。",			
    ["xhuangdi"] = "秦始皇",
	["&xhuangdi"] = "秦始皇",
	["#xhuangdi"] = "王者独尊",
	["designer:xhuangdi"] = "轨迹",
	["cv:xhuangdi"] = "暂无",
	["~xhuangdi"] = "暂无",
	["illustrator:xhuangdi"] = "王者荣耀",	
    ["xxzhiba"]="雄略",     
    [":xxzhiba"]="<font color=\"red\"><b>主动技</b></font>，出牌阶段限X+1次，你可以弃置至少一张牌，若如此做，你摸等量的牌（X为你已损失的血量值）",  	
	["zhuchongba"] = "朱元璋",
	["&zhuchongba"] = "朱元璋",
	["#zhuchongba"] = "洪武帝",
	["designer:zhuchongba"] = "轨迹",
	["~zhuchongba"] = "朕，乃万岁...",	
	["qiangyun"] = "强运",
    [":qiangyun"] = "<font color=\"blue\"><b>被动技</b></font>，在任意一名角色的回合内，每当你失去或者用掉最后一张手牌时，可以立即从牌堆摸两张牌，然后，在此回合内，当你再次失去或者用掉一张手牌时，可以立即从牌堆摸两张牌。",    	
	["wangyi"] = "王异",
	["&wangyi"] = "王异",
	["#wangyi"] = "决意巾帼",
	["designer:wangyi"] = "轨迹",
	["cv:wangyi"] = "暂无",
	["~wangyi"] = "吾之家仇，何日得报？",
	["illustrator:wangyi"] = "三国杀",			
	["zhenlie"]="贞烈",
    [":zhenlie"]="<font color=\"red\"><b>主动技</b></font>，每当你的判定牌生效前，你可以亮出牌堆顶的一张牌代替之",		
	["miji"]="秘计",
    [":miji"]="<font color=\"red\"><b>主动技</b></font>，回合开始或结束阶段开始时，若你已受伤，你可以进行判定：若结果为黑色，你观看牌堆顶的X张牌然后将之交给一名角色（X为你已损失的血量值）",
}
	
	




