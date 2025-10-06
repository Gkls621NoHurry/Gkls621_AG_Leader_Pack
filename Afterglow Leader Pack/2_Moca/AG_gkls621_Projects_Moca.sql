-- Moca's project to revive Babanbo Sama
INSERT INTO Types
(Type,	Kind)
VALUES
('PROJECT_BABANBO_REVIVAL_gkls621',	    'KIND_PROJECT'),
('BUILDING_BABANBO_STATUE_gkls621',     'KIND_BUILDING');

INSERT INTO Projects
(ProjectType,	Name,	ShortName,	Description,
Cost,   CostProgressionModel,	CostProgressionParam1,	AdvisorType,	UnlocksFromEffect)
VALUES
('PROJECT_BABANBO_REVIVAL_gkls621',	'LOC_PROJECT_BABANBO_REVIVAL_gkls621_NAME',	'LOC_PROJECT_BABANBO_REVIVAL_gkls621_SHORT_NAME',	'LOC_PROJECT_BABANBO_REVIVAL_gkls621_DESCRIPTION',
120,  'COST_PROGRESSION_GAME_PROGRESS',	1500,	'ADVISOR_CONQUEST',	1);

INSERT INTO Projects_XP1
(ProjectType,   IdentityPerCitizenChange)
VALUES
('PROJECT_BABANBO_REVIVAL_gkls621',   1.0);

INSERT INTO Projects_XP2
(ProjectType, RequiredBuilding)
VALUES
('PROJECT_BABANBO_REVIVAL_gkls621', 'BUILDING_BABANBO_STATUE_gkls621');

INSERT INTO Project_BuildingCosts
(ProjectType, ConsumedBuildingType)
VALUES
('PROJECT_BABANBO_REVIVAL_gkls621', 'BUILDING_BABANBO_STATUE_gkls621');

INSERT OR REPLACE INTO Buildings
(BuildingType, Name, Cost, MustPurchase, Description)
VALUES
('BUILDING_BABANBO_STATUE_gkls621', 'LOC_BUILDING_BABANBO_STATUE_gkls621_NAME', 150, 1, 'LOC_BUILDING_BABANBO_STATUE_gkls621_DESCRIPTION');

INSERT INTO Buildings_XP2
(BuildingType, Pillage)
VALUES
('BUILDING_BABANBO_STATUE_gkls621', 0);

INSERT INTO Building_YieldChanges
(BuildingType,  YieldType,  YieldChange)
VALUES
('BUILDING_BABANBO_STATUE_gkls621', 'YIELD_FAITH', 8);