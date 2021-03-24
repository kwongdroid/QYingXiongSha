-- yxs
-- jijiangf
sgs.ai_skill_invoke.jijiangf = function(self, data)
	local cards = self.player:getHandcards()
	for _, card in sgs.qlist(cards) do
		if card:inherits("Slash") then
			return false
		end
	end
	if sgs.jijiangsource then return false else return true end
end

sgs.ai_skill_choice.jijiangf = function(self , choices)
	if not self.player:hasLordSkill("jijiangf") then
		if self:getCardsNum("Slash") <= 0 then return "ignore" end
	end

	if self.player:isLord() then
		local target
		for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
			if player:hasSkill("weidi") then
				target = player
				break
			end
		end
		if target and self:isEnemy(target) then return "ignore" end
	elseif self:isFriend(self.room:getLord()) then return "accept" end
	return "ignore"
end

local jijiangf_skill={}
jijiangf_skill.name="jijiangf"
table.insert(sgs.ai_skills,jijiangf_skill)
jijiangf_skill.getTurnUseCard=function(self)
	if self.player:hasUsed("JijiangfCard") or not self:slashIsAvailable() then return end
	local card_str = "@JijiangfCard=."
	local slash = sgs.Card_Parse(card_str)
	assert(slash)

	return slash
end

sgs.ai_skill_use_func["JijiangfCard"]=function(card,use,self)
	self:sort(self.enemies, "defense")
	local target_count=0
	for _, enemy in ipairs(self.enemies) do
	if ((self.player:canSlash(enemy, not no_distance)) or
		(use.isDummy and (self.player:distanceTo(enemy)<=self.predictedRange)))
		and
		self:objectiveLevel(enemy)>3 and
		self:slashIsEffective(card, enemy) then
		use.card=card
		if use.to then
			use.to:append(enemy)
		end
		target_count=target_count+1
		if self.slash_targets<=target_count then return end
	end
end
end

sgs.ai_skill_choice.hujiaf = function(self , choices)
	if not self.player:hasLordSkill("hujiaf") then
		if self:getCardsNum("Jink") <= 0 then return "ignore" end
	end
	if self.player:isLord() then
		local target
		for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
			if player:hasSkill("weidi") then
				target = player
				break
			end
		end
		if target and self:isEnemy(target) then return "ignore" end
	elseif self:isFriend(self.room:getLord()) then return "accept" end
	return "ignore"
end

-- hujiaf
sgs.ai_skill_invoke.hujiaf = function(self, data)
	local cards = self.player:getHandcards()
	if sgs.hujiafsource then return false end
	for _, friend in ipairs(self.friends_noself) do
		if friend:getKingdom() == "wei" and self:isEquip("EightDiagram", friend) then return true end
	end
	for _, card in sgs.qlist(cards) do
		if card:inherits("Jink") then
			return false
		end
	end
	return true
end

--jianxiongyxs
local jianxiongyxs_skill={}
jianxiongyxs_skill.name="jianxiongyxs"
table.insert(sgs.ai_skills,jianxiongyxs_skill)
jianxiongyxs_skill.getTurnUseCard=function(self,inclusive)
    if self.player:getMark("jianxiongused") > 0 then return end
	if self.player:getMark("jianxiongyxs_mark") <= 0 then return end
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	local jianxiongcard = sgs.Sanguosha:getCard(self.player:getMark("jianxiongyxs_mark"))
	local cards = sgs.QList2Table(self.player:getHandcards())
				self:sortByUseValue(cards, true)
				for _, hcard in ipairs(cards) do
					if hcard:isRed() or hcard:isBlack() then
						local jianxiong = sgs.Sanguosha:cloneCard(jianxiongcard:objectName(), hcard:getSuit(), hcard:getNumber())
						jianxiong:addSubcard(hcard:getId())
						jianxiong:setSkillName("jianxiongyxs")
						if self:getUseValue(jianxiongcard) > self:getUseValue(hcard) then
					    return jianxiong
			end
		end
	end
end

-- budao
sgs.ai_skill_invoke.budao = function(self, data)
	local damage = data:toDamage()
	return self:isEnemy(damage.to) and self:getCardsNum("Slash") > 0
