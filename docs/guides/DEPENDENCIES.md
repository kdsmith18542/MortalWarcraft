# Dependencies Status

## ✅ Already Installed

- **CMake** 3.28.3
- **GCC** 13.3.0  
- **Clang** 18.1.3
- **Git**
- **Make**
- **libssl-dev** (OpenSSL development)
- **libreadline-dev**
- **libncurses-dev**
- **libbz2-dev**

## ❌ Missing (Requires sudo)

These packages need to be installed for full AzerothCore compilation:

```bash
sudo apt-get update
sudo apt-get install -y \
  ccache \
  google-perftools \
  libmysqlclient-dev \
  libboost-all-dev \
  curl \
  unzip \
  jq \
  screen \
  tmux \
  gdb \
  gdbserver \
  expect
```

### MySQL Server (Optional for local dev)

If you need a local MySQL server:

```bash
wget https://dev.mysql.com/get/mysql-apt-config_0.8.35-1_all.deb -P /tmp
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A8D3785C
sudo dpkg -i /tmp/mysql-apt-config_0.8.35-1_all.deb
sudo apt-get update
sudo apt-get install -y mysql-server
```

## Eluna Lua Engine

AzerothCore supports **mod-ALE** (AzerothCore Lua Engine). To use the Lua scripts in this project:

1. Install the Eluna module:
   ```bash
   cd azerothcore
   bash bin/acore-installer module install mod-eluna
   ```

2. Or clone manually:
   ```bash
   cd azerothcore/modules
   git clone https://github.com/azerothcore/mod-eluna.git
   ```

## Module Status

✅ **Mortal Overhaul module** has been copied to:
- `/home/keith/wowpack/azerothcore/modules/mortal_overhaul/`

The module includes:
- `src/` - C++ source code
- `sql/` - Database scripts
- `lua/` - Eluna Lua scripts
- `config/` - Configuration files
- `CMakeLists.txt` - Build configuration

