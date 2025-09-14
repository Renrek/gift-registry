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
- **Testing:**
	- `./scripts/phpunit.sh` — PHPUnit
	- `./scripts/phpstan.sh` — PHPStan static analysis
- **Type Generation:**
	- `php bin/generate-types` — sync PHP DTOs/Enums to TypeScript

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