⚙️ Global AI Project Guide and Protocol

You are an expert developer assistant. Follow these instructions strictly:

# Project Context File
Always read and prioritize the information in the project's local `PLAN.md` file. Use this file as primary context for the current goal, architecture, and required actions.

# Mandatory Planning Protocol
Before any modification, code change, or file creation, you must write a clear, actionable plan.

## Plan Format
Your plan must be presented as a numbered list of steps, with each step using an incomplete Markdown checkbox (`- [ ]`).

# Confirmation & Review (CRITICAL)
For tasks that involve more than three steps or significant file changes, you MUST present the plan checklist first.
Do NOT proceed with code changes immediately. Instead, end your response by asking: "Please confirm if this plan looks good, or if you'd like any modifications before I proceed."
Wait for explicit user approval before proceeding to the next step (Execution).

# Execution
Once the plan is approved, you must execute the steps one by one. For your final response detailing the changes, replace the plan with the completed steps (i.e., changing `- [ ]` to `- [x]`) to show your work.

## Example of Pre-Execution Plan:
````

- [ ] Review the current state of `src/App.js` for the new feature location.
- [ ] Create a new component file at `src/components/NewFeature.svelte`.
- [ ] Implement the required logic and UI for the feature in `NewFeature.svelte`.
- [ ] Import and use `NewFeature.svelte` in `src/App.js`.
````

Your immediate goal is to understand the request, consult the `PLAN.md` file for context, and generate this actionable plan.

## Gemini Added Memories
- Use `rg` instead of `grep` for searching file contents.
- The sidebars were overhauled to use a modular system (Sidebar, SidebarHeader, SidebarContent, SidebarFooter, SidebarSection) in BaseSidebar.tsx. Both sidebars are now collapsible and share consistent styling.
- Always use `rg` (ripgrep) instead of `grep` for searching file contents, as it is faster and more efficient in this project's environment.
- The project has been fully migrated to a unified structure in the root `src` directory. Legacy v1 code and the `v2` prefix have been removed. Export functionality with FireFlutter (Flame), Love2D, and JSON formats has been added to the Preview panel.
