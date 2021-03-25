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

-- 1
local caocao = sgs.Sanguosha:getGeneral("caocao")
if caocao then
	caocao:addSkill("newlangyan")
	caocao:addSkill("fenghuo")
	caocao:addSkill("tanzhishou")
	caocao:addSkill("yingzi")
end

-- 2
local yingzheng = sgs.Sanguosha:getGeneral("yingzheng")
if yingzheng then
	yingzheng:addSkill("xixue")
	yingzheng:addSkill("fanji")
	yingzheng:addSkill("xqianghua")
	yingzheng:addSkill("wusheng")
end

-- 3
local liubang = sgs.Sanguosha:getGeneral("liubang")
if liubang then
	liubang:addSkill("newlangyan")
	liubang:addSkill("fenghuo")
	liubang:addSkill("tanzhishou")
	liubang:addSkill("jianxiongyxs")
end

-- 4
local chensheng = sgs.Sanguosha:getGeneral("chensheng")
if chensheng then
	chensheng:addSkill("hongshadun")
	chensheng:addSkill("diehun")
	chensheng:addSkill("heishadun")
	chensheng:addSkill("lijian")
end

-- 5
local yuji = sgs.Sanguosha:getGeneral("yuji")
if yuji then
	yuji:addSkill("xixue")
	yuji:addSkill("fanji")
	yuji:addSkill("xqianghua")
	yuji:addSkill("wusheng")
end

-- 6
local likui = sgs.Sanguosha:getGeneral("likui")
if likui then
	likui:addSkill("xixue")
	likui:addSkill("fanji")
	likui:addSkill("shangzhichou")
	likui:addSkill("jianxiong")
end

-- 7
local shangyang = sgs.Sanguosha:getGeneral("shangyang")
if shangyang then
	shangyang:addSkill("tanzhishou")
	shangyang:addSkill("zhiheng")
	shangyang:addSkill("shazhitan")
	shangyang:addSkill("kongju")
end

-- 8
local wusong = sgs.Sanguosha:getGeneral("wusong")
if wusong then
	wusong:addSkill("xqianghua")
	wusong:addSkill("toujivs")
	wusong:addSkill("xjingzhun")
	wusong:addSkill("tianyi")
end

-- 9
local zhaofeiyan = sgs.Sanguosha:getGeneral("zhaofeiyan")
if zhaofeiyan then
	zhaofeiyan:addSkill("newlangyan")
	zhaofeiyan:addSkill("fenghuo")
	zhaofeiyan:addSkill("qingling")
	zhaofeiyan:addSkill("tuqiang")
end

-- 10
local songjiang = sgs.Sanguosha:getGeneral("songjiang")
if songjiang then
	songjiang:addSkill("hongshadun")
	songjiang:addSkill("jieyin")
	songjiang:addSkill("heishadun")
	songjiang:addSkill("qiangxi")
end

-- 11
local tantaiming = sgs.Sanguosha:getGeneral("tantaiming")
if tantaiming then
	tantaiming:addSkill("shazhitan")
	tantaiming:addSkill("tianyi")
	tantaiming:addSkill("xqianghua")
	tantaiming:addSkill("liegong")
end

-- 12
local yangyanzhao = sgs.Sanguosha:getGeneral("yangyanzhao")
if yangyanzhao then
	yangyanzhao:addSkill("shazhitan")
	yangyanzhao:addSkill("wusheng")
	yangyanzhao:addSkill("xjingzhun")
	yangyanzhao:addSkill("tianyi")
end

-- 13
local yuefei = sgs.Sanguosha:getGeneral("yuefei")
if yuefei then
	yuefei:addSkill("xjingzhun")
	yuefei:addSkill("tianyi")
	yuefei:addSkill("shazhitan")
	yuefei:addSkill("toujivs")
end

-- 14
local liubowen = sgs.Sanguosha:getGeneral("liubowen")
if liubowen then
	liubowen:addSkill("hongshadun")
	liubowen:addSkill("jieyin")
	liubowen:addSkill("heishadun")
	liubowen:addSkill("lijian")
