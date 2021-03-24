-- huiwei
sgs.ai_skill_invoke.huwei = function(self, data)
	local damage = data:toDamage()
	local to   = damage.to
	return self:isFriend(damage.to) and damage.from~=self.player and not to:hasSkill("buqu")
	and (self:getCardsNum(".", self.player, "e") >= 1 or self.player:getHp() > to:getHp())
end

sgs.ai_skill_choice.huwei = function(self, choices)
	if self:getCardsNum(".", self.player, "e") >= 1 then
	return "qi" end
	if self:getCardsNum(".", self.player, "e") == 0 then
	return "jian" end
end

-- chexuan
sgs.ai_skill_invoke.chexuan= true

local pozhen_skill={}
pozhen_skill.name="pozhen"
table.insert(sgs.ai_skills,pozhen_skill)
pozhen_skill.getTurnUseCard=function(self)
	if not self.player:hasUsed("PozhenCard") and not self.player:isKongcheng() then
		local max_card = self:getMaxCard()
		return sgs.Card_Parse("@PozhenCard=" .. max_card:getEffectiveId())
	end
end

sgs.ai_skill_use_func.PozhenCard = function(card, use, self)
	local max_card = self:getMaxCard()
	local max_point = max_card:getNumber()
	local ptarget = self:getPriorTarget()
	local slashcount = self:getCardsNum("Slash")
	if max_card:inherits("Slash") then slashcount = slashcount - 1 end
	if not ptarget:isKongcheng() and slashcount > 0 and self.player:canSlash(ptarget, true)
	and not ptarget:hasSkill("kongcheng") and ptarget:getHandcardNum() == 1 then
		local card_id = max_card:getEffectiveId()
		local card_str = "@PozhenCard=" .. card_id
		if use.to then
			use.to:append(ptarget)
		end
		use.card = sgs.Card_Parse(card_str)
		return
	end
	self:sort(self.enemies, "defense")

	for _, enemy in ipairs(self.enemies) do
		if self:getCardsNum("Snatch") > 0 and not enemy:isKongcheng() then
			local enemy_max_card = self:getMaxCard(enemy)
			local allknown = 0
			if self:getKnownNum(enemy) == enemy:getHandcardNum() then
				allknown = allknown + 1
			end
			if (enemy_max_card and max_point > enemy_max_card:getNumber() and allknown > 0)
				or (enemy_max_card and max_point > enemy_max_card:getNumber() and allknown < 1 and max_point > 10)
				or (not enemy_max_card and max_point > 10) and
				(self:getDangerousCard(enemy) or self:getValuableCard(enemy)) then
					local card_id = max_card:getEffectiveId()
					local card_str = "@PozhenCard=" .. card_id
					if use.to then
						use.to:append(enemy)
					end
					use.card = sgs.Card_Parse(card_str)
					return
			end
		end
	end
	local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards, true)
	if self:getUseValue(cards[1]) >= 6 or self:getKeepValue(cards[1]) >= 6 then return end
	if self:getOverflow() > 0 then
		if not ptarget:isKongcheng() then
			local card_id = max_card:getEffectiveId()
			local card_str = "@PozhenCard=" .. card_id
			if use.to then
				use.to:append(ptarget)
			end
			use.card = sgs.Card_Parse(card_str)
			return
		end
		for _, enemy in ipairs(self.enemies) do
			if not (enemy:hasSkill("kongcheng") and enemy:getHandcardNum() == 1) and not enemy:isKongcheng() and not enemy:hasSkill("tuntian") then
				use.card = sgs.Card_Parse("@PozhenCard=" .. cards[1]:getId())
				if use.to then use.to:append(enemy) end
				return
			end
		end
	end
end

sgs.ai_cardneed.pozhen = sgs.ai_cardneed.bignumber
sgs.ai_card_intention.PozhenCard = 30
sgs.dynamic_value.control_card.PozhenCard = true
sgs.ai_use_priority.PozhenCard = 8

-- jinguo
sgs.ai_skill_invoke.jinguo= true

sgs.ai_skill_choice.jinguo = function(self, choices)
	if self.player:isWounded() then return "huixue" end
	return "mopai"
end

sgs.ai_skill_invoke.guashuai = function(self, data)
	return self.player:getHandcardNum() <= 1
end

