// app/api/bookings.js

const bookings = [
  {
    id: "BK001",
    customer: "John Doe",
    route: "NYC → Boston",
    date: "2024-05-25",
    status: "confirmed",
  },
  {
    id: "BK002",
    customer: "Jane Smith",
    route: "LA → SF",
    date: "2024-05-25",
    status: "pending",
  },
  {
    id: "BK003",
    customer: "Mike Johnson",
    route: "Miami → Orlando",
    date: "2024-05-24",
    status: "confirmed",
  },
  {
    id: "BK004",
    customer: "Sarah Wilson",
    route: "Chicago → Detroit",
    date: "2024-05-24",
    status: "cancelled",
  },
];

import { NextRequest, NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json(bookings);
}
export async function POST(req: NextRequest) {
  const updatedBooking = await req.json();
  const index = bookings.findIndex((b) => b.id === updatedBooking.id);
  if (index !== -1) {
    bookings[index] = updatedBooking;
    return NextResponse.json(bookings, { status: 200 });
  } else {
    return NextResponse.json({ message: "Booking not found" }, { status: 404 });
  }
}
