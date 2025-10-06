-- Historical Moment Illustrations
INSERT INTO MomentIllustrations
(MomentIllustrationType,                    MomentDataType,             GameDataType,                       Texture)
VALUES
('MOMENT_ILLUSTRATION_UNIQUE_BUILDING',     'MOMENT_DATA_BUILDING',     'BUILDING_ROOFTOP_gkls621',         'Moment_Infrastructure_AG_gkls621'),
('MOMENT_ILLUSTRATION_UNIQUE_UNIT',         'MOMENT_DATA_UNIT',         'UNIT_FELLOW_GANG_gkls621',         'Moment_UniqueUnit_FellowGang_gkls621'),
('MOMENT_ILLUSTRATION_UNIQUE_UNIT',         'MOMENT_DATA_UNIT',         'UNIT_BABANBO_gkls621',             'Moment_UniqueUnit_Babanbo_gkls621'),
('MOMENT_ILLUSTRATION_UNIQUE_IMPROVEMENT',  'MOMENT_DATA_IMPROVEMENT',  'IMPROVEMENT_SUNNY_DOLL_gkls621',   'Moment_Infrastructure_Himari_gkls621'),
('MOMENT_ILLUSTRATION_UNIQUE_UNIT',         'MOMENT_DATA_UNIT',         'UNIT_TAIKO_TEAM_gkls621',          'Moment_UniqueUnit_TaikoTeam_gkls621');

INSERT INTO MomentIllustrations
(MomentIllustrationType, MomentDataType, GameDataType, Texture)
SELECT
'MOMENT_ILLUSTRATION_GOVERNOR', 'MOMENT_DATA_GOVERNOR',
'GOVERNOR_AG_gkls621_' || SUBSTR(g.GovernorType,10), mi.Texture
FROM MomentIllustrations mi
JOIN Governors g 
ON mi.GameDataType = g.GovernorType AND g.TraitType IS NULL;