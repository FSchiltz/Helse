CREATE TABLE
    person.Settings (
        Id BIGINT NOT NULL,
        Name VARCHAR NOT NULL,
        Blob json NOT NULL,
        PRIMARY KEY (Id, Name)
    );