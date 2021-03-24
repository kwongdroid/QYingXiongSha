module("extensions.baojubao", package.seeall)
extension = sgs.Package("baojubao")
sgs.LoadTranslationTable {
	 ["baojubao"] = "宝具包",
}
xxxx = sgs.General(extension, "xxxx", "wei", 4, true,true,true)
xixue = sgs.CreateTriggerSkill{
	name = "xixue",
	events = {sgs.Damage},
	frequency = sgs.Skill_Compulsory,    	
	on_trigger = function(self,event,player,data)
		local room = player:getRoom()
        local s=room:findPlayerBySkillName(self:objectName()) 	
        if event==sgs.Damage then 				        				
		    local damage = data:toDamage()				    
            if not damage.card:inherits("Slash") then return false end	
			if math.random()<=0.79 then
			    local log = sgs.LogMessage()			
	            log.type = "$xixueEffect"						
	            room:sendLog(log)	
				local recover = sgs.RecoverStruct()
			    recover.who = s
			    recover.recover = 1
			    room:recover(s,recover)				      									
			end	   						                          					
        end	
    end				
}
shazhitan = sgs.CreateTriggerSkill{
	    name = "shazhitan",
	    events = {sgs.Damage},
	    frequency = sgs.Skill_Compulsory,        			
	    on_trigger = function(self,event,player,data)
		    local room = player:getRoom()
            local x=room:findPlayerBySkillName(self:objectName())  
            if event==sgs.Damage then 				          					
			    local damage = data:toDamage()
				if not damage.card:inherits("Slash") then return false end	 
			    if math.random()<=0.79 then
					x:drawCards(1)									    
			    end	   						                          					
            end	
        end				
}	
shazhixie = sgs.CreateTriggerSkill{
	name = "shazhixie",
	events = {sgs.Damage},
	frequency = sgs.Skill_Compulsory,       		
	on_trigger = function(self,event,player,data)
	    local room = player:getRoom()
		local x=room:findPlayerBySkillName(self:objectName())
        if event==sgs.Damage then                    
		    local damage = data:toDamage()					
		    local to = damage.to		          
		    if not damage.card:inherits("Slash") then return end			            
            if damage.to:hasEquip() then								                       									                      
			    if math.random()<=0.79 then
				    local card_id = room:askForCardChosen(x, damage.to, "e", "shazhixie")	
				    room:throwCard(sgs.Sanguosha:getCard(card_id))
				end						                      						
			end	   						                          					
        end
    end        			
}	
shangzhitan = sgs.CreateTriggerSkill{
	name = "shangzhitan",
	events = {sgs.Damaged},
	frequency = sgs.Skill_Compulsory,		    	
	on_trigger = function(self,event,player,data)
	    local room = player:getRoom()  
        if event==sgs.Damaged then 				                       					
		    local damage = data:toDamage()            		    
            if not damage.card:inherits("Slash") then return end	
			if math.random()<=0.79 then						    
				player:drawCards(1)						                      						
			end	   						                          					
        end
    end       		
}	
newxiejia = sgs.CreateTriggerSkill{
	name = "newxiejia",
	events = {sgs.Damaged},
	frequency = sgs.Skill_Compulsory,		    	
	on_trigger = function(self,event,player,data)
		local room = player:getRoom()
        if event==sgs.Damaged then                    
		    local damage = data:toDamage()					
		    local source = damage.from
		    local source_data = sgs.QVariant()
		    source_data:setValue(source)
			if not damage.card:inherits("Slash") then return end	
		    if source then
                if source:hasEquip() or (not source:getJudgingArea():isEmpty()) then								                       									                      
					if math.random()<=0.79 then					    		    
					    local card_id = room:askForCardChosen(player, source, "ej", "newxiejia")
                        room:obtainCard(player, card_id)												       
				    end						                      						
				end	   						                          					
            end
        end 
    end				
}	
shangzhixie = sgs.CreateTriggerSkill{
	name = "shangzhixie",
	events = {sgs.Damaged},
	frequency = sgs.Skill_Compulsory,		    	
	on_trigger = function(self,event,player,data)
	    local room = player:getRoom()
        if event==sgs.Damaged then 								                   
		    local damage = data:toDamage()					
		    local source = damage.from
		    local source_data = sgs.QVariant()
		    source_data:setValue(source)
			if not damage.card:inherits("Slash") then return end	
		    if source then
                if source:hasEquip() then								                       									                      
					if math.random()<=0.79 then
						local card_id = room:askForCardChosen(player, source, "e", "shangzhixie")	
						room:throwCard(sgs.Sanguosha:getCard(card_id))
					end						                      						
				end	   						                          					
            end
        end 
    end				
}	
shihua = sgs.CreateTriggerSkill{
	name = "shihua",
	events = {sgs.Damaged},
	frequency = sgs.Skill_Compulsory,		    	
	on_trigger = function(self,event,player,data)
	    local room = player:getRoom()
        if event==sgs.Damaged then 				                          					
		    local damage = data:toDamage()
            local from = damage.from				    
            if  damage.card:inherits("Slash") then 
                if player:getPhase()~=sgs.Player_NotActive then return end					
			    if math.random()<=0.79 then	                   						
				    local log = sgs.LogMessage()			
	                log.type = "$shihuaEffect"						
	                room:sendLog(log)									
                    local current=room:getCurrent()
				    local thread=room:getThread()			
				    current:play(current:getPhases())
                    while true do						
				    	current=current:getNextAlive()
					    current:gainAnExtraTurn(current)
				    end
				end	   						                          					
            end
	    end
	end                 		
}	
hongshadun = sgs.CreateTriggerSkill{
    name = "hongshadun",
	frequency = sgs.Skill_Compulsory,
    events = {sgs.CardEffected},
    on_trigger = function(self,event,player,data)
	    local room = player:getRoom()
		if event==sgs.CardEffected then               
			local effect=data:toCardEffect()
            local card=effect.card
			if card:inherits("Slash") then 
				if card:isRed() then
                    if math.random()<=0.79 then                       	
						local log = sgs.LogMessage()			
	                    log.type = "$hongshadunEffect"						
	                    room:sendLog(log)								
			            return true
                    end
                end
            end
        end					
    end	
}
heishadun = sgs.CreateTriggerSkill{
    name = "heishadun",
    frequency = sgs.Skill_Compulsory,
    events = {sgs.CardEffected},
    on_trigger = function(self,event,player,data)
	    local room = player:getRoom()
	    if event==sgs.CardEffected then               
			local effect=data:toCardEffect()
            local card=effect.card
			if card:inherits("Slash") then 
			    if card:isBlack() then
                    if math.random()<=0.79 then                       
						local log = sgs.LogMessage()			
	                    log.type = "$heishadunEffect"						
	                    room:sendLog(log)							
			            return true
                    end
                end
            end
        end					
    end	
}
tanzhishou = sgs.CreateTriggerSkill{
	name = "tanzhishou",	
	events = {sgs.DrawNCards},
	frequency = sgs.Skill_Compulsory,
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		local x = data:toInt()
		if math.random()<=0.79 then
            room:setEmotion(player,"tanzhishou")	
			local log = sgs.LogMessage()			
	        log.type = "$tanzhishouEffect"						
	        room:sendLog(log)								
			data:setValue(x+1)
		end
	end
}
hongyushou = sgs.CreateTriggerSkill{
    name = "hongyushou",
    frequency = sgs.Skill_Compulsory,
    events = {sgs.CardEffected},
    on_trigger = function(self,event,player,data)
		local room = player:getRoom()
		if event==sgs.CardEffected then               
		    local effect=data:toCardEffect()				
            local card=effect.card
		    if card:inherits("Slash") then 
			    if card:isRed() then
                    if math.random()<=0.79 then												    	
						local log = sgs.LogMessage()			
	                    log.type = "$hongyushouEffect"						
	                    room:sendLog(log)																
                        player:drawCards(1)										                
                    end
                end
            end
        end					
    end	
}
heiyushou = sgs.CreateTriggerSkill{
    name = "heiyushou",
    frequency = sgs.Skill_Compulsory,
    events = {sgs.CardEffected},
    on_trigger = function(self,event,player,data)
		local room = player:getRoom()
		if event==sgs.CardEffected then                
		    local effect=data:toCardEffect()				
            local card=effect.card
		    if card:inherits("Slash") then 
			    if card:isBlack() then
                    if math.random()<=0.79 then																			    	
						local log = sgs.LogMessage()			
	                    log.type = "$heiyushouEffect"						
	                    room:sendLog(log)																
                        player:drawCards(1)										                
                    end
                end
            end
        end					
    end	
}
qingling = sgs.CreateTriggerSkill{
	name = "qingling",
	events = {sgs.CardResponsed},
	frequency = sgs.Skill_Frequent,	
	on_trigger = function(self, event, player, data)
	    local room = player:getRoom()
		local player=room:findPlayerBySkillName(self:objectName())
		if(event == sgs.CardResponsed) then		    		    	
			local card_star = data:toCard()
			if(card_star:inherits("Jink")) then			
			    if math.random()<=0.79 then			   			         			   			   			   
			        player:drawCards(1)
			    end
			end				
	    end
	end
}
xjingzhun=sgs.CreateTriggerSkill{
	name = "xjingzhun",	
 	frequency = sgs.Skill_Compulsory,	
 	events = {sgs.SlashProceed},			
 	on_trigger=function(self,event,player,data)
	  	local room = player:getRoom()
		if event==sgs.SlashProceed then
			if math.random()<=0.79 then               	
				local log = sgs.LogMessage()			
	            log.type = "$jingzhunEffect"						
	            room:sendLog(log)					
     			local effect=data:toSlashEffect()
     			room:slashResult(effect, nil) 
     			return true
			end
		end	
	end
}	
xqianghua=sgs.CreateTriggerSkill{
	name = "xqianghua",	
 	frequency = sgs.Skill_Compulsory,	
 	events = {sgs.Predamage},		
 	on_trigger=function(self,event,player,data)	
        local room = player:getRoom()	
		if event==sgs.Predamage then		    
			local damage = data:toDamage()					
            if not damage.card:inherits("Slash") then return end	
            if math.random()<=0.79 then               
                local log = sgs.LogMessage()			
	            log.type = "$qianghuaEffect"						
	            room:sendLog(log)						
			    damage.damage = damage.damage+1
			    data:setValue(damage)
		    end
		end								
	end	
}
shangzhichou = sgs.CreateTriggerSkill{	
	name = "shangzhichou",	
	frequency = sgs.Skill_Compulsory,		
	events = {sgs.Damaged},	
	on_trigger = function(self, event, player, data)
		local room = player:getRoom()
		if event==sgs.Damaged then  
		    local damage = data:toDamage()		
		    local source = damage.from
		    local source_data = sgs.QVariant()
		    source_data:setValue(source)
			if not damage.card:inherits("Slash") then return end
		    if source then		   			    
                if math.random()<=0.79 then                   
					local log = sgs.LogMessage()			
                    log.type = "$shangzhichouEffect"						
                    room:sendLog(log)					
				    local damage=sgs.DamageStruct()
			        damage.damage=1                       
			        damage.from=player
			        damage.to = source
		            room:damage(damage)			     						 		                                     
                end
            end				
	    end
	end
}
taotie = sgs.CreateTriggerSkill{
	name = "taotie",
	frequency = sgs.Skill_Compulsory,
	events = {sgs.PhaseChange},	
	on_trigger = function(self, event, player, data)
		local room=player:getRoom()	
	    local player = room:findPlayerBySkillName(self:objectName())	
		if event == sgs.PhaseChange then			
			if player:getPhase() == sgs.Player_Discard then
                if math.random()<=0.79 then				    
					local log = sgs.LogMessage()			
	                log.type = "$taotieEffect"						
	                room:sendLog(log)									
		            if player:getHandcardNum()<=20 then			        						     				
					    return true
                    else
                        room:askForDiscard(player,"taotie",player:getHandcardNum()-20,false,false)
                        return true											
			        end
			    end
		    end
		end
	end
}	
newlangyan = sgs.CreateTriggerSkill{
    name = "newlangyan",
    frequency = sgs.Skill_Compulsory, 
    events = {sgs.Predamage}, 	 
	on_trigger = function(self,event,player,data) 
        local room = player:getRoom()		 
	    local damage = data:toDamage()		  	      	  		  		  		  		  
		local card = damage.card		             
		if damage.card:inherits("SavageAssault") then 		  
		    if math.random()<=0.79 then			    					
				local log = sgs.LogMessage()			
	            log.type = "$langyanEffect"						
	            room:sendLog(log)			                 				 
			    damage.damage = damage.damage+1
			    data:setValue(damage)	
			end	
        end		  
	 end
}	
newyixin = sgs.CreateTriggerSkill{
    name="newyixin",   
    frequency = sgs.Skill_Compulsory,		  
    events={sgs.CardEffected},  
    can_trigger=function() 
        return true
    end,			  
    on_trigger=function(self,event,player,data)
	    local room=player:getRoom()	           
	    local bq=room:findPlayerBySkillName(self:objectName())	           	
	    if event==sgs.CardEffected then
	        local effect=data:toCardEffect()	            
	        if not effect.card:inherits("Peach") then return end               
				if effect.from:objectName()==bq:objectName() then
                    if math.random()<=0.79 then
					    room:setEmotion(bq,"yixin")						
						local log = sgs.LogMessage()			
	                    log.type = "$yixinEffect"						
	                    room:sendLog(log)									
					    local recover = sgs.RecoverStruct()
			            recover.who = player
			            recover.recover = 1
			            room:recover(player,recover)
                    end               
                end
        end			
	end						                  	         		          		        
}
shangzhixue = sgs.CreateTriggerSkill{
	name = "shangzhixue",
	events = {sgs.Damaged},
	frequency = sgs.Skill_Compulsory,		    	
	on_trigger = function(self,event,player,data)
	    local room = player:getRoom()
        if event==sgs.Damaged then                     
		    local damage = data:toDamage()					
		    local source = damage.from
		    local source_data = sgs.QVariant()
		    source_data:setValue(source)
			if not damage.card:inherits("Slash") then return end	
		    if source then
                if not source:isKongcheng() then								                       									                      
					if math.random()<=0.79 then
						local card_id = room:askForCardChosen(player, source, "h", "shangzhixue")	
						room:throwCard(sgs.Sanguosha:getCard(card_id))
				    end						                      						
			    end	   						                          					
            end
        end 
    end				
}	
xxxx:addSkill(newyixin)
xxxx:addSkill(newlangyan)
xxxx:addSkill(taotie)
xxxx:addSkill(xixue)
xxxx:addSkill(shazhitan)
xxxx:addSkill(newxiejia)
xxxx:addSkill(shazhixie)
xxxx:addSkill(shangzhitan)
xxxx:addSkill(shangzhixue)
xxxx:addSkill(shangzhixie)
xxxx:addSkill(shihua)
xxxx:addSkill(hongshadun)
xxxx:addSkill(heishadun)
xxxx:addSkill(tanzhishou)
xxxx:addSkill(hongyushou)
xxxx:addSkill(heiyushou)
xxxx:addSkill(qingling)
xxxx:addSkill(xjingzhun)
xxxx:addSkill(xqianghua)
xxxx:addSkill(shangzhichou)

