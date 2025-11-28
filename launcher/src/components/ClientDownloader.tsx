import React, { useState, useEffect } from 'react';
import { invoke } from '@tauri-apps/api/tauri';
import { listen } from '@tauri-apps/api/event';

interface DownloadProgress {
  file: string;
  current: number;
  total: number;
  percent: number;
}

interface DownloadStatus {
  status: string;
  file: string;
  current: number;
  total: number;
}

export const ClientDownloader: React.FC = () => {
  const [downloading, setDownloading] = useState(false);
  const [progress, setProgress] = useState<DownloadProgress | null>(null);
  const [status, setStatus] = useState<string>('');
  const [error, setError] = useState<string>('');

  useEffect(() => {
    // Listen for download progress events
    const progressListener = listen<DownloadProgress>('download-progress', (event) => {
      setProgress(event.payload);
    });

    const statusListener = listen<DownloadStatus>('download-status', (event) => {
      setStatus(`Downloading ${event.payload.file} (${event.payload.current}/${event.payload.total})`);
    });

    const completeListener = listen<string>('download-complete', (event) => {
      setDownloading(false);
      setStatus('Download complete!');
      setProgress(null);
    });

    const errorListener = listen<string>('download-error', (event) => {
      setDownloading(false);
      setError(event.payload);
      setProgress(null);
    });

    return () => {
      progressListener.then(unlisten => unlisten());
      statusListener.then(unlisten => unlisten());
      completeListener.then(unlisten => unlisten());
      errorListener.then(unlisten => unlisten());
    };
  }, []);

  const handleDownload = async () => {
    setDownloading(true);
    setError('');
    setStatus('Starting download...');
    setProgress(null);

    try {
      const serverUrl = 'http://localhost:8080'; // Default server URL
      const targetPath = await invoke<string>('get_client_path') || './gameclientfiles/World of Warcraft - WoTLK';
      
      await invoke('download_client', {
        serverUrl,
        targetPath,
      });
    } catch (err) {
      setError(err as string);
      setDownloading(false);
    }
  };

  return (
    <div className="client-downloader">
      <h2>Client Download</h2>
      
      {error && (
        <div className="error-message" style={{ color: 'red', marginBottom: '1rem' }}>
          {error}
        </div>
      )}

      {status && (
        <div className="status-message" style={{ marginBottom: '1rem' }}>
          {status}
        </div>
      )}

      {progress && (
        <div className="progress-container" style={{ marginBottom: '1rem' }}>
          <div className="progress-bar" style={{ 
            width: '100%', 
            height: '20px', 
            backgroundColor: '#333',
            borderRadius: '4px',
            overflow: 'hidden'
          }}>
            <div style={{
              width: `${progress.percent}%`,
              height: '100%',
              backgroundColor: '#4CAF50',
              transition: 'width 0.3s'
            }} />
          </div>
          <div style={{ marginTop: '0.5rem', fontSize: '0.9rem' }}>
            {progress.file}: {Math.round(progress.percent)}% ({formatBytes(progress.current)} / {formatBytes(progress.total)})
          </div>
        </div>
      )}

      <button
        onClick={handleDownload}
        disabled={downloading}
        style={{
          padding: '0.75rem 1.5rem',
          fontSize: '1rem',
          backgroundColor: downloading ? '#666' : '#4CAF50',
          color: 'white',
          border: 'none',
          borderRadius: '4px',
          cursor: downloading ? 'not-allowed' : 'pointer'
        }}
      >
        {downloading ? 'Downloading...' : 'Download Client'}
      </button>
    </div>
  );
};

function formatBytes(bytes: number): string {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

