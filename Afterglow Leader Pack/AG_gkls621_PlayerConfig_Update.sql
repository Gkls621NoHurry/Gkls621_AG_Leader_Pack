INSERT INTO PlayerItems
(Domain, CivilizationType, LeaderType, Type, Name, Description, Icon, SortIndex)
SELECT DISTINCT
'Players:Expansion2_Players', 'CIVILIZATION_AG_gkls621', 'LEADER_RAN_gkls621',
'DISTRICT_IKEBANA_FAMILY_gkls621', 'LOC_DISTRICT_IKEBANA_FAMILY_gkls621_NAME', 'LOC_DISTRICT_IKEBANA_FAMILY_gkls621_DESCRIPTION',
'ICON_DISTRICT_IKEBANA_FAMILY_gkls621', 30
FROM PlayerItems
WHERE EXISTS(SELECT 1 FROM Parameters WHERE ParameterId = 'GardensPlusPreserves');

INSERT INTO PlayerItems
(Domain, CivilizationType, LeaderType, Type, Name, Description, Icon, SortIndex)
SELECT DISTINCT
'Players:Expansion2_Players', 'CIVILIZATION_AG_gkls621', 'LEADER_TSUGUMI_gkls621',
'DISTRICT_CAFFE_gkls621', 'LOC_DISTRICT_CAFFE_gkls621_NAME', 'LOC_DISTRICT_CAFFE_gkls621_DESCRIPTION',
'ICON_DISTRICT_CAFFE_gkls621', 30
FROM PlayerItems
WHERE EXISTS(SELECT 1 FROM PlayerItems WHERE Type = 'BUILDING_HSPIND_CHINA');