end

-- 15
local lishimin = sgs.Sanguosha:getGeneral("lishimin")
if lishimin then
	lishimin:addSkill("shangzhitan")
	lishimin:addSkill("jianxiong")
	lishimin:addSkill("shazhitan")
	lishimin:addSkill("zhiheng")
end

-- 16
local hanxin = sgs.Sanguosha:getGeneral("hanxin")
if hanxin then
	hanxin:addSkill("newlangyan")
	hanxin:addSkill("fenghuo")
	hanxin:addSkill("tanzhishou")
	hanxin:addSkill("jianxiongyxs")
end

-- 17
local goujian = sgs.Sanguosha:getGeneral("goujian")
if goujian then
	goujian:addSkill("qingling")
	goujian:addSkill("bazhen")
	goujian:addSkill("shazhitan")
	goujian:addSkill("zhiheng")
end

-- 18
local shiqian = sgs.Sanguosha:getGeneral("shiqian")
if shiqian then
	-- shiqian:addSkill("探囊")
	shiqian:addSkill("zhiheng")
	shiqian:addSkill("shazhitan")
	shiqian:addSkill("tianyi")
end

-- 19
local zhaokuangyin = sgs.Sanguosha:getGeneral("zhaokuangyin")
if zhaokuangyin then
	zhaokuangyin:addSkill("tanzhishou")
	zhaokuangyin:addSkill("yingzi")
	zhaokuangyin:addSkill("xqianghua")
	zhaokuangyin:addSkill("sanbanfu")
end

-- 20
local xishi = sgs.Sanguosha:getGeneral("xishi")
if xishi then
	xishi:addSkill("tanzhishou")
	xishi:addSkill("kongju")
	xishi:addSkill("xjingzhun")
	xishi:addSkill("zhiheng")
end

-- 21
local baosi = sgs.Sanguosha:getGeneral("baosi")
if baosi then
	baosi:addSkill("newlangyan")
	baosi:addSkill("jianxiongyxs")
	baosi:addSkill("tanzhishou")
	baosi:addSkill("yingzi")
end

-- 22
local xiangyu = sgs.Sanguosha:getGeneral("xiangyu")
if xiangyu then
	xiangyu:addSkill("xqianghua")
	xiangyu:addSkill("tianyi")
	xiangyu:addSkill("shazhitan")
	xiangyu:addSkill("toujivs")
end

-- 23
local tiemuzhen = sgs.Sanguosha:getGeneral("tiemuzhen")
if tiemuzhen then
	tiemuzhen:addSkill("shazhitan")
	tiemuzhen:addSkill("tianyi")
	tiemuzhen:addSkill("xqianghua")
	tiemuzhen:addSkill("tieji")
end

-- 24
local bianque = sgs.Sanguosha:getGeneral("bianque")
if bianque then
	bianque:addSkill("newyixin")
	bianque:addSkill("kongju")
	bianque:addSkill("shangzhitan")
	bianque:addSkill("jianxiong")
end

-- 25
local chenyuanyuan = sgs.Sanguosha:getGeneral("chenyuanyuan")
if chenyuanyuan then
	chenyuanyuan:addSkill("hongshadun")
	chenyuanyuan:addSkill("tuxi")
	chenyuanyuan:addSkill("heishadun")
	chenyuanyuan:addSkill("jieyin")
end

-- 26
local guanyu = sgs.Sanguosha:getGeneral("guanyu")
if guanyu then
	guanyu:addSkill("shazhitan")
	guanyu:addSkill("wusheng")
	guanyu:addSkill("xqianghua")
	guanyu:addSkill("wushuang")
end

-- 27
local wuzetian = sgs.Sanguosha:getGeneral("wuzetian")
if wuzetian then
	wuzetian:addSkill("tanzhishou")
	wuzetian:addSkill("yingzi")
	wuzetian:addSkill("shangzhitan")
	wuzetian:addSkill("jianxiong")
end

