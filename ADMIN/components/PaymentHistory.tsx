
// export default function BlogsHistory() {
//   return (
//     <div className="p-6 bg-white rounded-lg shadow-sm">
//       <h2 className="text-2xl font-semibold text-gray-800 mb-4">Blogs and News</h2>
      
//       {/* Payment history content goes here */}
//     </div>
//   );
// }
"use client";
import React, { useState } from "react";


const PaymentHistory = () => {
  const [activeTab, setActiveTab] = useState("night");

  // Sample data for charts
  const monthlyBookings = [
    { month: "Jan", bookings: 1850, revenue: 74000 },
    { month: "Feb", bookings: 2100, revenue: 84000 },
    { month: "Mar", bookings: 2400, revenue: 96000 },
    { month: "Apr", bookings: 2200, revenue: 88000 },
    { month: "May", bookings: 2847, revenue: 89420 },
  ];

  const routePerformance = [
    { route: "NYC → Boston", bookings: 420, revenue: 16800 },
    { route: "LA → SF", bookings: 380, revenue: 15200 },
    { route: "Miami → Orlando", bookings: 350, revenue: 14000 },
    { route: "Chicago → Detroit", bookings: 320, revenue: 12800 },
    { route: "Seattle → Portland", bookings: 280, revenue: 11200 },
  ];

  const bookingStatus = [
    { name: "Confirmed", value: 68, color: "#10b981" },
    { name: "Pending", value: 22, color: "#f59e0b" },
    { name: "Cancelled", value: 10, color: "#ef4444" },
  ];

  const dailyBookings = [
    { day: "Mon", bookings: 45 },
    { day: "Tue", bookings: 52 },
    { day: "Wed", bookings: 38 },
    { day: "Thu", bookings: 61 },
    { day: "Fri", bookings: 73 },
    { day: "Sat", bookings: 89 },
    { day: "Sun", bookings: 67 },
  ];

  const tabbs = ["night", "local"];
  
  
  
  type StatCardProps = {
    title: string;
    value: string | number;
    change: number;
    icon: React.ComponentType<React.SVGProps<SVGSVGElement>>;
    color?: string;
  };

  const StatCard: React.FC<StatCardProps> = ({ title, value, change, icon: Icon, color = "blue" }) => (
    <div className="bg-white rounded-lg border border-gray-200 p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-2xl font-bold text-gray-800 mt-1">{value}</p>
        </div>
        <div className={`p-3 rounded-lg bg-${color}-50`}>
          <Icon className={`h-6 w-6 text-${color}-600`} />
        </div>
      </div>
      <div className="mt-4 flex items-center">
        <span
          className={`text-sm ${
            change >= 0 ? "text-green-600" : "text-red-600"
          }`}
        >
          {change >= 0 ? "+" : ""}
          {change}%
        </span>
        <span className="text-sm text-gray-500 ml-2">vs last month</span>
      </div>
    </div>
  );

  return (

        <main className="flex-1 overflow-y-auto p-6">
          
   <div className="p-6 bg-white rounded-lg shadow-sm">
      <h2 className="text-2xl font-semibold text-gray-800 mb-4">Payment History</h2>
      <p className="text-gray-600">This section will display the payment history of users.</p>
      {/* Payment history content goes here */}
    </div>
          {/* Tabs */}
          <div className="mb-6">
            <div className="border-b border-gray-200">
              <nav className="-mb-px flex space-x-8">
                {tabbs.map((tab) => (
                  <button
                    key={tab}
                    onClick={() => setActiveTab(tab)}
                    className={`py-2 px-1 border-b-2 font-medium text-sm capitalize ${
                      activeTab === tab
                        ? "border-blue-500 text-blue-600"
                        : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
                    }`}
                  >
                    {tab}
                  </button>
                ))}
              </nav>
            </div>
          </div>

          {activeTab === "night" && (
            <>
                 <div className="p-6 bg-white rounded-lg shadow-sm">
       <h2 className="text-2xl font-semibold text-gray-800 mb-4">Night Bus</h2>
      
       {/* Payment history content goes here */}
    </div>
            </>
          )}

          {activeTab === "local" && (
               <>
                 <div className="p-6 bg-white rounded-lg shadow-sm">
       <h2 className="text-2xl font-semibold text-gray-800 mb-4">Local Bus</h2>
      
       {/* Payment history content goes here */}
    </div>
            </>
          )}

          
        </main>
    
  );
};

export default PaymentHistory;