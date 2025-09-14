# Copilot Instructions for AI Coding Agents

## Project Overview
- **Stack:** Symfony 7 (PHP 8.2+), Doctrine ORM, Twig, Webpack, React (with TypeScript), MobX, MUI, Bootstrap
- **Structure:**
  - `app/` — Main Symfony app, configs, PHP source, tests, and build scripts
  - `components/` — React components, TypeScript types, and entry points
  - `public/` — Web root, static assets
  - `migrations/` — Doctrine DB migrations
  - `scripts/` — Helper scripts for PHPStan and PHPUnit

## Key Architectural Patterns
- **Backend:**
  - Controllers in `src/Controller/Rest/v1` (API) and `src/Controller/Web` (web)
  - DTOs and Enums in `src/DTO` and `src/Feature/*/DTO|Enum`
  - Services auto-wired via `config/services.yaml`
  - Doctrine entities in `src/Entity/`
- **Frontend:**
  - React components loaded dynamically via `component.loader.tsx` and registered in `main.entry.tsx`
  - TypeScript types auto-generated from PHP DTOs using `bin/generate-types`
  - Webpack builds assets to `public/assets/`

## Developer Workflows
- **Start/Build:**
  - `docker compose up -d --build` (start all services)
  - `docker compose exec php bash` (enter PHP container)
  - `composer install` (install PHP deps)
  - `yarn install` or `npm install` (install JS deps)
  - `yarn build` or `npm run build` (build frontend assets)
- **Testing:**
  - `./scripts/phpunit.sh` (runs PHPUnit)
  - `./scripts/phpstan.sh` (runs PHPStan static analysis)
- **Type Generation:**
  - `php bin/generate-types` (sync PHP DTOs/Enums to TypeScript)

## Project-Specific Conventions
- **DTOs/Enums:** Annotate PHP classes with `#[DTO]` or `#[DTOEnum]` for type generation
- **ArrayOf:** Use `#[ArrayOf(SomeClass::class)]` for array-typed DTO properties
- **React Integration:** Use `.react-component` class and `data-component`/`data-parameters` attributes in Twig to mount React components
- **Twig:** Use `loadComponent`/`loadStyles`/`loadScripts` helpers in templates
- **Webpack:** Entry points are `main.entry.tsx` and `utils.entry.ts`

## Integration Points
- **Database:** MySQL, configured via `.env.local` and `DATABASE_URL`
- **API:** REST endpoints under `/api/v1/` (see `src/Controller/Rest/v1`)
- **Assets:** Built JS/CSS in `public/assets/`, referenced in Twig

## Examples
- To add a new DTO: create PHP class with `#[DTO]`, run `php bin/generate-types`, import in TS
- To add a React component: register in `main.entry.tsx`, mount in Twig with `.react-component`

## References
- See `README.md` and `app/README.md` for setup and structure
- See `webpack.config.js`, `phpstan.dist.neon`, `phpunit.xml.dist` for build/test config
- See `bin/generate-types` for type sync logic

---
For any unclear or missing conventions, check the referenced files or ask for clarification.