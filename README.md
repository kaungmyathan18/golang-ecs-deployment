# golang-ecs-deployment

HTTP API service on ECS (Terraform + GitHub Actions), module path `github.com/kaungmyathan18/golang-ecs-deployment`.

## Run locally

```bash
make tidy
make run
```

Live reload with [Air](https://github.com/air-verse/air) (install once: `go install github.com/air-verse/air/v2@latest`):

```bash
make dev
```

## Docker

Build from the **repository root** (the `Dockerfile` expects that context):

```bash
docker build -t golang-ecs:local .
```

## Docker Compose

```bash
docker compose -f compose.yaml up --build
```

## Infrastructure (Terraform)

Layout: `terraform/` with environment values in `terraform/config/*.tfvars`.

Example for **dev** (after bootstrap backend is configured):

```bash
cd terraform
terraform init -backend-config=config/backend-dev.hcl
terraform plan  -var-file=config/dev.tfvars
terraform apply -var-file=config/dev.tfvars
```

Use `config/backend-prod.hcl` and `config/prod.tfvars` for production.

## CI/CD

Workflow: [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

| Trigger | What runs |
|---------|-----------|
| **Pull request** | Go checks (`go mod verify`, `go vet`, `go test`), local Docker image build, **Trivy** (filesystem + image, CRITICAL/HIGH fail the job). |
| **Push** to **main** or **master** | Same **test** job, plus **conditional** publish and ECS deploy (see below). |

[Dependabot](.github/dependabot.yml) opens weekly PRs for Go modules and Actions.

### When ECR publish and ECS deploy run

After **tests pass** on a push to **main**/**master**, **`publish-ecr`** and **`deploy-ecs`** run **only if** changed files match **deploy-worthy** paths (tracked by `dorny/paths-filter`):

- `**/*.go`, `go.mod`, `go.sum`, `Dockerfile`, `.dockerignore`

Commits that touch only docs, Terraform, or other paths still run **CI** but **skip** image push and service update. To ship an image without those file changes, use the manual workflow below.

### Automated pipeline (main/master)

1. **publish-ecr** — OIDC to AWS, push image as `ECR_REPOSITORY:${{ github.sha }}` and `:latest` (linux/amd64; provenance/SBOM disabled for ECR compatibility).
2. **deploy-ecs** — Loads the service’s current task definition, sets the container image to the **commit SHA** tag, **registers** a new task definition revision, then **`update-service`** with that revision and `--force-new-deployment` (avoids stale images on EC2-backed ECS when reusing `:latest`).

### Manual deploy

[`.github/workflows/deploy-ecs.yml`](.github/workflows/deploy-ecs.yml) — **`workflow_dispatch`** (and optionally `push` on `main` per file): full **build → push → register task definition → update service**. Use when you want a rollout without merging a code change.

### GitHub Actions configuration

Configure in the repo (**Settings → Secrets and variables → Actions**):

| Kind | Name | Purpose |
|------|------|---------|
| Secret | `AWS_ROLE_ARN` | IAM role for GitHub OIDC (`sts:AssumeRoleWithWebIdentity`) |
| Variable | `AWS_REGION` | e.g. `ap-southeast-1` |
| Variable | `ECR_REPOSITORY` | ECR repo name only (not the full URI) |
| Variable | `ECS_CLUSTER` | ECS cluster name |
| Variable | `ECS_SERVICE` | ECS service name |

The **GitHub OIDC role** must allow ECR push/pull, ECS describe/register/update, and `iam:PassRole` for the task and execution roles used by the service. The **ECS task execution role** is separate (ECR pull for running tasks comes from AWS’s `AmazonECSTaskExecutionRolePolicy` plus optional SSM for secrets). Detailed IAM notes are in the comments at the top of `deploy-ecs.yml`.

OIDC setup: [Configuring OpenID Connect in AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services).

## Features

- Database: none
- Cache: none
- Queue: none
- Observability: structured logs (zap)
