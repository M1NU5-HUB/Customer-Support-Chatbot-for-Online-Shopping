import { Send } from 'lucide-react';
import { useState } from 'react';

export default function Chat() {
  const [messages, setMessages] = useState([
    {
      role: 'ai',
      content: 'Hello! How can I assist you with refactoring today?'
    },
    {
      role: 'user',
      content: 'Commit and push to a new branch.'
    },
    {
      role: 'ai',
      content: "I'll create a new branch and commit your changes.\n\nnew branch: `feature/improve-exception-handling`"
    },
    {
      role: 'ai',
      content: 'I have created a new branch and committed your changes.'
    }
  ]);
  const [inputValue, setInputValue] = useState('');

  const handleSend = () => {
    if (inputValue.trim()) {
      setMessages([...messages, { role: 'user', content: inputValue }]);
      setInputValue('');
      
      // Simulate AI response
      setTimeout(() => {
        setMessages(prev => [...prev, { 
          role: 'ai', 
          content: 'I understand. Let me help you with that.' 
        }]);
      }, 1000);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <div className="flex flex-col h-screen bg-neutral-950">
      {/* Top Bar */}
      <div className="flex items-center justify-between px-8 py-4 border-b border-neutral-800">
        <div className="text-sm text-gray-400">User</div>
        <button className="bg-yellow-500 hover:bg-yellow-600 text-black font-semibold px-8 py-2.5 rounded-lg transition-colors">
          Save Changes.
        </button>
      </div>

      {/* Messages Area */}
      <div className="flex-1 overflow-y-auto px-8 py-6 space-y-4">
        {messages.map((message, index) => (
          <div key={index} className="flex flex-col gap-2">
            <div className="text-xs text-gray-500 uppercase">
              {message.role === 'ai' ? 'AI' : 'User'}
            </div>
            <div className={`max-w-3xl p-4 rounded-lg whitespace-pre-wrap ${
              message.role === 'ai' 
                ? 'bg-neutral-800 text-white' 
                : 'bg-yellow-500 text-black ml-auto'
            }`}>
              {message.content}
            </div>
          </div>
        ))}
      </div>

      {/* Input Area */}
      <div className="px-8 py-6 border-t border-neutral-800">
        <div className="max-w-4xl mx-auto flex gap-3 items-end">
          <input
            type="text"
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
            onKeyPress={handleKeyPress}
            placeholder="Enter Your Prompt"
            className="flex-1 bg-neutral-800 text-white px-6 py-3.5 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-500"
          />
          <button 
            onClick={handleSend}
            className="bg-yellow-500 hover:bg-yellow-600 text-black font-semibold px-8 py-3.5 rounded-lg transition-colors flex items-center gap-2"
          >
            Send
          </button>
        </div>
      </div>
    </div>
  );
}