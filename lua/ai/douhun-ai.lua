-- yxs douhun
-- card
sgs.weapon_range.Fangtianji = 4
sgs.weapon_range.Kongqueling = 4
sgs.weapon_range.XueSword = 2
sgs.ai_use_priority.Kongqueling = 2.645
sgs.ai_use_priority.XueSword = 2.69
sgs.ai_use_priority.Fangtianji = 2.65
sgs.ai_use_priority.Jinlinjia = 0.9
sgs.ai_use_priority.Huxinjing = 0.6
sgs.ai_use_priority.Qiankundai = 0.9

sgs.ai_skill_invoke.xue_sword = true

sgs.ai_skill_invoke.fangtianji = true

sgs.ai_skill_invoke.fenpei = true

sgs.ai_skill_invoke.huxinjing = function(self, data)
	local damage = data:toDamage()
	return not (self:isFriend(damage.from) and self.player:hasSkill("yiji"))
end

-- fuzhou
function SmartAI:useCardFuzhou(card, use)
    if self.player:isWounded() then
			use.card=card
			if use.to then use.to:append(self.player) end
			return
	end
end

sgs.ai_skill_choice.fuzhou = function(self, choices)
	return "peach"
end

sgs.ai_use_value.Fuzhou = 6
sgs.ai_keep_value.Fuzhou = 5
sgs.ai_use_priority.Fuzhou = 2.5

function SmartAI:useCardAnSlash(...)
	self:useCardSlash(...)
end

sgs.ai_card_intention.AnSlash = sgs.ai_card_intention.Slash

sgs.ai_use_value.AnSlash = 4.6
sgs.ai_keep_value.AnSlash = 2.3
sgs.ai_use_priority.AnSlash = 2.4

function SmartAI:useCardXueSlash(...)
	self:useCardSlash(...)
end

sgs.ai_card_intention.XueSlash = sgs.ai_card_intention.Slash

sgs.ai_use_value.XueSlash = 4.8
sgs.ai_keep_value.XueSlash = 2.5
sgs.ai_use_priority.XueSlash = 3.1

sgs.ai_skill_invoke.shewoqishui = function(self, data)
    local player = self.room:getCurrent()
	return  self:isEnemy(player)  and not self:isWeak() and not self.player:hasSkill("jiaozhen") and not self.player:isLord()
end

function SmartAI:useCardGeanguanhuo(card, use)
	if self.player:hasSkill("wuyan") then return end

	if self.player:hasFlag("geanguanhuo") then return end

	for _, enemy in ipairs(self.enemies) do
		if not self.room:isProhibited(self.player, enemy, card)
			and self:hasTrickEffective(card, enemy)
			and not enemy:isKongcheng()
			and not enemy:hasSkill("diehun") then

			for _, enemy2 in ipairs(self.enemies) do
				if not self.room:isProhibited(self.player, enemy2, card)
			and self:hasTrickEffective(card, enemy2)
			and not enemy2:isKongcheng()
			and enemy2 ~= enemy
			and not enemy2:hasSkill("diehun") then
						use.card = card
						if use.to then use.to:append(enemy) end
						if use.to then use.to:append(enemy2) end
						return
				end
			end
		end
	end
	for _, friend in ipairs(self.friends) do
		if not self.room:isProhibited(self.player, friend, card)
			and self:hasTrickEffective(card, friend)
			and not friend:isKongcheng() then

			for _, enemy3 in ipairs(self.enemies) do
				if not self.room:isProhibited(self.player, enemy3, card)
			and self:hasTrickEffective(card, enemy3)
			and not enemy3:isKongcheng()
			and not enemy3:hasSkill("diehun")
			and not self:hasSkills(sgs.masochism_skill, enemy3)
			and self:getMaxCard(friend):getNumber() > self:getMaxCard(enemy3):getNumber() then
						use.card = card
						if use.to then use.to:append(enemy3) end
						if use.to then use.to:append(friend) end
						return
				end
			end
		end
	end