-- 28
local renhengzhi = sgs.Sanguosha:getGeneral("renhengzhi")
if renhengzhi then
	renhengzhi:addSkill("xqianghua")
	renhengzhi:addSkill("liegong")
	renhengzhi:addSkill("shazhitan")
	renhengzhi:addSkill("toujivs")
end

-- 29
local qinqiong = sgs.Sanguosha:getGeneral("qinqiong")
if qinqiong then
	qinqiong:addSkill("xixue")
	qinqiong:addSkill("yiji")
	qinqiong:addSkill("xqianghua")
	qinqiong:addSkill("wusheng")
end

-- 30
local huamulan = sgs.Sanguosha:getGeneral("huamulan")
if huamulan then
	huamulan:addSkill("newlangyan")
	huamulan:addSkill("fenghuo")
	huamulan:addSkill("tanzhishou")
	huamulan:addSkill("zhiheng")
end

-- 31
local murong = sgs.Sanguosha:getGeneral("murong")
if murong then
	murong:addSkill("hongshadun")
	murong:addSkill("tuxi")
	murong:addSkill("heishadun")
	murong:addSkill("jieyin")
end

-- 32
local lishishi = sgs.Sanguosha:getGeneral("lishishi")
if lishishi then
	lishishi:addSkill("shangzhitan")
	lishishi:addSkill("jianxiong")
	lishishi:addSkill("tanzhishou")
	lishishi:addSkill("kongju")
end

-- 33
local luzhishen = sgs.Sanguosha:getGeneral("luzhishen")
if luzhishen then
	luzhishen:addSkill("shazhitan")
	luzhishen:addSkill("tianyi")
	luzhishen:addSkill("xjingzhun")
	luzhishen:addSkill("huoshen")
end

-- 34
local jingke = sgs.Sanguosha:getGeneral("jingke")
if jingke then
	jingke:addSkill("xixue")
	jingke:addSkill("fanji")
	jingke:addSkill("xqianghua")
	jingke:addSkill("jianxiong")
end

-- 35
local zhugeliang = sgs.Sanguosha:getGeneral("zhugeliang")
if zhugeliang then
	zhugeliang:addSkill("shangzhitan")
	zhugeliang:addSkill("fankui")
	zhugeliang:addSkill("shazhitan")
	zhugeliang:addSkill("tianyi")
end

-- 36
local lianpo = sgs.Sanguosha:getGeneral("lianpo")
if lianpo then
	lianpo:addSkill("xjingzhun")
	lianpo:addSkill("paoxiao")
	lianpo:addSkill("shazhitan")
	lianpo:addSkill("tianyi")
end

-- 37
local lvzhi = sgs.Sanguosha:getGeneral("lvzhi")
if lvzhi then
	lvzhi:addSkill("tanzhishou")
	-- lvzhi:addSkill("穿杨")
	lvzhi:addSkill("shangzhitan")
	lvzhi:addSkill("yingzi")
end

-- 38
local chengyaojin = sgs.Sanguosha:getGeneral("chengyaojin")
if chengyaojin then
	chengyaojin:addSkill("xqianghua")
	chengyaojin:addSkill("tianyi")
	chengyaojin:addSkill("shazhitan")
	chengyaojin:addSkill("toujivs")
end

-- 39
local xiaoqiao = sgs.Sanguosha:getGeneral("xiaoqiao")
if xiaoqiao then
	xiaoqiao:addSkill("qingling")
	xiaoqiao:addSkill("tuqiang")
	xiaoqiao:addSkill("tanzhishou")
	xiaoqiao:addSkill("kongju")
end

-- 40
local panan = sgs.Sanguosha:getGeneral("panan")
if panan then
	panan:addSkill("newlangyan")
	panan:addSkill("fenghuo")
	panan:addSkill("tanzhishou")
	panan:addSkill("zhiheng")
end

-- 41
local zhuyuanzhang = sgs.Sanguosha:getGeneral("zhuyuanzhang")
if zhuyuanzhang then
	zhuyuanzhang:addSkill("xjingzhun")
	zhuyuanzhang:addSkill("wusheng")
	zhuyuanzhang:addSkill("xqianghua")
	zhuyuanzhang:addSkill("tianyi")
