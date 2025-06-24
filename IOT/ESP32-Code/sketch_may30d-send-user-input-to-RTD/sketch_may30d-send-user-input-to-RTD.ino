#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define WIFI_SSID "sk"
#define WIFI_PASSWORD "12345678"

#define API_KEY ""
#define DATABASE_URL "https://saralyatra-8074-default-rtdb.asia-southeast1.firebasedatabase.app"

#define USER_EMAIL "ribeshkumarsah@gmail.com"
#define USER_PASSWORD "Ribesh@1"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

String inputString = "";

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
  Serial.println("Type a message and press Enter to send to Firebase:");
}

void loop()
{
  // Check for Serial input
  while (Serial.available())
  {
    char c = Serial.read();
    if (c == '\n')
    {
      // Send to Firebase when Enter is pressed
      if (inputString.length() > 0)
      {
        String path = "/test/inputMessage"; // Change path if needed

        if (Firebase.RTDB.setString(&fbdo, path, inputString))
        {
          Serial.println("Message sent to Firebase: " + inputString);
        }
        else
        {
          Serial.print("Error sending to Firebase: ");
          Serial.println(fbdo.errorReason());
        }

        inputString = ""; // Reset for next input
      }
    }
    else
    {
      inputString += c;
    }
  }
}
