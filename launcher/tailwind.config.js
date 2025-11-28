/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'mortal-dark': '#1a1a1a',
        'mortal-darker': '#0f0f0f',
        'mortal-accent': '#3a3a3a',
        'mortal-gold': '#d4af37',
      },
    },
  },
  plugins: [],
}

