-- cuanquan
sgs.ai_skill_invoke.cuanquan= true

-- shixin
sgs.ai_skill_invoke.shixin = function(self, data)
	return not self:isFriend(data:toPlayer())
end

-- luobi
sgs.ai_skill_invoke.luobi= true

--heqin
local heqin_skill={}
heqin_skill.name="heqin"
table.insert(sgs.ai_skills,heqin_skill)
heqin_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@HeqinCard=%d"):format(cards[1]:getId())

	if self.player:getMark("@heqin") <= 0 then
	return sgs.Card_Parse("@HeqinCard=.")
	else
	return sgs.Card_Parse(card_str)
  end
end

sgs.ai_skill_use_func["HeqinCard"]=function(card,use,self)
	for _, friend in ipairs(self.friends_noself) do
	if self.player:getMark("@heqin") <= 0 and friend:getGeneral():isMale() and friend:isLord() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
	   end
	end
	for _, friend in ipairs(self.friends_noself) do
	if self.player:getMark("@heqin") <= 0 and friend:getGeneral():isMale() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
	   end
	end
	for _, enemy in ipairs(self.enemies) do
	if enemy:getMark("@heqin") > 0 and self.player:getMark("@heqin") > 0 and enemy:getGeneral():isMale() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

-- xinpozhen
sgs.ai_skill_invoke.xinpozhen= function(self, data)
	local effect = data:toSlashEffect()
	return not self:isFriend(effect.to)
end

--ciyin
local ciyin_skill={}
ciyin_skill.name="ciyin"
table.insert(sgs.ai_skills,ciyin_skill)
ciyin_skill.getTurnUseCard=function(self)
    if self.player:getMark("@xchen") > 0 then return end
	if not self.player:hasUsed("CiyinCard") then
		return sgs.Card_Parse("@CiyinCard=.")
	end
end

sgs.ai_skill_use_func["CiyinCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if not self.player:getArmor() and enemy:getArmor() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_view_as.jiaozhen = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card:isBlack() and card_place ~= sgs.Player_Equip then
		return ("shewoqishui:jiaozhen[%s:%s]=%d"):format(suit, number, card_id)
	end
end

--xinguashuai
local xinguashuai_skill={}
xinguashuai_skill.name="xinguashuai"
table.insert(sgs.ai_skills,xinguashuai_skill)
xinguashuai_skill.getTurnUseCard=function(self)
    if self.player:getMark("@xmin") > 0 then return end
	if self.player:isKongcheng() then return end
    if self.player:hasUsed("XinguashuaiCard") then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@XinguashuaiCard=%d"):format(cards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["XinguashuaiCard"]=function(card,use,self)
	if self.player:isWounded() then
	use.card=card
   end
end

-- piaoqi
sgs.ai_skill_invoke.piaoqi= function(self, data)
	local effect = data:toSlashEffect()
	return not self:isFriend(effect.to)
end

-- rentu
sgs.ai_skill_invoke.rentu= true

-- huiyan
sgs.ai_skill_invoke.huiyan= true

-- xinjujian
local xinjujian_skill={}
xinjujian_skill.name="xinjujian"
table.insert(sgs.ai_skills, xinjujian_skill)
xinjujian_skill.getTurnUseCard=function(self)
    local haschens = false
    for _, player in sgs.qlist(self.room:getAllPlayers()) do
	if player:getKingdom() == "shu" then
			haschens = true
	end
end

	if haschens and not self.player:hasUsed("XinjujianCard") then
		return sgs.Card_Parse("@XinjujianCard=.")
	end
end

sgs.ai_skill_use_func.XinjujianCard = function(card, use, self)
	local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards,true)
	local name = self.player:objectName()
	local card, friend = self:getCardNeedPlayer(cards)
	if card and friend then
		use.card = sgs.Card_Parse("@XinjujianCard=" .. card:getId())
		if use.to then use.to:append(friend) end
		return
	end

	local target
	for _, enemy in ipairs(self.enemies) do
			if enemy then
				for _, card in ipairs(cards)do
					if card:inherits("Shewoqishui") or card:inherits("Lightning") or (not card:inherits("Peach") and not card:inherits("Jink") and not card:inherits("Fuzhou") and not card:inherits("EquipCard") and not card:inherits("TrickCard") and not card:inherits("XueSlash") and not card:inherits("AnSlash") and self.player:getHandcardNum()-1 > self.player:getHp()) then
						use.card = sgs.Card_Parse("@XinjujianCard=" .. card:getEffectiveId())
						target = enemy
						break
					end
				end
			end
			if target then break end
		end

	if target then
		if use.to then
			use.to:append(target)
		end
	end
end

sgs.ai_use_value.XinjujianCard = 8.5
sgs.ai_use_priority.XinjujianCard = 5.8

sgs.ai_card_intention.XinjujianCard = -70

sgs.dynamic_value.benefit.XinjujianCard = true

-- yaoyi
sgs.ai_skill_invoke.yaoyi= true

local zongheng_skill={}
zongheng_skill.name="zongheng"
table.insert(sgs.ai_skills,zongheng_skill)
zongheng_skill.getTurnUseCard=function(self)
	local cards = self.player:getCards("h")
	cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	for _,acard in ipairs(cards)  do
		if (acard:getSuit() == sgs.Card_Diamond) then--and (self:getUseValue(acard)<sgs.ai_use_value.IronChain) then
			card = acard
			break
		end
	end

	if not card then return nil end
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	local card_str = ("iron_chain:zongheng[diamond:%s]=%d"):format(number, card_id)
	local skillcard = sgs.Card_Parse(card_str)
	assert(skillcard)
	return skillcard
end

--yinju
local yinju_skill={}
yinju_skill.name="yinju"
table.insert(sgs.ai_skills,yinju_skill)
yinju_skill.getTurnUseCard=function(self)
    if self.player:getMark("@yinju1") > 0 or self.player:getMark("@yinju2") > 0 then return end
	if self.player:isKongcheng() then return end
    if self.player:hasUsed("YinjuCard") then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@YinjuCard=%d"):format(cards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["YinjuCard"]=function(card,use,self)
	use.card=card
end

local duizhi_skill={}
duizhi_skill.name="duizhi"
table.insert(sgs.ai_skills,duizhi_skill)
duizhi_skill.getTurnUseCard=function(self,inclusive)
    local cards = self.player:getCards("h")
    cards=sgs.QList2Table(cards)

	local card

	self:sortByUseValue(cards,true)

	for _,acard in ipairs(cards)  do
		if (acard:getSuit() == sgs.Card_Diamond) and ((self:getUseValue(acard)<sgs.ai_use_value["Geanguanhuo"]) or inclusive) then
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
	local card_str = ("geanguanhuo:duizhi[%s:%s]=%d"):format(suit, number, card_id)
	local  geanguanhuo= sgs.Card_Parse(card_str)

    assert(geanguanhuo)

    return geanguanhuo
end

-- xinzhiheng
sgs.ai_skill_invoke.xinzhiheng = function(self, data)
	local player = self.room:getCurrent()
	if self:isWeak() then return end
	return (self:isFriend(player) and player:hasSkill("jushou") and player:getPhase()== sgs.Player_Finish)
	or (self:isEnemy(player) and player:hasSkill("tianyi") and not player:hasSkill("heqin") and player:getPhase()== sgs.Player_Play)
	or (self:isEnemy(player) and player:hasSkill("shuangxiong") and not player:hasSkill("heqin") and player:getPhase()== sgs.Player_Draw)
	or (self:isEnemy(player) and player:hasSkill("luoyi") and not player:hasSkill("heqin") and player:getPhase()== sgs.Player_Draw)
	or (self:isEnemy(player) and player:hasSkill("xintiaoxin") and not player:hasSkill("heqin") and player:getPhase()== sgs.Player_Draw)
	or (self:isEnemy(player) and player:hasSkill("weiwo") and not player:hasSkill("heqin") and player:getPhase()== sgs.Player_Draw)
	or (self:isEnemy(player) and player:hasSkill("cihuai") and not player:hasSkill("heqin") and player:getPhase()== sgs.Player_Play)
end

-- cardneed
sgs.guiguzi_suit_value =
{
	diamond = 3.9
}

sgs.sunquan_suit_value =
{
	diamond = 3.9
}

-- taofa
local taofa_skill={}
taofa_skill.name="taofa"
table.insert(sgs.ai_skills,taofa_skill)
taofa_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Jink")
		and not card:inherits("Analeptic") and not card:inherits("Fuzhou") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@TaofaCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
 end

