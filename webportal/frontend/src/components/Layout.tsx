import { Outlet, Link, useNavigate } from 'react-router-dom'
import { useAuthStore } from '../stores/authStore'

export default function Layout() {
  const { isAuthenticated, logout } = useAuthStore()
  const navigate = useNavigate()

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  return (
    <div className="min-h-screen bg-mortal-darker">
      <nav className="bg-mortal-dark border-b border-mortal-accent">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex">
              <Link to="/" className="flex items-center px-4 text-mortal-gold font-bold text-xl">
                Mortal Atlas
              </Link>
              <div className="flex space-x-4">
                <Link to="/" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-mortal-accent">
                  Dashboard
                </Link>
                <Link to="/killboard" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-mortal-accent">
                  Killboard
                </Link>
                <Link to="/map" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-mortal-accent">
                  Map
                </Link>
                <Link to="/warfronts" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-mortal-accent">
                  Warfronts
                </Link>
                <Link to="/market" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-mortal-accent">
                  Market
                </Link>
                <Link to="/wiki" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-mortal-accent">
                  Wiki
                </Link>
                <Link to="/shop" className="px-3 py-2 rounded-md text-sm font-medium hover:bg-mortal-accent">
                  Shop
                </Link>
              </div>
            </div>
            <div className="flex items-center">
              {isAuthenticated ? (
                <button
                  onClick={handleLogout}
                  className="px-4 py-2 rounded-md text-sm font-medium bg-red-600 hover:bg-red-700"
                >
                  Logout
                </button>
              ) : (
                <Link
                  to="/login"
                  className="px-4 py-2 rounded-md text-sm font-medium bg-mortal-accent hover:bg-opacity-80"
                >
                  Login
                </Link>
              )}
            </div>
          </div>
        </div>
      </nav>
      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <Outlet />
      </main>
    </div>
  )
}