end

function sgs.ai_cardneed.budao(to, card)
	if not to:containsTrick("indulgence") then
		return card:inherits("Slash")
	end
end

sgs.guanyu_keep_value =
{
	Peach = 6,
	Fuzhou = 6,
	Analeptic = 5.8,
	Jink = 5.7,
	XueSlash = 5.6,
	AnSlash = 5.4,
	FireSlash = 5.6,
	Slash = 5.4,
	ThunderSlash = 5.5,
	ExNihilo = 4.7
}

--diehun
sgs.ai_skill_invoke.diehun = function(self, data)
	local effect = data:toCardEffect()
	return (effect.card:inherits("GodSalvation") and not self.player:isWounded()) or effect.card:inherits("AOE")
	or effect.card:inherits("IronChain") or (self:isEnemy(effect.from) and effect.card:inherits("Geanguanhuo")) or (self:isEnemy(effect.from) and effect.card:inherits("Toulianghuanzhu"))
end

--fenghuo
local fenghuo_skill={}
fenghuo_skill.name="fenghuo"
table.insert(sgs.ai_skills,fenghuo_skill)
fenghuo_skill.getTurnUseCard=function(self,inclusive)
	local equips = self.player:getCards("e")
	if not equips then return end

	local eCard
	local hasCard={0, 0, 0, 0}
	for _, card in sgs.qlist(self.player:getCards("he")) do
		if card:inherits("EquipCard") then
			hasCard[sgs.ai_get_cardType(card)] = hasCard[sgs.ai_get_cardType(card)]+1
		end
	end

	for _, card in sgs.qlist(equips) do
		if hasCard[sgs.ai_get_cardType(card)]>1 or sgs.ai_get_cardType(card)>3 then
			eCard = card
			break
		end
		if not eCard and not card:inherits("Armor") then eCard = card end
	end
	if not eCard then return end

	local suit = eCard:getSuitString()
	local number = eCard:getNumberString()
	local card_id = eCard:getEffectiveId()
	local card_str = ("savage_assault:fenghuo[%s:%s]=%d"):format(suit, number, card_id)
	local skillcard = sgs.Card_Parse(card_str)

    assert(skillcard)
    return skillcard
end

-- menshen
sgs.ai_skill_invoke.menshen = function(self, data)
   return #self.friends_noself > 0 and self.player:getHp() > 2
end
sgs.ai_skill_playerchosen.menshen = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and self:isWeak(player) then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and player:getLostHp()>0 then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and player:isKongcheng() and not player:hasSkill("kongcheng") then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and not self:hasSkills(sgs.masochism_skill, player) then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) then
			return player
		end
	end
end

-- fanji
sgs.ai_skill_invoke.fanji = function(self, data)
	return not self:isFriend(data:toPlayer()) and self:getCardsNum("Slash") > 0
end

local shentou_skill={}
shentou_skill.name="shentou"
table.insert(sgs.ai_skills,shentou_skill)
shentou_skill.getTurnUseCard=function(self,inclusive)
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	for _,acard in ipairs(cards)  do
		if (acard:getSuit() == sgs.Card_Club) and ((self:getUseValue(acard)<sgs.ai_use_value["Snatch"]) or inclusive) then
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
	local card_str = ("snatch:shentou[club:%s]=%d"):format(number, card_id)
	local  snatch= sgs.Card_Parse(card_str)

    assert(snatch)

    return snatch
end

-- tiemuzhen
sgs.ai_skill_invoke.qianglue = function(self, data)
	local effect = data:toSlashEffect()
	return not self:isFriend(effect.to) or (self:hasSkills(sgs.lose_equip_skill,effect.to) and not effect.to:getEquips():isEmpty())
end

