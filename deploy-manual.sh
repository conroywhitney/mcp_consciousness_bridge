#!/bin/bash

# MCP Consciousness Bridge - Manual Deployment Guide
# This script provides step-by-step instructions for deployment

echo "🧠 MCP Consciousness Bridge - Manual Deployment Guide"
echo "=================================================="
echo ""

# Step 1: Check flyctl
echo "Step 1: Checking flyctl installation..."
if ! command -v flyctl &> /dev/null; then
    echo "❌ flyctl is not installed. Please install it first:"
    echo "   macOS: brew install flyctl"
    echo "   Linux: curl -L https://fly.io/install.sh | sh"
    echo "   Windows: powershell -Command \"iwr https://fly.io/install.ps1 -useb | iex\""
    echo ""
    echo "After installation, please run this script again."
    exit 1
fi
echo "✅ flyctl is installed"

# Step 2: Check authentication
echo ""
echo "Step 2: Checking authentication..."
if ! flyctl auth whoami &> /dev/null; then
    echo "🔑 Please authenticate with Fly.io:"
    echo "   flyctl auth login"
    echo ""
    echo "After authentication, please run this script again."
    exit 1
fi
echo "✅ Authenticated with Fly.io"

# Step 3: Get app name
echo ""
echo "Step 3: Choose your app name"
read -p "Enter your app name (must be globally unique): " APP_NAME

if [ -z "$APP_NAME" ]; then
    echo "❌ App name cannot be empty"
    exit 1
fi

echo "App name: $APP_NAME"

# Step 4: Update fly.toml
echo ""
echo "Step 4: Updating fly.toml..."
sed -i.bak "s/app = \".*\"/app = \"$APP_NAME\"/" fly.toml
echo "✅ Updated fly.toml with app name: $APP_NAME"

# Step 5: Build
echo ""
echo "Step 5: Building the application..."
npm run build:prod
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi
echo "✅ Build successful"

# Step 6: Deploy
echo ""
echo "Step 6: Deploying to Fly.io..."
echo "This will create the app if it doesn't exist..."

flyctl launch --no-deploy --name "$APP_NAME" --region lax
if [ $? -eq 0 ]; then
    echo "✅ App created successfully"
else
    echo "⚠️  App might already exist, continuing with deployment..."
fi

# Create volume if it doesn't exist
echo ""
echo "Creating persistent volume..."
flyctl volumes create consciousness_data --app "$APP_NAME" --size 1 --region lax || echo "⚠️  Volume might already exist"

# Deploy
echo ""
echo "Deploying application..."
flyctl deploy --app "$APP_NAME"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Deployment successful!"
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
    echo ""
    echo "🌐 Visit https://$APP_NAME.fly.dev to see your running instance!"
else
    echo "❌ Deployment failed. Please check the logs above."
    echo ""
    echo "Common issues:"
    echo "- App name already taken (try a different name)"
    echo "- Insufficient permissions"
    echo "- Network issues"
    echo ""
    echo "You can check app status with: flyctl status --app $APP_NAME"
    echo "View logs with: flyctl logs --app $APP_NAME"
    exit 1
fi
