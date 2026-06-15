ALTER TABLE
    health.MetricType
ADD
    COLUMN ValueCount INT NULL;

INSERT INTO
    health.MetricType(
        id,
        description,
        name,
        type,
        summaryType,
        usereditable,
        GroupId
    )
VALUES
    (19, null, 'Blood pressure',  3, 0, false, 2);