end

sgs.ai_cardshow.geanguanhuo = function(self, requestor)
	local cards = self.player:getHandcards()
	local cards2 = requestor:getHandcards()
	local result
	local point

	if not self:isEnemy(requestor) and not self:isFriend(requestor) then
	for _, card in sgs.qlist(cards) do
			result = self:getMaxCard()
			return result
		end
    end

	if self:isEnemy(requestor) then
	for _, card in sgs.qlist(cards) do
			result = self:getMaxCard()
			return result
		end
    end

	if self:isFriend(requestor) then
	for _, card2 in sgs.qlist(cards2) do
		    if card2:getNumber() <= 13 then
			point = card2
		end
	  end
end
	  local point_num = point:getNumber()
	  for _, card3 in sgs.qlist(cards) do
		    if card3:getNumber() == point_num then
			result = card3
			return result
			elseif self.player:getHp() < requestor:getHp() then
			result = self:getMaxCard()
			return result
			else
			result = card3:getNumber() ~= point_num
   end
end
	return result
end

sgs.ai_use_value.Geanguanhuo= 8.8
sgs.ai_use_priority.Geanguanhuo = 7

sgs.ai_card_intention.Geanguanhuo = function(card, from, to)
	if sgs.evaluateRoleTrends(to[1]) == sgs.evaluateRoleTrends(to[2]) then
		sgs.updateIntentions(from, to, 40)
	end
end

sgs.dynamic_value.control_card.Geanguanhuo = true

function SmartAI:useCardToulianghuanzhu(card, use)
	if self.player:hasSkill("wuyan") then return end
	local player1
	local player2

	for _, friend in ipairs(self.friends) do
		if not self.room:isProhibited(self.player, friend, card)
			and self:hasTrickEffective(card, friend)
			and not friend:isKongcheng() then
			player1 = friend
  end

			for _, enemy in ipairs(self.enemies) do
				if not self.room:isProhibited(self.player, enemy, card)
			and self:hasTrickEffective(card, enemy)
			and enemy :getHandcardNum() >= 2
			and not (enemy:getHandcardNum() == 2 and enemy:hasSkill("lianying"))
			and not enemy:hasSkill("diehun") then
			        player2 = enemy
			end

			if player1 and player2 then
			    use.card = card
				if use.to then use.to:append(player1) end
				if use.to then use.to:append(player2) end
				return
           end
		end
	end
end

sgs.ai_cardshow.toulianghuanzhu = function(self, requestor)
	local cards = self.player:getHandcards()
	local result

	for _, card in sgs.qlist(cards) do
	if card:inherits("Shewoqishui") then
			result = card
			return result
		end
    end

	for _, card in sgs.qlist(cards) do
	if card:inherits("Lightning") then
			result = card
			return result
		end
    end

	for _, card in sgs.qlist(cards) do
	if card:inherits("AmazingArace") then
			result = card
			return result
		end
    end

	for _, card in sgs.qlist(cards) do
	if card:inherits("GodSalvation") then
			result = card
			return result
		end
    end

	for _, card in sgs.qlist(cards) do
	if card:inherits("Analeptic") then
			result = card
			return result
		end
    end

	for _, card in sgs.qlist(cards) do
	if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo")  then
			result = card
			return result
		end
    end

	for _, card in sgs.qlist(cards) do
	    if card then
			result = card
			return result
		end
   end

	return result
end

sgs.ai_use_value.Toulianghuanzhu = 9.5
sgs.ai_use_priority.Toulianghuanzhu = 9
sgs.dynamic_value.control_card.Toulianghuanzhu = true

-- skill
sgs.ai_skill_invoke.fengyi = function(self, data)
	return not self:isFriend(data:toPlayer())
end

