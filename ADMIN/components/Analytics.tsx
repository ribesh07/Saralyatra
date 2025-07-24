"use client";
import React, { useState } from "react";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from "recharts";
import {
  Bus,
  Users,
  DollarSign,
  Calendar,
} from "lucide-react";

const Analytics = () => {
  const [activeTab, setActiveTab] = useState("overview");

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
          {/* Tabs */}
          <div className="mb-6">
            <div className="border-b border-gray-200">
              <nav className="-mb-px flex space-x-8">
                {["overview", "bookings", "revenue", "routes"].map((tab) => (
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

          {activeTab === "overview" && (
            <>
              {/* Stats Cards */}
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <StatCard
                  title="Total Bookings"
                  value="2,847"
                  change={12}
                  icon={Calendar}
                  color="blue"
                />
                <StatCard
                  title="Active Buses"
                  value="124"
                  change={2}
                  icon={Bus}
                  color="green"
                />
                <StatCard
                  title="Revenue"
                  value="$89,420"
                  change={18}
                  icon={DollarSign}
                  color="purple"
                />
                <StatCard
                  title="Customers"
                  value="1,342"
                  change={-2}
                  icon={Users}
                  color="orange"
                />
              </div>

              {/* Charts Row */}
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                {/* Monthly Trends */}
                <div className="bg-white rounded-lg border border-gray-200 p-6">
                  <h3 className="text-lg font-semibold text-gray-800 mb-4">
                    Monthly Booking Trends
                  </h3>
                  <ResponsiveContainer width="100%" height={300}>
                    <LineChart data={monthlyBookings}>
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="month" />
                      <YAxis />
                      <Tooltip />
                      <Line
                        type="monotone"
                        dataKey="bookings"
                        stroke="#3b82f6"
                        strokeWidth={3}
                      />
                    </LineChart>
                  </ResponsiveContainer>
                </div>

                {/* Booking Status */}
                <div className="bg-white rounded-lg border border-gray-200 p-6">
                  <h3 className="text-lg font-semibold text-gray-800 mb-4">
                    Booking Status Distribution
                  </h3>
                  <ResponsiveContainer width="100%" height={300}>
                    <PieChart>
                      <Pie
                        data={bookingStatus}
                        cx="50%"
                        cy="50%"
                        outerRadius={100}
                        fill="#8884d8"
                        dataKey="value"
                        label={({ name, value }) => `${name}: ${value}%`}
                      >
                        {bookingStatus.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={entry.color} />
                        ))}
                      </Pie>
                      <Tooltip />
                    </PieChart>
                  </ResponsiveContainer>
                </div>
              </div>

              {/* Daily Bookings and Top Routes */}
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                {/* Daily Bookings */}
                <div className="bg-white rounded-lg border border-gray-200 p-6">
                  <h3 className="text-lg font-semibold text-gray-800 mb-4">
                    Daily Bookings (This Week)
                  </h3>
                  <ResponsiveContainer width="100%" height={250}>
                    <BarChart data={dailyBookings}>
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="day" />
                      <YAxis />
                      <Tooltip />
                      <Bar dataKey="bookings" fill="#10b981" />
                    </BarChart>
                  </ResponsiveContainer>
                </div>

                {/* Top Routes */}
                <div className="bg-white rounded-lg border border-gray-200 p-6">
                  <h3 className="text-lg font-semibold text-gray-800 mb-4">
                    Top Performing Routes
                  </h3>
                  <div className="space-y-4">
                    {routePerformance.map((route, index) => (
                      <div
                        key={index}
                        className="flex items-center justify-between"
                      >
                        <div>
                          <p className="font-medium text-gray-800">
                            {route.route}
                          </p>
                          <p className="text-sm text-gray-600">
                            {route.bookings} bookings
                          </p>
                        </div>
                        <div className="text-right">
                          <p className="font-semibold text-gray-800">
                            ${route.revenue.toLocaleString()}
                          </p>
                          <p className="text-sm text-gray-600">revenue</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </>
          )}

          {activeTab === "bookings" && (
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <div className="bg-white rounded-lg border border-gray-200 p-6">
                <h3 className="text-lg font-semibold text-gray-800 mb-4">
                  Booking Trends
                </h3>
                <ResponsiveContainer width="100%" height={400}>
                  <LineChart data={monthlyBookings}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="month" />
                    <YAxis />
                    <Tooltip />
                    <Line
                      type="monotone"
                      dataKey="bookings"
                      stroke="#3b82f6"
                      strokeWidth={3}
                    />
                  </LineChart>
                </ResponsiveContainer>
              </div>

              <div className="bg-white rounded-lg border border-gray-200 p-6">
                <h3 className="text-lg font-semibold text-gray-800 mb-4">
                  Weekly Distribution
                </h3>
                <ResponsiveContainer width="100%" height={400}>
                  <BarChart data={dailyBookings}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="day" />
                    <YAxis />
                    <Tooltip />
                    <Bar dataKey="bookings" fill="#10b981" />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>
          )}

          {activeTab === "revenue" && (
            <div className="space-y-6">
              <div className="bg-white rounded-lg border border-gray-200 p-6">
                <h3 className="text-lg font-semibold text-gray-800 mb-4">
                  Revenue Over Time
                </h3>
                <ResponsiveContainer width="100%" height={400}>
                  <LineChart data={monthlyBookings}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="month" />
                    <YAxis />
                    <Tooltip
                      formatter={(value) => [
                        `$${value.toLocaleString()}`,
                        "Revenue",
                      ]}
                    />
                    <Line
                      type="monotone"
                      dataKey="revenue"
                      stroke="#8b5cf6"
                      strokeWidth={3}
                    />
                  </LineChart>
                </ResponsiveContainer>
              </div>
            </div>
          )}

          {activeTab === "routes" && (
            <div className="bg-white rounded-lg border border-gray-200 p-6">
              <h3 className="text-lg font-semibold text-gray-800 mb-4">
                Route Performance Analysis
              </h3>
              <ResponsiveContainer width="100%" height={400}>
                <BarChart data={routePerformance} layout="horizontal">
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis type="number" />
                  <YAxis dataKey="route" type="category" width={120} />
                  <Tooltip />
                  <Bar dataKey="bookings" fill="#3b82f6" />
                </BarChart>
              </ResponsiveContainer>
            </div>
          )}
        </main>
    
  );
};

export default Analytics;