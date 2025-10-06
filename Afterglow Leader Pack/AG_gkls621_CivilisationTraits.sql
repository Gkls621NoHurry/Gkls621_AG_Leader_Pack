-- Afterglow Civilisation Trait
INSERT INTO Types
(Type,  Kind)
VALUES
('TRAIT_CIVILIZATION_AG_gkls621',  'KIND_TRAIT'),
('MODIFIER_AG_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER_gkls621', 'KIND_MODIFIER'),
('MODIFIER_AG_PLAYER_BUILT_CITIES_ATTACH_MODIFIER_gkls621', 'KIND_MODIFIER'),
('MODIFIER_AG_CITY_DISTRICTS_ADJUST_YIELD_CHANGE_gkls621', 'KIND_MODIFIER');

INSERT INTO DynamicModifiers (ModifierType, EffectType, CollectionType)
VALUES
('MODIFIER_AG_CITY_DISTRICTS_ADJUST_YIELD_CHANGE_gkls621', 'EFFECT_ADJUST_DISTRICT_YIELD_CHANGE', 'COLLECTION_CITY_DISTRICTS'),
('MODIFIER_AG_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER_gkls621', 'EFFECT_ATTACH_MODIFIER', 'COLLECTION_PLAYER_CAPITAL_CITY'),
('MODIFIER_AG_PLAYER_BUILT_CITIES_ATTACH_MODIFIER_gkls621', 'EFFECT_ATTACH_MODIFIER', 'COLLECTION_PLAYER_BUILT_CITIES');

INSERT INTO Traits
(TraitType,                             Name,                                           Description)
VALUES
('TRAIT_CIVILIZATION_AG_gkls621',  'LOC_TRAIT_CIVILIZATION_AG_gkls621_NAME',  'LOC_TRAIT_CIVILIZATION_AG_gkls621_DESCRIPTION');

INSERT INTO CivilizationTraits	
(TraitType,								CivilizationType)
VALUES
('TRAIT_CIVILIZATION_AG_gkls621',       'CIVILIZATION_AG_gkls621'),
('TRAIT_UNIT_FELLOW_GANG_gkls621',      'CIVILIZATION_AG_gkls621'),
('TRAIT_BUILDING_ROOFTOP_gkls621',      'CIVILIZATION_AG_gkls621');

INSERT INTO CivilizationTraits
(TraitType,								CivilizationType)
SELECT
'TRAIT_GOVERNOR_AG_gkls621_' || SUBSTR(GovernorType,10),
'CIVILIZATION_AG_gkls621'
FROM Governors g WHERE TraitType IS NULL
AND NOT EXISTS(SELECT 1 FROM GovernorsCannotAssign gca WHERE gca.GovernorType = g.GovernorType AND gca.CannotAssign = 1);

INSERT INTO TraitModifiers
(TraitType, ModifierId)
VALUES
('TRAIT_CIVILIZATION_AG_gkls621',   'AG_ERA_ANCIENT_EUREKAS_gkls621'),
('TRAIT_CIVILIZATION_AG_gkls621',   'AG_ERA_ANCIENT_INSPIRATIONS_gkls621'),
('TRAIT_CIVILIZATION_AG_gkls621',   'AG_CAPITAL_CITY_DISTRICTS_CULTURE_ATTACH_gkls621'),
('TRAIT_CIVILIZATION_AG_gkls621',   'AG_BUILT_CITIES_DISTRICTS_CULTURE_ATTACH_gkls621');

INSERT INTO Modifiers
(ModifierId, ModifierType, RunOnce, Permanent, OwnerRequirementSetId)
SELECT
'AG_' || EraType || '_EUREKAS_gkls621',
'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_BY_ERA',
1, 1, 'REQSET_AG_PLAYER_HAS_CAPITAL_gkls621'
FROM Eras;

INSERT INTO Modifiers
(ModifierId, ModifierType, RunOnce, Permanent, OwnerRequirementSetId)
SELECT
'AG_' || EraType || '_INSPIRATIONS_gkls621',
'MODIFIER_PLAYER_GRANT_RANDOM_CIVIC_BOOST_BY_ERA',
1, 1, 'REQSET_AG_PLAYER_HAS_CAPITAL_gkls621'
FROM Eras;