function sgs.ai_skill_invoke.wange(self, data)
	for _, enemy in ipairs(self.enemies) do
				if enemy :getHandcardNum() >= 2  then
				return self:isWeak() and self.player:getLostHp() >= 1
		end
	end
end

sgs.ai_skill_playerchosen.wange = function(self, targets)
	for _, enemy in ipairs(self.enemies) do
	if (self.player:getLostHp() == 1 and enemy :getHandcardNum() >= 1)
	or (self.player:getLostHp() >1 and enemy :getHandcardNum() >= 2) then
		 return enemy
	end
  end
end

sgs.ai_skill_invoke.kuidao= true

sgs.ai_skill_playerchosen.kuidao1 = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) then
			return player
		end
	end
end

sgs.ai_skill_playerchosen.kuidao2 = function(self, targets)
	for _, enemy in ipairs(self.enemies) do
	if not enemy:isNude() then
		 return enemy
	end
  end
end

sgs.ai_skill_playerchosen.kuidao3 = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) then
			return player
		end
	end
end

--zhijun
local zhijun_skill={}
zhijun_skill.name="zhijun"
table.insert(sgs.ai_skills,zhijun_skill)
zhijun_skill.getTurnUseCard=function(self)
    if self.player:isKongcheng() then return end
    if self.player:hasUsed("ZhijunCard") then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@ZhijunCard=%d"):format(cards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["ZhijunCard"]=function(card,use,self)
	for _, friend in ipairs(self.friends) do
	if self:isWeak(friend) then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
	for _, friend in ipairs(self.friends) do
	if friend:getLostHp()>0 then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
	for _, friend in ipairs(self.friends) do
			use.card=card
			if use.to then use.to:append(friend) end
			return
	  end
end

sgs.ai_skill_invoke.zhulu= true

local xinchujia_skill={}
xinchujia_skill.name="xinchujia"
table.insert(sgs.ai_skills,xinchujia_skill)
xinchujia_skill.getTurnUseCard=function(self)
	local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards)
	local chujia_cards = {}
	for index = #cards, 1, -1 do
		if self:getUseValue(cards[index]) >= 6 then break end
		if cards[index]:isBlack() or cards[index]:isRed() then
			if #chujia_cards == 0 or (#chujia_cards == 1 and cards[index]:getSuit() == sgs.Sanguosha:getCard(chujia_cards[1]):getSuit()) then
				table.insert(chujia_cards, cards[index]:getId())
				table.remove(cards, index)
			end
			if #chujia_cards >=2 then break end
		end
	end
	if #chujia_cards == 2 then return sgs.Card_Parse("@XinchujiaCard=" .. table.concat(chujia_cards, "+")) end
end

sgs.ai_skill_use_func["XinchujiaCard"]=function(card,use,self)
for _, friend in ipairs(self.friends) do
	if self:isWeak(friend) or (friend:isWounded() and friend:getLostHp() >= 2) or (friend:isWounded() and self.player:getHandcardNum() > self.player:getHp()) then
			use.card = card
			if use.to then use.to:append(friend) end
			return
		end
	end
end

--zhijie
local zhijie_skill={}
zhijie_skill.name="zhijie"
table.insert(sgs.ai_skills,zhijie_skill)
zhijie_skill.getTurnUseCard=function(self,inclusive)
    if self.player:getMark("@zhijie") > 0 then return end
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	for _,acard in ipairs(cards)  do
		if (acard:getSuit() == sgs.Card_Heart) and ((self:getUseValue(acard)<sgs.ai_use_value["ExNihilo"]) or inclusive) then
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
	local card_str = ("ex_nihilo:zhijie[heart:%s]=%d"):format(number, card_id)
	local  exnihilo= sgs.Card_Parse(card_str)

    assert(exnihilo)

    return exnihilo
end

