#!/bin/bash

echo "🔧 CWA MCP Server Full Installation"
echo "This script will install and configure everything you need."
echo ""

# Step 1: Make scripts executable
echo "📄 Making scripts executable..."
chmod +x cwa-server.js test.sh setup.sh

# Step 2: Install dependencies
echo "📦 Installing dependencies..."
npm install

# Step 3: Test the server
echo "🔍 Testing the server..."
./test.sh

# Step 4: Configure Claude Desktop
echo "⚙️ Configuring Claude Desktop..."
./setup.sh

echo ""
echo "🎉 Installation complete!"
echo "You now have a working CWA MCP server connected to Claude Desktop."
echo "⚠️ Make sure to edit the configuration file and add your CWA API key."
echo "Restart Claude Desktop to start using the server."
echo ""
echo "Example prompts for Claude:"
echo "- What's the current weather in 臺北市?"
echo "- How is the weather in 高雄市 today?"
echo ""
