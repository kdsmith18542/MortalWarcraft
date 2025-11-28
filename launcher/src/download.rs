// ==================================================
// Project Mortal Warcraft
// Feature: Client Streaming Download
// Description: Downloads and streams WoW 3.3.5a client files
// ==================================================

use std::fs;
use std::io::{self, Read, Write};
use std::path::{Path, PathBuf};
use std::sync::{Arc, Mutex};
use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize)]
pub struct DownloadProgress {
    pub current: u64,
    pub total: u64,
    pub file_name: String,
}

pub struct ClientDownloader {
    base_url: String,
    target_path: PathBuf,
    progress: Arc<Mutex<DownloadProgress>>,
}

impl ClientDownloader {
    pub fn new(base_url: String, target_path: PathBuf) -> Self {
        Self {
            base_url,
            target_path,
            progress: Arc::new(Mutex::new(DownloadProgress {
                current: 0,
                total: 0,
                file_name: String::new(),
            })),
        }
    }

    /// Download a single file with progress tracking
    pub fn download_file(
        &self,
        relative_path: &str,
    ) -> Result<(), String> {
        let url = format!("{}/{}", self.base_url, relative_path);
        let file_path = self.target_path.join(relative_path);
        
        // Create parent directories
        if let Some(parent) = file_path.parent() {
            fs::create_dir_all(parent)
                .map_err(|e| format!("Failed to create directory: {}", e))?;
        }

        // Download file
        let response = reqwest::blocking::get(&url)
            .map_err(|e| format!("Failed to download {}: {}", url, e))?;

        let total_size = response.content_length().unwrap_or(0);
        let mut file = fs::File::create(&file_path)
            .map_err(|e| format!("Failed to create file: {}", e))?;

        let mut downloaded: u64 = 0;
        let mut stream = response;

        // Update progress
        {
            let mut progress = self.progress.lock().unwrap();
            progress.file_name = relative_path.to_string();
            progress.total = total_size;
        }

        // Stream download with progress updates
        let mut buffer = vec![0u8; 8192];
        loop {
            let bytes_read = stream.read(&mut buffer)
                .map_err(|e| format!("Read error: {}", e))?;
            
            if bytes_read == 0 {
                break;
            }

            file.write_all(&buffer[..bytes_read])
                .map_err(|e| format!("Write error: {}", e))?;

            downloaded += bytes_read as u64;

            // Update progress
            {
                let mut progress = self.progress.lock().unwrap();
                progress.current = downloaded;
            }

            // Progress is tracked in self.progress
        }

        Ok(())
    }

    /// Download client manifest and all files
    pub fn download_client(
        &self,
        manifest_url: &str,
    ) -> Result<(), String> {
        // Download manifest
        let manifest_response = reqwest::blocking::get(manifest_url)
            .map_err(|e| format!("Failed to download manifest: {}", e))?;

        let manifest: ClientManifest = manifest_response
            .json()
            .map_err(|e| format!("Failed to parse manifest: {}", e))?;

        // Download all files
        let total_files = manifest.files.len();
        for (index, file_entry) in manifest.files.iter().enumerate() {
            self.download_file(&file_entry.path)
                .map_err(|e| format!("Failed to download {}: {}", file_entry.path, e))?;
        }

        // Write realmlist
        self.write_realmlist("127.0.0.1", 8085)?;

        // Install addons
        self.install_addons()?;

        Ok(())
    }

    /// Write realmlist.wtf file
    fn write_realmlist(&self, ip: &str, port: u16) -> Result<(), String> {
        let realmlist_path = self.target_path
            .join("Data")
            .join("enGB")
            .join("realmlist.wtf");

        // Create directory if needed
        if let Some(parent) = realmlist_path.parent() {
            fs::create_dir_all(parent)
                .map_err(|e| format!("Failed to create directory: {}", e))?;
        }

        let content = format!("set realmlist {}:{}", ip, port);
        fs::write(&realmlist_path, content)
            .map_err(|e| format!("Failed to write realmlist: {}", e))?;

        Ok(())
    }

    /// Install MortalUI addon
    fn install_addons(&self) -> Result<(), String> {
        let addon_source = PathBuf::from("addons/MortalUI");
        let addon_dest = self.target_path
            .join("Interface")
            .join("AddOns")
            .join("MortalUI");

        if !addon_source.exists() {
            return Err("MortalUI addon not found in addons/ directory".to_string());
        }

        // Copy addon directory
        copy_dir_all(&addon_source, &addon_dest)
            .map_err(|e| format!("Failed to copy addon: {}", e))?;

        Ok(())
    }

    pub fn get_progress(&self) -> DownloadProgress {
        self.progress.lock().unwrap().clone()
    }
    
    pub fn base_url(&self) -> &str {
        &self.base_url
    }
}

#[derive(Deserialize)]
struct ClientManifest {
    version: String,
    files: Vec<FileEntry>,
}

#[derive(Deserialize)]
struct FileEntry {
    path: String,
    size: u64,
    hash: String,
}

/// Recursively copy directory
fn copy_dir_all(src: &Path, dst: &Path) -> io::Result<()> {
    fs::create_dir_all(dst)?;
    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let ty = entry.file_type()?;
        let src_path = entry.path();
        let dst_path = dst.join(entry.file_name());

        if ty.is_dir() {
            copy_dir_all(&src_path, &dst_path)?;
        } else {
            fs::copy(&src_path, &dst_path)?;
        }
    }
    Ok(())
}

