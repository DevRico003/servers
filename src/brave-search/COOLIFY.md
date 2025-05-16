# Deploying with Coolify

This guide will help you deploy the Brave Search MCP server on Coolify.

## Prerequisites

1. A Coolify instance
2. A Brave Search API key (get it from https://api-dashboard.search.brave.com/app/keys)

## Deployment Steps

### 1. Create a new service in Coolify

- Select "Docker" as the deployment method
- Select "Git Repository" as the source
- Provide your Git repository URL
- Set the build context to your repository root
- Set the Dockerfile path to `/servers/src/brave-search/Dockerfile`

### 2. Configure Environment Variables

Add the following environment variables:

- `BRAVE_API_KEY`: Your Brave Search API key
- `TRANSPORT`: Set to `sse` to use Server-Sent Events
- `PORT`: Set to `3000` (or your preferred port)

### 3. Configure Network Settings

- Expose port `3000` (or your configured port)
- If you're using a custom domain, make sure to set it up in Coolify

### 4. Health Checks (Optional)

Add a health check if desired:
- Type: HTTP
- Path: /
- Port: 3000
- Interval: 30s
- Timeout: 5s
- Retries: 3

### 5. Deployment Options

- Set "Always pull image" to true
- Set appropriate resource limits based on your server capacity

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