-- huamulan
local yizhuang_skill={}
yizhuang_skill.name="yizhuang"
table.insert(sgs.ai_skills,yizhuang_skill)
yizhuang_skill.getTurnUseCard=function(self)
	local deather = false
	for _, player in sgs.qlist(self.room:getPlayers()) do
        if player:isDead() and player:getGeneral():isMale() then
		deather = true
		end
	end

    if not deather or self.player:hasUsed("YizhuangCard") then return end

    local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards)
	local yizhuang_cards = {}
	for index = #cards, 1, -1 do
		if self:getUseValue(cards[index]) >= 6 then break end
		if cards[index]:isBlack() or cards[index]:isRed() then
			if #yizhuang_cards == 0 or (#yizhuang_cards == 1 and cards[index] ~= sgs.Sanguosha:getCard(yizhuang_cards[1])) then
				table.insert(yizhuang_cards, cards[index]:getId())
				table.remove(cards, index)
			end
			if #yizhuang_cards >=2 then break end
		end
	end
	if #yizhuang_cards == 2 then return sgs.Card_Parse("@YizhuangCard=" .. table.concat(yizhuang_cards, "+")) end
end

sgs.ai_skill_use_func["YizhuangCard"]=function(card,use,self)
	 use.card = card
end

-- qlzz
-- lianpo
sgs.ai_skill_choice.kurou = function(self, choices)
	return "ziji"
end

--sanbanfu
local sanbanfu_skill={}
sanbanfu_skill.name="sanbanfu"
table.insert(sgs.ai_skills,sanbanfu_skill)
sanbanfu_skill.getTurnUseCard=function(self)
    if self:isWeak() or self.player:hasUsed("SanbanfuCard") or not self:slashIsAvailable() then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if card:inherits("Slash") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@SanbanfuCard=%d"):format(wastecards[1]:getId())
	local slash = sgs.Card_Parse(card_str)
	assert(slash)
	return slash
 end

sgs.ai_skill_use_func["SanbanfuCard"]=function(card,use,self)
	self:sort(self.enemies, "defense")
	local target_count=0

	for _, enemy in ipairs(self.enemies) do
		if (self.player:canSlash(enemy, not no_distance) or
			(use.isDummy and self.player:distanceTo(enemy)<=(self.predictedRange or self.player:getAttackRange())))
			and self:objectiveLevel(enemy)>3 and self:slashIsEffective(card, enemy)
			and self:isWeak(enemy)
			and not (enemy:isKongcheng() and enemy:hasSkill("kongcheng"))
			and enemy:getMark("@feigong2") <= 0
			and enemy:getMark("@yinju1") <= 0
			and enemy:getMark("@yinju2") <= 0 then
			use.card=card
			if use.to then
				use.to:append(enemy)
			end
			target_count=target_count+1
			if self.slash_targets<=target_count then return end
		end
	end

	for _, enemy in ipairs(self.enemies) do
		if (self.player:canSlash(enemy, not no_distance) or
			(use.isDummy and self.player:distanceTo(enemy)<=(self.predictedRange or self.player:getAttackRange())))
			and self:objectiveLevel(enemy)>3 and self:slashIsEffective(card, enemy)
			and enemy:isKongcheng()
			and not (enemy:isKongcheng() and enemy:hasSkill("kongcheng"))
			and enemy:getMark("@feigong2") <= 0
			and enemy:getMark("@yinju1") <= 0
			and enemy:getMark("@yinju2") <= 0 then
			use.card=card
			if use.to then
				use.to:append(enemy)
			end
			target_count=target_count+1
			if self.slash_targets<=target_count then return end
		end
	end

	for _, enemy in ipairs(self.enemies) do
		if (self.player:canSlash(enemy, not no_distance) or
			(use.isDummy and self.player:distanceTo(enemy)<=(self.predictedRange or self.player:getAttackRange())))
			and self:objectiveLevel(enemy)>3 and self:slashIsEffective(card, enemy)
			and not self:isEquip("EightDiagram", enemy) and not enemy:hasSkill("bazhen")
			and not (enemy:isKongcheng() and enemy:hasSkill("kongcheng"))
			and enemy:getMark("@feigong2") <= 0
			and enemy:getMark("@yinju1") <= 0
			and enemy:getMark("@yinju2") <= 0 then
			use.card=card
			if use.to then
				use.to:append(enemy)
			end
			target_count=target_count+1
			if self.slash_targets<=target_count then return end
		end
	end
end

sgs.ai_use_priority.SanbanfuCard = 3.3

function sgs.ai_cardneed.sanbanfu(to, card)
	if not to:containsTrick("indulgence") then
		return card:inherits("Slash")
	end
