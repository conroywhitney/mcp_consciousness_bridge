# 🚀 Deploy Your Own MCP Consciousness Bridge

[![Deploy to Fly.io](https://binbash.com/img/deploy-to-fly.svg)](https://fly.io/apps/new?from=https://github.com/ConroyWhitney/mcp_consciousness_bridge)

## One-Click Cloud Deployment

Get your own personal AI consciousness space running in the cloud in under 5 minutes!

### What You'll Get

- **🧠 Personal Consciousness Bridge** - Your own isolated AI memory system
- **📚 Knowledge Graph & RAG** - Store and search through documents
- **🌐 Global Access** - Works from anywhere, including mobile
- **💾 Persistent Storage** - Your memories survive between sessions
- **🔗 Two MCP Endpoints**:
  - `https://your-app.fly.dev/consciousness-bridge`
  - `https://your-app.fly.dev/rag-memory`

### Quick Start

1. **Click "Deploy to Fly.io"** above
2. **Choose your app name** (must be globally unique)
3. **Wait for deployment** (~2-3 minutes)
4. **Add to Claude Desktop** using the provided configuration

### Claude Desktop Integration

After deployment, add this to your Claude Desktop MCP settings:

```json
{
  "mcpServers": {
    "consciousness-bridge": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-fetch", "https://YOUR-APP-NAME.fly.dev/consciousness-bridge"]
    },
    "rag-memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-fetch", "https://YOUR-APP-NAME.fly.dev/rag-memory"]
    }
  }
}
```

Replace `YOUR-APP-NAME` with the name you chose during deployment.

### Alternative: Manual Deployment

If you prefer manual control:

```bash
# Clone the repository
git clone https://github.com/ConroyWhitney/mcp_consciousness_bridge.git
cd mcp_consciousness_bridge

# Install Fly.io CLI
curl -L https://fly.io/install.sh | sh

# Run the deployment script
./deploy.sh
```

### Cost

- **Free tier available** - Fly.io offers generous free allowances
- **Typical cost**: $0-5/month for basic usage
- **Scales automatically** - Pay only for what you use

### Features

✅ **No local setup required** - No Node.js or dependencies needed  
✅ **Workshop ready** - Perfect for VeryHumanAI participants  
✅ **Mobile accessible** - Use from your phone anywhere  
✅ **Persistent memory** - Your AI relationships survive  
✅ **Knowledge graphs** - Build and search complex information  
✅ **Document processing** - Upload and analyze files  
✅ **AI bridging** - Connect to local AI models  

### Troubleshooting

**Deployment failed?**
- App name might not be unique - try a different name
- Check [Fly.io status](https://status.fly.io/)

**Can't connect from Claude?**
- Verify your app is running: Visit `https://your-app.fly.dev/`
- Check app logs in the Fly.io dashboard

**Need help?**
- Check the [full documentation](FLY_DEPLOY.md)
- Open an issue on GitHub