end

-- 42
local lizicheng = sgs.Sanguosha:getGeneral("lizicheng")
if lizicheng then
	lizicheng:addSkill("hongshadun")
	lizicheng:addSkill("tuxi")
	lizicheng:addSkill("heishadun")
	lizicheng:addSkill("lijian")
end

-- 43
local luban = sgs.Sanguosha:getGeneral("luban")
if luban then
	luban:addSkill("shazhitan")
	luban:addSkill("tianyi")
	luban:addSkill("xjingzhun")
	luban:addSkill("wusheng")
end

-- 44
local zhangfei = sgs.Sanguosha:getGeneral("zhangfei")
if zhangfei then
	zhangfei:addSkill("shangzhitan")
	zhangfei:addSkill("jianxiong")
	zhangfei:addSkill("shangzhichou")
	zhangfei:addSkill("ganglie")
end

-- 45
local linchong = sgs.Sanguosha:getGeneral("linchong")
if linchong then
	linchong:addSkill("xqianghua")
	linchong:addSkill("tianyi")
	linchong:addSkill("shazhitan")
	linchong:addSkill("toujivs")
end

-- 46
local liyu = sgs.Sanguosha:getGeneral("liyu")
if liyu then
	liyu:addSkill("qingling")
	liyu:addSkill("bazhen")
	liyu:addSkill("tanzhishou")
	liyu:addSkill("tuqiang")
end

-- 47
local diaochan = sgs.Sanguosha:getGeneral("diaochan")
if diaochan then
	diaochan:addSkill("xixue")
	diaochan:addSkill("fanji")
	diaochan:addSkill("xqianghua")
	diaochan:addSkill("wusheng")
end

-- 48
local yangyuhuan = sgs.Sanguosha:getGeneral("yangyuhuan")
if yangyuhuan then
	yangyuhuan:addSkill("shangzhixie")
	yangyuhuan:addSkill("huoshen")
	yangyuhuan:addSkill("xjingzhun")
	yangyuhuan:addSkill("wusheng")
end

-- 49
local libai = sgs.Sanguosha:getGeneral("libai")
if libai then
	libai:addSkill("tanzhishou")
	libai:addSkill("yingzi")
	libai:addSkill("shangzhichou")
	libai:addSkill("ganglie")
end

-- 50
local sunwu = sgs.Sanguosha:getGeneral("sunwu")
if sunwu then
	sunwu:addSkill("shangzhitan")
	sunwu:addSkill("yiji")
	sunwu:addSkill("tanzhishou")
	sunwu:addSkill("kongju")
end

-- 51
local mozi = sgs.Sanguosha:getGeneral("mozi")
if mozi then
	mozi:addSkill("hongshadun")
	mozi:addSkill("diehun")
	mozi:addSkill("heishadun")
	mozi:addSkill("tuxi")
end

-- 52
local kangxi = sgs.Sanguosha:getGeneral("kangxi")
if kangxi then
	kangxi:addSkill("tanzhishou")
	kangxi:addSkill("yingzi")
	kangxi:addSkill("shangzhitan")
	kangxi:addSkill("jianxiong")
end

-- 53
local liuche = sgs.Sanguosha:getGeneral("liuche")
if liuche then
	liuche:addSkill("tanzhishou")
	liuche:addSkill("lijian")
	liuche:addSkill("shangzhichou")
	liuche:addSkill("ganglie")
end

-- 54
local tangbohu = sgs.Sanguosha:getGeneral("tangbohu")
if tangbohu then
	tangbohu:addSkill("shangzhitan")
	tangbohu:addSkill("jianxiong")
	tangbohu:addSkill("newlangyan")
	tangbohu:addSkill("fenghuo")
end

-- 55
local sp_wangzhaojun = sgs.Sanguosha:getGeneral("sp_wangzhaojun")
if sp_wangzhaojun then
	sp_wangzhaojun:addSkill("shangzhichou")
	sp_wangzhaojun:addSkill("ganglie")
	sp_wangzhaojun:addSkill("shangzhixue")
	sp_wangzhaojun:addSkill("jieyin")