end

sgs.chengyaojin_keep_value =
{
	Peach = 6,
	Fuzhou = 6,
	Analeptic = 5.8,
	Jink = 5.7,
	XueSlash = 5.6,
	AnSlash = 5.4,
	FireSlash = 5.6,
	Slash = 5.4,
	ThunderSlash = 5.5,
	ExNihilo = 4.7
}

--lizicheng
sgs.ai_skill_invoke.lumang = function(self, data)
	local effect = data:toCardEffect()
	return self:isEnemy(effect.from) and not self.player:isKongcheng() and not self:isWeak()
end

-- lvzhi
sgs.ai_skill_invoke.zhensha = function(self, data)
	local dying = data:toDying()
	return self:isEnemy(dying.who) and (self:getCardsNum("Peach") > 0 or self:getCardsNum("Fuzhou") > 0)
end

-- xiaoqiao
sgs.ai_skill_invoke.tianxian = function(self, data)
	local player = self.room:getCurrent()
	local judges = player:getJudgingArea()
	if self.player:getHandcardNum() <= 1 and self.player:isWounded() then return end
	return (self:isFriend(player) and self:getCardsNum("Nullification") <= 0 and not judges:isEmpty() and not player:hasSkill("luoshen") and player:getPhase()~= sgs.Player_Play)
	or (self:isEnemy(player) and judges:isEmpty() and player:hasFlag("luoshen") and player:getPhase()~= sgs.Player_Play)
	or (self:isEnemy(player) and judges:isEmpty() and player:hasFlag("shuangxiong") and player:getPhase()~= sgs.Player_Play)
	or (self:isEnemy(player) and judges:isEmpty() and player:hasSkill("chexuan") and player:getPhase()~= sgs.Player_Play)
end

--luban
local guifu_skill={}
guifu_skill.name="guifu"
table.insert(sgs.ai_skills,guifu_skill)
guifu_skill.getTurnUseCard=function(self)
	if not self.player:hasUsed("GuifuCard") then
		return sgs.Card_Parse("@GuifuCard=.")
	end
end

sgs.ai_skill_use_func["GuifuCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if self:getCardsNum(".", enemy, "e") >= 1 and not self:hasSkills(sgs.lose_equip_skill, enemy) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
for _, friend in ipairs(self.friends_noself) do
	if (self:getCardsNum(".", friend, "e") > 0 and self:hasSkills(sgs.lose_equip_skill, friend))
	or (self:isEquip("Jinlinjia", friend) and friend:isWounded()) or self:isEquip("Qiankundai", friend) then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
end

-- panan
local zirong_skill={}
zirong_skill.name="zirong"
table.insert(sgs.ai_skills,zirong_skill)
zirong_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end
    if self.player:hasUsed("ZirongCard") then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@ZirongCard=%d"):format(cards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["ZirongCard"]=function(card,use,self)
	for _, friend in ipairs(self.friends_noself) do
	if friend:getGeneral():isFemale() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
end

-- bhzz
-- sunwu
local shipo_skill={}
shipo_skill.name="shipo"
table.insert(sgs.ai_skills,shipo_skill)
shipo_skill.getTurnUseCard=function(self)
    if self.player:hasUsed("ShipoCard") then return end
    local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards)
	local kanpo_cards = {}
	for index = #cards, 1, -1 do
		if self:getUseValue(cards[index]) >= 6 then break end
		if cards[index]:isBlack() or cards[index]:isRed() then
			if #kanpo_cards == 0 or (#kanpo_cards == 1 and cards[index]:getSuit() ~= sgs.Sanguosha:getCard(kanpo_cards[1]):getSuit()) then
				table.insert(kanpo_cards, cards[index]:getId())
				table.remove(cards, index)
			end
			if #kanpo_cards >=2 then break end
		end
	end
	if #kanpo_cards == 2 then return sgs.Card_Parse("@ShipoCard=" .. table.concat(kanpo_cards, "+")) end
end

sgs.ai_skill_use_func["ShipoCard"]=function(card,use,self)
for _, friend in ipairs(self.friends_noself) do
	if self.player:getHp() > friend:getHp() and self:isWeak(friend) then
			use.card = card
			if use.to then use.to:append(friend) end
			return
	   end
	end
