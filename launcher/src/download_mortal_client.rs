// ==================================================
// Project Mortal Warcraft
// Feature: Pre-Configured Client Download
// Description: Downloads fully-configured Mortal Warcraft client bundle
// ==================================================

use std::fs;
use std::path::{Path, PathBuf};
use serde::{Deserialize, Serialize};

/// Mortal Warcraft client manifest
#[derive(Debug, Deserialize, Serialize)]
pub struct MortalClientManifest {
    pub version: String,
    pub build: String,
    pub game: String,
    pub server: String,
    pub released: String,
    pub realmlist: String,
    pub required_addons: Vec<String>,
    pub optional_addons: Vec<String>,
    pub patches: PatchInfo,
    pub files: FileInfo,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct PatchInfo {
    pub dbc_patched: bool,
    pub mpq_patched: bool,
    pub auto_patch: bool,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct FileInfo {
    pub wow_exe: String,
    pub data_dir: String,
    pub addons_dir: String,
    pub wtf_dir: String,
    pub realmlist: String,
    pub config: String,
}

/// Download pre-configured Mortal Warcraft client bundle
pub fn download_mortal_client(target_dir: &Path) -> Result<(), String> {
    println!("╔══════════════════════════════════════════════════════╗");
    println!("║  Downloading Mortal Warcraft Client                  ║");
    println!("╚══════════════════════════════════════════════════════╝");
    println!();
    
    // Create target directory
    fs::create_dir_all(target_dir)
        .map_err(|e| format!("Failed to create target directory: {}", e))?;
    
    // Client download URLs (configurable via env vars)
    let client_url = std::env::var("MORTAL_CLIENT_URL")
        .unwrap_or_else(|_| {
            // Default to local bundle for testing
            "/home/keith/wowpack/gameclientfiles/mortal_client_bundle.tar.gz".to_string()
        });
    
    let manifest_url = std::env::var("MORTAL_MANIFEST_URL")
        .unwrap_or_else(|_| {
            "/home/keith/wowpack/gameclientfiles/mortal_client_bundle/mortal_manifest.json".to_string()
        });
    
    println!("📦 Source: {}", client_url);
    println!("📄 Manifest: {}", manifest_url);
    println!();
    
    // Download manifest first
    println!("1/3: Reading manifest...");
    let manifest = load_manifest(&manifest_url)?;
    println!("  ✅ Version: {}", manifest.version);
    println!("  ✅ Build: {}", manifest.build);
    println!("  ✅ Realmlist: {}", manifest.realmlist);
    println!();
    
    // Check if we're using local bundle or remote
    if client_url.starts_with("http://") || client_url.starts_with("https://") {
        // Remote download
        println!("2/3: Downloading client archive (this may take a while)...");
        download_remote_client(&client_url, target_dir)?;
    } else {
        // Local copy
        println!("2/3: Copying local client bundle...");
        copy_local_client(&client_url, target_dir)?;
    }
    
    println!("  ✅ Client files ready");
    println!();
    
    // Extract if it's an archive
    if client_url.ends_with(".tar.gz") || client_url.ends_with(".tgz") {
        println!("3/3: Extracting client...");
        extract_client_archive(target_dir)?;
        println!("  ✅ Extraction complete");
    } else {
        println!("3/3: Verifying installation...");
    }
    println!();
    
    // Verify installation
    println!("✅ Verifying installation...");
    verify_client_installation(target_dir, &manifest)?;
    
    // Apply auto-patches if needed
    if manifest.patches.auto_patch {
        println!();
        println!("🔧 Applying DBC patches...");
        apply_dbc_patches(target_dir)?;
    }
    
    println!();
    println!("╔══════════════════════════════════════════════════════╗");
    println!("║  ✅ Client Installation Complete!                    ║");
    println!("╠══════════════════════════════════════════════════════╣");
    println!("║                                                      ║");
    println!("║  📁 Installed to: {}                                  ║", truncate_string(&target_dir.display().to_string(), 35));
    println!("║  📦 Version: {}                                       ║", manifest.version);
    println!("║  🌐 Realmlist: {}                                     ║", manifest.realmlist);
    println!("║  ✅ Addons: {} required, {} optional                  ║", 
             manifest.required_addons.len(), 
             manifest.optional_addons.len());
    println!("║                                                      ║");
    println!("║  🎮 Ready to play!                                   ║");
    println!("║                                                      ║");
    println!("╚══════════════════════════════════════════════════════╝");
    
    Ok(())
}

/// Load manifest from file or URL
fn load_manifest(source: &str) -> Result<MortalClientManifest, String> {
    if source.starts_with("http://") || source.starts_with("https://") {
        // Remote manifest
        let response = reqwest::blocking::get(source)
            .map_err(|e| format!("Failed to download manifest: {}", e))?;
        
        let manifest: MortalClientManifest = response.json()
            .map_err(|e| format!("Failed to parse manifest: {}", e))?;
        
        Ok(manifest)
    } else {
        // Local manifest
        let content = fs::read_to_string(source)
            .map_err(|e| format!("Failed to read manifest: {}", e))?;
        
        let manifest: MortalClientManifest = serde_json::from_str(&content)
            .map_err(|e| format!("Failed to parse manifest: {}", e))?;
        
        Ok(manifest)
    }
}

/// Download client from remote CDN
fn download_remote_client(url: &str, target_dir: &Path) -> Result<(), String> {
    let archive_path = target_dir.join("mortal_client.tar.gz");
    
    println!("  📥 Downloading from CDN...");
    println!("  ⏳ This may take 10-30 minutes depending on your connection");
    
    let response = reqwest::blocking::get(url)
        .map_err(|e| format!("Failed to start download: {}", e))?;
    
    if !response.status().is_success() {
        return Err(format!("Download failed: HTTP {}", response.status()));
    }
    
    let total_size = response.content_length().unwrap_or(0);
    let mut downloaded: u64 = 0;
    let mut file = fs::File::create(&archive_path)
        .map_err(|e| format!("Failed to create file: {}", e))?;
    
    use std::io::{Read, Write};
    let mut stream = response;
    let mut buffer = vec![0u8; 8192];
    let mut last_print = 0;
    
    loop {
        let bytes_read = stream.read(&mut buffer)
            .map_err(|e| format!("Download error: {}", e))?;
        
        if bytes_read == 0 {
            break;
        }
        
        file.write_all(&buffer[..bytes_read])
            .map_err(|e| format!("Write error: {}", e))?;
        
        downloaded += bytes_read as u64;
        
        // Print progress every 5%
        let progress = (downloaded as f64 / total_size as f64 * 100.0) as u64;
        if progress >= last_print + 5 {
            println!("    {}% ({} MB / {} MB)", 
                     progress, 
                     downloaded / 1024 / 1024,
                     total_size / 1024 / 1024);
            last_print = progress;
        }
    }
    
    Ok(())
}

/// Copy client from local bundle
fn copy_local_client(source: &str, target_dir: &Path) -> Result<(), String> {
    let source_path = PathBuf::from(source);
    
    if !source_path.exists() {
        return Err(format!("Local client bundle not found: {}", source));
    }
    
    if source_path.is_dir() {
        // Copy directory
        println!("  📁 Copying directory...");
        copy_dir_all(&source_path, target_dir)
            .map_err(|e| format!("Failed to copy directory: {}", e))?;
    } else {
        // Copy archive file
        println!("  📦 Copying archive...");
        let dest = target_dir.join(source_path.file_name().unwrap());
        fs::copy(&source_path, &dest)
            .map_err(|e| format!("Failed to copy file: {}", e))?;
    }
    
    Ok(())
}

/// Extract client archive
fn extract_client_archive(target_dir: &Path) -> Result<(), String> {
    let archive_path = target_dir.join("mortal_client.tar.gz");
    
    if !archive_path.exists() {
        // Maybe it's already extracted
        return Ok(());
    }
    
    use flate2::read::GzDecoder;
    use tar::Archive;
    
    let file = fs::File::open(&archive_path)
        .map_err(|e| format!("Failed to open archive: {}", e))?;
    
    let decoder = GzDecoder::new(file);
    let mut archive = Archive::new(decoder);
    
    archive.unpack(target_dir)
        .map_err(|e| format!("Failed to extract archive: {}", e))?;
    
    // Clean up archive
    let _ = fs::remove_file(&archive_path);
    
    Ok(())
}

/// Verify client installation
fn verify_client_installation(client_dir: &Path, manifest: &MortalClientManifest) -> Result<(), String> {
    // Check required files
    let required_paths = vec![
        &manifest.files.data_dir,
        &manifest.files.addons_dir,
        &manifest.files.realmlist,
    ];
    
    for file_path in required_paths {
        let full_path = client_dir.join(file_path);
        if !full_path.exists() {
            return Err(format!("Missing required path: {}", file_path));
        }
    }
    
    // Verify required addons
    for addon in &manifest.required_addons {
        let addon_path = client_dir.join(&manifest.files.addons_dir).join(addon);
        if !addon_path.exists() {
            return Err(format!("Missing required addon: {}", addon));
        }
    }
    
    println!("  ✅ All required files present");
    println!("  ✅ All required addons installed");
    println!("  ✅ Realmlist configured");
    
    Ok(())
}

/// Apply DBC patches if needed
fn apply_dbc_patches(client_dir: &Path) -> Result<(), String> {
    let patch_marker = client_dir.join("Data/.mortal_patch_required");
    
    if !patch_marker.exists() {
        println!("  ℹ️  No patching required (pre-patched)");
        return Ok(());
    }
    
    println!("  🔧 Applying DBC patches...");
    
    // Apply hitbox patches
    let dbc_dir = client_dir.join("Data/dbc");
    if dbc_dir.exists() {
        crate::hitbox_patcher::patch_hitboxes(&dbc_dir)?;
        println!("  ✅ Hitbox patches applied");
    }
    
    // Remove marker
    let _ = fs::remove_file(&patch_marker);
    println!("  ✅ Patching complete");
    
    Ok(())
}

/// Recursively copy directory
fn copy_dir_all(src: &Path, dst: &Path) -> std::io::Result<()> {
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

/// Truncate string for display
fn truncate_string(s: &str, max_len: usize) -> String {
    if s.len() <= max_len {
        s.to_string()
    } else {
        format!("...{}", &s[s.len() - (max_len - 3)..])
    }
}

