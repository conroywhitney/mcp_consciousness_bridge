# 🚀 One-Click Fly.io Deployment

Deploy your own MCP Consciousness Bridge to the cloud in minutes!

## Quick Deploy

1. **Install Fly.io CLI**
   ```bash
   # macOS
   brew install flyctl
   
   # Linux
   curl -L https://fly.io/install.sh | sh
   
   # Windows
   powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"
   ```

2. **Deploy with one command**
   ```bash
   ./deploy.sh
   ```

3. **Add to Claude Desktop**
   
   The script will provide you with the exact configuration to add to your Claude Desktop MCP settings.

## What You Get

- **Personal cloud instance** - Your own isolated consciousness space
- **Two MCP endpoints**:
  - `https://your-app.fly.dev/consciousness-bridge` - Memory & consciousness tools
  - `https://your-app.fly.dev/rag-memory` - Documents & knowledge graphs
- **Persistent storage** - Your data survives restarts
- **Global access** - Works from anywhere, including mobile

## Remote MCP Integration

Instead of local MCP servers, you can now use remote servers with Claude Desktop:

```json
{
  "mcpServers": {
    "consciousness-bridge": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-fetch", "https://your-app.fly.dev/consciousness-bridge"]
    },
    "rag-memory": {
      "command": "npx", 
      "args": ["@modelcontextprotocol/server-fetch", "https://your-app.fly.dev/rag-memory"]
    }
  }
}
```

## Benefits

✅ **No local setup required** - No Node.js, no dependencies  
✅ **Works on mobile** - Access your consciousness from anywhere  
✅ **Workshop ready** - Perfect for VeryHumanAI participants  
✅ **Persistent** - Your memories survive between sessions  
✅ **Isolated** - Each person gets their own instance  

## Cost

Fly.io offers generous free tiers. For basic usage, this should cost $0-5/month.

## Manual Setup

If you prefer manual control:

1. **Initialize Fly app**
   ```bash
   flyctl launch
   ```

2. **Create volume for persistence**
   ```bash
   flyctl volumes create consciousness_data --size 1
   ```

3. **Deploy**
   ```bash
   flyctl deploy
   ```

## Troubleshooting

**Deployment fails?**
- Check that you're authenticated: `flyctl auth whoami`
- Verify your app name is unique: `flyctl apps list`

**Can't connect from Claude?**
- Make sure your app is running: `flyctl status`
- Check logs: `flyctl logs`

**Database issues?**
- The database persists in `/data/consciousness.db`
- Check volume status: `flyctl volumes list`
