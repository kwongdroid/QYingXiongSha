sgs.ai_skill_choice["wumou"] = function(self, choices)
	if self.player:getHp() + self:getCardsNum("Peach") > 3 then return "losehp"
	else return "losebiaoji"
	end
end

sgs.ai_skill_invoke.cangfei = function(self, data)
	return true
end	

sgs.ai_skill_invoke.shayi = function(self, data)
	return true
end	

local shayi_skill = {}
shayi_skill.name = "shayi"
table.insert(sgs.ai_skills, shayi_skill)
shayi_skill.getTurnUseCard = function(self, inclusive)	
	if self.player:isKongcheng() then return nil end			
	return sgs.Card_Parse("#shayicard:.:")
end

sgs.ai_skill_use_func["#shayicard"] = function(card, use, self)	
        if not self.player:hasFlag("shayibuff")  then return end
        local sycard 
        local cards = self.player:getCards("he")	 	 					
		cards = sgs.QList2Table(cards)
		for _, fcard in ipairs(cards) do
			if not fcard:isRed() then
				sycard = fcard
			end
        end											
		local enemies = {}
	    for _,p in ipairs(self.enemies) do					    		
		    if self.player:canSlash(p, true) then                                              			
			    table.insert(enemies,p)
            end				
		end           							    
	    if #enemies == 0  then return end	
        self:sort(self.enemies, "hp")			
		use.card = sgs.Card_Parse("#shayicard:"..sycard:getEffectiveId()..":")	 	
	    if use.card and use.to then
		    use.to:append(enemies[1])
	    end
end

sgs.ai_skill_invoke.shenqu = true

local xguimian_skill={}
xguimian_skill.name="xguimian"
table.insert(sgs.ai_skills,xguimian_skill)
xguimian_skill.getTurnUseCard=function(self)	
    if self.player:isKongcheng() then return nil end
	if self:getCardsNum("Slash") == 0 then return nil end	
	if #self.enemies==0 then return nil end
	local cando = false
	for _,p in ipairs(self.enemies) do
		if p:getMark("@xyuxueuse")>0 then
			cando = true
			break
		end
	end
	if not cando then return nil end	
	return sgs.Card_Parse("#xguimian_card:.:")
end

sgs.ai_skill_use_func["#xguimian_card"]=function(card,use,self)
    if self.player:isKongcheng() then return nil end	
	for _, enemy in ipairs(self.enemies) do	
	    if enemy:getMark("@xyuxueuse")>0 then 			   	
			use.card=card
			if use.to then use.to:append(enemy) end
			return
		end
	end
end

sgs.ai_skill_playerchosen.xguimian = function(self, targets)
    for _, enemy in ipairs(self.enemies) do	
	    if enemy:getMark("@xyuxueuse")>0 then         
		    return enemy 
		end
	end  
end

local youmie_skill={}
youmie_skill.name="youmie"
table.insert(sgs.ai_skills,youmie_skill)
youmie_skill.getTurnUseCard=function(self)
	if self.player:hasUsed("#youmie_card") then return nil end	
	if #self.enemies==0 then return nil end	
	if self.player:getMark("@youmieskill")>0 then return nil end		
	local cando = false
	for _,p in ipairs(self.enemies) do
		if p:getGeneral():isMale() then
			cando = true
			break
		end
	end
	if not cando then return nil end	
	return sgs.Card_Parse("#youmie_card:.:")
end

