import { db } from "@/components/db/firebase";
import { doc, setDoc } from "firebase/firestore";

export async function POST(req: any) {
  try {
    const body = await req.json();
    const { uniqueID, seats } = body;

    if (!uniqueID || !seats || typeof seats !== "object") {
      return new Response(
        JSON.stringify({ error: "uniqueID and seats are required." }),
        { status: 400 }
      );
    }

    // Path: saralyatra/busTicketDetails/buses/{uniqueID}
    const seatRef = doc(
      db,
      "saralyatra",
      "busTicketDetails",
      "buses",
      uniqueID
    );
    await setDoc(seatRef, seats, { merge: true }); // merge true to update partially

    return new Response(
      JSON.stringify({
        message: "Seats updated successfully.",
        seats,
        uniqueID,
      }),
      { status: 200 }
    );
  } catch (error) {
    console.error("Add Seats API Error:", error);
    const errorMessage =
      error instanceof Error ? error.message : "An unknown error occurred.";
    return new Response(JSON.stringify({ error: errorMessage }), {
      status: 500,
    });
  }
}

const samplebody: any = {
  uniqueID: "Djk33zDsvhpmAJngWiHq",
  seats: {
    bookC1: false,
    bookL1: false,
    bookL2: false,
    bookL3: false,
    bookL4: false,
    bookL5: false,
    bookL6: false,
    bookL7: false,
    bookL8: false,
    bookL9: false,
    bookL10: false,
    bookL11: false,
    bookL12: false,
    bookL13: false,
    bookL14: false,
    bookR1: false,
    bookR2: false,
    bookR3: false,
    bookR4: false,
    bookR5: false,
    bookR6: false,
    bookR7: false,
    bookR8: false,
    bookR9: false,
    bookR10: false,
    bookR11: false,
    bookR12: false,
    bookR13: false,
    bookR14: false,
  },
};
