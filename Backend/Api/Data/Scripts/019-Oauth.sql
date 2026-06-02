CREATE TABLE person.OauthUser (
    UserId BIGINT NOT NULL,
    OauthSub VARCHAR Not NULL,
    Provider VARCHAR NOT NULL,
    PRIMARY KEY(OauthSub, Provider)
);

ALTER TABLE
    person.OauthUser
ADD
    CONSTRAINT FK_Oauth_TO_User FOREIGN KEY (UserId) REFERENCES person.User (Id);
