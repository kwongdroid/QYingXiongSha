-- anshu
sgs.ai_skill_invoke.anshu = true

sgs.ai_skill_playerchosen.anshu = function(self, targets)
	for _, enemy in ipairs(self.enemies) do
	if enemy:getPile("jice"):isEmpty() and enemy:getMark("xinfanjian") <= 0 then
		 return enemy
	end
  end
end

--xinfanjian
local xinfanjian_skill={}
xinfanjian_skill.name="xinfanjian"
table.insert(sgs.ai_skills,xinfanjian_skill)
xinfanjian_skill.getTurnUseCard=function(self)
	if not self.player:hasUsed("XinfanjianCard") then
		return sgs.Card_Parse("@XinfanjianCard=.")
	end
end

sgs.ai_skill_use_func["XinfanjianCard"]=function(card,use,self)
    for _, enemy in ipairs(self.enemies) do
		if not enemy:getPile("jice"):isEmpty() and enemy:getMark("xinfanjian") > 0 then

			for _, enemy2 in ipairs(self.enemies) do
				if not enemy2:getPile("jice"):isEmpty() and enemy2 ~= enemy and enemy2:getMark("xinfanjian") > 0 then
						use.card = card
						if use.to then use.to:append(enemy) end
						if use.to then use.to:append(enemy2) end
						return
				end
			end
		end
	end
end

-- qinlv
sgs.ai_skill_invoke.qinlv = true

-- gedi
sgs.ai_skill_invoke.gedi = true

sgs.ai_skill_playerchosen.gedi = function(self, targets)
	for _, enemy in ipairs(self.enemies) do
	if not enemy:isNude() then
		 return enemy
	end
  end
end

-- hongmian
sgs.ai_skill_invoke.hongmian = true

-- jinbiao
sgs.ai_skill_invoke.jinbiao = function(self, data)
    local cards = self.player:getCards("he")
	local equips = {}
	for _, card in sgs.qlist(cards) do
		if card:getTypeId() == sgs.Card_Equip then
			table.insert(equips, card)
		end
	end
	if #equips == 0 then return end
	return #self.enemies > 0
end

sgs.ai_skill_playerchosen.jinbiao = function(self, targets)
	for _, enemy in ipairs(self.enemies) do
	if self:isWeak(enemy) then
		 return enemy
	end
  end
    for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) then
			return player
		end
	end
end

-- cihuai
sgs.ai_skill_invoke.cihuai = function(self, data)
    if self.player:getPhase() == sgs.Player_Play then return self:getCardsNum("Slash") <= 0 end
	return true
end

local cihuai_skill={}
cihuai_skill.name="cihuai"
table.insert(sgs.ai_skills,cihuai_skill)
cihuai_skill.getTurnUseCard=function(self)
	if self.player:getMark("@cihuai") <= 0 or not self:slashIsAvailable() then return end
	local card_str = "@CihuaiCard=."
	local slash = sgs.Card_Parse(card_str)
	assert(slash)
	return slash
end

sgs.ai_skill_use_func.CihuaiCard=function(card,use,self)
	self:sort(self.enemies, "defense")
	local target_count=0

	for _, enemy in ipairs(self.enemies) do
		if (self.player:canSlash(enemy, not no_distance) or
			(use.isDummy and self.player:distanceTo(enemy)<=(self.predictedRange or self.player:getAttackRange())))
			and self:objectiveLevel(enemy)>3 and self:slashIsEffective(card, enemy)
			and not (enemy:isKongcheng() and enemy:hasSkill("kongcheng"))
			and enemy:getMark("@feigong2") <= 0 then
			use.card=card
			if use.to then
				use.to:append(enemy)
			end
			target_count=target_count+1
			if self.slash_targets<=target_count then return end
		end
	end
end

sgs.ai_use_priority.CihuaiCard = 12

-- laozi
sgs.ai_skill_invoke.wendao = true

--wendao
local wendao_skill={}
wendao_skill.name="wendao"
table.insert(sgs.ai_skills,wendao_skill)
wendao_skill.getTurnUseCard=function(self,inclusive)
	if self.player:getMark("wendao_mark") <= 0 then return end
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	local wendaocard = sgs.Sanguosha:getCard(self.player:getMark("wendao_mark"))
	local cards = sgs.QList2Table(self.player:getHandcards())
				self:sortByUseValue(cards, true)
				for _, hcard in ipairs(cards) do
					if hcard:isRed() or hcard:isBlack() then
						local wendao = sgs.Sanguosha:cloneCard(wendaocard:objectName(), hcard:getSuit(), hcard:getNumber())
						wendao:addSubcard(hcard:getId())
						wendao:setSkillName("wendao")
						if self:getUseValue(wendaocard) > self:getUseValue(hcard) then
					    return wendao
			end
		end
	end
end

-- wuwei
local wuwei_skill={}
wuwei_skill.name="wuwei"
table.insert(sgs.ai_skills,wuwei_skill)
wuwei_skill.getTurnUseCard=function(self)
	if not self.player:getPile("lingfu"):isEmpty() then return end

	local cards = self.player:getHandcards()
	local lingfus = {}
	for _, card in sgs.qlist(cards) do
		if card:getSuit() ~= sgs.Card_Heart and card:getSuit() ~= sgs.Card_Diamond and not card:inherits("Peach") and not card:inherits("Fuzhou") then
			table.insert(lingfus, card)
		end
	end

	if #lingfus == 0 then return end
	self:sortByUseValue(lingfus, true)

	local card_str = ("@WuweiCard=%d"):format(lingfus[1]:getEffectiveId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["WuweiCard"]=function(card,use,self)
	use.card = card
end
