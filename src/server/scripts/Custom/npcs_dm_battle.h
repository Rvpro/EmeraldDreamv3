/*******************************************************************************************
*						 __                           __ _   							   *
*					  /\ \ \___  _ __ ___  ___  ___  / _| |_ 							   *
*					 /  \/ / _ \| '_ ` _ \/ __|/ _ \| |_| __|							   *
*					/ /\  / (_) | | | | | \__ \ (_) |  _| |_ 							   *
*					\_\ \/ \___/|_| |_| |_|___/\___/|_|  \__|	- www.Nomsoftware.com -	   *
*                               The policy of Nomsoftware states: Releasing our software   *
*                               or any other files are protected. You cannot re-release    *
*                               anywhere unless you were given permission.                 *
*                           (C) Nomsoftware 'Nomsoft' 2011-2012. All rights reserved.      *
********************************************************************************************/
/**********************************************************
**********************************************************
 *                      Title:                          *
  *            NPC Arena Battle(Dire Maul)             *
   *                                                  *
    *             Idea by: QQrofl                    *
	 *            Sub-Ideas by: Foereaper           *
	  *            Scripted by: QQrofl             *
	   *      		Fondled by: Faded	          *
	    *    Mental Support by: Foereaper        *
	     *    							        *
		  *   (C)Nomsoftware 'Nomsoft' 2012    * 
		   *##################################*#####################*
		   *        MAIN SPAWN                                      *
		   *	Arena Commander:                                    *
		   *	-3815.866699f, 1102.770874f, 132.355194f, 6.182988f *
		   *########################################################*/
#include "ScriptPCH.h"
using namespace std;

/* Player */
uint64 m_PlayerGUID;
string playerName;
/* Is Active */
bool isBattleActive = false;
bool hasLogged = false;
bool inZone = true;
/* Is Bosses Dead */
int isWaveBossDead = 0;

#define MSG_FIGHT_COMPUTER "I would like to fight!"

enum Events
{
	EVENT_NONE,
	EVENT_CHECK_ACTIVITY, // Check Activity of the battle : if true or false ? can start?
	EVENT_CHECK_WAVES, // Checks the waves so it can move on to the next event, if it is allowed
	EVENT_CHECK_PLAYER,
	EVENT_FIRST_WAVE,
	EVENT_FIRST_WAVE_TREAT,
	EVENT_FIRST_WAVE_ELITE,
	EVENT_SECOND_WAVE,
	EVENT_SECOND_WAVE_TREAT,
	EVENT_SECOND_WAVE_ELITE,
	EVENT_FINAL_WAVE_BOSS,
    EVENT_COMPLETED_WAVES,
};

enum bPhases
{
	/* Final Boss Phases */
	PHASE_START_COMBAT,
	PHASE_END,
};