--yuxian
local yuxian_skill={}
yuxian_skill.name="yuxian"
table.insert(sgs.ai_skills,yuxian_skill)
yuxian_skill.getTurnUseCard=function(self)
    if self.player:isKongcheng() then return end
	if self.player:getHandcardNum() == 1 then return end
    if self.player:hasUsed("YuxianCard") then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@YuxianCard=%d"):format(cards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["YuxianCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if enemy:getJudgingArea():isEmpty() and self.player:getMark("SlashCount") < 1 and self:getCardsNum(".", enemy, "e") >= 1 then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_skill_invoke.nichang = function(self, data)
	return (self:isWeak() or self.player:getHandcardNum() <= 2) and not self.player:isKongcheng()
end

--zhangfei
-- xintiaoxin
sgs.ai_skill_invoke.xintiaoxin = true

local xintiaoxin_skill={}
xintiaoxin_skill.name="xintiaoxin"
table.insert(sgs.ai_skills,xintiaoxin_skill)
xintiaoxin_skill.getTurnUseCard=function(self)
	if self.player:getMark("xintiaoxin") <= 0 or not self:slashIsAvailable() then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@XintiaoxinCard=%d"):format(wastecards[1]:getId())
	local slash = sgs.Card_Parse(card_str)
	assert(slash)
	return slash
end

sgs.ai_skill_use_func.XintiaoxinCard=function(card,use,self)
	self:sort(self.enemies, "defense")
	local target_count=0

	for _, enemy in ipairs(self.enemies) do
		if self:objectiveLevel(enemy)>3 and self:slashIsEffective(card, enemy)
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

sgs.ai_skill_invoke.nuhe = function(self, data)
	local effect = data:toSlashEffect()
	return not self:isFriend(effect.to)
end

-- liubang
local renwang_skill={}
renwang_skill.name="renwang"
table.insert(sgs.ai_skills,renwang_skill)
renwang_skill.getTurnUseCard=function(self)
    if self.player:hasUsed("RenwangCard") then return end

    local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards)
	local renwang_cards = {}
	for index = #cards, 1, -1 do
		if self:getUseValue(cards[index]) >= 6 then break end
		if cards[index]:isBlack() or cards[index]:isRed() then
			if #renwang_cards == 0 or (#renwang_cards == 1 and cards[index] ~= sgs.Sanguosha:getCard(renwang_cards[1])) then
				table.insert(renwang_cards, cards[index]:getId())
				table.remove(cards, index)
			end
			if #renwang_cards >=2 then break end
		end
	end
	if #renwang_cards == 2 then return sgs.Card_Parse("@RenwangCard=" .. table.concat(renwang_cards, "+")) end
end

sgs.ai_skill_use_func["RenwangCard"]=function(card,use,self)
	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
	if player:getHandcardNum() >= 6 and player:getHandcardNum() > self.player:getHandcardNum()-2 then
			use.card=card
			if use.to then use.to:append(player) end
			return
	   end
	end
	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
	if player:getHandcardNum() >= 5 and player:getHandcardNum() > self.player:getHandcardNum()-2 then
			use.card=card
			if use.to then use.to:append(player) end
			return
	   end
	end
	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
	if player:getHandcardNum() >= 4 and player:getHandcardNum() > self.player:getHandcardNum()-2 then
			use.card=card
			if use.to then use.to:append(player) end
			return
	   end
	end
	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
	if player:getHandcardNum() >= 3 and player:getHandcardNum() > self.player:getHandcardNum()-2 then
			use.card=card
			if use.to then use.to:append(player) end
			return
	   end
	end
	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
	if player:getHandcardNum() >= 2 and player:getHandcardNum() > self.player:getHandcardNum()-2 then
			use.card=card
			if use.to then use.to:append(player) end
			return
	   end
	end
end

sgs.ai_skill_invoke.xinshiwei = function(self, data)
	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
	if player:isKongcheng() and player:getMark("shiweiuse")>0 then
	return not self:isFriend(player)
end
end
end

