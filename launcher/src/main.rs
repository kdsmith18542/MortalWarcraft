// Prevents additional console window on Windows in release builds
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod patcher;
mod integrity;
mod config;
mod manifest;
mod download;
mod hitbox_patcher;
mod spell_patcher;
mod talenttab_patcher;

use tauri::Manager;

fn main() {
    tauri::Builder::default()
        .setup(|app| {
            // Initialize launcher on startup
            println!("Mortal Warcraft Launcher v1.0.0");
            
            // Check for WoW client installation
            if let Some(client_path) = config::find_wow_client() {
                println!("Found WoW client at: {:?}", client_path);
                
                // Verify client integrity
                if integrity::verify_client(&client_path) {
                    println!("Client integrity verified");
                } else {
                    println!("Warning: Client integrity check failed");
                }
            } else {
                println!("Warning: WoW client not found");
            }
            
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            check_client_integrity,
            patch_dbc_files,
            patch_hitboxes,
            patch_spell_dbc,
            patch_talenttab_dbc,
            install_addons,
            sync_manifest,
            inject_config,
            get_client_path,
            launch_game,
            download_client,
            get_download_progress
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}

// Tauri commands
#[tauri::command]
fn check_client_integrity(client_path: String) -> Result<bool, String> {
    integrity::verify_client(&std::path::PathBuf::from(client_path))
        .then_some(true)
        .ok_or_else(|| "Client integrity check failed".to_string())
}

#[tauri::command]
fn patch_dbc_files(client_path: String) -> Result<String, String> {
    patcher::patch_all_dbc(&std::path::PathBuf::from(client_path))
        .map(|count| format!("Patched {} DBC files", count))
        .map_err(|e| format!("Failed to patch DBC files: {}", e))
}

#[tauri::command]
fn patch_hitboxes(client_path: String) -> Result<String, String> {
    hitbox_patcher::patch_hitboxes(&std::path::PathBuf::from(client_path))
        .map(|count| format!("Patched hitboxes in {} DBC files", count))
        .map_err(|e| format!("Failed to patch hitboxes: {}", e))
}

#[tauri::command]
fn patch_spell_dbc(client_path: String) -> Result<String, String> {
    spell_patcher::patch_spell_dbc(&std::path::PathBuf::from(client_path))
        .map(|count| format!("Prepared Spell.dbc for {} custom spells", count))
        .map_err(|e| format!("Failed to patch Spell.dbc: {}", e))
}

#[tauri::command]
fn patch_talenttab_dbc(client_path: String) -> Result<String, String> {
    talenttab_patcher::patch_talenttab_dbc(&std::path::PathBuf::from(client_path))
        .map(|count| format!("Prepared TalentTab.dbc for {} mastery trees", count))
        .map_err(|e| format!("Failed to patch TalentTab.dbc: {}", e))
}

#[tauri::command]
fn install_addons(client_path: String) -> Result<String, String> {
    let addon_path = std::path::PathBuf::from(client_path).join("Interface/AddOns");
    patcher::install_addon_pack(&addon_path)
        .map(|count| format!("Installed {} addons", count))
        .map_err(|e| format!("Failed to install addons: {}", e))
}

#[tauri::command]
fn sync_manifest(server_url: String) -> Result<manifest::Manifest, String> {
    manifest::download_manifest(&server_url)
}

#[tauri::command]
fn inject_config(client_path: String, server_ip: String, server_port: u16) -> Result<(), String> {
    config::inject_realmlist(&std::path::PathBuf::from(client_path), &server_ip, server_port)
}

#[tauri::command]
fn get_client_path() -> Option<String> {
    config::find_wow_client()
        .map(|p| p.to_string_lossy().to_string())
}

#[tauri::command]
fn launch_game(client_path: String) -> Result<String, String> {
    use std::process::Command;
    
    let wow_exe = std::path::PathBuf::from(&client_path).join("Wow.exe");
    if !wow_exe.exists() {
        // Try WowClassic.exe
        let wow_classic = std::path::PathBuf::from(&client_path).join("WowClassic.exe");
        if wow_classic.exists() {
            Command::new(&wow_classic)
                .current_dir(&client_path)
                .spawn()
                .map_err(|e| format!("Failed to launch game: {}", e))?;
            return Ok("Game launched".to_string());
        }
        return Err("Wow.exe or WowClassic.exe not found".to_string());
    }
    
    Command::new(&wow_exe)
        .current_dir(&client_path)
        .spawn()
        .map_err(|e| format!("Failed to launch game: {}", e))?;
    
    Ok("Game launched".to_string())
}

#[tauri::command]
fn download_client(
    window: tauri::Window,
    server_url: String,
    target_path: String,
) -> Result<String, String> {
    use std::thread;
    use std::sync::Arc;
    
    let target = std::path::PathBuf::from(target_path);
    let downloader = Arc::new(download::ClientDownloader::new(server_url.clone(), target));
    let downloader_clone = downloader.clone();
    
    let manifest_url = format!("{}/client/manifest.json", server_url);
    let window_clone = window.clone();
    
    // Download in background thread with progress updates
    thread::spawn(move || {
        let mut last_progress = 0u64;
        let mut last_file = String::new();
        
        // Progress update loop
        let progress_updater = downloader.clone();
        let window_progress = window_clone.clone();
        let progress_thread = thread::spawn(move || {
            loop {
                std::thread::sleep(std::time::Duration::from_millis(500));
                let progress = progress_updater.get_progress();
                
                if progress.current != last_progress || progress.file_name != last_file {
                    let percent = if progress.total > 0 {
                        (progress.current as f64 / progress.total as f64) * 100.0
                    } else {
                        0.0
                    };
                    
                    let _ = window_progress.emit("download-progress", serde_json::json!({
                        "file": progress.file_name,
                        "current": progress.current,
                        "total": progress.total,
                        "percent": percent
                    }));
                    
                    last_progress = progress.current;
                    last_file = progress.file_name.clone();
                }
            }
        });
        
        // Perform download
        let result = downloader_clone.download_client(&manifest_url);
        
        // Stop progress thread (in a real implementation, use a channel or flag)
        drop(progress_thread);
        
        match result {
            Ok(_) => {
                let _ = window_clone.emit("download-complete", "Client download complete");
            }
            Err(e) => {
                let _ = window_clone.emit("download-error", e);
            }
        }
    });
    
    Ok("Download started".to_string())
}

#[tauri::command]
fn get_download_progress() -> Result<download::DownloadProgress, String> {
    // Progress is now tracked via events
    // This function kept for compatibility
    Ok(download::DownloadProgress {
        current: 0,
        total: 0,
        file_name: String::new(),
    })
}

