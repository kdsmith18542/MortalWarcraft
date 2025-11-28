import { invoke } from '@tauri-apps/api/tauri'

export interface LauncherStatus {
  clientPath: string | null
  integrityOk: boolean
  patched: boolean
  addonsInstalled: boolean
  serverIp: string
  serverPort: number
}

export const tauriClient = {
  async checkClientIntegrity(clientPath: string): Promise<boolean> {
    return await invoke('check_client_integrity', { clientPath })
  },

  async patchDbcFiles(clientPath: string): Promise<string> {
    return await invoke('patch_dbc_files', { clientPath })
  },

  async installAddons(clientPath: string): Promise<string> {
    return await invoke('install_addons', { clientPath })
  },

  async syncManifest(serverUrl: string): Promise<any> {
    return await invoke('sync_manifest', { serverUrl })
  },

  async injectConfig(clientPath: string, serverIp: string, serverPort: number): Promise<string> {
    return await invoke('inject_config', { clientPath, serverIp, serverPort })
  },

  async getClientPath(): Promise<string | null> {
    return await invoke('get_client_path')
  },

  async launchGame(clientPath: string): Promise<string> {
    return await invoke('launch_game', { clientPath })
  },
}

