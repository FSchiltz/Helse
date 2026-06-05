CREATE TABLE person.Sessions (
    UserId BIGINT NOT NULL,
    SessionId VARCHAR NOT NULL,
    Ip VARCHAR NULL,
    Location VARCHAR NULL,
    Start TIMESTAMP NOT NULL,
    Stop TIMESTAMP NOT NULL,
    UserAgent VARCHAR NULL,
    PRIMARY KEY(UserId, SessionId)
);

ALTER TABLE
    person.Sessions
ADD
    CONSTRAINT FK_Sessions_TO_User FOREIGN KEY (UserId) REFERENCES person.User (Id) ON DELETE CASCADE;