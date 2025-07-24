import BookingTable from "./BookingTable";

export default function Bookings() {
  return (
    <div className="bg-white shadow-sm  p-8 text-center">
      {/* <h2 className="text-2xl font-bold text-gray-900 mb-4">Settings</h2> */}
       <BookingTable />
    </div>
  );
}