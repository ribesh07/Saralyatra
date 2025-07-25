import { NextRequest, NextResponse } from "next/server";
import { db } from "../../../components/db/firebase.js";
import {
  doc,
  collection,
  getDocs,
  getDoc,
  query,
  where,
} from "firebase/firestore";

// Type definitions
interface SeatData {
  bookC1?: boolean;
  bookL1?: boolean;
  bookL2?: boolean;
  bookL3?: boolean;
  bookL4?: boolean;
  bookL5?: boolean;
  bookL6?: boolean;
  bookL7?: boolean;
  bookL8?: boolean;
  bookL9?: boolean;
  bookL10?: boolean;
  bookL11?: boolean;
  bookL12?: boolean;
  bookL13?: boolean;
  bookL14?: boolean;
  bookR1?: boolean;
  bookR2?: boolean;
  bookR3?: boolean;
  bookR4?: boolean;
  bookR5?: boolean;
  bookR6?: boolean;
  bookR7?: boolean;
  bookR8?: boolean;
  bookR9?: boolean;
  bookR10?: boolean;
  bookR11?: boolean;
  bookR12?: boolean;
  bookR13?: boolean;
  bookR14?: boolean;
  [key: string]: any;
}

interface BusData {
  route?: string;
  arrTimeHr?: string;
  arrTimeMin?: string;
  availableSeat?: number;
  busName?: string;
  busNumber?: string;
  busType?: string;
  createdAt?: string;
  depTimeHr?: string;
  depTimeMin?: string;
  location?: string;
  price?: string;
  reservedSeat?: number;
  shift?: string;
  uid?: string;
  seatData?: SeatData | null;
  [key: string]: any;
}

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const route = searchParams.get("route"); // e.g., "ktm-pkr", "pkr-ktm"
    const busId = searchParams.get("busId"); // specific bus ID if needed
    const includeSeatData = true;
    console.log(route, busId, includeSeatData);
    // If specific bus ID is requested
    if (busId) {
      return await getSingleBusDetails(busId, includeSeatData);
    }

    // If route is specified, get buses for that route
    if (route) {
      console.log("Fetching buses for route:", route);
      return await getBusesByRoute(route, includeSeatData);
    }

    // Get all buses from all routes
    return await getAllBuses(includeSeatData);
  } catch (error) {
    console.error("Error fetching bus details:", error);
    return NextResponse.json(
      { error: "Failed to fetch bus details" },
      { status: 500 }
    );
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const { routes, includeSeatData = true } = body;

    if (!routes || !Array.isArray(routes)) {
      return NextResponse.json(
        { error: "Routes array is required" },
        { status: 400 }
      );
    }

    const allBuses: BusData[] = [];

    for (const route of routes) {
      const buses = await getBusesByRouteInternal(route, includeSeatData);
      allBuses.push(...buses);
    }

    return NextResponse.json({
      success: true,
      data: allBuses,
      total: allBuses.length,
    });
  } catch (error) {
    console.error("Error fetching multiple route buses:", error);
    return NextResponse.json(
      { error: "Failed to fetch bus details" },
      { status: 500 }
    );
  }
}

// Helper function to get a single bus with details
async function getSingleBusDetails(busId: string, includeSeatData: boolean) {
  try {
    // First, try to find the bus in different route collections
    const routeCollections = [
      "JKR-POK",
      "POK-JKR",
      "KTM-JKR",
      "JKR-KTM",
      "KTM-POK",
      "POK-KTM",
    ];
    let busData: BusData | null = null;
    let foundRoute: string | null = null;

    for (const route of routeCollections) {
      try {
        const busDocRef = doc(
          db,
          "saralyatra",
          "busTicketDetails",
          route,
          busId
        );
        const busDoc = await getDoc(busDocRef);

        if (busDoc.exists()) {
          busData = { id: busDoc.id, ...busDoc.data() };
          foundRoute = route;
          break;
        }
      } catch (error) {
        // Continue to next route if this one doesn't exist
        continue;
      }
    }

    if (!busData) {
      return NextResponse.json({ error: "Bus not found" }, { status: 404 });
    }

    // Add seat data if requested
    if (includeSeatData) {
      busData.seatData = await getSeatData(busId);
    }

    busData.route = foundRoute ?? undefined;

    return NextResponse.json({
      success: true,
      data: busData,
    });
  } catch (error) {
    console.error("Error fetching single bus:", error);
    return NextResponse.json(
      { error: "Failed to fetch bus details" },
      { status: 500 }
    );
  }
}

