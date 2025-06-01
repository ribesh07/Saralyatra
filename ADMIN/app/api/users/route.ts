import { NextRequest, NextResponse } from "next/server";

export async function POST(req: NextRequest) {
  const body = await req.json();

  console.log("🚀 New customer received:", body);

  return NextResponse.json({ success: true, message: "Customer added" });
}
export async function GET() {
  // Simulate fetching users from a database
  const customers = [
    {
      id: "C001",
      name: "John Doe",
      email: "john.doe@email.com",
      phone: "+1 (555) 123-4567",
      location: "New York, NY",
      joinDate: "2024-01-15",
      totalBookings: 12,
      totalSpent: 2400,
      status: "active",
      lastBooking: "2024-05-20",
      avatar: "JD",
    },
    {
      id: "C002",
      name: "Jane Smith",
      email: "jane.smith@email.com",
      phone: "+1 (555) 987-6543",
      location: "Los Angeles, CA",
      joinDate: "2024-02-03",
      totalBookings: 8,
      totalSpent: 1600,
      status: "active",
      lastBooking: "2024-05-18",
      avatar: "JS",
    },
    {
      id: "C003",
      name: "Mike Johnson",
      email: "mike.johnson@email.com",
      phone: "+1 (555) 456-7890",
      location: "Miami, FL",
      joinDate: "2024-03-10",
      totalBookings: 15,
      totalSpent: 3000,
      status: "active",
      lastBooking: "2024-05-22",
      avatar: "MJ",
    },
    {
      id: "C004",
      name: "Sarah Wilson",
      email: "sarah.wilson@email.com",
      phone: "+1 (555) 321-0987",
      location: "Chicago, IL",
      joinDate: "2024-01-28",
      totalBookings: 3,
      totalSpent: 450,
      status: "inactive",
      lastBooking: "2024-04-10",
      avatar: "SW",
    },
    {
      id: "C005",
      name: "David Brown",
      email: "david.brown@email.com",
      phone: "+1 (555) 654-3210",
      location: "Seattle, WA",
      joinDate: "2024-04-05",
      totalBookings: 6,
      totalSpent: 1200,
      status: "active",
      lastBooking: "2024-05-19",
      avatar: "DB",
    },
  ];

  return NextResponse.json(customers);
}
