# LibreChat Quick Configuration Guide

## 🚀 Getting Started

LibreChat is now installed and running at **http://localhost:3080**

However, before you can use it effectively, you need to complete a few configuration steps.

## 🔐 Step 1: Secure Your Installation (CRITICAL)

### Generate New Security Keys

1. Visit: https://www.librechat.ai/toolkit/creds_generator
2. Generate new values for all keys
3. Update your `.env` file with the generated values:

```bash
# Replace these default values in .env:
CREDS_KEY=<your-generated-key>
CREDS_IV=<your-generated-iv>
JWT_SECRET=<your-generated-secret>
JWT_REFRESH_SECRET=<your-generated-refresh-secret>
MEILI_MASTER_KEY=<your-generated-meili-key>
```

4. Restart LibreChat:
```bash
docker compose restart
```

## 🤖 Step 2: Configure AI Providers

LibreChat supports multiple AI providers. Configure at least one to start chatting.

### Option A: OpenAI (ChatGPT)

1. Get your API key from: https://platform.openai.com/api-keys
2. Add to `.env`:
```bash
OPENAI_API_KEY=sk-your-key-here
```

### Option B: Anthropic (Claude)

1. Get your API key from: https://console.anthropic.com/
2. Add to `.env`:
```bash
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

### Option C: Google (Gemini)

1. Get your API key from: https://makersuite.google.com/app/apikey
2. Add to `.env`:
```bash
GOOGLE_KEY=your-key-here
```

### Option D: Local Models (Ollama)

1. Install Ollama: https://ollama.ai/
2. Create or update `librechat.yaml`:
```yaml
endpoints:
  custom:
    - name: "Ollama"
      apiKey: "ollama"
      baseURL: "http://host.docker.internal:11434/v1"
      models:
        default: ["llama2", "mistral", "codellama"]
      titleConvo: true
      titleModel: "llama2"
```

### After adding API keys:
```bash
docker compose restart api
```

## 📝 Step 3: Create Your First User

### Method 1: Through Web Interface
1. Go to http://localhost:3080
2. Click "Sign up"
3. Fill in your details
4. Start chatting!

### Method 2: Through Command Line
```bash
npm run create-user
```

## ⚙️ Step 4: Optional Advanced Configuration

### Enable Email Password Reset

1. Configure email settings in `.env`:
```bash
EMAIL_SERVICE=gmail
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USERNAME=your-email@gmail.com
EMAIL_PASSWORD=your-app-password
EMAIL_FROM=noreply@librechat.ai
EMAIL_FROM_NAME=LibreChat
ALLOW_PASSWORD_RESET=true
```

### Enable Social Login (Google Example)

1. Create OAuth credentials at: https://console.cloud.google.com/
2. Add to `.env`:
```bash
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_CALLBACK_URL=/oauth/google/callback
ALLOW_SOCIAL_LOGIN=true
```

### Enable Code Interpreter

```bash
LIBRECHAT_CODE_API_KEY=your-code-api-key
```

### Enable Web Search

```bash
# Search provider
SERPER_API_KEY=your-serper-key

# Content scraper
FIRECRAWL_API_KEY=your-firecrawl-key

# Result reranker (choose one)
JINA_API_KEY=your-jina-key
# or
COHERE_API_KEY=your-cohere-key

# Enable the feature
SEARCH=true
```

## 📋 Configuration Checklist

- [ ] Generate and update security keys
- [ ] Configure at least one AI provider
- [ ] Create your first user account
- [ ] Test chat functionality
- [ ] (Optional) Configure email service
- [ ] (Optional) Enable social login
- [ ] (Optional) Set up advanced features

## 🛠️ Using the Management Script

A convenient management script has been created for you:

```bash
./manage.sh
```

This provides an interactive menu for:
- Starting/stopping services
- Viewing logs
- Creating users
- Updating LibreChat
- And more!

## 📚 Available Endpoints

After configuration, you'll have access to:

### With API Keys:
- OpenAI (GPT-4, GPT-3.5, o1, etc.)
- Anthropic (Claude Opus, Sonnet, Haiku)
- Google (Gemini Pro, Gemini Flash)
- And more based on your configuration

### Free/Local Options:
- Ollama (with local models)
- Any OpenAI-compatible API
- Custom endpoints

## 🔍 Verifying Your Setup

### 1. Check Services Status
```bash
docker compose ps
```

All services should show "Up" status.

### 2. Check Logs
```bash
docker logs LibreChat --tail 50
```

Should show:
- "Connected to MongoDB" ✓
- "Server listening on all interfaces at port 3080" ✓
- "RAG API is running and reachable" ✓

### 3. Access Web Interface
- Open: http://localhost:3080
- You should see the LibreChat login/signup page

## 🆘 Troubleshooting

### Can't access http://localhost:3080
```bash
# Check if services are running
docker compose ps

# Check logs
docker logs LibreChat

# Restart services
docker compose restart
```

### AI models not appearing
- Verify API keys are correct in `.env`
- Check logs for API connection errors
- Restart services after adding keys

### Permission errors
```bash
# Fix directory permissions
chmod -R 777 logs/ api/logs/ images/ uploads/
docker compose restart
```

### Database errors
```bash
# Check MongoDB status
docker logs chat-mongodb

# If needed, reset (WARNING: deletes all data)
docker compose down -v
docker compose up -d
```

## 📖 Next Steps

1. **Read the documentation**: https://docs.librechat.ai
2. **Explore features**: https://www.librechat.ai/docs/features
3. **Join the community**: https://discord.librechat.ai
4. **Check changelog**: https://www.librechat.ai/changelog

## 🎯 Quick Reference

### Start LibreChat
```bash
docker compose up -d
```

### Stop LibreChat
```bash
docker compose down
```

### Update LibreChat
```bash
npm run update
docker compose pull
docker compose up -d
```

### View Logs
```bash
docker logs LibreChat -f
```

### Access URL
```
http://localhost:3080
```

---

**Your LibreChat installation is ready! Complete the configuration steps above to start using it.** 🎉
