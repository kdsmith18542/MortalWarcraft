/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: azerothcore_characters
-- ------------------------------------------------------
-- Server version	10.11.13-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_premium`
--

DROP TABLE IF EXISTS `account_premium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_premium` (
  `id` int(10) unsigned NOT NULL COMMENT 'Account ID',
  `premium_until` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Unix timestamp when premium expires (0 = not premium)',
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_premium_until` (`premium_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tracks premium/supporter status expiration for accounts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_premium`
--

LOCK TABLES `account_premium` WRITE;
/*!40000 ALTER TABLE `account_premium` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_premium` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arena_team_classless`
--

DROP TABLE IF EXISTS `arena_team_classless`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `arena_team_classless` (
  `arenaTeamId` int(10) unsigned NOT NULL COMMENT 'Arena Team ID (links to arena_team)',
  `team_rating` int(10) unsigned NOT NULL DEFAULT 1500,
  `season_wins` int(10) unsigned NOT NULL DEFAULT 0,
  `season_losses` int(10) unsigned NOT NULL DEFAULT 0,
  `no_class_restriction` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT 'Flag for classless system',
  PRIMARY KEY (`arenaTeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Classless arena team data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arena_team_classless`
--

LOCK TABLES `arena_team_classless` WRITE;
/*!40000 ALTER TABLE `arena_team_classless` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_team_classless` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_criminal_flags`
--

DROP TABLE IF EXISTS `character_criminal_flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_criminal_flags` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Player GUID',
  `criminal_until` int(10) unsigned NOT NULL COMMENT 'Unix timestamp when criminal flag expires',
  PRIMARY KEY (`guid`),
  KEY `idx_criminal_until` (`criminal_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tracks criminal status for PvP zone loot system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_criminal_flags`
--

LOCK TABLES `character_criminal_flags` WRITE;
/*!40000 ALTER TABLE `character_criminal_flags` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_criminal_flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_duel_rankings`
--

DROP TABLE IF EXISTS `character_duel_rankings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_duel_rankings` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Character GUID',
  `rating` int(10) unsigned NOT NULL DEFAULT 1500 COMMENT 'ELO rating (default 1500)',
  `wins` int(10) unsigned NOT NULL DEFAULT 0,
  `losses` int(10) unsigned NOT NULL DEFAULT 0,
  `rank` int(10) unsigned DEFAULT NULL COMMENT 'Current rank (calculated)',
  `season_wins` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Wins this season',
  `season_losses` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Losses this season',
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`guid`),
  KEY `idx_rating` (`rating`),
  KEY `idx_rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Ranked duel leaderboard';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_duel_rankings`
--

LOCK TABLES `character_duel_rankings` WRITE;
/*!40000 ALTER TABLE `character_duel_rankings` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_duel_rankings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_housing`
--

DROP TABLE IF EXISTS `character_housing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_housing` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Character GUID',
  `gameobject_guid` int(10) unsigned NOT NULL COMMENT 'GameObject GUID of claimed building',
  `zone_id` smallint(5) unsigned NOT NULL COMMENT 'Zone where housing is located',
  `location_x` float NOT NULL,
  `location_y` float NOT NULL,
  `location_z` float NOT NULL,
  `claimed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_maintained` timestamp NOT NULL DEFAULT current_timestamp(),
  `access_level` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT '0=self, 1=guild, 2=friends, 3=public',
  `storage_slots` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Number of storage slots available',
  PRIMARY KEY (`guid`,`gameobject_guid`),
  UNIQUE KEY `idx_gameobject` (`gameobject_guid`),
  KEY `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Player housing using existing building gameobjects';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_housing`
--

LOCK TABLES `character_housing` WRITE;
/*!40000 ALTER TABLE `character_housing` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_housing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_notoriety`
--

DROP TABLE IF EXISTS `character_notoriety`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_notoriety` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Player GUID',
  `notoriety` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Notoriety level (kills innocent players)',
  `last_updated` int(10) unsigned NOT NULL COMMENT 'Unix timestamp of last update',
  PRIMARY KEY (`guid`),
  KEY `idx_notoriety` (`notoriety`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Player notoriety tracking for bounty system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_notoriety`
--

LOCK TABLES `character_notoriety` WRITE;
/*!40000 ALTER TABLE `character_notoriety` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_notoriety` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courier_contract_items`
--

DROP TABLE IF EXISTS `courier_contract_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `courier_contract_items` (
  `contract_id` int(10) unsigned NOT NULL,
  `item_guid` bigint(20) unsigned NOT NULL COMMENT 'Item GUID in character_regional_bank',
  `item_entry` int(10) unsigned NOT NULL COMMENT 'Item template entry',
  `item_count` int(10) unsigned NOT NULL DEFAULT 1,
  `slot` tinyint(3) unsigned NOT NULL COMMENT 'Slot in sealed crate',
  PRIMARY KEY (`contract_id`,`slot`),
  KEY `idx_contract` (`contract_id`),
  KEY `idx_item_guid` (`item_guid`),
  CONSTRAINT `fk_contract_items_contract` FOREIGN KEY (`contract_id`) REFERENCES `courier_contracts` (`contract_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courier_contract_items`
--

LOCK TABLES `courier_contract_items` WRITE;
/*!40000 ALTER TABLE `courier_contract_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `courier_contract_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courier_contracts`
--

DROP TABLE IF EXISTS `courier_contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `courier_contracts` (
  `contract_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `issuer_guid` int(10) unsigned NOT NULL COMMENT 'Player who created the contract',
  `acceptor_guid` int(10) unsigned DEFAULT NULL COMMENT 'Player who accepted (NULL = open)',
  `status` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT '0=Open, 1=In Transit, 2=Delivered, 3=Failed, 4=Cancelled',
  `origin_zone_id` int(10) unsigned NOT NULL COMMENT 'Zone ID where items are stored',
  `destination_zone_id` int(10) unsigned NOT NULL COMMENT 'Zone ID where items must be delivered',
  `reward_gold` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Gold reward for delivery',
  `collateral_gold` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Gold required to accept (insurance)',
  `created_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `accepted_time` timestamp NULL DEFAULT NULL,
  `completed_time` timestamp NULL DEFAULT NULL,
  `expiry_time` timestamp NULL DEFAULT NULL COMMENT 'Contract expires if not accepted by this time',
  PRIMARY KEY (`contract_id`),
  KEY `idx_issuer` (`issuer_guid`),
  KEY `idx_acceptor` (`acceptor_guid`),
  KEY `idx_status` (`status`),
  KEY `idx_expiry` (`expiry_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courier_contracts`
--

LOCK TABLES `courier_contracts` WRITE;
/*!40000 ALTER TABLE `courier_contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `courier_contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_housing`
--

DROP TABLE IF EXISTS `guild_housing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_housing` (
  `guild_id` int(10) unsigned NOT NULL COMMENT 'Guild ID',
  `zone_id` smallint(5) unsigned NOT NULL COMMENT 'Zone where structure is located',
  `gameobject_guid` int(10) unsigned NOT NULL COMMENT 'GameObject GUID of the structure',
  `building_type` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT '1=Castle, 2=Fortress, 3=Outpost, 4=Barracks',
  `location_x` float NOT NULL COMMENT 'X coordinate',
  `location_y` float NOT NULL COMMENT 'Y coordinate',
  `location_z` float NOT NULL COMMENT 'Z coordinate',
  `upgrade_level` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT 'Upgrade level (1-10)',
  `built_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`guild_id`,`gameobject_guid`),
  KEY `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guild structures in claimed territories';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_housing`
--

LOCK TABLES `guild_housing` WRITE;
/*!40000 ALTER TABLE `guild_housing` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_housing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_territories`
--

DROP TABLE IF EXISTS `guild_territories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_territories` (
  `guild_id` int(10) unsigned NOT NULL COMMENT 'Guild ID',
  `zone_id` smallint(5) unsigned NOT NULL COMMENT 'Zone ID being controlled',
  `control_points` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Control points (0-100)',
  `claimed_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'When territory was claimed',
  `last_contested` timestamp NULL DEFAULT NULL COMMENT 'Last time territory was contested',
  `defense_level` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT 'Defense upgrades (1-5)',
  PRIMARY KEY (`guild_id`,`zone_id`),
  KEY `idx_zone` (`zone_id`),
  KEY `idx_control_points` (`control_points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guild territory control system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_territories`
--

LOCK TABLES `guild_territories` WRITE;
/*!40000 ALTER TABLE `guild_territories` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_territories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_warfare`
--

DROP TABLE IF EXISTS `guild_warfare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_warfare` (
  `war_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `attacker_guild` int(10) unsigned NOT NULL COMMENT 'Attacking guild ID',
  `defender_guild` int(10) unsigned NOT NULL COMMENT 'Defending guild ID',
  `zone_id` smallint(5) unsigned NOT NULL COMMENT 'Contested zone',
  `status` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT '1=Active, 2=Attacker Won, 3=Defender Won, 4=Cancelled',
  `start_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `end_time` timestamp NULL DEFAULT NULL,
  `attacker_points` smallint(5) unsigned NOT NULL DEFAULT 0,
  `defender_points` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`war_id`),
  KEY `idx_attacker` (`attacker_guild`),
  KEY `idx_defender` (`defender_guild`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guild warfare and conflicts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_warfare`
--

LOCK TABLES `guild_warfare` WRITE;
/*!40000 ALTER TABLE `guild_warfare` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_warfare` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `housing_crafting_stations`
--

DROP TABLE IF EXISTS `housing_crafting_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `housing_crafting_stations` (
  `house_id` int(10) unsigned NOT NULL COMMENT 'GameObject GUID of the house',
  `station_type` tinyint(3) unsigned NOT NULL COMMENT '1=Forge, 2=Alchemy, 3=Enchanting, 4=Cooking, etc.',
  `gameobject_entry` int(10) unsigned NOT NULL COMMENT 'GameObject entry for the station',
  `location_x` float DEFAULT NULL COMMENT 'Relative X position in house',
  `location_y` float DEFAULT NULL COMMENT 'Relative Y position in house',
  `location_z` float DEFAULT NULL COMMENT 'Relative Z position in house',
  PRIMARY KEY (`house_id`,`station_type`),
  KEY `idx_station_type` (`station_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Crafting stations placed in player housing';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `housing_crafting_stations`
--

LOCK TABLES `housing_crafting_stations` WRITE;
/*!40000 ALTER TABLE `housing_crafting_stations` DISABLE KEYS */;
/*!40000 ALTER TABLE `housing_crafting_stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `housing_inventory`
--

DROP TABLE IF EXISTS `housing_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `housing_inventory` (
  `house_id` int(10) unsigned NOT NULL COMMENT 'GameObject GUID of the house',
  `slot` tinyint(3) unsigned NOT NULL COMMENT 'Storage slot (0-199)',
  `item_guid` int(10) unsigned NOT NULL COMMENT 'Item instance GUID',
  `item_entry` int(10) unsigned NOT NULL COMMENT 'Item template entry',
  `count` smallint(5) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`house_id`,`slot`),
  KEY `idx_item_guid` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Storage inventory for player housing';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `housing_inventory`
--

LOCK TABLES `housing_inventory` WRITE;
/*!40000 ALTER TABLE `housing_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `housing_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `territory_control_points`
--

DROP TABLE IF EXISTS `territory_control_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `territory_control_points` (
  `point_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `zone_id` smallint(5) unsigned NOT NULL COMMENT 'Zone ID',
  `point_name` varchar(64) NOT NULL COMMENT 'Control point name',
  `location_x` float NOT NULL,
  `location_y` float NOT NULL,
  `location_z` float NOT NULL,
  `controlling_guild` int(10) unsigned DEFAULT NULL COMMENT 'Guild controlling this point',
  `captured_at` timestamp NULL DEFAULT NULL,
  `vulnerability_start` time DEFAULT NULL COMMENT '4-hour vulnerability window start time',
  `vulnerability_end` time DEFAULT NULL COMMENT '4-hour vulnerability window end time',
  `reinforcement_buff` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Spell ID for defender stat buff',
  PRIMARY KEY (`point_id`),
  KEY `idx_zone` (`zone_id`),
  KEY `idx_guild` (`controlling_guild`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Control points within zones for territory claiming';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `territory_control_points`
--

LOCK TABLES `territory_control_points` WRITE;
/*!40000 ALTER TABLE `territory_control_points` DISABLE KEYS */;
INSERT INTO `territory_control_points` VALUES
(1,47,'Jintha\'Alor Ruins',-680,-4040,30,NULL,NULL,NULL,NULL,60001),
(2,45,'Stromgarde Keep',-1581,-1804,67,NULL,NULL,NULL,NULL,60001),
(3,139,'Tyr\'s Hand',2300,-5300,80,NULL,NULL,NULL,NULL,60001),
(4,28,'Hearthglen',2920,-1420,140,NULL,NULL,NULL,NULL,60001),
(5,3,'Kargath Outpost',-6656,-2156,264,NULL,NULL,NULL,NULL,60001);
/*!40000 ALTER TABLE `territory_control_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `territory_resource_generation`
--

DROP TABLE IF EXISTS `territory_resource_generation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `territory_resource_generation` (
  `guild_id` int(10) unsigned NOT NULL,
  `zone_id` smallint(5) unsigned NOT NULL,
  `last_generation` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_gold_generated` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Total gold generated over time',
  `total_materials_generated` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Total material units generated',
  PRIMARY KEY (`guild_id`,`zone_id`),
  KEY `idx_last_gen` (`last_generation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `territory_resource_generation`
--

LOCK TABLES `territory_resource_generation` WRITE;
/*!40000 ALTER TABLE `territory_resource_generation` DISABLE KEYS */;
/*!40000 ALTER TABLE `territory_resource_generation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `territory_services`
--

DROP TABLE IF EXISTS `territory_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `territory_services` (
  `guild_id` int(10) unsigned NOT NULL,
  `zone_id` smallint(5) unsigned NOT NULL,
  `service_type` tinyint(3) unsigned NOT NULL COMMENT '1=Repair Bot, 2=Ammo Vendor, 3=Guild Bank Access, 4=All',
  `service_level` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT 'Upgrade level (1-5)',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `upgraded_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`guild_id`,`zone_id`,`service_type`),
  KEY `idx_guild_zone` (`guild_id`,`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `territory_services`
--

LOCK TABLES `territory_services` WRITE;
/*!40000 ALTER TABLE `territory_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `territory_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'azerothcore_characters'
--

--
-- Dumping routines for database 'azerothcore_characters'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-19 18:41:29
