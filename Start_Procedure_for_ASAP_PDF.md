Complete Start Procedure for ASAP PDF (Including AI)

  Prerequisites Check

  1. Ruby 3.2.2+ ✅
  2. Node.js 18.17.0+ ✅
  3. Yarn ✅
  4. PostgreSQL (must be running)
  5. Redis (must be running for Sidekiq)
  6. Docker & Docker Compose (must be running)
  7. API Keys: Anthropic Claude + Google Gemini (for AI functionality)

  Step 1: Start All Required Services

  # Start PostgreSQL and Redis
  brew services start postgresql@14
  brew services start redis

  # Verify they're running
  redis-cli ping  # Should return: PONG
  ps aux | grep postgres  # Should show postgres processes

  # Start Docker services for AI functionality
  docker compose up -d

  # Verify Docker services
  docker compose ps
  # Should show: localstack, setup, lambda_document_inference, lambda_evaluation

  Step 2: Install Dependencies

  bundle install
  yarn install

  Step 3: Database Setup

  bin/rails db:setup

  Step 4: Configure AI Services (Required for Summary/Exception Check)

  Replace YOUR_ANTHROPIC_KEY and YOUR_GEMINI_KEY with your actual API keys:

  # Set Anthropic API Key for Summary function
  docker exec asap_setup aws secretsmanager put-secret-value \
    --endpoint-url=http://localstack:4566 \
    --secret-id "/asap-pdf/production/ANTHROPIC_KEY-20250521205655572700000001" \
    --secret-string "YOUR_ANTHROPIC_KEY"

  # Set Google Gemini API Key for Summary function
  docker exec asap_setup aws secretsmanager put-secret-value \
    --endpoint-url=http://localstack:4566 \
    --secret-id "/asap-pdf/production/GOOGLE_AI_KEY-20250521205655769000000003" \
    --secret-string "YOUR_GEMINI_KEY"

  # Set Rails API credentials for Lambda communication
  docker exec asap_setup aws secretsmanager put-secret-value \
    --endpoint-url=http://localstack:4566 \
    --secret-id "/asap-pdf/production/RAILS_API_USER-20250613220933079900000001" \
    --secret-string "admin@codeforamerica.org"

  docker exec asap_setup aws secretsmanager put-secret-value \
    --endpoint-url=http://localstack:4566 \
    --secret-id "/asap-pdf/production/RAILS_API_PASSWORD-20250613220933080000000003" \
    --secret-string "password"

  # Restart Lambda containers to pick up secrets
  docker restart lambda_document_inference lambda_evaluation

  Step 5: Start Rails Application

  # Option A - All services (recommended)
  bin/dev
  # Starts: Rails server + JS/CSS builds + Sidekiq worker

  # Option B - Just Rails server
  bin/rails server

  Step 6: Test AI Functionality

  1. Visit: http://localhost:3000
  2. Login: admin@codeforamerica.org / password
  3. Navigate to any document (e.g., SLC.gov site)
  4. Test Summary: Click "Summary" button - should generate AI summary
  5. Test Exception Check: Click "Get AI Exception Check" - should generate recommendations

  Quick Status Check

  # Verify all services
  redis-cli ping                                    # Redis: PONG
  curl -f http://localhost:4566/_localstack/health  # LocalStack: {"services"...}
  curl -I http://localhost:3000                     # Rails: HTTP/1.1 302
  docker compose ps                                 # All containers running

  # Verify AI secrets configured
  docker exec asap_setup aws secretsmanager list-secrets \
    --endpoint-url=http://localstack:4566 \
    --query 'SecretList[].Name'
  # Should show 4 secrets

  Daily Workflow for Full AI Functionality

  # 1. Start all background services
  brew services start postgresql@14
  brew services start redis
  docker compose up -d

  # 2. Start Rails application
  bin/dev

  # 3. Test AI features at http://localhost:3000

  Key Point: Without the AI configuration (Step 4), the Summary and Exception Check functions will show "An error occurred" messages. The API
  keys are essential for full functionality.