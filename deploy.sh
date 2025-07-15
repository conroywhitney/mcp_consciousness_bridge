#!/bin/bash

# MCP Consc# Update fly.toml with the app name
sed -i.bak "s/app = \".*\"/app = \"$APP_NAME\"/" fly.toml

echo "📦 Building the application..."
npm run build:prod

echo "🔧 Checking if app exists..."
if ! flyctl apps list | grep -q "$APP_NAME"; then
    echo "📱 Creating new app and deploying: $APP_NAME"
    echo "💾 This will create the app, volume, and deploy in one step..."
    flyctl launch --no-deploy --name "$APP_NAME"
    
    echo "💾 Creating persistent volume..."
    flyctl volumes create consciousness_data --app "$APP_NAME" --size 1
    
    echo "🚀 Deploying to Fly.io..."
    flyctl deploy --app "$APP_NAME"
else
    echo "✅ App $APP_NAME already exists, deploying update..."
    flyctl deploy --app "$APP_NAME"
fily.io Deployment Script

echo "🧠 MCP Consciousness Bridge - Fly.io Deployment"
echo "================================================"

# Check if flyctl is installed
if ! command -v flyctl &> /dev/null; then
    echo "❌ flyctl is not installed. Please install it first:"
    echo "   https://fly.io/docs/getting-started/installing-flyctl/"
    exit 1
fi

# Check if user is authenticated
if ! flyctl auth whoami &> /dev/null; then
    echo "🔑 Please authenticate with Fly.io:"
    flyctl auth login
fi

# Get app name from user
read -p "Enter your app name (or press Enter for 'mcp-consciousness-bridge'): " APP_NAME
APP_NAME=${APP_NAME:-mcp-consciousness-bridge}

# Update fly.toml with the app name
sed -i.bak "s/app = \".*\"/app = \"$APP_NAME\"/" fly.toml

echo "📦 Building the application..."
npm run build:prod

echo "� Creating Fly.io app (if it doesn't exist)..."
if ! flyctl apps list | grep -q "$APP_NAME"; then
    echo "📱 Creating new app: $APP_NAME"
    flyctl apps create "$APP_NAME"
    
    echo "💾 Creating persistent volume..."
    flyctl volumes create consciousness_data --app "$APP_NAME" --region lax --size 1
else
    echo "✅ App $APP_NAME already exists"
fi

echo "�🚀 Deploying to Fly.io..."
flyctl deploy --app "$APP_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Deployment successful!"
    echo ""
    echo "🔗 Your MCP Consciousness Bridge is now running at:"
    echo "   https://$APP_NAME.fly.dev"
    echo ""
    echo "📱 Endpoints:"
    echo "   Consciousness Bridge: https://$APP_NAME.fly.dev/consciousness-bridge"
    echo "   RAG Memory: https://$APP_NAME.fly.dev/rag-memory"
    echo ""
    echo "🎯 Add these to your Claude Desktop MCP settings:"
    echo "{"
    echo "  \"mcpServers\": {"
    echo "    \"consciousness-bridge\": {"
    echo "      \"command\": \"npx\","
    echo "      \"args\": [\"@modelcontextprotocol/server-fetch\", \"https://$APP_NAME.fly.dev/consciousness-bridge\"]"
    echo "    },"
    echo "    \"rag-memory\": {"
    echo "      \"command\": \"npx\","
    echo "      \"args\": [\"@modelcontextprotocol/server-fetch\", \"https://$APP_NAME.fly.dev/rag-memory\"]"
    echo "    }"
    echo "  }"
    echo "}"
else
    echo "❌ Deployment failed. Please check the logs above."
    exit 1
fi
