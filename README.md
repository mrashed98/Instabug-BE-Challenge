# Instabug Backend Challenge

This repository contains the backend implementation for the **Instabug BE Challenge**, built with Ruby on Rails and Docker to handle chat-related functionality efficiently.

## Table of Contents
- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Setup Instructions](#setup-instructions)
- [API Endpoints](#api-endpoints)


## Project Overview

This project is a challenge that implements a simple backend for managing chat functionalities, including creating and managing chats, using Rails, Sidekiq for background processing, and MySQL as the database. The project is containerized with Docker for easy deployment and development.

## Tech Stack
- **Ruby on Rails** - Backend framework
- **MySQL** - Database
- **Sidekiq** - Background job processing
- **Redis** - Queueing system for Sidekiq
- **Docker** - Containerization for the project
- **Elasticsearch** - Search engine integration (for scalable search functionality)

## Setup Instructions

### Prerequisites
- Docker and Docker Compose installed
- Ruby `v3.3.3`(for local development, if not using Docker)
- Ruby on Rails `v7.2.1` - Backend development framework
- MySQL server `v8` running (or use the Dockerized MySQL)
- Redis `v7.4.0` Queuing system for Sidekiq
- Elasticsearch `v8.15.0`- Search engine integration 

### Steps
1. **Clone the repository:**
   ```bash
   git clone https://github.com/mrashed98/Instabug-BE-Challenge.git
   cd Instabug-BE-Challenge
   ```
2. Set up environment variables: Copy the .env.example to .env and configure the variables (e.g., MySQL password, Redis URL).

3. Build and run the Docker containers:
   ```bash
   docker-compose up --build
   ```

### API Endpoints

#### Applications

 - Get all applications
   - Method `GET`
   - Endpoint `/applications`
   - Description -> `It gets all the applications on the system`
   - Expected Returned object `List of Application Object`
     
   ```json
   [
    {
        "token": "fpiQbRiR3MsUB5p52zsfn7JX",
        "name": "Re-engineered non-volatile moratorium",
        "chats_count": 2,
        "created_at": "2024-09-22T19:02:33.827Z",
        "updated_at": "2024-09-22T21:12:08.844Z"
    },
    {
        "token": "wNrw5Q17Ae6R9Pxfh4rV1kFF",
        "name": "Object-based",
        "chats_count": 0,
        "created_at": "2024-09-22T23:14:19.246Z",
        "updated_at": "2024-09-22T23:14:19.246Z"
    },
    {
        "token": "qCLJ3f4V9yx3NFZoBBiihHY8",
        "name": "Triple-buffered",
        "chats_count": 0,
        "created_at": "2024-09-22T23:14:19.880Z",
        "updated_at": "2024-09-22T23:14:19.880Z"
    }
   ]
   ```

- Get Specific application
  - Method `GET`
  - Endpoint `/applications/:application_token/`
  - Description -> `It Gets the data for specific application`
  - Expected Returned object `Application object`
 
    ```json
    {
    "token": "fpiQbRiR3MsUB5p52zsfn7JX",
    "name": "Re-engineered non-volatile moratorium",
    "chats_count": 2,
    "created_at": "2024-09-22T19:02:33.827Z",
    "updated_at": "2024-09-22T21:12:08.844Z"
    }
    ```
- Create new application
  - Method `POST`
  - Endpoint `/applications/new`
  - Description -> `It create new application`
  - Params `name` -> type `string`
  - Expected Returned object `The created application token`
 
    ```json
    {
    "token": "xu5TZL5Gwahy311izQc8WMqg"
    }
    ```
- Update application name
  - Method `PUT`
  - Endpoint `/applications/:application_token/update`
  - Description -> `Update the application name
  - Params `name` -> type `string`
  - Expcted returned output `Update successfull msg`

#### Chats
   
   
