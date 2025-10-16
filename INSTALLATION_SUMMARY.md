# LibreChat Installation Summary

## Project Overview
**LibreChat** is an open-source AI chat platform that integrates multiple AI models including:
- OpenAI (GPT-4, GPT-3.5, o1, etc.)
- Anthropic (Claude)
- Google (Gemini)
- Azure OpenAI
- AWS Bedrock
- Local models (Ollama, etc.)
- And many more through custom endpoints

## Installation Method
**Docker-based deployment** (Recommended for production)

## Installation Date
October 14, 2025

## System Requirements Met
✅ Node.js v22.20.0
✅ npm 10.9.3
✅ Docker 28.5.1
✅ Docker Compose v2.40.0

## Installation Steps Completed

### 1. Environment Configuration
- ✅ Created `.env` file from `.env.example`
- ✅ Configured UID=501 and GID=20 for proper file permissions
- ✅ Left API keys as `user_provided` (needs configuration)

### 2. Directory Structure
Created necessary directories with proper permissions:
```
/LibreChat/
├── logs/          (chmod 777)
├── api/logs/      (chmod 777)
├── images/        (chmod 777)
├── uploads/       (chmod 777)
├── data-node/     (MongoDB data)
└── meili_data_v1.12/ (MeiliSearch data)
```

### 3. Docker Configuration
- ✅ Created `docker-compose.override.yml` to fix log volume mapping
- ✅ Pulled latest Docker images
- ✅ Started all services successfully

### 4. Services Running
All containers are up and healthy:
- ✅ **LibreChat** (API) - Port 3080
- ✅ **MongoDB** - Database
- ✅ **MeiliSearch** - Search engine
- ✅ **VectorDB** (PostgreSQL with pgvector) - Vector storage
- ✅ **RAG API** - Retrieval Augmented Generation

## Access Information
- **URL**: http://localhost:3080
- **Status**: ✅ Running and accessible

## Next Steps Required

### 1. Security Configuration (CRITICAL)
Replace the default secret values in `.env`:
```bash
CREDS_KEY=<generate-new-value>
CREDS_IV=<generate-new-value>
JWT_SECRET=<generate-new-value>
JWT_REFRESH_SECRET=<generate-new-value>
MEILI_MASTER_KEY=<generate-new-value>
```

**Tool to generate secrets**: https://www.librechat.ai/toolkit/creds_generator

### 2. AI Provider Configuration
Configure API keys for the AI providers you want to use:

**OpenAI:**
```bash
OPENAI_API_KEY=your-key-here
```

**Anthropic (Claude):**
```bash
ANTHROPIC_API_KEY=your-key-here
```

**Google (Gemini):**
```bash
GOOGLE_KEY=your-key-here
```

**Azure OpenAI:**
Create `librechat.yaml` configuration file (see docs)

### 3. Optional Configuration

**Email Service** (for password reset):
```bash
EMAIL_SERVICE=gmail
EMAIL_USERNAME=your-email
EMAIL_PASSWORD=your-app-password
ALLOW_PASSWORD_RESET=true
```

**Social Login** (OAuth):
- Configure Discord, Google, GitHub, etc.
- Set `ALLOW_SOCIAL_LOGIN=true`

**Advanced Features:**
- Code Interpreter: Add `LIBRECHAT_CODE_API_KEY`
- Web Search: Configure `SERPER_API_KEY`, `FIRECRAWL_API_KEY`, `JINA_API_KEY`
- File Storage: Configure AWS S3, Azure Blob, or Firebase

### 4. Create librechat.yaml (Optional but Recommended)
For advanced configuration, create a `librechat.yaml` file:
```bash
cp librechat.example.yaml librechat.yaml
```

Then customize endpoints, models, and features.

## Useful Commands

### Start/Stop Services
```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# Restart specific service
docker compose restart api

# View logs
docker logs LibreChat --tail 100
docker logs LibreChat -f  # follow logs

# Check status
docker compose ps
```

### User Management
```bash
# Create user
npm run create-user

# List users
npm run list-users

# Reset password
npm run reset-password

# Ban user
npm run ban-user

# Add balance (if using token system)
npm run add-balance
```

### Updates
```bash
# Update LibreChat
npm run update

# Or for deployed version
npm run update:deployed
```

## Documentation Links
- **Main Documentation**: https://docs.librechat.ai
- **Configuration Guide**: https://www.librechat.ai/docs/configuration/dotenv
- **AI Endpoints**: https://www.librechat.ai/docs/configuration/librechat_yaml/ai_endpoints
- **Features**: https://www.librechat.ai/docs/features
- **Changelog**: https://www.librechat.ai/changelog

## Current Configuration Notes

### Warnings from Logs
The following default values are being used (should be changed):
- ⚠️ CREDS_KEY - Default encryption key
- ⚠️ CREDS_IV - Default encryption IV
- ⚠️ JWT_SECRET - Default JWT secret
- ⚠️ JWT_REFRESH_SECRET - Default refresh token secret

### Config Version
- Current: undefined
- Latest: 1.3.0
- Action: Create or update `librechat.yaml` to use latest features

### Missing Configuration
- ⚠️ No `librechat.yaml` file (optional but recommended for advanced features)
- ⚠️ No AI API keys configured (required to use AI models)

## Troubleshooting

### If containers fail to start:
1. Check logs: `docker logs LibreChat`
2. Ensure directories have correct permissions
3. Verify .env file is properly configured
4. Check port 3080 is not already in use

### Permission Issues:
```bash
# Fix permissions
chmod 777 logs/ images/ uploads/
chmod -R 777 api/logs/
```

### Database Issues:
```bash
# Reset MongoDB
docker compose down -v  # WARNING: This deletes all data
docker compose up -d
```

## Installation Success Checklist
- ✅ Docker images pulled
- ✅ All containers running
- ✅ Server accessible at http://localhost:3080
- ✅ MongoDB connected
- ✅ MeiliSearch indexes created
- ✅ RAG API reachable
- ⚠️ Security keys need to be changed
- ⚠️ AI API keys need to be configured

## Support
- Discord: https://discord.librechat.ai
- GitHub Issues: https://github.com/danny-avila/LibreChat/issues
- YouTube: https://www.youtube.com/@LibreChat
