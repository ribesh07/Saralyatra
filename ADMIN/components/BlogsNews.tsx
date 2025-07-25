"use client";
import React, { useState } from "react";
import { MapPin, Calendar, Clock, Heart, Share2, User, ArrowLeft } from 'lucide-react';

interface BlogPost {
  id: number;
  title: string;
  location: string;
  excerpt: string;
  content: string;
  image: string;
  author: string;
  date: string;
  readTime: string;
  tags: string[];
  likes: number;
}

interface NewsItem {
  id: number;
  title: string;
  excerpt: string;
  content: string;
  image: string;
  source: string;
  date: string;
  category: string;
}

const blogPosts: BlogPost[] = [
  {
    id: 1,
    title: "Discovering the Magic of Everest Base Camp",
    location: "Khumbu Region",
    excerpt: "Journey through the legendary trails that lead to the base of the world's highest peak, experiencing Sherpa culture and breathtaking mountain vistas.",
    content: "The trek to Everest Base Camp is more than just a hike; it's a transformative journey through some of the world's most spectacular mountain scenery. Starting from Lukla, the trail winds through ancient rhododendron forests, across suspension bridges, and past traditional Sherpa villages. The acclimatization stops in Namche Bazaar and Tengboche offer glimpses into the rich Buddhist culture of the region, with monasteries perched dramatically against towering peaks. The final approach to base camp reveals the raw power and beauty of the Himalayas, where mountaineers from around the world gather to attempt the ultimate summit.",
    image: "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800&h=500&fit=crop",
    author: "Pemba Sherpa",
    date: "March 15, 2024",
    readTime: "8 min read",
    tags: ["Trekking", "Mountains", "Adventure"],
    likes: 234
  },
  {
    id: 2,
    title: "Sunrise Over Sarangkot: Pokhara's Golden Hour",
    location: "Pokhara Valley",
    excerpt: "Wake up early to witness one of Nepal's most spectacular sunrises as the Annapurna range glows golden above the serene Phewa Lake.",
    content: "Sarangkot, perched at 1,600 meters above sea level, offers one of the most breathtaking sunrise views in Nepal. As dawn breaks, the Annapurna range, including Machapuchare (Fishtail), transforms from dark silhouettes to glowing golden peaks. The panoramic view encompasses the entire Annapurna massif, stretching from Annapurna I to Dhaulagiri. Below, Phewa Lake mirrors the morning sky, creating a perfect reflection of the surrounding mountains. The experience is made even more special by the peaceful atmosphere and the gradual awakening of Pokhara city in the valley below.",
    image: "https://images.unsplash.com/photo-1605540436563-5bca919ae766?w=800&h=500&fit=crop",
    author: "Maya Gurung",
    date: "March 10, 2024",
    readTime: "5 min read",
    tags: ["Sunrise", "Mountains", "Photography"],
    likes: 189
  },
  {
    id: 3,
    title: "Cultural Treasures of Kathmandu Durbar Square",
    location: "Kathmandu",
    excerpt: "Step back in time as you explore the ancient palaces, temples, and courtyards that showcase Nepal's rich architectural heritage.",
    content: "Kathmandu Durbar Square stands as a testament to Nepal's rich cultural heritage and architectural prowess. This UNESCO World Heritage Site houses the old royal palace of the former Kathmandu Kingdom and numerous temples dating back to the 12th century. The intricate wood carvings, stone sculptures, and pagoda-style architecture represent centuries of Newari craftsmanship. Key highlights include the Hanuman Dhoka Palace, Taleju Temple, and the living goddess Kumari's residence. Despite damage from the 2015 earthquake, ongoing restoration efforts continue to preserve this cultural treasure for future generations.",
    image: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=500&fit=crop",
    author: "Rajesh Shakya",
    date: "March 5, 2024",
    readTime: "6 min read",
    tags: ["Culture", "Heritage", "Architecture"],
    likes: 156
  },
  {
    id: 4,
    title: "Wildlife Safari in Chitwan National Park",
    location: "Chitwan",
    excerpt: "Experience Nepal's incredible biodiversity as you search for one-horned rhinoceros, Bengal tigers, and exotic birds in the Terai lowlands.",
    content: "Chitwan National Park, Nepal's first national park, offers an incredible wildlife experience in the subtropical lowlands of the Terai. Home to over 700 species of wildlife, including the endangered one-horned rhinoceros and Bengal tiger, the park provides excellent opportunities for wildlife viewing. Elephant-back safaris and jeep tours through the grasslands and forests reveal a diverse ecosystem. The park is also a birdwatcher's paradise with over 540 bird species recorded, including the colorful kingfishers and majestic hornbills. Evening visits to traditional Tharu villages add a cultural dimension to the wildlife experience.",
    image: "https://images.unsplash.com/photo-1578834438732-83ad1b6a8b3e?w=800&h=500&fit=crop",
    author: "Suman Tamang",
    date: "February 28, 2024",
    readTime: "7 min read",
    tags: ["Wildlife", "Safari", "Nature"],
    likes: 201
  },
  {
    id: 5,
    title: "Spiritual Journey to Lumbini: Birthplace of Buddha",
    location: "Lumbini",
    excerpt: "Discover the sacred site where Prince Siddhartha was born over 2,500 years ago, now a pilgrimage destination for Buddhists worldwide.",
    content: "Lumbini, located in the Terai plains of southern Nepal, holds immense significance as the birthplace of Lord Buddha. This UNESCO World Heritage Site attracts pilgrims and visitors from around the world who come to pay homage at the exact spot where Queen Maya Devi gave birth to Prince Siddhartha in 623 BCE. The sacred garden contains the Maya Devi Temple, the Ashoka Pillar erected by Emperor Ashoka in 249 BCE, and numerous monasteries built by Buddhist communities from different countries. The peaceful atmosphere and spiritual energy of Lumbini provide a perfect environment for meditation and reflection on Buddhist teachings.",
    image: "https://images.unsplash.com/photo-1590736969955-71cc94901144?w=800&h=500&fit=crop",
    author: "Tenzin Norbu",
    date: "February 20, 2024",
    readTime: "6 min read",
    tags: ["Spirituality", "Buddhism", "Pilgrimage"],
    likes: 167
  },
  {
    id: 6,
    title: "Adventure in Annapurna Circuit: Complete Guide",
    location: "Annapurna Region",
    excerpt: "Embark on one of the world's most diverse treks, crossing the dramatic Thorong La Pass and experiencing varied landscapes from subtropical to alpine.",
    content: "The Annapurna Circuit is renowned as one of the world's greatest treks, offering incredible diversity in landscapes, cultures, and experiences. The journey begins in subtropical forests and terraced fields, gradually ascending through rhododendron and pine forests to high-altitude desert terrain. The highlight is crossing Thorong La Pass at 5,416 meters, providing stunning panoramic views of the Annapurna and Dhaulagiri mountain ranges. Along the route, trekkers encounter diverse ethnic communities including Gurung, Magar, and Thakali people, each with unique traditions and hospitality. The trek concludes in the sacred Muktinath Temple, an important pilgrimage site for both Hindus and Buddhists.",
    image: "https://images.unsplash.com/photo-1486022119026-c4ffd5615d7b?w=800&h=500&fit=crop",
    author: "Ang Dorje",
    date: "February 15, 2024",
    readTime: "10 min read",
    tags: ["Trekking", "Adventure", "Circuit"],
    likes: 298
  }
];

