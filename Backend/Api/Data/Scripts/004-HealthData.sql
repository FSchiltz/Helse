INSERT INTO health.metrictype( description, name, unit, type, summaryType)
	VALUES ( null, 'Heart', 'bpm', 1, 0),
    (null , 'Oxygen', '%', 1, 0),
    (null , 'Wheight', 'Kg', 1, 0),
    (null , 'Height', 'm', 1, 0),
    (null , 'Temperature', 'C', 1, 0),    
    (null , 'Steps', '', 1, 1),
    (null , 'Calories', 'kcal', 1, 1), 
    (null , 'Distance', 'm', 1, 1)    ;

    INSERT INTO health.EventType(description, name, standalone)
	VALUES (null, 'Sleep', true), 
    (null, 'Generic', true),  
    (null, 'Medicine', true),  
	(null, 'Care', false),
    (null, 'Workout', true)     ; 