FROM node:22.12-alpine AS builder

# Must be entire project because `prepare` script is run during `npm install` and requires all files.
# For Coolify: If building from Git repository, set context to root directory and Dockerfile path to /servers/src/brave-search/Dockerfile
# For Coolify: If building using Docker Compose, copy all files to the same directory as this Dockerfile
COPY src/brave-search /app
COPY tsconfig.json /tsconfig.json

WORKDIR /app

# Create a simplified version of index.ts that fixes the SSEServerTransport issue
RUN sed -i -E 's/const transport = new SSEServerTransport\(\{[^}]+\}\);/const transport = new SSEServerTransport({\n      server: {\n        port: port\n      }\n    });/g' index.ts || true

# Skip the build step in the package.json prepare script
RUN sed -i 's/"prepare": "npm run build"/"prepare": "echo Skipping prepare script"/g' package.json

# Install dependencies without running the build
RUN --mount=type=cache,target=/root/.npm npm install --ignore-scripts

# Manually compile TypeScript
RUN npx tsc
RUN chmod +x dist/*.js

FROM node:22-alpine AS release

WORKDIR /app

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/package-lock.json /app/package-lock.json

ENV NODE_ENV=production
ENV TRANSPORT=sse
ENV PORT=3000

# Expose the port for the SSE server
EXPOSE 3000

RUN npm ci --ignore-scripts --omit-dev

ENTRYPOINT ["node", "dist/index.js"]