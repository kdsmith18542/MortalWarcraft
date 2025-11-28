use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Manifest {
    pub version: String,
    pub files: Vec<ManifestFile>,
    pub patches: Vec<PatchInfo>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ManifestFile {
    pub path: String,
    pub checksum: String,
    pub size: u64,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct PatchInfo {
    pub name: String,
    pub version: String,
    pub url: String,
    pub checksum: String,
    pub required: bool,
}

/// Download manifest from server
pub fn download_manifest(server_url: &str) -> Result<Manifest, String> {
    let url = format!("{}/api/manifest", server_url);
    
    // Download manifest from server using reqwest
    let response = reqwest::blocking::get(&url)
        .map_err(|e| format!("Failed to download manifest from {}: {}", url, e))?;
    
    if !response.status().is_success() {
        return Err(format!("Server returned error: {}", response.status()));
    }
    
    let manifest: Manifest = response.json()
        .map_err(|e| format!("Failed to parse manifest JSON: {}", e))?;
    
    println!("✅ Downloaded manifest version {}", manifest.version);
    println!("   Files: {}", manifest.files.len());
    println!("   Patches: {}", manifest.patches.len());
    
    Ok(manifest)
}

/// Verify client files against manifest
pub fn verify_client_files(client_path: &std::path::Path, manifest: &Manifest) -> Vec<String> {
    let mut missing_files = Vec::new();
    
    for file in &manifest.files {
        let file_path = client_path.join(&file.path);
        if !file_path.exists() {
            missing_files.push(file.path.clone());
        }
    }
    
    missing_files
}

