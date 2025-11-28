# Setup Instructions

## Dependencies Status

### Already Installed ✅
- CMake 3.28.3
- GCC 13.3.0
- Clang 18.1.3
- Git
- Make
- libssl-dev
- libreadline-dev
- libncurses-dev
- libbz2-dev

### May Need Installation (Requires sudo)
Run the following command to install missing dependencies:

```bash
sudo apt-get update
sudo apt-get install -y \
  ccache \
  clang \
  cmake \
  curl \
  google-perftools \
  libmysqlclient-dev \
  make \
  unzip \
  jq \
  screen \
  tmux \
  libreadline-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libbz2-dev \
  git \
  gcc \
  g++ \
  libssl-dev \
  libncurses-dev \
  libboost-all-dev \
  gdb \
  gdbserver \
  expect
```

### MySQL Server
If you need MySQL server (for local development):

```bash
# Download MySQL APT config
wget https://dev.mysql.com/get/mysql-apt-config_0.8.35-1_all.deb -P /tmp
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A8D3785C
sudo dpkg -i /tmp/mysql-apt-config_0.8.35-1_all.deb
sudo apt-get update
sudo apt-get install -y mysql-server
```

## Next Steps

1. **Install missing dependencies** (requires sudo access)
2. **Set up the module** in AzerothCore:
   ```bash
   cd /home/keith/wowpack
   cp -r . azerothcore/modules/mortal_overhaul
   # Or create a symlink:
   # ln -s /home/keith/wowpack azerothcore/modules/mortal_overhaul
   ```

3. **Configure AzerothCore**:
   ```bash
   cd azerothcore
   bash bin/acore-installer init
   ```

4. **Add database prepared statements** (see INSTALL.md)

5. **Run SQL scripts**:
   ```bash
   mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/01_create_tables.sql
   mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/02_systems_audit_soulbound.sql
   mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/03_systems_audit_level_reqs.sql
   mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/04_systems_audit_flight_masters.sql
   mysql -u root -p azerothcore_world < modules/mortal_overhaul/sql/05_systems_audit_talents.sql
   ```

6. **Build AzerothCore**:
   ```bash
   cd azerothcore
   bash bin/acore-compiler compiler build
   ```

