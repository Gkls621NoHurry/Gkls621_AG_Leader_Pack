INSERT INTO IconDefinitions
(Name, Atlas, 'Index')
SELECT
'ICON_GOVERNOR_AG_gkls621_' || SUBSTR(Name, 15) , Atlas, "Index"
FROM IconDefinitions WHERE Name LIKE 'ICON_GOVERNOR_%';

INSERT INTO IconAliases
(Name, OtherName)
SELECT
'GOVERNOR_AG_gkls621_' || SUBSTR(Name, 10), 'ICON_GOVERNOR_AG_gkls621_' || SUBSTR(OtherName, 15)
FROM IconAliases WHERE Name LIKE 'GOVERNOR_%';