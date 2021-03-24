module("extensions.zceshib",package.seeall)
extension=sgs.Package("zceshib")

xwuzetian = sgs.General(extension, "xwuzetian", "wu", 4, false)
zetian=sgs.CreateTriggerSkill{
name="zetian",
--view_as_skill=!!_vs,
events={sgs.PhaseChange},
frequency = sgs.Skill_Frequent,
--priority
on_trigger=function(self,event,player,data)
	local room=player:getRoom()	
	local selfplayer=room:findPlayerBySkillName(self:objectName())
	local otherplayers=room:getOtherPlayers(selfplayer)
	--local effect=data:toCardEffect()
	if selfplayer:getPhase()==sgs.Player_Start then
		selfplayer:drawCards(1)
		room:playSkillEffect("xiuluo",59)
	elseif selfplayer:getPhase()==sgs.Player_Finish then
		selfplayer:drawCards(1)
	end	
end,
}
xwuzetian:addSkill("guihan")	
xwuzetian:addSkill(zetian)		
xwuzetian:addSkill("nvquan")	
xwuzetian:addSkill("jijiang")

xcc = sgs.General(extension, "xcc", "wu", 4)	

	dushi1 = sgs.CreateViewAsSkill{
	name = "dushi1",
	n = 1,
	
	view_filter = function(self, selected, to_select)
		return to_select:isRed()
	end,
	
	view_as = function(self, cards)
		if #cards < 1 then
			return nil
		end
		if #cards == 1 then
			local card = cards[1]
			local suit = card:getSuit()
			local numb = card:getNumber()
			local acard = sgs.Sanguosha:cloneCard("jink", suit, numb)

			for _,card in ipairs(cards) do
				acard:addSubcard(card:getId())
			end
			acard:setSkillName(self:objectName())
			return acard
		end
	end,
	
	enabled_at_play = function(self, player)
		return false
	end,
	
	enabled_at_response = function(self, player, pattern)
		return pattern == "jink"

	end,
	

}	
 	
	dushi2 = sgs.CreateViewAsSkill{
	name = "dushi2",
	n = 1,
	
	view_filter = function(self, selected, to_select)
		return to_select:isBlack()
	end,
	
	view_as = function(self, cards)
		if #cards < 1 then
			return nil
		end
		if #cards == 1 then
			local card = cards[1]
			local suit = card:getSuit()
			local numb = card:getNumber()
			local acard = sgs.Sanguosha:cloneCard("nullification", suit, numb)

			for _,card in ipairs(cards) do
				acard:addSubcard(card:getId())
			end
			acard:setSkillName(self:objectName())
			return acard
		end
	end,
	
	enabled_at_play = function(self, player)
		return false
	end,
	
	enabled_at_response = function(self, player, pattern)
		return pattern == "nullification"

	end,
	
	enabled_at_nullification = function(self, player)
		return true
	end
}	




xjianxiong=sgs.CreateTriggerSkill{
	name="#xjianxiong",
	events=sgs.GameStart,
	frequency=sgs.Skill_Compulsory,
	on_trigger=function(self,event,player,data)
		local room=player:getRoom()
		room:acquireSkill(player,"jianxiongyxs")
		return false
	end, 	
	}
xcc:addSkill(dushi1)
xcc:addSkill(dushi2)

xcc:addSkill(xjianxiong)
xcc:addSkill("jijiang")				 		 	