sgs.ai_skill_use_func["#youmie_card"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do	
	    if enemy:getGeneral():isMale() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
		end
	end
end

sgs.ai_skill_invoke.youmie = true

local xshenfen_skill={}
xshenfen_skill.name = "xshenfen"
table.insert(sgs.ai_skills, xshenfen_skill)
xshenfen_skill.getTurnUseCard=function(self)
    if self.player:hasUsed("#shenfencard") then return nil end
	if self.player:getMark("@wrath") < 6 then return nil end
	return sgs.Card_Parse("#shenfencard:.:")
end

sgs.ai_skill_use_func["#shenfencard"]=function(card,use,self)
	if self:isFriend(self.room:getLord()) and self:isWeak(self.room:getLord()) and not self.player:isLord() then return end
	use.card = card
end

sgs.ai_use_value["#shenfencard"] = 8
sgs.ai_use_priority["#shenfencard"] = 3
sgs.dynamic_value.damage_card["#shenfencard"] = true
sgs.dynamic_value.control_card["#shenfencard"] = true

sgs.ai_skill_invoke.guixin = function(self,data)
	return self.room:alivePlayerCount() > 2
end

sgs.ai_chaofeng.sgkcaocao = -6

sgs.ai_skill_invoke.jianwu = function(self, data)
	return  self:getCardsNum("Slash") > 0 or self:isWeak()
end

sgs.ai_skill_invoke.Chongzhenwz = function(self, data)	
	local target = self.room:getTag("ChongzhenwzTo"):toPlayer()	
	if self:isFriend(target)  then
		return target:hasSkill("kongcheng") and target:getHandcardNum() == 1
	else
		return not (target:hasSkill("kongcheng") and target:getHandcardNum() == 1)  
	end
end

local Longdanwz_skill={}
Longdanwz_skill.name="Longdanwz"
table.insert(sgs.ai_skills,Longdanwz_skill)
Longdanwz_skill.getTurnUseCard=function(self)
	local cards = self.player:getCards("h")
	cards=sgs.QList2Table(cards)
	local jink_card
	self:sortByUseValue(cards,true)
	for _,card in ipairs(cards)  do
		if card:inherits("Jink") then
			jink_card = card
			break
		end
	end
	if not jink_card then return nil end
	local suit = jink_card:getSuitString()
	local number = jink_card:getNumberString()
	local card_id = jink_card:getEffectiveId()
	local card_str = ("slash:Longdanwz[%s:%s]=%d"):format(suit, number, card_id)
	local slash = sgs.Card_Parse(card_str)
	assert(slash)
	return slash
end

sgs.ai_view_as.Longdanwz = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card_place ~= sgs.Player_Equip then
		if card:inherits("Jink") then
			return ("slash:Longdanwz[%s:%s]=%d"):format(suit, number, card_id)
		elseif card:inherits("Slash") then
			return ("jink:Longdanwz[%s:%s]=%d"):format(suit, number, card_id)
		end
	end
end

sgs.ai_use_priority.Longdanwz = 9

sgs.xyuefei_keep_value =
{
	Peach = 7.5,
	Fuzhou = 7.5,
	Analeptic = 5.3,
	Jink = 7.3,
	XueSlash = 7.5,
	AnSlash = 7.5,
	FireSlash = 5.5,
	Slash = 7.5,
	ThunderSlash = 5.3,
	ExNihilo = 5.3
}

sgs.ai_skill_invoke.honglian = function(self, data)
    for _, enemy in ipairs(self.enemies) do    
	    if self.player:canSlash(enemy, true)  and not self.player:isKongcheng()  and not (enemy:hasSkill("kongcheng") and enemy:isKongcheng()) then return true end
	end
end

sgs.ai_skill_playerchosen.honglian = function(self, targets)
	for _, target in sgs.qlist(targets) do
		if self:isEnemy(target) and self.player:canSlash(target, true) then
			return target
		end
	end
end

function bindSkills(room)	
	local skillsOnline={}	
	local skillsAll={"#fenjiskill","#fenjiinvoke","#fenglaiqinskill","#fenglaiqin2skill"}
	local all = room:getAlivePlayers()
	for _, p in sgs.qlist(all) do
		for _, itemAll in ipairs(skillsAll) do
			room:acquireSkill(p,itemAll)
		end
		for _, itemOnline in ipairs(skillsOnline) do
			if p:getState() ~= "robot" then room:acquireSkill(p,itemOnline) end
		end
	end	
end

sgs.ai_skill_invoke["#fenjiskill"] = function(self, data)
	local dying = data:toDying()
	return self:isEnemy(dying.who)
end

function sgs.ai_weapon_value.fenji_sword()
	return 3.8
end

function sgs.ai_armor_value.fenglaiqin()
	return 3.8
end

sgs.ai_skill_invoke["#fenglaiqinskill"] = function(self, data)
	return true
end

sgs.ai_skill_playerchosen["#fenglaiqinskill"] = function(self, targets)
	for _, target in sgs.qlist(targets) do
		if self:isEnemy(target) then
			return target
		end
	end
end

sgs.ai_skill_invoke.meiying = function(self, data)
    local effect=data:toCardEffect()
	return  self:isEnemy(effect.from) and (effect.card:inherits("Slash") or effect.card:inherits("Snatch") or effect.card:inherits("Dismantlement") or effect.card:inherits("Duel"))  
end

sgs.ai_skill_invoke.moukui = true

sgs.ai_skill_invoke.xxbudao = function(self, data)
	local damage = data:toDamage()
	return self:isEnemy(damage.to) and self:getCardsNum("Slash") > 0
end

function sgs.ai_cardneed.xxbudao(to, card)
	if not to:containsTrick("indulgence") then
		return card:inherits("Slash")
	end
end

sgs.spguanyu_keep_value =
{
	Peach = 6,
	Fuzhou = 6,
	Analeptic = 5.8,
	Jink = 5.7,
	XueSlash = 5.6,
	AnSlash = 5.6,
	FireSlash = 5.6,
	Slash = 5.6,
	ThunderSlash = 5.6,
	ExNihilo = 5.0
}

sgs.ai_skill_invoke.jianfeng = function(self, data)
	local damage = data:toDamage()
	return not self:isFriend(damage.to)
end  

sgs.ai_skill_invoke.srqicai = true

aowu_skill={}
aowu_skill.name="aowu"
table.insert(sgs.ai_skills,aowu_skill)
aowu_skill.getTurnUseCard=function(self)
	local cards = self.player:getCards("he")
	cards=sgs.QList2Table(cards)
	local red_card
	self:sortByUseValue(cards,true)
	for _,card in ipairs(cards)  do
		if card:getSuitString()=="heart" then--and (self:getUseValue(card)<sgs.ai_use_value.Slash) then
			red_card = card
			break
		end
	end
	if red_card then
		local suit = red_card:getSuitString()
		local number = red_card:getNumberString()
		local card_id = red_card:getEffectiveId()
		local card_str = ("slash:aowu[%s:%s]=%d"):format(suit, number, card_id)
		local slash = sgs.Card_Parse(card_str)
		assert(slash)
		return slash
	end
end

sgs.ai_filterskill_filter.aowu = function(card, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card:getSuit() == sgs.Card_Heart then return ("slash:aowu[%s:%s]=%d"):format(suit, number, card_id) end
end

sgs.ai_skill_invoke.lengao = function(self, data)
	return data:toSlashEffect().from:getHp() > self.player:getHp()
end

sgs.ai_skill_invoke.srruya = true

sgs.ai_skill_discard.jiaoyan = function(self, discard_num, optional, include_equip)
	local to_discard = {}
	local cards = sgs.QList2Table(self.player:getHandcards())
	local index = 0
	local all_peaches = 0
	for _, card in ipairs(cards) do
		if card:inherits("Peach") then
			all_peaches = all_peaches + 1
		end
	end
	if all_peaches >= 1 and self:getOverflow() <= 0 then return {} end
	self:sortByKeepValue(cards)
	cards = sgs.reverse(cards)
	for i = #cards, 1, -1 do
		local card = cards[i]
		if not card:inherits("Peach") and not self.player:isJilei(card) then
			table.insert(to_discard, card:getEffectiveId())
			table.remove(cards, i)
			index = index + 1
			if index == 2 then break end
		end
	end
	if #to_discard < 2 then return {}
	else
		return to_discard
	end
end

sgs.ai_skill_invoke.meinv = function(self, data)
	if self.player:isKongcheng() then return nil end
	return true
end

sgs.ai_skill_askforag["meinv"] = function(self, card_ids)
    local handcards = sgs.QList2Table(self.player:getHandcards())
	self:sortByKeepValue(handcards)
	local card = handcards[1] 
	return card
end

sgs.meiji_keep_value =
{
	Peach = 7.5,
	Fuzhou = 7.5,
	Analeptic = 5.5,
	Jink = 8.0,
	XueSlash = 7.5,
	AnSlash = 7.5,
	FireSlash = 5.5,
	Slash = 7.5,
	ThunderSlash = 5.5,
}

local yaozhan_skill = {}
yaozhan_skill.name = "yaozhan"
table.insert(sgs.ai_skills, yaozhan_skill)
yaozhan_skill.getTurnUseCard = function(self, inclusive)
	if self.player:hasUsed("#yaozhan_card") then return nil end
	if self.player:isKongcheng() then return nil end
	if #self.enemies==0 then return nil end
	local cando = false
	for _,p in ipairs(self.enemies) do
		if not p:isKongcheng() and p:getHandcardNum() <=3 then
			cando = true
			break
		end
	end
	if not cando then return nil end	
	return sgs.Card_Parse("#yaozhan_card:.:")
end

sgs.ai_skill_use_func["#yaozhan_card"] = function(card, use, self)
	local maxcard = self.player:getHandcards():first()
	for _, c in sgs.qlist(self.player:getHandcards()) do
		if c:getNumber() > maxcard:getNumber() then
			maxcard =c 
		end
	end
	if maxcard:getNumber() <=6 then return end	
	local enemies = {}
	for _,p in ipairs(self.enemies) do
		if not p:isKongcheng() and p:getHandcardNum() <=3 then
			table.insert(enemies,p)
		end
	end
	self:sort(enemies,"defense")
	use.card = sgs.Card_Parse("#yaozhan_card:"..maxcard:getEffectiveId()..":")
	if use.card and use.to then
		use.to:append(enemies[1])
	end
end

local zhuxin_skill = {}
zhuxin_skill.name = "zhuxin"
table.insert(sgs.ai_skills, zhuxin_skill)
zhuxin_skill.getTurnUseCard = function(self, inclusive)
	if self.player:hasUsed("#zhuxin_card") then return nil end
	if self.player:isKongcheng() then return nil end
	if #self.enemies==0 then return nil end
	local cando = false
	for _,p in ipairs(self.enemies) do
		if not p:isKongcheng() and p:getHandcardNum() <=3 then
			cando = true
			break
		end
	end
	if not cando then return nil end	
	return sgs.Card_Parse("#zhuxin_card:.:")
end

sgs.ai_skill_use_func["#zhuxin_card"] = function(card, use, self)
	local maxcard = self.player:getHandcards():first()
	for _, c in sgs.qlist(self.player:getHandcards()) do
		if c:getNumber() > maxcard:getNumber() then
			maxcard =c 
		end
	end
	if maxcard:getNumber() <=5 then return end	
	local enemies = {}
	for _,p in ipairs(self.enemies) do
		if not p:isKongcheng() and p:getHandcardNum() <=3 then
			table.insert(enemies,p)
		end
	end
	self:sort(enemies,"defense")
	use.card = sgs.Card_Parse("#zhuxin_card:"..maxcard:getEffectiveId()..":")
	if use.card and use.to then
		use.to:append(enemies[1])
	end
end

sgs.ai_skill_invoke.zhenguo = true

sgs.ai_skill_invoke.wencai = function(self, data)
    if self.player:getHp() > 1 then return false end	
	return true
end

local xiezheng_skill = {}
xiezheng_skill.name = "xiezheng"
table.insert(sgs.ai_skills, xiezheng_skill)
xiezheng_skill.getTurnUseCard = function(self, inclusive)
	if self.player:hasUsed("#xiezhengcard") then return nil end
	if self.player:isKongcheng() then return nil end
	return sgs.Card_Parse("#xiezhengcard:.:")
end

sgs.ai_skill_use_func["#xiezhengcard"] = function(card, use, self)
    if self.player:isKongcheng() then return nil end
	local mcard 	
	for _, c in sgs.qlist(self.player:getHandcards()) do
		if not (c:inherits("Peach") or c:inherits("Fuzhou")) then
			mcard =c 
		end
	end	
	local enemies = {}
	for _,p in ipairs(self.enemies) do
		if  p:getHandcardNum() >= 3 then
			table.insert(enemies,p)
		end
	end	
	if #enemies == 0  then return end
	self:sort(enemies,"defense")
	use.card = sgs.Card_Parse("#xiezhengcard:"..mcard:getEffectiveId()..":")
	if use.card and use.to then
		use.to:append(enemies[1])
	end
end

local mimou_skill={}
mimou_skill.name="mimou"
table.insert(sgs.ai_skills,mimou_skill)
mimou_skill.getTurnUseCard=function(self,inclusive)
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)
	local card
	self:sortByUseValue(cards,true)
	for _,acard in ipairs(cards)  do
		if (acard:getSuit() == sgs.Card_Diamond) and ((self:getUseValue(acard)<sgs.ai_use_value["Collateral"]) or inclusive) then
		    local shouldUse=true
		    if shouldUse then
			    card = acard
			    break
			end
		end
	end
    if not card then return end
	local number = card:getNumberString()
    local card_id = card:getEffectiveId()
	local card_str = ("collateral:mimou[diamond:%s]=%d"):format(number, card_id)
	local collateral = sgs.Card_Parse(card_str)
    assert(collateral)
    return collateral
end

sgs.ai_skill_invoke.tanlan = function(self, data)
	return true
end

sgs.ai_skill_invoke.linglong = function(self, data)
    local damage = data:toDamage()
	if self:isEnemy(damage.from) then
	    if self.player:getHandcardNum()>damage.from:getHandcardNum() then return nil end
	end
	return  self:getCardsNum("Peach") == 0 
end

local tianjiao_skill={}
tianjiao_skill.name="tianjiao"
table.insert(sgs.ai_skills,tianjiao_skill)
tianjiao_skill.getTurnUseCard=function(self)
	if self.player:hasUsed("#tianjiao_card") then return nil end	
	if #self.enemies==0 then return nil end		
	if self.player:getHp()==1 and self:getCardsNum("Jink")==0 then return nil end	
	if self.player:getHp()==1 and self.player:isKongcheng() then return nil end
	local cando = false
	for _,p in ipairs(self.enemies) do
		if not p:isAllNude() then
			cando = true
			break
		end
	end
	if not cando then return nil end	
	return sgs.Card_Parse("#tianjiao_card:.:")
end

sgs.ai_skill_use_func["#tianjiao_card"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	    if not enemy:isNude() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
		end
	end
end

local tianming_skill = {}
tianming_skill.name = "tianming"
table.insert(sgs.ai_skills, tianming_skill)
tianming_skill.getTurnUseCard = function(self, inclusive)	
	if self.player:isKongcheng() then return nil end
	if #self.enemies==0 then return nil end
	local cando = false
	for _,p in ipairs(self.enemies) do
		if not p:isKongcheng() and p:getMark("@tianming")==0 then
			cando = true
			break
		end
	end
	if not cando then return nil end	
	return sgs.Card_Parse("#tianming_card:.:")
end

sgs.ai_skill_use_func["#tianming_card"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	    if not enemy:isKongcheng() and enemy:getMark("@tianming")==0 then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
		end
	end
end

