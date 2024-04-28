# Helse

[![CI](https://github.com/FSchiltz/Helse/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/FSchiltz/Helse/actions/workflows/ci.yml)

This is a simple work in progress selfhosted app for logging health data

## Usage

### First use

On the first connexion to the app, the url of the API will be by default the one used by the webpage but that can be changed
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
- Allow patient to be tranformed into a full user
- Allow user to set their caregiver
- Allow patients sharing between caregiver
- Add better graphs detail for the metric
- Allow marking event as TODO and DONE.
- Android app with support for google health connect sync
- Bare metal install
- And more

## Installation

The easiest way to use the app is to use docker-compose
exemple config:

