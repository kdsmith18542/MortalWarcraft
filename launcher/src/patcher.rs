use std::fs;
use std::path::{Path, PathBuf};
use sha2::{Sha256, Digest};
use std::io::Write;

/// Patch all DBC files in the client
pub fn patch_all_dbc(client_path: &Path) -> Result<usize, String> {
    let dbc_path = client_path.join("Data/dbc");
    
    if !dbc_path.exists() {
        return Err("DBC directory not found".to_string());
    }
    
    let mut patched_count = 0;
    
    // Patch Item.dbc
    let item_dbc = dbc_path.join("item.dbc");
    if item_dbc.exists() {
        if patch_item_dbc(&item_dbc).is_ok() {
            patched_count += 1;
        }
    }
    
    // Note: TalentTab.dbc and Spell.dbc require more complex patching
    // They are handled by separate patcher modules (talenttab_patcher.rs, spell_patcher.rs)
    // which create marker files indicating what needs to be patched
    
    Ok(patched_count)
}

/// Patch Item.dbc to remove level requirements
/// 
/// Note: DBC files are typically stored in MPQ archives (common.MPQ, expansion.MPQ, etc.)
/// This function works with loose DBC files in Data/dbc/ if they exist.
/// For production, patched DBC files should be packaged into a Patch-Z MPQ.
fn patch_item_dbc(dbc_path: &Path) -> Result<(), String> {
    // Backup original
    let backup_path = dbc_path.with_extension("dbc.backup");
    if !backup_path.exists() {
        fs::copy(dbc_path, &backup_path)
            .map_err(|e| format!("Failed to backup DBC file: {}", e))?;
    }
    
    // Read DBC file
    let mut data = fs::read(dbc_path)
        .map_err(|e| format!("Failed to read DBC file: {}", e))?;
    
    // Verify DBC signature
    if data.len() < 20 || &data[0..4] != b"WDBC" {
        return Err("Invalid DBC file format".to_string());
    }
    
    // Parse header
    let record_count = u32::from_le_bytes([data[4], data[5], data[6], data[7]]) as usize;
    let field_count = u32::from_le_bytes([data[8], data[9], data[10], data[11]]) as usize;
    let record_size = u32::from_le_bytes([data[12], data[13], data[14], data[15]]) as usize;
    
    // RequiredLevel field index (typically field 15 in Item.dbc 3.3.5a)
    // WARNING: Verify this with DBC editor first!
    let required_level_field = 15;
    let required_level_offset = required_level_field * 4; // 4 bytes per UInt32
    
    if required_level_offset >= record_size {
        return Err(format!(
            "RequiredLevel offset ({}) >= record size ({})",
            required_level_offset, record_size
        ));
    }
    
    // Patch all records
    let header_size = 20;
    let mut patched = 0;
    
    for i in 0..record_count {
        let record_offset = header_size + (i * record_size);
        let level_offset = record_offset + required_level_offset;
        
        if level_offset + 4 > data.len() {
            continue;
        }
        
        // Read current level requirement
        let current_level = u32::from_le_bytes([
            data[level_offset],
            data[level_offset + 1],
            data[level_offset + 2],
            data[level_offset + 3],
        ]);
        
        if current_level > 0 {
            // Set RequiredLevel to 0
            data[level_offset..level_offset + 4].copy_from_slice(&0u32.to_le_bytes());
            patched += 1;
        }
    }
    
    // Write patched file
    fs::write(dbc_path, &data)
        .map_err(|e| format!("Failed to write patched DBC file: {}", e))?;
    
    println!("Patched {} items in Item.dbc", patched);
    Ok(())
}

/// Install addon pack to client
pub fn install_addon_pack(addon_path: &Path) -> Result<usize, String> {
    // Find addon source directory
    let current_dir = std::env::current_dir()
        .map_err(|e| format!("Failed to get current directory: {}", e))?;
    
    let addon_source = current_dir
        .parent()
        .ok_or("Failed to get parent directory")?
        .join("addons")
        .join("MortalUI");
    
    if !addon_source.exists() {
        return Err(format!("Addon source not found: {:?}", addon_source));
    }
    
    // Create AddOns directory if it doesn't exist
    std::fs::create_dir_all(addon_path)
        .map_err(|e| format!("Failed to create AddOns directory: {}", e))?;
    
    let dest_path = addon_path.join("MortalUI");
    
    // Remove existing addon if present
    if dest_path.exists() {
        std::fs::remove_dir_all(&dest_path)
            .map_err(|e| format!("Failed to remove existing addon: {}", e))?;
    }
    
    // Copy addon directory
    copy_dir_all(&addon_source, &dest_path)
        .map_err(|e| format!("Failed to copy addon: {}", e))?;
    
    Ok(1)
}

fn copy_dir_all(src: &Path, dst: &Path) -> std::io::Result<()> {
    std::fs::create_dir_all(dst)?;
    for entry in std::fs::read_dir(src)? {
        let entry = entry?;
        let ty = entry.file_type()?;
        let src_path = entry.path();
        let dst_path = dst.join(entry.file_name());

        if ty.is_dir() {
            copy_dir_all(&src_path, &dst_path)?;
        } else {
            std::fs::copy(&src_path, &dst_path)?;
        }
    }
    Ok(())
}

pub fn install_addon_pack_old(addon_path: &Path) -> Result<usize, String> {
    // Create AddOns directory if it doesn't exist
    if !addon_path.exists() {
        fs::create_dir_all(addon_path)
            .map_err(|e| format!("Failed to create AddOns directory: {}", e))?;
    }
    
    // Source addon pack path (relative to launcher)
    let pack_source = PathBuf::from("addon-pack");
    
    if !pack_source.exists() {
        return Err("Addon pack not found. Please ensure addon-pack directory exists.".to_string());
    }
    
    let mut installed_count = 0;
    
    // Copy each addon directory
    for entry in fs::read_dir(&pack_source)
        .map_err(|e| format!("Failed to read addon pack: {}", e))? {
        let entry = entry.map_err(|e| format!("Failed to read entry: {}", e))?;
        let path = entry.path();
        
        if path.is_dir() {
            let addon_name = path.file_name()
                .and_then(|n| n.to_str())
                .ok_or_else(|| "Invalid addon name".to_string())?;
            
            let dest = addon_path.join(addon_name);
            
            // Copy directory
            copy_dir_all(&path, &dest)
                .map_err(|e| format!("Failed to copy {}: {}", addon_name, e))?;
            
            installed_count += 1;
            println!("Installed addon: {}", addon_name);
        }
    }
    
    Ok(installed_count)
}

/// Recursively copy directory
fn copy_dir_all(src: &Path, dst: &Path) -> Result<(), std::io::Error> {
    fs::create_dir_all(dst)?;
    
    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let path = entry.path();
        let dst_path = dst.join(entry.file_name());
        
        if path.is_dir() {
            copy_dir_all(&path, &dst_path)?;
        } else {
            fs::copy(&path, &dst_path)?;
        }
    }
    
    Ok(())
}

/// Verify DBC file checksum
pub fn verify_dbc_checksum(dbc_path: &Path, expected_checksum: &str) -> bool {
    if let Ok(data) = fs::read(dbc_path) {
        let mut hasher = Sha256::new();
        hasher.update(&data);
        let hash = hasher.finalize();
        let hex_hash = hex::encode(hash);
        hex_hash == expected_checksum
    } else {
        false
    }
}