for _, friend in ipairs(self.friends_noself) do
	if self.player:getHp() > friend:getHp() and friend:getLostHp()>0 then
			use.card = card
			if use.to then use.to:append(friend) end
			return
	   end
	end
for _, enemy in ipairs(self.enemies) do
	if (self.player:getHp() < enemy:getHp() and not self:hasSkills(sgs.masochism_skill, enemy))
	or (self.player:getHp() < enemy:getHp() and enemy:getHp()-self.player:getHp() >= 2) then
			use.card = card
			if use.to then use.to:append(enemy) end
			return
		end
	end
end

sgs.ai_use_value.ShipoCard = 8.6
sgs.ai_use_priority.ShipoCard = 6.8
sgs.dynamic_value.benefit.ShipoCard = true

-- kangxi
sgs.ai_skill_invoke.mingcha = true

-- liuche
sgs.ai_skill_invoke.ruide = function(self, data)
	local player = self.room:getCurrent()
	return self ~= player:getNextAlive()
end

sgs.ai_skill_askforag.ruide = function(self, card_ids)
	local who = self.room:getCurrent()
	local cards = {}
	for _, card_id in ipairs(card_ids) do
		table.insert(cards, sgs.Sanguosha:getCard(card_id))
	end

		self:sortByUseValue(cards, true)

	return cards[1]:getEffectiveId()
end

--mozi
local jianai_skill={}
jianai_skill.name="jianai"
table.insert(sgs.ai_skills,jianai_skill)
jianai_skill.getTurnUseCard=function(self,inclusive)
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	for _,acard in ipairs(cards)  do
		if acard:inherits("Peach") then
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
	local card_str = ("god_salvation:jianai[%s:%s]=%d"):format(suit, number, card_id)
	local  god= sgs.Card_Parse(card_str)

    assert(god)

    return god
end

local feigong_skill={}
feigong_skill.name="feigong"
table.insert(sgs.ai_skills,feigong_skill)
feigong_skill.getTurnUseCard=function(self)
	if not self.player:hasUsed("FeigongCard") then
		return sgs.Card_Parse("@FeigongCard=.")
	end
end

sgs.ai_skill_use_func["FeigongCard"]=function(card,use,self)
for _, friend in ipairs(self.friends_noself) do
	if  (self:isWeak(friend) and not friend:isKongcheng())
	or (self:getCardsNum(".", friend, "h") == 1 and friend:hasSkill("lianying"))
	or (self:getCardsNum(".", friend, "h") == 1 and friend:hasSkill("kongcheng"))
	or (friend:isWounded() and not friend:isKongcheng())
	then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
end

sgs.ai_skill_choice.feigong = function(self, choices)
	return "choupai"
end

--miaobi
local miaobi_skill={}
miaobi_skill.name="miaobi"
table.insert(sgs.ai_skills,miaobi_skill)
miaobi_skill.getTurnUseCard=function(self,inclusive)
    if self.player:getMark("@miaobi") > 0 then return end
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	for _,acard in ipairs(cards)  do
		if (acard:getSuit() == sgs.Card_Heart) and ((self:getUseValue(acard)<sgs.ai_use_value["AmazingGrace"]) or inclusive) then
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
	local card_str = ("amazing_grace:miaobi[heart:%s]=%d"):format(number, card_id)
	local  amazing= sgs.Card_Parse(card_str)

    assert(amazing)

    return amazing
end

-- zqzz
--jujia
jujia_skill={}
jujia_skill.name="jujia"
table.insert(sgs.ai_skills,jujia_skill)
jujia_skill.getTurnUseCard=function(self)
if self.player:isKongcheng() then return end
	if not self.player:hasUsed("JujiaCard") then
		return sgs.Card_Parse("@JujiaCard=.")
	end
end

