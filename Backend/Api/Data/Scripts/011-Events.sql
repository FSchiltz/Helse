BEGIN;
LOCK TABLE health.Eventtype  IN EXCLUSIVE MODE;

ALTER TABLE health.Eventtype ADD COLUMN Visible boolean NOT NULL DEFAULT TRUE;
ALTER TABLE health.Eventtype ADD COLUMN UserEditable boolean NOT NULL DEFAULT TRUE;

--Make the first row non user editable (this disable deleting but allow changing names and description)
UPDATE health.Eventtype SET UserEditable = FALSE WHERE Id < 3;


-- Add delete cascade to allow update the primay key of the type

ALTER TABLE health.Event
  DROP CONSTRAINT FK_Type_TO_Event;
 
ALTER TABLE health.Event
  ADD CONSTRAINT FK_Type_TO_Event
    FOREIGN KEY (Type)
    REFERENCES health.EventType (Id);


UPDATE health.EventType SET Id = (Id + 100) WHERE UserEditable = TRUE;


-- Set the key at around 100 to leave space for future hardcoded metric
SELECT setval(pg_get_serial_sequence('health.EventType','id'), COALESCE((SELECT MAX(Id)+100 FROM health.EventType), 1), false);


    INSERT INTO health.EventType(id, description, name, standalone)
	VALUES (3, null, 'Workout', true); 
   
   COMMIT;

