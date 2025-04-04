#!/bin/bash

echo "🐳 Setting up CWA MCP Server with Docker..."

# Install dependencies (needed for development)
echo "📦 Installing dependencies..."
npm install

# Configure Claude Desktop
CONFIG_DIR="$HOME/.config/claude"
CONFIG_FILE="$CONFIG_DIR/claude_desktop_config.json"
MCP_CONFIG='{
  "mcpServers": {
    "cwa": {
      "command": "docker",
      "args": [
        "exec",
        "-i",
        "cwa-mcp-server",
        "node",
        "cwa-server.js"
      ]
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
else
    echo "📝 Creating Claude Desktop config file..."
    echo "$MCP_CONFIG" > "$CONFIG_FILE"
    echo "✅ Configuration created at $CONFIG_FILE"
fi

echo ""
echo "🚀 Starting Docker container..."
echo "⚠️ Make sure to edit docker-compose.yml to add your CWA API key before running Docker!"
echo ""
echo "To start the container, run:"
echo "  docker-compose up -d"
echo ""
echo "🎉 Setup complete! You can now use the CWA MCP server with Claude Desktop and Docker."
echo "ℹ️ After starting the Docker container, restart Claude Desktop to apply the changes."