sgs.ai_skill_use_func["JujiaCard"] = function(card, use, self)
	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)
	self:sortByUseValue(cards,true)

	local target
	for _, friend in ipairs(self.friends_noself) do
		if ((self:getCardsNum(".", friend, "h") == 1 and friend:hasSkill("lianying"))
	    or (self:getCardsNum(".", friend, "h") == 1 and friend:hasSkill("kongcheng")))
		and self.player:distanceTo(friend) <= 2
		and not friend:isKongcheng() then
			for _, card in ipairs(cards) do
				if not card:inherits("Peach") and self.player:getHandcardNum() > 1 then
					use.card = sgs.Card_Parse("@JujiaCard=" .. card:getEffectiveId())
					target = friend
					break
				end
			end
		end
		if target then break end
	end
	if not target then
		for _, enemy in ipairs(self.enemies) do
			if not enemy:isKongcheng()
			and self.player:distanceTo(enemy) <= 2
			and not (self:getCardsNum(".", enemy, "h") == 1 and enemy:hasSkill("lianying"))
			and not (self:getCardsNum(".", enemy, "h") == 1 and enemy:hasSkill("kongcheng"))
			then
				for _, card in ipairs(cards)do
					if not card:inherits("Peach")  and self.player:getHandcardNum() > 1 then
						use.card = sgs.Card_Parse("@JujiaCard=" .. card:getEffectiveId())
						target = enemy
						break
					end
				end
			end
			if target then break end
		end
	end

	if target then
		self.room:setPlayerFlag(target, "jujia_target")
		if use.to then
			use.to:append(target)
		end
	end
end

sgs.ai_use_priority.JujiaCard = 5

sgs.ai_skill_playerchosen.jujia = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isWeak(player)  and self:isFriend(player) and not player:hasFlag("jujia_target") then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if player:isWounded() and self:isFriend(player) and not player:hasFlag("jujia_target") then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and not player:hasFlag("jujia_target") then
			return player
		end
	end
end

-- bushi
sgs.ai_skill_invoke.bushi = true

sgs.ai_skill_playerchosen.bushi = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and self:isWeak(player) then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and player:getLostHp()>0 then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) then
			return player
		end
	end
end

sgs.ai_skill_askforag.bushi = function(self, card_ids)
	local cards = {}
	for _, card_id in ipairs(card_ids) do
		table.insert(cards, sgs.Sanguosha:getCard(card_id))
	end

		self:sortByUseValue(cards, true)

    local card, friend = self:getCardNeedPlayer(cards)
	if card and friend then
	return cards[card]:getEffectiveId()
    else
	return cards[1]:getEffectiveId()
	end
end

-- taiji
sgs.ai_skill_invoke.taiji = function(self, data)
	for _, enemy in ipairs(self.enemies) do
		if self.player:canSlash(enemy, true) and self:getCardsNum("Slash") > 0 and not (enemy:hasSkill("kongcheng") and enemy:isKongcheng()) then return true end
	end
end

sgs.ai_skill_playerchosen.taiji = sgs.ai_skill_playerchosen.zero_card_as_slash

-- xwzz
-- wangzhaojun
local luoyan_skill={}
luoyan_skill.name="luoyan"
table.insert(sgs.ai_skills,luoyan_skill)
luoyan_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end
    if self.player:hasUsed("LuoyanCard") then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@LuoyanCard=%d"):format(cards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["LuoyanCard"]=function(card,use,self)
	for _, friend in ipairs(self.friends_noself) do
	 if friend:getGeneral():isMale() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
end

--sheji
local sheji_skill={}
sheji_skill.name="sheji"
table.insert(sgs.ai_skills,sheji_skill)
sheji_skill.getTurnUseCard=function(self)
    if self.player:isKongcheng() then return end
	if not self.player:hasUsed("ShejiCard") then
		return sgs.Card_Parse("@ShejiCard=.")
	end
end

