#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#include "time.h"

// Replace with your network credentials
#define WIFI_SSID "sk"
#define WIFI_PASSWORD "12345678"

// Replace with your Firebase credentials
#define API_KEY ""
#define DATABASE_URL "https://saralyatra-8074-default-rtdb.asia-southeast1.firebasedatabase.app"
#define USER_EMAIL "ribeshkumarsah@gmail.com"
#define USER_PASSWORD "Ribesh@1"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Timezone config
const char *ntpServer = "pool.ntp.org";
const long gmtOffset_sec = 19800; // Nepal Time (UTC+5:45 = 5*3600 + 45*60 = 19800)
const int daylightOffset_sec = 0;

void setup()
{
  Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println("\nConnected to WiFi");

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  while (auth.token.uid == "")
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nAuthenticated with Firebase");

  // Initialize NTP
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  Serial.println("Time configured");
}

void loop()
{
  // Get current time
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo))
  {
    Serial.println("Failed to obtain time");
    return;
  }

  // Format date and time
  char datetime[30];
  strftime(datetime, sizeof(datetime), "%Y-%m-%d %H:%M:%S", &timeinfo);

  // Prepare JSON data
  FirebaseJson json;
  json.set("message", "Hello from ESP32");
  json.set("timestamp", String(datetime));

  // Push to Firebase
  if (Firebase.RTDB.pushJSON(&fbdo, "/test/messages", &json))
  {
    Serial.println("Data sent: " + String(datetime));
  }
  else
  {
    Serial.print("Error: ");
    Serial.println(fbdo.errorReason());
  }

  delay(1000); // wait 1 second
}
