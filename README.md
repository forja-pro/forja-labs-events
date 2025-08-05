# Forja Labs Events

## Frontend

### Pages

- Home page
- Event page

### Integrations

- Backend APIs
  - Confirm user subscription
  - Get notifications

- Google Sheet APIs
  - Get events

- Google Firebase
  - Push notifications

- Apple Developers Program
  - Push notifications

## Backend

### Integrations

- Resend or Mailgun !?

### Endpoints

- POST /api/events/:id/user-subcription
```json
{
  "email": "user@domain.com"
}
```

### Scheduling/Cron

- Daily at 9 PM gets the next events for the user, for the next day and send them an email