sgs.ai_skill_use_func["TaofaCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if enemy:getHp() == 1
	and self.player:getHp() == 1
	and enemy:getMark("taofamark") <= 0 then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end

	for _, friend in ipairs(self.friends_noself) do
	if friend:getMark("taofamark") <= 0
	and self:isWeak(friend)
	and friend:getHp() < self.player:getHp()
	and not (friend:isKongcheng() and friend:hasSkill("kongcheng")) then
			use.card=card
			if use.to then use.to:append(friend) end
			return
	   end
	end

    for _, enemy in ipairs(self.enemies) do
	if not enemy:hasSkill("ganglie")
	and not enemy:hasSkill("fankui")
	and not enemy:hasSkill("yiji")
	and not enemy:hasSkill("jieming")
	and enemy:getMark("taofamark") <= 0
	and enemy:getHp() >= self.player:getHp() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_skill_invoke.jiasha = function(self, data)
	local target = data:toPlayer()
	if self:isFriend(target) then
		return (target:hasSkill("xiaoji") and not target:getEquips():isEmpty()) or (self:isEquip("SilverLion",target) and target:isWounded())
	end
	if self:isEnemy(target) then
		if target:hasSkill("tuntian") then return false end
		if (self:needKongcheng(target) or target:hasSkill("lianying")) and target:getHandcardNum() == 1 then
			if not target:getEquips():isEmpty() then return true
			else return false
			end
		end
	end
	--self:updateLoyalty(-0.8*sgs.ai_loyalty[target:objectName()],self.player:objectName())
	return true
end

--pudu
local pudu_skill={}
pudu_skill.name="pudu"
table.insert(sgs.ai_skills,pudu_skill)
pudu_skill.getTurnUseCard=function(self)
    if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if card:inherits("EquipCard") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 or self.player:hasUsed("PuduCard") then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@PuduCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
 end

sgs.ai_skill_use_func["PuduCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if not enemy:isKongcheng()  then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_use_priority.PuduCard = 5

sgs.ai_skill_choice.pudu = function(self, choices)
	return "puduqipai"
end

-- zhenglue
sgs.ai_skill_invoke.zhenglue= true

-- beide
sgs.ai_skill_invoke.beide= true

-- yuci
local yuci_skill={name="yuci"}
table.insert(sgs.ai_skills,yuci_skill)
yuci_skill.getTurnUseCard = function(self)
	if not self.player:hasUsed("YuciCard") then return sgs.Card_Parse("@YuciCard=.") end
	if self.player:hasFlag("yuci") then return sgs.Card_Parse("@YuciCard=.") end
end

sgs.ai_skill_use_func.YuciCard = function(card, use, self)
	if self.player:hasFlag("yuci") then
		local yucisrc = sgs.Sanguosha:getCard(self.player:getMark("yuci"))
		local cards = sgs.QList2Table(self.player:getHandcards())
		self:sortByUseValue(cards, true)
		for _, hcard in ipairs(cards) do
			if hcard:getSuit() == yucisrc:getSuit() then
				local yucistr = ("%s:yuci[%s:%s]=%d"):format(yucisrc:objectName(), yucisrc:getSuitString(), yucisrc:getNumberString(), hcard:getId())
				local yuci = sgs.Card_Parse(yucistr)
				if self:getUseValue(yuci) > self:getUseValue(hcard) then
					if yucisrc:inherits("BasicCard") then
						self:useBasicCard(yucisrc, use)
						if use.card then use.card = yuci return end
					else
						self:useTrickCard(yucisrc, use)
						if use.card then use.card = yuci return end
					end
				end
			end
		end
	else
		local target
		self:sort(self.enemies, "hp")
		enemy = self.enemies[1]
		if self:isWeak(enemy) and not enemy:isKongcheng() then
			target = enemy
		else
			if target and target:isKongcheng() then target = nil end
		end

		if not target then
			self:sort(self.enemies,"handcard")
			if not self.enemies[1]:isKongcheng() then target = self.enemies[1] else return end
		end
		use.card = card
		if use.to then use.to:append(target) end
	end
end

sgs.ai_use_priority.YuciCard = 10

-- cifu
sgs.ai_skill_invoke.cifu= true

sgs.ai_skill_playerchosen.cifu = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isWeak(player) and self:isFriend(player) then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if player:isWounded() and self:isFriend(player) then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) then
			return player
		end
	end
end

-- feijiang
sgs.ai_skill_invoke.feijiang = function(self, data)
	local effect = data:toSlashEffect()
return not self:isFriend(effect.to) end

-- xinzhiba
local xinzhiba_skill={}
xinzhiba_skill.name="xinzhiba"
table.insert(sgs.ai_skills,xinzhiba_skill)
xinzhiba_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 or self.player:hasUsed("XinzhibaCard") then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@XinzhibaCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
 end

sgs.ai_skill_use_func["XinzhibaCard"]=function(card,use,self)
	for _, friend in ipairs(self.friends_noself) do
	if self:isWeak(friend)
	and ((friend:getHandcardNum() == 1 and friend:hasSkill("kongcheng")) or (friend:getHandcardNum() == 1 and friend:hasSkill("lianying")))  then
			use.card=card
			if use.to then use.to:append(friend) end
			return
	   end
	end

	for _, enemy in ipairs(self.enemies) do
	if self:isWeak(enemy)
	and not enemy:isKongcheng()
	and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("kongcheng"))
	and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("lianying")) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end

	for _, enemy in ipairs(self.enemies) do
	if enemy:isWounded()
	and not enemy:isKongcheng()
	and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("kongcheng"))
	and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("lianying")) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end

    for _, enemy in ipairs(self.enemies) do
	if not enemy:isKongcheng()
	and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("kongcheng"))
	and not (enemy:getHandcardNum() == 1 and enemy:hasSkill("lianying")) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_use_priority.XinzhibaCard = 10

