INSERT INTO health.metrictype(description, name, unit)
	VALUES (null, 'Heart', 'bpm'),
    (null , 'Oxygen', '%'),
    (null , 'Wheight', 'Kg'),
    (null , 'Height', 'm'),
    (null , 'Temperature', 'C'),    
    (null , 'Steps', ''),
    (null , 'Calories', 'kcal'), 
    (null , 'Distance', 'm')    ;

    INSERT INTO health.EventType(description, name, standalone)
	VALUES (null, 'Sleep', true),    
	(null, 'Care', false)    ; 