import { Plus } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function Home() {
  const navigate = useNavigate();

  return (
    <div className="flex flex-col h-screen bg-neutral-950 text-white">
      {/* Header */}
      <div className="px-8 py-6 border-b border-neutral-800">
        <h1 className="text-3xl font-bold mb-2">Welcome, @github-username</h1>
        <p className="text-orange-400">
          Connected to GitHub • 12 repositories ready to analyze
        </p>
      </div>

      {/* Main Content - Centered */}
      <div className="flex-1 flex items-center justify-center px-8">
        <div className="text-center max-w-3xl">
          <h2 className="text-5xl font-bold mb-4 leading-tight">
            Welcome to Repo AI
          </h2>
          <p className="text-2xl text-gray-300 mb-10">
            Your AI-Powered Code Refactoring Assistant
          </p>

          <button 
            onClick={() => navigate('/init-chat')}
            className="bg-yellow-500 hover:bg-yellow-600 text-black font-bold py-4 px-8 rounded-xl inline-flex items-center gap-3 transition-colors text-lg mb-6"
          >
            <Plus className="w-6 h-6" />
            Create a new chat
          </button>

          <p className="text-orange-400">
            Pick a repository and branch to analyze your code
          </p>
        </div>
      </div>
    </div>
  );
}