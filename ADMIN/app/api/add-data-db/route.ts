// import { NextResponse } from "next/server";
// import { db } from "@/components/db/firebase";
// import { collection, addDoc } from "firebase/firestore";

// function getCurrentUTCDateFormatted(): string {
//   const today = new Date();
//   const year = today.getUTCFullYear();
//   const month = (today.getUTCMonth() + 1).toString().padStart(2, "0");
//   const day = today.getUTCDate().toString().padStart(2, "0");
//   return `${year}-${month}-${day}`;
// }

// console.log(getCurrentUTCDateFormatted());

// export async function GET() {
//   try {
//     const driverId = "xy4hVhcOpWbaJE86svd7dWWwnNX2";
//     const driverId1 = "AofneqG15bWYDtNd7ECUAatdYyJ3";

//     // const dateId = new Date().toISOString().split("T")[0];
//     const dateId = getCurrentUTCDateFormatted();

//     const driverPaymentsRef = collection(
//       db,
//       "saralyatra",
//       "paymentDetails",
//       "driverlocalpaymenthistory",
//       driverId,
//       "payments",
//       "2025-07-28",
//       "payments"
//     );

//     const paymentData = {
//       userid: "9532372",
//       price: 15,
//       type: "bus fare",
//       location: {
//         lat: 27.6715564,
//         lng: 85.3389387,
//       },
//       datetime: new Date(),
//     };

//     try {
//       // await setDoc(dateDocRef, { createdAt: new Date() }, { merge: true });
//       const docRef = await addDoc(driverPaymentsRef, paymentData);
//       console.log("Payment added with ID:", docRef.id);
//       return NextResponse.json({
//         message: "Payment added successfully",
//         status: true,
//       });
//     } catch (err) {
//       console.error("Error adding payment:", err);
//     }
//   } catch (error) {
//     console.error("Error fetching data:", error);
//     return NextResponse.json({ error: "Error fetching data" }, { status: 500 });
//   }
// }

import { NextResponse } from "next/server";
import { db } from "@/components/db/firebase";
import { collection, addDoc, doc, setDoc } from "firebase/firestore";

export async function GET() {
  try {
    const driverId = "xy4hVhcOpWbaJE86svd7dWWwnNX2";
    const dateId = new Date().toISOString().split("T")[0];

    const dateDocRef = doc(
      db,
      "saralyatra",
      "paymentDetails",
      "driverlocalpaymenthistory",
      driverId,
      "payments",
      dateId
    );

    // Create date document explicitly
    await setDoc(dateDocRef, { createdAt: new Date() }, { merge: true });

    const paymentsSubColRef = collection(dateDocRef, "payments");

    const paymentData = {
      userid: "9532372",
      price: 15,
      type: "bus fare",
      location: {
        lat: 27.6715564,
        lng: 85.3389387,
      },
      datetime: new Date(),
    };

    const docRef = await addDoc(paymentsSubColRef, paymentData);
    console.log("Payment added with ID:", docRef.id);

    return NextResponse.json({
      message: "Payment added successfully",
      status: true,
    });
  } catch (error) {
    console.error("Error adding payment:", error);
    return NextResponse.json(
      { error: "Error adding payment" },
      { status: 500 }
    );
  }
}
