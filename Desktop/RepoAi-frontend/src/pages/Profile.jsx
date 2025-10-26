export default function Profile() {
  return (
    <div className="flex flex-col h-full bg-neutral-950 text-white">
      {/* Profile Header */}
      <div className="p-8 pb-6">
        <h1 className="text-3xl font-bold">Profile</h1>
      </div>

      {/* Profile Content */}
      <div className="flex-1 px-8">
        <div className="max-w-2xl mx-auto">
          {/* Profile Card */}
          <div className="text-center mb-12">
            <div className="w-36 h-36 rounded-full bg-orange-300 mx-auto mb-6 overflow-hidden">
              <img 
                src="https://api.dicebear.com/7.x/avataaars/svg?seed=Sophia" 
                alt="Profile" 
                className="w-full h-full object-cover"
              />
            </div>
            <h2 className="text-3xl font-bold mb-2">Sophia Chen</h2>
            <p className="text-orange-400 text-lg">GitHub User</p>
            
            <button className="mt-6 bg-neutral-700 hover:bg-neutral-600 px-24 py-3 rounded-lg font-medium transition-colors">
              Logout
            </button>
          </div>

          {/* Clear History Section */}
          <div className="bg-neutral-900/50 rounded-lg p-6">
            <div className="flex items-start justify-between">
              <div>
                <h3 className="text-xl font-semibold mb-2">Clear All History?</h3>
                <p className="text-orange-400 mb-1">
                  Manage the permissions This will permanently delete all 5 refactoring sessions.
                </p>
                <p className="text-gray-400">
                  This action cannot be undone.
                </p>
              </div>
              <button className="bg-neutral-700 hover:bg-neutral-600 px-8 py-2.5 rounded-lg font-medium whitespace-nowrap ml-6 transition-colors">
                Clear History
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}