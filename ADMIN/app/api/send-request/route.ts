import { NextRequest, NextResponse } from "next/server";

export async function POST(req: NextRequest) {
  try {
    const body = await req.json(); // Parse the incoming JSON body
    const { id, time } = body;
    console.log("Received request from ESP32 :", id, time);
    if (!id || !time) {
      return NextResponse.json(
        { error: "Missing id or time in request body" },
        { status: 400 }
      );
    }

    return NextResponse.json({
      message: "Data received successfully",
      received: { id, time },
    });
  } catch (error) {
    return NextResponse.json(
      { error: "Invalid JSON or request format" },
      { status: 400 }
    );
  }
}

// HTTPClient http;
// String jsonData = "{\"id\":\"esp32-001\",\"time\":\"2025-07-24T22:00:00Z\"}";
// http.begin("http://192.168.254.20:3000/api/send-request");
// http.addHeader("Content-Type", "application/json");
// int httpResponseCode = http.POST(jsonData);
//   Serial.print("HTTP Response code: ");
//     Serial.println(httpResponseCode);

//     if (httpResponseCode > 0) {
//       String response = http.getString();
//       Serial.println("Response:");
//       Serial.println(response);
//     }

//     http.end();

// void loop() {
//   if (WiFi.status() == WL_CONNECTED) {
//     HTTPClient http;

//     http.begin(serverURL); // specify URL
//     http.addHeader("Content-Type", "application/json");

//     // Prepare your JSON data
//     String jsonData = "{\"device\":\"ESP32\",\"temperature\":25.4,\"status\":\"active\"}";

//     // Send POST request
//     int httpResponseCode = http.POST(jsonData);

//     // Print response
//     Serial.print("HTTP Response code: ");
//     Serial.println(httpResponseCode);

//     if (httpResponseCode > 0) {
//       String response = http.getString();
//       Serial.println("Response:");
//       Serial.println(response);
//     }

//     http.end(); // free resources
//   } else {
//     Serial.println("WiFi Disconnected");
//   }

//   delay(10000); // wait before next post
// }
