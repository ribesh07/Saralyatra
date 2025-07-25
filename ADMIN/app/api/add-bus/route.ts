// app/api/add-ticket/route.js
import { NextResponse } from "next/server";
// import { db } from "@/lib/firebaseDB";
import { db } from "../../../components/db/firebase.js";
import { doc, collection, addDoc, updateDoc } from "firebase/firestore";

export async function POST(req: any) {
  try {
    const body = await req.json();
    const {
      location,
      busName,
      price,
      shift,
      busNumber,
      busType,
      depTimeMin,
      depTimeHr,
      arrTimeMin,
      arrTimeHr,
      availableSeat,
      reservedSeat,
      date
    } = body;

    if (!location) {
      return NextResponse.json(
        { error: "Location is required" },
        { status: 400 }
      );
    }

    const parentDocRef = doc(db, "saralyatra", "busTicketDetails");
    const ticketCollectionRef = collection(parentDocRef, location);

    const result = await addDoc(ticketCollectionRef, {
      location,
      busName,
      price,
      shift,
      busNumber,
      busType,
      depTimeMin, 
      depTimeHr, 
      arrTimeMin, 
      arrTimeHr, 
      availableSeat,
      reservedSeat,
      date,
      createdAt: new Date().toISOString(),
    });

    // Update the document with its own ID as busUniqueID
    await updateDoc(result, {
      uid: result.id,
    });
    console.log("Ticket added with ID:", result.id);

    return NextResponse.json(
      { message: "Ticket added", id: result.id },
      { status: 201 }
    );
  } catch (error) {
    console.error("Error adding ticket:", error);
    return NextResponse.json(
      { error: "Failed to add ticket" },
      { status: 500 }
    );
  }
}

const samplebody: any = {
  location: "KTM-JKR",
  busName: "Mountain Express",
  price: 1200,
  shift: "Morning",
  busNumber: "BA 2 KHA 1234",
  busType: "Deluxe",
  depTimeMin: "30",
  depTimeHr: "08",
  arrTimeMin: "15",
  arrTimeHr: "13",
  uniqueID: "BX-89345",
};
const data = {
  arrTimeHr: "15",
  arrTimeMin: "8",
  availableSeat: 29,

  busName: "Yatra",
  busNumber: "genda 98 p 8888",
  busType: "DELUXE",

  createdAt: "2023-06-27T08:15:00.000Z",
  depTimeHr: "8",
  depTimeMin: "15",
  location: "KTM-JKR",
  price: "6969",
  reservedSeat: 0,
  shift: "Mor",
  uid: "XnC1k2PLtPVCFUkx3pKm",
};