enum SpellIds
{
	/* First Wave Spells */
	/* Red Blood Guard */
	SPELL_BERSERKER_CHARGE = 38907,
	SPELL_MORTAL_STRIKE = 68783,
	SPELL_DEEP_WOUNDS = 23256,
	/* First Wave Treat Spells */
	SPELL_ROOT_AURA = 43956,
	/* First Wave Elite Spells */
	/* `- Spore Healer */
	SPELL_HEAL_REGROWTH = 48443, //heal+H.O.T.
	SPELL_HEAL_NORMAL = 48378, //heal normal
	SPELL_HEAL_REJUV = 48441, //H.O.T.
	SPELL_HEAL_AURA_HOTS = 38299, // Aura hots
	SPELL_FLASH_HEAL = 48071,
	SPELL_POWER_WORD_SHIELD = 20697, // Absorbs a ton of damage
	SPELL_HEAL_LIFEBLOOM = 67958,
	/* `- Hank the Tank */
	SPELL_BATTLE_STANCE = 2487, //warrior bstance
	SPELL_SHOUT_BUFF = 47436,	//attk pwr self buff
	SPELL_TANK_CHARGE = 11578,	//warrior charge
	SPELL_GROUND_STOMP = 47502, //thunderclap
	SPELL_EXECUTE = 47471,		//normal strike
	SPELL_TANK_STRIKE = 47450,	//normal strike
	SPELL_INCREASE_BLOCK_VALUE = 67515, // Increases block value
	SPELL_SHIELD_BLOCK = 69580, // Blocks attacks
	SPELL_INCREASE_DEFENSE_RATING = 60343, // Increases Defense by 180+
	SPELL_INCREASE_DODGE_RATING = 18062, // Increase dodge by 96
	SPELL_REND = 47465, // Rends the target ~Bleeds
	SPELL_SHIELD_BASH = 47488, // Bashes the target with a shield
	/* Second Wave Spells */
	SPELL_ROGUE_STEALTH = 1784,
	SPELL_ROGUE_CHEAP_SHOT = 1833, //in stealth only
	SPELL_ROGUE_STRIKE = 48660,
	SPELL_ROGUE_FINISHER = 48668,
	SPELL_ROGUE_VANISH = 26889, //idea here is to make the sidekicks(and main?) vanish in/out of the fight
	SPELL_ROGUE_KICK = 27814,
	SPELL_ROGUE_BACKSTAB = 52540,
	SPELL_ROGUE_RUPTURE = 48672,
	SPELL_ROGUE_KIDNEY_SHOT = 41389,
	/* Second Wave Treat Spells */
	SPELL_UNHOLY_BONE_SHIELD = 49222,
	SPELL_UNHOLY_AOE = 49938,
	SPELL_UNHOLY_PLAGUE_STRIKE = 49921,
	SPELL_UNHOLY_STANGULATE = 47476,
	SPELL_UNHOLY_DEATH_STRIKE = 49924,
	SPELL_UNHOLY_ARMY = 42650, // <- should happen with both NPC's simultaneously
	SPELL_ENRAGE = 59707,
	/* Second Wave Elite Spells */
	/*	`- Rider Brutes	*/
	SPELL_RIDERS_LIGHTNING = 59159, // aoe
	SPELL_RIDERS_CHAIN_LIGHTNING = 49269, // aoe
	SPELL_RIDERS_MOONFIRE = 48463,
	SPELL_RIDERS_STORM = 48467, // aoe
	/*	`- Rider Healer	*/
	SPELL_RIDERS_STAM_BUFF = 48161, // fortitude buff
	SPELL_RIDERS_SHIELD = 48066, // absorbs damage
	SPELL_RIDERS_HEALING_BOLT = 66097,
	SPELL_RIDERS_RENEW = 48068,
	SPELL_RIDERS_GREATER_HEAL = 48063,
	/* Final Wave Boss Spells */
	SPELL_DRAGON_FIRE_SHIELD = 57108, //Reduces damage by 95% for 5s
	SPELL_DRAGON_ENGULF = 74562,
	SPELL_DRAGON_BREATH = 74525,
	SPELL_DRAGON_TAIL_WHIP = 74531,
	SPELL_DRAGON_BERSERK = 26662,
	SPELL_DRAGON_CLAW = 74524,
	SPELL_DRAGON_MASSIVE_FLAMESTRIKE = 26558,
	//SPELL_DRAGON_FIREBALL_BARRAGE = 37541,
	/* Others */
	SPELL_TELEPORT_VISUAL = 64446,
	/* Disable Class Spells */
	SPELL_VANISH_1 = 1856,
	SPELL_VANISH_2 = 1857,
	SPELL_VANISH_3 = 26889,
};

enum SpawnIds
{
	/* First Wave */
	NPC_RED_BLOOD_GUARD =         88001,
	NPC_RED_BLOOD_GUARD_MINI =    88002,
	NPC_RED_BLOOD_GUARD_MINI2 =   88003,
	NPC_RED_BLOOD_GUARD_MINI3 =   88004,
	/* First Wave Treat */
	NPC_WAVE_SPAWN_TRIGGER =      88500,
	NPC_GARM_WATCHER       =      80050,
	NPC_FRIGID_PROTO_DRAKE =      80051,
	NPC_OSTERKILGR         =      80052,
	NPC_BLIGHT_FALCONER    =      80053,
	NPC_CONVERTED_HERO     =      80054,
	NPC_PORTAL =                  88501,
    /* First Wave Elite */ 					/* NPC : Display ID */
	NPC_HANK_THE_TANK  =		  88011,	// Tank: 27930 Paladin Tank BE
	NPC_FIELD_MEDIC  =			  88012,	// Healer: 17544 Spore thing
	/* Second Wave */
	NPC_ROGUE_INITIATE = 		  88013, // Main rogue: 24918
	NPC_ROGUE_INITIATE_1 =		  88014, // Sidekick(easier to kill): 24919
	NPC_ROGUE_INITIATE_2 = 		  88015, // Sidekick(easier to kill): 24919
	/* Second Wave Treat */
	NPC_THE_UNHOLY = 			  88016, // Main: 25446
	NPC_THE_UNHOLY_TWIN = 		  88017, // Twin: 25496
	NPC_THE_UNHOLY_PET = 		  88018, // Their Pet: 25467 (no spells, normal attacks just to occupy the player) Maybe just SPELL_PET_BITE ?
	/* Second Wave Elite */
	NPC_RIDERS_OFTHE_ICE =	 	  88019, // Main/Healer: 25083
	NPC_RIDERS_OFTHE_ICE_1 =	  88020, // Brute: 25082
	NPC_RIDERS_OFTHE_ICE_2 = 	  88021, // Brute: 25082
	/* Final Wave Boss */
	NPC_DRAGON_BOSS = 			  88022, // Dragon: 25015
	NPC_DRAGON_BOSS_TRIGGER =     88023,
	GOBJECT_DRAGON_BOSS_RUNE =    183036,
};

