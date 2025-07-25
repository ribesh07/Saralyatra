import React, { useState, ChangeEvent } from 'react';
import { Plus, Edit, Trash2, Upload } from 'lucide-react';
import AddTourPackageForm from './AddTourPackageForm';

interface TourPackage {
  id: number;
  title: string;
  description: string;
  image: string | null;
  price: string;
  duration: string;
}

const ToursPackagesPage: React.FC = () => {
  const [toursPackages, setToursPackages] = useState<TourPackage[]>([
    {
      id: 1,
      title: "Himalayan Adventure Trek",
      description: "Experience the breathtaking beauty of the Himalayas with our guided trekking tour. Perfect for adventure enthusiasts.",
      image: null,
      price: "$1,299",
      duration: "14 days"
    },
    {
      id: 2,
      title: "Cultural Heritage Package",
      description: "Explore ancient temples, traditional villages, and immerse yourself in local culture and traditions.",
      image: null,
      price: "$899",
      duration: "7 days"
    },
    {
      id: 3,
      title: "Wildlife Safari Experience",
      description: "Discover exotic wildlife in their natural habitat with professional guides and luxury accommodations.",
      image: null,
      price: "$1,599",
      duration: "10 days"
    }
  ]);
  const [enabled, setenabled] = useState(false);

   const handleClose = () => {
    setenabled(false);
  };

  const handleOpen = () => {
    setenabled(true);
  };

  const handleImageUpload = (id: number, event: ChangeEvent<HTMLInputElement>): void => {
    const file = event.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e: ProgressEvent<FileReader>) => {
        const result = e.target?.result as string;
        setToursPackages(prev => 
          prev.map(item => 
            item.id === id 
              ? { ...item, image: result }
              : item
          )
        );
      };
      reader.readAsDataURL(file);
    }
  };

  const handleDelete = (id: number): void => {
    if (window.confirm('Are you sure you want to delete this item?')) {
      setToursPackages(prev => prev.filter(item => item.id !== id));
    }
  };

  const handleUpdate = (id: number): void => {
    alert(`Update functionality for item ID: ${id}`);
  };

  const handleAddNew = (): void => {
        setenabled(true);
  };

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-7xl mx-auto">
        <div className="bg-white rounded-lg shadow-sm p-6 mb-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Tours & Packages Management</h1>
          <p className="text-gray-600">Manage your travel tours and packages efficiently</p>
        </div>

        <div className="flex justify-start mb-6">
          <button
            onClick={handleAddNew}
            className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg flex items-center gap-2 font-medium transition-colors"
          >
            <Plus size={20} />
            Add Tours & Package
          </button>
        </div>
        { enabled && <AddTourPackageForm onClose={handleClose} /> }

        <div className="bg-white rounded-lg shadow-sm overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Image
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Title
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Description
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Price
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Duration
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {toursPackages.map((item: TourPackage) => (
                  <tr key={item.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        {item.image ? (
                          <img
                            src={item.image}
                            alt={item.title}
                            className="h-12 w-12 rounded-lg object-cover"
                          />
                        ) : (
                          <div className="h-12 w-12 bg-gray-200 rounded-lg flex items-center justify-center">
                            <Upload size={16} className="text-gray-400" />
                          </div>
                        )}
                        <label className="ml-2 cursor-pointer">
                          <input
                            type="file"
                            accept="image/*"
                            onChange={(e) => handleImageUpload(item.id, e)}
                            className="hidden"
                          />
                          <button 
                            type="button"
                            className="text-blue-600 hover:text-blue-700 text-sm font-medium"
                          >
                            {item.image ? 'Change' : 'Add Image'}
                          </button>
                        </label>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-medium text-gray-900">
                        {item.title}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-500 max-w-xs truncate">
                        {item.description}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                      {item.price}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {item.duration}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleUpdate(item.id)}
                          className="text-blue-600 hover:text-blue-700 p-1 rounded transition-colors"
                          title="Update"
                          type="button"
                        >
                          <Edit size={16} />
                        </button>
                        <button
                          onClick={() => handleDelete(item.id)}
                          className="text-red-600 hover:text-red-700 p-1 rounded transition-colors"
                          title="Delete"
                          type="button"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div className="grid grid-cols-1 gap-6 mt-6">
          <div className="bg-white p-6 rounded-lg shadow-sm">
            <h3 className="text-lg font-semibold text-gray-900 mb-2">Total Items</h3>
            <p className="text-3xl font-bold text-blue-600">
              {toursPackages.length}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ToursPackagesPage;