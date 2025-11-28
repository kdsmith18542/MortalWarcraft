import { useEffect, useState } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import apiClient from '../lib/apiClient'

interface WikiPage {
  id: number
  slug: string
  title: string
  summary?: string
  content_markdown: string
  category: string
  tags?: string[]
  icon?: string
  visibility: string
  created_at: string
  updated_at: string
}

interface WikiPageListResponse {
  pages: WikiPage[]
  total: number
  page: number
  page_size: number
}

export default function Wiki() {
  const { slug } = useParams()
  const [searchParams, setSearchParams] = useSearchParams()
  const [pages, setPages] = useState<WikiPage[]>([])
  const [selectedPage, setSelectedPage] = useState<WikiPage | null>(null)
  const [loading, setLoading] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedCategory, setSelectedCategory] = useState('')
  const [page, setPage] = useState(1)
  const [total, setTotal] = useState(0)

  const categories = ['mechanics', 'lore', 'locations', 'builds', 'dev', 'general']

  useEffect(() => {
    if (slug) {
      fetchPage(slug)
    } else {
      fetchPages()
    }
  }, [slug, page, selectedCategory, searchQuery])

  const fetchPages = async () => {
    setLoading(true)
    try {
      const params = new URLSearchParams({
        page: page.toString(),
        page_size: '20',
      })
      if (selectedCategory) params.append('category', selectedCategory)
      if (searchQuery) params.append('search', searchQuery)

      const res = await apiClient.get(`/wiki/pages?${params}`)
      const data: WikiPageListResponse = res.data
      setPages(data.pages)
      setTotal(data.total)
    } catch (err) {
      console.error('Failed to fetch wiki pages:', err)
    } finally {
      setLoading(false)
    }
  }

  const fetchPage = async (pageSlug: string) => {
    setLoading(true)
    try {
      const res = await apiClient.get(`/wiki/pages/${pageSlug}`)
      setSelectedPage(res.data)
    } catch (err) {
      console.error('Failed to fetch wiki page:', err)
      setSelectedPage(null)
    } finally {
      setLoading(false)
    }
  }

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    setPage(1)
    fetchPages()
  }

  const renderMarkdown = (markdown: string) => {
    // Simple markdown rendering (in production, use a proper markdown library)
    return markdown
      .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
      .replace(/\*(.*?)\*/g, '<em>$1</em>')
      .replace(/`(.*?)`/g, '<code>$1</code>')
      .replace(/\n/g, '<br />')
  }

  if (loading && !selectedPage) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading wiki...</div>
      </div>
    )
  }

  if (slug && selectedPage) {
    return (
      <div className="px-4 py-6 max-w-4xl mx-auto">
        <Link to="/wiki" className="text-blue-400 hover:text-blue-300 mb-4 inline-block">
          ← Back to Wiki
        </Link>
        <article className="bg-mortal-dark rounded-lg border border-mortal-accent p-6">
          <header className="mb-6">
            <h1 className="text-4xl font-bold mb-2">{selectedPage.title}</h1>
            {selectedPage.summary && (
              <p className="text-gray-400 text-lg">{selectedPage.summary}</p>
            )}
            <div className="flex items-center gap-4 mt-4 text-sm text-gray-500">
              <span className="bg-mortal-accent px-2 py-1 rounded">{selectedPage.category}</span>
              {selectedPage.tags && selectedPage.tags.length > 0 && (
                <div className="flex gap-2">
                  {selectedPage.tags.map((tag, i) => (
                    <span key={i} className="bg-gray-700 px-2 py-1 rounded">
                      {tag}
                    </span>
                  ))}
                </div>
              )}
              <span>Updated {new Date(selectedPage.updated_at).toLocaleDateString()}</span>
            </div>
          </header>
          <div
            className="prose prose-invert max-w-none"
            dangerouslySetInnerHTML={{ __html: renderMarkdown(selectedPage.content_markdown) }}
          />
        </article>
      </div>
    )
  }

  return (
    <div className="px-4 py-6">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-3xl font-bold mb-6">Mortal Warcraft Wiki</h1>

        {/* Search and Filters */}
        <div className="bg-mortal-dark rounded-lg border border-mortal-accent p-4 mb-6">
          <form onSubmit={handleSearch} className="flex gap-4 mb-4">
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search wiki..."
              className="flex-1 bg-mortal-darker border border-mortal-accent rounded px-4 py-2 text-white"
            />
            <button
              type="submit"
              className="bg-blue-600 hover:bg-blue-700 px-6 py-2 rounded font-semibold"
            >
              Search
            </button>
          </form>
          <div className="flex gap-2 flex-wrap">
            <button
              onClick={() => {
                setSelectedCategory('')
                setPage(1)
              }}
              className={`px-3 py-1 rounded ${
                selectedCategory === ''
                  ? 'bg-blue-600 text-white'
                  : 'bg-mortal-darker text-gray-300'
              }`}
            >
              All
            </button>
            {categories.map((cat) => (
              <button
                key={cat}
                onClick={() => {
                  setSelectedCategory(cat)
                  setPage(1)
                }}
                className={`px-3 py-1 rounded capitalize ${
                  selectedCategory === cat
                    ? 'bg-blue-600 text-white'
                    : 'bg-mortal-darker text-gray-300'
                }`}
              >
                {cat}
              </button>
            ))}
          </div>
        </div>

        {/* Page List */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {pages.length === 0 ? (
            <div className="col-span-full text-center py-12 text-gray-400">
              No pages found
            </div>
          ) : (
            pages.map((page) => (
              <Link
                key={page.id}
                to={`/wiki/${page.slug}`}
                className="bg-mortal-dark rounded-lg border border-mortal-accent p-4 hover:border-blue-500 transition-colors"
              >
                <h3 className="text-xl font-semibold mb-2">{page.title}</h3>
                {page.summary && (
                  <p className="text-gray-400 text-sm mb-3 line-clamp-2">{page.summary}</p>
                )}
                <div className="flex items-center gap-2 text-xs text-gray-500">
                  <span className="bg-mortal-accent px-2 py-0.5 rounded">{page.category}</span>
                  <span>{new Date(page.updated_at).toLocaleDateString()}</span>
                </div>
              </Link>
            ))
          )}
        </div>

        {/* Pagination */}
        {total > 20 && (
          <div className="mt-6 flex justify-center gap-2">
            <button
              onClick={() => setPage(Math.max(1, page - 1))}
              disabled={page === 1}
              className="px-4 py-2 bg-mortal-darker rounded disabled:opacity-50"
            >
              Previous
            </button>
            <span className="px-4 py-2">
              Page {page} of {Math.ceil(total / 20)}
            </span>
            <button
              onClick={() => setPage(page + 1)}
              disabled={page >= Math.ceil(total / 20)}
              className="px-4 py-2 bg-mortal-darker rounded disabled:opacity-50"
            >
              Next
            </button>
          </div>
        )}
      </div>
    </div>
  )
}