enum eEnums
{
	ITEM_INTRAVENOUS_HEALING_POTION = 44698, // You can change the items they can heal with here
	DIRE_MAUL_ZONE = 2557,
	DIRE_MAUL_AREA = 357, //3217,
	PVP_END_TOKEN = 47241, // You can easily change this
	SOUND_HORN_WAVE_START = 7054,
	SOUND_WAVE_COMPLETE = 8571,
};

struct DragonMove
{
	uint32 gobject;
	uint32 spellId;
	float x, y, z, o;
};

uint32 spellDisables[] = { SPELL_VANISH_1, SPELL_VANISH_2, SPELL_VANISH_3 };

static Position sTeleOut[] = 
{
	{ -4286.56f, 1330.970f, 161.21f, 0.019994f }
};

static DragonMove sMoveData[] =
{
	{GOBJECT_DRAGON_BOSS_RUNE, SPELL_DRAGON_MASSIVE_FLAMESTRIKE, -3786.241943f, 1096.538452f, 153.903366f, 6.257603f }
};

#define MAX_WAVE_SPAWN_LOCATIONS 20
const uint32 waveList[MAX_WAVE_SPAWN_LOCATIONS] =
{
	   /* First Wave Ids */
	   NPC_RED_BLOOD_GUARD,
	   /* First Wave Treat Ids */
	   NPC_WAVE_SPAWN_TRIGGER, NPC_GARM_WATCHER, NPC_FRIGID_PROTO_DRAKE, NPC_OSTERKILGR, NPC_BLIGHT_FALCONER, NPC_CONVERTED_HERO, NPC_PORTAL,
	   /* First Wave Elite Ids */
	   NPC_HANK_THE_TANK, NPC_FIELD_MEDIC,
	   /* Second Wave Ids */
	   NPC_ROGUE_INITIATE, NPC_ROGUE_INITIATE_1, NPC_ROGUE_INITIATE_2,
	   /* Second Wave Treat Ids */
	   NPC_THE_UNHOLY, NPC_THE_UNHOLY_TWIN, NPC_THE_UNHOLY_PET,
	   /* Second Wave Elite Ids */
	   NPC_RIDERS_OFTHE_ICE, NPC_RIDERS_OFTHE_ICE_1, NPC_RIDERS_OFTHE_ICE_2,
	   /* Final Wave Boss */
	   NPC_DRAGON_BOSS,
};

static Position m_WaveSpawns[] =
{
	/*    X               Y            Z           O      */
	             /* All Waves Spawns */
	{ -3756.859863f, 1097.575317f, 131.969559f, 6.159780f },
	             /* First Wave Treat */
	{ -3760.98f, 1082.98f, 131.96f, 0.214342f }, // Portal 1 Location
	{ -3751.31f, 1106.84f, 131.96f, 5.364266f }  // Portal 2 Location
};

void DoGivePlayerSpells(Player * player)
{
	switch(player->getClass())
	{
		case CLASS_ROGUE:
			for(int i = 0; i < 3; i++)
				if(player->getLevel() >= 24 && !player->HasSpell(spellDisables[i]))
					player->learnSpell(spellDisables[i], true);
			break;
	}
}

