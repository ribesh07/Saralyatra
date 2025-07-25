#include <WiFi.h>
#include <HTTPClient.h>
#include <SPI.h>
#include <MFRC522.h>
#include <TinyGPS.h>
#include <ArduinoJson.h>
#include <time.h>
#include <map>

// WiFi credentials
#define WIFI_SSID "sk"
#define WIFI_PASSWORD "12345678"

// RFID pins
#define SS_PIN 5
#define RST_PIN 22

// GPS pins
#define RXD2 16
#define TXD2 17

MFRC522 rfid(SS_PIN, RST_PIN);
TinyGPS gps;

// NTP
const char* ntpServer = "pool.ntp.org";
const long gmtOffset_sec = 20700;  // Nepal time
const int daylightOffset_sec = 0;

// Store entry states
std::map<String, bool> cardStates;  // true = entered, false = exited

String getLocalTimeISO() {
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println(" Failed to get time");
    return "";
  }

  char timeStr[30];
  strftime(timeStr, sizeof(timeStr), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);
  return String(timeStr);
}

void setup() {
  Serial.begin(115200);

  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("🔌 Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\n WiFi connected");

  // Time setup
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  Serial.println(" Time sync ready");

  // RFID setup
  SPI.begin();
  rfid.PCD_Init();
  Serial.println("RFID ready");

 
}

void loop() {
  // Read RFID
  if (rfid.PICC_IsNewCardPresent() && rfid.PICC_ReadCardSerial()) {
    String uid = "";
    for (byte i = 0; i < rfid.uid.size; i++) {
      uid += String(rfid.uid.uidByte[i], HEX);
    }

    Serial.print("RFID UID: ");
    Serial.println(uid);

    String timestamp = getLocalTimeISO();
    String status = "";

    // Check entry/exit state
    if (cardStates.find(uid) == cardStates.end() || cardStates[uid] == false) {
      // First time or returned => Enter
      cardStates[uid] = true;
      status = "Enter";
    } else if(cardStates[uid]==true){
      // Second time => Exit
      cardStates[uid] = false;
      status = "Exit";
    }

    Serial.print(" Status: ");
    Serial.println(status);

    String driver_ID= "3845797347";

    Serial.print("Driver ID: ");
Serial.println(driver_ID);


    // Build JSON
    StaticJsonDocument<256> doc;
    doc["id"] = uid;
    doc["time"] = timestamp;
    doc["status"] = status;
    doc["driver_ID"]= driver_ID;

    String jsonPayload;
    serializeJson(doc, jsonPayload);

    // Send to API
    HTTPClient http;
    http.begin("http://192.168.254.20:3000/api/send-request");
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.POST(jsonPayload);
    Serial.print("HTTP Response: ");
    Serial.println(httpResponseCode);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(" Server Response:");
      Serial.println(response);
    } else {
      Serial.println(" Failed to send request.");
    }

    http.end();
    rfid.PICC_HaltA();
    delay(1500);  // debounce
  }

  delay(200);
}
