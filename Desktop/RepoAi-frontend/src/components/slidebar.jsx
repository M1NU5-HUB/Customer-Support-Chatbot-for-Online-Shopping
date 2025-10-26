import { Coffee, Plus, Menu, User } from 'lucide-react';
import { useNavigate, useLocation } from 'react-router-dom';

export default function SidebarLayout({ children }) {
  const navigate = useNavigate();
  const location = useLocation();

  const isActive = (path) => location.pathname === path;

  return (
    <div className="min-h-screen bg-neutral-950 text-white flex">
      {/* Sidebar */}
      <aside className="w-80 bg-neutral-900 p-6">
        {/* Repo AI Header */}
        <div className="flex items-center gap-3 mb-8 cursor-pointer" onClick={() => navigate('/home')}>
          <div className="w-12 h-12 flex items-center justify-center">
            <Coffee className="w-8 h-8 text-white" />
          </div>
          <span className="text-xl font-semibold">Repo AI</span>
        </div>

        {/* Navigation Items */}
        <nav className="space-y-3">
          <button 
            onClick={() => navigate('/init-chat')}
            className={`w-full flex items-center gap-4 p-4 rounded-xl transition-colors ${
              isActive('/init-chat') || isActive('/home') ? 'bg-neutral-800' : 'hover:bg-neutral-800'
            }`}
          >
            <div className={`w-10 h-10 flex items-center justify-center rounded-lg ${
              isActive('/init-chat') || isActive('/home') ? 'bg-neutral-700' : ''
            }`}>
              <Plus className="w-5 h-5" />
            </div>
            <span className="font-medium">New Chat</span>
          </button>

          <button 
            onClick={() => navigate('/chat')}
            className={`w-full flex items-center gap-4 p-4 rounded-xl transition-colors ${
              isActive('/chat') ? 'bg-neutral-800' : 'hover:bg-neutral-800'
            }`}
          >
            <div className={`w-10 h-10 flex items-center justify-center rounded-lg ${
              isActive('/chat') ? 'bg-neutral-700' : ''
            }`}>
              <Menu className="w-5 h-5" />
            </div>
            <span className="font-medium">Chat History</span>
          </button>

          <button 
            onClick={() => navigate('/profile')}
            className={`w-full flex items-center gap-4 p-4 rounded-xl transition-colors ${
              isActive('/profile') ? 'bg-neutral-800' : 'hover:bg-neutral-800'
            }`}
          >
            <div className={`w-10 h-10 flex items-center justify-center rounded-lg ${
              isActive('/profile') ? 'bg-neutral-700' : ''
            }`}>
              <User className="w-5 h-5" />
            </div>
            <span className="font-medium">Profile</span>
          </button>
        </nav>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1">
        {children}
      </main>
    </div>
  );
}