# IP geolocation API
### This Demo API is based on Rack
This app is using Redis as a database to cache results from external API (ipstack.com).
If you request geolocation for ip used previously, data will be fetched from cache.

## Endpoints

### [POST] http://localhost:9292/geolocations
Request body [JSON]
```
{ "ip": "4.21.21.11" }
```
## Authorization
Bearer token
```
Bearer 8STR7A1UL0FQYW18
```

## Running locally (Docker)
```
docker-compose up redis web --build
```

## Running locally (no Docker)
```
bundle
./server.sh
```

## Configuration
```
.env
```

## Running tests (Docker)
```
docker-compose run test
```

## Running tests (no Docker)
```
rspec
```
<img width="646" alt="api" src="https://github.com/marsiox/ip-geolocation/assets/849456/42dc5ebf-d871-446f-b501-4a43499260e6">