// Helper function to get buses by specific route
async function getBusesByRoute(route: string, includeSeatData: boolean) {
  try {
    const buses = await getBusesByRouteInternal(route, includeSeatData);
    console.log("Fetched buses for route:", route, buses);
    return NextResponse.json({
      success: true,
      data: buses,
      route: route,
      total: buses.length,
    });
  } catch (error) {
    console.error(`Error fetching buses for route ${route}:`, error);
    return NextResponse.json(
      { error: `Failed to fetch buses for route ${route}` },
      { status: 500 }
    );
  }
}

// Internal helper function to get buses by route
async function getBusesByRouteInternal(
  route: string,
  includeSeatData: boolean = true
): Promise<BusData[]> {
  const buses: BusData[] = [];

  try {
    const routeCollectionRef = collection(
      db,
      "saralyatra",
      "busTicketDetails",
      route
    );
    const querySnapshot = await getDocs(routeCollectionRef);
    // console.log(querySnapshot);

    for (const docSnap of querySnapshot.docs) {
      const busData: BusData = {
        id: docSnap.id,
        route: route,
        ...docSnap.data(),
      };
      // console.log(busData);
      // Add seat data if requested
      if (includeSeatData) {
        console.log("Fetching seat data for bus:", docSnap.id);
        busData.seatData = await getSeatData(docSnap.id);
      }

      buses.push(busData);
    }
  } catch (error) {
    console.error(`Error fetching buses for route ${route}:`, error);
    // Return empty array if route doesn't exist
  }

  return buses;
}

// Helper function to get all buses from all routes
async function getAllBuses(includeSeatData: boolean) {
  try {
    const routeCollections = [
      "JKR-POK",
      "POK-JKR",
      "KTM-JKR",
      "JKR-KTM",
      "KTM-POK",
      "POK-KTM",
    ];
    const allBuses: BusData[] = [];

    for (const route of routeCollections) {
      const buses = await getBusesByRouteInternal(route, includeSeatData);
      allBuses.push(...buses);
    }

    return NextResponse.json({
      success: true,
      data: allBuses,
      total: allBuses.length,
      routes: routeCollections,
    });
  } catch (error) {
    console.error("Error fetching all buses:", error);
    return NextResponse.json(
      { error: "Failed to fetch all buses" },
      { status: 500 }
    );
  }
}

// Helper function to get seat data for a specific bus
async function getSeatData(busId: string): Promise<SeatData | null> {
  try {
    console.log("Fetching seat data for bus:", busId);
    const seatDocRef = doc(
      db,
      "saralyatra",
      "busTicketDetails",
      "buses",
      busId
    );
    const seatDoc = await getDoc(seatDocRef);
    console.log("Seat data fetched:");
    if (seatDoc.exists()) {
      console.log("Seat data exists:", seatDoc.data());
      return seatDoc.data();
    }

    return null;
  } catch (error) {
    console.error(`Error fetching seat data for bus ${busId}:`, error);
    return null;
  }
}

// Sample request bodies and responses for documentation
const sampleGetRequests = {
  // GET /api/get-bus-details - Get all buses
  getAllBuses: "/api/get-bus-details",

  // GET /api/get-bus-details?route=ktm-pkr - Get buses for specific route
  getBusesByRoute: "/api/get-bus-details?route=ktm-pkr",

  // GET /api/get-bus-details?busId=XnC1k2PLtPVCFUkx3pKm - Get specific bus
  getSingleBus: "/api/get-bus-details?busId=XnC1k2PLtPVCFUkx3pKm",

  // GET /api/get-bus-details?route=ktm-pkr&includeSeats=true - Get buses with seat data
  getBusesWithSeats: "/api/get-bus-details?route=ktm-pkr&includeSeats=true",
};

const samplePostBody = {
  routes: ["ktm-pkr", "pkr-ktm", "ktm-jkr"],
  includeSeatData: true,
};

const sampleResponse = {
  success: true,
  data: [
    {
      id: "XnC1k2PLtPVCFUkx3pKm",
      route: "ktm-pkr",
      arrTimeHr: "15",
      arrTimeMin: "8",
      availableSeat: 29,
      busName: "Yatra",
      busNumber: "genda 98 p 8888",
      busType: "DELUXE",
      createdAt: "2023-06-27T08:15:00.000Z",
      depTimeHr: "8",
      depTimeMin: "15",
      location: "KTM-PKR",
      price: "6969",
      reservedSeat: 0,
      shift: "Morning",
      uid: "XnC1k2PLtPVCFUkx3pKm",
      seatData: {
        bookC1: false,
        bookL1: false,
        bookL2: false,
        // ... other seat data
        bookR14: false,
      },
    },
  ],
  total: 1,
};