end

-- 56
local chen_muguiying = sgs.Sanguosha:getGeneral("chen_muguiying")
if chen_muguiying then
	chen_muguiying:addSkill("xqianghua")
	chen_muguiying:addSkill("tianyi")
	chen_muguiying:addSkill("shazhitan")
	chen_muguiying:addSkill("toujivs")
end

-- 57
local min_muguiying = sgs.Sanguosha:getGeneral("min_muguiying")
if min_muguiying then
	min_muguiying:addSkill("tanzhishou")
	min_muguiying:addSkill("yingzi")
	min_muguiying:addSkill("shangzhichou")
	min_muguiying:addSkill("ganglie")
end

-- 58
local baiqi = sgs.Sanguosha:getGeneral("baiqi")
if baiqi then
	baiqi:addSkill("xjingzhun")
	baiqi:addSkill("tianyi")
	baiqi:addSkill("shazhitan")
	baiqi:addSkill("toujivs")
end

-- 59
local sp_luocheng = sgs.Sanguosha:getGeneral("sp_luocheng")
if sp_luocheng then
	sp_luocheng:addSkill("shazhitan")
	sp_luocheng:addSkill("paoxiao")
	sp_luocheng:addSkill("xqianghua")
	sp_luocheng:addSkill("wusheng")
end

-- 60
local zhaowu = sgs.Sanguosha:getGeneral("zhaowu")
if zhaowu then
	zhaowu:addSkill("xqianghua")
	zhaowu:addSkill("tianyi")
	zhaowu:addSkill("shazhitan")
	zhaowu:addSkill("danji")
end

-- 61
local bole = sgs.Sanguosha:getGeneral("bole")
if bole then
	bole:addSkill("hongshadun")
	bole:addSkill("tuxi")
	bole:addSkill("heishadun")
	bole:addSkill("lijian")
end

-- 62
local yangguang = sgs.Sanguosha:getGeneral("yangguang")
if yangguang then
	yangguang:addSkill("shangzhitan")
	yangguang:addSkill("zhiheng")
	yangguang:addSkill("newlangyan")
	yangguang:addSkill("fenghuo")
end

-- 63
local guiguzi = sgs.Sanguosha:getGeneral("guiguzi")
if guiguzi then
	guiguzi:addSkill("tanzhishou")
	guiguzi:addSkill("yingzi")
	guiguzi:addSkill("shangzhitan")
	guiguzi:addSkill("ganglie")
end

-- 64
local sunquan = sgs.Sanguosha:getGeneral("sunquan")
if sunquan then
	sunquan:addSkill("tanzhishou")
	sunquan:addSkill("yingzi")
	sunquan:addSkill("shangzhitan")
	sunquan:addSkill("jianxiong")
end

-- 65
local jifa = sgs.Sanguosha:getGeneral("jifa")
if jifa then
	jifa:addSkill("tanzhishou")
	jifa:addSkill("yingzi")
	jifa:addSkill("shangzhitan")
	jifa:addSkill("jianxiong")
end

-- 66
local liqingzhao = sgs.Sanguosha:getGeneral("liqingzhao")
if liqingzhao then
	liqingzhao:addSkill("tanzhishou")
	liqingzhao:addSkill("zhiheng")
	liqingzhao:addSkill("shangzhitan")
	liqingzhao:addSkill("jianxiongyxs")
end

-- 67
local xuanzang = sgs.Sanguosha:getGeneral("xuanzang")
if xuanzang then
	xuanzang:addSkill("xixue")
	xuanzang:addSkill("fanji")
	xuanzang:addSkill("xqianghua")
	xuanzang:addSkill("wusheng")
end

-- 68
local wenjiang = sgs.Sanguosha:getGeneral("wenjiang")
if wenjiang then
	wenjiang:addSkill("tanzhishou")
	wenjiang:addSkill("zhiheng")
	wenjiang:addSkill("shangzhitan")
	wenjiang:addSkill("jizhi")
end

