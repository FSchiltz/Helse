INSERT INTO health.metrictype(id, description, name, unit)
	VALUES (1, null, 'Heart', 'bpm'),
    (2, null , 'Oxygen', '%'),
    (3,null , 'Wheight', 'Kg'),
    (4,null , 'Height', 'm'),
    (5,null , 'Temperature', 'C'),    
    (6,null , 'Steps', ''),
    (7,null , 'Calories', 'kcal'), 
    (8,null , 'Distance', 'm')    ;

    INSERT INTO health.EventType(id,description, name, standalone)
	VALUES (1,null, 'Sleep', true),    
	(2, null, 'Care', false)    ; 