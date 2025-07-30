"use client"
import React from 'react';
import useSWR, { mutate } from "swr";
import axios from "axios";

const fetcher = (url : any) => axios.get(url).then((res) => res.data);
const Dashboard = () => {

  const stats = [
    { name: 'SaralYatra' , value : 'Journey Begins Here ....' },
  ];

  const recentBookings = [
    { id: 'BK001', customer: 'John Doe', route: 'NYC → Boston', date: '2024-05-25', status: 'confirmed' },
    { id: 'BK002', customer: 'Jane Smith', route: 'LA → SF', date: '2024-05-25', status: 'pending' },
    { id: 'BK003', customer: 'Mike Johnson', route: 'Miami → Orlando', date: '2024-05-24', status: 'confirmed' },
    { id: 'BK004', customer: 'Sarah Wilson', route: 'Chicago → Detroit', date: '2024-05-24', status: 'cancelled' },
  ];

    const { data, error } = useSWR("/api/bookings", fetcher);
  
    if (error) return <div>Failed to load</div>;
    if (!data) return <div>Loading...</div>;
  
      const updateBooking = async (booking :any) => {
    await axios.post("/api/bookings", booking);
    mutate("/api/bookings"); // Refresh the data
    alert("Booking updated successfully!");
  };
    // const packages = data.packages || [];
    // const reservations = data.reservations || [];
    const completed = data.completed || [];
  
    const bookings = [...(data.packages || []), ...(data.reservations || []) , ...(data.completed || [])];

  return (
    <>
        <main className="flex-1 p-6">
          <div className="mb-6">
            <h1 className="text-2xl font-bold text-gray-900">
              Dashboard
            </h1>
            <p className="text-gray-600">
              Manage your bus reservation system from this admin panel.
            </p>
          </div>
          <div className="space-y-6">
            {/* Stats Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 justify-center">
              {stats.map((stat) => (
                <div key={stat.name+Math.random()} className="bg-white self-center w-100 px-8 rounded-lg shadow-sm border p-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-medium text-gray-600">{stat.name}</p>
                      <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Recent Bookings */}
            <div className="bg-white rounded-lg shadow-sm border">
              <div className="px-6 py-4 border-b border-gray-200">
                <h3 className="text-lg font-semibold text-gray-900">Recent Bookings</h3>
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
                        Package
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Date
                      </th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Status
                      </th>
                    </tr>
                  </thead>
                  <tbody className="bg-white divide-y divide-gray-200">
                    {bookings.map((booking) => (
                      <tr key={`${booking.id}+${Math.random()}`} className="hover:bg-gray-50">
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                          {booking.id}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {booking.email}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {booking.packageName ?? 'N/A'}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                          {booking.date ?? 'N/A'}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                            booking.status === 'confirmed' ? 'bg-green-100 text-green-800' :
                            booking.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                            'bg-red-100 text-red-800'
                          }`}>
                            {booking.status}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        
        </main>
      
    </>
  );
};

export default Dashboard;