--shouli
local shouli_skill={}
shouli_skill.name="shouli"
table.insert(sgs.ai_skills,shouli_skill)
shouli_skill.getTurnUseCard=function(self)
	if not self.player:hasUsed("ShouliCard") and not self.player:isKongcheng() then
		return sgs.Card_Parse("@ShouliCard=.")
	end
end

sgs.ai_skill_use_func["ShouliCard"]=function(card,use,self)
	local friends={}
	for _,player in ipairs(self.friends_noself) do
		if not (player:isKongcheng() and player:hasSkill("kongcheng")) then
			table.insert(friends, player)
		end
	end

	local friend1=friends[1]
	local friend2=friends[2]

	for _, friend in ipairs(self.friends_noself) do
	if  friend1 and friend2 and self.player:getHandcardNum() > 1 and not (friend:isKongcheng() and friend:hasSkill("kongcheng")) then
			use.card=card
			if use.to then
			use.to:append(friend1)
			use.to:append(friend2) end
			return
	   end
	end

	for _, friend in ipairs(self.friends_noself) do
	if  friend1 and not self.player:isKongcheng() and not (friend:isKongcheng() and friend:hasSkill("kongcheng")) then
			use.card=card
			if use.to then
			use.to:append(friend1) end
			return
	   end
	end
end

sgs.ai_use_priority.ShouliCard = 10

--chongru
local chongru_skill={}
chongru_skill.name="chongru"
table.insert(sgs.ai_skills,chongru_skill)
chongru_skill.getTurnUseCard=function(self)
    if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 or self.player:hasUsed("ChongruCard") then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@ChongruCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
 end

