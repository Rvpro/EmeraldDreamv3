--
-- Fixes only for YTDB
--

-- fix crash with use .gob near command and russian locale
UPDATE `trinity_string` SET `content_loc8` = '%d (Entry: %d) - |cffffffff|Hgameobject:%d|h[%s X:%f Y:%f Z:%f MapId:%d]|h|r' WHERE `entry` = '517';

-- Anub'arak, fix of incorrect YTDB flag
UPDATE `creature_template` SET `unit_flags` = 32832 WHERE `entry`IN (34564,34566,35615,35616);

-- fix crash with NPC 38068 cast spel (recursion)
UPDATE `creature_template` SET `ScriptName`="", `spell1`="" WHERE `entry` = 38068;

-- Fix start Valithria encounter while enconter is DONE
UPDATE `creature` SET `spawntimesecs` = 604800 WHERE `id` IN (38752, 16980);

-- Add lost data
DELETE FROM `creature` WHERE `guid` in (85584, 85585, 85586);
INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`) VALUES
(85584, 29836, 604, 3, 1, 0, 0, 1851.12, 743.221, 135.951, 3.1629, 7200, 0, 0, 45516, 0, 0, 0, 0, 0),
(85585, 29836, 604, 3, 1, 0, 0, 1874.55, 757.72, 136.039, 3.56345, 7200, 0, 0, 45516, 0, 0, 0, 0, 0),
(85586, 29836, 604, 3, 1, 0, 0, 1875.77, 726.76, 135.946, 2.61705, 7200, 0, 0, 45516, 0, 0, 0, 0, 0);

-- QUEST 9663 "The Kessel Run"
-- right gossip number for NPC
UPDATE `creature_template` SET `gossip_menu_id`=7983 WHERE `entry`=17440;
-- Smart AI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry` IN (17116,17240,17440);
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (17116,17240,17440);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17116,0,0,0,64,0,100,0,0,0,0,0,33,17116,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663'),
(17240,0,0,0,64,0,100,0,0,0,0,0,33,17240,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663'),
(17440,0,0,0,64,0,100,0,0,0,0,0,33,17440,0,0,0,0,0,7,0,0,0,0,0,0,0, 'On gossip hello credit for quest 9663');
-- Add Gossip menu items
DELETE FROM `gossip_menu` WHERE `entry`=7399 AND `text_id`=9038;
DELETE FROM `gossip_menu` WHERE `entry`=7983 AND `text_id`=8994;
DELETE FROM `gossip_menu` WHERE `entry`=7983 AND `text_id`=9039;
DELETE FROM `gossip_menu` WHERE `entry`=7370 AND `text_id`=9040;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES
(7399,9038),(7983,8994),(7983,9039),(7370,9040);
-- Gossip conditions
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup` IN (7399,7983,7370);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(14,7399,9038,0,9,9663,0,0,0,'','Show gossip text 9038 if player has quest 9663'),
(14,7983,9039,0,9,9663,0,0,0,'','Show gossip text 9039 if player has quest 9663'),
(14,7370,9040,0,9,9663,0,0,0,'','Show gossip text 9040 if player has quest 9663');

-- QUEST What The Dragons Know (horde & alliance)
-- right gossip number for NPC
UPDATE `creature_template` SET `gossip_menu_id`=10192 WHERE `entry`=26917;
UPDATE `creature_template` SET `gossip_menu_id`=10199 WHERE `entry`=27990;
DELETE FROM `gossip_menu_option` WHERE `menu_id`=10199;
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`,`action_poi_id`,`box_coded`,`box_money`,`box_text`) VALUES
(10199,0,0,'What do you know of ancient swords?',1,1,0,0,0,0,''),
(10199,1,0,'What do you know of ancient swords?',1,1,0,0,0,0,'');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10199;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10199,0,0,9,14444,0,0,0,'','Show gossip option 0 if player has quest 14444 (Alliance)'),
(15,10199,1,0,9,24555,0,0,0,'','Show gossip option 1 if player has quest 24555 (Horde)');
-- Smart AI
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=27990;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (27990,2799000,2799001);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27990,0,0,0,62,0,100,0,10199,0,0,0,80,2799001,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On gossip option select run script'),
(27990,0,1,0,62,0,100,0,10199,1,0,0,80,2799000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On gossip option select run script'),
-- horde quest script
(2799000,9,0,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn off Gossip & Questgiver flags'),
(2799000,9,1,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn of Gossip & Questgiver flags for Alexstrasza'),
(2799000,9,2,0,0,0,100,0,2000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 0'),
(2799000,9,3,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 1'),
(2799000,9,4,0,0,0,100,0,0,0,0,0,45,0,1,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos start path'),
(2799000,9,5,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 2'),
(2799000,9,6,0,0,0,100,0,4000,4000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 3'),
(2799000,9,7,0,0,0,100,0,4000,4000,0,0,1,0,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 0'),
(2799000,9,8,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 1'),
(2799000,9,9,0,0,0,100,0,4000,4000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 4'),
(2799000,9,10,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 2'),
(2799000,9,11,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn Alexstrasza'),
(2799000,9,12,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Alexstrasza Say text 0'),
(2799000,9,13,0,0,0,100,0,4000,4000,0,0,1,3,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 3'),
(2799000,9,14,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos resume path'),
(2799000,9,15,0,0,0,100,0,0,0,0,0,45,0,2,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn Alexstrasza back'),
(2799000,9,16,0,0,0,100,0,1000,1000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 5'),
(2799000,9,17,0,0,0,100,0,4000,4000,0,0,1,6,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 6'),
(2799000,9,18,0,0,0,100,0,4000,4000,0,0,33,36715,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Give quest credit'),
(2799000,9,19,0,0,0,100,0,4000,4000,0,0,81,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn on Gossip & Questgiver flags'),
(2799000,9,20,0,0,0,100,0,0,0,0,0,81,3,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn on Gossip & Questgiver flags for Alexstrasza'),
-- alliance quest script
(2799001,9,0,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn off Gossip & Questgiver flags'),
(2799001,9,1,0,0,0,100,0,0,0,0,0,81,0,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn of Gossip & Questgiver flags for Alexstrasza'),
(2799001,9,2,0,0,0,100,0,2000,2000,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 0'),
(2799001,9,3,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 1'),
(2799001,9,4,0,0,0,100,0,0,0,0,0,45,0,1,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos start path'),
(2799001,9,5,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 2'),
(2799001,9,6,0,0,0,100,0,4000,4000,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 3'),
(2799001,9,7,0,0,0,100,0,4000,4000,0,0,1,0,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 0'),
(2799001,9,8,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 1'),
(2799001,9,9,0,0,0,100,0,4000,4000,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 4'),
(2799001,9,10,0,0,0,100,0,4000,4000,0,0,1,2,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 2'),
(2799001,9,11,0,0,0,100,0,3000,3000,0,0,45,0,1,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn Alexstrasza'),
(2799001,9,12,0,0,0,100,0,1000,1000,0,0,1,0,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Alexstrasza Say text 0'),
(2799001,9,13,0,0,0,100,0,4000,4000,0,0,1,3,0,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos Say text 3'),
(2799001,9,14,0,0,0,100,0,3000,3000,0,0,45,0,2,0,0,0,0,9,38017,0,30,0,0,0,0, 'Kalecgos resume path'),
(2799001,9,15,0,0,0,100,0,0,0,0,0,45,0,2,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn Alexstrasza back'),
(2799001,9,16,0,0,0,100,0,1000,1000,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 5'),
(2799001,9,17,0,0,0,100,0,4000,4000,0,0,1,7,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Say text 7'),
(2799001,9,18,0,0,0,100,0,4000,4000,0,0,33,36715,0,0,0,0,0,7,0,0,0,0,0,0,0, 'Give quest credit'),
(2799001,9,19,0,0,0,100,0,4000,4000,0,0,81,3,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Turn on Gossip & Questgiver flags'),
(2799001,9,20,0,0,0,100,0,0,0,0,0,81,3,0,0,0,0,0,9,26917,0,10,0,0,0,0, 'Turn on Gossip & Questgiver flags for Alexstrasza');

DELETE FROM `creature_text` WHERE `entry` IN (26917,27990,38017);
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(26917,0,0,'Mortal champions have long used these weapons to combat evil. I see no reason to keep the swords from them in this battle.',0,0,100,1,0,0,'Alexstrasza the Life-Binder'),
(27990,0,0,'You''re too late, $n. Another visitor from Dalaran came asking after information about the same prismatic dragon blades.',0,0,100,1,0,0,'Krasus'),
(27990,1,0,'From your description, I''m certain the book I loaned our visitor could allow you to easily identify the weapon.',0,0,100,25,0,0,'Krasus'),
(27990,2,0,'I''m afraid you''ll have to ask the -- Well, perhaps Kalecgos can help.',0,0,100,1,0,0,'Krasus'),
(27990,3,0,'$n may have found the remains of a prismatic blade, Kalecgos. Will you offer your help to our visitor?',0,0,100,1,0,0,'Krasus'),
(27990,4,0,'You believe our allies will not be able to control the power of the swords?',0,0,100,1,0,0,'Krasus'),
(27990,5,0,'As will we all.',0,0,100,25,0,0,'Krasus'),
(27990,6,0,'Please, mortal, speak with Arcanist Tybalin in Dalaran. He may be able to negotiate with the Sunreavers for access to the book.',0,0,100,1,0,0,'Krasus'),
(27990,7,0,'Please, mortal, seek out Magister Hathorel in Dalaran. He might be able to negotiate with the Silver Covenant for access to the book.',0,0,100,1,0,0,'Krasus'),
(38017,0,0,'Are you certain you should be helping these mortals in their quest for the sword?',0,0,100,1,0,0,'Kalecgos'),
(38017,1,0,'These blades, Krasus... They were made long ago, when things were... different.',0,0,100,1,0,0,'Kalecgos'),
(38017,2,0,'Our enemies once turned our strongest weapon against us. What makes you think the prismatic blades will be any different?',0,0,100,1,0,0,'Kalecgos'),
(38017,3,0,'As you wish, my queen. I will not stand in their way, but I will keep a close watch.',0,0,100,16,0,0,'Kalecgos');
-- waypoints for Kalecgos
DELETE FROM `waypoints` WHERE `entry`=38017;
INSERT INTO `waypoints` (`entry`,`pointid`,`position_x`,`position_y`,`position_z`,`point_comment`) VALUES
(38017,1,3541.156,276.041,342.721,'talk point'),
(38017,2,3545.989,287.278,342.721,'home point');
-- SAI for Kalecgos
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=38017;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=38017;
DELETE FROM `smart_scripts` WHERE `source_type`=9 AND `entryorguid` IN (3801700,3801701);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(38017,0,0,1,38,0,100,0,0,1,0,0,80,3801700,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On dataset 0 1 run script'),
(38017,0,1,1,38,0,100,0,0,2,0,0,80,3801701,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On dataset 0 2 run script'),
(38017,0,2,3,40,0,100,0,1,38017,0,0,54,30000,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Pause at wp 1'),
(38017,0,3,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,9,27990,0,15,0,0,0,0, 'turn to Krasus'),
(38017,0,4,5,40,0,100,0,2,38017,0,0,55,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Stop at wp 2'),
(38017,0,5,0,61,0,100,0,0,0,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'turn to pos'),
(3801700,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'dataset 0 0'),
(3801700,9,1,0,0,0,100,0,0,0,0,0,53,0,38017,0,0,0,0,1,0,0,0,0,0,0,0, 'wp start'),
(3801701,9,0,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'dataset 0 0'),
(3801701,9,1,0,0,0,100,0,0,0,0,0,65,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'wp resume');
-- SAI for Alexstrasza
UPDATE `creature_template` SET `AIName`= 'SmartAI' WHERE `entry`=26917;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26917;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26917,0,0,1,38,0,100,0,0,1,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,1.6049, 'On dataset 0 1 turn'),
(26917,0,1,1,38,0,100,0,0,2,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On dataset 0 2 turn');

-- Increased drop chance for some cook recipes
UPDATE `item_loot_template` SET `ChanceOrQuestChance` = 15 WHERE `item` IN (33873, 33870); 
UPDATE `item_loot_template` SET `ChanceOrQuestChance` = 10 WHERE `item` IN (33875, 33869);

-- Delete non-attackable flag from Army of the Dead Ghoul NPC (24207)
UPDATE `creature_template` SET `unit_flags`=0 WHERE `entry` =24207;

-- Restore data deleted in 2011_10_23_08_world_sai.sql TC update (27.10.2011)
DELETE FROM `creature` WHERE `guid` =56995;
INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`) VALUES
(56995, 16933, 530, 1, 1, 0, 0, -1545.9, 3627.48, 35.0149, 2.96104, 600, 5, 0, 5000, 0, 1, 0, 0, 0);

-- fix creatures spawn coordinates
REPLACE INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`) VALUES
(97343, 25428, 571, 1, 1, 0, 0, 4457.88, 5241.73, 74.4109, 5.03238, 600, 15, 0, 7984, 3080, 1),
(111385, 31718, 571, 1, 1, 0, 0, 7930.02, 1022.7, 462.613, 5.22892, 300, 0, 0, 12600, 3994, 0);
REPLACE INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`) VALUES
(98952, 30102, 571, 1, 1, 0, 0, 5823.54, -2910.77, 303.546, 3.70443, 600, 0, 0, 10635, 0, 0),
(111940, 31140, 571, 1, 1, 0, 0, 6582.88, 1116.38, 273.358, 0.355237, 300, 0, 0, 12600, 0, 0);

-- Fix Sindragosa non aggro
UPDATE creature_template SET unit_flags = '0' WHERE entry IN (36853,38267,38266,38265);

-- Fix repetable of event for object 185861 (23.12.2011)
UPDATE `creature_ai_scripts` SET `event_flags`=1 WHERE `creature_id`=23119;

-- fix wrong conditions conversion
DELETE FROM `conditions` WHERE `SourceEntry` = 66665 AND `ConditionValue2` = 35015;