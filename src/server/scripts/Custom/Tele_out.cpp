#define RANGE_DISTANCE 100.0f
#define MAPID 0

struct Position2d
{
	float x, y, z, o;
};

static Position2d m_teleport[1] =
{
  { -13246.55f, 194.03f, 31.00f, 1.09f }
};

class Tele_Trigger : public CreatureScript
{
  public:
          Tele_Trigger() : CreatureScript("Tele_Trigger") { }
 
          struct Tele_TriggerAI : public ScriptedAI
          {
                  Tele_TriggerAI(Creature * pCreature) : ScriptedAI(pCreature)
                  {
                       me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                       me->SetFloatValue(OBJECT_FIELD_SCALE_X, 0);
                  }
 
                  void MoveInLineOfSight(Unit * who)
                  {
                          if(!who || (!who->isAlive()) && who->GetTypeId() != TYPEID_PLAYER)
                                  return;
 
                          if(me->IsWithinDistInMap(who, RANGE_DISTANCE))
                          {
                              if(me->GetDistance(who) <= RANGE_DISTANCE)
							  {
 
                                    if(who->ToPlayer()->GetSession()->GetSecurity() == SEC_PLAYER)
									{
                                      me->MonsterSay("You cannot be up here!", LANG_UNIVERSAL, who->GetGUID());      
                                      who->ToPlayer()->TeleportTo(MAPID, m_teleport[0].x, m_teleport[0].y, m_teleport[0].z, m_teleport[0].o);
									}
									else
									{
                                        // We don't want to kick GameMasters off of there.
									}
							  }
						  }
                  }
          };
 
          CreatureAI * GetAI(Creature * c) const
          {
                  return new Tele_TriggerAI(c);
          }
};

void AddSC_npc_tele_trigger()
{
   new Tele_Trigger();
}
