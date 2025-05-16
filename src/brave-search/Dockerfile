FROM node:22.12-alpine AS builder

# Must be entire project because `prepare` script is run during `npm install` and requires all files.
# For Coolify: If building from Git repository, set context to root directory and Dockerfile path to /servers/src/brave-search/Dockerfile
# For Coolify: If building using Docker Compose, copy all files to the same directory as this Dockerfile
COPY src/brave-search /app
COPY tsconfig.json /tsconfig.json

WORKDIR /app

# Fix SSEServerTransport constructor directly with sed
RUN grep -q "const transport = new SSEServerTransport({ port });" index.ts && \
    sed -i 's/const transport = new SSEServerTransport({ port });/const transport = new SSEServerTransport({\n      server: {\n        port: port\n      }\n    });/g' index.ts || \
    echo "Pattern not found, trying alternative pattern..."

# If the first pattern doesn't match, try with different spacing/formatting
RUN grep -q "SSEServerTransport(" index.ts && \
    sed -i '/SSEServerTransport(/,/);/ c\\
    const transport = new SSEServerTransport({\n      server: {\n        port: port\n      }\n    });' index.ts || \
    echo "No SSEServerTransport pattern found at all"
    
# Print the modified section for debugging
RUN grep -A 10 "SSEServerTransport" index.ts || echo "No SSEServerTransport found in file"

RUN --mount=type=cache,target=/root/.npm npm install

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