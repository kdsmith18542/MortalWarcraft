import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';

interface GuildRelation {
  guild_id: number;
  guild_name: string;
  relation_type: 'alliance' | 'war' | 'truce';
  start_time: number;
  end_time: number;
  initiator_guild_id: number;
}

interface GuildPolitics {
  guild_id: number;
  guild_name: string;
  allies: GuildRelation[];
  wars: GuildRelation[];
  truces: GuildRelation[];
}

const GuildPoliticsPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [politics, setPolitics] = useState<GuildPolitics | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchPolitics = async () => {
      try {
        const response = await fetch(`/api/v1/politics/guild/${id}`);
        if (!response.ok) {
          throw new Error('Failed to fetch guild politics');
        }
        const data = await response.json();
        setPolitics(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Unknown error');
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      fetchPolitics();
    }
  }, [id]);

  const formatTime = (timestamp: number) => {
    if (timestamp === 0) return 'Indefinite';
    const date = new Date(timestamp * 1000);
    return date.toLocaleDateString();
  };

  const formatTimeRemaining = (endTime: number) => {
    if (endTime === 0) return null;
    const now = Math.floor(Date.now() / 1000);
    const remaining = endTime - now;
    if (remaining <= 0) return 'Expired';
    
    const days = Math.floor(remaining / 86400);
    const hours = Math.floor((remaining % 86400) / 3600);
    const minutes = Math.floor((remaining % 3600) / 60);
    
    if (days > 0) return `${days}d ${hours}h`;
    if (hours > 0) return `${hours}h ${minutes}m`;
    return `${minutes}m`;
  };

  const renderRelation = (relation: GuildRelation, type: 'alliance' | 'war' | 'truce') => {
    const colors = {
      alliance: 'text-blue-400',
      war: 'text-red-400',
      truce: 'text-yellow-400',
    };

    const icons = {
      alliance: '🤝',
      war: '⚔️',
      truce: '🕊️',
    };

    const labels = {
      alliance: 'Alliance',
      war: 'At War',
      truce: 'Truce',
    };

    return (
      <div key={relation.guild_id} className="bg-gray-800 rounded-lg p-4 mb-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <span className="text-2xl">{icons[type]}</span>
            <div>
              <Link
                to={`/guild/${relation.guild_id}`}
                className={`font-semibold ${colors[type]} hover:underline`}
              >
                {relation.guild_name}
              </Link>
              <p className="text-sm text-gray-400">{labels[type]}</p>
            </div>
          </div>
          <div className="text-right text-sm text-gray-400">
            <p>Started: {formatTime(relation.start_time)}</p>
            {relation.end_time > 0 && (
              <p>
                {formatTimeRemaining(relation.end_time) ? (
                  <>Expires: {formatTimeRemaining(relation.end_time)}</>
                ) : (
                  <>Expired</>
                )}
              </p>
            )}
          </div>
        </div>
      </div>
    );
  };

  if (loading) {
    return (
      <div className="px-4 py-6">
        <div className="text-center">Loading...</div>
      </div>
    );
  }

  if (error || !politics) {
    return (
      <div className="px-4 py-6">
        <div className="text-center text-red-400">
          {error || 'Guild not found'}
        </div>
      </div>
    );
  }

  return (
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-2">{politics.guild_name}</h1>
        <p className="text-gray-400 mb-6">Guild Relations & Politics</p>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Alliances */}
          <div className="bg-gray-900 rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4 text-blue-400">
              🤝 Alliances ({politics.allies.length})
            </h2>
            {politics.allies.length > 0 ? (
              <div>
                {politics.allies.map((ally) => renderRelation(ally, 'alliance'))}
              </div>
            ) : (
              <p className="text-gray-500">No active alliances</p>
            )}
          </div>

          {/* Wars */}
          <div className="bg-gray-900 rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4 text-red-400">
              ⚔️ Wars ({politics.wars.length})
            </h2>
            {politics.wars.length > 0 ? (
              <div>
                {politics.wars.map((war) => renderRelation(war, 'war'))}
              </div>
            ) : (
              <p className="text-gray-500">No active wars</p>
            )}
          </div>

          {/* Truces */}
          <div className="bg-gray-900 rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4 text-yellow-400">
              🕊️ Truces ({politics.truces.length})
            </h2>
            {politics.truces.length > 0 ? (
              <div>
                {politics.truces.map((truce) => renderRelation(truce, 'truce'))}
              </div>
            ) : (
              <p className="text-gray-500">No active truces</p>
            )}
          </div>
        </div>
      </div>
  );
};

export default GuildPoliticsPage;

