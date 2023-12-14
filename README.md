# Temperature API
### This Demo API is based on Rack

## Endpoints

### [GET] http://localhost:9393/temp/c2f?value=28
Convert celsuis to fahrenheit
```
{
  fahrenheit: 82.4
}
```

### [GET] http://localhost:9393/temp/f2c?value=98
Convert fahrenheit to celsius
```
{
  celsius: 36.67
}
```

### [GET] http://localhost:9393/pressure/boiling-point?hpa=7500
Boiling point of water for given pressure in hPa
```
{
  temperature: 332.74,
  scale: "fahrenheit"
}
```

## Install
```
bundle
./server.sh
```

## Configuration
```
.env
```

## Tests with Minitest
```
ruby -Itest test/controllers/pressure_controller_test.rb
ruby -Itest test/interactors/pressure_point_test.rb
ruby -Itest test/interactors/temperature_conterter_test.rb
```
