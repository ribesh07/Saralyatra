"use client"
import React, { useState } from 'react';
import { 
  LayoutDashboard, 
  Bus, 
  Calendar, 
  Users, 
  MapPin, 
  BarChart3, 
  Settings, 
  Menu,
  Bell,
  Search,
  ChevronDown
} from 'lucide-react';

const Dashboard = () => {
  // const [sidebarOpen, setSidebarOpen] = useState(true);
  const [activeTab, setActiveTab] = useState('dashboard');

  const navigation = [
    { name: 'Dashboard', icon: LayoutDashboard, id: 'dashboard' },
    { name: 'Buses', icon: Bus, id: 'buses' },
    { name: 'Bookings', icon: Calendar, id: 'bookings' },
    { name: 'Customers', icon: Users, id: 'customers' },
    { name: 'Routes', icon: MapPin, id: 'routes' },
    { name: 'Analytics', icon: BarChart3, id: 'analytics' },
    { name: 'Settings', icon: Settings, id: 'settings' },
  ];

  const stats = [
    { name: 'Total Bookings', value: '2,847', change: '+12%', changeType: 'positive' },
    { name: 'Active Buses', value: '124', change: '+2%', changeType: 'positive' },
    { name: 'Revenue', value: '$89,420', change: '+18%', changeType: 'positive' },
    { name: 'Customers', value: '1,342', change: '-2%', changeType: 'negative' },
  ];

  const recentBookings = [
    { id: 'BK001', customer: 'John Doe', route: 'NYC → Boston', date: '2024-05-25', status: 'confirmed' },
    { id: 'BK002', customer: 'Jane Smith', route: 'LA → SF', date: '2024-05-25', status: 'pending' },
    { id: 'BK003', customer: 'Mike Johnson', route: 'Miami → Orlando', date: '2024-05-24', status: 'confirmed' },
    { id: 'BK004', customer: 'Sarah Wilson', route: 'Chicago → Detroit', date: '2024-05-24', status: 'cancelled' },
  ];

  const renderContent = () => {
    switch(activeTab) {
      case 'dashboard':
        return (
          <div className="space-y-6">
            {/* Stats Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              {stats.map((stat) => (
                <div key={stat.name} className="bg-white rounded-lg shadow-sm border p-6">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-medium text-gray-600">{stat.name}</p>
                      <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
                    </div>
                    <div className={`text-sm font-medium ${
                      stat.changeType === 'positive' ? 'text-green-600' : 'text-red-600'
                    }`}>
                      {stat.change}
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
                        Route
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
                    {recentBookings.map((booking) => (
                      <tr key={booking.id} className="hover:bg-gray-50">
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                          {booking.id}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {booking.customer}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {booking.route}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                          {booking.date}
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
        );
      default:
        return (
          <div className="bg-white rounded-lg shadow-sm border p-8 text-center">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              {navigation.find(nav => nav.id === activeTab)?.name}
            </h2>
            <p className="text-gray-600">
              This section is under development. Here you would manage {activeTab}.
            </p>
          </div>
        );
    }
  };

  return (
    <>
    <div className="min-h-screen bg-gray-100 flex">
      {/* Fixed Sidebar */}
      <div className="w-64 bg-white shadow-lg flex-shrink-0">
        
        {/* Sidebar Header */}
        <div className="flex items-center justify-center h-16 px-6 border-b border-gray-200">
          <div className="flex items-center space-x-2">
            <Bus className="h-8 w-8 text-blue-600" />
            <span className="text-xl font-bold text-gray-900">BusAdmin</span>
          </div>
        </div>

        {/* Navigation */}
        <nav className="mt-6 px-3">
          <div className="space-y-1">
            {navigation.map((item) => {
              const Icon = item.icon;
              return (
                <button
                  key={item.name}
                  onClick={() => setActiveTab(item.id)}
                  className={`w-full flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-colors ${
                    activeTab === item.id
                      ? 'bg-blue-50 text-blue-700 border-r-2 border-blue-700'
                      : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                  }`}
                >
                  <Icon className="mr-3 h-5 w-5" />
                  {item.name}
                </button>
              );
            })}
          </div>
        </nav>
      </div>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col">
        {/* Top Navigation */}
        <header className="bg-white shadow-sm border-b border-gray-200">
          <div className="flex items-center justify-between h-16 px-6">
            <div className="flex items-center space-x-4">
              {/* Search Bar */}
              <div className="relative">
                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Search className="h-5 w-5 text-gray-400" />
                </div>
                <input
                  type="text"
                  placeholder="Search..."
                  className="block w-80 pl-10 pr-3 py-2 border border-gray-300 rounded-lg leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                />
              </div>
            </div>

            {/* Right side */}
            <div className="flex items-center space-x-4">
              <button
                className="p-2 text-gray-400 hover:text-gray-600 relative"
                title="Notifications"
                aria-label="Notifications"
              >
                <Bell className="h-6 w-6" />
                <span className="absolute top-0 right-0 block h-2 w-2 rounded-full bg-red-400"></span>
              </button>
              
              <div className="flex items-center space-x-3">
                <div className="text-right">
                  <p className="text-sm font-medium text-gray-900">Admin User</p>
                  <p className="text-xs text-gray-500">admin@busreservation.com</p>
                </div>
                <div className="h-8 w-8 rounded-full bg-blue-600 flex items-center justify-center">
                  <span className="text-white text-sm font-medium">A</span>
                </div>
                <ChevronDown className="h-4 w-4 text-gray-400" />
              </div>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="flex-1 p-6">
          <div className="mb-6">
            <h1 className="text-2xl font-bold text-gray-900">
              {navigation.find(nav => nav.id === activeTab)?.name}
            </h1>
            <p className="text-gray-600">
              Manage your bus reservation system from this admin panel.
            </p>
          </div>
          
          {renderContent()}
        </main>
      </div>
    </div>
    </>
  );
};

export default Dashboard;


//new 


// "use client"
// import React, { useState } from 'react';
// import { 
//   LayoutDashboard, 
//   Bus, 
//   Calendar, 
//   Users, 
//   MapPin, 
//   BarChart3, 
//   Settings, 
//   Bell,
//   Search,
//   ChevronDown
// } from 'lucide-react';

// const Dashboard = () => {
//   const [sidebarOpen, setSidebarOpen] = useState(true);
//   const [activeTab, setActiveTab] = useState('dashboard');

//   // Buses state for CRUD
//   const [buses, setBuses] = useState([
//     { id: 'BUS001', name: 'City Express', capacity: 40 },
//     { id: 'BUS002', name: 'Interstate', capacity: 55 },
//   ]);

//   // Users state for CRUD
//   const [users, setUsers] = useState([
//     { id: 'USR001', name: 'Alice Brown', email: 'alice@example.com' },
//     { id: 'USR002', name: 'Bob Green', email: 'bob@example.com' },
//   ]);

//   // Form state for Add/Edit
//   const [busForm, setBusForm] = useState({ id: '', name: '', capacity: '' });
//   const [userForm, setUserForm] = useState({ id: '', name: '', email: '' });

//   // To track if editing or creating
//   const [isEditingBus, setIsEditingBus] = useState(false);
//   const [isEditingUser, setIsEditingUser] = useState(false);

//   const navigation = [
//     { name: 'Dashboard', icon: LayoutDashboard, id: 'dashboard' },
//     { name: 'Buses', icon: Bus, id: 'buses' },
//     { name: 'Bookings', icon: Calendar, id: 'bookings' },
//     { name: 'Customers', icon: Users, id: 'customers' },
//     { name: 'Routes', icon: MapPin, id: 'routes' },
//     { name: 'Analytics', icon: BarChart3, id: 'analytics' },
//     { name: 'Settings', icon: Settings, id: 'settings' },
//   ];

//   const stats = [
//     { name: 'Total Bookings', value: '2,847', change: '+12%', changeType: 'positive' },
//     { name: 'Active Buses', value: '124', change: '+2%', changeType: 'positive' },
//     { name: 'Revenue', value: '$89,420', change: '+18%', changeType: 'positive' },
//     { name: 'Customers', value: '1,342', change: '-2%', changeType: 'negative' },
//   ];

//   const recentBookings = [
//     { id: 'BK001', customer: 'John Doe', route: 'NYC → Boston', date: '2024-05-25', status: 'confirmed' },
//     { id: 'BK002', customer: 'Jane Smith', route: 'LA → SF', date: '2024-05-25', status: 'pending' },
//     { id: 'BK003', customer: 'Mike Johnson', route: 'Miami → Orlando', date: '2024-05-24', status: 'confirmed' },
//     { id: 'BK004', customer: 'Sarah Wilson', route: 'Chicago → Detroit', date: '2024-05-24', status: 'cancelled' },
//   ];

//   // Bus CRUD handlers
//   const handleBusFormChange = (e) => {
//     const { name, value } = e.target;
//     setBusForm(prev => ({ ...prev, [name]: value }));
//   };

//   const addBus = () => {
//     if(!busForm.id || !busForm.name || !busForm.capacity) return alert("Fill all fields!");
//     if(buses.find(b => b.id === busForm.id)) return alert("Bus ID must be unique!");
//     setBuses(prev => [...prev, { ...busForm, capacity: Number(busForm.capacity) }]);
//     setBusForm({ id: '', name: '', capacity: '' });
//   };

//   const editBus = (bus) => {
//     setBusForm(bus);
//     setIsEditingBus(true);
//   };

//   const updateBus = () => {
//     setBuses(prev => prev.map(b => b.id === busForm.id ? { ...busForm, capacity: Number(busForm.capacity) } : b));
//     setBusForm({ id: '', name: '', capacity: '' });
//     setIsEditingBus(false);
//   };

//   const deleteBus = (id) => {
//     if(window.confirm("Delete this bus?")) {
//       setBuses(prev => prev.filter(b => b.id !== id));
//     }
//   };

//   // User CRUD handlers
//   const handleUserFormChange = (e) => {
//     const { name, value } = e.target;
//     setUserForm(prev => ({ ...prev, [name]: value }));
//   };

//   const addUser = () => {
//     if(!userForm.id || !userForm.name || !userForm.email) return alert("Fill all fields!");
//     if(users.find(u => u.id === userForm.id)) return alert("User ID must be unique!");
//     setUsers(prev => [...prev, { ...userForm }]);
//     setUserForm({ id: '', name: '', email: '' });
//   };

//   const editUser = (user) => {
//     setUserForm(user);
//     setIsEditingUser(true);
//   };

//   const updateUser = () => {
//     setUsers(prev => prev.map(u => u.id === userForm.id ? userForm : u));
//     setUserForm({ id: '', name: '', email: '' });
//     setIsEditingUser(false);
//   };

//   const deleteUser = (id) => {
//     if(window.confirm("Delete this user?")) {
//       setUsers(prev => prev.filter(u => u.id !== id));
//     }
//   };

//   const renderBuses = () => (
//     <div>
//       <h3 className="text-lg font-semibold mb-4">Bus List</h3>

//       {/* Bus Form */}
//       <div className="font-bold text-gray-900 mb-6 p-4 bg-white rounded shadow-sm border">
//         <h4 className="mb-2">{isEditingBus ? 'Edit Bus' : 'Add New Bus'}</h4>
//         <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
//           <input
//             type="text"
//             name="id"
//             placeholder="Bus ID"
//             value={busForm.id}
//             onChange={handleBusFormChange}
//             disabled={isEditingBus}
//             className="border p-2 rounded"
//             color='black'
//           />
//           <input
//             type="text"
//             name="name"
//             placeholder="Bus Name"
//             value={busForm.name}
//             onChange={handleBusFormChange}
//             className="border p-2 rounded"
//             color='gray'
//           />
//           <input
//             type="number"
//             name="capacity"
//             placeholder="Capacity"
//             value={busForm.capacity}
//             onChange={handleBusFormChange}
//             className="border p-2 rounded"
//             color='black'
//           />
//           <div>
//             {isEditingBus ? (
//               <>
//                 <button
//                   onClick={updateBus}
//                   className="px-4 py-2 bg-blue-600 text-white rounded mr-2"
//                 >
//                   Update
//                 </button>
//                 <button
//                   onClick={() => {
//                     setIsEditingBus(false);
//                     setBusForm({ id: '', name: '', capacity: '' });
//                   }}
//                   className="px-4 py-2 bg-gray-300 rounded"
//                 >
//                   Cancel
//                 </button>
//               </>
//             ) : (
//               <button
//                 onClick={addBus}
//                 className="px-4 py-2 bg-green-600 text-white rounded"
//               >
//                 Add Bus
//               </button>
//             )}
//           </div>
//         </div>
//       </div>

//       {/* Bus List Table */}
//       <div className="overflow-x-auto bg-white rounded shadow-sm border">
//         <table className="min-w-full divide-y divide-gray-200">
//           <thead className="bg-gray-50">
//             <tr>
//               <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
//                 Bus ID
//               </th>
//               <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
//                 Name
//               </th>
//               <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
//                 Capacity
//               </th>
//               <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
//                 Actions
//               </th>
//             </tr>
//           </thead>
//           <tbody className="bg-white divide-y divide-gray-200">
//             {buses.map((bus) => (
//               <tr key={bus.id} className="hover:bg-gray-50">
//                 <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{bus.id}</td>
//                 <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{bus.name}</td>
//                 <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{bus.capacity}</td>
//                 <td className="px-6 py-4 whitespace-nowrap text-sm">
//                   <button
//                     onClick={() => editBus(bus)}
//                     className="text-blue-600 hover:underline mr-4"
//                   >
//                     Edit
//                   </button>
//                   <button
//                     onClick={() => deleteBus(bus.id)}
//                     className="text-red-600 hover:underline"
//                   >
//                     Delete
//                   </button>
//                 </td>
//               </tr>
//             ))}
//           </tbody>
//         </table>
//       </div>
//     </div>
//   );

//   const renderUsers = () => (
//     <div>
//       <h3 className="text-lg font-semibold mb-4">User List</h3>

//       {/* User Form */}
//       <div className="mb-6 p-4 bg-white rounded shadow-sm border">
//         <h4 className="font-semibold mb-2">{isEditingUser ? 'Edit User' : 'Add New User'}</h4>
//         <div className="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
//           <input
//             type="text"
//             name="id"
//             placeholder="User ID"
//             value={userForm.id}
//             onChange={handleUserFormChange}
//             disabled={isEditingUser}
//             className="border p-2 rounded"
//           />
//           <input
//             type="text"
//             name="name"
//             placeholder="Name"
//             value={userForm.name}
//             onChange={handleUserFormChange}
//             className="border p-2 rounded"
//           />
//           <input
//             type="email"
//             name="email"
//             placeholder="Email"
//             value={userForm.email}
//             onChange={handleUserFormChange}
//             className="border p-2 rounded"
//           />
//           <div>
//             {isEditingUser ? (
//               <>
//                 <button
//                   onClick={updateUser}
//                   className="px-4 py-2 bg-blue-600 text-white rounded mr-2"
//                 >
//                   Update
//                 </button>
//                 <button
//                   onClick={() => {
//                     setIsEditingUser(false);
//                     setUserForm({ id: '', name: '', email: '' });
//                   }}
//                   className="px-4 py-2 bg-gray-300 rounded"
//                 >
//                   Cancel
//                 </button>
//               </>
//             ) : (
//               <button
//                 onClick={addUser}
//                 className="px-4 py-2 bg-green-600 text-white rounded"
//               >
//                 Add User
//               </button>
//             )}
//           </div>
//         </div>
//       </div>

//       {/* User List Table */}
//       <div className="overflow-x-auto bg-white rounded shadow-sm border">
//         <table className="min-w-full divide-y divide-gray-200">
//           <thead className="bg-gray-50">
//             <tr>
//               <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
//                 User ID
//               </th>
//               <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
//                 Name
//               </th>
//               <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
//                 Email
//               </th>
//               <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
//                 Actions
//               </th>
//             </tr>
//           </thead>
//           <tbody className="bg-white divide-y divide-gray-200">
//             {users.map((user) => (
//               <tr key={user.id} className="hover:bg-gray-50">
//                 <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{user.id}</td>
//                 <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{user.name}</td>
//                 <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{user.email}</td>
//                 <td className="px-6 py-4 whitespace-nowrap text-sm">
//                   <button
//                     onClick={() => editUser(user)}
//                     className="text-blue-600 hover:underline mr-4"
//                   >
//                     Edit
//                   </button>
//                   <button
//                     onClick={() => deleteUser(user.id)}
//                     className="text-red-600 hover:underline"
//                   >
//                     Delete
//                   </button>
//                 </td>
//               </tr>
//             ))}
//           </tbody>
//         </table>
//       </div>
//     </div>
//   );

//   const renderContent = () => {
//     switch(activeTab) {
//       case 'dashboard':
//         return (
//           <div className="space-y-6">
//             {/* Stats Grid */}
//             <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
//               {stats.map((stat) => (
//                 <div key={stat.name} className="bg-white rounded-lg shadow-sm border p-6">
//                   <div className="flex items-center justify-between">
//                     <div>
//                       <p className="text-sm font-medium text-gray-600">{stat.name}</p>
//                       <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
//                     </div>
//                     <div className={`text-sm font-medium ${
//                       stat.changeType === 'positive' ? 'text-green-600' : 'text-red-600'
//                     }`}>
//                       {stat.change}
//                     </div>
//                   </div>
//                 </div>
//               ))}
//             </div>

//             {/* Recent Bookings */}
//             <div className="bg-white rounded-lg shadow-sm border">
//               <div className="px-6 py-4 border-b border-gray-200">
//                 <h3 className="text-lg font-semibold text-gray-900">Recent Bookings</h3>
//               </div>
//               <div className="overflow-x-auto">
//                 <table className="min-w-full divide-y divide-gray-200">
//                   <thead className="bg-gray-50">
//                     <tr>
//                       <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking ID</th>
//                       <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
//                       <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Route</th>
//                       <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
//                       <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
//                     </tr>
//                   </thead>
//                   <tbody className="bg-white divide-y divide-gray-200">
//                     {recentBookings.map((booking) => (
//                       <tr key={booking.id} className="hover:bg-gray-50">
//                         <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{booking.id}</td>
//                         <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{booking.customer}</td>
//                         <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{booking.route}</td>
//                         <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{booking.date}</td>
//                         <td className={`px-6 py-4 whitespace-nowrap text-sm font-semibold ${
//                           booking.status === 'confirmed' ? 'text-green-600' :
//                           booking.status === 'pending' ? 'text-yellow-600' : 'text-red-600'
//                         }`}>
//                           {booking.status.charAt(0).toUpperCase() + booking.status.slice(1)}
//                         </td>
//                       </tr>
//                     ))}
//                   </tbody>
//                 </table>
//               </div>
//             </div>
//           </div>
//         );
//       case 'buses':
//         return renderBuses();
//       case 'customers':
//         return renderUsers();
//       // Add other tabs as needed...
//       default:
//         return <div>Select a tab to view content.</div>;
//     }
//   };

//   return (
//     <div className="flex min-h-screen">
//       {/* Sidebar */}
//       <aside className={`bg-gray-800 text-gray-100 w-64 flex-shrink-0 transition-all duration-300 ${sidebarOpen ? 'block' : 'hidden'}`}>
//         <div className="flex items-center justify-center h-16 border-b border-gray-700 font-bold text-xl">
//           Bus Dashboard
//         </div>
//         <nav className="flex flex-col p-4 space-y-2">
//           {navigation.map((item) => (
//             <button
//               key={item.name}
//               className={`flex items-center p-2 rounded hover:bg-gray-700 focus:outline-none ${
//                 activeTab === item.id ? 'bg-gray-700' : ''
//               }`}
//               onClick={() => setActiveTab(item.id)}
//             >
//               <item.icon className="w-5 h-5 mr-2" />
//               <span>{item.name}</span>
//             </button>
//           ))}
//         </nav>
//       </aside>

//       {/* Main content */}
//       <main className="flex-1 bg-gray-100 p-6 overflow-auto">
//         {/* Top bar */}
//         <header className="flex justify-between items-center mb-6">
//           <button
//             className="text-gray-800 md:hidden"
//             title='Toggle Sidebar'
//             onClick={() => setSidebarOpen(!sidebarOpen)}
//           >
//             <svg
//               className="w-6 h-6"
//               fill="none"
//               stroke="currentColor"
//               viewBox="0 0 24 24"
//               xmlns="http://www.w3.org/2000/svg"
//             >
//               <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
//             </svg>
//           </button>

//           <div className="flex items-center space-x-4">
//             <div className="relative text-gray-600">
//               <input
//                 type="search"
//                 placeholder="Search"
//                 className="bg-gray-200 rounded-full pl-10 pr-4 py-2 text-sm focus:outline-none"
//               />
//               <Search className="absolute left-3 top-2.5 w-5 h-5 text-gray-400" />
//             </div>

//             <Bell className="w-6 h-6 text-gray-600 cursor-pointer" />
//             <button className="flex items-center space-x-2 focus:outline-none">
//               <span className="font-medium text-gray-700">Admin</span>
//               <ChevronDown className="w-4 h-4 text-gray-600" />
//             </button>
//           </div>
//         </header>

//         {/* Content area */}
//         {renderContent()}
//       </main>
//     </div>
//   );
// };

// export default Dashboard;
