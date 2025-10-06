-- Tsugumi's Unique District, replacing JIDONG's Hospital District
INSERT INTO Types
(Type, Kind)
VALUES
('DISTRICT_IKEBANA_FAMILY_gkls621', 'KIND_DISTRICT'),
('TRAIT_DISTRICT_IKEBANA_FAMILY_gkls621', 'KIND_TRAIT'),
('MODIFIER_AG_SINGLE_CITY_GRANT_UNIT_BY_CLASS_gkls621', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers (ModifierType, EffectType, CollectionType)
VALUES
('MODIFIER_AG_SINGLE_CITY_GRANT_UNIT_BY_CLASS_gkls621', 'EFFECT_GRANT_UNIT_BY_CLASS', 'COLLECTION_OWNER_CITY');

INSERT INTO Traits
(TraitType, Name,   Description)
VALUES
('TRAIT_DISTRICT_IKEBANA_FAMILY_gkls621',  'LOC_DISTRICT_IKEBANA_FAMILY_gkls621_NAME',    'LOC_DISTRICT_IKEBANA_FAMILY_gkls621_DESCRIPTION');

INSERT INTO LeaderTraits
(LeaderType,                TraitType)
VALUES
('LEADER_RAN_gkls621',      'TRAIT_DISTRICT_IKEBANA_FAMILY_gkls621');

INSERT INTO DistrictReplaces
(CivUniqueDistrictType, ReplacesDistrictType)
VALUES
('DISTRICT_IKEBANA_FAMILY_gkls621',    'DISTRICT_LEU_GARDEN');

INSERT INTO Districts 
(   DistrictType,
    Name,
    PrereqTech,
    Coast,
    Description,
    Cost,
    RequiresPlacement,
    RequiresPopulation,
    NoAdjacentCity,
    CityCenter,
    Aqueduct,
    InternalOnly,
    ZOC,
    FreeEmbark,
    HitPoints,
    CaptureRemovesBuildings,
    CaptureRemovesCityDefenses,
    PlunderType,
    PlunderAmount,
    TradeEmbark,
    MilitaryDomain,
    CostProgressionModel,
    CostProgressionParam1,
    TraitType,
    Appeal,
    Housing,
    Entertainment,
    OnePerCity,
    AllowsHolyCity,
    Maintenance,
    AirSlots,
    CitizenSlots,
    TravelTime,
    CityStrengthModifier,
    AdjacentToLand,
    CanAttack,
    AdvisorType,
    CaptureRemovesDistrict,
    MaxPerPlayer
)SELECT
    'DISTRICT_IKEBANA_FAMILY_gkls621',
    'LOC_DISTRICT_IKEBANA_FAMILY_gkls621_NAME',
    'TECH_IRRIGATION',
    Coast,
    'LOC_DISTRICT_IKEBANA_FAMILY_gkls621_DESCRIPTION',
    Cost *0.5,
    RequiresPlacement,
    RequiresPopulation,
    NoAdjacentCity,
    CityCenter,
    Aqueduct,
    InternalOnly,
    1,
    FreeEmbark,
    100,
    1,
    0,
    'NO_PLUNDER',
    0,
    TradeEmbark,
    'DOMAIN_LAND',
    CostProgressionModel,
    CostProgressionParam1 *0.5,
    'TRAIT_DISTRICT_IKEBANA_FAMILY_gkls621',
    1,
    1,
    -1,
    OnePerCity,
    AllowsHolyCity,
    Maintenance,
    AirSlots,
    3,
    TravelTime,
    2,
    AdjacentToLand,
    CanAttack,
    AdvisorType,
    CaptureRemovesDistrict,
    MaxPerPlayer
FROM Districts WHERE DistrictType = 'DISTRICT_LEU_GARDEN';

INSERT INTO Districts_XP2
(DistrictType, AttackRange)
VALUES
('DISTRICT_IKEBANA_FAMILY_gkls621', 3);

INSERT INTO District_CitizenYieldChanges
(DistrictType,  YieldType,  YieldChange)
VALUES
('DISTRICT_IKEBANA_FAMILY_gkls621',    'YIELD_PRODUCTION',   2),
('DISTRICT_IKEBANA_FAMILY_gkls621',    'YIELD_CULTURE',   1);

INSERT INTO District_GreatPersonPoints
(DistrictType,  GreatPersonClassType,   PointsPerTurn)
VALUES
('DISTRICT_IKEBANA_FAMILY_gkls621', 'GREAT_PERSON_CLASS_GENERAL', 2);

INSERT INTO District_TradeRouteYields
(DistrictType,  YieldType,  YieldChangeAsOrigin,    YieldChangeAsDomesticDestination,   YieldChangeAsInternationalDestination)
VALUES
('DISTRICT_IKEBANA_FAMILY_gkls621', 'YIELD_CULTURE', 1, 1, 0),
('DISTRICT_IKEBANA_FAMILY_gkls621', 'YIELD_FOOD', 1, 1, 0);

INSERT INTO District_Adjacencies
(DistrictType,  YieldChangeId)
SELECT
'DISTRICT_IKEBANA_FAMILY_gkls621', YieldChangeId
FROM District_Adjacencies WHERE DistrictType = 'DISTRICT_LEU_GARDEN';

INSERT INTO Adjacent_AppealYieldChanges
(DistrictType,  BuildingType,   Description,    MinimumValue,   MaximumValue,   Unimproved, YieldType,  YieldChange)
SELECT
'DISTRICT_IKEBANA_FAMILY_gkls621', BuildingType, Description, MinimumValue, MaximumValue, Unimproved, YieldType, YieldChange
FROM Adjacent_AppealYieldChanges WHERE DistrictType = 'DISTRICT_LEU_GARDEN';

INSERT INTO DistrictModifiers
(DistrictType, ModifierId)
VALUES 
('DISTRICT_IKEBANA_FAMILY_gkls621', 'IKEBANA_FAMILY_DISTRICT_ANTI_CAVALRY_gkls621'),
('DISTRICT_IKEBANA_FAMILY_gkls621', 'BARRACKS_ADJUST_RESOURCE_STOCKPILE_CAP'),
('DISTRICT_IKEBANA_FAMILY_gkls621', 'IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_BASE_gkls621'),
('DISTRICT_IKEBANA_FAMILY_gkls621', 'IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_BASE_gkls621'),
('DISTRICT_IKEBANA_FAMILY_gkls621', 'IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_GA_gkls621'),
('DISTRICT_IKEBANA_FAMILY_gkls621', 'IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_GA_gkls621');

INSERT INTO TraitModifiers
(TraitType, ModifierId)
VALUES
('TRAIT_DISTRICT_IKEBANA_FAMILY_gkls621', 'IKEBANA_FAMILY_GRANT_ANTI_CAVALRY_gkls621');

INSERT INTO Modifiers
(ModifierId, ModifierType, RunOnce, Permanent)
VALUES
('IKEBANA_FAMILY_DISTRICT_ANTI_CAVALRY_gkls621', 'MODIFIER_AG_SINGLE_CITY_GRANT_UNIT_BY_CLASS_gkls621', 1, 1);

INSERT INTO Modifiers
(ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
('IKEBANA_FAMILY_GRANT_ANTI_CAVALRY_gkls621', 'MODIFIER_PLAYER_DISTRICT_ADJUST_PLAYER_DISTRICT_AND_BUILDINGS_CREATE_UNIT_WITH_ABILITY_BY_CLASS', NULL),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_BASE_gkls621', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_AG_PLOT_HAS_UNIMPROVED_LUXURY_gkls621'),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_BASE_gkls621', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_AG_PLOT_HAS_UNIMPROVED_LUXURY_gkls621'),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_GA_gkls621', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_AG_PLOT_HAS_UNIMPROVED_LUXURY_gkls621'),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_GA_gkls621', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_AG_PLOT_HAS_UNIMPROVED_LUXURY_gkls621');

