-- translation for Basaltic Package

return {
	["douhun"] = "斗魂包",

	--人物
	--魂·貂蝉
	["hun_diaochan"] = "魂·貂蝉",
	["#hun_diaochan"] = "倾国倾城",
	["fengyi"] = "凤仪",
	[":fengyi"] = "主动技，你掉血后可以进行一次判定，如果不是红桃，则伤你的角色必须立即进入弃牌阶段",
	["wange"] = "婉歌",
	[":wange"] = "主动技，摸牌时，你可以少摸一张牌，则回合结束时你可以抽取一名其他角色的手牌，至多X张。（X为你当前的掉血量）",
	["kuixin"] = "窥心",
	[":kuixin"] = "被动技，你的判定牌生效后立即收入手牌",

    ["$fengyi1"] = "有凤来仪~",
	["$wange1"] = "焚香一拜月羞藏，娇语三声百草香。",
	["$kuixin1"] = "心似比干多一窍，貌若西子胜三分",
	["~hun_diaochan"] = "冬日之蝉，岂待来年~",

	--魂·林冲
	["hun_linchong"] = "魂·林冲",
	["#hun_linchong"] = "落草教头",
	["zhongwu"] = "忠武",
	[":zhongwu"] = "被动技，每回合你出杀的数量等于1+你当前掉血量。每当你使用一张杀，立即摸一张牌",
	["xiedao"] = "携刀",
	[":xiedao"] = "被动技，你使用的红色【杀】不受距离限制。",

	["$zhongwu1"] = "我乃豹子头林冲是也！",
	["$zhongwu2"] = "吃我一枪！",
	["~hun_linchong"] = "实不该一忍再忍呐！",

	--魂·孙武
	["hun_sunwu"] = "魂·孙武",
	["#hun_sunwu"] = "兵圣",
	["kuidao"] = "诡道",
	[":kuidao"] = "主动技，当你受到伤害时，可以立即判定：红桃，你立即回复1点血；方块，指定任意角色摸两张牌；黑桃，指定任意角色掉1点血；梅花，指定任意角色弃两张牌",
	["zhijun"] = "治军",
	[":zhijun"] = "主动技，出牌时，可以弃一张手牌，指定任意目标摸两张牌。（每回合限用一次）",
	["xiongcai"] = "雄才",
	[":xiongcai"] = "被动技，你的手牌上限始终等于你的血量上限",

	["$kuidao1"] = "兵者，诡道也",
	["$zhijun1"] = "以近待远以逸待劳",
	["~hun_sunwu"] = "存亡之道不可不察也",

	--魂·曹操
	["hun_caocao"] = "魂·曹操",
	["#hun_caocao"] = "魏武帝",
	["xieling"] = "挟令",
	[":xieling"] = "主动技，出牌阶段，弃掉一张手牌或装备区的牌，将任意一名角色装备区或判定区的牌移动到另一名角色的对应区域里。（每回合限用一次）",
	["zhulu"] = "逐鹿",
	[":zhulu"] = "主动技，回合外，当有非延时锦囊牌结算完毕后，你可以立即弃掉一张相同花色手牌或装备区的牌获得这张锦囊。（每轮限用一次）",
	["@zhulu"] = "%src 使用的牌的花色为 %arg，您可以弃置与其相同花色的牌获得之",

	["$xieling1"] = "兵不厌诈！",
	["$zhulu1"] = "天下英雄唯使君与操尔~",
	["~hun_caocao"] = "谁来煮酒/头又痛起来了...",

	--魂·小乔
	["hun_xiaoqiao"] = "魂·小乔",
	["#hun_xiaoqiao"] = "秋水芙蓉",
	["xinchujia"] = "初嫁",
	[":xinchujia"] = "主动技，出牌阶段，可以弃掉两张相同颜色的手牌，指定任意角色摸X张牌。（X为该角色已损失的血量值）",
	["zhijie"] = "知节",
	[":zhijie"] = "主动技，出牌阶段，你的红桃花色的手牌可以视为【无中生有】使用。（每回合限用一次）",

	["$xinchujia1"] = "不要这样嘛~",
	["$xinchujia2"] = "你锁的住我的人，却锁不住我的心~",
	["$zhijie1"] = "玉容花貌，飘零几处？",
	["~hun_xiaoqiao"] = "桴鼓谢吴宫,铜雀春深千古恨.../都怪周郎死的早...",

	--魂·杨玉环
	["hun_yangyuhuan"] = "魂·杨玉环",
	["#hun_yangyuhuan"] = "华清贵妃",
	["yuxian"] = "羽仙",
	[":yuxian"] = "主动技，出牌时你可以弃一张牌指定场上一张装备牌或延时锦囊本轮不生效（每回合限用一次）",
	["nichang"] = "霓裳",
	[":nichang"] = "主动技，摸牌你可以选择不摸牌，回合结束时展示你的手牌，每缺少一种花色就摸一张牌。",
    ["$Yuxian"] = "%from 技能<font color='yellow'><b>【羽仙】</b></font>已触发，%to 的 %card 本轮不生效",
	["@yuxian1"] = "羽仙",
	["@yuxian2"] = "羽仙",
	["@yuxian3"] = "羽仙",
	["@yuxian4"] = "羽仙",
	["@yuxian5"] = "羽仙",
	["$yuxian1"] = "云想衣裳花想容，春风拂槛露华浓 ",
	["$nichang1"] = "霓裳一曲千峰上,舞破中原始下来",
	["~hun_yangyuhuan"] = "玉容寂寞泪阑干，梨花一枝春带雨...",

	--魂·张飞
	["hun_zhangfei"] = "魂·张飞",
	["#hun_zhangfei"] = "万人敌",
	["xintiaoxin"] = "挑衅",
	[":xintiaoxin"] = "主动技，摸牌阶段，你可以放弃摸牌，展示并获得牌堆顶的2张牌，若展示牌：\
（1）颜色不同，则本回合内你所有【杀】的伤害+1；\
（2）颜色相同，则本回合内你的所有手牌均可视为【杀】且无视距离。",
	["nuhe"] = "怒喝",
	[":nuhe"] = "主动技，当你使用的【杀】被目标角色闪避后，你可以弃掉该角色1张手牌或装备区的牌。",
	["$Xintiaoxin1"] = "展示牌颜色不同 %from 在本回合内使用的 <font color='yellow'><b>【杀】</b></font>造成的伤害+1",
	["$Xintiaoxin2"] = "展示牌颜色相同 %from 在本回合内所有手牌均可视为<font color='yellow'><b>【杀】</b></font>且无视距离",
	["#XintiaoxinBuff"] = "%from 的<font color='yellow'><b>【挑衅】</b></font>效果被触发，伤害从 %arg 点上升至 %arg2 点",
	["$xintiaoxin1"] = "待谋取尔首级!",
	["$nuhe1"] = "来吧!",
	["~hun_zhangfei"] = "唉，脾气是该收敛啦...",

	--魂·刘邦
	["hun_liubang"] = "魂·刘邦",
	["#hun_liubang"] = "横绝四海",
	["renwang"] = "人望",
	[":renwang"] = " 主动技，出牌阶段，你可以弃掉2张牌并指定1名手牌数大于你的角色，你摸牌至与该角色手牌数相等。（每回合限用一次）",
	["xinshiwei"] = "施威",
	[":xinshiwei"] = "主动技，当其他角色失去最后一张手牌时，你可以将牌堆顶的1张牌背面朝上置于该角色面前，该角色回合，跳过出牌阶段并弃掉这张牌。",
	["shiweicard"] = "施威",
	["$Shiwei"] = "%from 受到技能<font color='yellow'><b>【施威】</b></font>效果影响，将跳过本回合出牌阶段",
	["$renwang1"] = "豁达大度，从谏如流!",
	["$xinshiwei1"] = "帝王之道，审时度势，物尽其用~",
	["~hun_liubang"] = "横绝四海，当可奈何~/大汉的基业交付你们了...",

	--魂·墨子
	["hun_mozi"] = "魂·墨子",
	["#hun_mozi"] = "墨家始祖",
	["jieyong"] = "节用",
	[":jieyong"] = "主动技，出牌阶段，你可以使用1张红桃花色手牌当作任意非延时锦囊使用（每回合限用1次）。",
	["shangtong"] = "尚同",
	[":shangtong"] = "主动技，每当你令其他角色恢复1点血量或掉1点血时，你可以摸1张牌（摸牌上限为4）。",
	["enyuan"] = "非命",
	[":enyuan"] = "被动技，其他角色对你造成伤害时，该角色须选择1项执行：\
	（1）将1张红桃花色手牌交给你；\
	（2）流失1点血量。",
	["$Feiming"] = "%from 的被动技<font color='yellow'><b>【非命】</b></font>被触发， %to 须交给其一张红桃花色手牌，否则流失一点血量",
	["@enyuan"] = "您受到【非命】技能影响，请交给交给其一张<font color='yellow'><b>【红桃】</b></font>花色手牌，否则流失一点血量",
	["ndtrick"] = "非延时锦囊",
	["single_target"] = "单体锦囊",
	["multiple_targets"] = "群体锦囊",
	["$jieyong1"] = "兴天下之利，除天下之害~",
    ["$shangtong1"] = "别同异~",
	["$enyuan1"] = "明是非",
	["~hun_mozi"] = "赴汤蹈火，死不旋踵.....",

	--魂·狄仁杰
	["hun_direnjie"] = "魂·狄仁杰",
	["#hun_direnjie"] = "盛世功臣",
	["xinshenduan"] = "神断",
	[":xinshenduan"] = "主动技，出牌阶段，你可以弃掉1张牌，获得任意角色装备区或判定区内的1张牌。（每回合限用一次）",
	["zhaoxue"] = "昭雪",
	[":zhaoxue"] = "主动技，当你成为非延时锦囊的目标时，你可以弃掉一张牌，让该锦囊的目标变为任意一名角色。",
	["jianneng"] = "荐能",
	[":jianneng"] = "主动技，每当你获得牌并加入手牌时，你可以将这些牌中的1张分给任意角色。",
	["#Zhaoxue"] = "%from 使用技能<font color='yellow'><b>【昭雪】</b></font>将 %arg 的目标转移到了 %to",
	["$xinshenduan1"] = "此事非同小可，当明断之",
	["$zhaoxue1"] = "此事必有蹊跷",
	["$zhaoxue2"] = "你就是本案的凶手",
	["$jianneng1"] = "荐贤臣以固我大唐也",
	["~hun_direnjie"] = "百密一疏啊...../魂归白马~",

	--魂·鬼谷子
	["hun_guiguzi"] = "魂·鬼谷子",
	["#hun_guiguzi"] = "王禅老祖",
	["baihe"] = "捭阖",
	[":baihe"] = "主动技，出牌阶段，你可以弃掉1张手牌或装备区的牌，选择以下1项执行（每回合限用一次）：（1）横置1名未处于【连横】状态的角色，该角色从牌堆顶摸1张牌;（2）重置1名处于【连横】状态的角色，该角色弃掉1张手牌。",
	["yinyang"] = "阴阳",
	[":yinyang"] = "主动技，出牌阶段，你可以弃掉2张手牌选择3名角色，分别横置或重置这些角色（每回合限用1次）。",
	["xiushen"] = "修身",
	[":xiushen"] = "被动技，回合结束阶段，若场上有角色处于【连横】状态，你从牌堆顶摸2张牌。",
	["$baihe1"] = "纵横捭阖~",
	["$yinyang1"] = "连起来~",
	["$xiushen1"] = "审时度势~",
	["~hun_guiguzi"] = "归去云梦山....",

	--魂·项羽
	["hun_xiangyu"] = "魂·项羽",
	["#hun_xiangyu"] = "长安侯",
	["hongmen"] = "鸿门",
	[":hongmen"] = "主动技，回合开始阶段，你可以指定除你外的1名角色从牌堆顶摸X张牌或最多弃掉X张手牌和装备区的牌（X为你已损失的血量）。",
	["guixiong"] = "鬼雄",
	[":guixiong"] = "主动技，你的黑色手牌可以当作【鸩】来使用。",
	["pofu"] = "破釜",
	[":pofu"] = "被动技，当你的血量值不满时，你使用【杀】和【决斗】的伤害+1。",
	["#PofuBuff"] = "%from 的<font color='yellow'><b>【破釜】</b></font>效果被触发，伤害从 %arg 点上升至 %arg2 点",
	["@hongmen"] = "鸿门",
	["hongmen1"] = "该角色从牌堆顶摸X张牌",
	["hongmen2"] = "该角色弃掉X张牌",
	["$hongmen1"] = "舍我其谁!",
	["$pofu1"] = "看我横扫千军！",
	["~hun_xiangyu"] = "力拔山兮气盖世，时不利兮骓不逝...../四面楚歌啊",

	--卡牌
	--基本牌
	["an_slash"] = "暗杀",
	[":an_slash"] = "基本牌，出牌阶段，对除你外，你攻击范围内的一名角色使用，若目标无法闪避，你对目标角色造成的伤害为血量流失。",

	["xue_slash"] = "血杀",
	[":xue_slash"] = "基本牌，出牌阶段，对除你外，你攻击范围内的一名角色使用，若目标无法闪避，对目标角色造成伤害后，使用者回复等量的血量。",

	["zhendu"] = "鸩",
	[":zhendu"] = "基本牌，出牌阶段，对自己使用，流失1点血量，则该出牌阶段，你的【杀】造成的伤害+1；弃牌阶段：弃入弃牌堆，流失1点血量；濒死时：回复1点血量。",
	["#Drank2"] = "%from 使用了<font color='yellow'><b>【鸩】</b></font>，本回合使用的<font color='yellow'><b>【杀】</b></font>将具有伤害 <font color='yellow'><b>+1</b></font> 的效果",
	["#UnsetDrank2"] = "%from 的<font color='yellow'><b>【杀】</b></font>结算完毕，<font color='yellow'><b>【鸩】</b></font>效果消失",
	["#UnsetDrankEndOfTurn2"] = "%from 的回合结束，<font color='yellow'><b>【鸩】</b></font>效果消失",
	["$ZhenduLostHp"] = "%from 弃掉了 %card, 将流失1点血量力",
	["#ZhenduBuff"] = "%from 喝了<font color='yellow'><b>【%arg】</b></font>，对 %to 造成的杀伤害 +1",

	["fuzhou"] = "符",
	[":fuzhou"] = "基本牌，你可以将此牌当任意基本牌来使用或打出。",

	--锦囊牌
	["jueliangmoxing"] = "绝粮莫兴",
	[":jueliangmoxing"] = "锦囊牌，出牌阶段，对与你距离为1的一名角色使用，将【绝粮莫兴】横置于该角色的判定区。【绝粮莫兴】在该角色摸牌前开始判定：如果不是梅花，则不能摸牌。",

    ["hezhonglianheng"] = "合纵连横",
	[":hezhonglianheng"] = "锦囊牌，出牌阶段，对任意角色使用，连横：选择一至两名角色使用，分别横置或重置这些角色，被横置的角色处于“连横”状态。当有一名角色受到【杀】的伤害时，其他处于“连横”状态的角色也将受到等额的伤害。合纵：你可以立即摸一张牌。",

    ["toulianghuanzhu"] = "偷梁换柱",
	[":toulianghuanzhu"] = "锦囊牌，出牌阶段，对任意两名角色使用，先指定的角色用一张手牌和后指定的角色的两张手牌交换。",
	["huanpai"] = "换牌",

	["geanguanhuo"] = "隔岸观火",
	[":geanguanhuo"] = "锦囊牌，出牌阶段，对任意两名角色使用，指定任意两名角色进行拼点，拼点输的一方掉1点血；若点数一样则使用该锦囊的角色掉1点血。拼点的牌不用丢弃。",
	["#Pindian"] = "%from 向 %to 发起了拼点",
	["$PindianResult"] = "%from 的拼点结果为 <font color='yellow'><b>%card</b></font>",
	["#PindianSuccess"] = "%from（对 %to）拼点成功",
	["#PindianFailure"] = "%from（对 %to）拼点失败",

	["shewoqishui"] = "舍我其谁",
	[":shewoqishui"] = "锦囊牌，除你外的其他角色成为【杀】和【决斗】的目标时使用，该角色使用的【杀】或【决斗】视为对你使用。（你不能是【杀】和【决斗】的使用者）",
	["@shewoqishui"] = "锦囊牌，除你外的其他角色成为【杀】和【决斗】的目标时使用，该角色使用的【杀】或【决斗】视为对你使用。（你不能是【杀】和【决斗】的使用者）",
	["#Shewo"] = "%from 使用的<font color='yellow'><b>【%arg】</b></font>效果被触发，%to 的<font color='yellow'><b>【%arg2】</b></font>视为对 %from 其使用",

	--装备牌
	["xue_sword"] = "饮血剑",
	[":xue_sword"] = "装备牌，攻击范围：2\
	武器特效：你可以将你的任意一张普通【杀】视为【血杀】来使用。",

	["kongqueling"] = "孔雀翎",
	[":kongqueling"] = "装备牌，攻击范围：4\
武器特效：你可以选择主动流失1点血量，本回合内你对其他角色使用的【杀】伤害+1。（与【鸩】的效果不可以叠加）。",
    ["#KongqueBuff"] = "%from 的<font color='yellow'><b>【孔雀翎】</b></font>效果被触发，伤害从 %arg 点上升至 %arg2 点",
	["#KongqueBuff2"] = "%from 的<font color='yellow'><b>【孔雀翎】</b></font>效果被触发，对 %to 造成的杀伤害 +1",

    ["jinlinjia"] = "金鳞甲",
	[":jinlinjia"] = "装备牌，防具特效：【烽火狼烟】和【万箭齐发】对你无效。当你失去装备区里的【金鳞甲】时，将恢复1点血。",

	["huxinjing"] = "护心镜",
	[":huxinjing"] = "装备牌，防具特效：抵消两点【杀】的伤害，当抵消第二点【杀】的伤害时，弃掉【护心镜】并弃1张手牌。",
	["#Huxinjing"] = "%from 的防具<font color='yellow'><b>【护心镜】</b></font>效果被触发，将 %arg 点伤害减至 <font color='yellow'><b> %arg2 </b></font> 点",

	["qiankundai"] = "乾坤袋",
	[":qiankundai"] = "装备牌，防具特效：手牌上限+1。当你失去装备区里的【乾坤袋】时，将摸取1张牌。",
}