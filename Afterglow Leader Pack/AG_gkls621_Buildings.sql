INSERT INTO Types
(Type, Kind)
VALUES
('TRAIT_BUILDING_ROOFTOP_gkls621', 'KIND_TRAIT'),
('BUILDING_ROOFTOP_gkls621', 'KIND_BUILDING'),
('MODIFIER_AG_SINGLE_CITY_ADJUST_RANGED_STRIKE_gkls621', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers (ModifierType, EffectType, CollectionType)
VALUES
('MODIFIER_AG_SINGLE_CITY_ADJUST_RANGED_STRIKE_gkls621', 'EFFECT_ADJUST_CITY_RANGED_STRIKE', 'COLLECTION_OWNER');


INSERT INTO Traits
(TraitType, Name,   Description)
VALUES
('TRAIT_BUILDING_ROOFTOP_gkls621', 'LOC_BUILDING_ROOFTOP_gkls621_NAME', 'LOC_BUILDING_ROOFTOP_gkls621_DESCRIPTION');

INSERT INTO BuildingReplaces
(CivUniqueBuildingType, ReplacesBuildingType)
VALUES
('BUILDING_ROOFTOP_gkls621',    'BUILDING_LIBRARY');

INSERT INTO MutuallyExclusiveBuildings
(Building,  MutuallyExclusiveBuilding)
SELECT
'BUILDING_ROOFTOP_gkls621',    MutuallyExclusiveBuilding
FROM MutuallyExclusiveBuildings WHERE Building = 'BUILDING_LIBRARY';

INSERT INTO Buildings (
BuildingType,
Name,
Cost,
Capital,
PrereqDistrict,
PrereqTech,
Description,
RequiresPlacement,
RequiresRiver,
Housing,
Entertainment,
EnabledByReligion,
AllowsHolyCity,
PurchaseYield,
MustPurchase,
Maintenance,
IsWonder,
OuterDefenseStrength,
CitizenSlots,
MustBeLake,
MustNotBeLake,
RegionalRange,
AdjacentToMountain,
ObsoleteEra,
RequiresReligion,
GrantFortification,
DefenseModifier,
InternalOnly,
RequiresAdjacentRiver,
MustBeAdjacentLand,
AdvisorType,
AdjacentCapital,
UnlocksGovernmentPolicy,
TraitType
) SELECT 
'BUILDING_ROOFTOP_gkls621',
'LOC_BUILDING_ROOFTOP_gkls621_NAME',
85,
0,
'DISTRICT_CAMPUS',
PrereqTech,
'LOC_BUILDING_ROOFTOP_gkls621_DESCRIPTION',
RequiresPlacement,
RequiresRiver,
1,
1,
EnabledByReligion,
AllowsHolyCity,
PurchaseYield,
MustPurchase,
0,
IsWonder,
OuterDefenseStrength,
CitizenSlots +1,
MustBeLake,
MustNotBeLake,
RegionalRange,
AdjacentToMountain,
ObsoleteEra,
RequiresReligion,
GrantFortification,
DefenseModifier,
InternalOnly,
RequiresAdjacentRiver,
MustBeAdjacentLand,
AdvisorType,
AdjacentCapital,
UnlocksGovernmentPolicy,
'TRAIT_BUILDING_ROOFTOP_gkls621'
FROM Buildings WHERE BuildingType = 'BUILDING_LIBRARY';

INSERT INTO Buildings_XP2
(BuildingType, Pillage)
VALUES
('BUILDING_ROOFTOP_gkls621', 0);

INSERT INTO Building_YieldChanges
(BuildingType,  YieldType,  YieldChange)
VALUES
('BUILDING_ROOFTOP_gkls621', 'YIELD_SCIENCE', 2),
('BUILDING_ROOFTOP_gkls621', 'YIELD_CULTURE', 2);

INSERT INTO Building_YieldsPerEra
(BuildingType,  YieldType,  YieldChange)
VALUES
('BUILDING_ROOFTOP_gkls621',   'YIELD_CULTURE',    2);

INSERT INTO Building_GreatPersonPoints
(BuildingType,  GreatPersonClassType,   PointsPerTurn)
VALUES
('BUILDING_ROOFTOP_gkls621',   'GREAT_PERSON_CLASS_SCIENTIST',  1),
('BUILDING_ROOFTOP_gkls621',   'GREAT_PERSON_CLASS_MUSICIAN',  1);

INSERT INTO BuildingModifiers
(BuildingType, ModifierId)
VALUES
('BUILDING_ROOFTOP_gkls621', 'ROOFTOP_GARRISON_STRENGTH_gkls621'),
('BUILDING_ROOFTOP_gkls621', 'ROOFTOP_RANGED_STRIKE_gkls621');

INSERT INTO Modifiers
(ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
('ROOFTOP_GARRISON_STRENGTH_gkls621', 'MODIFIER_PLAYER_CITIES_ADJUST_INNER_DEFENSE', 'PLAYER_IS_HUMAN'),
('ROOFTOP_RANGED_STRIKE_gkls621', 'MODIFIER_AG_SINGLE_CITY_ADJUST_RANGED_STRIKE_gkls621', 'PLAYER_IS_HUMAN');

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
VALUES
('ROOFTOP_GARRISON_STRENGTH_gkls621', 'Amount', 6),
('ROOFTOP_RANGED_STRIKE_gkls621', 'Amount', 10);

INSERT INTO ModifierStrings
(ModifierId, Context, Text)
VALUES
('ROOFTOP_GARRISON_STRENGTH_gkls621', 'Preview', 'LOC_ROOFTOP_GARRISON_STRENGTH_gkls621'),
('ROOFTOP_RANGED_STRIKE_gkls621', 'Preview', 'LOC_ROOFTOP_RANGED_STRIKE_gkls621');