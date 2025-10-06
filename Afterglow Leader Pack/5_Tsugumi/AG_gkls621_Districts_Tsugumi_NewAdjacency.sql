INSERT INTO Ruivo_New_Adjacency 
    (ID, DistrictType,                              
    ProvideType, YieldType, YieldChange,            
    AdjacencyType, CustomAdjacentObject,       
    DistrictModifiers, TraitType,                    
    Only, FreeCompose)
    VALUES
    ('CAFFE_AMENITY_FROM_CITY_OUTGOING_ROUTES_gkls621', 'DISTRICT_CAFFE_gkls621',
    'SelfAmenity', 'YIELD_AMENITY', 2,
    'FROM_CITY_PROPERTY', 'TSUGU_CITY_OUTGOING_ROUTES',
    1, NULL,
    'Human&AI', 0),
    ('CAFFE_HOUSING_FROM_CITY_INCOMING_ROUTES_gkls621', 'DISTRICT_CAFFE_gkls621',
    'SelfHousing', 'YIELD_HOUSING', 2,
    'FROM_CITY_PROPERTY', 'TSUGU_CITY_INCOMING_ROUTES',
    1, NULL,
    'Human&AI', 0),
    ('CAFFE_CAPACITY_FROM_POPULATION_gkls621', 'DISTRICT_CAFFE_gkls621',
    'SelfTradeRoute', 'YIELD_TRADE_ROUTE', 0.167,
    'FROM_CITY_POPULATION', 'NONE',
    1, NULL,
    'Human&AI', 0);

INSERT INTO Ruivo_New_Adjacency_Text (ID, Tooltip)VALUES
    ('CAFFE_AMENITY_FROM_CITY_OUTGOING_ROUTES_gkls621', 'LOC_CAFFE_AMENITY_FROM_CITY_OUTGOING_ROUTES_gkls621'),
    ('CAFFE_HOUSING_FROM_CITY_INCOMING_ROUTES_gkls621', 'LOC_CAFFE_HOUSING_FROM_CITY_INCOMING_ROUTES_gkls621');