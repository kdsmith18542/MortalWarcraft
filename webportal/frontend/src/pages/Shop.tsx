import { useEffect, useState } from 'react'
import apiClient from '../lib/apiClient'
import { useAuthStore } from '../stores/authStore'

interface Product {
  id: number
  code: string
  name: string
  description: string
  category: string
  price_usd: number
  price_credits?: number
  is_subscription: boolean
  subscription_days?: number
}

interface Subscription {
  id: number
  product_id: number
  status: string
  started_at: string
  expires_at: string
  cancelled_at?: string
  auto_renew: boolean
  product?: Product
}

export default function Shop() {
  const [products, setProducts] = useState<Product[]>([])
  const [subscription, setSubscription] = useState<Subscription | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [selectedCategory, setSelectedCategory] = useState('')
  const { isAuthenticated } = useAuthStore()

  useEffect(() => {
    fetchProducts()
    if (isAuthenticated) {
      fetchSubscription()
    }
  }, [isAuthenticated])

  const fetchProducts = async () => {
    try {
      const params = selectedCategory ? `?category=${selectedCategory}` : ''
      const res = await apiClient.get(`/shop/products${params}`)
      setProducts(res.data.products || [])
    } catch (err: any) {
      setError(err.response?.data?.error || 'Failed to load products')
    } finally {
      setLoading(false)
    }
  }

  const fetchSubscription = async () => {
    try {
      const res = await apiClient.get('/shop/subscription')
      setSubscription(res.data.subscription)
    } catch (err) {
      // Subscription not found is OK
      setSubscription(null)
    }
  }

  const [paymentMethod, setPaymentMethod] = useState('stripe')

  const handlePurchase = async (productId: number) => {
    if (!isAuthenticated) {
      setError('Please login to make a purchase')
      return
    }

    try {
      const res = await apiClient.post('/shop/purchase', {
        product_id: productId,
        payment_method: paymentMethod,
      })
      
      if (res.data.payment_url) {
        // Redirect to payment URL if provided
        window.location.href = res.data.payment_url
      } else {
        alert('Purchase created! In production, you would be redirected to payment.')
      }
    } catch (err: any) {
      setError(err.response?.data?.error || 'Purchase failed')
    }
  }

  const handleCancelSubscription = async () => {
    if (!confirm('Are you sure you want to cancel your subscription?')) {
      return
    }

    try {
      await apiClient.post('/shop/subscription/cancel')
      alert('Subscription cancelled. It will remain active until expiration.')
      fetchSubscription()
    } catch (err: any) {
      setError(err.response?.data?.error || 'Failed to cancel subscription')
    }
  }

  const categories = ['all', 'cosmetic', 'subscription', 'boost', 'currency']
  const groupedProducts = products.reduce((acc, product) => {
    if (!acc[product.category]) {
      acc[product.category] = []
    }
    acc[product.category].push(product)
    return acc
  }, {} as Record<string, Product[]>)

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center py-12">Loading shop...</div>
      </div>
    )
  }

  return (
    <div className="px-4 py-6">
      <h1 className="text-3xl font-bold mb-6">Shop</h1>

      {error && (
        <div className="bg-red-900 bg-opacity-50 border border-red-600 rounded-lg p-4 mb-6">
          <div className="text-red-400">{error}</div>
        </div>
      )}

      {/* Active Subscription */}
      {subscription && (
        <div className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent mb-6">
          <h2 className="text-xl font-semibold mb-4">Active Subscription</h2>
          <div className="space-y-2">
            <div>
              <span className="text-gray-400">Product:</span>{' '}
              <span className="text-mortal-gold">{subscription.product?.name}</span>
            </div>
            <div>
              <span className="text-gray-400">Status:</span>{' '}
              <span className={subscription.status === 'active' ? 'text-green-400' : 'text-red-400'}>
                {subscription.status}
              </span>
            </div>
            <div>
              <span className="text-gray-400">Expires:</span>{' '}
              <span>{new Date(subscription.expires_at).toLocaleDateString()}</span>
            </div>
            {subscription.status === 'active' && (
              <button
                onClick={handleCancelSubscription}
                className="mt-4 px-4 py-2 bg-red-600 hover:bg-red-700 rounded"
              >
                Cancel Subscription
              </button>
            )}
          </div>
        </div>
      )}

      {/* Category Filter */}
      <div className="mb-6 flex gap-2 flex-wrap">
        {categories.map((cat) => (
          <button
            key={cat}
            onClick={() => {
              setSelectedCategory(cat === 'all' ? '' : cat)
              fetchProducts()
            }}
            className={`px-4 py-2 rounded ${
              (cat === 'all' && !selectedCategory) || selectedCategory === cat
                ? 'bg-mortal-accent'
                : 'bg-mortal-dark border border-mortal-accent'
            }`}
          >
            {cat.charAt(0).toUpperCase() + cat.slice(1)}
          </button>
        ))}
      </div>

      {/* Products by Category */}
      {Object.keys(groupedProducts).length === 0 ? (
        <div className="text-center py-12 text-gray-400">No products available</div>
      ) : (
        Object.entries(groupedProducts).map(([category, categoryProducts]) => (
          <div key={category} className="mb-8">
            <h2 className="text-2xl font-semibold mb-4 capitalize">{category}</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {categoryProducts.map((product) => (
                <div
                  key={product.id}
                  className="bg-mortal-dark p-6 rounded-lg border border-mortal-accent"
                >
                  <h3 className="text-xl font-semibold mb-2">{product.name}</h3>
                  <p className="text-gray-400 text-sm mb-4">{product.description}</p>
                  <div className="flex justify-between items-center mb-4">
                    <div>
                      <span className="text-2xl font-bold text-mortal-gold">
                        ${product.price_usd.toFixed(2)}
                      </span>
                      {product.price_credits && (
                        <div className="text-sm text-gray-400">
                          or {product.price_credits} credits
                        </div>
                      )}
                    </div>
                    {product.is_subscription && (
                      <div className="text-sm text-blue-400">
                        {product.subscription_days} days
                      </div>
                    )}
                  </div>
                  <div className="space-y-2">
                    <select
                      value={paymentMethod}
                      onChange={(e) => setPaymentMethod(e.target.value)}
                      className="w-full bg-mortal-darker border border-mortal-accent rounded px-3 py-2 text-white text-sm"
                    >
                      <option value="stripe">Stripe</option>
                      <option value="paypal">PayPal</option>
                      <option value="credits">Credits</option>
                    </select>
                    <button
                      onClick={() => handlePurchase(product.id)}
                      className="w-full bg-blue-600 hover:bg-blue-700 px-4 py-2 rounded"
                    >
                      Purchase
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))
      )}
    </div>
  )
}