sgs.ai_skill_playerchosen.guashuai = function(self, targets)
	if self:isWeak() then return self.player end
	for _, player in sgs.qlist(targets) do
		if (player:getHandcardNum() <= 1 and self:isFriend(player)) or self:isFriend(player)  then
			return player
		end
	end
end

-- dianjiang
dianjiang_skill={}
dianjiang_skill.name = "dianjiang"
table.insert(sgs.ai_skills, dianjiang_skill)
dianjiang_skill.getTurnUseCard = function(self)
	if self.player:hasUsed("DianjiangCard") then return end
	local slash = self:getCard("Slash")
	if not slash then return end
	return sgs.Card_Parse("@DianjiangCard=" .. slash:getEffectiveId())
end
sgs.ai_skill_use_func["DianjiangCard"] = function(card, use, self)
	self:sort(self.friends,"threat")
	for _, friend in ipairs(self.friends) do
		if friend:getGeneral():isMale() then
			use.card = card
			if use.to then use.to:append(friend) end
			return
		end
	end
end

sgs.ai_skill_choice.dianjiang = function(self, choices)
	if self.player:getHandcardNum() >= 3 then return "bieren" end
	return "ziji"
end

--yanxiao
local yanxiao_skill={}
yanxiao_skill.name="yanxiao"
table.insert(sgs.ai_skills,yanxiao_skill)
yanxiao_skill.getTurnUseCard=function(self)
	local cards = self.player:getHandcards()
	local fks = {}
	for _, card in sgs.qlist(cards) do
		if card:getSuit() == sgs.Card_Diamond then
			table.insert(fks, card)
		end
	end

	if #fks == 0 or self.player:getHandcardNum() <= 1 then return end
	self:sortByUseValue(fks, true)

	local card_str = ("@YanxiaoCard=%d"):format(fks[1]:getEffectiveId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["YanxiaoCard"]=function(card,use,self)
	for _, friend in ipairs(self.friends) do
	local judges = friend:getJudgingArea()
	if (not judges:isEmpty() or friend:isKongcheng() or self:isWeak(friend) or friend:hasSkill("duizhi") or friend:hasSkill("guose") or friend:hasSkill("jijiu")) and friend:getPile("xiao"):isEmpty() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
end

-- haolongdan
sgs.ai_skill_invoke.haolongdan= function(self, data)
	local effect = data:toSlashEffect()
	return not self:isFriend(effect.to)
end

sgs.ai_skill_use["@@tuji"]=function(self,prompt)
	self:updatePlayers()
	self:sort(self.enemies,"defense")
	if self.player:containsTrick("lightning") and self.player:getCards("j"):length()==1
		and self:hasWizard(self.friends) and not self:hasWizard(self.enemies,true) then return false end

	local selfSub = self.player:getHp()-self.player:getHandcardNum()
	local selfDef = sgs.getDefense(self.player)
	local hasJud = self.player:getJudgingArea()

	for _,enemy in ipairs(self.enemies) do
		local def=sgs.getDefense(enemy)
		local amr=enemy:getArmor()
		local eff=(not amr) or self.player:hasWeapon("qinggang_sword") or not
			((amr:inherits("Vine") and not self.player:hasWeapon("fan"))
			or (amr:objectName()=="eight_diagram"))

		if (enemy:hasSkill("kongcheng") and enemy:isKongcheng()) or enemy:getMark("@feigong2") > 0 or not self.player:inMyAttackRange(enemy) then
		elseif self:slashProhibit(nil, enemy) then
		elseif def<6 and eff then return "@TujiCard=.->"..enemy:objectName()

		elseif selfSub>=2 then return "."
		elseif selfDef<6 then return "." end

	end

	for _,enemy in ipairs(self.enemies) do
		local def=sgs.getDefense(enemy)
		local amr=enemy:getArmor()
		local eff=(not amr) or self.player:hasWeapon("qinggang_sword") or not
			((amr:inherits("Vine") and not self.player:hasWeapon("fan"))
			or (amr:objectName()=="eight_diagram"))

		if (enemy:hasSkill("kongcheng") and enemy:isKongcheng()) or enemy:getMark("@feigong2") > 0 or not self.player:inMyAttackRange(enemy) then
		elseif self:slashProhibit(nil, enemy) then
		elseif eff and def<8 then return "@TujiCard=.->"..enemy:objectName()
		else return "." end
	end
	return "."
end

-- feiren
local feiren_skill={}
feiren_skill.name="feiren"
table.insert(sgs.ai_skills,feiren_skill)
feiren_skill.getTurnUseCard=function(self)
	local cards = self.player:getHandcards()
	local slashs = {}
	for _, card in sgs.qlist(cards) do
		if card:inherits("Slash") or card:inherits("Weapon") then
			table.insert(slashs, card)
		end
	end

	if #slashs == 0 or self.player:hasUsed("FeirenCard") then return end
	self:sortByUseValue(slashs, true)

	local card_str = ("@FeirenCard=%d"):format(slashs[1]:getEffectiveId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["FeirenCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if not enemy:getArmor() and not self.player:inMyAttackRange(enemy) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
		end
	end
end

-- dunjia
sgs.ai_skill_invoke.dunjia = true

-- duwu
sgs.ai_skill_invoke.duwu= function(self, data)
	return #self.enemies > 1 and self.player:getHp() > 1
end

sgs.ai_skill_playerchosen.duwu = function(self, targets)
    for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and self:isWeak(player) then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) and player:isKongcheng() then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) and player:getLostHp()>0 then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) and not self:isEquip("EightDiagram", player) and not player:hasSkill("bazhen") then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) then
			return player
		end
	end