void MessageOnWave(Creature * me, uint32 eventId)
{
	stringstream ss;
	switch(eventId)
	{
	   case EVENT_CHECK_ACTIVITY: // Before Wave 1 starts
		   ss << playerName.c_str()
			  << " приготовься! Следующая волна через 10секунд.";
		   break;

	   case EVENT_CHECK_WAVES:
		   {
			   if( isWaveBossDead == 1)
			   {
				   ss << "Я не могу в это поверить "
					  << playerName.c_str()
					  << " убил кровавого стража! Посмотрим на следующую волну, которая будет через 25 секунд!";
			   }
			   else if (isWaveBossDead == 2)
			   {
				   ss << "Это нереально! "
					  << playerName.c_str()
					  << " уничтожил волну! Следующая будет через 35секунд, приготовьтесь!";
			   }
			   else if (isWaveBossDead == 3)
			   {	
				   ss << "Вот дерьмо! "
					  << playerName.c_str()
					  << " раскрошил элиту! Удачи с остальными... Следующая волна через 25секунд!";
			   }
			   else if (isWaveBossDead == 4)
			   {
				   ss << "Превосходно! "
					  << playerName.c_str()
					  << " пнул разбойников под зад! 35 секунд на подготовку к следующей волне!";
			   }
			   else if (isWaveBossDead == 5)
			   {
				   ss << "Я не могу поверить в то, что я вижу! "
				      << playerName.c_str()
					  << " победил Нечистивых братьев, Эпичная победа! Следующая волна через 40 секунд, приготовьтесь!";
			   }
			   else if (isWaveBossDead == 6)
			   {
				   ss << "Невероятно "
				      << playerName.c_str()
					  << " снова победил. Хорошая работа! Финальная волна через 35 секунд, лучше поискать какие нибудь баффы!";
			   }
			   else if (isWaveBossDead == 7)
			   {
				   ss << "Минута молчания.... "
				      << playerName.c_str()
					  << " закончил испытание. Мои поздравления!";
			   }
		   }break;

	   case EVENT_FIRST_WAVE:
		   ss << "Первая волна началась!"
			  << " Из кровавых пучин ада," 
			  << " Арена мастер, Кровавый защитник!";
		   break;

	   case EVENT_FIRST_WAVE_TREAT:
		   ss << "Очередная волна!"
			  << " Путешествуя по континентам ты встретишь много врагов!";
		   break;

	   case EVENT_FIRST_WAVE_ELITE:
		   ss << "Первая волна Элиты!"
			  << " Скажи свои последнии слова, другого шанса у тебя уже не будет!"
			  << " На арену входят любители ПвЕ, Тива и его любимый Танк!";
		   break;
		  
	   case EVENT_SECOND_WAVE:
		   ss << "И снова наши чемпионы"
			  << " Поверь твоим глазам, ты не ослеп, это смертоносные враги"
			  << " Быстрые и незаметные. Разбойники убийцы, может быть сдашься?";
		   break;
	   
	   case EVENT_SECOND_WAVE_TREAT:
		  ss << "Братья появились!"
		     << " Из другого мира, они пришли, чтобы выполнить свою работу"
			 << " Двое смертоносных, приготовься умереть!";
		   break;
	   
	   case EVENT_SECOND_WAVE_ELITE:
		  ss << "Очередные путники"
		     << " Ледяные наездники входят на Арену!"
			 << " Не смейся над их размером, они растопчат тебя!";
		   break;
		   
	   case EVENT_FINAL_WAVE_BOSS:
		  ss << "Из глубин земли "
		     << " здесь потребуется совсем другой уровень подготовки. "
			 << " Приготовься! Дракон Арены уже здесь!";
		   break;
	}
	me->MonsterYell(ss.str().c_str(), LANG_UNIVERSAL, me->GetGUID());
}

void DoSendCompleteMessage(string who)
{
	stringstream ss;
	ss << who.c_str()
		<< " стал победителем Арены!"
		<< "Она теперь открыта и ждёт новых желающих!";
	sWorld->SendGlobalText(ss.str().c_str(), NULL);
}

void AddEndRewards(Player * player, uint32 honoramount, uint32 tokenId, uint32 tokenAmount)
{
	uint32 curHonor = player->GetHonorPoints();
	player->SetHonorPoints(curHonor + honoramount);
	ChatHandler(player).PSendSysMessage("Добавлено %u чести!", honoramount);
	player->AddItem(tokenId, tokenAmount);
}