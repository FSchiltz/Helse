BEGIN TRANSACTION;

INSERT INTO
    health.MetricType(
        id,
        description,
        name,
        unit,
        type,
        summaryType,
        usereditable,
        GroupId
    )
VALUES
    (17, null, 'Head Diameter', 'cm', 1, 0, false, 2),
    (18, null, 'Diapper', '', 0, 0, false, 1);

INSERT INTO
    health.EventType(id, description, name, standalone, UserEditable)
VALUES
    (4, null, 'Bath', true, false),
    (5, null, 'Feeding', true, false);

ALTER TABLE health.Event ADD COLUMN source INT NOT NULL DEFAULT 0;

COMMIT;