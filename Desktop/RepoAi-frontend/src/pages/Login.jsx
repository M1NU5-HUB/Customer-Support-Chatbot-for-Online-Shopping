import React from "react";
import cup from "../photo/cup.png"; // ✅ Your logo

export default function Login() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-[#121212] text-center text-white px-4">
      {/* Logo */}
      <img
        src={cup}
        alt="RepoAI Logo"
        className="w-[200px] h-[200px]  mb-6 object-contain"
      />

      {/* Title */}
      <h1 className="text-2xl font-semibold mb-2 text-white">Log in to RepoAI</h1>

      {/* Description */}
      <p className="text-sm text-white max-w-sm mb-8 leading-relaxed">
        We use GitHub OAuth for secure and simple authentication. <br />
        Your personal information is never stored on our servers.
      </p>

      {/* Button */}
      <button className="flex items-center gap-2 bg-[#f6ad37] hover:bg-[#e39c20] text-black font-medium py-3 px-6 rounded-lg transition-all duration-200">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="currentColor"
          className="w-5 h-5"
        >
          <path
            fillRule="evenodd"
            d="M12 0C5.37 0 0 5.373 0 12c0 5.303 3.438 9.8 8.205 11.387.6.113.82-.26.82-.578 
            0-.285-.01-1.04-.016-2.04-3.338.727-4.042-1.61-4.042-1.61-.547-1.388-1.335-1.758-1.335-1.758
            -1.09-.744.083-.729.083-.729 1.205.085 1.84 1.237 1.84 1.237 1.07 1.835 2.808 1.305 3.492.998.107-.776.42-1.305.763-1.606
            -2.665-.303-5.466-1.333-5.466-5.932 0-1.31.47-2.382 1.236-3.222-.124-.304-.536-1.523.118-3.176 0 0 1.008-.322 3.3 
            1.23a11.52 11.52 0 013.003-.403c1.02.005 2.045.137 3.003.403 2.29-1.552 3.296-1.23 
            3.296-1.23.656 1.653.244 2.872.12 3.176.77.84 1.236 1.912 1.236 3.222 
            0 4.61-2.807 5.625-5.479 5.921.43.37.823 1.102.823 2.222 
            0 1.606-.015 2.901-.015 3.293 0 .321.216.694.825.576C20.565 
            21.796 24 17.298 24 12c0-6.627-5.373-12-12-12z"
            clipRule="evenodd"
          />
        </svg>
        Login with GitHub
      </button>
    </div>
  );
}
