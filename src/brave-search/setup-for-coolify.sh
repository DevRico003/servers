#!/bin/bash
set -e

# Create a self-contained package for Coolify deployment
echo "Creating standalone package for Coolify deployment..."

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Working in temporary directory: $TEMP_DIR"

# Copy necessary files
cp -r . $TEMP_DIR

# Create a simplified package.json
cat > $TEMP_DIR/package.json << EOF
{
  "name": "brave-search-mcp-server",
  "version": "0.6.2",
  "description": "MCP server for Brave Search API integration",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc && chmod +x dist/*.js",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "1.0.1"
  },
  "devDependencies": {
    "@types/node": "^22",
    "typescript": "^5.6.2"
  }
}
EOF

# Create tsconfig.json
cat > $TEMP_DIR/tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "esModuleInterop": true,
    "outDir": "./dist",
    "strict": true,
    "skipLibCheck": true
  },
  "include": ["*.ts"],
  "exclude": ["node_modules"]
}
EOF

# Use the simple Dockerfile
cp Dockerfile.coolify $TEMP_DIR/Dockerfile

# Create a .dockerignore
cat > $TEMP_DIR/.dockerignore << EOF
node_modules
npm-debug.log
dist
.git
.env
EOF

echo "Package created at $TEMP_DIR"
echo "You can now use this directory for Coolify deployment"
echo "Don't forget to set BRAVE_API_KEY in your Coolify environment variables"