import BookingTable from "./BookingTable";
import BusRoutesTable from "./BusRoutesTable";

export default function Buses() {
  return (
    <div className="bg-white rounded-lg shadow-sm border p-8 text-center">
      <div className="mt-2">
         <BusRoutesTable />
      </div>
    </div>
  );
}