local pass_t = {
    ["pass_mode"]       = "猛将传模式",
    ["hero"]            = "主人翁",
    ["study"]           = "请选择要学习的技能",
    ["@rmb"]            = "元宝",
    ["@exp"]            = "经验",
    ["damage"]          = "伤害",

    ["baishi"]         = "拜师系统",
    [":baishi"]    = "在猛将传模式中，游戏开始时，你可以决定角色的性别和阵营，然后选择一名同性别同阵营的英雄作为师父，师父将传授您技能。",

    ["qianghua_s"]         = "强化：(当你使用的杀造成伤害时，有15%的几率伤害+1)：经验30",
    ["qianghua2_s"]         = "强化II（强化Lv）：(当你使用的杀造成伤害时，有30%的几率伤害+1)：经验80",
    ["yixin_s"]         = "医心：(当你使用的药或鸩回复血量时，有15%的几率额外回复一血)：经验30",
    ["yixin2_s"]         = "医心II（医心Lv）：(当你使用的药或鸩回复血量时，有30%的几率额外回复一血)：经验80",
    ["jingque_s"]         = "精确：(当你使用的杀指定目标时，有15%的几率目标无法闪避)：经验30",
    ["jingque2_s"]         = "精确II（当你使用的杀指定目标时，有30%的几率目标无法闪避)：经验80",
    ["fuhuo_s"]        = "复活：(整场游戏限用一次)：经验30",
    ["qiangshen_s"]          = "身强：(增加1点血量上限)：经验40",
    ["qiangshen2_s"]          = "身强II：(增加1点血量上限)：经验60",
    ["mashu_s"]         = "马术：(攻击距离+1)：经验15",
    ["xiangma_s"]         = "相马：(防守距离+1)：经验70",
    ["kezhi_s"]         = "克制：(手牌上限+1)：经验20",
    ["fenjin_s"]         = "奋进：(每关开始时和击败敌人后额外摸一张牌)：经验15",
    ["nuhou_s"]         = "二刀流：(每回合可以额外使用1张杀)：经验50",
    ["niepan_s"]         = "谪仙：(复活一次，整局游戏只可用一回)：经验70",
    ["cancel"]          = "取消",

    ["qianghua"]           = "强化",
    [":qianghua"]          = "当你使用的杀造成伤害时，有15%的几率伤害+1。",
    ["qianghua2"]           = "强化II",
    [":qianghua2"]          = "当你使用的杀造成伤害时，有30%的几率伤害+1。",

    ["yixin"]           = "医心",
    [":yixin"]          = "当你使用的药或鸩回复血量时，有15%的几率额外回复一血。",
    ["yixin2"]           = "医心II",
    [":yixin2"]          = "当你使用的药或鸩回复血量时，有30%的几率额外回复一血。",

    ["jingque"]           = "精确",
    [":jingque"]          = "当你使用的杀指定目标时，有15%的几率目标无法闪避。",
    ["jingque2"]           = "精确II",
    [":jingque2"]          = "当你使用的杀指定目标时，有30%的几率目标无法闪避。",

    ["qiangshen"]            = "身强",
    [":qiangshen"]           = " <b>被动技</b>,血量上限+1。",
    ["qiangshen2"]            = "身强II",
    [":qiangshen2"]           = " <b>被动技</b>,血量上限+2。",

    ["nuhou"]           = "二刀流",
    [":nuhou"]          = " <b>被动技</b>,每回合出杀次数+1。",
    ["fenjin"]          = "奋进",
    [":fenjin"]         = " <b>被动技</b>,每关开始时和击败敌人后额外摸一张牌。",
    ["kezhi"]           = "克制",
    [":kezhi"]          = " <b>被动技</b>,手牌上限+1。",

    ["#QianghuaBuff"] = "%from 的<font color='yellow'><b>【强化】</b></font>效果被触发，伤害从 %arg 点上升至 %arg2 点",
    ["#YixinPass"] = "%from 的<font color='yellow'><b>【医心】</b></font>效果被触发，额外回复一血",
    ["#Jingzhun"] = "%from 的<font color='yellow'><b>【精确】</b></font>效果被触发，%to 无法出闪响应",

    ["shibing"]            = "士兵",
    ["pijiang"]        = "裨将",
    ["pianjiang"]        = "偏将",
    ["shizu"]           = "步兵",
    ["gongshou"]        = "弓箭手",
    ["jianwei"]         = "剑卫",
    ["qibing"]          = "骑兵",
    ["shiwei"]           = "侍卫",
    ["renzhe"]           = "忍者",
    ["moushi"]          = "谋士",

    ["nan_p"]        = "男主人翁",
    ["nv_p"]        = "女主人翁",

    ["~shizu"] = "步兵·阵亡",
	["~gongshou"] = "弓手·阵亡",
	["~jianwei"] = "剑卫·阵亡",
	["~qibing"] = "骑兵·阵亡",
	["~shiwei"] = "侍卫·阵亡",
    ["~renzhe"] = "忍者·阵亡",
	["~moushi"] = "谋士·阵亡",

    ["shiqi"]           = "士气",
    [":shiqi"]          = "摸牌阶段开始时，你可以进行一次判定，若为红色则你获得此牌。",
    ["qianggong"]       = "强弓",
    [":qianggong"]      = "当你使用【杀】指定一名角色为目标后，以下两种情况，你可以令此【杀】不可被【闪】响应：1、你的血量值小于或等于1。2、你的攻击范围大于3。",
    ["pojia"]           = "破甲",
    [":pojia"]          = " <b>被动技</b>，你使用的黑色【杀】无视目标防具；红色【杀】被【闪】抵消时，可以立即对相同的目标再使用一张【杀】。",
    ["zhanshang_pass"]  = "战觞",
    [":zhanshang_pass"] = " <b>被动技</b>，当你成为【烽火狼烟】或【万箭齐发】的目标时，你摸一张牌。",
    ["qishu"]           = "骑术",
    [":qishu"]          = " <b>被动技</b>，当你计算与其他角色的距离时，始终-1，当其他角色计算与你的距离时，始终+1（已装备的马匹无效果）。",
    ["chenwen"]         = "沉稳",
    [":chenwen"]        = " <b>被动技</b>，当你没装备防具时，梅花的【杀】对你无效。",
    ["zhongzhuang"]     = "重装",
    [":zhongzhuang"]    = " <b>被动技</b>，当你受到一次伤害时，伤害值最多为1点。",
    ["yaoshuf"]          = "天变",
    [":yaoshuf"]         = "出牌阶段，你可以弃置一张黑桃手牌，令一名角色进行判定，若结果为黑色2-9，你对该角色造成1点普通伤害。每回合限一次。",
    ["jitian"]          = "祭天",
    [":jitian"]         = " <b>被动技</b>，当你受到一次【血杀】或血属性伤害前，摸X张牌（X等于伤害点数），然后伤害为0。",
    ["jitian"]          = "祭天",
    ["mojing"]          = "远古魔镜",
    ["jingmian"]          = "镜中魂",
    [":jingmian"]         = " <b>限制技</b>，你可以弃置一张牌复制主人翁的所有技能。",

    ["#ZhanshangPass"]  = "%from 的技能<font color='yellow'><b>【战觞】</b></font>效果被触发，从牌堆摸了1张牌",
    ["#Zhongzhuang"]    = "%from 的技能<font color='yellow'><b>【重装】</b></font>防止了 %arg 点伤害，减至1点",
    ["#Jitian"]         = "%from 的技能<font color='yellow'><b>【祭天】</b></font>防止了暗属性伤害并摸了等同于伤害值的手牌数",
    ["#GainRmb"]        = "%from 成功击败了 %to，获得了 %arg 个元宝 ，当前元宝数为 %arg2",
    ["#GainExp"]        = "%from 成功击败了 %to，获得了 %arg 点经验值 ，当前经验值为 %arg2",
    ["#CantGainExp"]    = "由于 %from 并非属于这个世界，因此无法获得元宝和经验值",
    ["#NextStage"]      = "%from 击败了所有敌人，来到了第<font color='yellow'><b>【%arg】</b></font>关",
    ["#LoadNextStage"]  = "读档成功！%from 来到了 <font color='yellow'><b>%arg2</b></font>\ 周目的第<font color='yellow'><b>【%arg】</b></font>关",
    ["#ResetPlayer"]    = "<font color='red'><b>进入了2周目，所有技能重置，并获得初始的50点经验值</b></font>",

    ["savefile"]        = "存档",
    ["read"]            = "读取存档",
    ["deletesave"]      = "删除存档",
    ["notread"]         = "重新开始",
    ["save"]            = "保存",
    ["notsave"]         = "不保存",
    ["different_skills"]    = "数据错误！\n技能不符\n（可能由于version不同造成）",
    ["unknown_lord"] = "数据错误！\n不允许的主公角色",
    ["except_maxhp"] = "数据错误！\n不允许的血量上限",

--items
    ["useitem"]         = "道具栏",
    [":useitem"]        = "使用你已获得的道具",
    ["passmodeitem"]    = "使用道具",

    ["#RewardGet"]      = "%from 因学习技能获得了道具 %arg",
    ["#ItemUnlock"]     = "<font color='red'><b>此道具暂未开放使用</b></font>",
    ["#ItemUsed"]       = "%from 使用了道具 %arg",

--shop
    ["shop"]                = "道具商店",

    ["jinchuangyao"]        = "金疮药：功效：回复一点血量。",
    ["daliwan"]       = "大力丸：功效回复两点血量。花费：25元宝",
    ["dahuandan"]   = "大还丹：功效：回复至血量上限并弃掉所有手牌，摸牌至血量上限。宝",
    ["menghanyao"]    = "蒙汗药：功效：摸两张牌然后指定一名角色跳过其一回合。",
    ["zhuanlonghu"]     = "转龙壶：功效：指定一名角色回复一点血量，你获得该角色所有手牌。",
    ["mapishangren"]    = "马匹商人：功效：弃掉所有角色的马，然后你摸等数量的牌。",

    ["buy"]                 = "道具购买",
    ["buy:jinchuangyao"]        = "金疮药：功效：回复一点血量。花费：30元宝",
    ["buy:daliwan"]       = "大力丸：功效回复两点血量。花费：50元宝",
    ["buy:dahuandan"]   = "大还丹：功效：回复至血量上限并弃掉所有手牌，摸牌至血量上限。花费：100元宝",
    ["buy:menghanyao"]    = "蒙汗药：功效：摸两张牌然后指定一名角色跳过其一回合。花费：50元宝",
    ["buy:zhuanlonghu"]     = "转龙壶：功效：指定一名角色回复一点血量，你获得该角色所有手牌。花费：150元宝",
    ["buy:mapishangren"]    = "马匹商人：功效：弃掉所有角色的马，然后你摸等数量的牌。花费：70元宝",

    ["sell"]                = "道具出售",
    ["sell:jinchuangyao"]       = "金疮药：功效：回复一点血量。卖出：18元宝",
    ["sell:daliwan"]      = "大力丸：功效：回复两点血量。卖出：30元宝",
    ["sell:dahuandan"]  = "大还丹：功效：回复至血量上限并弃掉所有手牌，摸牌至血量上限。卖出：60元宝",
    ["sell:menghanyao"]   = "蒙汗药：功效：摸两张牌然后指定一名角色跳过其一回合。卖出：30元宝",
    ["sell:zhuanlonghu"]    = "转龙壶：功效：指定一名角色回复一点血量，你获得该角色所有手牌。卖出：90元宝",
    ["sell:mapishangren"]   = "马匹商人：功效：弃掉所有角色的马，然后你摸等数量的牌。卖出：42元宝",
}

for k, v in pairs(pass_t) do
    local ks = k:split("_")
    if not k:find(":") and #ks > 1 and ks[2] == "pass" then
        pass_t[ks[1]..ks[2]] = pass_t[k]
    end
end

return pass_t