const newsItems: NewsItem[] = [
  {
    id: 1,
    title: "Nepal Opens New Trekking Routes in Remote Himalayas",
    excerpt: "Government announces three new high-altitude trekking circuits to boost adventure tourism while promoting sustainable mountain practices.",
    content: "The Nepal Tourism Board has officially opened three new high-altitude trekking routes in previously restricted areas of the Himalayas. These routes, located in the Manaslu-Tsum Valley region, offer experienced trekkers access to pristine mountain landscapes and authentic cultural experiences. The initiative aims to distribute tourism benefits to remote communities while maintaining strict environmental protection standards. Each route requires special permits and certified guides, ensuring both trekker safety and cultural preservation.",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop",
    source: "Nepal Tourism Board",
    date: "July 20, 2025",
    category: "Tourism"
  },
  {
    id: 2,
    title: "Successful Conservation Efforts Boost Tiger Population in Chitwan",
    excerpt: "Latest wildlife census reveals a 30% increase in Bengal tiger numbers, marking a significant conservation milestone.",
    content: "The Department of National Parks and Wildlife Conservation announced remarkable success in tiger conservation efforts across Nepal's protected areas. The latest census conducted in Chitwan National Park shows a 30% increase in Bengal tiger population over the past five years. This achievement is attributed to enhanced anti-poaching measures, community-based conservation programs, and improved prey base management. The success story demonstrates Nepal's commitment to wildlife conservation and serves as a model for other countries in the region.",
    image: "https://images.unsplash.com/photo-1578834438732-83ad1b6a8b3e?w=800&h=400&fit=crop",
    source: "Department of Wildlife Conservation",
    date: "July 18, 2025",
    category: "Conservation"
  },
  {
    id: 3,
    title: "Ancient Manuscripts Discovered in Mustang Cave Complex",
    excerpt: "Archaeological team uncovers 800-year-old Buddhist manuscripts in previously unexplored caves in Upper Mustang.",
    content: "A joint archaeological expedition involving Nepali and international researchers has made a groundbreaking discovery in the cave complexes of Upper Mustang. The team uncovered a collection of well-preserved Buddhist manuscripts dating back to the 13th century, written in ancient Tibetan script. These texts include rare philosophical treatises and medical knowledge that provide invaluable insights into medieval Himalayan Buddhism. The discovery highlights the region's historical importance as a center of learning and cultural exchange along ancient trade routes.",
    image: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop",
    source: "Archaeological Survey of Nepal",
    date: "July 15, 2025",
    category: "Heritage"
  },
  {
    id: 4,
    title: "Record-Breaking Climbing Season on Mount Everest",
    excerpt: "Spring 2025 sees highest number of successful summit attempts with improved safety measures and weather conditions.",
    content: "The 2025 spring climbing season on Mount Everest concluded with record-breaking statistics, seeing 647 successful summit attempts from both Nepal and Tibet sides. This represents a 15% increase from the previous record set in 2023. The Department of Tourism credits improved weather forecasting, enhanced safety protocols, and better coordination between expedition teams for the successful season. Despite the high numbers, the fatality rate remained at historic lows due to stringent safety measures and experienced guide requirements.",
    image: "https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800&h=400&fit=crop",
    source: "Department of Tourism",
    date: "July 12, 2025",
    category: "Adventure Sports"
  },
  {
    id: 5,
    title: "Lumbini Development Project Reaches Major Milestone",
    excerpt: "International Buddhist pilgrimage site sees completion of new meditation centers and sustainable infrastructure.",
    content: "The Lumbini Development Trust announced the completion of major infrastructure improvements at the birthplace of Lord Buddha. The project includes new meditation centers designed by renowned architects, sustainable energy systems, and enhanced facilities for international pilgrims. The development maintains strict archaeological standards while improving visitor experience and supporting local communities. The project represents collaboration between multiple Buddhist nations and international organizations committed to preserving this UNESCO World Heritage Site.",
    image: "https://images.unsplash.com/photo-1590736969955-71cc94901144?w=800&h=400&fit=crop",
    source: "Lumbini Development Trust",
    date: "July 10, 2025",
    category: "Development"
  }
];