-- 69
local baozheng = sgs.Sanguosha:getGeneral("baozheng")
if baozheng then
	baozheng:addSkill("xixue")
	baozheng:addSkill("fanji")
	baozheng:addSkill("xqianghua")
	baozheng:addSkill("wusheng")
end

-- 70
local dongfangshuo = sgs.Sanguosha:getGeneral("dongfangshuo")
if dongfangshuo then
	dongfangshuo:addSkill("tanzhishou")
	dongfangshuo:addSkill("zhiheng")
	dongfangshuo:addSkill("newlangyan")
	dongfangshuo:addSkill("fenghuo")
end

-- 71
local liguang = sgs.Sanguosha:getGeneral("liguang")
if liguang then
	liguang:addSkill("xqianghua")
	liguang:addSkill("toujivs")
	liguang:addSkill("tanzhishou")
	liguang:addSkill("luoyi")
end

-- 72
local qihuangong = sgs.Sanguosha:getGeneral("qihuangong")
if qihuangong then
	qihuangong:addSkill("tanzhishou")
	qihuangong:addSkill("bazhen")
	qihuangong:addSkill("qingling")
	qihuangong:addSkill("tuqiang")
end

-- 73
local kongzi = sgs.Sanguosha:getGeneral("kongzi")
if kongzi then
	kongzi:addSkill("hongshadun")
	kongzi:addSkill("diehun")
	kongzi:addSkill("heishadun")
	kongzi:addSkill("lijian")
end

-- 74
local liubei = sgs.Sanguosha:getGeneral("liubei")
if liubei then
	liubei:addSkill("tanzhishou")
	liubei:addSkill("zhiheng")
	liubei:addSkill("shangzhitan")
	liubei:addSkill("jianxiongyxs")
end

-- 93
local direnjie = sgs.Sanguosha:getGeneral("direnjie")
if direnjie then
	direnjie:addSkill("tanzhishou")
	direnjie:addSkill("yingzi")
	direnjie:addSkill("shangzhitan")
	direnjie:addSkill("jianxiong")
end

-- 94
local zhangsanfeng = sgs.Sanguosha:getGeneral("zhangsanfeng")
if zhangsanfeng then
	zhangsanfeng:addSkill("qingling")
	zhangsanfeng:addSkill("bazhen")
	zhangsanfeng:addSkill("xqianghua")
	zhangsanfeng:addSkill("wusheng")
end

-- 95
local sp_zhaoyun = sgs.Sanguosha:getGeneral("sp_zhaoyun")
if sp_zhaoyun then
	sp_zhaoyun:addSkill("xqianghua")
	sp_zhaoyun:addSkill("sanbanfu")
	sp_zhaoyun:addSkill("shazhitan")
	sp_zhaoyun:addSkill("toujivs")
end

-- 96
local sp_lvbu = sgs.Sanguosha:getGeneral("sp_lvbu")
if sp_lvbu then
	sp_lvbu:addSkill("shazhitan")
	sp_lvbu:addSkill("tianyi")
	sp_lvbu:addSkill("xjingzhun")
	sp_lvbu:addSkill("toujivs")
end

-- 97
local yuwenhuaji = sgs.Sanguosha:getGeneral("yuwenhuaji")
if yuwenhuaji then
	yuwenhuaji:addSkill("newlangyan")
	yuwenhuaji:addSkill("fenghuo")
	yuwenhuaji:addSkill("shangzhitan")
	yuwenhuaji:addSkill("jianxiong")
end

-- 98
local sudaji = sgs.Sanguosha:getGeneral("sudaji")
if sudaji then
	sudaji:addSkill("shangzhitan")
	sudaji:addSkill("diehun")
	sudaji:addSkill("tanzhishou")
	sudaji:addSkill("kongju")
end

-- 99
local xiaotaihou = sgs.Sanguosha:getGeneral("xiaotaihou")
if xiaotaihou then
	xiaotaihou:addSkill("xjingzhun")
	xiaotaihou:addSkill("tianyi")
	xiaotaihou:addSkill("xqianghua")
	xiaotaihou:addSkill("wusheng")
end

