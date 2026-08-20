# React + TypeScript (TSX) Coding Standards

This document establishes the frontend engineering standards and conventions for React, TypeScript, and JSX/TSX in this repository, adhering to modern React best practices (React 18+ / 19+ functional components & hooks).

---

## 1. Automated Tooling & Formatting Commands

All formatting, linting, and type checking must be automated using standard ecosystem tooling. Whenever code is created or modified, execute the following commands:

- **Type Check (TypeScript Compiler)**:
  ```bash
  npx tsc --noEmit
  # or with pnpm:
  pnpm tsc --noEmit
  ```
- **Lint & Fix (ESLint / Biome)**:
  ```bash
  npx eslint . --ext .ts,.tsx --fix
  # or if using Biome:
  npx @biomejs/biome check --write .
  ```
- **Format Code (Prettier)**:
  ```bash
  npx prettier --write "src/**/*.{ts,tsx,css,json}"
  ```
- **Unit & Integration Tests**:
  ```bash
  # Vitest or Jest
  npm test
  # or:
  pnpm test --run
  ```

---

## 2. Naming & File Conventions

- **Component Files & Folders**:
  - Use `PascalCase` for component files and directories (e.g., `UserProfile.tsx`, `Button.tsx`, `Header/Header.tsx`).
  - Use `.tsx` extension for any file containing JSX; use `.ts` for pure TypeScript files (hooks, utils, services).
- **Custom Hooks**:
  - Always use `camelCase` with the `use` prefix (e.g., `useAuth.ts`, `useWindowSize.ts`, `useDebounce.ts`).
- **Utilities & Services**:
  - Use `camelCase` (e.g., `formatCurrency.ts`, `apiClient.ts`, `storage.ts`).
- **Component Exports**:
  - Prefer **named exports** over default exports for better IDE auto-imports and unambiguous refactoring:
    ```tsx
    // Preferred
    export const UserCard = ({ user }: UserCardProps) => { ... };

    // Avoid
    export default UserCard;
    ```

---

## 3. TypeScript & Typing Standards

- **Strict Mode & No `any`**:
  - Keep `strict: true` in `tsconfig.json`.
  - Avoid `any`. Use `unknown`, generic parameters, or explicit interfaces.
- **Component Props Typing**:
  - Always define explicit `interface` or `type` for component props:
    ```tsx
    interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
      variant?: 'primary' | 'secondary' | 'ghost';
      isLoading?: boolean;
      children: React.ReactNode;
    }

    export const Button = ({
      variant = 'primary',
      isLoading = false,
      children,
      className,
      ...rest
    }: ButtonProps) => {
      return (
        <button className={classNames('btn', variant, className)} {...rest}>
          {isLoading ? <Spinner /> : children}
        </button>
      );
    };
    ```
- **Event Handler Typing**:
  - Use standard React event types:
    ```tsx
    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
      setValue(e.target.value);
    };

    const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
      e.preventDefault();
    };
    ```
- **Discriminated Unions for Complex State**:
  ```tsx
  type RequestState<T> =
    | { status: 'idle' }
    | { status: 'loading' }
    | { status: 'success'; data: T }
    | { status: 'error'; error: Error };
  ```

---

## 4. Component Architecture & State Management

- **Single Responsibility Principle (SRP)**:
  - Separate UI presentation (stateless/visual components) from stateful business logic and side effects.
  - Extract complex state transitions, data fetching, or timers into **Custom Hooks**.
- **State Locality**:
  - Keep state as local as possible. Do not lift state up or put it in global stores unless multiple distant components genuinely need it.
- **Avoid Redundant / Derived State**:
  - Never store in `useState` values that can be computed during render from props or existing state:
    ```tsx
    // Preferred: compute on the fly (use useMemo if calculation is heavy)
    const fullName = `${firstName} ${lastName}`;
    const filteredItems = useMemo(() => items.filter(predicate), [items, predicate]);

    // Avoid: synchronizing derived state via useEffect + useState
    // const [fullName, setFullName] = useState('');
    // useEffect(() => { setFullName(`${firstName} ${lastName}`); }, [firstName, lastName]);
    ```

---

## 5. Hooks & Side Effect Discipline

- **Strict Rules of Hooks**:
  - Only call hooks at the top level of function components or custom hooks.
  - Never call hooks inside loops, conditional branches, or nested functions.
- **`useEffect` Best Practices**:
  - Do **not** use `useEffect` to respond to user interactions (handle them directly in event handlers like `onClick`/`onSubmit`).
  - Always declare an exhaustive dependency array (`react-hooks/exhaustive-deps`).
  - Always clean up asynchronous subscriptions, WebSockets, event listeners, and timers in the cleanup return function:
    ```tsx
    useEffect(() => {
      const controller = new AbortController();
      fetchData({ signal: controller.signal });
      return () => controller.abort();
    }, [fetchData]);
    ```
- **Memoization (`useCallback` / `useMemo`)**:
  - Use `useCallback` when passing functions to child components wrapped in `React.memo` or in hook dependency arrays.
  - Avoid premature optimization with unnecessary `useMemo` on cheap primitives.

---

## 6. JSX & Rendering Best Practices

- **Stable Keys in Lists**:
  - Always provide a unique, persistent key (e.g., `item.id`).
  - **Never use array index (`index`) as key** if the list can be reordered, sorted, inserted, or filtered.
- **Safe Conditional Rendering**:
  - Avoid using numeric values directly in `&&` expressions which can render `0`:
    ```tsx
    // Preferred
    {items.length > 0 && <ItemList items={items} />}
    {Boolean(count) && <Badge count={count} />}

    // Avoid (renders "0" when items.length is 0)
    {items.length && <ItemList items={items} />}
    ```
- **Fragments & Clean Hierarchy**:
  - Use Fragment shorthand `<>...</>` to group elements without injecting redundant DOM wrapper nodes.
  - Use self-closing tags `<Avatar />` when an element has no children.

---

## 7. Directory & Module Organization

- **Feature-Driven / Domain Directory Layout**:
  ```text
  src/
  ├── assets/           # Static media, icons, fonts
  ├── components/       # Shared UI components (Button, Modal, Input)
  │   └── Button/
  │       ├── Button.tsx
  │       ├── Button.test.tsx
  │       └── index.ts
  ├── features/         # Domain/feature modules (auth, dashboard, billing)
  │   └── auth/
  │       ├── components/
  │       ├── hooks/
  │       ├── services/
  │       └── types.ts
  ├── hooks/            # Global reusable custom hooks
  ├── services/         # API clients, network layer
  ├── types/            # Global TypeScript interfaces & declarations
  └── utils/            # Pure utility functions (grouped by domain)
  ```
- **Avoid "Grab-Bag" `utils.ts`**:
  - Group helpers into cohesive modules (e.g., `date.ts`, `string.ts`, `formatters.ts`).

---

## 8. File Sizing & Granularity (Non-Mandatory Recommendations)

- **Pragmatic Component Sizing**:
  - Aim for **150 ~ 350 lines** per component file.
  - If a component exceeds ~400 lines, extract sub-components or move state/effects into a custom hook (e.g., `useUserProfile.ts`).
- **High Cohesion**:
  - Keep closely related sub-components or small render helpers together if they are only used within that component. Avoid over-fragmentation into 20-line micro-files.
