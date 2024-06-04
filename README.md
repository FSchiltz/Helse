# Helse

[![CI](https://github.com/FSchiltz/Helse/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/FSchiltz/Helse/actions/workflows/ci.yml)

This is a simple work in progress selfhosted app for logging health data.
The app is composed of a c# webapi and a flutter app that can be run on Web or Android/iOS.


![image](https://github.com/FSchiltz/Helse/assets/1764553/78dc1cbe-c870-4e51-a88a-95a654a27dcf)

## Usage

### First use

On the first connexion to the app, the URL of the API will be by default the one used by the web page but that can be changed
The webapp will ask for the information of the admin account then open the main page.

### Dashboard

Depending of the user type, a dashboard will open.
For the user, a recap of the metric and event for the day will show

### Metric

A metric is a data health data representing any thing a a specific moment.
Helse comes with some metric type by default but an admin can change and add more if needed.

### Events

An event is more of a logbook event or anything that can have a duration.
Helse by default use event for care but admin can add more event type if needed.

### Treatment

Not ready yet for use.
Represent a list of recurring events. Exemple: take a medicine every 2 day at 12:30.

### User type

- User: the basic user, can add and view their metric and event.
- Admin: Works as an user but can also edit the settings of the server
- Caregiver: Works as an user but can also add patients and edit and view their metric/event and treatment.
    This role is useful if you need to track the care of someone else.

## Feature to come

- Multiple roles for a user
- Add better graphs detail for the metric
- Allow marking event as TODO and DONE.
- Support for google health connect sync
- Notification for incoming event
- And more

## Installation

The easiest way to use the app is to use docker-compose
exemple config:

``` yaml
volumes:
  data:

services:
  helse:
    image: ghcr.io/fschiltz/helse:latest
    ports:
      - 8080:8080
    environment:
      - ConnectionStrings__Default=Server=database;Port=5432;Database=helse;User Id=postgres;Password=somethinglong
      - Jwt__Issuer=health.yoursite.com
      - Jwt__Audience=health.yoursite.com
      - Jwt__Key=asuperlongrandomkey
    restart: always
    depends_on:
      - database

  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: somethinglong
      POSTGRES_USER: postgres
      POSTGRES_DB: helse
    restart: always
    volumes:
      - data:/var/lib/postgresql/data
    healthcheck:
      test:
        [
          "CMD",
          "pg_isready",
          "-q",
          "-d",
          "helse",
          "-U",
          "postgres"
        ]
      interval: 5s
      timeout: 5s

```

## Local debugging

The best editor to debug is to use VS code with the c# and flutter extensions.
Launching the debug target 'Launch' should automatically open the swagger API and the flutter web app.
