import useSWR, { mutate } from "swr";
import axios from "axios";

const fetcher = (url) => axios.get(url).then((res) => res.data);

const BookingTable = () => {
  const { data, error } = useSWR("/api/bookings", fetcher);

  if (error) return <div>Failed to load</div>;
  if (!data) return <div>Loading...</div>;

  // const packages = data.packages || [];
  // const reservations = data.reservations || [];
  const completed = data.completed || [];

  const bookings = [
    ...(data.packages || []),
    ...(data.reservations || []),
    ...(data.bus || []),
  ];

  const updateBooking = async (booking) => {
    await axios.post("/api/bookings", booking);
    mutate("/api/bookings"); // Refresh the data
    alert("Booking updated successfully!");
  };
  const currenttime = new Date().getTime();

  return (
    <div className="bg-white shadow-sm">
      <div className="px-6 py-4 mt-5 border-b border-gray-200">
        <h3 className="text-lg font-semibold text-gray-900">Bookings</h3>
      </div>
      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Booking ID
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Customer
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Route
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Date
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Status
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {bookings.map((booking) => (
              <tr
                key={`${booking.id}+${currenttime}`}
                className="hover:bg-gray-50"
              >
                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                  {booking.id}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {booking.userName ?? booking.name ?? "N/A"}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {booking.destination ?? booking.location ?? "-"}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {booking.bookingDate?.seconds
                    ? new Date(
                        booking.bookingDate.seconds * 1000
                      ).toLocaleString()
                    : booking.bookingDate ?? booking.date ?? "-"}
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <span
                    className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                      booking.status === "confirmed"
                        ? "bg-green-100 text-green-800"
                        : booking.status === "pending"
                        ? "bg-yellow-100 text-yellow-800"
                        : "bg-red-100 text-red-800"
                    }`}
                  >
                    {booking.status || "pending"}
                  </span>
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <button
                    onClick={() =>
                      updateBooking({ ...booking, status: "confirmed" })
                    }
                    className="text-white hover:text-blue-900 bg-blue-500 px-2 py-1 rounded-md"
                  >
                    Confirm
                  </button>
                  <button
                    onClick={() =>
                      updateBooking({ ...booking, status: "cancelled" })
                    }
                    className="ml-2 text-red-600 hover:text-red-900"
                  >
                    Cancel
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Optionally show reservations too */}
      {completed.length > 0 && (
        <div className="mt-6 px-6">
          <h4 className="text-lg font-semibold mb-2">Reservations</h4>
          <ul className="list-disc list-inside text-sm text-gray-700">
            {completed.map((r) => (
              <li className="mb-2 text-red-300" key={r.id + r.completionDate}>
                {r.name} completed on{" "}
                {r.completionDate?.seconds
                  ? new Date(r.completionDate.seconds * 1000).toLocaleString()
                  : r.completionDate || "-"}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export default BookingTable;