UPDATE Modifiers SET OwnerRequirementSetId = 'PLAYER_HAS_GOLDEN_AGE' WHERE ModifierId = 'IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_GA_gkls621' OR ModifierId = 'IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_GA_gkls621';

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
VALUES
('IKEBANA_FAMILY_DISTRICT_ANTI_CAVALRY_gkls621', 'UnitPromotionClass', 'PROMOTION_CLASS_ANTI_CAVALRY'),
('IKEBANA_FAMILY_GRANT_ANTI_CAVALRY_gkls621', 'DistrictType', 'DISTRICT_IKEBANA_FAMILY_gkls621'),
('IKEBANA_FAMILY_GRANT_ANTI_CAVALRY_gkls621', 'UnitPromotionClass', 'PROMOTION_CLASS_ANTI_CAVALRY'),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_BASE_gkls621', 'YieldType', 'YIELD_GOLD'),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_BASE_gkls621', 'Amount', 3),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_BASE_gkls621', 'YieldType', 'YIELD_SCIENCE'),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_BASE_gkls621', 'Amount', 3),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_GA_gkls621', 'YieldType', 'YIELD_GOLD'),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_GOLD_GA_gkls621', 'Amount', 3),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_GA_gkls621', 'YieldType', 'YIELD_SCIENCE'),
('IKEBANA_FAMILY_UNIMPROVED_LUXURY_SCIENCE_GA_gkls621', 'Amount', 3);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('REQSET_AG_PLOT_HAS_UNIMPROVED_LUXURY_gkls621', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('REQSET_AG_PLOT_HAS_UNIMPROVED_LUXURY_gkls621', 'REQUIRES_PLOT_HAS_LUXURY'),
('REQSET_AG_PLOT_HAS_UNIMPROVED_LUXURY_gkls621', 'REQUIRES_PLOT_HAS_NO_IMPROVEMENT');

INSERT INTO AiFavoredItems
(ListType,	Item,	Favored)
VALUES
('RAN_gkls621_DISTRICT', 'DISTRICT_IKEBANA_FAMILY_gkls621', 1);

INSERT INTO MomentIllustrations
(MomentIllustrationType,                    MomentDataType,             GameDataType,                       Texture)
VALUES
('MOMENT_ILLUSTRATION_UNIQUE_DISTRICT',     'MOMENT_DATA_DISTRICT',     'DISTRICT_IKEBANA_FAMILY_gkls621',  'Moment_Infrastructure_Ran_gkls621');