INSERT INTO Modifiers
(ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
('AG_CAPITAL_CITY_DISTRICTS_CULTURE_ATTACH_gkls621', 'MODIFIER_AG_PLAYER_CAPITAL_CITY_ATTACH_MODIFIER_gkls621', NULL),
('AG_BUILT_CITIES_DISTRICTS_CULTURE_ATTACH_gkls621', 'MODIFIER_AG_PLAYER_BUILT_CITIES_ATTACH_MODIFIER_gkls621', NULL),
('AG_BUILT_CITIES_DISTRICTS_CULTURE_gkls621',        'MODIFIER_AG_CITY_DISTRICTS_ADJUST_YIELD_CHANGE_gkls621',  'REQSET_AG_DISTRICT_IS_NOT_WONDER_gkls621'),
('AG_MONUMENT_FAITH_gkls621',                        'MODIFIER_SINGLE_CITY_ADJUST_YIELD_CHANGE',                NULL),
('AG_MONUMENT_INFLUENCE_gkls621',                    'MODIFIER_PLAYER_ADJUST_INFLUENCE_POINTS_PER_TURN',        NULL),
('AG_MONUMENT_FAVOR_gkls621',                        'MODIFIER_PLAYER_ADD_FAVOR',                               NULL);

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
SELECT
'AG_' || EraType || '_EUREKAS_gkls621',
'Amount', 4
FROM Eras;

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
SELECT
'AG_' || EraType || '_EUREKAS_gkls621',
'StartEraType', EraType
FROM Eras;

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
SELECT
'AG_' || EraType || '_EUREKAS_gkls621',
'EndEraType', EraType
FROM Eras;

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
SELECT
'AG_' || EraType || '_INSPIRATIONS_gkls621',
'Amount', 4
FROM Eras;

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
SELECT
'AG_' || EraType || '_INSPIRATIONS_gkls621',
'StartEraType', EraType
FROM Eras;

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
SELECT
'AG_' || EraType || '_INSPIRATIONS_gkls621',
'EndEraType', EraType
FROM Eras;

INSERT INTO ModifierArguments
(ModifierId, Name, Value)
VALUES
('AG_CAPITAL_CITY_DISTRICTS_CULTURE_ATTACH_gkls621', 'ModifierId', 'AG_BUILT_CITIES_DISTRICTS_CULTURE_gkls621'),
('AG_BUILT_CITIES_DISTRICTS_CULTURE_ATTACH_gkls621', 'ModifierId', 'AG_BUILT_CITIES_DISTRICTS_CULTURE_gkls621'),
('AG_BUILT_CITIES_DISTRICTS_CULTURE_gkls621', 'Amount', 1),
('AG_BUILT_CITIES_DISTRICTS_CULTURE_gkls621', 'YieldType', 'YIELD_CULTURE'),
('AG_MONUMENT_FAITH_gkls621', 'Amount', 5),
('AG_MONUMENT_FAITH_gkls621', 'YieldType', 'YIELD_FAITH'),
('AG_MONUMENT_INFLUENCE_gkls621', 'Amount', 1),
('AG_MONUMENT_FAVOR_gkls621', 'Amount', 1);

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
('REQSET_AG_PLAYER_HAS_CAPITAL_gkls621',     'REQUIREMENTSET_TEST_ALL'),
('REQSET_AG_DISTRICT_IS_NOT_WONDER_gkls621', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
('REQSET_AG_PLAYER_HAS_CAPITAL_gkls621', 'REQUIRES_CAPITAL_CITY'),
('REQSET_AG_DISTRICT_IS_NOT_WONDER_gkls621', 'AG_DISTRICT_IS_NOT_WONDER_gkls621');

INSERT INTO Requirements (RequirementId, RequirementType, Inverse)
VALUES
('AG_DISTRICT_IS_NOT_WONDER_gkls621', 'REQUIREMENT_DISTRICT_TYPE_MATCHES', 1);

INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES
('AG_DISTRICT_IS_NOT_WONDER_gkls621', 'DistrictType', 'DISTRICT_WONDER');