const BlogsNews = () => {
  const [activeTab, setActiveTab] = useState("blogs");
  const [selectedPost, setSelectedPost] = useState<BlogPost | null>(null);
  const [selectedNews, setSelectedNews] = useState<NewsItem | null>(null);
  const [likedPosts, setLikedPosts] = useState(new Set<number>());

  const tabs = ["blogs", "news"];

  const handleLike = (postId: number) => {
    setLikedPosts(prev => {
      const newLiked = new Set(prev);
      if (newLiked.has(postId)) {
        newLiked.delete(postId);
      } else {
        newLiked.add(postId);
      }
      return newLiked;
    });
  };

  const handleBackToList = () => {
    setSelectedPost(null);
    setSelectedNews(null);
  };

  // Full article view for blogs
  if (selectedPost) {
    return (
      <main className="flex-1 overflow-y-auto p-6">
        <div className="max-w-4xl mx-auto">
          <button 
            onClick={handleBackToList}
            className="mb-6 flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            Back to Blogs
          </button>
          
          <article className="bg-white rounded-lg shadow-sm overflow-hidden">
            <div className="relative h-80">
              <img 
                src={selectedPost.image} 
                alt={selectedPost.title}
                className="w-full h-full object-cover"
              />
              <div className="absolute inset-0 bg-black bg-opacity-30"></div>
              <div className="absolute bottom-6 left-6 text-white">
                <div className="flex items-center gap-2 mb-2">
                  <MapPin className="w-4 h-4" />
                  <span className="text-sm">{selectedPost.location}</span>
                </div>
                <h1 className="text-3xl font-bold mb-2">{selectedPost.title}</h1>
              </div>
            </div>
            
            <div className="p-6">
              <div className="flex items-center justify-between mb-6 text-gray-600">
                <div className="flex items-center gap-4">
                  <div className="flex items-center gap-2">
                    <User className="w-4 h-4" />
                    <span>{selectedPost.author}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Calendar className="w-4 h-4" />
                    <span>{selectedPost.date}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Clock className="w-4 h-4" />
                    <span>{selectedPost.readTime}</span>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <button 
                    onClick={() => handleLike(selectedPost.id)}
                    className={`flex items-center gap-1 px-3 py-1 rounded-full transition-colors ${
                      likedPosts.has(selectedPost.id) 
                        ? 'bg-red-100 text-red-600' 
                        : 'bg-gray-100 text-gray-600 hover:bg-red-100 hover:text-red-600'
                    }`}
                  >
                    <Heart className={`w-4 h-4 ${likedPosts.has(selectedPost.id) ? 'fill-current' : ''}`} />
                    <span>{selectedPost.likes + (likedPosts.has(selectedPost.id) ? 1 : 0)}</span>
                  </button>
                  <button className="flex items-center gap-1 px-3 py-1 rounded-full bg-gray-100 text-gray-600 hover:bg-blue-100 hover:text-blue-600 transition-colors">
                    <Share2 className="w-4 h-4" />
                    <span>Share</span>
                  </button>
                </div>
              </div>
              
              <div className="flex flex-wrap gap-2 mb-6">
                {selectedPost.tags.map((tag, index) => (
                  <span 
                    key={index}
                    className="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm"
                  >
                    {tag}
                  </span>
                ))}
              </div>
              
              <div className="prose max-w-none">
                <p className="text-lg text-gray-700 leading-relaxed mb-6">
                  {selectedPost.excerpt}
                </p>
                <p className="text-gray-700 leading-relaxed">
                  {selectedPost.content}
                </p>
              </div>
            </div>
          </article>
        </div>
      </main>
    );
  }

  // Full article view for news
  if (selectedNews) {
    return (
      <main className="flex-1 overflow-y-auto p-6">
        <div className="max-w-4xl mx-auto">
          <button 
            onClick={handleBackToList}
            className="mb-6 flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            <ArrowLeft className="w-4 h-4" />
            Back to News
          </button>
          
          <article className="bg-white rounded-lg shadow-sm overflow-hidden">
            <div className="relative h-80">
              <img 
                src={selectedNews.image} 
                alt={selectedNews.title}
                className="w-full h-full object-cover"
              />
              <div className="absolute top-4 left-4">
                <span className="bg-red-600 text-white px-3 py-1 rounded-full text-sm">
                  {selectedNews.category}
                </span>
              </div>
            </div>
            
            <div className="p-6">
              <h1 className="text-3xl font-bold mb-4 text-gray-800">{selectedNews.title}</h1>
              
              <div className="flex items-center gap-4 mb-6 text-gray-600">
                <span>{selectedNews.source}</span>
                <span>•</span>
                <span>{selectedNews.date}</span>
              </div>
              
              <div className="prose max-w-none">
                <p className="text-lg text-gray-700 leading-relaxed mb-6">
                  {selectedNews.excerpt}
                </p>
                <p className="text-gray-700 leading-relaxed">
                  {selectedNews.content}
                </p>
              </div>
            </div>
          </article>
        </div>
      </main>
    );
  }

  return (
    <main className="flex-1 overflow-y-auto p-6">
      <div className="p-6 bg-white rounded-lg shadow-sm mb-6">
        <h2 className="text-2xl font-semibold text-gray-800 mb-4">Blogs and News</h2>
        
        {/* Tabs */}
        <div className="border-b border-gray-200">
          <nav className="-mb-px flex space-x-8">
            {tabs.map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`py-2 px-1 border-b-2 font-medium text-sm capitalize transition-colors ${
                  activeTab === tab
                    ? "border-blue-500 text-blue-600"
                    : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
                }`}
              >
                {tab}
              </button>
            ))}
          </nav>
        </div>
      </div>

      {activeTab === "blogs" && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {blogPosts.map((post) => (
            <article 
              key={post.id}
              className="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-all duration-300 hover:-translate-y-1 cursor-pointer"
              onClick={() => setSelectedPost(post)}
            >
              <div className="relative h-48">
                <img 
                  src={post.image} 
                  alt={post.title}
                  className="w-full h-full object-cover"
                />
                <div className="absolute top-4 left-4">
                  <span className="bg-blue-600 text-white px-3 py-1 rounded-full text-sm flex items-center gap-1">
                    <MapPin className="w-3 h-3" />
                    {post.location}
                  </span>
                </div>
              </div>
              
              <div className="p-4">
                <h3 className="text-lg font-semibold text-gray-800 mb-2">{post.title}</h3>
                <p className="text-gray-600 mb-4 text-sm">{post.excerpt}</p>
                
                <div className="flex items-center justify-between text-xs text-gray-500 mb-3">
                  <span className="flex items-center gap-1">
                    <User className="w-3 h-3" />
                    {post.author}
                  </span>
                  <span className="flex items-center gap-1">
                    <Clock className="w-3 h-3" />
                    {post.readTime}
                  </span>
                </div>
                
                <div className="flex items-center justify-between">
                  <div className="flex flex-wrap gap-1">
                    {post.tags.slice(0, 2).map((tag, index) => (
                      <span 
                        key={index}
                        className="px-2 py-1 bg-gray-100 text-gray-600 rounded text-xs"
                      >
                        {tag}
                      </span>
                    ))}
                  </div>
                  <button 
                    onClick={(e) => {
                      e.stopPropagation();
                      handleLike(post.id);
                    }}
                    className={`flex items-center gap-1 transition-colors ${
                      likedPosts.has(post.id) ? 'text-red-600' : 'text-gray-400 hover:text-red-600'
                    }`}
                  >
                    <Heart className={`w-4 h-4 ${likedPosts.has(post.id) ? 'fill-current' : ''}`} />
                    <span className="text-xs">{post.likes + (likedPosts.has(post.id) ? 1 : 0)}</span>
                  </button>
                </div>
              </div>
            </article>
          ))}
        </div>
      )}

      {activeTab === "news" && (
        <div className="space-y-6">
          {newsItems.map((news) => (
            <article 
              key={news.id}
              className="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow cursor-pointer"
              onClick={() => setSelectedNews(news)}
            >
              <div className="md:flex">
                <div className="md:w-1/3">
                  <div className="relative h-48 md:h-full">
                    <img 
                      src={news.image} 
                      alt={news.title}
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute top-4 left-4">
                      <span className="bg-red-600 text-white px-3 py-1 rounded-full text-sm">
                        {news.category}
                      </span>
                    </div>
                  </div>
                </div>
                <div className="md:w-2/3 p-6">
                  <h3 className="text-xl font-semibold text-gray-800 mb-2">{news.title}</h3>
                  <p className="text-gray-600 mb-4">{news.excerpt}</p>
                  
                  <div className="flex items-center gap-4 text-sm text-gray-500">
                    <span>{news.source}</span>
                    <span>•</span>
                    <span className="flex items-center gap-1">
                      <Calendar className="w-4 h-4" />
                      {news.date}
                    </span>
                  </div>
                </div>
              </div>
            </article>
          ))}
        </div>
      )}
    </main>
  );
};

export default BlogsNews;