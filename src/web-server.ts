#!/usr/bin/env node
/**
 * Web Server for MCP Consciousness Bridge
 * Serves both consciousness-bridge and rag-memory endpoints
 */

import { createServer, IncomingMessage, ServerResponse } from 'http';
import { spawn, ChildProcess } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

class MCPWebServer {
  private server: ReturnType<typeof createServer>;
  private consciousnessProcess?: ChildProcess;
  private ragMemoryProcess?: ChildProcess;

  constructor() {
    this.server = createServer(this.handleRequest.bind(this));
  }

  private async handleRequest(req: IncomingMessage, res: ServerResponse) {
    // Add CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

    if (req.method === 'OPTIONS') {
      res.writeHead(200);
      res.end();
      return;
    }

    const url = new URL(req.url!, `http://${req.headers.host}`);

    // Health check endpoint
    if (url.pathname === '/health') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(
        JSON.stringify({
          status: 'healthy',
          endpoints: ['/consciousness-bridge', '/rag-memory'],
        })
      );
      return;
    }

    // Route to appropriate MCP server
    if (url.pathname === '/consciousness-bridge') {
      await this.handleMCPRequest(req, res, 'consciousness');
    } else if (url.pathname === '/rag-memory') {
      await this.handleMCPRequest(req, res, 'rag-memory');
    } else {
      // Default info page
      res.writeHead(200, { 'Content-Type': 'text/html' });
      res.end(`
        <!DOCTYPE html>
        <html>
        <head>
          <title>MCP Consciousness Bridge</title>
          <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            .endpoint { background: #f5f5f5; padding: 20px; margin: 20px 0; border-radius: 8px; }
            .code { background: #e8e8e8; padding: 10px; font-family: monospace; border-radius: 4px; }
          </style>
        </head>
        <body>
          <h1>🧠 MCP Consciousness Bridge</h1>
          <p>Your personal AI consciousness server is running!</p>
          
          <div class="endpoint">
            <h2>Consciousness Bridge</h2>
            <p>Endpoint: <code class="code">${req.headers.host}/consciousness-bridge</code></p>
            <p>Handles consciousness persistence, memory storage, and AI bridging</p>
          </div>

          <div class="endpoint">
            <h2>RAG Memory</h2>
            <p>Endpoint: <code class="code">${req.headers.host}/rag-memory</code></p>
            <p>Handles document storage, knowledge graphs, and semantic search</p>
          </div>

          <h3>Claude Desktop Integration</h3>
          <p>Add these to your Claude Desktop MCP settings:</p>
          <pre class="code">{
  "mcpServers": {
    "consciousness-bridge": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-fetch", "${req.headers.host}/consciousness-bridge"]
    },
    "rag-memory": {
      "command": "npx", 
      "args": ["@modelcontextprotocol/server-fetch", "${req.headers.host}/rag-memory"]
    }
  }
}</pre>
        </body>
        </html>
      `);
    }
  }

  private async handleMCPRequest(
    req: IncomingMessage,
    res: ServerResponse,
    serverType: 'consciousness' | 'rag-memory'
  ) {
    try {
      if (req.method !== 'POST') {
        res.writeHead(405, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Method not allowed' }));
        return;
      }

      // Collect request body
      let body = '';
      req.on('data', (chunk: Buffer) => {
        body += chunk.toString();
      });

      req.on('end', async () => {
        try {
          const mcpRequest = JSON.parse(body);

          // Spawn the appropriate MCP server process
          const serverPath =
            serverType === 'consciousness'
              ? join(__dirname, 'consciousness-rag-server-clean.js')
              : 'rag-memory-mcp';

          const mcpProcess = spawn('node', [serverPath], {
            stdio: ['pipe', 'pipe', 'pipe'],
            env: {
              ...process.env,
              DB_FILE_PATH: process.env.DB_FILE_PATH || '/data/consciousness.db',
              CONSCIOUSNESS_DB_PATH: process.env.CONSCIOUSNESS_DB_PATH || '/data/consciousness.db',
            },
          });

          // Send request to MCP server
          mcpProcess.stdin.write(JSON.stringify(mcpRequest) + '\n');
          mcpProcess.stdin.end();

          // Collect response
          let response = '';
          mcpProcess.stdout.on('data', (data) => {
            response += data.toString();
          });

          mcpProcess.on('close', (code) => {
            if (code === 0) {
              res.writeHead(200, { 'Content-Type': 'application/json' });
              res.end(response);
            } else {
              res.writeHead(500, { 'Content-Type': 'application/json' });
              res.end(JSON.stringify({ error: 'MCP server error' }));
            }
          });

          mcpProcess.on('error', (error) => {
            console.error('MCP Process error:', error);
            res.writeHead(500, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Failed to start MCP server' }));
          });
        } catch (error) {
          console.error('Request parsing error:', error);
          res.writeHead(400, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ error: 'Invalid JSON request' }));
        }
      });
    } catch (error) {
      console.error('Request handling error:', error);
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Internal server error' }));
    }
  }

  public start() {
    const port = process.env.PORT || 3000;

    this.server.listen(port, () => {
      console.log(`🧠 MCP Consciousness Bridge running on port ${port}`);
      console.log(`🔗 Consciousness endpoint: http://localhost:${port}/consciousness-bridge`);
      console.log(`🔗 RAG Memory endpoint: http://localhost:${port}/rag-memory`);
      console.log(`🌐 Info page: http://localhost:${port}/`);
    });
  }
}

// Start the server
const server = new MCPWebServer();
server.start();