-- 100
local shangzhou = sgs.Sanguosha:getGeneral("shangzhou")
if shangzhou then
	-- shangzhou:addSkill("万箭")
	shangzhou:addSkill("zhiheng")
	shangzhou:addSkill("tanzhishou")
	shangzhou:addSkill("yingzi")
end

-- 101
local aobai = sgs.Sanguosha:getGeneral("aobai")
if aobai then
	aobai:addSkill("xqianghua")
	aobai:addSkill("tianyi")
	aobai:addSkill("shazhitan")
	aobai:addSkill("tieji")
end

-- 102
local kaisa = sgs.Sanguosha:getGeneral("kaisa")
if kaisa then
	-- kaisa:addSkill("shazhitan")
	-- kaisa:addSkill("tianyi")
	-- kaisa:addSkill("xqianghua")
	-- kaisa:addSkill("wusheng")
end

-- 103
local napolun = sgs.Sanguosha:getGeneral("napolun")
if napolun then
	-- napolun:addSkill("shazhitan")
	-- napolun:addSkill("tianyi")
	-- napolun:addSkill("xqianghua")
	-- napolun:addSkill("wusheng")
end

-- 104
local aijiyanhou = sgs.Sanguosha:getGeneral("aijiyanhou")
if aijiyanhou then
	-- aijiyanhou:addSkill("shazhitan")
	-- aijiyanhou:addSkill("tianyi")
	-- aijiyanhou:addSkill("xqianghua")
	-- aijiyanhou:addSkill("wusheng")
end

-- 105
local zhende = sgs.Sanguosha:getGeneral("zhende")
if zhende then
	-- zhende:addSkill("shazhitan")
	-- zhende:addSkill("tianyi")
	-- zhende:addSkill("xqianghua")
	-- zhende:addSkill("wusheng")
end

-- 106
local zhitianxinzhang = sgs.Sanguosha:getGeneral("zhitianxinzhang")
if zhitianxinzhang then
	-- zhitianxinzhang:addSkill("shazhitan")
	-- zhitianxinzhang:addSkill("tianyi")
	-- zhitianxinzhang:addSkill("xqianghua")
	-- zhitianxinzhang:addSkill("wusheng")
end

-- 107
local mchh = sgs.Sanguosha:getGeneral("mchh")
if mchh then
	-- mchh:addSkill("shazhitan")
	-- mchh:addSkill("tianyi")
	-- mchh:addSkill("xqianghua")
	-- mchh:addSkill("wusheng")
end

-- 108
local ndge = sgs.Sanguosha:getGeneral("ndge")
if ndge then
	-- ndge:addSkill("shazhitan")
	-- ndge:addSkill("tianyi")
	-- ndge:addSkill("xqianghua")
	-- ndge:addSkill("wusheng")
end

-- 109
local sibada = sgs.Sanguosha:getGeneral("sibada")
if sibada then
	-- sibada:addSkill("shazhitan")
	-- sibada:addSkill("tianyi")
	-- sibada:addSkill("xqianghua")
	-- sibada:addSkill("wusheng")
end

-- 110
local fems = sgs.Sanguosha:getGeneral("fems")
if fems then
	-- fems:addSkill("shazhitan")
	-- fems:addSkill("fenghuo")
	-- fems:addSkill("xqianghua")
	-- fems:addSkill("wusheng")
end

-- 111
local min_luobinhan = sgs.Sanguosha:getGeneral("min_luobinhan")
if min_luobinhan then
	-- min_luobinhan:addSkill("shazhitan")
	-- min_luobinhan:addSkill("fenghuo")
	-- min_luobinhan:addSkill("xqianghua")
	-- min_luobinhan:addSkill("wusheng")
end

-- 112
local chen_luobinhan = sgs.Sanguosha:getGeneral("chen_luobinhan")
if chen_luobinhan then
	-- chen_luobinhan:addSkill("shazhitan")
	-- chen_luobinhan:addSkill("fenghuo")
	-- chen_luobinhan:addSkill("xqianghua")
	-- chen_luobinhan:addSkill("wusheng")
end

