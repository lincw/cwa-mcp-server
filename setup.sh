#!/bin/bash

echo "📡 Setting up CWA MCP Server..."

# Make the server script executable
chmod +x cwa-server.js

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Claude Desktop configuration
CONFIG_DIR="$HOME/.config/claude"
CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"
CURRENT_DIR=$(pwd)
MCP_CONFIG='{
  "mcpServers": {
    "cwa": {
      "command": "node",
      "args": [
        "'$CURRENT_DIR'/cwa-server.js"
      ],
      "env": {
        "CWA_API_KEY": "<YOUR_CWA_API_KEY>"
      }
    }
  }
}'

if [ ! -d "$CONFIG_DIR" ]; then
    echo "📁 Creating Claude Desktop config directory..."
    mkdir -p "$CONFIG_DIR"
fi

if [ -f "$CONFIG_FILE" ]; then
    echo "⚙️ Claude Desktop config file found."
    echo "📝 To manually update your configuration, add this to your $CONFIG_FILE file:"
    echo "$MCP_CONFIG"
    echo ""
    echo "⚠️ Make sure to replace <YOUR_CWA_API_KEY> with your actual CWA API key."
else
    echo "📝 Creating Claude Desktop config file..."
    echo "$MCP_CONFIG" > "$CONFIG_FILE"
    echo "✅ Configuration created at $CONFIG_FILE"
    echo ""
    echo "⚠️ Make sure to edit the config file and replace <YOUR_CWA_API_KEY> with your actual CWA API key."
fi

echo ""
echo "🎉 Setup complete! You can now use the CWA MCP server with Claude Desktop."
echo "ℹ️ To test the server, run: npm start"
echo "ℹ️ After setup, restart Claude Desktop to apply the changes."
