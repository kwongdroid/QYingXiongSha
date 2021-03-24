--yanyi
local yanyi_skill={}
yanyi_skill.name="yanyi"
table.insert(sgs.ai_skills,yanyi_skill)
yanyi_skill.getTurnUseCard=function(self)
    local cards = self.player:getCards("he")
	local blacks = {}
	for _, card in sgs.qlist(cards) do
		if card:isBlack() then
			table.insert(blacks, card)
		end
	end

	if #blacks == 0 or self.player:hasUsed("YanyiCard") then return end
	self:sortByUseValue(blacks, true)

	local card_str = ("@YanyiCard=%d"):format(blacks[1]:getEffectiveId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["YanyiCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if not enemy:isKongcheng() and self:isWeak(enemy) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
	for _, enemy in ipairs(self.enemies) do
	if not enemy:isKongcheng() then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

-- jiean
sgs.ai_skill_invoke.jiean= true

--seyou
local seyou_skill={}
seyou_skill.name="seyou"
table.insert(sgs.ai_skills,seyou_skill)
seyou_skill.getTurnUseCard=function(self)
	if not self.player:hasUsed("SeyouCard") and self.player:getMark("seyou") <= 0 then
		return sgs.Card_Parse("@SeyouCard=.")
	end
end

sgs.ai_skill_use_func["SeyouCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if self:isWeak(enemy) and enemy:isLord() and self.player:getRole() == "rebel" then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
	for _, enemy in ipairs(self.enemies) do
	if self:isWeak(enemy) then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

-- sheshi
sgs.ai_skill_invoke.sheshi= true

-- jiasuo
function sgs.ai_skill_invoke.jiasuo(self, data)
	return not self:isWeak()
end

-- zaofan
function sgs.ai_skill_invoke.zaofan(self, data)
	return self.player:getPhase() ~= sgs.Player_NotActive
end

-- buwu
sgs.ai_skill_invoke.buwu = function(self, data)
   return #self.friends_noself >= 2
end
sgs.ai_skill_playerchosen.buwu = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and (player:hasSkill("wusheng") or player:hasSkill("longdan") or player:hasSkill("tianyi")) and player:getMark("buwu") <= 0 then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isFriend(player) and player:getMark("buwu") <= 0 then
			return player
		end
	end
end

-- xiadao
sgs.ai_view_as.xiadao = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if player:getEquips():isEmpty() and card_place ~= sgs.Player_Equip then
		return ("jink:xiadao[%s:%s]=%d"):format(suit, number, card_id)
	end
end
sgs.ai_view_as.dushi1 = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card:isRed() then
		return ("jink:dushi1[%s:%s]=%d"):format(suit, number, card_id)
	end
end
sgs.ai_view_as.dushi2 = function(card, player, card_place)
	local suit = card:getSuitString()
	local number = card:getNumberString()
	local card_id = card:getEffectiveId()
	if card:isBlack() then
		return ("nullification:dushi2[%s:%s]=%d"):format(suit, number, card_id)
	end 
end

-- zhangyi
sgs.ai_skill_invoke.zhangyi = function(self, data)
   return #self.friends_noself >= 1
end

sgs.ai_skill_playerchosen.zhangyi = function(self, targets)
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

--lingdao
local lingdao_skill={}
lingdao_skill.name="lingdao"
table.insert(sgs.ai_skills,lingdao_skill)
lingdao_skill.getTurnUseCard=function(self)
    if self.player:getMark("@lmin") > 0 then return end
	local cards = self.player:getCards("h")
	local ljcards = {}
	for _, card in sgs.qlist(cards) do
		if card:inherits("Shewoqishui") or card:inherits("Lightning") or card:inherits("AmazingGrace")  then
			table.insert(ljcards, card)
		end
	end

	if #ljcards == 0 or self.player:hasUsed("LingdaoCard") then return end
	self:sortByUseValue(ljcards, true)

	local card_str = ("@LingdaoCard=%d"):format(ljcards[1]:getEffectiveId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["LingdaoCard"]=function(card,use,self)
	for _, enemy in ipairs(self.enemies) do
	if self:getCardsNum(".", enemy, "e") > 0 then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

--duobi
local duobi_skill={}
duobi_skill.name="duobi"
table.insert(sgs.ai_skills,duobi_skill)
duobi_skill.getTurnUseCard=function(self)
    if self.player:getMark("@lchen") > 0 then return end
	if self.player:isKongcheng() then return end
    if self.player:hasUsed("DuobiCard") then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@DuobiCard=%d"):format(cards[1]:getId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func["DuobiCard"]=function(card,use,self)
	if self.player:isWounded() then
	use.card=card
   end
end

--tongfu
local tongfu_skill={}
tongfu_skill.name="tongfu"
table.insert(sgs.ai_skills,tongfu_skill)
tongfu_skill.getTurnUseCard=function(self)
	if self.player:isKongcheng() then return end

	local cards = self.player:getHandcards()
	cards=sgs.QList2Table(cards)

	self:sortByKeepValue(cards)

	local card_str = ("@TongfuCard=%d"):format(cards[1]:getId())

	if self.player:getMark("jingxiang") <= 0 then
	return sgs.Card_Parse("@TongfuCard=.")
	else
	return sgs.Card_Parse(card_str)
  end
end

sgs.ai_skill_use_func["TongfuCard"]=function(card,use,self)
	for _, friend in ipairs(self.friends_noself) do
	if self.player:getMark("jingxiang") <= 0 and friend:getMark("@jingxiang") <= 0  and friend:isLord() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
	   end
	end
	for _, friend in ipairs(self.friends_noself) do
	if self.player:getMark("jingxiang") <= 0 and friend:getMark("@jingxiang") <= 0 then
			use.card=card
			if use.to then use.to:append(friend) end
			return
	   end
	end
	for _, enemy in ipairs(self.enemies) do
	if self.player:getMark("jingxiang") > 0 and enemy:getMark("@jingxiang") > 0 then
			use.card=card
			if use.to then use.to:append(enemy) end
			return
	   end
	end
end

-- shengnv
sgs.ai_skill_invoke.shengnv= true

sgs.ai_skill_cardask["@shengnv_discard1"] = function(self, data)
	local da = data:toDamage()
	if self:isFriend(da.to) or self.player:isKongcheng() then
		return "."
	else
		local card = da.card
		local cards = sgs.QList2Table(self.player:getCards("h"))
		self:sortByUseValue(cards, true)
		for _, acard in ipairs(cards) do
			if acard:isRed() then
				return acard:getEffectiveId()
			end
		end
		return "."
	end
end

sgs.ai_skill_cardask["@shengnv_discard2"] = function(self, data)
	local da = data:toDamage()
	if self:isFriend(da.to) or self.player:isKongcheng() then
		return "."
	else
		local card = da.card
		local cards = sgs.QList2Table(self.player:getCards("h"))
		self:sortByUseValue(cards, true)
		for _, acard in ipairs(cards) do
			if acard:isBlack() then
				return acard:getEffectiveId()
			end
		end
		return "."
	end
end

-- huli
local huli_skill={}
huli_skill.name="huli"
table.insert(sgs.ai_skills,huli_skill)
huli_skill.getTurnUseCard=function(self)
	local cards = self.player:getCards("h")
	local yaocards = {}
	for _, card in sgs.qlist(cards) do
		if card:inherits("Peach") then
			table.insert(yaocards, card)
		end
	end

	if #yaocards == 0 or self.player:hasUsed("HuliCard") then return end
	self:sortByUseValue(yaocards, true)

	local card_str = ("@HuliCard=%d"):format(yaocards[1]:getEffectiveId())
	return sgs.Card_Parse(card_str)
end

sgs.ai_skill_use_func.HuliCard=function(card,use,self)
	self:sort(self.friends, "defense")

	for _, friend in ipairs(self.friends_noself) do
		if friend:isWounded() then
			use.card=card
			if use.to then use.to:append(friend) end
			return
		end
	end
end

sgs.ai_use_priority.HuliCard = 4.2
sgs.ai_card_intention.HuliCard = -100

sgs.dynamic_value.benefit.HuliCard = true

-- yxyixin
local yxyixin_skill={}
yxyixin_skill.name="yxyixin"
table.insert(sgs.ai_skills,yxyixin_skill)
yxyixin_skill.getTurnUseCard=function(self)
    if self.player:hasUsed("YxyixinCard") or self.player:getMark("yxyixin") > 0  then return end
    local cards = sgs.QList2Table(self.player:getHandcards())
	self:sortByUseValue(cards)
	local yixin_cards = {}
	for index = #cards, 1, -1 do
		if self:getUseValue(cards[index]) >= 6 then break end
		if cards[index]:isBlack() or cards[index]:isRed() then
			if #yixin_cards == 0 or (#yixin_cards == 1 and cards[index]:getSuit() ~= sgs.Sanguosha:getCard(yixin_cards[1]):getSuit()) then
				table.insert(yixin_cards, cards[index]:getId())
				table.remove(cards, index)
			end
			if #yixin_cards >=2 then break end
		end
	end
	if #yixin_cards == 2 then return sgs.Card_Parse("@YxyixinCard=" .. table.concat(yixin_cards, "+")) end
end

sgs.ai_skill_use_func["YxyixinCard"]=function(card,use,self)
for _, friend in ipairs(self.friends) do
	if self:isWeak(friend) then
			use.card = card
			if use.to then use.to:append(friend) end
			return
	   end
	end
end

sgs.ai_use_value.YxyixinCard = 8.6
sgs.ai_use_priority.YxyixinCard = 6.8
sgs.dynamic_value.benefit.YxyixinCard = true

--fanpu
local fanpu_skill={}
fanpu_skill.name="fanpu"
table.insert(sgs.ai_skills,fanpu_skill)
fanpu_skill.getTurnUseCard=function(self)
    local hasdiren = flase
	for _, enemy in ipairs(self.enemies) do
	if self.player:inMyAttackRange(enemy) and not self:isWeak()  then
			hasdiren = true
	end
	end

	local hasdiren2 = flase
	for _, enemy in ipairs(self.enemies) do
	if enemy:inMyAttackRange(self.player) and self:isWeak() then
			hasdiren2 = true
	end
	end

	if not self.player:hasUsed("FanpuCard") and ((self.player:getMark("@tongling") == 3 and hasdiren)  or (self.player:getMark("@tongling") == 3 and hasdiren2)) then
		return sgs.Card_Parse("@FanpuCard=.")
	end
end

sgs.ai_skill_use_func["FanpuCard"]=function(card,use,self)
	use.card=card
	return
end

sgs.ai_skill_choice.fanpu = function(self, choices)
	if(self:isWeak()) then return "fanpu1" end
	return "fanpu2"
end

sgs.ai_skill_playerchosen.fanpu = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) and self:isWeak(enemy) then
			return player
		end
	end
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) then
			return player
		end
	end
end

-- tiewan
sgs.ai_skill_invoke.tiewan = function(self, data)
   local enemys = false
   for _, player in sgs.qlist(self.room:getOtherPlayers(self.player)) do
	if self:isEnemy(player) and not player:containsTrick("indulgence") then
			enemys = true
	end
end
    local cards = self.player:getHandcards()
	local wastecards = {}
	for _, card in sgs.qlist(cards) do
		if card:isRed() then
			table.insert(wastecards, card)
		end
	end
     return enemys and #wastecards > 0
end

sgs.ai_skill_playerchosen.tiewan = function(self, targets)
	for _, player in sgs.qlist(targets) do
		if self:isEnemy(player) and not player:containsTrick("indulgence") then
			return player
		end
	end
end
