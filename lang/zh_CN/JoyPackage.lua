-- translation for JoyPackage

return {
	["joy"] = "欢乐",
	["disaster"] = "天灾包",
	["joy_equip"] = "欢乐装备包",

	["disgusting_card"] = "恶心牌",

	["shit"] = "屎",
	[":shit"] = "基本牌，当此牌在<font color='red'><b>你的回合</b></font>内从你的<font color='red'>手牌</font>进入<font color='red'>弃牌堆</font>时，你将受到自己对自己的一点伤害，其中梅花为雷电伤害，红桃花色产生火焰伤害，其他为无属性伤害，造成伤害的牌为此牌，在你的回合内，你可多次食用。",

	["deluge"] = "洪水",
	[":deluge"] = "锦囊牌，出牌阶段，将【洪水】横置于你的判定区里，回合判定阶段进行判定：若判定结果为 A、K，从当前角色的牌随机取出和场上存活人数相等的数量置于桌前，从下家开始，每人选一张收为手牌，然后将【洪水】弃置，否则将【洪水】移到当前角色下家的判定区。",

	["typhoon"] = "台风",
	[":typhoon"] = "锦囊牌，出牌阶段，将【台风】横置于你的判定区里，回合判定阶段进行判定：若判定结果为方块2~9之间，与当前角色距离为1的角色弃掉6张手牌，然后将【台风】弃置，否则将【台风】移动到当前角色下家的判定区。",

	["earthquake"] = "地震",
	[":earthquake"] = "锦囊牌，出牌阶段，将【地震】横置于你的判定区里，回合判定阶段进行判定：若判定结果为梅花2~9之间，与当前角色距离为1以内的角色弃掉装备区里的所有牌，然后将【地震】弃置，否则将【地震】移动到当前角色下家的判定区。",

	["volcano"] = "火山",
	[":volcano"] = "锦囊牌，出牌阶段，将【火山】横置于你的判定区里，回合判定阶段进行判定：若判定结果为红桃2~9之间，当前角色受到2点火焰伤害，与当前角色距离为1的角色受到1点火焰伤害，然后将【火山】弃置，否则将【火山】移动到当前角色下家的判定区。",

	["mudslide"] = "泥石流",
	[":mudslide"] = "锦囊牌，出牌阶段，将【泥石流】横置于你的判定区里，回合判定阶段进行判定：若判定结果为黑桃或梅花A、K、4、7，从当前角色开始，每名角色依次按顺序弃掉武器、防具、+1马、-1马，无装备者受到1点伤害，当总共被弃掉的装备达到4件或所有角色都结算完毕后，将【泥石流】弃置，否则将【泥石流】移动到当前角色下家的判定区。",

	["monkey"] = "猴子",
	[":monkey"] = "装备牌，防具效果：当场上有其他角色使用【桃】时，你可以弃掉【猴子】，阻止【桃】的结算并将其收为手牌",
	["grab_peach"] = "偷桃",

	["gale-shell"] = "狂风甲",
	[":gale-shell"] = "装备牌，防具效果：锁定技，每次受到火焰伤害时，该伤害+1；你可以将【狂风甲】装备到和你距离为1以内的一名角色的装备区内（不得替换）。",
	["#GaleShellDamage"] = "%from 的锁定技<font color='yellow'><b>【狂风甲】</b></font>被触发，受到的火焰伤害由 %arg 点上升到 %arg2 点",

	["yx_sword"] = "杨修剑",
	[":yx_sword"] = "装备牌，攻击范围：3\
武器特效：当你的【杀】造成上伤害时，你可以指定攻击范围内一名角色为伤害来源，若如此做，结算后将杨修剑交于该角色。",

}