-- mozi
sgs.ai_skill_cardask["@enyuan"] = function(self)
	local cards = self.player:getHandcards()
	for _, card in sgs.qlist(cards) do
		if card:getSuit() == sgs.Card_Heart and not (card:inherits("Peach") or card:inherits("ExNihilo")) then
			return card:getEffectiveId()
		end
	end
	return "."
end

function sgs.ai_slash_prohibit.enyuan(self)
	if self:isWeak() then return true end
end

-- jieyong
local jieyong_skill={}
jieyong_skill.name = "jieyong"
table.insert(sgs.ai_skills, jieyong_skill)
jieyong_skill.getTurnUseCard = function(self)
	if self.player:hasUsed("JieyongCard") then return end
	local cards = self.player:getHandcards()
	local heartcards = {}
	for _, card in sgs.qlist(cards) do
		if card:getSuit() == sgs.Card_Heart then
			table.insert(heartcards, card)
		end
	end

	if #heartcards == 0 then return end
	local aoename = "savage_assault|archery_attack"
	local aoenames = aoename:split("|")
	local aoe
	local i
	local good, bad = 0, 0
	local jieyongtrick = "savage_assault|archery_attack|ex_nihilo|god_salvation"
	local jieyongtricks = jieyongtrick:split("|")
	for i=1, #jieyongtricks do
		local forbiden = jieyongtricks[i]
		forbid = sgs.Sanguosha:cloneCard(forbiden, sgs.Card_NoSuit, 0)
		if self.player:isLocked(forbid) then return end
	end
	for _, friend in ipairs(self.friends) do
		if friend:isWounded() then
			good = good + 10/(friend:getHp())
			if friend:isLord() then good = good + 10/(friend:getHp()) end
		end
	end
	for _, enemy in ipairs(self.enemies) do
		if enemy:isWounded() then
			bad = bad + 10/(enemy:getHp())
			if enemy:isLord() then
				bad = bad + 10/(enemy:getHp())
			end
		end
	end
	local card = -1
	self:sortByUseValue(heartcards, true)
	card = heartcards[1]:getEffectiveId()

	if card < 0 then return end
	for i=1, #aoenames do
		local newjieyong = aoenames[i]
		aoe = sgs.Sanguosha:cloneCard(newjieyong, sgs.Card_NoSuit, 0)
		if self:getAoeValue(aoe) > -5 then
			local parsed_card=sgs.Card_Parse("@JieyongCard=" .. card .. ":" .. newjieyong)
			return parsed_card
		end
	end
	if good > bad then
		local parsed_card = sgs.Card_Parse("@JieyongCard=" .. card .. ":god_salvation")
		return parsed_card
	end
	if self:getCardsNum("Jink") == 0 and self:getCardsNum("Peach") == 0 then
		local parsed_card = sgs.Card_Parse("@JieyongCard=" .. card .. ":ex_nihilo")
		return parsed_card
	end
end
sgs.ai_skill_use_func["JieyongCard"] = function(card, use, self)
	local userstring=card:toString()
	userstring=(userstring:split(":"))[2]
	local jieyongcard=sgs.Sanguosha:cloneCard(userstring, card:getSuit(), card:getNumber())
	self:useTrickCard(jieyongcard,use)
	if not use.card then return end
	use.card=card
end

-- xiangyu
sgs.ai_skill_choice.hongmen = function(self, choices)
	return self.hongmenchoice
end

sgs.ai_skill_use["@@hongmen"] = function(self, prompt)
	if #self.friends > 1 then
		for _, friend in ipairs(self.friends_noself) do
			if self:hasSkills(sgs.lose_equip_skill, friend) then
				self.hongmen = friend
				self.hongmenchoice = "hongmen1"
				break
			end
		end
		self:sort(self.friends_noself, "chaofeng")
		for _, afriend in ipairs(self.friends_noself) do
			if not afriend:hasSkill("manjuan") then self.hongmen = afriend end
		end
		if self.hongmen and not self.hongmenchoice then self.hongmenchoice = "hongmen1" end
	else
		self:sort(self.enemies, "handcard")
		for index = #self.enemies, 1, -1 do
			local enemy = self.enemies[index]
			if not self:hasSkills(sgs.lose_equip_skill, enemy) or not enemy:isNude() then
				self.hongmen = enemy
				self.hongmenchoice = "hongmen2"
				break
			end
		end
	end

	if self.hongmen then
		return "@HongmenCard=.->" .. self.hongmen:objectName()
	else
		return "."
	end
