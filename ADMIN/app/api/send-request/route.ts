import { NextRequest, NextResponse } from "next/server";
import { db } from "@/components/db/firebase";
import {
  collection,
  getDoc,
  doc,
  updateDoc,
  setDoc,
  addDoc,
} from "firebase/firestore";

export async function POST(req: NextRequest) {
  try {
    const baseUrl = process.env.NEXT_PUBLIC_BASE_URL || "http://localhost:3000";
    const body = await req.json(); // Parse the incoming JSON body
    const { id, time, status, driver_ID } = body;
    console.log("Received request from ESP32 :", id, time, status, driver_ID);
    if (!id || !time || !status || !driver_ID) {
      return NextResponse.json(
        { error: "Missing id or time in request body" },
        { status: 400 }
      );
    }

    if (id && driver_ID) {
      // return NextResponse.json({
      //   message: "HOla",
      // });
      const response = await fetch(`${baseUrl}/api/socket-response`);
      const data = await response.json();
      console.log(data.drivers[0].uid);
      const driverData = data.drivers.map((driver: any) => ({
        uid: driver.uid,
        lat: driver.latitude,
        lng: driver.longitude,
      }));
      console.log(driverData[0]);
      if (status === "Enter") {
        const checksucc = await savehistory(
          id,
          driverData[0].uid,
          driverData[0].lat,
          driverData[0].lng
        );
        if (checksucc) {
          return NextResponse.json({
            success: true,
            message: "Welcome to Saralyatra Services !",
          });
        } else {
          return NextResponse.json({
            success: false,
            message: "Card History not added sorry !",
          });
        }
      } else {
        const checksuccess = await transferBalance(
          id,
          driverData[0].uid,
          driverData[0].lat,
          driverData[0].lng
        );
      }
    }

    return NextResponse.json({
      message: `Data received successfully ${id} ${time} ${status} ${driver_ID}`,
      received: { id, time, status, driver_ID },
    });
  } catch (error) {
    console.log(error);
    return NextResponse.json(
      { error: "Invalid JSON or request format" },
      { status: 400 }
    );
  }
}

const transferBalance = async (
  userId: any,
  driverId: any,
  lat: any,
  lng: any
) => {
  try {
    // Step 1: Reference for user and driver
    const userRef = doc(
      db,
      "saralyatra",
      "userDetailsDatabase",
      "users",
      userId
    );
    const driverRef = doc(
      db,
      "saralyatra",
      "driverDetailsDatabase",
      "drivers",
      driverId
    );

    const paymentsRef = collection(
      db,
      "saralyatra",
      "paymentDetails",
      "userLocalPaymentHistory",
      userId,
      "payments"
    );
    const driverPaymentsRef = collection(
      db,
      "saralyatra",
      "paymentDetails",
      "driverlocalpaymenthistory",
      driverId,
      "payments"
    );

    // Step 2: Get user and driver data
    const userSnap = await getDoc(userRef);
    const driverSnap = await getDoc(driverRef);

    if (!userSnap.exists() || !driverSnap.exists()) {
      console.error("User or Driver not found");
      return;
    }

    const userData = userSnap.data();
    const driverData = driverSnap.data();

    const userBalance = Number(userData.balance || 0);
    const driverBalance = Number(driverData.balance || 0);

    if (userBalance < 15) {
      console.error("User does not have enough balance.");
      return false;
    }

    // Step 3: Update both balances
    await updateDoc(userRef, {
      balance: userBalance - 15,
    });

    await updateDoc(driverRef, {
      balance: driverBalance + 15,
    });
    const docRef = await addDoc(driverPaymentsRef, {
      balance: 15,
      timestamp: new Date(),
      userId: userId,
      type: "Bus fare",
      location: {
        lat: lat,
        lng: lng,
      },
    });

    const setsucc = await updatePayment(userId, lat, lng);
    console.log("Balance transferred successfully.");
    if (setsucc) {
      return true;
    }
  } catch (error) {
    console.error("Error during balance transfer:", error);
  }
};

