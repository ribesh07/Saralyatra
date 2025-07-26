// For TypeScript
import { NextResponse } from "next/server";

export async function GET() {
  try {
    const res = await fetch("https://saralyatra-socket.onrender.com/drivers", {
      method: "GET",
      headers: { "Content-Type": "application/json" },
    });

    if (!res.ok) {
      throw new Error("Failed to fetch driver data");
    }

    const data = await res.json();
    console.log(data);
    return NextResponse.json(data);
  } catch (err) {
    console.error(err);
    return NextResponse.json(
      { error: "Unable to fetch drivers" },
      { status: 500 }
    );
  }
}
