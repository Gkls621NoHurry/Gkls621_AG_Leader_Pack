INSERT INTO Types
(Type, Kind)
VALUES
('UNIT_TAIKO_TEAM_gkls621', 'KIND_UNIT'),
('TRAIT_UNIT_TAIKO_TEAM_gkls621', 'KIND_TRAIT'),
('IMPROVEMENT_TOMOE_GOODY_gkls621',	'KIND_IMPROVEMENT');

INSERT INTO Traits
(TraitType, Name,   Description)
VALUES
('TRAIT_UNIT_TAIKO_TEAM_gkls621',    'LOC_UNIT_TAIKO_TEAM_gkls621_NAME',  'LOC_UNIT_TAIKO_TEAM_gkls621_DESCRIPTION');

INSERT INTO Tags
(Tag,   Vocabulary)
VALUES
('CLASS_TAIKO_TEAM_gkls621',   'ABILITY_CLASS');

INSERT INTO TypeTags
(Type,  Tag)
VALUES
('UNIT_TAIKO_TEAM_gkls621', 'CLASS_BUILDER'),
('UNIT_TAIKO_TEAM_gkls621', 'CLASS_LANDCIVILIAN'),
('UNIT_TAIKO_TEAM_gkls621', 'CLASS_TAIKO_TEAM_gkls621'),
('ABILITY_IGNORE_ZOC', 'CLASS_TAIKO_TEAM_gkls621');

INSERT INTO UnitAiInfos
(UnitType,  AiType)
VALUES
('UNIT_TAIKO_TEAM_gkls621',    'UNITAI_BUILD'),
('UNIT_TAIKO_TEAM_gkls621',    'UNITAI_EXPLORE'),
('UNIT_FELLOW_GANG_gkls621',    'UNITTYPE_CIVILIAN');

INSERT INTO UnitReplaces
(CivUniqueUnitType, ReplacesUnitType)
VALUES
('UNIT_TAIKO_TEAM_gkls621',  'UNIT_BUILDER');

INSERT INTO Units
(UnitType,
Name, 
Description, 
Cost,
CostProgressionModel,
CostProgressionParam1,
Maintenance,
BaseMoves,
BaseSightRange,
ZoneOfControl,
Domain,
Combat,
BuildCharges,
ParkCharges,
FormationClass,
PromotionClass,
AdvisorType,
CanCapture,
PurchaseYield,
PrereqTech,
PrereqCivic,
TraitType
)SELECT
'UNIT_TAIKO_TEAM_gkls621',
'LOC_UNIT_TAIKO_TEAM_gkls621_NAME',
'LOC_UNIT_TAIKO_TEAM_gkls621_DESCRIPTION',
Cost -10,
CostProgressionModel,
CostProgressionParam1,
0,
3,
BaseSightRange +1,
0,
Domain,
0,
3,
0,
FormationClass,
PromotionClass,
AdvisorType,
CanCapture,
PurchaseYield,
PrereqTech,
PrereqCivic,
'TRAIT_UNIT_TAIKO_TEAM_gkls621'
FROM Units WHERE UnitType = 'UNIT_BUILDER';

INSERT INTO Units_XP2
(UnitType, CanEarnExperience, CanFormMilitaryFormation)
VALUES
('UNIT_TAIKO_TEAM_gkls621', 0, 0);

INSERT INTO UnitCaptures
(CapturedUnitType, BecomesUnitType)
VALUES
('UNIT_TAIKO_TEAM_gkls621', 'UNIT_TAIKO_TEAM_gkls621');

UPDATE Technologies SET EmbarkUnitType = 'UNIT_TAIKO_TEAM_gkls621' WHERE TechnologyType = 'TECH_ANIMAL_HUSBANDRY';

-- Acknowledgement: Rick & Morty Mod
INSERT INTO Improvement_ValidBuildUnits
(UnitType,  ImprovementType)
SELECT DISTINCT	'UNIT_TAIKO_TEAM_gkls621',	ImprovementType
FROM Improvement_ValidBuildUnits WHERE UnitType ='UNIT_BUILDER';

-- Acknowledgement: Phantagonist's Yan State
INSERT INTO Improvements
		(ImprovementType,							Name,										Icon,							PlunderType,	RemoveOnEntry,	Goody,	GoodyNotify)
VALUES	('IMPROVEMENT_TOMOE_GOODY_gkls621',	        'LOC_IMPROVEMENT_GOODY_HUT_NAME',	        'ICON_IMPROVEMENT_GOODY_HUT',	'NO_PLUNDER',	1,				1,		0);

INSERT INTO GoodyHuts
		(GoodyHutType,								ImprovementType,						Weight,	ShowMoment)
VALUES	('GOODY_TOMOE_ENVOY_gkls621',	            'IMPROVEMENT_TOMOE_GOODY_gkls621',	    100,	0);

INSERT INTO GoodyHutSubTypes
		(GoodyHut,						SubTypeGoodyHut,    				Description,                                Weight, ModifierID)
VALUES	('GOODY_TOMOE_ENVOY_gkls621',   'GOODYHUT_TOMOE_ENVOY_gkls621',   'LOC_GOODYHUT_DIPLOMACY_ENVOY_DESCRIPTION', 	100,	'GOODY_DIPLOMACY_GRANT_ENVOY');

INSERT INTO GoodyHutSubTypes_XP2
(SubTypeGoodyHut)
VALUES
('GOODYHUT_TOMOE_ENVOY_gkls621');

