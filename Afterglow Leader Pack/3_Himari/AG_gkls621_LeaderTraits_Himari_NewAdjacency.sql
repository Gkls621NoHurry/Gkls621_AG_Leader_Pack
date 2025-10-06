INSERT INTO Ruivo_New_Adjacency 
    (ID, DistrictType,                              
    ProvideType, YieldType, YieldChange,            
    AdjacencyType, CustomAdjacentObject,       
    DistrictModifiers, TraitType,                    
    Only, FreeCompose)
    SELECT
    'HIMARI_INDUSTRY_' || YieldType || '_FROM_ENGINEER_ACTIVATION_gkls621', 'DISTRICT_INDUSTRIAL_ZONE',
    'SelfBonus', YieldType, 2.0,
    'FROM_PLAYER_PROPERTY', 'HIMARI_ENGINEER_TIMES' ,
    0, 'TRAIT_LEADER_HIMARI_gkls621',
    'Human&AI', 0
    FROM Yields;

INSERT INTO Ruivo_New_Adjacency_Text (ID, Tooltip) SELECT
    'HIMARI_INDUSTRY_' || YieldType || '_FROM_ENGINEER_ACTIVATION_gkls621',
    'LOC_HIMARI_INDUSTRY_FROM_ENGINEER_ACTIVATION_gkls621'
    FROM Yields;