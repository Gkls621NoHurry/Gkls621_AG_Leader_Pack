-- Tsugumi's Unique District, replacing JIDONG's Hospital District
INSERT INTO Types
(Type, Kind)
VALUES
('DISTRICT_CAFFE_gkls621', 'KIND_DISTRICT'),
('TRAIT_DISTRICT_CAFFE_gkls621', 'KIND_TRAIT'),
('MODIFIER_AG_OWNER_CITY_GRANT_TRADING_POST_gkls621', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers (ModifierType, EffectType, CollectionType)
VALUES
('MODIFIER_AG_OWNER_CITY_GRANT_TRADING_POST_gkls621', 'EFFECT_GRANT_CITY_TRADING_POST', 'COLLECTION_OWNER_CITY');

INSERT INTO Traits
(TraitType, Name,   Description)
VALUES
('TRAIT_DISTRICT_CAFFE_gkls621',  'LOC_DISTRICT_CAFFE_gkls621_NAME',    'LOC_DISTRICT_CAFFE_gkls621_DESCRIPTION');

INSERT INTO LeaderTraits
(LeaderType,                TraitType)
VALUES
('LEADER_TSUGUMI_gkls621',   'TRAIT_DISTRICT_CAFFE_gkls621');

INSERT INTO DistrictReplaces
(CivUniqueDistrictType, ReplacesDistrictType)
VALUES
('DISTRICT_CAFFE_gkls621',    'DISTRICT_JD_HOSPITAL');

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
    'DISTRICT_CAFFE_gkls621',
    'LOC_DISTRICT_CAFFE_gkls621_NAME',
    'TECH_CURRENCY',
    Coast,
    'LOC_DISTRICT_CAFFE_gkls621_DESCRIPTION',
    Cost *0.5,
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
    'PLUNDER_GOLD',
    50,
    TradeEmbark,
    MilitaryDomain,
    CostProgressionModel,
    CostProgressionParam1 *0.5,
    'TRAIT_DISTRICT_CAFFE_gkls621',
    1,
    2,
    1,
    OnePerCity,
    AllowsHolyCity,
    Maintenance,
    AirSlots,
    4,
    TravelTime,
    CityStrengthModifier,
    AdjacentToLand,
    CanAttack,
    AdvisorType,
    CaptureRemovesDistrict,
    MaxPerPlayer
FROM Districts WHERE DistrictType = 'DISTRICT_JD_HOSPITAL';

INSERT INTO District_CitizenYieldChanges
(DistrictType,  YieldType,  YieldChange)
VALUES
('DISTRICT_CAFFE_gkls621',    'YIELD_GOLD',   2),
('DISTRICT_CAFFE_gkls621',    'YIELD_FOOD',   2);

INSERT INTO District_GreatPersonPoints
(DistrictType,  GreatPersonClassType,   PointsPerTurn)
VALUES
('DISTRICT_CAFFE_gkls621', 'GREAT_PERSON_CLASS_MERCHANT', 2);

INSERT INTO District_TradeRouteYields
(DistrictType,  YieldType,  YieldChangeAsOrigin,    YieldChangeAsDomesticDestination,   YieldChangeAsInternationalDestination)
VALUES
('DISTRICT_CAFFE_gkls621', 'YIELD_FOOD', 3, 2, 0),
('DISTRICT_CAFFE_gkls621', 'YIELD_PRODUCTION', 2, 3, 0);

INSERT INTO District_Adjacencies
(DistrictType,  YieldChangeId)
VALUES
('DISTRICT_CAFFE_gkls621', 'CAFFE_BASE_GOLD_gkls621'),
('DISTRICT_CAFFE_gkls621', 'CAFFE_RIVER_GOLD_gkls621'),
('DISTRICT_CAFFE_gkls621', 'CAFFE_DISTRICT_GOLD_gkls621');

INSERT INTO Adjacency_YieldChanges
(ID,    Description,    YieldType,  YieldChange,    TilesRequired,  Self)
VALUES
('CAFFE_BASE_GOLD_gkls621', 'LOC_CAFFE_BASE_GOLD_gkls621',
'YIELD_GOLD', 3, 1, 1);

INSERT INTO Adjacency_YieldChanges
(ID,    Description,    YieldType,  YieldChange,    TilesRequired,  OtherDistrictAdjacent)
VALUES
('CAFFE_DISTRICT_GOLD_gkls621', 'LOC_CAFFE_DISTRICT_GOLD_gkls621',
'YIELD_GOLD', 1, 1, 1);

INSERT INTO Adjacency_YieldChanges
(ID,    Description,    YieldType,  YieldChange,    TilesRequired,  AdjacentRiver)
VALUES
('CAFFE_RIVER_GOLD_gkls621', 'LOC_CAFFE_RIVER_GOLD_gkls621',
'YIELD_GOLD', 2, 1, 1);

INSERT INTO DistrictModifiers
(DistrictType,  ModifierId)
VALUES
('DISTRICT_CAFFE_gkls621', 'CAFFE_GRANT_COFFEE_gkls621'),
('DISTRICT_CAFFE_gkls621', 'CAFFE_GRANT_TRADING_POST_gkls621');

INSERT INTO Modifiers
(ModifierId, ModifierType, Permanent, SubjectRequirementSetId)
VALUES
('CAFFE_GRANT_COFFEE_gkls621', 'MODIFIER_SINGLE_CITY_GRANT_RESOURCE_IN_CITY', 1, NULL),
('CAFFE_GRANT_TRADING_POST_gkls621', 'MODIFIER_AG_OWNER_CITY_GRANT_TRADING_POST_gkls621', 1, NULL);

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
VALUES
('CAFFE_GRANT_COFFEE_gkls621', 'Amount', 1),
('CAFFE_GRANT_COFFEE_gkls621', 'ResourceType', 'RESOURCE_COFFEE');

INSERT INTO AiFavoredItems
(ListType,	Item,	Favored)
VALUES
('TSUGUMI_gkls621_DISTRICT',    'DISTRICT_CAFFE_gkls621',	1);

INSERT INTO MomentIllustrations
(MomentIllustrationType,                    MomentDataType,             GameDataType,               Texture)
VALUES
('MOMENT_ILLUSTRATION_UNIQUE_DISTRICT',     'MOMENT_DATA_DISTRICT',     'DISTRICT_CAFFE_gkls621',   'Moment_Infrastructure_Tsugumi_gkls621');