-- 140
local xiajie = sgs.Sanguosha:getGeneral("xiajie")
if xiajie then
	xiajie:addSkill("xqianghua")
	xiajie:addSkill("tianyi")
	xiajie:addSkill("shazhitan")
	xiajie:addSkill("liegong")
end

-- 141
local weizhongxian = sgs.Sanguosha:getGeneral("weizhongxian")
if weizhongxian then
	weizhongxian:addSkill("xjingzhun")
	weizhongxian:addSkill("toujivs")
	weizhongxian:addSkill("xqianghua")
	weizhongxian:addSkill("luoyi")
end

-- 142
local gaoqiu = sgs.Sanguosha:getGeneral("gaoqiu")
if gaoqiu then
	gaoqiu:addSkill("hongshadun")
	gaoqiu:addSkill("diehun")
	gaoqiu:addSkill("tanzhishou")
	gaoqiu:addSkill("yingzi")
end

-- 143
local xmh = sgs.Sanguosha:getGeneral("xmh")
if xmh then
	xmh:addSkill("shazhitan")
	xmh:addSkill("tianyi")
	xmh:addSkill("xqianghua")
	xmh:addSkill("liegong")
end

-- 144
local xzhurong = sgs.Sanguosha:getGeneral("xzhurong")
if xzhurong then
	xzhurong:addSkill("hongshadun")
	xzhurong:addSkill("qiangxi")
	xzhurong:addSkill("heishadun")
	xzhurong:addSkill("lijian")
end

-- 145
local liji = sgs.Sanguosha:getGeneral("liji")
if liji then
	liji:addSkill("xqianghua")
	liji:addSkill("tianyi")
	liji:addSkill("shazhitan")
	liji:addSkill("liegong")
end

-- 146
local wsgui = sgs.Sanguosha:getGeneral("wsgui")
if wsgui then
	wsgui:addSkill("xqianghua")
	wsgui:addSkill("tianyi")
	wsgui:addSkill("shazhitan")
	wsgui:addSkill("liegong")
end

-- 147
local gcg1 = sgs.Sanguosha:getGeneral("gcg1")
if gcg1 then
	gcg1:addSkill("xjingzhun")
	gcg1:addSkill("wusheng")
	gcg1:addSkill("shazhitan")
	gcg1:addSkill("tianyi")
end

-- 148
local xiaozhuang = sgs.Sanguosha:getGeneral("xiaozhuang")
if xiaozhuang then
	xiaozhuang:addSkill("tanzhishou")
	xiaozhuang:addSkill("yingzi")
	xiaozhuang:addSkill("shangzhitan")
	xiaozhuang:addSkill("jianxiong")
end

-- 149
local miyue = sgs.Sanguosha:getGeneral("miyue")
if miyue then
	miyue:addSkill("newlangyan")
	miyue:addSkill("fenghuo")
	miyue:addSkill("tanzhishou")
	miyue:addSkill("zhiheng")
end

-- 150
local nvwa = sgs.Sanguosha:getGeneral("nvwa")
if nvwa then
	nvwa:addSkill("tanzhishou")
	nvwa:addSkill("yingzi")
	nvwa:addSkill("shangzhitan")
	nvwa:addSkill("zhiheng")
end

-- 152
local xnianshou = sgs.Sanguosha:getGeneral("xnianshou")
if xnianshou then
	xnianshou:addSkill("tanzhishou")
	xnianshou:addSkill("yiji")
	xnianshou:addSkill("newlangyan")
	xnianshou:addSkill("fenghuo")
end

-- 153
local tpgz = sgs.Sanguosha:getGeneral("tpgz")
if tpgz then
	tpgz:addSkill("tanzhishou")
	tpgz:addSkill("zhiheng")
	tpgz:addSkill("xjingzhun")
	tpgz:addSkill("kongju")
end

-- 154
local moxi = sgs.Sanguosha:getGeneral("moxi")
if moxi then
	moxi:addSkill("shangzhitan")
	moxi:addSkill("jianxiong")
	moxi:addSkill("newlangyan")
	moxi:addSkill("fenghuo")
end