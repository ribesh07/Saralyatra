import { NextResponse } from "next/server";
import { db } from "@/components/db/firebase";
import { collection, addDoc } from "firebase/firestore";

export async function GET() {
  try {
    const driverId = "4dD3WLyocCaz9sCNcVYJddjFEpI3";
    const driverId1 = "AofneqG15bWYDtNd7ECUAatdYyJ3";

    const driverPaymentsRef = collection(
      db,
      "saralyatra",
      "paymentDetails",
      "driverlocalpaymenthistory",
      driverId,
      "payments"
    );

    const paymentData = {
      userid: "73bf145",
      price: 15,
      type: "bus fare",
      location: {
        lat: 27.6715564,
        lng: 85.3389387,
      },
      datetime: new Date(),
    };

    try {
      const docRef = await addDoc(driverPaymentsRef, paymentData);
      console.log("Payment added with ID:", docRef.id);
      return NextResponse.json({
        message: "Payment added successfully",
        status: true,
      });
    } catch (err) {
      console.error("Error adding payment:", err);
    }
  } catch (error) {
    console.error("Error fetching data:", error);
    return NextResponse.json({ error: "Error fetching data" }, { status: 500 });
  }
}
