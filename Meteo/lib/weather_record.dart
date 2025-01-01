class WeatherRecord {

  String city;
  String country;
  DateTime timestamp;
  String state;
  String descriptionState;
  double temp;
  double rain;
  int humidity;

  WeatherRecord(this.city, this.country, this.timestamp, this.state,
      this.descriptionState, this.temp, this.rain, this.humidity);

  @override
  String toString() {
    return 'WeatherDay{city: $city, country: $country, timestamp: $timestamp, state: $state, descriptionState: $descriptionState, temp: $temp, rain: $rain, humidity: $humidity}';
  }
}