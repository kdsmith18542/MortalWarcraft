import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface AuthState {
  isAuthenticated: boolean
  token: string | null
  user: any | null
  login: (token: string, user: any) => void
  logout: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      isAuthenticated: false,
      token: null,
      user: null,
      login: (token, user) => {
        localStorage.setItem('token', token)
        set({ isAuthenticated: true, token, user })
      },
      logout: () => {
        localStorage.removeItem('token')
        set({ isAuthenticated: false, token: null, user: null })
      },
    }),
    {
      name: 'auth-storage',
      partialize: (state) => ({ token: state.token, user: state.user, isAuthenticated: !!state.token }),
    }
  )
)

// Initialize from localStorage on load
if (typeof window !== 'undefined') {
  const token = localStorage.getItem('token')
  if (token) {
    useAuthStore.setState({ token, isAuthenticated: true })
  }
}

