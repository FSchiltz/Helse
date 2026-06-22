-- Add the new metric group
DO $$
DECLARE newId OAMENI.id%TYPE;

INSERT INTO
    health.MetricGroup(
        name,
        description,
        showtitle,
        showOndashboard
    )
VALUES
    ('Treatments', '', true, true) RETURNING id INTO newId;

-- Add the metric group property to the event table
ALTER TABLE
    health.EventType
ADD
    COLUMN GroupId BIGINT NOT NULL DEFAULT 1;

-- update the name of the Test metric to checkups
-- move the checkups metrics to the new group
UPDATE
    health.MetricType
SET
    Name = 'Checkups',
    GroupId = newId
WHERE
    Id = 13;

UPDATE
    health.MetricType
SET
    GroupId = newId
WHERE
    Id = 12;

-- move the activity and care group to the correct metricgroup
UPDATE
    health.EventType
SET
    GroupId = newId
WHERE
    ID = 2;

UPDATE
    health.EventType
SET
    GroupId = 4
WHERE
    ID = 3;
END $$