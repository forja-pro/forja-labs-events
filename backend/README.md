# Backend API

This is the backend API for the Forja Labs Posts project.

## Project Structure

The project is structured as follows:

```
.
├── cmd
│   └── main.go
├── config
│   ├── db.go
│   └── init.go
├── internal
│   ├── core
│   │   ├── dto
│   │   ├── entity
│   │   └── service
│   └── infra
│       ├── db
│       │   └── repository
│       ├── http
│       │   ├── controller
│       │   └── routes
│       └── server
├── .air.toml
├── .env.example
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── go.mod
├── go.sum
└── wait-for-it.sh
```

- **cmd/main.go**: The entry point of the application.
- **config**: Contains the configuration for the database and other services.
- **internal**: Contains the core business logic of the application.
  - **core**: Contains the core entities, services, and data transfer objects.
    - **entity**: Contains the domain entities.
    - **service**: Contains the business logic services.
    - **dto**: Contains the data transfer objects.
  - **infra**: Contains the infrastructure-related code, such as database repositories and HTTP handlers.
    - **db**: Contains the database-related code.
      - **repository**: Contains the database repositories.
    - **http**: Contains the HTTP-related code.
      - **controller**: Contains the HTTP controllers.
      - **routes**: Contains the HTTP routes.
    - **server**: Contains the server-related code.
- **.air.toml**: Configuration file for Air, a live-reloading tool for Go.
- **.env.example**: Example environment file.
- **.gitignore**: Git ignore file.
- **docker-compose.yml**: Docker Compose file for running the application and its dependencies.
- **Dockerfile**: Dockerfile for building the application image.
- **go.mod**: Go modules file.
- **go.sum**: Go modules sum file.
- **wait-for-it.sh**: A script to wait for a service to be available.

## Getting Started

To get started with the project, you need to have Go and Docker installed.

1. Clone the repository:

```bash
git clone https://github.com/forja-pro/forja-labs-posts.git
```

2. Navigate to the project directory:

```bash
cd forja-labs-posts/backend
```

3. Create a `.env` file from the `.env.example` file and update the environment variables.

4. Run the application using Docker Compose:

```bash
docker-compose up -d
```

## Dependencies

The project uses the following dependencies:

- [GORM](https://gorm.io/): A developer-friendly ORM for Go.
- [PostgreSQL](https://www.postgresql.org/): A powerful, open source object-relational database system.
