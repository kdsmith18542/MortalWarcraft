use std::path::{Path, PathBuf};
use std::fs;
use std::io::Write;

/// Find WoW client installation
pub fn find_wow_client() -> Option<PathBuf> {
    // Check local gameclientfiles directory first
    let local_client = PathBuf::from("gameclientfiles/World of Warcraft - WoTLK");
    if local_client.join("Wow.exe").exists() || local_client.join("WowClassic.exe").exists() {
        return Some(local_client);
    }
    
    // Common installation paths
    let common_paths = vec![
        // Windows
        PathBuf::from("C:/Program Files/World of Warcraft"),
        PathBuf::from("C:/Program Files (x86)/World of Warcraft"),
        PathBuf::from("D:/World of Warcraft"),
        // Linux (Wine)
        PathBuf::from(std::env::var("HOME").unwrap_or_default() + "/.wine/drive_c/Program Files/World of Warcraft"),
        // macOS
        PathBuf::from("/Applications/World of Warcraft"),
    ];
    
    for path in common_paths {
        if path.join("Wow.exe").exists() || path.join("WowClassic.exe").exists() {
            return Some(path);
        }
    }
    
    // Try to find from registry or environment variable
    if let Ok(wow_path) = std::env::var("WOW_PATH") {
        let path = PathBuf::from(wow_path);
        if path.join("Wow.exe").exists() || path.join("WowClassic.exe").exists() {
            return Some(path);
        }
    }
    
    None
}

/// Inject realmlist configuration
pub fn inject_realmlist(client_path: &Path, server_ip: &str, server_port: u16) -> Result<(), String> {
    // Try multiple realmlist locations
    let realmlist_paths = vec![
        client_path.join("Data").join("enGB").join("realmlist.wtf"),
        client_path.join("Data").join("enUS").join("realmlist.wtf"),
        client_path.join("realmlist.wtf"),
        client_path.join("WTF").join("realmlist.wtf"),
    ];
    
    let realmlist_content = format!("set realmlist {}:{}", server_ip, server_port);
    
    for realmlist_path in realmlist_paths {
        if let Some(parent) = realmlist_path.parent() {
            std::fs::create_dir_all(parent)
                .map_err(|e| format!("Failed to create directory: {}", e))?;
        }
        
        std::fs::write(&realmlist_path, &realmlist_content)
            .map_err(|e| format!("Failed to write realmlist to {:?}: {}", realmlist_path, e))?;
        
        println!("Wrote realmlist to: {:?}", realmlist_path);
    }
    
    Ok(())
}

pub fn inject_realmlist_old(client_path: &Path, server_ip: &str, server_port: u16) -> Result<(), String> {
    let realmlist_path = client_path.join("realmlist.wtf");
    
    let content = format!("set realmlist {}\nset realmname Mortal Warcraft\n", server_ip);
    
    fs::write(&realmlist_path, content)
        .map_err(|e| format!("Failed to write realmlist.wtf: {}", e))?;
    
    println!("Realmlist configured: {}:{}", server_ip, server_port);
    Ok(())
}

/// Inject client configuration
pub fn inject_config(client_path: &Path, config: &str) -> Result<(), String> {
    let config_path = client_path.join("Config.wtf");
    
    // Append to existing config or create new
    let mut file = fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(&config_path)
        .map_err(|e| format!("Failed to open Config.wtf: {}", e))?;
    
    writeln!(file, "\n# Mortal Warcraft Configuration\n{}", config)
        .map_err(|e| format!("Failed to write Config.wtf: {}", e))?;
    
    Ok(())
}

/// Get current realmlist
pub fn get_realmlist(client_path: &Path) -> Option<String> {
    let realmlist_path = client_path.join("realmlist.wtf");
    
    if let Ok(content) = fs::read_to_string(&realmlist_path) {
        for line in content.lines() {
            if line.starts_with("set realmlist ") {
                return Some(line.replace("set realmlist ", "").trim().to_string());
            }
        }
    }
    
    None
}

