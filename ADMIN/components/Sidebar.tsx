"use client";
import { Activity, BarChart3, Bus, BusFrontIcon, Calendar, LayoutDashboard, MapPin, Settings, TrendingUp, Users, WalletCards } from 'lucide-react';
import { useState } from "react";

//   const Sidebar = () => (
//     <div className="w-64 bg-white border-r border-gray-200 h-screen">
//       <div className="p-6">
//         <div className="flex items-center space-x-2">
//           <Bus className="h-8 w-8 text-blue-600" />
//           <span className="text-xl font-bold text-gray-800">BusAdmin</span>
//         </div>
//       </div>

//       <nav className="mt-8">
//         <div className="px-6 py-2">
//           <div className="flex items-center space-x-3 text-gray-600 hover:text-blue-600 cursor-pointer">
//             <Activity className="h-5 w-5" />
//             <span>Dashboard</span>
//           </div>
//         </div>
//         <div className="px-6 py-2">
//           <div className="flex items-center space-x-3 text-gray-600 hover:text-blue-600 cursor-pointer">
//             <Bus className="h-5 w-5" />
//             <span>Buses</span>
//           </div>
//         </div>
//         <div className="px-6 py-2">
//           <div className="flex items-center space-x-3 text-gray-600 hover:text-blue-600 cursor-pointer">
//             <Calendar className="h-5 w-5" />
//             <span>Bookings</span>
//           </div>
//         </div>
//         <div className="px-6 py-2 bg-blue-50 border-r-4 border-blue-600">
//           <div className="flex items-center space-x-3 text-blue-600 cursor-pointer">
//             <Users className="h-5 w-5" />
//             <span>Customers</span>
//           </div>
//         </div>
//         <div className="px-6 py-2">
//           <div className="flex items-center space-x-3 text-gray-600 hover:text-blue-600 cursor-pointer">
//             <MapPin className="h-5 w-5" />
//             <span>Routes</span>
//           </div>
//         </div>
//         <div className="px-6 py-2">
//           <div className="flex items-center space-x-3 text-gray-600 hover:text-blue-600 cursor-pointer">
//             <TrendingUp className="h-5 w-5" />
//             <span>Analytics</span>
//           </div>
//         </div>
//       </nav>
//     </div>
//   );

{/* Fixed Sidebar */ }
const navigation = [
  { name: 'Dashboard', icon: LayoutDashboard, id: 'dashboard' },
  { name: 'Buses', icon: Bus, id: 'buses' },
  { name: 'Bookings', icon: Calendar, id: 'bookings' },
  { name: 'Users', icon: Users, id: 'users' },
  { name: 'Drivers', icon: BusFrontIcon, id: 'drivers' },
  { name: 'DriverPayment', icon: WalletCards , id: 'driver-payment' },  
  { name: 'Tours & Packages', icon: Settings, id: 'tours&packages' },
  { name: 'Payment History', icon: Settings, id: 'payment-history' },
  { name: 'News & Blogs', icon: MapPin, id: 'blogs&news' },
  // { name: 'Analytics', icon: BarChart3, id: 'analytics' },
  // { name: 'Settings', icon: Settings, id: 'settings' },


];
type SidebarProps = {
  onSelect: (section: string) => void;
};
const Sidebar = ({ onSelect }: SidebarProps) => {
  const [activeTab, setActiveTab] = useState('customers');
  return (<>
    <div className="fixed top-0 left-0 h-screen w-60 bg-white shadow-lg z-50">

      {/* Sidebar Header */}
      <div className="sticky flex items-center justify-center h-16 px-6 border-b border-gray-200">
        <div className="flex items-center space-x-2">
          <Bus className="h-8 w-8 text-blue-600" />
          <span className="text-xl font-bold text-gray-900">BusAdmin</span>
        </div>
      </div>

      {/* Navigation */}
      <nav className="mt-6 px-3">
        <div className="space-y-1">
          {navigation.map((item) => (
            (() => {
              const Icon = item.icon;
              return (
                <button
                  key={item.name}
                  onClick={() => {
                    setActiveTab(item.id);
                    onSelect(item.id);
                  }}
                  className={`w-full flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-colors ${activeTab === item.id
                      ? 'bg-blue-50 text-blue-700 border-r-2 border-blue-700'
                      : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                    }`}
                >
                  <Icon className="mr-3 h-5 w-5" />
                  {item.name}
                </button>
              );
            })()
          ))}

        </div>
      </nav>
    </div>
  </>
  );
}
export default Sidebar;