end

--zhinangf
local zhinangf_skill={}
zhinangf_skill.name="zhinangf"
table.insert(sgs.ai_skills,zhinangf_skill)
zhinangf_skill.getTurnUseCard=function(self,inclusive)
    if self.player:getPile("zhi"):length() < 2 then return end
	if self.player:getMark("zhinangf_mark") <= 0 then return end
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	local zhinangcard = sgs.Sanguosha:getCard(self.player:getMark("zhinangf_mark"))
	local cards = sgs.QList2Table(self.player:getHandcards())
				self:sortByUseValue(cards, true)
				for _, hcard in ipairs(cards) do
					if hcard:isRed() or hcard:isBlack() then
						local zhinang = sgs.Sanguosha:cloneCard(zhinangcard:objectName(), hcard:getSuit(), hcard:getNumber())
						zhinang:addSubcard(hcard:getId())
						zhinang:setSkillName("zhinangf")
						if self:getUseValue(zhinangcard) > self:getUseValue(hcard) then
					    return zhinang
			end
		end
	end
end

sgs.ai_skill_invoke.zhinangf = true

-- caijian
sgs.ai_skill_invoke.caijian = sgs.ai_skill_invoke.eight_diagram

-- yaoshu
yaoshu_skill={}
yaoshu_skill.name="yaoshu"
table.insert(sgs.ai_skills,yaoshu_skill)
yaoshu_skill.getTurnUseCard=function(self)
	if self.player:hasUsed("YaoshuCard") then return end

	local card
	if self.player:getArmor() and (self.player:getArmor():objectName() == "jinlinjia" and self.player:isWounded()) then
		card = self.player:getArmor()
	end
	if not card then
		local hcards = self.player:getCards("h")
		hcards = sgs.QList2Table(hcards)
		self:sortByUseValue(hcards, true)

		for _, hcard in ipairs(hcards) do
			if hcard:inherits("EquipCard") then
				card = hcard
				break
			end
		end
	end
	if card then
		card = sgs.Card_Parse("@YaoshuCard=" .. card:getEffectiveId())
		return card
	end

	return nil
end

sgs.ai_skill_use_func.YaoshuCard=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if enemy:getGeneralName() ~= "anjiang" then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
		end
	end
end

-- heiwu
sgs.ai_skill_invoke.heiwu= true

-- diewu
sgs.ai_skill_invoke.diewu= true

local qimen_skill={}
qimen_skill.name="qimen"
table.insert(sgs.ai_skills,qimen_skill)
qimen_skill.getTurnUseCard=function(self,inclusive)
    if self.player:getMark("@qimen") > 0 then return end
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	for _,acard in ipairs(cards)  do
		if (acard:inherits("TrickCard")) and ((self:getUseValue(acard)<sgs.ai_use_value["Toulianghuanzhu"]) or inclusive) then
		    local shouldUse=true

		    if shouldUse then
			    card = acard
			    break
			end
		end
	end

    if not card then return end
	local number = card:getNumberString()
	local suit = card:getSuitString()
    local card_id = card:getEffectiveId()
	local card_str = ("toulianghuanzhu:qimen[%s:%s]=%d"):format(suit, number, card_id)
	local  toulianghuanzhu= sgs.Card_Parse(card_str)

    assert(toulianghuanzhu)

    return toulianghuanzhu
end
