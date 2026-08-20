# Gift Registry — Developer Guide

## Project Overview
**Stack:** Symfony 7 (PHP 8.2+), Doctrine ORM, Twig, Webpack, React (TypeScript), MobX, MUI, Bootstrap

**Structure:**
- `app/` — Symfony app, configs, PHP, tests, build scripts
- `components/` — React components, TypeScript types, entry points
- `public/` — Web root, static assets
- `migrations/` — Doctrine DB migrations
- `scripts/` — Helper scripts for PHPStan and PHPUnit

## Architecture & Patterns
- **Backend:**
	- Controllers: `src/Controller/Rest/v1` (API), `src/Controller/Web` (web)
	- DTOs/Enums: `src/DTO`, `src/Feature/*/DTO|Enum`
	- Services: auto-wired via `config/services.yaml`
	- Entities: `src/Entity/`
- **Frontend:**
	- React: loaded via `component.loader.tsx`, registered in `main.entry.tsx`
	- TypeScript types: auto-generated from PHP DTOs (`bin/generate-types`)
	- Webpack: builds to `public/assets/`

## Developer Workflows
- **Start/Build:**
	- `docker compose up -d --build` — start all services
	- `docker compose exec php bash` — enter PHP container
	- `composer install` — PHP deps
	- `yarn install` or `npm install` — JS deps
	- `yarn build` or `npm run build` — build frontend
**Testing and Type Generation:**
	_All commands below should be run inside the Docker PHP container (after `docker compose exec php bash`):_
		- `./scripts/phpunit.sh` — PHPUnit
		- `./scripts/phpstan.sh` — PHPStan static analysis
		- `php bin/generate-types` — sync PHP DTOs/Enums to TypeScript

## Production Deployment

Development uses `docker-compose.yml` plus `docker-compose.override.yml`. The
override starts the Node/Webpack watcher and the base file starts the local
MySQL service.

Production uses `docker-compose.prod.yml`. It starts only PHP and Nginx; the
database is an external MySQL server supplied through `app/.env.prod.local`.

### One-time server setup

1. Install Docker Compose, Git, and SSH access for the deployment user.
2. Clone this repository on the server.
3. Copy `app/.env.prod.local.example` to `app/.env.prod.local`.
4. Set a unique `APP_SECRET` and the external MySQL `DATABASE_URL`.
5. Configure HTTPS in front of the Nginx service.
6. Confirm the server can reach the MySQL host and that the database user has
	 only the required application privileges.

### Manual production deployment

```sh
git fetch origin main
git reset --hard origin/main
docker run --rm -v "$PWD/app:/app" -w /app node:22-alpine \
	sh -c 'npm ci && npm run build'
docker compose -f docker-compose.prod.yml build php
docker compose -f docker-compose.prod.yml up -d
docker compose -f docker-compose.prod.yml exec -T php \
	composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction
docker compose -f docker-compose.prod.yml exec -T php \
	php bin/console cache:clear --env=prod --no-debug
docker compose -f docker-compose.prod.yml exec -T php \
	php bin/console doctrine:migrations:migrate --no-interaction
```

### GitHub Actions deployment

The workflow at `.github/workflows/ci-cd.yml` runs PHPStan, PHPUnit, and the
frontend build for every pull request and push. A push to `main` deploys over
SSH after those checks pass.

Configure these secrets in the GitHub `production` environment:

- `DEPLOY_HOST`
- `DEPLOY_PORT` (optional; defaults to `22`)
- `DEPLOY_USER`
- `DEPLOY_SSH_KEY`
- `DEPLOY_PATH` (the server checkout directory)

## Conventions
- **DTOs/Enums:** Annotate PHP with `#[DTO]` or `#[DTOEnum]` for type gen
- **ArrayOf:** Use `#[ArrayOf(SomeClass::class)]` for array-typed DTOs
- **React in Twig:** Use `.react-component` and `data-component`/`data-parameters` attrs
- **Twig:** Use `loadComponent`, `loadStyles`, `loadScripts` helpers
- **Webpack:** Entry points: `main.entry.tsx`, `utils.entry.ts`

## Integration Points
- **Database:** MySQL, configured via `.env.local` and `DATABASE_URL`
- **API:** REST under `/api/v1/` (`src/Controller/Rest/v1`)
- **Assets:** Built JS/CSS in `public/assets/`, referenced in Twig

## Examples
- Add DTO: create PHP class with `#[DTO]`, run `php bin/generate-types`, import in TS
- Add React component: register in `main.entry.tsx`, mount in Twig with `.react-component`

## References
- See `app/README.md` for Symfony-specific details
- See `webpack.config.js`, `phpstan.dist.neon`, `phpunit.xml.dist` for build/test config
- See `bin/generate-types` for type sync logic