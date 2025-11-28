import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import apiClient from '../lib/apiClient'

interface MarketItem {
  item_entry: number
  item_name: string
  seller_name: string
  location: string
  zone_id: number
  price: number
  stock: number
  is_red_zone: boolean
}

interface ArbitrageOpportunity {
  item_entry: number
  item_name: string
  buy_location: string
  buy_price: number
  sell_location: string
  sell_price: number
  profit: number
  risk_level: string
}

export default function Market() {
  const [items, setItems] = useState<MarketItem[]>([])
  const [arbitrage, setArbitrage] = useState<ArbitrageOpportunity[]>([])
  const [loading, setLoading] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedZone, setSelectedZone] = useState('')
  const [activeTab, setActiveTab] = useState<'items' | 'arbitrage'>('items')

  useEffect(() => {
    if (activeTab === 'items') {
      fetchItems()
    } else {
      fetchArbitrage()
    }
  }, [activeTab, searchQuery, selectedZone])

  const fetchItems = async () => {
    setLoading(true)
    try {
      const params = new URLSearchParams()
      if (searchQuery) params.append('q', searchQuery)
      if (selectedZone) params.append('zone_id', selectedZone)

      const res = await apiClient.get(`/market/search?${params}`)
      setItems(res.data.items || [])
    } catch (err) {
      console.error('Failed to fetch market items:', err)
    } finally {
      setLoading(false)
    }
  }

  const fetchArbitrage = async () => {
    setLoading(true)
    try {
      const res = await apiClient.get('/market/arbitrage')
      setArbitrage(res.data.opportunities || [])
    } catch (err) {
      console.error('Failed to fetch arbitrage:', err)
    } finally {
      setLoading(false)
    }
  }

  const formatGold = (copper: number) => {
    const gold = Math.floor(copper / 10000)
    const silver = Math.floor((copper % 10000) / 100)
    const copperRemainder = copper % 100
    return `${gold}g ${silver}s ${copperRemainder}c`
  }

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    fetchItems()
  }

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading market data...</div>
      </div>
    )
  }

  return (
    <div className="px-4 py-6">
      <h1 className="text-3xl font-bold mb-6">Market Tracker</h1>

      {/* Tabs */}
      <div className="flex gap-4 mb-6 border-b border-mortal-accent">
        <button
          onClick={() => setActiveTab('items')}
          className={`px-4 py-2 font-semibold ${
            activeTab === 'items'
              ? 'border-b-2 border-blue-500 text-blue-400'
              : 'text-gray-400'
          }`}
        >
          Market Items
        </button>
        <button
          onClick={() => setActiveTab('arbitrage')}
          className={`px-4 py-2 font-semibold ${
            activeTab === 'arbitrage'
              ? 'border-b-2 border-blue-500 text-blue-400'
              : 'text-gray-400'
          }`}
        >
          Arbitrage Opportunities
        </button>
      </div>

      {activeTab === 'items' ? (
        <>
          {/* Search */}
          <form onSubmit={handleSearch} className="mb-6">
            <div className="flex gap-4">
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search items or sellers..."
                className="flex-1 bg-mortal-darker border border-mortal-accent rounded px-4 py-2 text-white"
              />
              <button
                type="submit"
                className="bg-blue-600 hover:bg-blue-700 px-6 py-2 rounded font-semibold"
              >
                Search
              </button>
            </div>
          </form>

          {/* Items Table */}
          <div className="bg-mortal-dark rounded-lg border border-mortal-accent overflow-hidden">
            <div className="bg-mortal-accent px-4 py-2 font-semibold">
              Market Items ({items.length})
            </div>
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-mortal-darker">
                  <tr>
                    <th className="px-4 py-2 text-left">Item</th>
                    <th className="px-4 py-2 text-left">Seller</th>
                    <th className="px-4 py-2 text-left">Location</th>
                    <th className="px-4 py-2 text-right">Price</th>
                    <th className="px-4 py-2 text-right">Stock</th>
                    <th className="px-4 py-2 text-center">Zone</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-mortal-accent">
                  {items.length === 0 ? (
                    <tr>
                      <td colSpan={6} className="px-4 py-8 text-center text-gray-400">
                        No items found
                      </td>
                    </tr>
                  ) : (
                    items.map((item, idx) => (
                      <tr key={idx} className="hover:bg-mortal-darker">
                        <td className="px-4 py-2">
                          <Link
                            to={`/character/${item.seller_name}`}
                            className="text-blue-400 hover:text-blue-300"
                          >
                            {item.item_name}
                          </Link>
                        </td>
                        <td className="px-4 py-2">{item.seller_name}</td>
                        <td className="px-4 py-2">{item.location}</td>
                        <td className="px-4 py-2 text-right">{formatGold(item.price)}</td>
                        <td className="px-4 py-2 text-right">{item.stock}</td>
                        <td className="px-4 py-2 text-center">
                          {item.is_red_zone ? (
                            <span className="text-red-400 font-semibold">Red</span>
                          ) : (
                            <span className="text-green-400">Safe</span>
                          )}
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </>
      ) : (
        <>
          {/* Arbitrage Opportunities */}
          <div className="bg-mortal-dark rounded-lg border border-mortal-accent overflow-hidden">
            <div className="bg-mortal-accent px-4 py-2 font-semibold">
              Arbitrage Opportunities ({arbitrage.length})
            </div>
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-mortal-darker">
                  <tr>
                    <th className="px-4 py-2 text-left">Item</th>
                    <th className="px-4 py-2 text-left">Buy Location</th>
                    <th className="px-4 py-2 text-right">Buy Price</th>
                    <th className="px-4 py-2 text-left">Sell Location</th>
                    <th className="px-4 py-2 text-right">Sell Price</th>
                    <th className="px-4 py-2 text-right">Profit</th>
                    <th className="px-4 py-2 text-center">Risk</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-mortal-accent">
                  {arbitrage.length === 0 ? (
                    <tr>
                      <td colSpan={7} className="px-4 py-8 text-center text-gray-400">
                        No arbitrage opportunities found
                      </td>
                    </tr>
                  ) : (
                    arbitrage.map((opp, idx) => (
                      <tr key={idx} className="hover:bg-mortal-darker">
                        <td className="px-4 py-2">{opp.item_name}</td>
                        <td className="px-4 py-2">{opp.buy_location}</td>
                        <td className="px-4 py-2 text-right">{formatGold(opp.buy_price)}</td>
                        <td className="px-4 py-2">{opp.sell_location}</td>
                        <td className="px-4 py-2 text-right">{formatGold(opp.sell_price)}</td>
                        <td className="px-4 py-2 text-right text-green-400 font-semibold">
                          {formatGold(opp.profit)}
                        </td>
                        <td className="px-4 py-2 text-center">
                          <span
                            className={`px-2 py-1 rounded text-xs font-semibold ${
                              opp.risk_level === 'high'
                                ? 'bg-red-600'
                                : opp.risk_level === 'medium'
                                ? 'bg-yellow-600'
                                : 'bg-green-600'
                            }`}
                          >
                            {opp.risk_level.toUpperCase()}
                          </span>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </>
      )}
    </div>
  )
}
