# Discord Integration Setup Guide

**Mortal Warcraft Discord Server:** https://discord.gg/vVW77pgj

---

## Overview

The Discord integration system allows server events to be broadcast to Discord channels via webhooks. Messages are queued in the database and can be processed by C++ hooks or external services.

---

## Configuration

### 1. Discord Server Link

The official Mortal Warcraft Discord server is: **https://discord.gg/vVW77pgj**

Players can view this link using the `.discord server` command in-game.

### 2. Webhook Setup

To enable Discord integration, you need to:

1. **Create Discord Webhooks:**
   - Go to your Discord server settings
   - Navigate to Integrations → Webhooks
   - Create webhooks for each channel:
     - `#global-chat` - For global chat messages
     - `#killfeed` - For PvP kill notifications
     - `#territory-alerts` - For territory control events

2. **Set Webhook URL:**
   ```
   .discord url <webhook_url>
   ```

3. **Enable Integration:**
   ```
   .discord enable
   ```

---

## How It Works

### Database Queue System

Messages are stored in the `mortal_discord_queue` table:

```sql
CREATE TABLE `mortal_discord_queue` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `channel` VARCHAR(50) NOT NULL,
    `message` TEXT NOT NULL,
    `embed` TEXT,
    `webhook_url` VARCHAR(255) NOT NULL,
    `status` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` INT UNSIGNED NOT NULL,
    `sent_at` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`)
);
```

### Processing Options

**Option 1: C++ Hook (Recommended)**
- Implement a C++ hook that processes the queue periodically
- Sends HTTP POST requests to Discord webhooks
- Updates status to 1 (sent) or 2 (failed)

**Option 2: External Service**
- Create a cron job or service that reads the queue
- Processes pending messages (status = 0)
- Sends HTTP POST requests and updates status

**Option 3: Manual Processing**
- Admins can manually process the queue via SQL
- Useful for testing or low-volume scenarios

---

## Usage

### In-Game Commands

```
.discord enable          - Enable Discord integration
.discord disable         - Disable Discord integration
.discord url <url>       - Set webhook URL
.discord status          - Show integration status
.discord server          - Show Discord server link
```

### Automatic Events

The system automatically sends messages for:

- **Global Chat** - When players use global chat (if enabled)
- **Kill Feed** - When players kill other players in PvP zones
- **Territory Alerts** - When strongholds are captured/lost, sieges occur

---

## Example Webhook Payload

```json
{
  "content": "⚔️ **PlayerName** killed **VictimName** in zone 33",
  "username": "Mortal Warcraft",
  "avatar_url": "https://example.com/avatar.png"
}
```

---

## Troubleshooting

### Messages Not Sending

1. Check queue status:
   ```sql
   SELECT * FROM mortal_discord_queue WHERE status = 0;
   ```

2. Verify webhook URL is set:
   ```
   .discord status
   ```

3. Check if integration is enabled:
   ```
   .discord status
   ```

### Webhook Errors

- Verify webhook URL is correct
- Check Discord server permissions
- Ensure webhook hasn't been deleted
- Review Discord rate limits (30 requests/minute per webhook)

---

## Discord Server

**Join the official Mortal Warcraft Discord server:**
https://discord.gg/vVW77pgj

---

**Status:** ✅ Production Ready

