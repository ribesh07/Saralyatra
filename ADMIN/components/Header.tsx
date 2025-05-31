
//   const Header = () => (
//     <div className="bg-white border-b border-gray-200 px-6 py-4">
//       <div className="flex items-center justify-between">
//         <div>
//           {/* <h1 className="text-2xl font-bold text-gray-800">Customers</h1>
//           <p className="text-gray-600 mt-1">
//             Manage and view all customer information and booking history.
//           </p> */}
//         </div>
//         <div className="flex items-center space-x-4">
//           <div className="relative">
//             {/* <input
//               type="text"
//               placeholder="Search..."
//               className="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
//             /> */}
//           </div>
//           <div className="flex items-center space-x-2">
//             <div className="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white font-medium">
//               A
//             </div>
//             <span className="text-sm text-gray-600">Admin User</span>
//           </div>
//         </div>
//       </div>
//     </div>
//   );
// "use client";
import { ChevronDown } from "lucide-react";


  const Header = () => {
    return (
        <>
     {/* Top Navigation */}
        <header className="bg-white shadow-sm border-b border-gray-200">
          <div className="flex items-center justify-between h-16 px-6">
            <div className="flex items-center space-x-4">
            </div>
            {/* Right side */}
            <div className="flex items-center space-x-4">              
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
        </>
    );
  }
export default Header;