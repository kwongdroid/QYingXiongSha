-- translation for ManeuveringPackage

return {
	["maneuvering"] = "军争卡牌包",

	["buff_card"] = "辅助伤害卡",
	["damage_spread"] = "伤害传导",

	["analeptic"] = "鸩",
	[":analeptic"] = "基本牌，出牌阶段，对自己使用，流失1点血量，则该出牌阶段，你的【杀】造成的伤害+1；弃牌阶段：弃入弃牌堆，流失1点血量；濒死时：回复1点血量。",
	["#Drank"] = "%from 使用了<font color='yellow'><b>【鸩】</b></font>，本回合使用的<font color='yellow'><b>【杀】</b></font>将具有伤害 <font color='yellow'><b>+1</b></font> 的效果",
	["#UnsetDrank"] = "%from 的<font color='yellow'><b>【杀】</b></font>结算完毕，<font color='yellow'><b>【鸩】</b></font>效果消失",
	["#UnsetDrankEndOfTurn"] = "%from 的回合结束，<font color='yellow'><b>【鸩】</b></font>效果消失",
	["#AnalepticBuff"] = "%from 喝了<font color='yellow'><b>【%arg】</b></font>，对 %to 造成的杀伤害 +1",

	["fire_slash"] = "火杀",
	[":fire_slash"] = "基本牌，出牌阶段，对除你外，你攻击范围内的一名角色使用，若目标无法闪避，你对目标角色造成1点火焰伤害。",

	["thunder_slash"] = "雷杀",
	[":thunder_slash"] = "基本牌，出牌阶段，对除你外，你攻击范围内的一名角色使用，若目标无法闪避，你对目标角色造成1点雷电伤害。",

	["fire_attack"] = "火攻",
	[":fire_attack"] = "锦囊牌，出牌阶段，对任意一名有手牌的角色使用（可以是自己），目标角色展示1张手牌，若你弃置1张与之相同花色的手牌，则你对目标角色造成1点火焰伤害。",
	["fire-attack-card"] = "你可以弃一张与 %dest 所展示卡牌相同花色（%arg）的牌对 %dest 产生一点火焰伤害",
	["@fire-attack"] = "%src 展示的牌的花色为 %arg，请弃掉与其相同花色的牌",

	["iron_chain"] = "合纵连横",
	[":iron_chain"] = "锦囊牌，出牌阶段，对任意角色使用，连横：选择一至两名角色使用，分别横置或重置这些角色，被横置的角色处于“连横”状态。当有一名角色受到【杀】的伤害时，其他处于“连横”状态的角色也将受到等额的伤害。合纵：你可以立即摸一张牌。",

	["supply_shortage"] = "绝粮莫兴",
	[":supply_shortage"] = "锦囊牌，出牌阶段，对与你距离为1的一名角色使用，将【绝粮莫兴】横置于该角色的判定区。【绝粮莫兴】在该角色摸牌前开始判定：如果不是梅花，则不能摸牌。",

	["guding_blade"] = "古锭刀",
	[":guding_blade"] = "装备牌，攻击范围：２\
	武器特效：锁定技，当你使用的【杀】造成伤害时，若指定目标没有手牌，则该伤害+1。",
	["#GudingBladeEffect"] = "%from 的锁定技<font color='yellow'><b>【古锭刀】</b></font>被触发，无手牌目标 %to 受到的伤害从 %arg 点增加到 %arg2 点",

	["fan"] = "朱雀羽扇",
	[":fan"] = "装备牌，攻击范围：４\
	武器特效：你可以将你的任一普通杀当作属性为火焰伤害的杀来使用。",
	["fan:yes"] = "你可将此普通【杀】视作【火杀】",

	["vine"] = "藤甲",
	[":vine"] = "装备牌，防具效果：锁定技，南蛮入侵、万箭齐发和普通杀对你无效；每次受到火焰伤害时，该伤害+1。",
	["#VineDamage"] = "%from 的锁定技<font color='yellow'><b>【藤甲】</b></font>被触发，受到的火焰伤害由 %arg 点增加到 %arg2 点",

	["silver_lion"] = "白银狮子",
	[":silver_lion"] = "装备牌，防具效果：锁定技，每次你受到伤害时，最多承受1点伤害（防止多余的伤害）；当你失去装备区里的白银狮子时，你回复1点体力值。",
	["#SilverLion"] = "%from 的锁定技<font color='yellow'><b>【白银狮子】</b></font>被触发，将 %arg 点伤害减至 <font color='yellow'><b>１</b></font> 点",

	["hualiu"] = "蹑影",
	[":+1 horse"] = "装备牌，其他角色计算与你的距离时，始终+1（你可以理解为一种防御上的优势，不同名称的+1马，其效果是相同的）。",
}
