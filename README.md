# golang-ecs-deployment

Generated HTTP service (`github.com/kaungmyathan18/golang-ecs-deployment`).

## Run locally

```bash
make tidy
make run
```

Live reload with [Air](https://github.com/air-verse/air) (install once: `go install github.com/air-verse/air/v2@latest`):

```bash
make dev
```

## Docker Compose

```bash
docker compose -f compose.yaml up --build
```

## CI/CD

GitHub Actions (`.github/workflows/ci.yml`) runs on push and pull requests: `go mod verify`, `go vet`, `go test`, a local **Docker** build, and **Trivy** scans (filesystem and image). [Dependabot](.github/dependabot.yml) opens weekly PRs for Go modules and Actions.

### ECS deploy

`.github/workflows/deploy-ecs.yml` is included because you enabled ECS during scaffolding. Configure **Actions** before running it:

| Kind | Name | Purpose |
|------|------|---------|
| Secret | `AWS_ROLE_ARN` | IAM role for GitHub OIDC (`sts:AssumeRoleWithWebIdentity`) |
| Variable | `AWS_REGION` | e.g. `us-east-1` |
| Variable | `ECR_REPOSITORY` | ECR repo name (not the full URI) |
| Variable | `ECS_CLUSTER` | ECS cluster name |
| Variable | `ECS_SERVICE` | ECS service name |

The workflow pushes an image tagged with the commit SHA and `:latest`, then calls `ecs update-service --force-new-deployment`. Your task definition should use the same ECR repository (typically the `:latest` tag). See [GitHub OIDC with AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services).

## Features

- Database: none
- Cache: none
- Queue: none
- Observability: structured logs (zap)
