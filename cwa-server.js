#!/usr/bin/env node

// CWA MCP Server - Simple standalone implementation
// This provides access to the Taiwan Central Weather Administration (CWA) API through the MCP protocol

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { 
  ListToolsRequestSchema, 
  CallToolRequestSchema 
} from '@modelcontextprotocol/sdk/types.js';
import axios from 'axios';

// Create server instance
const server = new Server(
  {
    name: "cwa-mcp-server",
    version: "0.1.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Taiwan county/city names
const LOCATION_NAMES = [
  '宜蘭縣', '花蓮縣', '臺東縣', '澎湖縣', '金門縣', '連江縣',
  '臺北市', '新北市', '桃園市', '臺中市', '臺南市', '高雄市',
  '基隆市', '新竹縣', '新竹市', '苗栗縣', '彰化縣', '南投縣',
  '雲林縣', '嘉義縣', '嘉義市', '屏東縣'
];

// API configuration
const API_BASE_URL = 'https://opendata.cwa.gov.tw/api/v1/rest/datastore';

// Utility function for making API requests
async function fetchCWAData(endpoint, params = {}) {
  const apiKey = process.env.CWA_API_KEY;
  
  if (!apiKey) {
    throw new Error('CWA API key not set. Set the CWA_API_KEY environment variable.');
  }

  const url = `${API_BASE_URL}/${endpoint}`;
  
  try {
    const response = await axios.get(url, {
      params: {
        ...params,
        Authorization: apiKey
      }
    });

    if (response.status !== 200) {
      throw new Error(`CWA API Error: ${response.status} ${response.statusText}`);
    }

    return response.data;
  } catch (error) {
    throw new Error(`Error fetching CWA data: ${error.message}`);
  }
}

// Define tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "get_weather_forecast",
        description: `Get Taiwan weather forecast for the next 36 hours by county/city name. Available locations: ${LOCATION_NAMES.join(', ')}`,
        inputSchema: {
          type: "object",
          properties: {
            locationName: {
              type: "string",
              description: "Taiwan county/city name in Traditional Chinese (e.g., 臺北市, 高雄市)"
            }
          },
          required: ["locationName"]
        }
      }
    ],
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  try {
    if (!request.params.arguments) {
      throw new Error("Arguments are required");
    }

    switch (request.params.name) {
      case "get_weather_forecast": {
        const { locationName } = request.params.arguments;
        
        if (!locationName) {
          throw new Error("locationName parameter is required");
        }
        
        if (!LOCATION_NAMES.includes(locationName)) {
          throw new Error(`Invalid locationName. Available options: ${LOCATION_NAMES.join(', ')}`);
        }
        
        // F-C0032-001 is the endpoint for 36-hour weather forecast
        const result = await fetchCWAData('F-C0032-001', { locationName });
        
        return {
          content: [{ type: "text", text: JSON.stringify(result.records, null, 2) }],
        };
      }

      default:
        throw new Error(`Unknown tool: ${request.params.name}`);
    }
  } catch (error) {
    console.error("Error:", error);
    throw new Error(`Error: ${error.message}`);
  }
});

// Start the server
async function runServer() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("CWA MCP Server running on stdio");
}

runServer().catch((error) => {
  console.error("Fatal error in main():", error);
  process.exit(1);
});