sgs.ai_skill_use_func["ChongruCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if not enemy:isKongcheng() and enemy:getHandcardNum() > self.player:getHandcardNum() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

--xinjieyi
local xinjieyi_skill={}
xinjieyi_skill.name="xinjieyi"
table.insert(sgs.ai_skills,xinjieyi_skill)
xinjieyi_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@XinjieyiCard=%d"):format(cards[1]:getId())

	if self.player:getMark("@jieyi") <= 0 then
	return sgs.Card_Parse("@XinjieyiCard=.")
	else
	return sgs.Card_Parse(card_str)
  end
end

sgs.ai_skill_use_func["XinjieyiCard"]=function(card,use,self)
	for _, friend in ipairs(self.friends_noself) do
	if self.player:getMark("@jieyi") <= 0 and friend:getGeneral():isMale() and friend:isLord() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
	   end
	end
	for _, friend in ipairs(self.friends_noself) do
	if self.player:getMark("@jieyi") <= 0 and friend:getGeneral():isMale() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
	   end
	end
	for _, enemy in ipairs(self.enemies) do
	if #self.friends_noself == 0 and self.player:getMark("@jieyi") <= 0 and enemy:getGeneral():isMale() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
	for _, enemy in ipairs(self.enemies) do
	if #self.friends_noself > 0 and enemy:getMark("@jieyi") > 0 and self.player:getMark("@jieyi") > 0 and enemy:getGeneral():isMale() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_skill_invoke.xinjieyi = function(self, data)
   local cards = self.player:getHandcards()
   local reds = {}
	for _, card in sgs.qlist(cards) do
		if card:isRed() then
			table.insert(reds, card)
		end
	end

   local damage = data:toDamage()
   local recover = data:toRecover()

   local others = self.room:getOtherPlayers(self.player)
   for _, other in sgs.qlist(others) do
       if self:isFriend(damage.to) and other:getMark("@jieyi") > 0 then
       return #reds ~= 0 and self:isEnemy(other)
	end
end
   for _, other in sgs.qlist(others) do
   if self:isFriend(recover.who) and other:getMark("@jieyi") > 0 then
   return #reds ~= 0 and self:isFriend(other)
   end
  end
end

-- xinrende
sgs.ai_skill_invoke.xinrende = function(self, data)
   return #self.friends_noself > 0
end
sgs.ai_skill_playerchosen.xinrende = function(self, targets)
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
		if self:isFriend(player) then
			return player
		end
	end
end

-- shenduan
local shenduan_skill={}
shenduan_skill.name="shenduan"
table.insert(sgs.ai_skills,shenduan_skill)
shenduan_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end
	if self.player:hasUsed("ShenduanCard") then return end
	if self.player:getMark("@shenduan") > 1 then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") and not card:inherits("Jink")  then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 or self.player:hasUsed("ShenduanCard") then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@ShenduanCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
 end

sgs.ai_skill_use_func["ShenduanCard"]=function(card,use,self)
	use.card = card
end

sgs.ai_skill_invoke.shenduan = function(self, data)
   local judge = data:toJudge()
   local reason = judge.reason
	return self:needRetrial(judge) and self:isFriend(judge.who) and (reason == "indulgence" or reason == "eight_diagram" or reason == "lightning" or reason == "tieji" or reason == "bazhen")
end

sgs.ai_skill_choice.shenduan = function(self, choices)
	 return "shenduan1"
end

--shengong
local shengong_skill={}
shengong_skill.name="shengong"
table.insert(sgs.ai_skills,shengong_skill)
shengong_skill.getTurnUseCard=function(self)
    if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 or self.player:hasUsed("ShengongCard") then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@ShengongCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
 end

sgs.ai_skill_use_func["ShengongCard"]=function(card,use,self)
	for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
	if self:getCardsNum(".", player, "e") >= 1 then
			use.card=card
			if use.to then use.to:append(player) end
			return
	   end
	end
end

sgs.ai_skill_playerchosen.shengong = function(self, targets)
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
		if self:isFriend(player) then
			return player
		end
	end
end

sgs.ai_skill_choice.yingtu = function(self, choice)
	if self.player:getHp() < self.player:getMaxHP()-1 then return "yingturecover" end
	return "yingtudraw"
end

-- renshu
local renshu_skill={}
renshu_skill.name="renshu"
table.insert(sgs.ai_skills,renshu_skill)
renshu_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end
	if self.player:hasUsed("RenshuCard") then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") and card:getSuit() == sgs.Card_Diamond  then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 or self.player:hasUsed("RenshuCard") then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@RenshuCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
 end

sgs.ai_skill_use_func["RenshuCard"]=function(card,use,self)
	use.card = card
end

sgs.ai_use_priority.RenshuCard = 10

--guimian
local guimian_skill={}
guimian_skill.name="guimian"
table.insert(sgs.ai_skills,guimian_skill)
guimian_skill.getTurnUseCard=function(self)
    if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if card:inherits("Slash") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@GuimianCard=%d"):format(wastecards[1]:getId())
	local slash = sgs.Card_Parse(card_str)
	assert(slash)
	return slash
 end

sgs.ai_skill_use_func["GuimianCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if enemy:getMark("guimians") > 0 then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_use_priority.GuimianCard = 10

--jingmian
local jingmian_skill={}
jingmian_skill.name="jingmian"
table.insert(sgs.ai_skills,jingmian_skill)
jingmian_skill.getTurnUseCard=function(self)
    if self.player:isKongcheng() then return end
	if self.player:getMark("jingmian") > 0 then return end

	local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if not card:inherits("Peach") and not card:inherits("Fuzhou")  and not card:inherits("ExNihilo") and not card:inherits("Jink") then
			table.insert(wastecards, card)
		end
	end

	if #wastecards == 0 or self.player:hasUsed("JingmianCard") then return end
	self:sortByUseValue(wastecards, true)

	local card_str = ("@JingmianCard=%d"):format(wastecards[1]:getId())
	return sgs.Card_Parse(card_str)
 end

sgs.ai_skill_use_func["JingmianCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if enemy and self.player:getMark("jingmian") <= 0  then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

sgs.ai_use_priority.JingmianCard = 12

-- qinzheng
sgs.ai_skill_invoke.qinzheng= true

sgs.ai_skill_playerchosen.qinzheng = function(self, targets)
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
		if self:isFriend(player) then
			return player
		end
	end
end

--shangzhou
-- wudao
sgs.ai_skill_invoke.wudao = function(self, data)
	return not self:isFriend(data:toPlayer())
end

--zhongpan
local zhongpan_skill={}
zhongpan_skill.name="zhongpan"
table.insert(sgs.ai_skills,zhongpan_skill)
zhongpan_skill.getTurnUseCard=function(self,inclusive)
	local cards = self.player:getCards("h")
	cards=sgs.QList2Table(cards)
	local spade_card
	self:sortByUseValue(cards,true)

	for _,card in ipairs(cards) do
		if card:getSuit() == sgs.Card_Spade and ((self:getUseValue(card)<sgs.ai_use_value.ArcheryAttack) or inclusive) then
			spade_card = card
			break
		end
	end

	if spade_card then
	local suit = spade_card:getSuitString()
	local number = spade_card:getNumberString()
	local card_id = spade_card:getEffectiveId()
	local card_str = ("archery_attack:zhongpan[%s:%s]=%d"):format(suit, number, card_id)
	local skillcard = sgs.Card_Parse(card_str)

    assert(skillcard)
    return skillcard
	end
end

--aobai
-- weiwo
sgs.ai_skill_invoke.weiwo=function(self,data)
	if self.player:isSkipped(sgs.Player_Play) then return false end
	local cards=self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	for _,card in ipairs(cards) do
		if card:inherits("Slash") then

			for _,enemy in ipairs(self.enemies) do
				if self.player:canSlash(enemy, true) and
				self:slashIsEffective(card, enemy) and
				( (not enemy:getArmor()) or (enemy:getArmor():objectName()=="renwang_shield") or (enemy:getArmor():objectName()=="vine") ) and
				enemy:getHandcardNum()< 2 then
					if not self.player:containsTrick("indulgence") then
						self:speak("weiwo")
						return true
					end
				end
			end
		end
	end
	return false
end

-- duzun
sgs.ai_skill_invoke.duzun = function(self, data)
	local damage = data:toDamage()
	local ly = self.room:findPlayerBySkillName("guidao")
	if ly and self:isEnemy(ly) and self:canRetrial(ly) then
	    return false
	else
		return self:isEnemy(damage.to)
	end
end

-- chaofeng
sgs.ai_chaofeng.sunquan = 5
sgs.ai_chaofeng.sp_wangzhaojun = 4
sgs.ai_chaofeng.tangbohu = -1
sgs.ai_chaofeng.chen_muguiying = 1
sgs.ai_chaofeng.min_muguiying = 1
sgs.ai_chaofeng.luocheng = 1
sgs.ai_chaofeng.baiqi = 1
sgs.ai_chaofeng.zhaowu = 3
sgs.ai_chaofeng.bole = -1
sgs.ai_chaofeng.yangguang = -1
sgs.ai_chaofeng.guiguzi = 2
sgs.ai_chaofeng.yuwenhuaji = 3
sgs.ai_chaofeng.sudaji = -2
sgs.ai_chaofeng.liqingzhao = 4
sgs.ai_chaofeng.xzhuge = 6
sgs.ai_chaofeng.miyue = 1
sgs.ai_chaofeng.xiaozhuang = 5
sgs.ai_chaofeng.wsgui = 2
sgs.ai_chaofeng.xiajie = -3
sgs.ai_chaofeng.weizhongxian = 5
sgs.ai_chaofeng.gaoqiu = 2
sgs.ai_chaofeng.xzhurong = -2
sgs.ai_chaofeng.xmh = 4
sgs.ai_chaofeng.liji = 4
sgs.ai_chaofeng.gcg1 = 3
sgs.ai_chaofeng.nvwa = -3
sgs.ai_chaofeng.spwenjiang = 5
sgs.ai_chaofeng.xnianshou = -2
sgs.ai_chaofeng.tpgz = -1
sgs.ai_chaofeng.moxi = -2
sgs.ai_chaofeng.baiban = 6
















