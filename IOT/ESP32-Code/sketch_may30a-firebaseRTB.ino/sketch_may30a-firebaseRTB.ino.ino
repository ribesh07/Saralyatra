#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Provide the token generation process info
#include "addons/TokenHelper.h"

// Provide the RTDB payload printing info and other helper functions
#include "addons/RTDBHelper.h"

// Replace with your network credentials
#define WIFI_SSID "sk"
#define WIFI_PASSWORD "12345678"
// Replace with your Firebase project credentials
#define API_KEY ""
#define DATABASE_URL "https://saralyatra-8074-default-rtdb.asia-southeast1.firebasedatabase.app"

// Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

void setup()
{
  Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.println("WiFi connected");

  // Set API key and RTDB URL
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  // Anonymous login
  auth.user.email = "ribeshkumarsah@gmail.com";
  auth.user.password = "Ribesh@1";

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Wait for token
  while (auth.token.uid == "")
  {
    Serial.println("Waiting for token...");
    delay(1000);
  }
  Serial.println("\nAuthenticated with Firebase");
  String path = "/test/message";
  // message for db
  FirebaseJson msg;
  msg.set("message", "Hello from ESP32");
  msg.set("timestamp", millis());

  if (Firebase.RTDB.pushJSON(&fbdo, "/Data/", &msg))
  {
    Serial.println("Message with timestamp sent!");
  }
  else
  {
    Serial.println("Send failed: " + fbdo.errorReason());
  }
  // Read value
  // if (Firebase.RTDB.getString(&fbdo, path)) {
  //   Serial.print("Data read successfully: ");
  //   Serial.println(fbdo.stringData());
  // } else {
  //   Serial.print("Failed to read data: ");
  //   Serial.println(fbdo.errorReason());
  // }
  // // Send test data
  // if (Firebase.RTDB.setString(&fbdo, "/test/message", "Hello from ESP32")) {
  //   Serial.println("Message sent!");
  // } else {
  //   Serial.println("Send failed: " + fbdo.errorReason());
  // }
}

void loop()
{
}
