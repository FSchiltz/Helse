BEGIN;
LOCK TABLE health.MetricType IN EXCLUSIVE MODE;

ALTER TABLE health.MetricType ADD COLUMN Visible boolean NOT NULL DEFAULT TRUE;
ALTER TABLE health.MetricType ADD COLUMN UserEditable boolean NOT NULL DEFAULT TRUE;

--Make the first row non user editable (this disable deleting but allow changing names and description)
UPDATE health.MetricType SET UserEditable = FALSE WHERE Id < 9;


-- Add delete cascade to allow update the primay key of the type
ALTER TABLE health.Metric
  DROP CONSTRAINT FK_Type_TO_Metric;

ALTER TABLE health.Metric
  ADD CONSTRAINT FK_Type_TO_Metric
    FOREIGN KEY (Type)
    REFERENCES health.MetricType (Id)
    ON UPDATE CASCADE;


UPDATE health.MetricType SET Id = (Id + 100) WHERE UserEditable = TRUE;

-- Set the key at around 100 to leave space for future hardcoded metric
SELECT setval(pg_get_serial_sequence('health.MetricType','id'), COALESCE((SELECT MAX(Id)+1 FROM health.MetricType), 1), false);

INSERT INTO health.MetricType(id, description, name, unit, type, summaryType, usereditable)
	VALUES (9, null, 'Menstruation', '', 1, 0, false),
    (10, null, 'Pain', '', 1, 0, false),
    (11, null, 'Mood', '', 0, 0, false);

COMMIT;