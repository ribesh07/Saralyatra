"use client";

import { MessageCircle } from "lucide-react";
import { useRouter } from "next/navigation";

const ChatButton = () => {
  const router = useRouter();
    const handleClick = () => {
    router.push("/chat");
  };

  return (
    <div className="fixed bottom-6 right-6 z-50">
      <button
        onClick={() => handleClick()}
        className="bg-blue-600 text-white p-4 rounded-full shadow-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400"
        aria-label="Chat"
      >
        <MessageCircle className="w-6 h-6" />
      </button>
    </div>
  );
};

export default ChatButton;
