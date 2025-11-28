/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        mortal: {
          dark: '#1a1a1a',
          darker: '#0f0f0f',
          accent: '#8b4513',
          gold: '#ffd700',
        },
      },
    },
  },
  plugins: [],
}

