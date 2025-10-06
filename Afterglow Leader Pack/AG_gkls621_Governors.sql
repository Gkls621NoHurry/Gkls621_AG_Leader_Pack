-- Afterglow faster governors
INSERT INTO Types
(Type, Kind)
SELECT
'GOVERNOR_AG_gkls621_' || SUBSTR(GovernorType,10), 'KIND_GOVERNOR'
FROM Governors g WHERE TraitType IS NULL
AND NOT EXISTS(SELECT 1 FROM GovernorsCannotAssign gca WHERE gca.GovernorType = g.GovernorType AND gca.CannotAssign = 1);

INSERT INTO Types
(Type, Kind)
SELECT
'TRAIT_GOVERNOR_AG_gkls621_' || SUBSTR(GovernorType,10), 'KIND_TRAIT'
FROM Governors g WHERE TraitType IS NULL
AND NOT EXISTS(SELECT 1 FROM GovernorsCannotAssign gca WHERE gca.GovernorType = g.GovernorType AND gca.CannotAssign = 1);

INSERT INTO Traits
(TraitType)
SELECT
'TRAIT_GOVERNOR_AG_gkls621_' || SUBSTR(GovernorType,10)
FROM Governors g WHERE TraitType IS NULL
AND NOT EXISTS(SELECT 1 FROM GovernorsCannotAssign gca WHERE gca.GovernorType = g.GovernorType AND gca.CannotAssign = 1);

INSERT INTO Governors
(GovernorType,
Name,
Description,
IdentityPressure,
Title,
ShortTitle,
TransitionStrength,
AssignCityState,
Image,
PortraitImage,
PortraitImageSelected,
TraitType)
SELECT
'GOVERNOR_AG_gkls621_' || SUBSTR(GovernorType,10),
Name,
Description,
IdentityPressure*3,
Title,
ShortTitle,
CASE
    WHEN TransitionStrength <= 250 THEN 250
    ELSE TransitionStrength
END AS TransitionStrength,
--IF(TransitionStrength <= 250, 250, TransitionStrength) AS TransitionStrength,
--250,
AssignCityState,
Image,
PortraitImage,
PortraitImageSelected,
'TRAIT_GOVERNOR_AG_gkls621_' || SUBSTR(GovernorType,10)
FROM Governors g WHERE TraitType IS NULL
AND NOT EXISTS(SELECT 1 FROM GovernorsCannotAssign gca WHERE gca.GovernorType = g.GovernorType AND gca.CannotAssign = 1);

INSERT INTO GovernorPromotionSets
(GovernorType, GovernorPromotion)
SELECT
'GOVERNOR_AG_gkls621_' || SUBSTR(gp.GovernorType,10), gp.GovernorPromotion
FROM GovernorPromotionSets gp
JOIN Governors g ON g.GovernorType = gp.GovernorType AND g.TraitType IS NULL
WHERE NOT EXISTS(SELECT 1 FROM GovernorsCannotAssign gca WHERE gca.GovernorType = g.GovernorType AND gca.CannotAssign = 1);

INSERT INTO CivilopediaPageExcludes
(SectionId, PageId)
SELECT
'GOVERNORS', 'GOVERNOR_AG_gkls621_' || SUBSTR(GovernorType,10)
FROM Governors g WHERE TraitType IS NULL
AND NOT EXISTS(SELECT 1 FROM GovernorsCannotAssign gca WHERE gca.GovernorType = g.GovernorType AND gca.CannotAssign = 1);

INSERT INTO CivilopediaPageGroupExcludes
(SectionId, PageGroupId)
SELECT
'GOVERNORS', 'GOVERNOR_AG_gkls621_' || SUBSTR(GovernorType,10)
FROM Governors g WHERE TraitType IS NULL
AND NOT EXISTS(SELECT 1 FROM GovernorsCannotAssign gca WHERE gca.GovernorType = g.GovernorType AND gca.CannotAssign = 1);