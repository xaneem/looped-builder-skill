# Dark Mode - Implementation Plan

## Overview

Add dark mode toggle with system preference detection and localStorage persistence.

---

## Phase 1: Codebase Exploration

- [ ] **Explore existing styling architecture**
  - Find where global styles are defined
  - Identify if CSS custom properties are already in use
  - Find the main CSS entry point

  **Findings:**
  <!-- Claude fills this in during execution -->

- [ ] **Explore navigation component**
  - Find the navigation/header component
  - Understand how other nav items are structured
  - Identify where to add the toggle

  **Findings:**
  <!-- Claude fills this in during execution -->

- [ ] **Explore app initialization**
  - Find where the app bootstraps
  - Identify how to apply theme before first render
  - Check for existing localStorage usage patterns

  **Findings:**
  <!-- Claude fills this in during execution -->

---

## Phase 2: Implementation - CSS Foundation

- [ ] **Create theme color tokens**
  - Define CSS custom properties for light theme colors
  - Include: background, text, borders, accents
  - Add to global stylesheet

  **Implementation:**
  <!-- Claude fills this in during execution -->

- [ ] **Add dark theme overrides**
  - Create dark theme color values
  - Apply when `[data-theme="dark"]` on root element
  - Ensure all semantic tokens have dark variants

  **Implementation:**
  <!-- Claude fills this in during execution -->

- [ ] **Update existing components to use tokens**
  - Replace hardcoded colors with CSS variable references
  - Start with main layout components
  - Verify no hardcoded colors remain in critical UI

  **Implementation:**
  <!-- Claude fills this in during execution -->

---

## Phase 3: Implementation - Theme Logic

- [ ] **Create theme utility module**
  - Function to get current theme from localStorage
  - Function to get system preference
  - Function to apply theme to document
  - Function to save preference

  **Implementation:**
  <!-- Claude fills this in during execution -->

- [ ] **Add theme initialization script**
  - Add inline script to head to prevent flash
  - Script reads preference and applies theme before render
  - Handle localStorage unavailability gracefully

  **Implementation:**
  <!-- Claude fills this in during execution -->

---

## Phase 4: Implementation - Toggle UI

- [ ] **Create ThemeToggle component**
  - Toggle switch with sun/moon icons
  - Accessible label for screen readers
  - Calls theme utility on change

  **Implementation:**
  <!-- Claude fills this in during execution -->

- [ ] **Add toggle to navigation**
  - Import ThemeToggle component
  - Place in appropriate location in nav
  - Ensure consistent styling with other nav items

  **Implementation:**
  <!-- Claude fills this in during execution -->

---

## Phase 5: Implementation - System Preference Sync

- [ ] **Add system preference listener**
  - Listen for `prefers-color-scheme` media query changes
  - Only apply if user hasn't set manual preference
  - Update UI toggle state accordingly

  **Implementation:**
  <!-- Claude fills this in during execution -->

---

## Phase 6: Testing & Verification

- [ ] **Build and verify no compilation errors**
  - Run: `npm run build`
  - Verify clean build output

  **Result:**
  <!-- Claude fills this in during execution -->

- [ ] **Test toggle functionality**
  - Click toggle, verify theme changes
  - Refresh page, verify preference persists
  - Open new tab, verify preference syncs

  **Result:**
  <!-- Claude fills this in during execution -->

- [ ] **Test system preference behavior**
  - Clear localStorage
  - Change system preference
  - Verify app follows system preference

  **Result:**
  <!-- Claude fills this in during execution -->

- [ ] **Verify no flash of wrong theme**
  - Set dark mode preference
  - Hard refresh the page
  - Verify no white flash before dark theme applies

  **Result:**
  <!-- Claude fills this in during execution -->

---

## Notes

### Build Commands
```bash
npm install
npm run dev    # Development
npm run build  # Production build
```

### Key Files
<!-- Populated during exploration phase -->

### Design Decisions
<!-- Document any important decisions made during implementation -->
