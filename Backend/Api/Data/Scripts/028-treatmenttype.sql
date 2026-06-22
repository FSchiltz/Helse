-- Add the metric group property to the event table
ALTER TABLE
    health.EventType
ADD
    COLUMN GroupId BIGINT NOT NULL DEFAULT 1;

-- Add the new metric group
DO $$
DECLARE newId BIGINT;

BEGIN
SELECT
    id + 1
FROM
    health.MetricGroup
order by
    id desc
limit
    1 INTO newId;

INSERT INTO
    health.MetricGroup(
        id,
        name,
        description,
        showtitle,
        showOndashboard
    )
VALUES
    (newId, 'Treatments', '', true, true) RETURNING id INTO newId;

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

END $$;


-- Add the new metric group
DO $$
DECLARE newId BIGINT;

BEGIN
SELECT
    id + 1
FROM
    health.MetricGroup
order by
    id desc
limit
    1 INTO newId;

INSERT INTO
    health.MetricGroup(
        id,
        name,
        description,
        showtitle,
        showOndashboard
    )
VALUES
    (newId, 'Sleep', '', true, true) RETURNING id INTO newId;

-- move the Sleep to the correct metricgroup
UPDATE
    health.EventType
SET
    GroupId = newId
WHERE
    ID = 1;

END $$;


UPDATE
    health.EventType
SET
    GroupId = 4
WHERE
    ID = 3;
    
    -- Set the key at around 100 to leave space for future hardcoded metric
SELECT setval(pg_get_serial_sequence('health.MetricGroup','id'), COALESCE((SELECT MAX(Id)+100 FROM health.MetricGroup), 1), false);