-- Game Mechanism Compatibilities
-- The Pyramids
INSERT INTO BuildingModifiers
(BuildingType, ModifierId)
VALUES
('BUILDING_PYRAMIDS', 'TOMOE_ADJUST_TAIKO_TEAM_CHARGE_gkls621');

-- Policies
INSERT INTO PolicyModifiers
(PolicyType, ModifierId)
VALUES
('POLICY_ILKUM', 'TOMOE_TAIKO_TEAM_PRODUCTION_gkls621'),
('POLICY_SERFDOM', 'TOMOE_SERFDOM_gkls621'),
('POLICY_PUBLIC_WORKS', 'TOMOE_TAIKO_TEAM_PRODUCTION_gkls621'),
('POLICY_PUBLIC_WORKS', 'TOMOE_SERFDOM_gkls621');

-- Builder the Governor
INSERT INTO GovernorPromotionModifiers
(GovernorPromotionType, ModifierId)
VALUES
('GOVERNOR_PROMOTION_BUILDER_GUILDMASTER', 'TOMOE_GUILDMASTER_ATTACH_gkls621');

-- Commemoration: Infrastructure Focus
INSERT INTO CommemorationModifiers
(CommemorationType, ModifierId)
VALUES
('COMMEMORATION_INFRASTRUCTURE', 'TOMOE_TAIKO_TEAM_MOVEMENT_gkls621'),
('COMMEMORATION_INFRASTRUCTURE', 'TOMOE_TAIKO_TEAM_DISCOUNT_gkls621');

INSERT INTO Modifiers
(ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
('TOMOE_ADJUST_TAIKO_TEAM_CHARGE_gkls621', 'MODIFIER_PLAYER_UNITS_ADJUST_BUILDER_CHARGES', 'REQSET_AG_UNIT_IS_TAIKO_TEAM_gkls621'),
('TOMOE_TAIKO_TEAM_PRODUCTION_gkls621',    'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_PRODUCTION', NULL),
('TOMOE_SERFDOM_gkls621',                  'MODIFIER_PLAYER_UNITS_ADJUST_BUILDER_CHARGES', 'REQSET_AG_UNIT_IS_TAIKO_TEAM_gkls621'),
('TOMOE_GUILDMASTER_ATTACH_gkls621',       'MODIFIER_SINGLE_CITY_ATTACH_MODIFIER',         NULL),
('TOMOE_GUILDMASTER_gkls621',              'MODIFIER_SINGLE_CITY_BUILDER_CHARGES',         'REQSET_AG_UNIT_IS_TAIKO_TEAM_gkls621'),
('TOMOE_TAIKO_TEAM_MOVEMENT_gkls621',	   'MODIFIER_PLAYER_UNITS_ADJUST_MOVEMENT',		   'REQSET_AG_UNIT_IS_TAIKO_TEAM_gkls621'),
('TOMOE_TAIKO_TEAM_DISCOUNT_gkls621',	   'MODIFIER_PLAYER_CITIES_ADJUST_UNIT_PURCHASE_COST', NULL);

UPDATE Modifiers SET OwnerRequirementSetId = 'PLAYER_HAS_GOLDEN_AGE' WHERE ModifierId = 'TOMOE_TAIKO_TEAM_MOVEMENT_gkls621';
UPDATE Modifiers SET OwnerRequirementSetId = 'PLAYER_HAS_GOLDEN_AGE' WHERE ModifierId = 'TOMOE_TAIKO_TEAM_DISCOUNT_gkls621';
UPDATE Modifiers SET SubjectStackLimit = 1 WHERE ModifierId = 'TOMOE_TAIKO_TEAM_DISCOUNT_gkls621';

UPDATE Modifiers SET Permanent = 1 WHERE ModifierId = 'TOMOE_GUILDMASTER_gkls621';

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
VALUES
('TOMOE_ADJUST_TAIKO_TEAM_CHARGE_gkls621', 'Amount', 1),
('TOMOE_TAIKO_TEAM_PRODUCTION_gkls621', 'UnitType', 'UNIT_TAIKO_TEAM_gkls621'),
('TOMOE_TAIKO_TEAM_PRODUCTION_gkls621', 'Amount', 30),
('TOMOE_SERFDOM_gkls621', 'Amount', 2),
('TOMOE_GUILDMASTER_ATTACH_gkls621', 'ModifierId', 'TOMOE_GUILDMASTER_gkls621'),
('TOMOE_GUILDMASTER_gkls621', 'Amount', 1),
('TOMOE_TAIKO_TEAM_MOVEMENT_gkls621', 'Amount', 1),
('TOMOE_TAIKO_TEAM_DISCOUNT_gkls621', 'UnitType', 'UNIT_TAIKO_TEAM_gkls621'),
('TOMOE_TAIKO_TEAM_DISCOUNT_gkls621', 'Amount', 30);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('REQSET_AG_UNIT_IS_TAIKO_TEAM_gkls621', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('REQSET_AG_UNIT_IS_TAIKO_TEAM_gkls621', 'AG_UNIT_IS_TAIKO_TEAM_gkls621');

INSERT INTO Requirements (RequirementId, RequirementType)
VALUES
('AG_UNIT_IS_TAIKO_TEAM_gkls621', 'REQUIREMENT_UNIT_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES
('AG_UNIT_IS_TAIKO_TEAM_gkls621', 'UnitType', 'UNIT_TAIKO_TEAM_gkls621');