xhuangdi = sgs.General(extension, "xhuangdi", "wu", 4)
xxzhibacard = sgs.CreateSkillCard{
	name = "xxzhiba",
	target_fixed = true,
	will_throw = true,	
	on_use = function(self, room, source, targets)
		if(source:isAlive()) then
		    room:throwCard(self)
			room:playSkillEffect("zhiheng",math.random(1, 2))
			room:drawCards(source, self:subcardsLength())
			source:loseMark("@xzhiba",1)					
		end
	end,
}
xxzhibavs = sgs.CreateViewAsSkill{
	name = "xxzhibavs",
	n = 998,		
	view_filter = function(self, selected, to_select)
		return true
	end,	
	view_as = function(self, cards)
		if #cards > 0 then
			local new_card = xxzhibacard:clone()
			local i = 0
			while(i < #cards) do
				i = i + 1
				local card = cards[i]
				new_card:addSubcard(card:getId())
			end
			new_card:setSkillName("xxzhiba")
			return new_card
		else return nil
		end
	end,	
	enabled_at_play=function(self, player)
		return player:getMark("@xzhiba")>0
	end
}
xxzhiba=sgs.CreateTriggerSkill{
name="xxzhiba",
view_as_skill=xxzhibavs,
events={sgs.PhaseChange},
can_trigger = function(self, player)
   return player:hasSkill("xxzhiba")	  
end,
on_trigger=function(self,event,player,data)
	local room=player:getRoom()	
	local player=room:findPlayerBySkillName(self:objectName())
	if event==sgs.PhaseChange then
	    if player:getPhase()==sgs.Player_Start then		
		    local x = player:getLostHp()+1		
            player:gainMark("@xzhiba",x)
		end		
		if player:getPhase()==sgs.Player_Finish then
		    player:loseAllMarks("@xzhiba")
		end					
	end
end
}
xxzhibas = sgs.CreateTriggerSkill{
    name = "#xxzhibas",
	frequency = sgs.Skill_Frequent,
    events = {sgs.Damaged},      	
    on_trigger=function(self,event,player,data)
       	if event==sgs.Damaged then 
		    local room = player:getRoom()		
		    local damage = data:toDamage()
            if player:getPhase()==sgs.Player_NotActive then return end					
            for var=1,damage.damage,1 do
		        player:gainMark("@xzhiba")								
            end
        end	
    end,		
}      
xhuangdi:addSkill(xxzhiba)
xhuangdi:addSkill(xxzhibas)
xhuangdi:addSkill("jijiang")			

xliubowen = sgs.General(extension, "xliubowen", "shu", 3)	
LuaXSuperGuanxing = sgs.CreateTriggerSkill{
		name = "LuaXSuperGuanxing",
		frequency = sgs.Skill_Frequent,
		events = {sgs.PhaseChange},
		on_trigger = function(self, event, player, data)
			if player:getPhase() == sgs.Player_Start then
				if player:askForSkillInvoke(self:objectName()) then
					local room = player:getRoom()
					room:doGuanxing(player,room:getNCards(5),false)
					 room:playSkillEffect("guanxing",math.random(1, 2))   
				end
			end
		end
	}

xliubowen:addSkill(LuaXSuperGuanxing)
xliubowen:addSkill("kongcheng")
xliubowen:addSkill("hujia")


xzhuge = sgs.General(extension, "xzhuge", "shu", 3)	

	xdongcha= sgs.CreateProhibitSkill{
     name = "xdongcha",
     is_prohibited = function(self, from, to, card)
	 
     if (to:hasSkill(self:objectName())) then
     return ((card:inherits("Duel") and card:isBlack()) or (card:inherits("Snatch") and card:isBlack()) or (card:inherits("Geanguanhuo") and card:isBlack()) or (card:inherits("Toulianghuanzhu") and card:isBlack()) or (card:inherits("IronChain") and card:isBlack()) or (card:inherits("Lightning") and card:isBlack()) or (card:inherits("SupplyShortage") and card:isBlack()) or (card:inherits("Indulgence") and card:isBlack()) or (card:inherits("Snatch") and card:isBlack()) or (card:inherits("Dismantlement") and card:isBlack()) or (card:inherits("Collateral") and card:isBlack()) or (card:inherits("ExNihilo") and card:isBlack()))  
     end
     end
}
xdongchas=sgs.CreateTriggerSkill{
	name="#xdongchas",
	frequency=sgs.Skill_Compulsory,
	events={sgs.CardEffected},	
	can_trigger = function(self, player)
	    return player:hasSkill("#xdongchas")	      
    end,
	on_trigger=function(self,event,player,data)
	    if event==sgs.CardEffected then
		   local card=data:toCardEffect().card
		   local room=player:getRoom()
		   local player=room:findPlayerBySkillName(self:objectName())
		   	   		  
		        if ((card:inherits("SavageAssault") and card:isBlack()) or (card:inherits("AmazingGrace") and card:isBlack()) or (card:inherits("ArcheryAttack") and card:isBlack()) or (card:inherits("GodSalvation") and card:isBlack()) ) then 		   		  		     	  		           
					 room:setEmotion(player,"weimu") 
					 room:playSkillEffect("xiuluo",44)  
					return true
					  
	            end
		   
		end
	end
}	   	   	  
 	   	 	   
luajizhi = sgs.CreateTriggerSkill
{--集智 by 【群】皇叔
    name = "luajizhi",
    events = {sgs.CardUsed},
    frequency = sgs.Skill_Frequent,
    on_trigger = function(self, event, player, data)
        local room = player:getRoom()
        local card = data:toCardUse().card
        if card:isNDTrick() then 
            if not room:askForSkillInvoke(player, "luajizhi") then return false end
            player:drawCards(1)
			room:playSkillEffect("jizhi",math.random(2,3))
		elseif card:inherits("DelayedTrick") then 
            if not room:askForSkillInvoke(player, "luajizhi") then return false end
            player:drawCards(1)
			room:playSkillEffect("jizhi",1)
        end 
    end,
}
xzhuge:addSkill(xdongcha)		
xzhuge:addSkill(xdongchas)	
xzhuge:addSkill(luajizhi)
xzhuge:addSkill("hujia")

xxlvzhi = sgs.General(extension, "xxlvzhi", "wu", 4, false)

	LuaXJianshou = sgs.CreateTriggerSkill{
		name = "LuaXJianshou",
		frequency = sgs.Skill_Frequent,
		events = {sgs.PhaseChange},
		on_trigger = function(self, event, player, data)
			if player:getPhase() == sgs.Player_Finish then
				if player:askForSkillInvoke(self:objectName(), data) then
				
					
				player:drawCards(5)	
					
					player:gainMark("@xumou",1)	
					room:setEmotion(player,"xumou") 
					 room:playSkillEffect("wansha",math.random(22, 23))	
				end
			end
		end
}
xxlvzhi:addSkill(LuaXJianshou)
xxlvzhi:addSkill("zhensha")
xxlvzhi:addSkill("jijiang")	
 
zhuchongba = sgs.General(extension, "zhuchongba", "wu", 4)	
qiangyun = sgs.CreateTriggerSkill{
	name = "qiangyun",
	events = {sgs.CardLost},
	frequency = sgs.Skill_Frequent,	
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local move = data:toCardMove()	
		if player:getMark("qiangyun") <= 0 then		
		    if player:isKongcheng() and move.from_place == sgs.Player_Hand then      
			    if room:askForSkillInvoke(player, self:objectName()) == true then
                    room:setEmotion(player,"lianying") 
                    room:playSkillEffect("lianying",math.random(1, 2))   					
				    player:drawCards(2)				
				    room:setPlayerMark(player,"qiangyun",1)	
                end
            end				
		else			
			if not player:isKongcheng() and move.from_place == sgs.Player_Hand then
			    if room:askForSkillInvoke(player, self:objectName()) == true then
                    room:setEmotion(player,"lianying") 
					room:playSkillEffect("lianying",math.random(1, 2))   					
				    player:drawCards(2)
				    room:setPlayerMark(player,"qiangyun",0)
			    end	
		    end
        end			
end
}
qiangyunbuff=sgs.CreateTriggerSkill{
	name="#qiangyunbuff",
	frequency=sgs.Skill_Compulsory,
	events={sgs.PhaseChange},
	priority=1,
    can_trigger=function() 
        return true
    end,	
	on_trigger=function(self,event,player,data)		
    local room = player:getRoom()			      				                       
	local zyz=room:findPlayerBySkillName(self:objectName()) 
	if not (zyz) then return end	
	if event == sgs.PhaseChange and player:getPhase()==sgs.Player_Finish then  	 	 		
	    room:setPlayerMark(zyz,"qiangyun",0)
		end
	end					
}		
zhuchongba:addSkill(qiangyun)
zhuchongba:addSkill(qiangyunbuff)		
zhuchongba:addSkill("jijiang")			

xyuji = sgs.General(extension, "xyuji", "shu", 4, false)
xyuji:addSkill("yiji")		
xyuji:addSkill("hujia")			

xluzhishen = sgs.General(extension, "xluzhishen", "wei", 4)
fuye = sgs.CreateTriggerSkill{
	name = "fuye", 
	frequency = sgs.Skill_NotFrequent, 
	events = {sgs.Dying},  
	on_trigger = function(self, event, player, data) 
		local dying = data:toDying()
		local dest = dying.who
		local room = dest:getRoom()
		local source = room:findPlayerBySkillName("fuye")
		if source:objectName() ~= dest:objectName() then
			if room:askForSkillInvoke(source, "fuye", data) then
				room:loseHp(source, 1)
				room:playSkillEffect("wansha",math.random(17))
				local recover = sgs.RecoverStruct()
				recover.who = dest
				recover.recover = 1
				room:recover(dest, recover)
			end
		end
	end, 
	can_trigger = function(self, target)
		return (target ~= nil)
	end, 
}
xluzhishen:addSkill(fuye)		
xluzhishen:addSkill("dili")		
xluzhishen:addSkill("jiuyuan")			

xzhangsanfeng = sgs.General(extension, "xzhangsanfeng", "wei", 4)		
 xbushi=sgs.CreateTriggerSkill{
	name="#xbushi",
	events=sgs.GameStart,
	frequency=sgs.Skill_Compulsory,
	on_trigger=function(self,event,player,data)
		local room=player:getRoom()
		room:acquireSkill(player,"bushi")
		return false
	end, 	
	}		 	
	
meiying = sgs.CreateTriggerSkill{
    name = "meiying",
	frequency = sgs.Skill_NotFrequent,	
	events = {sgs.CardEffected,sgs.FinishJudge},	
    on_trigger = function(self, event, player, data) 	
	if event == sgs.CardEffected then	
        local room = player:getRoom()
        local player = room:findPlayerBySkillName(self:objectName())	  
	    local effect=data:toCardEffect()
	    if effect.from:objectName()~=player:objectName()then   	       
			    if effect.card:inherits("Slash") or effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement") or effect.card:inherits("Duel")  then				
                            if (effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement")) and (effect.from:isNude()) then return false end
	                        if (effect.card:inherits("Slash") or effect.card:inherits("Duel")) and (effect.from:hasSkill("kongcheng") and effect.from:isKongcheng()) then return false end
                            if effect.card:inherits("Duel") and effect.from:hasSkill("nvquan")  then return false end
                            if ((effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement") or effect.card:inherits("Duel")) and effect.card:getSuit() == sgs.Card_Spade) and (effect.from:hasSkill("weimu")) then return false end
                            if effect.card:inherits("Slash") and effect.from:getMark("@feigong2") > 0  then return false end
                            if effect.card:inherits("Slash") and  (player:getMark("@feigong1") > 0 and effect.from:getMark("@feigong3") > 0)  then return false end
                            if effect.card:inherits("Slash") and effect.card:getSuit() == sgs.Card_Spade and effect.from:hasSkill("heimian") and  effect.from:getArmor()==nil then return false end
                            if effect.card:inherits("Slash") and  (effect.from:hasSkill("meiguo") and effect.from:getHp() == 1) then return false end
                            if effect.card:inherits("Slash") and effect.from:getMark("@tongling2") > 0 then return false end
                            if effect.card:inherits("Slash") and  effect.card:isBlack() and  (effect.from:hasSkill("zhuanquan") and effect.from:getArmor()==nil) then return false end									
							if effect.card:inherits("Snatch") and effect.from:hasSkill("qingmin")  then return false end									
                            if (effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement"))  and  (effect.from:hasSkill("kongju") and effect.from:getHandcardNum() < effect.from:getMaxHp())  then return false end			               				
                            if player:askForSkillInvoke(self:objectName(),data)then
						    	local msg = sgs.LogMessage()
	                            local judge = sgs.JudgeStruct()																								
	                            judge.reason = self:objectName()
	                            judge.who = player
	                            room:judge(judge)  
	                            local color1 
								if effect.card:isRed()then
	                               color1 ="red" 
								else
								   color1 ="black"
							    end 
	                            local color2 
							    if judge.card:isRed() then
	                                color2 ="red" 
							    else
    						    	color2 ="black"
							    end 
	                            if color1 == color2 then																   									
									local msg = sgs.LogMessage()
	                                local use = sgs.CardUseStruct()
	                                use.card = effect.card
	                                use.from = player
	                                use.to:append(effect.from)
																	room:playSkillEffect("taiji",math.random(1, 2))
	                                room:useCard(use)
   																								
								    return true
                                    end									
	                        end    
	            end
        end			
	end
end,
}	
xzhangsanfeng:addSkill(xbushi)			
xzhangsanfeng:addSkill(meiying)			
xzhangsanfeng:addSkill("jiuyuan")	

xsongjiang = sgs.General(extension, "xsongjiang", "wei", 4)	
linglong = sgs.CreateTriggerSkill{	
	name = "linglong",
	frequency = sgs.Skill_NotFrequent,
	events = {sgs.Damaged},	
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local damage = data:toDamage()
		local source = damage.from
		local source_data = sgs.QVariant()
		source_data:setValue(source)
		if source then
			    if (not source:isKongcheng()) and (not player:isKongcheng()) then		        				
		            if room:askForSkillInvoke(player, "linglong") then							                       							 
						local to_exchange=source:wholeHandCards()  
                        local to_exchange2=player:wholeHandCards()		
						room:playSkillEffect("xiuluo",42) 
						room:moveCardTo(to_exchange,player,sgs.Player_Hand,true) 
                        room:moveCardTo(to_exchange2,source,sgs.Player_Hand,true)						
			            local log=sgs.LogMessage()
			            log.from =player
			            log.type ="#linglong"
		                log.arg  =source:getGeneralName()
			            room:sendLog(log)						 			 
                    end
                end							    
	    end
	end	
}
xsongjiang:addSkill(linglong)			
xsongjiang:addSkill("rende")			
xsongjiang:addSkill("jiuyuan")	

xyuefei = sgs.General(extension, "xyuefei", "shu", 4)	

Chongzhenwz = sgs.CreateTriggerSkill{
	name = "Chongzhenwz",
	events = {sgs.CardEffected, sgs.CardEffect, sgs.CardResponsed},			
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()						
		if event == sgs.CardEffected then
			local effect = data:toCardEffect()
			local value = sgs.QVariant()
			value:setValue(effect.from)
			room:setTag("ChongzhenwzTo", value)
		elseif event == sgs.CardEffect then
			local effect = data:toCardEffect()
			if effect.to:isKongcheng() then return end			
			if effect.card:getSkillName() == "longdan" then
       			if room:askForSkillInvoke(player, "Chongzhenwz") then
				    local card_id = room:askForCardChosen(effect.from, effect.to, "h", "Chongzhenwz")					
				    room:moveCardTo(sgs.Sanguosha:getCard(card_id), effect.from, sgs.Player_Hand, false)
				end
			end		
		elseif event == sgs.CardResponsed then
			local card = data:toCard()
			local target = room:getTag("ChongzhenwzTo"):toPlayer()			
			if not target then return end
            if target:isKongcheng() then return end			
			if card:getSkillName() == "longdan" then			
			    if room:askForSkillInvoke(player, "Chongzhenwz") then 			
			        local card_id = room:askForCardChosen(player, target, "h", "Chongzhenwz")	

				
			        room:moveCardTo(sgs.Sanguosha:getCard(card_id), player, sgs.Player_Hand, false)
					
		        end
	        end
		end
	end
}
xyuefei:addSkill(Chongzhenwz)			
xyuefei:addSkill("longdan")			
xyuefei:addSkill("hujia")	

xlishimin = sgs.General(extension, "xlishimin", "wu", 4)
xkongju=sgs.CreateTriggerSkill{
	name="#xkongju",
	events=sgs.GameStart,
	frequency=sgs.Skill_Compulsory,
	on_trigger=function(self,event,player,data)
		local room=player:getRoom()
		room:acquireSkill(player,"kongju")
		return false
	end, 	
	}	
shelie = sgs.CreateTriggerSkill{
	name = "shelie",
	frequency = sgs.Skill_Frequent,
	events = {sgs.PhaseChange},
	on_trigger = function(self, event, player, data)
	    local room = player:getRoom()
		if(event == sgs.PhaseChange and player:getPhase() == sgs.Player_Draw) then 	    				
		if not player:askForSkillInvoke(self:objectName()) then return false end
		local card_ids = room:getNCards(5)
		room:playSkillEffect("xiuluo",math.random(40, 41))   
		room:fillAG(card_ids,nil)
		while (not card_ids:isEmpty()) do
			local card_id = room:askForAG(player, card_ids, false, self:objectName())
			card_ids:removeOne(card_id)
			local card = sgs.Sanguosha:getCard(card_id)
			local suit = card:getSuit()
			room:takeAG(player, card_id)
			local removelist = {}
			for _,id in sgs.qlist(card_ids) do
				local c = sgs.Sanguosha:getCard(id)
				if c:getSuit() == suit then
					room:takeAG(nil, c:getId())
					table.insert(removelist, id)
				end
			end									
			if #removelist > 0 then
				for _,id in ipairs(removelist) do
					if card_ids:contains(id) then
						card_ids:removeOne(id)
					end
				end												
			end		                        			
		end										
		player:invoke("clearAG")			
		local players=sgs.SPlayerList()
		for _,p in sgs.qlist(room:getOtherPlayers(player)) do
		p:invoke("clearAG")	
		end
        return true		
	end
end
}	
xlishimin:addSkill(shelie)			
xlishimin:addSkill(xkongju)			
xlishimin:addSkill("jijiang")	

xsunwu = sgs.General(extension, "xsunwu", "shu", 3)	
gongxinxxcard = sgs.CreateSkillCard{
	name = "gongxinxx" ,
	filter=function(self,targets,to_select,player)
		return not to_select:isKongcheng()  and (#targets == 0) and (to_select:getSeat()~=player:getSeat())
	end ,
	on_effect = function(self, effect)        	
		local source = effect.from
		local dest = effect.to
		local room = source:getRoom() 
		room:setPlayerFlag(effect.from,"gongxinxxused")
		room:playSkillEffect("xiuluo",43)  
		room:doGongxin(effect.from, effect.to)		    		
	end
}
gongxinxx = sgs.CreateViewAsSkill{
	name = "gongxinxx" ,
	n = 0 ,
	view_as = function()
		return gongxinxxcard:clone()
	end ,
	enabled_at_play=function()   
	    if sgs.Self:getPhase()==sgs.Player_Finish then sgs.Self:getRoom():setPlayerFlag(sgs.Self,"-gongxinxxused") end 
	return not sgs.Self:hasFlag("gongxinxxused") 
    end,
}
xsunwu:addSkill(gongxinxx)			
xsunwu:addSkill("bingsheng")			
xsunwu:addSkill("shipo")			
xsunwu:addSkill("hujia")		

xxiaoqiao = sgs.General(extension, "xxiaoqiao", "wei", 3, false)
luaqicex=sgs.CreateViewAsSkill{

name="luaqicex",

n=999,

view_filter=function(self,selected,to_select)
return not to_select:isEquipped()
end,

view_as=function(self, cards)
local x = sgs.Self:getHandcardNum()
 if #cards < x and not sgs.Self:hasFlag("nullification")then
       return luaqicecard:clone()
   elseif #cards == x and x >0 then
     if (sgs.Self:hasFlag("blackc") and sgs.Self:hasFlag("redc")) then
       if sgs.Self:hasFlag("archeryattack") then
       local d_card = sgs.Sanguosha:cloneCard("archery_attack",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("snatch") then
	   local d_card = sgs.Sanguosha:cloneCard("snatch",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("dismantlement") then
	   local d_card = sgs.Sanguosha:cloneCard("dismantlement",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("collateral") then
	   local d_card = sgs.Sanguosha:cloneCard("collateral",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("ex_nihilo") then
	   local d_card = sgs.Sanguosha:cloneCard("ex_nihilo",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("duel") then
	   local d_card = sgs.Sanguosha:cloneCard("duel",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("geanguanhuo") then
	   local d_card = sgs.Sanguosha:cloneCard("geanguanhuo",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   	   elseif sgs.Self:hasFlag("toulianghuanzhu") then
	   local d_card = sgs.Sanguosha:cloneCard("toulianghuanzhu",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   
	   
	   elseif sgs.Self:hasFlag("amazing_grace") then
	   local d_card = sgs.Sanguosha:cloneCard("amazing_grace",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("savage_assault") then
	   local d_card = sgs.Sanguosha:cloneCard("savage_assault",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("god_salvation") then
	   local d_card = sgs.Sanguosha:cloneCard("god_salvation",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	    elseif sgs.Self:hasFlag("iron_chain") then
	   local d_card = sgs.Sanguosha:cloneCard("iron_chain",  sgs.Card_NoSuit, 0)
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("nullification") then
	    local d_card=sgs.Sanguosha:cloneCard("nullification",  sgs.Card_NoSuit, 0)
	    local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
       end
	 else
	    if sgs.Self:hasFlag("archeryattack") then
       local d_card = sgs.Sanguosha:cloneCard("archery_attack",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("snatch") then
	   local d_card = sgs.Sanguosha:cloneCard("snatch", cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("dismantlement") then
	   local d_card = sgs.Sanguosha:cloneCard("dismantlement",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("collateral") then
	   local d_card = sgs.Sanguosha:cloneCard("collateral",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("ex_nihilo") then
	   local d_card = sgs.Sanguosha:cloneCard("ex_nihilo",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("duel") then
	   local d_card = sgs.Sanguosha:cloneCard("duel",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("geanguanhuo") then
	   local d_card = sgs.Sanguosha:cloneCard("geanguanhuo",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("toulianghuanzhu") then
	   local d_card = sgs.Sanguosha:cloneCard("toulianghuanzhu",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("amazing_grace") then
	   local d_card = sgs.Sanguosha:cloneCard("amazing_grace",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("savage_assault") then
	   local d_card = sgs.Sanguosha:cloneCard("savage_assault",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("god_salvation") then
	   local d_card = sgs.Sanguosha:cloneCard("god_salvation",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	    elseif sgs.Self:hasFlag("iron_chain") then
	   local d_card = sgs.Sanguosha:cloneCard("iron_chain",  cards[1]:getSuit(), cards[1]:getNumber())
	   local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
	   elseif sgs.Self:hasFlag("nullification") then
	    local d_card=sgs.Sanguosha:cloneCard("nullification",  cards[1]:getSuit(), cards[1]:getNumber())
	    local y=0
       for var=1,x,1 do
	   y=y+1
       d_card:addSubcard(cards[y]:getId())
	   end
       d_card:setSkillName(self:objectName())
       return d_card
       end 
  end
end  

end,

enabled_at_play=function(self,player,pattern)

return sgs.Self:hasFlag("qcused") and sgs.Self:getHandcardNum() > 0
end,

enabled_at_response=function(self,player,pattern)

return sgs.Self:hasFlag("qcused") and pattern=="nullification" and sgs.Self:getHandcardNum() > 0

end,

}

luaqicecard = sgs.CreateSkillCard
{--技能卡
        name="luaqicecard",
        target_fixed=true,
        will_throw=true,
		on_use = function(self, room, source, targets)
         local room = source:getRoom()
		 local choice=room:askForChoice(source, self:objectName(), "snatch+dismantlement+collateral+ex_nihilo+duel+geanguanhuo+toulianghuanzhu+amazing_grace+savage_assault+archery_attack+god_salvation+iron_chain")
		 if  choice == "archery_attack" then
            room:setPlayerFlag(source, "archeryattack")
			room:setPlayerFlag(source, "-qcused")	
		    source:addMark("qc")
        elseif choice == "snatch" then
		    room:setPlayerFlag(source, "snatch")
            room:setPlayerFlag(source, "-qcused")			
		    source:addMark("qc")
		elseif choice == "dismantlement" then
		    room:setPlayerFlag(source, "dismantlement")
			room:setPlayerFlag(source, "-qcused")
		    source:addMark("qc")
		elseif  choice == "collateral" then 
		   room:setPlayerFlag(source, "collateral")
		   room:setPlayerFlag(source, "-qcused")			 
		   source:addMark("qc")
        elseif choice == "ex_nihilo" then
		     room:setPlayerFlag(source, "ex_nihilo")
             room:setPlayerFlag(source, "-qcused")			 
		     source:addMark("qc")
        elseif choice == "duel" then
		    room:setPlayerFlag(source, "duel")
			room:setPlayerFlag(source, "-qcused")
		    source:addMark("qc")
        elseif choice == "geanguanhuo" then
		   room:setPlayerFlag(source, "geanguanhuo")
		   room:setPlayerFlag(source, "-qcused")
		   source:addMark("qc")
		   elseif choice == "toulianghuanzhu" then
		   room:setPlayerFlag(source, "toulianghuanzhu")
		   room:setPlayerFlag(source, "-qcused")
		   source:addMark("qc")
        elseif  choice == "amazing_grace" then 
		   room:setPlayerFlag(source, "amazing_grace")
		   room:setPlayerFlag(source, "-qcused")
		   source:addMark("qc")
		elseif  choice == "savage_assault" then 
		   room:setPlayerFlag(source, "savage_assault")
		   room:setPlayerFlag(source, "-qcused")
		   source:addMark("qc")
        elseif  choice == "god_salvation" then 
		   room:setPlayerFlag(source, "god_salvation")
		   room:setPlayerFlag(source, "-qcused")
		   source:addMark("qc")
		elseif choice == "iron_chain" then
		   room:setPlayerFlag(source, "iron_chain")
		   room:setPlayerFlag(source, "-qcused")
		   source:addMark("qc")	
        end		
			room:playSkillEffect("xiuluo",60)		
		end,
		}
						
luaqice = sgs.CreateTriggerSkill{
 name="luaqice",
 view_as_skill = luaqicex,
 events={sgs.PhaseChange,sgs.CardUsed,sgs.CardFinished,sgs.CardResponsed},
 frequency = sgs.Skill_Frequency,
 on_trigger=function(self,event,player,data)
  local room = player:getRoom()
  local cardu=data:toCardUse().card
   if  (event == sgs.PhaseChange and player:getPhase() == sgs.Player_Play) then
		    room:setPlayerFlag(player, "qcused")
			player:addMark("cannull")
  end
  if event == sgs.CardFinished then
  if (player:getMark("qc")) > 0 then
     local idlist = player:handCards()
	 for _,id in sgs.qlist(idlist) do
	   if not player:hasSkill("hongyan") and (sgs.Sanguosha:getCard(id):getSuit() == sgs.Card_Spade or sgs.Sanguosha:getCard(id):getSuit() == sgs.Card_Club) then 
		  room:setPlayerFlag(player, "blackc")
       elseif not player:hasSkill("hongyan") and (sgs.Sanguosha:getCard(id):getSuit() == sgs.Card_Heart or sgs.Sanguosha:getCard(id):getSuit() == sgs.Card_Diamond) then
          room:setPlayerFlag(player, "redc")
       end		  
	  if player:hasSkill("hongyan") and sgs.Sanguosha:getCard(id):getSuit() == sgs.Card_Club then
       room:setPlayerFlag(player, "blackc")
	  elseif player:hasSkill("hongyan") and (sgs.Sanguosha:getCard(id):getSuit() == sgs.Card_Heart or sgs.Sanguosha:getCard(id):getSuit() == sgs.Card_Diamond or sgs.Sanguosha:getCard(id):getSuit() == sgs.Card_Spade) then
       room:setPlayerFlag(player, "redc")
      end  
	 end
     if player:hasFlag("archeryattack") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@archeryattack:")
	 elseif player:hasFlag("snatch") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@snatch:")
     elseif player:hasFlag("dismantlement") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@dismantlement:")
     elseif player:hasFlag("collateral") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@collateral:")
     elseif player:hasFlag("ex_nihilo") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@ex_nihilo:")
     elseif player:hasFlag("duel") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@duel:")
     elseif player:hasFlag("geanguanhuo") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@geanguanhuo:")
		elseif player:hasFlag("toulianghuanzhu") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@toulianghuanzhu:")
     elseif player:hasFlag("amazing_grace") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@amazing_grace:")
     elseif player:hasFlag("savage_assault") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@savage_assault:")
	elseif player:hasFlag("god_salvation") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@god_salvation:")
	elseif player:hasFlag("iron_chain") then
        qcuse = room:askForUseCard(player, "@@luaqice", "@iron_chain:")
    end	
        room:setPlayerFlag(player, "-blackc")
        room:setPlayerFlag(player, "-redc")		
	       if qcuse then return false end
		   room:setPlayerFlag(player, "qcused")
		   room:setPlayerFlag(player, "-archeryattack")
		   room:setPlayerFlag(player, "-snatch")
		   room:setPlayerFlag(player, "-dismantlement")
		   room:setPlayerFlag(player, "-collateral")
		   room:setPlayerFlag(player, "-ex_nihilo")
		   room:setPlayerFlag(player, "-duel")
		   room:setPlayerFlag(player, "-fire_attack")

		   room:setPlayerFlag(player, "-amazing_grace")
		   room:setPlayerFlag(player, "-savage_assault")
		   room:setPlayerFlag(player, "-god_salvation")
		   room:setPlayerFlag(player, "-iron_chain")
           player:setMark("qc",0)		   		   
  end
  end
  if event == sgs.CardUsed and cardu:isNDTrick() then
     if cardu:inherits("Nullification") then return false end
     room:setPlayerFlag(player, "nullification")
	 if cardu:getSkillName() == "luaqicex" then
	     player:setMark("cannull",0)
	 end	   
  end
	if event == sgs.CardResponsed then
			local card = data:toCard()
			if card:inherits("Nullification") then
			  if card:getSkillName() == "luaqicex" then
	          room:setPlayerFlag(player, "-qcused")
			  player:setMark("cannull",0)
              end
            end			  
    end
  if event == sgs.CardUsed and (player:getMark("qc")) > 0 then
     player:setMark("qc",0)
  end
  if (event == sgs.CardFinished) and player:hasFlag("nullification") then
     room:setPlayerFlag(player, "-nullification")
  end
   
  if  (event == sgs.PhaseChange and player:getPhase() == sgs.Player_Finish) then
		    player:setMark("qc",0)
			player:setMark("cannull",0)
  end
 end,
 }
 lguose = sgs.CreateProhibitSkill{
	name = "lguose",
	is_prohibited = function(self, from, to, card)
		if(to:hasSkill("lguose")) then
			return card:inherits("Slash") and card:isRed()
		end
	end,
}
xxiaoqiao:addSkill(luaqice)
xxiaoqiao:addSkill(lguose)
xxiaoqiao:addSkill("tianxian")
xxiaoqiao:addSkill("bazhen")
xxiaoqiao:addSkill("jiuyuan")

baiban = sgs.General(extension, "baiban", "wei", 4, false)
   xqinxn=sgs.CreateTriggerSkill{
name="xqinxn",
events={sgs.PhaseChange},
frequency = sgs.Skill_NotFrequent,
on_trigger=function(self,event,player,data)
	local room=player:getRoom()	
	local selfplayer=room:findPlayerBySkillName(self:objectName())
	local otherplayers=room:getOtherPlayers(selfplayer)
	if event==sgs.PhaseChange then
		if (selfplayer:getPhase()==sgs.Player_Start) then
			local sklist_chosen=selfplayer:getTag("xqinxn_sklist"):toString():split("|")
			for var=1,#sklist_chosen,1 do
				room:detachSkillFromPlayer(selfplayer,sklist_chosen[var])				
			end
			sklist_chosen={}
			if (room:askForSkillInvoke(selfplayer,self:objectName(),data)~=true) then return false end
			local pfc=room:getOtherPlayers(selfplayer)
			for var=1,selfplayer:getMaxHp()-2,1 do
				local pc=room:askForPlayerChosen(selfplayer,pfc,self:objectName())
				if pc~=nil then
					local str=""
					local sklist={}					
					for _,sk in sgs.qlist(pc:getGeneral():getVisibleSkillList()) do
						if (not sk:isLordSkill()) and (not (sk:getFrequency()==sgs.Skill_Limited)) and (not (sk:getFrequency()==sgs.Skill_Wake)) then
							table.insert(sklist,sk:objectName())
						end									
					end					
					for var=1,#sklist,1 do
						str=str..sklist[var]
						str=str.."+"						
					end
					str=str.."xqinxn_cancel"
					local strc=room:askForChoice(selfplayer, self:objectName(), str)
					if strc ~= "xqinxn_cancel" then
						table.insert(sklist_chosen,strc)				
					end
					room:acquireSkill(selfplayer,strc)
					pfc:removeOne(pc)
				end				
			end
			selfplayer:setTag("xqinxn_sklist",sgs.QVariant(table.concat(sklist_chosen,"|")))
		end
	end
end,
}
   
baiban:addSkill(xqinxn)
		
sgs.LoadTranslationTable{
["zceshib"] = "测试包",	
 
 ["xwuzetian"] = "武则天",
	["#xwuzetian"] = "逆天改命",
	["zetian"] = "择天",
	[":zetian"] = "主动技，你的回合开始和结束时都可以摸一张牌。",

	["~xwuzetian"] = "何人懂我/唉~~",
 
     ["xcc"] = "曹操",
	["#xcc"] = "全能之王",
	["dushi1"]="败走",
	[":dushi1"]="主动技，你的红牌可以当【闪】使用。",
    ["dushi2"]="多疑",
	[":dushi2"]="主动技，你的黑牌可以当【无懈可击】使用。",
	["~xcc"] = "世人，皆看错我曹操/谁能懂我",
 
    ["xhuangdi"] = "刘邦",
	["#xhuangdi"] = "驭霸刘邦",
	["xxzhiba"] = "驭霸",
	[":xxzhiba"] = "主动技，出牌时，你可以选择弃掉自己任意数量的手牌和装备区的牌，立即从牌堆重新摸取相同数量的牌。每回合限使用次数为1+当前掉血数。",
	["$zhiheng1"] = "知人善用，此乃王道",
	["$zhiheng2"] = "知进退，明得失",
	["~xhuangdi"] = "这是鸿门宴吗？/项庄，你！",
	
	["xliubowen"] = "刘伯温",
	["#xliubowen"] = "五星神算",
	["LuaXSuperGuanxing"] = "神卜",
	[":LuaXSuperGuanxing"] = "主动技，到你回合时，可以观看5张牌，然后可以自由调整这5张牌的摆放顺序，再放回牌堆。可以将一部分放在牌堆顶，其余的放在牌堆底。",
	["kongcheng"] = "归隐",
	[":kongcheng"] = "被动技，当你手里没牌的时候，其他人不可以主动出【杀】或者【决斗】攻击你",
	["#GuanxingResult"] = "%from 的观星结果：%arg 上 %arg2 下",
	["$guanxing1"] = "斗转星移，万物乾坤",
	["$guanxing2"] = "半似日兮半似月，曾被金龙咬一缺",
	["$kongcheng1"] = "最危险的，就是最安全的",
	["$kongcheng2"] = "大梦谁先觉，平身我自知",
	["~xliubowen"] = "残孽啊/知天命，尽人事",
	
	["xzhuge"] = "诸葛亮",
	["&xzhuge"] = "锦囊诸葛",
	["#xzhuge"] = "洞彻天机",
	["luajizhi"] = "妙计",
	[":luajizhi"] = "被动技，每当你使用一张锦囊牌（包含延时类锦囊牌）时，（在它结算之前）你可以立即摸一张牌",
	["xdongcha"] = "洞彻",
	[":xdongcha"] = "被动技，你不能成为黑色锦囊牌的目标",
	["$jizhi1"] = "志，当存高远",
	["$jizhi2"] = "静，以修身",
	["$jizhi3"] = "亮，有一计",
	["$weimu1"] = "（琴声）",
	["~xzhuge"] = "臣，愧对主公托孤之重.../出师未捷身先死啊/竭股肱之力，效忠贞之节，继之以死乎",
	
	["xxlvzhi"] = "吕雉",
    ["&xxlvzhi"] = "鬼谋吕后",
	["#xxlvzhi"] = "鬼谋毒后",
	["LuaXJianshou"] = "鬼谋",
	[":LuaXJianshou"] = "主动技，你回合结束时，可以选择摸取五张牌。若如此做，你将跳过你下一个回合",
	["zhensha"] = "鸩杀",
	[":zhensha"] = "主动技，当场上有角色进入濒死状态求【药】时，你可以对其(需在攻击范围内)使用【药】，此时该角色立即阵亡。\
	★吕雉使用【鸠杀】，不会改变造成该角色进入濒死状态的伤害来源。",
	["#xumou-mark"] = "蓄谋",
	["@zhensha-peach"] ="你可以对该角色使用一张【药】，若如此做，该角色立即阵亡",
	["LuaXJianshou:yes"] = "摸五张牌，若如此做，并将你的武将翻面",
	["$jushou1"] = "以静制动~",
	["$jushou2"] = "谋定而动~",
	["$zhensha1"] = "汝今势孤命必绝亦矣！",
	["$zhensha2"] = "即可斩首！",
	["$zhensha3"] = "非尽族是，天下不安",
	["~xxlvzhi"] = "天不助我吕氏/ 哀家不甘呐! /苦酒自酿，害人害己",
	
	["zhuchongba"] = "朱元璋",
	["&zhuchongba"] = "朱元璋",
	["#zhuchongba"] = "初代院长",
	["designer:zhuchongba"] = "",
	["~zhuchongba"] = "朕，乃万岁.../来亦何欢去亦何苦",	
	["qiangyun"] = "强运",
    [":qiangyun"] = "<font color=\"blue\"><b>被动技</b></font>，在任意一名角色的回合内，每当你失去或者用掉最后一张手牌时，可以立即从牌堆摸两张牌，然后，在此回合内，当你再次失去或者用掉一张手牌时，可以立即从牌堆摸两张牌。",  
	
		--虞姬
	["xyuji"] = "虞姬",
	["#xyuji"] = "初代虞姬",
	["~xyuji"] = "大王，何以四面楚歌……/汉兵已略地，四方楚歌声，大王意气尽，贱妾何聊生",
	
		--鲁智深
	["xluzhishen"] = "鲁智深",
	["#xluzhishen"] = "老版和尚",
		["fuye"] = "狂禅",
	[":fuye"] = "任意一名其他角色濒死时，你可以失去一点体力，然后令其回复一点体力。",
	["~xluzhishen"] = "贫僧去也/洒家去也",
	
	
["xzhangsanfeng"] = "张三丰",
	["#xzhangsanfeng"] = "无尚太极",
	["bushi"] = "布道",
	[":bushi"] ="主动技，轮到你摸牌时，你可以摸三张，然后将其中一张交给任意一名角色 。",
	["meiying"] = "太极",
    [":meiying"] = "<font color=\"red\"><b>主动技</b></font>, 当你成为【杀】、【决斗】、【探囊取物】或【釜底抽薪】的目标时，你可以进行一次判定，若判定牌与此牌颜色相同，则你成为此牌（或此技能）的使用者，之前此牌（或此技能）使用者成为此牌目标",	
  	["~xzhangsanfeng"] = "驾鹤成仙也~/命已行不可返~",
	
	--宋江
	["xsongjiang"] = "宋江",
	["#xsongjiang"] = "扶危济困",
	["linglong"]="招安",
    [":linglong"]="<font color=\"red\"><b>主动技</b></font>，当你受到伤害后，你可以与伤害来源交换所有手牌。",
    ["#linglong"]="由于%from的【招安】 %arg与之交换了所有手牌",
	["~xsongjiang"] = "算了，招安吧~/悲剧啊~",
	
	--岳飞
	["xyuefei"] = "岳飞",
	["#xyuefei"] = "精忠报国",
		["Chongzhenwz"] = "扫北",
    [":Chongzhenwz"] = "<font color=\"red\"><b>主动技</b></font>，每当你发动【武穆】使用或打出一张手牌时，你可以获得对方的一张手牌",
     ["~xyuefei"] = "儿愧对母亲/报国无门啊~!",
	
--李世民
	["xlishimin"] = "李世民",
	["#xlishimin"] = "开创盛世",
	["shelie"] = "开明",
    [":shelie"] = "<font color=\"red\"><b>主动技</b></font>，摸牌阶段开始时，你可以放弃摸牌并亮出牌堆顶的五张牌：若如此做，你获得其中每种花色的牌各一张，然后将其余的牌置入弃牌堆。",   	
	["~xlishimin"] = "贞观之治结束了么?/高句丽不除，后世必为大患。",
	
	--孙武
	["xsunwu"] = "孙武",
	["#xsunwu"] = "兵家之祖",
	["gongxinxx"] = "真看破",
    [":gongxinxx"] = "<font color=\"red\"><b>主动技</b></font>，出牌阶段限一次，你可以观看一名其他角色的手牌，然后选择其中一张红桃牌并选择一项：弃置之，或将之置于牌堆顶。",   
	["put"] = "置于牌堆顶",	
	["~xsunwu"] = "故三军可夺气，将军可夺心呐/兵贵胜，不贵久呀/英雄气短呐!",
	
	--小乔
	["xxiaoqiao"] = "小乔",
	["#xxiaoqiao"] = "国色天香",
	["luaqicex"] = "玲珑",
	["luaqice"] = "玲珑",
	["luaqicecard"] = "玲珑",	
	["lguose"] = "原国色",
	["snatch+dismantlement+collateral+ex_nihilo+duel+geanguanhuo+toulianghuanzhu+amazing_grace+savage_assault+archery_attack+god_salvation+iron_chain"] = "探囊取物+釜底抽薪+借刀杀人+无中生有+决斗+隔岸观火+偷梁换柱+五谷丰登+烽火狼烟+万箭齐发+休养生息+合纵连横",
	[":luaqice"] = "主动技，出牌阶段，你可以将所有的手牌（至少一张）当做任意一张非延时锦囊牌使用。每阶段限一次。",
	[":lguose"] = "被动技，你不能成为红色【杀】的目标。",
	[":luazhiyux"] = "每当你受到一次伤害后，可以摸一张牌，然后展示所有手牌，若均为同一颜色，则伤害来源弃一张手牌。",
	["@archeryattack"] = "你选择了把所有手牌当【万剑齐发】使用，请选择你的所有手牌",
	["@snatch"] = "你选择了把所有手牌当【探囊取物】使用，请选择你的所有手牌",
	["@dismantlement"] = "你选择了把所有手牌当【釜底抽薪】使用，请选择你的所有手牌",
	["@collateral"] = "你选择了把所有手牌当【借刀杀人】使用，请选择你的所有手牌",
	["@ex_nihilo"] = "你选择了把所有手牌当【无中生有】使用，请选择你的所有手牌",
	["@duel"] = "你选择了把所有手牌当【决斗】使用，请选择你的所有手牌",
	["@geanguanhuo"] = "你选择了把所有手牌当【隔岸观火】使用，请选择你的所有手牌",
	["@toulianghuanzhu"] = "你选择了把所有手牌当【偷梁换柱】使用，请选择你的所有手牌",
	["@amazing_grace"] = "你选择了把所有手牌当【五谷丰登】使用，请选择你的所有手牌",
	["@savage_assault"] = "你选择了把所有手牌当【烽火狼烟】使用，请选择你的所有手牌",
	["@god_salvation"] = "你选择了把所有手牌当【修养生息】使用，请选择你的所有手牌",
	["@iron_chain"] = "你选择了把所有手牌当【合纵连横】使用，请选择你的所有手牌",
	["~xxiaoqiao"] = "乍逝周郎，红颜黯香 /小女子伤痛欲绝呀！",
	
	["baiban"] = "白板",
	["#baiban"] = "模仿者",
    	["xqinxn"] = "学习",
	["xqinxn_cancel"] = "学习--取消",
	["xqinxn_cancel"] = "学习--取消",
	[":xqinxn"] = "<b>主动技</b>，在回合开始阶段，你最多可以选择其他2名存活角色，各获得其一项技能（限定技除外）直至下一个回合开始阶段",
}