end

guixiong_skill={}
guixiong_skill.name="guixiong"
table.insert(sgs.ai_skills,guixiong_skill)
guixiong_skill.getTurnUseCard=function(self)
	local cards = self.player:getCards("h")
	cards=sgs.QList2Table(cards)
	local card
	self:sortByUseValue(cards,true)
	for _,acard in ipairs(cards)  do
		if (acard:isBlack()) then --and (self:getUseValue(acard)<sgs.ai_use_value.Analeptic) then
			card = acard
			break
		end
	end
	if not card then return nil end
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	local card_str = ("analeptic:guixiong[spade:%s]=%d"):format(number, card_id)
	local analeptic = sgs.Card_Parse(card_str)
	assert(analeptic)
	return analeptic
end

sgs.ai_view_as.guixiong = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card_place ~= sgs.Player_Equip then
		if card:isBlack() then
			return ("analeptic:guixiong[%s:%s]=%d"):format(suit, number, card_id)
		end
	end
end

--direnjie
sgs.ai_skill_invoke.zhaoxue = function(self, data)
	local effect = data:toCardEffect()
	if effect.card:inherits("AmazingGrace") then return end
	if effect.card:inherits("GodSalvation") then return end
	return self:isEnemy(effect.from) and not self.player:isKongcheng()
end

sgs.ai_skill_playerchosen.zhaoxue = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) and self:isWeak(player) then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) and player:getLostHp()>0 then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) then
			return player
		end
	end
end

-- jianneng
sgs.ai_skill_invoke.jianneng = true

sgs.ai_skill_playerchosen.jianneng = function(self, targets)
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

sgs.ai_skill_askforag.jianneng = function(self, card_ids)
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

--xinshenduan
xinshenduan_skill={}
xinshenduan_skill.name="xinshenduan"
table.insert(sgs.ai_skills,xinshenduan_skill)
xinshenduan_skill.getTurnUseCard=function(self)
if self.player:hasUsed("XinshenduanCard") then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") and not card:inherits("Jink") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@XinshenduanCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["XinshenduanCard"] = function(card, use, self)
	for _, enemy in ipairs(self.enemies) do
	if not enemy:getEquips():isEmpty() and enemy:getJudgingArea():isEmpty() and self:isWeak(enemy) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
	for _, enemy in ipairs(self.enemies) do
	if not enemy:getEquips():isEmpty() and enemy:getJudgingArea():isEmpty() and enemy:isKongcheng() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
	for _, enemy in ipairs(self.enemies) do
	if not enemy:getEquips():isEmpty() and enemy:getJudgingArea():isEmpty() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_use_priority.XinshenduanCard = 5

--guiguzi
baihe_skill={}
baihe_skill.name="baihe"
table.insert(sgs.ai_skills,baihe_skill)
baihe_skill.getTurnUseCard=function(self)
if self.player:isKongcheng() or self.player:hasUsed("BaiheCard") then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") and not card:inherits("Jink") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@BaiheCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["BaiheCard"] = function(card, use, self)
	for _, friend in ipairs(self.friends) do
	if friend:isChained() and friend:isKongcheng() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
	for _, friend in ipairs(self.friends) do
	if friend:isChained() and self:isWeak(friend) and not self:isGoodChainTarget(friend) then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
	for _, enemy in ipairs(self.enemies) do
	if not enemy:isChained() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end
