import { NextRequest, NextResponse } from "next/server";
import { db } from "../../../components/db/firebase.js";
import { collection, getDocs, doc, setDoc } from "firebase/firestore";

export async function GET() {
  try {
    // Reference to subcollections
    const packageRef = collection(
      db,
      "history",
      "upcomingHistoryDetails",
      "package"
    );
    const reservationsRef = collection(
      db,
      "history",
      "upcomingHistoryDetails",
      "reservation"
    );
    const completedRef = collection(
      db,
      "history",
      "completedHistoryDetails",
      "completedHistory"
    );

    // Fetch documents from both subcollections
    const [packageSnapshot, reservationsSnapshot, completedSnapshot] =
      await Promise.all([
        getDocs(packageRef),
        getDocs(reservationsRef),
        getDocs(completedRef),
      ]);
    console;

    // Extract data from package documents
    const packageData = packageSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    // Extract data from reservations documents
    const reservationsData = reservationsSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    // Extract data from completed documents
    const completedData = completedSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    // Return both sets of data
    return NextResponse.json({
      success: true,
      packages: packageData,
      reservations: reservationsData,
      completed: completedData,
    });
  } catch (error) {
    console.error("Error fetching data:", error);
    return NextResponse.json(
      { error: "Failed to fetch history data" },
      { status: 500 }
    );
  }
}

let bookings: any = []; // Optional if you're persisting everything to Firestore

// export async function POST(req: NextRequest) {
//   try {
//     const updatedBooking = await req.json();

//     // 1. Add completionDate field
//     const completedBooking = {
//       ...updatedBooking,
//       completionDate: new Date().toISOString(),
//     };

//     // 2. Save to Firestore under completedHistory
//     const completedRef = collection(
//       db,
//       "history",
//       "completedHistoryDetails",
//       "completedHistory"
//     );
//     const newDocRef = doc(completedRef, completedBooking.id);
//     await setDoc(newDocRef, completedBooking);

//     // 3. Update local memory if still using that
//     const index = bookings.findIndex((b: any) => b.id === updatedBooking.id);
//     if (index !== -1) {
//       bookings[index] = completedBooking;
//     } else {
//       bookings.push(completedBooking);
//     }

//     return NextResponse.json(bookings, { status: 200 });
//   } catch (error) {
//     console.error("Error completing booking:", error);
//     return NextResponse.json(
//       { message: "Failed to complete booking" },
//       { status: 500 }
//     );
//   }
// }

import { deleteDoc, getDoc, updateDoc } from "firebase/firestore";

export async function POST(req: NextRequest) {
  try {
    const updatedBooking = await req.json();

    // Add completionDate
    const completedBooking = {
      ...updatedBooking,
      completionDate: new Date().toISOString(),
    };

    // Save to completedHistory
    const completedRef = collection(
      db,
      "history",
      "completedHistoryDetails",
      "completedHistory"
    );
    const completedDocRef = doc(completedRef, completedBooking.id);
    await setDoc(completedDocRef, completedBooking);

    // Update only the 'status' field in upcoming/package and reservations
    const packageDocRef = doc(
      db,
      "history",
      "upcomingHistoryDetails",
      "package",
      updatedBooking.id
    );
    const reservationsDocRef = doc(
      db,
      "history",
      "upcomingHistoryDetails",
      "reservation",
      updatedBooking.id
    );

    const packageDocSnap = await getDoc(packageDocRef);
    if (packageDocSnap.exists()) {
      await updateDoc(packageDocRef, { status: updatedBooking.status });
    }

    const reservationDocSnap = await getDoc(reservationsDocRef);
    if (reservationDocSnap.exists()) {
      await updateDoc(reservationsDocRef, { status: updatedBooking.status });
    }

    // Delete both from upcoming/package and upcoming/reservations
    await deleteDoc(packageDocRef);
    await deleteDoc(reservationsDocRef); // Safe even if doc doesn't exist

    return NextResponse.json(
      { message: "Booking completed and removed from upcoming." },
      { status: 200 }
    );
  } catch (error) {
    console.error("Error handling booking update:", error);
    return NextResponse.json(
      { message: "Failed to process booking update" },
      { status: 500 }
    );
  }
}
