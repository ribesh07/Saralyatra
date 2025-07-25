#include <TinyGPS.h>

#define RXD2 16
#define TXD2 17

TinyGPS gps;

void setup() {
  Serial.begin(115200);
  delay(1000);
  Serial.println("📡 Initializing GPS...");

  Serial2.begin(9600, SERIAL_8N1, RXD2, TXD2);
  Serial.println("✅ GPS Serial2 started");
}

void loop() {
  while (Serial2.available()) {
    gps.encode(Serial2.read());
  }

  float latitude, longitude;
  unsigned long age;

  gps.f_get_position(&latitude, &longitude, &age);

  if (age != TinyGPS::GPS_INVALID_AGE) {
    Serial.print("📍 Latitude: ");
    Serial.print(latitude, 6);
    Serial.print("  Longitude: ");
    Serial.println(longitude, 6);
  } else {
    Serial.println("⏳ Waiting for GPS fix...");
  }

  delay(1000);
}
