import React, { useState } from 'react';
import { User, Phone, Calendar, DollarSign, Check, X, Search } from 'lucide-react';

interface Driver {
  driverID: string;
  driverName: string;
  phoneNo: string;
  totalBalance: number;
  withdrawBalance: number;
}

interface ProcessingState {
  [key: string]: boolean;
}

const DriverPaymentTable: React.FC = () => {
  const [drivers] = useState<Driver[]>([
    {
      driverID: 'DRV001',
      driverName: 'John Smith',
      phoneNo: '+1 (555) 123-4567',
      totalBalance: 1250.75,
      withdrawBalance: 800.00
    },
    {
      driverID: 'DRV002',
      driverName: 'Sarah Johnson',
      phoneNo: '+1 (555) 234-5678',
      totalBalance: 2100.50,
      withdrawBalance: 1500.00
    },
    {
      driverID: 'DRV003',
      driverName: 'Mike Wilson',
      phoneNo: '+1 (555) 345-6789',
      totalBalance: 875.25,
      withdrawBalance: 500.00
    },
    {
      driverID: 'DRV004',
      driverName: 'Emily Davis',
      phoneNo: '+1 (555) 456-7890',
      totalBalance: 1650.00,
      withdrawBalance: 1200.00
    },
    {
      driverID: 'DRV005',
      driverName: 'David Brown',
      phoneNo: '+1 (555) 567-8901',
      totalBalance: 950.75,
      withdrawBalance: 750.00
    }
  ]);

  const [processingState, setProcessingState] = useState<ProcessingState>({});
  const [searchTerm, setSearchTerm] = useState('');

  const [withdrawData, setWithdrawData] = useState<{ [key: string]: string }>({});
  const [errors, setErrors] = useState<{ [key: string]: string }>({});
  const currentDate = new Date().toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });

  const filteredDrivers = drivers.filter(driver =>
    driver.driverName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    driver.driverID.toLowerCase().includes(searchTerm.toLowerCase()) ||
    driver.phoneNo.includes(searchTerm)
  );

  const handleWithdrawChange = (driverID: string, value: string) => {
    if (value === '' || /^\d*\.?\d*$/.test(value)) {
      setWithdrawData(prev => ({ ...prev, [driverID]: value }));
      setErrors(prev => ({ ...prev, [driverID]: '' }));
    }
  };

  const validateWithdraw = (driverID: string, totalBalance: number): boolean => {
    const amount = parseFloat(withdrawData[driverID] || '');
    
    if (!withdrawData[driverID] || isNaN(amount) || amount <= 0) {
      setErrors(prev => ({ ...prev, [driverID]: 'Please enter a valid amount' }));
      return false;
    }
    
    if (amount > totalBalance) {
      setErrors(prev => ({ ...prev, [driverID]: 'Amount exceeds balance' }));
      return false;
    }
    
    return true;
  };

  const handleConfirm = async (driver: Driver) => {
    if (!validateWithdraw(driver.driverID, driver.totalBalance)) return;
    
    setProcessingState(prev => ({ ...prev, [driver.driverID]: true }));
    
    // Simulate API call
    setTimeout(() => {
      alert(`Payment of ${parseFloat(withdrawData[driver.driverID]).toFixed(2)} confirmed for ${driver.driverName}`);
      setProcessingState(prev => ({ ...prev, [driver.driverID]: false }));
      setWithdrawData(prev => ({ ...prev, [driver.driverID]: '' }));
    }, 1500);
  };

  const handleCancel = (driverID: string) => {
    setWithdrawData(prev => ({ ...prev, [driverID]: '' }));
    setErrors(prev => ({ ...prev, [driverID]: '' }));
  };

  return (
    <div className="min-h-screen bg-gray-50 p-4">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Driver Payment Management</h1>
          <p className="text-gray-600">Process payments for multiple drivers</p>
          
          {/* Search Bar */}
          <div className="mt-6 relative max-w-md">
            <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <Search className="h-5 w-5 text-gray-400" />
            </div>
            <input
              type="text"
              placeholder="Search by name, ID, or phone..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>

        {/* Table */}
        <div className="bg-white rounded-lg shadow-lg overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Driver Info
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Phone Number
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Date
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Total Balance
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Withdraw Amount
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredDrivers.map((driver) => (
                  <tr key={driver.driverID} className="hover:bg-gray-50">
                    {/* Driver Info */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                          <User className="w-5 h-5 text-blue-600" />
                        </div>
                        <div className="ml-4">
                          <div className="text-sm font-medium text-gray-900">
                            {driver.driverName}
                          </div>
                          <div className="text-sm text-gray-500">
                            ID: {driver.driverID}
                          </div>
                        </div>
                      </div>
                    </td>

                    {/* Phone Number */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <Phone className="w-4 h-4 text-gray-400 mr-2" />
                        <span className="text-sm text-gray-900">{driver.phoneNo}</span>
                      </div>
                    </td>

                    {/* Date */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <Calendar className="w-4 h-4 text-gray-400 mr-2" />
                        <span className="text-sm text-gray-900">{currentDate}</span>
                      </div>
                    </td>

                    {/* Total Balance */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        {/* <DollarSign className="w-4 h-4 text-green-500 mr-1" /> */}
                        <span className= "text-sm font-semibold text-green-600">
                          NRs {driver.totalBalance.toFixed(2)}
                        </span>
                      </div>
                    </td>

                    {/* Withdraw Amount */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        {/* <DollarSign className="w-4 h-4 text-blue-500 mr-1" /> */}
                        <span className="text-sm font-semibold text-blue-600">
                          NRs {driver.withdrawBalance.toFixed(2)}
                        </span>
                      </div>
                    </td>

                    {/* Actions */}
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex space-x-2">
                        <button
                          onClick={() => handleConfirm(driver)}
                          disabled={processingState[driver.driverID]}
                          className="inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-blue-300 disabled:cursor-not-allowed"
                        >
                          {processingState[driver.driverID] ? (
                            <>
                              <div className="w-3 h-3 border border-white border-t-transparent rounded-full animate-spin mr-1"></div>
                              Processing
                            </>
                          ) : (
                            <>
                              <Check className="w-3 h-3 mr-1" />
                              Confirm
                            </>
                          )}
                        </button>
                        
                        <button
                          onClick={() => handleCancel(driver.driverID)}
                          className="inline-flex items-center text-xs font-medium text-red-600 hover:text-red-800 focus:outline-none"
                        >
                          <X className="w-3 h-3 mr-1" />
                          Cancel
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {filteredDrivers.length === 0 && (
            <div className="text-center py-12">
              <div className="text-gray-500">
                <User className="w-12 h-12 mx-auto mb-4 opacity-50" />
                <p className="text-lg font-medium">No drivers found</p>
                <p className="text-sm">Try adjusting your search criteria</p>
              </div>
            </div>
          )}
        </div>

        {/* Summary */}
        <div className="mt-6 bg-white rounded-lg shadow p-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-gray-900">{filteredDrivers.length}</div>
              <div className="text-sm text-gray-500">Total Drivers</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-green-600">
                ${filteredDrivers.reduce((sum, driver) => sum + driver.totalBalance, 0).toFixed(2)}
              </div>
              <div className="text-sm text-gray-500">Total Balance</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">
                ${filteredDrivers.reduce((sum, driver) => sum + driver.withdrawBalance, 0).toFixed(2)}
              </div>
              <div className="text-sm text-gray-500">Total Withdrawals</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-purple-600">
                {Object.keys(processingState).filter(key => processingState[key]).length}
              </div>
              <div className="text-sm text-gray-500">Processing</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DriverPaymentTable;