sgs.ai_skill_use_func["ShejiCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if not enemy:isKongcheng() and self.player:inMyAttackRange(enemy) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_use_value.ShejiCard = 8.3
sgs.ai_use_priority.ShejiCard = 6.5
sgs.ai_card_intention.ShejiCard = 70
sgs.dynamic_value.benefit.ShejiCard = true

-- fubing
local fuji_skill={}
fuji_skill.name="fuji"
table.insert(sgs.ai_skills,fuji_skill)
fuji_skill.getTurnUseCard=function(self)
	local cards = self.player:getHandcards()
	local basics = {}
	for _, card in sgs.qlist(cards) do
		if card:getTypeId() == sgs.Card_Basic then
			table.insert(basics, card)
		end
	end

	if #basics == 0 or self.player:hasUsed("FujiCard") then return end
	self:sortByUseValue(basics, true)

	local card_str = ("@FujiCard=%d"):format(basics[1]:getEffectiveId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["FujiCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	end
end

-- yinqiang
sgs.ai_skill_invoke.yinqiang = function(self, data)
	local damage = data:toDamage()
	return self:isEnemy(damage.to)
end

-- congzhen
sgs.ai_skill_invoke.congzhen = function(self, data)
	local effect = data:toSlashEffect()
	return self:isEnemy(effect.to)
end

--yunchou
sgs.ai_skill_invoke.yunchou = function(self, data)
	local effect = data:toCardEffect()
	if effect.card:inherits("GodSalvation") or effect.card:inherits("AmazingGrace") then return end
	return self:isEnemy(effect.from) or effect.card:inherits("AOE")
end

-- kaixian
sgs.ai_skill_invoke.kaixian = true

sgs.ai_view_as.shentan = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card_place ~= sgs.Player_Equip then
		if card:isBlack() or card:isRed() then
			return ("nullification:shentan[%s:%s]=%d"):format(suit, number, card_id)
		end
	end
end

-- sp_zhaoyun
local xchongfeng_skill={}
xchongfeng_skill.name="xchongfeng"
table.insert(sgs.ai_skills,xchongfeng_skill)
xchongfeng_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end
    local cards = self.player:getHandcards()
	local basics = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Slash") and not card:inherits("Peach") then
			table.insert(basics, card)
		end
	end

	if #basics == 0 or self.player:hasUsed("XchongfengCard") then return end
	self:sortByUseValue(basics, true)

	local card_str = ("@XchongfengCard=%d"):format(basics[1]:getEffectiveId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["XchongfengCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if self.player:distanceTo(enemy) > 1 and self.player:getMark("SlashCount") < 1 and self:getCardsNum("Slash") > 0 then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
		end
	end
end

sgs.ai_card_intention.XchongfengCard = 30
sgs.dynamic_value.control_card.XchongfengCard = true
sgs.ai_use_priority.XchongfengCard = 8

-- sp_lvbu
--xwushuang
local xwushuang_skill={}
xwushuang_skill.name="xwushuang"
table.insert(sgs.ai_skills,xwushuang_skill)
xwushuang_skill.getTurnUseCard=function(self)
    if not self:slashIsAvailable() then return end

	local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards)
	local black_cards = {}
	for index = #cards, 1, -1 do
		if self:getUseValue(cards[index]) >= 6 then break end
		if cards[index]:isBlack() or cards[index]:inherits("Slash") then
			if #black_cards == 0 or (#black_cards == 1 and cards[index] ~= sgs.Sanguosha:getCard(black_cards[1])) then
				table.insert(black_cards, cards[index]:getId())
				table.remove(cards, index)
			end
			if #black_cards >=2 then break end
		end
	end
	if #black_cards == 2 then return sgs.Card_Parse("@XwushuangCard=" .. table.concat(black_cards, "+")) end
end

sgs.ai_skill_use_func["XwushuangCard"]=function(card,use,self)
	self:sort(self.enemies, "defense")
	local target_count=0

	for _, enemy in ipairs(self.enemies) do
		if (self.player:canSlash(enemy, not no_distance) or
			(use.isDummy and self.player:distanceTo(enemy)<=(self.predictedRange or self.player:getAttackRange())))
			and self:objectiveLevel(enemy)>3 and self:slashIsEffective(card, enemy)
			and self:isWeak(enemy)
			and not (enemy:isKongcheng() and enemy:hasSkill("kongcheng"))
			and enemy:getMark("@feigong2") <= 0
			and enemy:getMark("@yinju1") <= 0
			and enemy:getMark("@yinju2") <= 0 then
			use.card=card
			if use.to then
				use.to:append(enemy)
			end
			target_count=target_count+1
			if self.slash_targets<=target_count then return end
		end
	end

	for _, enemy in ipairs(self.enemies) do
		if (self.player:canSlash(enemy, not no_distance) or
			(use.isDummy and self.player:distanceTo(enemy)<=(self.predictedRange or self.player:getAttackRange())))
			and self:objectiveLevel(enemy)>3 and self:slashIsEffective(card, enemy)
			and enemy:isKongcheng()
			and not (enemy:isKongcheng() and enemy:hasSkill("kongcheng"))
			and enemy:getMark("@feigong2") <= 0
			and enemy:getMark("@yinju1") <= 0
			and enemy:getMark("@yinju2") <= 0 then
			use.card=card
			if use.to then
				use.to:append(enemy)
			end
			target_count=target_count+1
			if self.slash_targets<=target_count then return end
		end
	end

	for _, enemy in ipairs(self.enemies) do
		if (self.player:canSlash(enemy, not no_distance) or
			(use.isDummy and self.player:distanceTo(enemy)<=(self.predictedRange or self.player:getAttackRange())))
			and self:objectiveLevel(enemy)>3 and self:slashIsEffective(card, enemy)
			and not self:isEquip("EightDiagram", enemy) and not enemy:hasSkill("bazhen")
			and not (enemy:isKongcheng() and enemy:hasSkill("kongcheng"))
			and enemy:getMark("@feigong2") <= 0
			and enemy:getMark("@yinju1") <= 0
			and enemy:getMark("@yinju2") <= 0 then
			use.card=card
			if use.to then
				use.to:append(enemy)
			end
			target_count=target_count+1
			if self.slash_targets<=target_count then return end
		end
	end
end

sgs.ai_use_priority.XwushuangCard = 2.3

sgs.ai_view_as.xxiaoyong = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card:isBlack() and not card:inherits("EquipCard") then
		return ("slash:xxiaoyong[%s:%s]=%d"):format(suit, number, card_id)
	end
end

local xxiaoyong_skill={}
xxiaoyong_skill.name="xxiaoyong"
table.insert(sgs.ai_skills,xxiaoyong_skill)
xxiaoyong_skill.getTurnUseCard=function(self,inclusive)
	local cards = self.player:getCards("h")
	cards=sgs.QList2Table(cards)

	local black_card

	self:sortByUseValue(cards,true)

	for _,card in ipairs(cards) do
		if card:isBlack() and not card:inherits("Slash") and not card:inherits("EquipCard") and ((self:getUseValue(card)<sgs.ai_use_value.Slash) or inclusive) then
			black_card = card
			break
		end
	end

	if black_card then
		local suit = black_card:getSuitString()
		local number = black_card:getNumberString()
		local card_id = black_card:getEffectiveId()
		local card_str = ("slash:xxiaoyong[%s:%s]=%d"):format(suit, number, card_id)
		local slash = sgs.Card_Parse(card_str)

		assert(slash)

		return slash
	end
end

-- cardneed
sgs.shiqian_suit_value =
{
	club = 3.9
}

sgs.daqiao_suit_value =
{
	diamond = 3.9
}

-- chaofeng
sgs.ai_chaofeng.daqiao = 1
sgs.ai_chaofeng.shiqian = 2
sgs.ai_chaofeng.lvzhi = -2
sgs.ai_chaofeng.direnjie = 3
sgs.ai_chaofeng.hun_sunwu = -3
sgs.ai_chaofeng.hun_diaochan = -3
sgs.ai_chaofeng.hun_linchong = 3
sgs.ai_chaofeng.yuchigong = 5
sgs.ai_chaofeng.huoqubing = 3
sgs.ai_chaofeng.muguiying = 1
sgs.ai_chaofeng.huamulan = 1
sgs.ai_chaofeng.fanzeng = 3
sgs.ai_chaofeng.xueli = 1
sgs.ai_chaofeng.qinqiong = 1
sgs.ai_chaofeng.luzhishen = -2
sgs.ai_chaofeng.liubang = 1
sgs.ai_chaofeng.luban = -1
sgs.ai_chaofeng.shenwanshan = 4
sgs.ai_chaofeng.sp_zhaoyun = 1
sgs.ai_chaofeng.sp_lvbu = 1
sgs.ai_chaofeng.lishishi = -1
sgs.ai_chaofeng.xyuji = -4