ZZZZ = sgs.General(extension, "ZZZZ", "qun", 4,true,true,true)
luabaojus=sgs.CreateTriggerSkill{
	name="luabaojus",
	events={sgs.GameStart},
	frequency = sgs.Skill_NotFrequent,
	priority=4,
	on_trigger=function(self,event,player,data)
		local room=player:getRoom()
		if event==sgs.GameStart then
			local mhp = sgs.QVariant()
			local x = player:getMaxHP()+4
			mhp:setValue(x)
			local data=sgs.QVariant(x)
			room:setPlayerProperty(player,"maxhp",mhp)
			room:setPlayerProperty(player, "hp", data)
		end
	end
}
ZZZZ:addSkill(luabaojus)

sgs.LoadTranslationTable{	
	["luabaojus"]="宝具",
    [":luabaojus"]="<font color=\"blue\"><b>被动技</b></font>，游戏开始时，体力上限+4。",
	["xixue"]="吸血",     
    [":xixue"]="<font color=\"blue\"><b>被动技</b></font>，你的【杀】对目标造成伤害时，有79%几率使自己回复1点血量",			
	["shazhitan"]="杀之贪",     
    [":shazhitan"]="<font color=\"blue\"><b>被动技</b></font>，你的【杀】对目标造成伤害时，有79%几率使自己摸1张牌",	
	["shazhixue"] = "杀之削",
    [":shazhixue"] = "<font color=\"blue\"><b>被动技</b></font>，你的【杀】对目标造成伤害时，有79%几率弃置目标1张手牌",	
    ["shazhixie"] = "杀之卸",
    [":shazhixie"] = "<font color=\"blue\"><b>被动技</b></font>，你的【杀】对目标造成伤害时，有79%几率弃置目标装备区的1张牌",					
	["shangzhitan"]="伤之贪",     
    [":shangzhitan"]="<font color=\"blue\"><b>被动技</b></font>，当你受到【杀】的伤害时，有79%几率使自己摸1张牌",	
	["shangzhixue"]="伤之削",     
    [":shangzhixue"]="<font color=\"blue\"><b>被动技</b></font>，当你受到【杀】的伤害时，有79%几率弃置伤害来源1张手牌",	
	["shangzhixie"]="伤之卸",     
    [":shangzhixie"]="<font color=\"blue\"><b>被动技</b></font>，当你受到【杀】的伤害时，有79%几率弃置伤害来源装备区的1张牌",	
	["shihua"]="石化",     
    [":shihua"]="<font color=\"blue\"><b>被动技</b></font>，当你受到【杀】的伤害时，有79%几率使伤害你的角色直接进入弃牌阶段",	
	["hongshadun"] = "红杀盾",
    [":hongshadun"] = "<font color=\"blue\"><b>被动技</b></font>，当你成为红色【杀】的目标时，该【杀】有79%几率对你无效",	
    ["heishadun"] = "黑杀盾",
    [":heishadun"] = "<font color=\"blue\"><b>被动技</b></font>，当你成为黑色【杀】的目标时，该【杀】有79%几率对你无效",	
    ["tanzhishou"] = "贪之手",
    [":tanzhishou"] = "<font color=\"blue\"><b>被动技</b></font>，摸牌阶段，有79%几率额外摸1张牌",							
    ["hongyushou"] = "红御守",
    [":hongyushou"] = "<font color=\"blue\"><b>被动技</b></font>，当你成为红色【杀】的目标时，有79%几率摸1张牌",	
    ["heiyushou"] = "黑御守",
    [":heiyushou"] = "<font color=\"blue\"><b>被动技</b></font>，当你成为黑色【杀】的目标时，有79%几率摸1张牌",	  				
    ["qingling"] = "轻灵", 
    [":qingling"] = "<font color=\"blue\"><b>被动技</b></font>，你每打出一张【闪】时，有79%几率摸1张牌",			
    ["xjingzhun"] = "精准", 
    [":xjingzhun"] = "<font color=\"blue\"><b>被动技</b></font>，你对目标出【杀】时，有79%几率此【杀】不可回避，直接命中",							
    ["xqianghua"] = "强化", 
    [":xqianghua"] = "<font color=\"blue\"><b>被动技</b></font>，你的【杀】对目标造成伤害时，有79%几率伤害+1",														 
	["$xixueEffect"] = "【吸血】技能效果触发，回复1点血量。",
	["shangzhichou"] = "伤之仇", 
    [":shangzhichou"] = "<font color=\"blue\"><b>被动技</b></font>，被【杀】掉血后，有79%几率对杀你的角色造成1点伤害。",
    ["$shangzhichouEffect"] = "【伤之仇】技能效果触发，对杀你的角色造成1点伤害。",	
	["$shihuaEffect"] = "【石化】技能效果触发，该角色直接进入弃牌阶段。",	
	["$hongshadunEffect"] = "【红杀盾】技能效果触发，该【杀】无效。",
	["$heishadunEffect"] = "【黑杀盾】技能效果触发，该【杀】无效。",
	["$tanzhishouEffect"] = "【贪之手】技能效果触发，额外摸1张牌。",	
	["$hongyushouEffect"] = "【红御守】技能效果触发，摸1张牌。",
	["$heiyushouEffect"] = "【黑御守】技能效果触发，摸1张牌。",	
	["$jingzhunEffect"] = "【精准】技能效果触发，此【杀】不可回避，直接命中。",	
	["$qianghuaEffect"] = "【强化】技能效果触发，此【杀】伤害+1。",	
	["newlangyan"]="狼烟",     
    [":newlangyan"]="<font color=\"blue\"><b>被动技</b></font>，打出【烽火狼烟】时，有79%几率威力+1。",
	["$langyanEffect"] = "【狼烟】技能效果触发，威力+1。",		
	["taotie"]="饕餮",     
    [":taotie"]="<font color=\"blue\"><b>被动技</b></font>，弃牌阶段开始时进行判定，有79%几率使你本回合的手牌上限变为20张。",
	["$taotieEffect"] = "【饕餮】技能效果触发，本回合的手牌上限变为20张。",		
	["newyixin"]="医心",     
    [":newyixin"]="<font color=\"blue\"><b>被动技</b></font>，装备【医心】的角色对自己或其他角色打出【药】回血时，有79%几率额外恢复1点血。",		
	["$yixinEffect"] = "【医心】技能效果触发，该角色额外回复1点血量。",		
    ["newxiejia"] = "卸甲", 
    [":newxiejia"] = "<font color=\"blue\"><b>被动技</b></font>，被【杀】掉血后，有79%几率能获得杀你的角色装备区或判定区的牌（目标装备区或判定区没有牌时，不生效）。"	
}

local generalnames=sgs.Sanguosha:getLimitedGeneralNames()
for _, generalname in ipairs(generalnames) do
	local general = sgs.Sanguosha:getGeneral(generalname)
	if general then
		general:addSkill("luabaojus")			
	end
end