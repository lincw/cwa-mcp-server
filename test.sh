#!/bin/bash

echo "Testing CWA MCP Server..."
echo "This will run the server and show basic tool information."

# Run the server and pipe some standard JSON input to test it works
echo '{
  "jsonrpc": "2.0",
  "id": "test",
  "method": "listTools",
  "params": {}
}' | node cwa-server.js

echo "If you see tool information above, the server is working correctly!"
echo "You can now set up the server with Claude Desktop using setup.sh"
