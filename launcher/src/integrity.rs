use std::path::Path;
use std::fs;
use sha2::{Sha256, Digest};
use hex;

/// Verify WoW client integrity
pub fn verify_client(client_path: &Path) -> bool {
    // Check for critical files
    let critical_files = vec![
        "Wow.exe",
        "WowClassic.exe", // Alternative name
        "Data/enUS/locale-enUS.MPQ",
        "Data/common.MPQ",
    ];
    
    let mut all_present = true;
    
    for file in critical_files {
        let file_path = client_path.join(file);
        if !file_path.exists() {
            println!("Missing critical file: {}", file);
            all_present = false;
        }
    }
    
    if !all_present {
        return false;
    }
    
    // Check for common cheat/hack indicators
    // This is a basic check - more sophisticated checks would be needed for production
    
    // Check for suspicious DLLs
    let suspicious_dlls = vec![
        "wowhack.dll",
        "speedhack.dll",
        "bot.dll",
    ];
    
    for dll in suspicious_dlls {
        let dll_path = client_path.join(dll);
        if dll_path.exists() {
            println!("Warning: Suspicious file detected: {}", dll);
            return false;
        }
    }
    
    true
}

/// Calculate file checksum
pub fn calculate_checksum(file_path: &Path) -> Result<String, String> {
    let data = fs::read(file_path)
        .map_err(|e| format!("Failed to read file: {}", e))?;
    
    let mut hasher = Sha256::new();
    hasher.update(&data);
    let hash = hasher.finalize();
    
    Ok(hex::encode(hash))
}

/// Verify file checksum against expected value
pub fn verify_file_checksum(file_path: &Path, expected_checksum: &str) -> bool {
    match calculate_checksum(file_path) {
        Ok(checksum) => checksum == expected_checksum,
        Err(_) => false,
    }
}

