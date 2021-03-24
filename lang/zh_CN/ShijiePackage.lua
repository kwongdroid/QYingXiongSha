-- translation for Shijie Package

return {
	["shijie"] = "世界英雄",

	--盖乌斯·尤利乌斯·凯撒
	["kaisa"] = "凯撒",
	["#kaisa"] = "独裁官",
	["ducai"] = "独裁",
	[":ducai"] ="主动技，出牌阶段，你可以弃掉1张手牌，则本轮内除你外的角色不能使用与该手牌花色相同的手牌或装备区的牌（每回合限用1次）。",
	["$ducai1"] = "我来，我见，我征服！",
	["$ducai2"] = "无",
	["~kaisa"] = "罗马帝国永存……",

	--拿破仑·波拿巴
	["napolun"] = "拿破仑",
	["#napolun"] = "荒野雄狮",
	["tongling"] = "统领",
	[":tongling"] ="被动技，每次其他角色受到伤害时，你获得1个统领标记（标记上限为3）。",
	["fanpu"] = "反扑",
	[":fanpu"] ="主动技，出牌阶段，你可以弃掉3个统领标记并选择一项执行（每回合限用1次）：\
	◆1. 本轮内不能成为【杀】的目标；\
	◆2. 对你攻击范围内的1名其他角色造成1点伤害。",
	["@tongling"] = "统领",
	["@tongling2"] = "统领·防",
	["fanpu1"] = "本轮内不能成为【杀】的目标",
	["fanpu2"] = "对你攻击范围内的1名其他角色造成1点伤害",
	["$tongling1"] = "统治世界的是想象力！",
	["$tongling2"] = "无",
	["$fanpu1"] = "精神胜于武力。",
	["$fanpu2"] = "无",
	["~napolun"] = "人是无常多变的，好运也是。",

	--埃及艳后
	["aijiyanhou"] = "埃及艳后",
	["#aijiyanhou"] = "神秘妖后",
	["seyou"] = "色诱",
	[":seyou"] ="主动技，出牌阶段，你可以指定任意一名角色，其他所有男性角色需选择一项执行（每局限用1次）：\
	◆1. 对你指定的角色出【杀】\
	◆2. 给你一张手牌或装备区的牌",
	["sheshi"] = "蛇噬",
	[":sheshi"] ="主动技，当你每受到1次伤害，可以指定1种花色，依次展示牌堆顶的牌，直到出现指定花色的牌为止，你获得与指定花色不同花色的所有牌（最多展示4张）。",
	["#Sheshi"] = "%from 选择了 <font color='yellow'><b>%arg</b></font> 花色",
	["seyou1"] = "对【埃及艳后】指定的角色使用一张杀",
	["seyou2"] = "交给【埃及艳后】一张手牌或装备区的牌",
	["seyouslash"] = "请对其使用一张杀，否则将交给【埃及艳后】一张手牌或装备区的牌",
	["$seyou1"] = "我！漂亮吗？",
	["$seyou2"] = "无",
	["$sheshi1"] = "你以为美女就没有獠牙和毒鬣！？",
	["$sheshi2"] = "无",
	["~aijiyanhou"] = "男人真是肤浅的生物。",

	--贞德
	["zhende"] = "贞德",
	["#zhende"] = "圣女",
	["tongfu"] = "同福",
	[":tongfu"] ="主动技，出牌阶段，你可以选择以下操作中的一项：（1）与场上一名角色形成【镜像】状态，该角色装备区等同于你的装备区，同时该角色原装备无法使用。（场上有角色处于【镜像】状态时，不能发动）；（2）弃掉一张手牌或装备区的牌，取消【镜像】状态",
	["shengnv"] = "圣女",
	[":shengnv"] ="主动技，当你每受到1次伤害，你可以展示1张手牌，对你造成伤害的角色须弃掉1张与此牌颜色不同的手牌，否则你回复1点血量。",
	["#Jingxiangbegin"] = "%from 与 %to 达成<font color='yellow'><b>【镜像】</b></font>状态",
	["#Jingxiangend"] = "%from 与 %to 解除了<font color='yellow'><b>【镜像】</b></font>状态",
	["@jingxiang"] = "镜像",
	["@shengnv_discard1"] ="请您弃置一张【红色】手牌，否则【贞德】将回复一点血量",
	["@shengnv_discard2"] ="请您弃置一张【黑色】手牌，否则【贞德】将回复一点血量",
	["$tongfu1"] = "上帝赐于我的，同样赐于你！",
	["$tongfu2"] = "无",
	["$shengnv1"] = "圣光引领我们前进。",
	["$shengnv2"] = "无",
	["~zhende"] = "圣主之光不会熄灭。",

	--织田信长
	["zhitianxinzhang"] = "织田信长",
	["#zhitianxinzhang"] = "第六天魔王",
	["yewang"] = "野望",
	[":yewang"] ="被动技，出牌阶段，你所有的【杀】造成的伤害均为血量流失",
	["buwu"] = "布武",
	[":buwu"] ="主动技，回合结束阶段，你可以指定除你外的任意两名角色，本轮内被指定角色在其出牌阶段内使用【杀】时，你可以弃掉1张手牌。令该角色可多使用1张【杀】。且若此【杀】为红色，你从牌堆摸1张牌。",
	["#Yewang"] = "%from 的被动技<font color='yellow'><b>【野望】</b></font>被触发，%to 受到的 %arg 点伤害改为了血量流失",
	["@buwu"] = "%src 对 %dest 使用了【%arg(%2arg花色)】，你可以弃置一张手牌发动【布武】",
	["$yewang1"] = "第六天魔王。",
	["$yewang2"] = "无",
	["$buwu1"] = "天下布武",
	["$buwu2"] = "无",
	["~zhitianxinzhang"] = "光秀，你……",

	--明成皇后
	["mchh"] = "明成皇后",
	["#mchh"] = "闵妃",
	["tiewan"] = "铁腕",
	[":tiewan"] ="主动技，其他角色使用【画地为牢】时，你可以选择1张红色手牌或装备区的牌当作【画地为牢】立即使用",
	["chajue"] = "察觉",
	[":chajue"] ="被动技，回合外，每当你受到伤害后，直到你的回合开始阶段，【杀】造成的伤害和非延时锦囊对你无效。",
	["tiewan_card"] = "您可以选择1张红色手牌或装备区的牌当作【画地为牢】立即打出",
	["#ChajueDamaged"] = "%from 受到了伤害，在其回合开始前<font color='yellow'><b>【杀】</b></font>和非延时锦囊都将对其无效",
	["#ChajueAvoid"] = "%from 的被动技<font color='yellow'><b>【察觉】</b></font>被触发，<font color='yellow'><b>【杀】</b></font>和非延时锦囊对其无效",
	["$tiewan1"] = "大韩民族发明的！",
	["$tiewan2"] = "无",
	["$chajue1"] = "啊！~~~~思密达！",
	["$chajue2"] = "无",
	["~mchh"] = "难道我死于癌症？！",

	--南丁格尔
	["ndge"] = "南丁格尔",
	["#ndge"] = "提灯女神",
	["huli"] = "护理",
	[":huli"] ="主动技，出牌阶段，你可以弃掉一张【药】，令场上除你外的任意一名角色回复1点血量。",
	["yxyixin"] = "医心",
	[":yxyixin"] ="主动技，出牌阶段，你可以弃掉2张手牌或装备区的牌指定任意一名角色，为该角色恢复x点血量，然后该角色摸4-x张牌（x的值由玩家自己决定，最大为4，最小为0，每局限用一次）。",
	["xianqu"] = "先驱",
	[":xianqu"] ="被动技，点数小于8的【杀】造成的伤害对你无效（不包括8）。",
	["#Xianqu"] = "%from 的被动技<font color='yellow'><b>【%arg】</b></font>被触发，%arg2 造成的伤害对其无效",
	["$huli1"] = "息心的护理，才能真正避免疾病流行。",
	["$huli2"] = "无",
	["$yxyixin1"] = "我来照顾你吧！",
	["$yxyixin2"] = "无",
	["$xianqu1"] = "习惯就好。",
	["$xianqu2"] = "无",
	["~ndge"] = "到此为止了吗？",

	--斯巴达克斯
	["sibada"] = "斯巴达克斯",
	["#sibada"] = "奴隶英雄",
	["jiasuo"] = "枷锁",
	[":jiasuo"] ="主动技，回合开始阶段，你可以选择跳过本回合的出牌阶段，若如此做，你获得1个【枷锁】标记，你每有一个【枷锁】标记，手牌上限加1（最多可累计2个）。",
	["zaofan"] = "造反",
	[":zaofan"] ="主动技，出牌阶段，当你出【杀】或【决斗】时。你可以弃掉一个【枷锁】标记，若如此做，该【杀】或【决斗】造成的伤害+1。",
	["#ZaofanBuff"] = "%from 的<font color='yellow'><b>【造反】</b></font>效果被触发，伤害从 %arg 点上升至 %arg2 点",
	["@jiasuo"] = "枷锁",
	["$jiasuo1"] = "我要践踏一切！",
	["$jiasuo2"] = "无",
	["$zaofan1"] = "我渴望自由！",
	["$zaofan2"] = "无",
	["~sibada"] = "为了自由，我愿意付出我的生命！",

	--福尔摩斯
	["fems"] = "福尔摩斯",
	["#fems"] = "大侦探",
	["yanyi"] = "演绎",
	[":yanyi"] ="主动技，出牌阶段，你可以弃掉一张黑色手牌或装备区的牌，指定一名角色和一种花色，被指定的角色的手牌中含有此花色，则受到一点伤害。",
	["jiean"] = "结案",
	[":jiean"] ="主动技，每当你使用【演绎】技能造成伤害后，你可以摸x张牌。并以任意数量分配给任意角色。（x为被【演绎】技能造成伤害的角色当前已损失的血量值）。",
	["#Yanyi"] = "%from 推测了 <font color='yellow'><b>%arg</b></font> 花色",
	["#Yanyi2"] = "%from 的手牌中，没有 <font color='yellow'><b>%arg</b></font> 花色",
	["$yanyi1"] = "你是在看，而我是在观察！",
	["$yanyi2"] = "无",
	["$jiean1"] = "案情终于明朗了",
	["$jiean2"] = "无",
	["~fems"] = "我判断错了吗？",

	--民·罗宾汉
	["min_luobinhan"] = "民·罗宾汉",
	["#min_luobinhan"] = "侠盗",
	["xiadao"] = "侠盗",
	[":xiadao"] ="主动技，当你装备区无装备时，你所有手牌可以视为【闪】。",
	["zhangyi"] = "仗义",
	[":zhangyi"] ="主动技，弃牌阶段，你可以选择将弃牌中的【闪】交给任意其他角色（最多3张）。",
	["lingdao"] = "领导",
	[":lingdao"] ="主动技，出牌阶段，你可以给场上除自己外的任意一名角色1张手牌，并获取该角色1张装备区的牌，转换为【臣·罗宾汉】。",
	["$xiadao1"] = "想要的自己拿来！",
	["$xiadao2"] = "无",
	["$zhangyi1"] = "劫富济贫！",
	["$zhangyi2"] = "无",
	["$lingdao1"] = "不断奋起，直到羔羊变雄狮！",
	["~min_luobinhan"] = "别了，舍伍德！",

	--臣·罗宾汉
	["chen_luobinhan"] = "臣·罗宾汉",
	["#chen_luobinhan"] = "汉丁顿伯爵",
	["sheshu"] = "射术",
	[":sheshu"] ="被动技，你的【杀】无视距离。",
	["duobi"] = "躲避",
	[":duobi"] ="主动技，出牌阶段，你可以弃掉一张手牌或装备区的牌，转换为【民·罗宾汉】。",
	["$sheshu1"] = "看我百步穿杨！",
	["$sheshu2"] = "无",
	["$duobi1"] = "二十面相。",
	["$duobi2"] = "无",
	["~chen_luobinhan"] = "别了，舍伍德！",

}