const savehistory = async (userId: any, driverId: any, lat: any, lng: any) => {
  try {
    const payid = generateRandom8Char();
    const driverRef = doc(
      db,
      "saralyatra",
      "driverDetailsDatabase",
      "drivers",
      driverId
    );
    // Step 2: Get user and driver data
    // const userSnap = await getDoc(userRef);
    const driverSnap = await getDoc(driverRef);

    if (!driverSnap.exists()) {
      console.error("User or Driver not found");
      return false;
    }

    const paymentDocRef = doc(
      db,
      "saralyatra",
      "paymentDetails",
      "userLocalPaymentHistory",
      userId,
      "payments",
      payid
    );

    const driverData = driverSnap.data();
    const activeBusDocRef = doc(db, "saralyatra", "users", "activebus", userId);

    await setDoc(activeBusDocRef, {
      txnRefId: payid,
    });

    // const userBalance = Number(userData.balance || 0);
    // const driverBalance = Number(driverData.busNumberr || 0);

    // Step 3: Update both balances
    await setDoc(paymentDocRef, {
      entry: {
        lat: lat,
        lng: lng,
      },
      busNumber: driverData.busNumber,
      userId,
      entrytime: new Date(),
      txnRefId: payid,
    });

    return true;
    // console.log("Balance transferred successfully.");
  } catch (error) {
    console.error("Error during balance transfer:", error);
  }
};

const updatePayment = async (
  userId: any,
  // paymentId: any,
  lat: any,
  lng: any,
  price = "-15",
  type = "Bus fare"
) => {
  try {
    const activeBusDocRef = doc(db, "saralyatra", "users", "activebus", userId);
    const activeBusSnap = await getDoc(activeBusDocRef);

    if (!activeBusSnap.exists()) {
      console.log("No active bus found for this user.");
      return false;
    }

    const activeTxnRefId = activeBusSnap.data().txnRefId;
    const matched = await compareTxnRefIds(userId, activeTxnRefId);
    if (matched) {
      const paymentDocRef = doc(
        db,
        "saralyatra",
        "paymentDetails",
        "userLocalPaymentHistory",
        userId,
        "payments",
        activeTxnRefId
      );

      await setDoc(
        paymentDocRef,
        {
          exit: {
            lat: lat,
            lng: lng,
            date: new Date(),
          },
          price,
          type,
        },
        { merge: true } // merge to keep other fields intact
      );
    }
    console.log("Payment updated successfully!");
    return true;
  } catch (error) {
    console.error("Error updating payment:", error);
  }
};

function generateRandom8Char() {
  const chars =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let result = "";
  for (let i = 0; i < 8; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

const setActiveBusTxn = async (userId: any, txnid: any) => {
  try {
    const activeBusDocRef = doc(db, "saralyatra", "users", "activebus", userId);

    await setDoc(activeBusDocRef, {
      txnid,
    });

    console.log("Active bus txnid set successfully!");
  } catch (error) {
    console.error("Error setting active bus txnid:", error);
  }
};

const compareTxnRefIds = async (userId: any, payid: any) => {
  try {
    // Get active bus txnRefId
    const activeBusDocRef = doc(db, "saralyatra", "users", "activebus", userId);
    const activeBusSnap = await getDoc(activeBusDocRef);

    if (!activeBusSnap.exists()) {
      console.log("No active bus found for this user.");
      return false;
    }

    const activeTxnRefId = activeBusSnap.data().txnRefId;

    // Get the payment document
    const paymentDocRef = doc(
      db,
      "saralyatra",
      "paymentDetails",
      "userLocalPaymentHistory",
      userId,
      "payments",
      payid
    );
    const paymentSnap = await getDoc(paymentDocRef);

    if (!paymentSnap.exists()) {
      console.log("No payment found for this ID.");
      return false;
    }

    const paymentTxnRefId = paymentSnap.data().txnRefId;

    // Compare both txnRefIds
    if (activeTxnRefId === paymentTxnRefId) {
      console.log(" txnRefId matched!");
      return activeTxnRefId;
    } else {
      console.log(" txnRefId does NOT match.");
      return null;
    }
  } catch (error) {
    console.error("Error comparing txnRefId:", error);
    return false;
  }
};

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
