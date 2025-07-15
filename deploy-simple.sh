#!/bin/bash

# Simple deployment that creates the app first
echo "🧠 Simple Fly.io Deployment"
echo "=========================="

# Get app name
APP_NAME="yornoc-consciousness-bridge-218"

echo "📦 Building..."
npm run build:prod

echo "🚀 Creating app and deploying..."
flyctl launch --name "$APP_NAME" --region lax

echo "✅ Done! Your app should be at: https://$APP_NAME.fly.dev"
