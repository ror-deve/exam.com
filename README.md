# Pariksha24.com


To get started in development begin with the following:
```
rvm use 3.1.2@pariksha24.com --create
```

* Install all dependencies

```
bundle install
yarn install
```

* Set-up database
```
rails db:setup
rails db:migrate
```

* Install Redis
```
redis-server
```

* Install minio on local machine

```
#ubuntu
wget https://dl.minio.io/server/minio/release/linux-amd64/minio
chmod +x minio
sudo mv minio /usr/local/bin
sudo mkdir /data
sudo minio server /data

open url to browser
http://127.0.0.1:9000 
login with below credentials 
RootUser: minioadmin 
RootPass: minioadmin 

create the secret key 
create bucket
open your aws.yml

access_key_id: your_minio_key_id
secret_access_key: your_minio_secret_key 
region: us-east-1
bucket: your_minio_bucket_name
s3_endpoint: http://127.0.0.1:9000

```

* Start application

```
rails s
```

* Important NOTES
```
1. After adding changes in JS run `yarn build`
2. After adding changes in CSS/SCSS run`yarn build:css`
3. We have aded TODO reminder in code base, if you are adding incomplete or patch code please add `TODO:` before the code.  
```

## Using Docker 

Please ensure you are using Docker Compose V2. This project relies on the `docker compose` command, not the previous `docker-compose` standalone program.

https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command

Check your docker compose version with:
```
% docker compose version
Docker Compose version v2.10.2
```

## Initial setup
```
cp .env.example .env
docker compose build
docker compose run --rm web bin/rails db:setup
```

## Running the Rails app
```
docker compose up

For development - http://localhost:3000/
```

## Running the Rails console
When the app is already running with `docker-compose` up, attach to the container:
```
docker compose exec web bin/rails c
```

When no container running yet, start up a new one:
```
docker compose run --rm web bin/rails c
```

## Running tests
```
docker compose run --rm web bin/rspec
```

## Updating gems
```
docker compose run --rm web bundle update
docker compose up --build
```
