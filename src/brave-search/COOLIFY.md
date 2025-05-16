# Deploying with Coolify

This guide will help you deploy the Brave Search MCP server on Coolify.

## Prerequisites

1. A Coolify instance
2. A Brave Search API key (get it from https://api-dashboard.search.brave.com/app/keys)

## Deployment Options

There are two methods for deployment:

### Option 1: Using the Simple Dockerfile (Recommended)

1. In Coolify, create a new service:
   - Select "Docker" as the deployment method
   - Select "Docker Compose" or "Git Repository" as the source
   - If using Git, provide your Git repository URL
   - Set the build context to your repository root
   - Set the Dockerfile path to `/servers/src/brave-search/Dockerfile.simple`

2. Configure Environment Variables:
   - `BRAVE_API_KEY`: Your Brave Search API key
   - `TRANSPORT`: Set to `sse` to use Server-Sent Events
   - `PORT`: Set to `3000` (or your preferred port)

3. Configure Network Settings:
   - Expose port `3000` (or your configured port)
   - If you're using a custom domain, set it up in Coolify

### Option 2: Using Docker Compose

1. In Coolify, create a new service:
   - Select "Docker Compose" as the deployment method
   - Use the docker-compose.yml file provided

2. Configure Environment Variables:
   - `BRAVE_API_KEY`: Your Brave Search API key (the other variables are already set in docker-compose.yml)

3. Configure Network Settings:
   - The port is already configured in the docker-compose.yml file
   - If you're using a custom domain, set it up in Coolify

## Health Checks (Optional)

Add a health check if desired:
- Type: HTTP
- Path: /
- Port: 3000
- Interval: 30s
- Timeout: 5s
- Retries: 3

## Connecting from Claude Code

Once deployed, you can connect to your MCP server using Claude Code:

```bash
claude mcp add --name brave-search --transport sse --url https://your-coolify-domain.com:3000
```

Replace `your-coolify-domain.com` with your actual Coolify domain or IP address.

## Troubleshooting

If the container keeps restarting:

1. Check Coolify logs to see the specific error
2. Verify that all environment variables are set correctly
3. Make sure port 3000 is properly exposed and not blocked by firewall
4. Check that your Brave API key is valid

If you see "stdio" in the logs, make sure that `TRANSPORT=sse` is properly set in your environment variables.