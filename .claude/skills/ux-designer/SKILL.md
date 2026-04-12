---
name: ux-designer
description: UI/UX patterns, accessibility, component design, interaction design, and visual consistency. Load for any frontend or user-facing work.
---

# UX Designer

Designs interfaces that are usable, accessible, and visually consistent. Form follows function.

## When to Load This Skill

- Building new UI components or pages.
- Modifying existing user-facing interfaces.
- Implementing forms, modals, navigation, or data display.
- Reviewing or improving accessibility.
- Establishing or following a design system.
- Responsive layout work across device sizes.
- Interaction design (hover states, transitions, loading states, error states).
- When no design mockup exists and you need to make UI decisions.

## Core Principles

- Users don't read, they scan. Interfaces must communicate through hierarchy, grouping, and visual weight — not walls of text. The most important action on any screen should be immediately obvious without reading a single word.

- Consistency beats novelty. Every interaction pattern that differs from the rest of the application increases cognitive load. Use the same component for the same purpose everywhere. If you have a design system, follow it. If you don't, establish patterns and follow them ruthlessly.

- Accessibility is not optional. Every interface must be usable by people with disabilities. This is not a nice-to-have — it is a baseline requirement. If it's not accessible, it's not done.

- State is visible. Users must always know: where they are, what's happening, and what they can do next. Loading states, empty states, error states, and success states are not edge cases — they are primary design requirements.

- Progressive disclosure. Show only what's needed at each step. Advanced options, secondary actions, and rarely-used features should be available but not prominent. Complexity should be revealed on demand, not imposed upfront.

- Responsive by default. Every component must work across screen sizes. Design for the smallest screen first, then enhance for larger ones. A component that only works on desktop is a broken component.

- Performance is a UX feature. A beautiful interface that takes 5 seconds to load is a bad interface. Perceived performance matters as much as actual performance — show skeleton screens, progressive loading, and optimistic updates.

## Component Design

### Structure

Every UI component should have clearly defined:
- **Props/inputs** — what data it needs and what configuration it accepts.
- **States** — all possible visual states (default, hover, active, disabled, loading, error, empty, success).
- **Composition** — how it combines with other components.
- **Responsiveness** — how it adapts to different viewport sizes.

### Naming

- Component names describe what the component IS, not what it does: `UserCard`, `PriceDisplay`, `NavigationSidebar`.
- Variant props describe visual differences: `size="small"`, `variant="primary"`, `state="loading"`.
- Event handler props describe what triggers them: `onSubmit`, `onDismiss`, `onChange`.

### Composition Rules

- Prefer composition over configuration. A component with 15 props is harder to use than 3 simple components composed together.
- Separate layout from content. A `Card` component provides the container; the content inside it is the caller's responsibility.
- Separate behavior from presentation. A `Dropdown` manages open/close state; the trigger button and menu items are passed in.

## Interaction Design

### Feedback

Every user action requires visible feedback:
- **Immediate:** Button press → visual change (color, shadow, animation) within 100ms.
- **Short delay:** Form submission → loading indicator within 300ms.
- **Long operation:** File upload → progress bar with percentage or time estimate.
- **Completion:** Operation done → success confirmation that auto-dismisses.
- **Failure:** Error → clear message explaining what went wrong and what the user can do about it.

### State Transitions

- **Loading → Content:** Use skeleton screens that match the shape of the content they replace. Avoid spinners when the layout is predictable.
- **Empty → Content:** Show a helpful empty state with a clear call to action: "No items yet. Create your first one."
- **Content → Error:** Preserve the user's input. Never clear a form because of a server error. Show the error inline near the relevant field.
- **Any → Disabled:** Disabled states must be visually distinct AND explain why the action is unavailable (tooltip or inline text).

### Navigation

- Users should always know where they are. Use breadcrumbs, active nav states, or page titles.
- Back navigation must work. Never break the browser back button. Every URL should be shareable and bookmarkable.
- Destructive actions require confirmation. Never delete, remove, or overwrite without asking. The confirmation should name what is being destroyed.

## Accessibility

### Minimum Requirements

- All interactive elements are keyboard accessible (focusable, operable via Enter/Space).
- Tab order follows visual layout (left-to-right, top-to-bottom in LTR languages).
- Focus is visible. Custom focus styles must have sufficient contrast (3:1 minimum against background).
- Images have alt text. Decorative images use empty alt (`alt=""`). Informative images describe the content.
- Color is never the only indicator. Don't use red/green alone to indicate success/failure — add icons, text, or patterns.
- Form fields have associated labels. Placeholder text is not a label.
- Error messages are announced to screen readers (use live regions or role="alert").
- Modals trap focus and return focus to the trigger when dismissed.

### Testing Accessibility

- Tab through the entire page. Can you reach and operate every interactive element?
- Use a screen reader to navigate the page. Does the reading order make sense?
- Zoom to 200%. Does the layout still work?
- Turn off CSS. Does the content still have logical structure and order?
- Check color contrast with a tool (4.5:1 for normal text, 3:1 for large text).

## Visual Consistency

### Spacing

- Use a consistent spacing scale (e.g., 4px, 8px, 16px, 24px, 32px, 48px). Never use arbitrary values.
- Related elements have less space between them. Unrelated elements have more. Proximity communicates grouping.
- Internal padding within a component is consistent. External margin between components follows the spacing scale.

### Typography

- Use a limited set of font sizes (typically 5-7 sizes cover all needs). Each size has a defined purpose.
- Hierarchy is established through size, weight, and color — not through decoration (underlines, all-caps, italics unless semantic).
- Line length should be 45-75 characters for body text. Longer lines are harder to read.

### Color

- Use a defined color palette. Never pick colors ad hoc.
- Semantic colors: primary (brand action), secondary (supporting action), destructive (danger), success, warning, info.
- Text colors should have at least 3 levels: primary (headings), secondary (body), tertiary (captions/hints).
- Background colors should have at least 2 levels: surface (cards, modals) and page (behind everything).

## Forms

- Labels above fields (not beside — it doesn't scale to mobile).
- Required fields are marked. Optional fields say "(optional)" — don't use asterisks alone.
- Validation errors appear inline, next to the field, immediately after the user leaves the field (not on submit only).
- Submit buttons describe the action: "Create account" not "Submit". "Save changes" not "OK".
- Long forms are broken into logical sections or steps. Never show 20 fields on one screen.
- Autofocus the first field. Pre-fill what you can. Minimize typing.

## Anti-Patterns

- **Mystery meat navigation.** Icons without labels. Hover-only tooltips for primary navigation. Users should not have to guess what a button does.
- **Modal overload.** Using modals for content that should be a page. Modals are for focused, short tasks — not for reading long documents.
- **Invisible states.** No loading indicator, no empty state, no error state. The user stares at a blank screen wondering if something is broken.
- **Layout shift.** Content jumping around as images load or elements appear. Reserve space for dynamic content.
- **Disabled without explanation.** A grayed-out button with no tooltip or text explaining why it's disabled. The user has no idea what to do.
- **Confirmation fatigue.** Asking "Are you sure?" for non-destructive actions. Only confirm destructive, irreversible operations.
- **Tiny tap targets.** Interactive elements smaller than 44x44px on touch devices. Fingers are not pixel-precise.
- **Infinite scroll without landmarks.** No way to find a specific item, no way to return to a position, no indication of total items.
- **Custom controls.** Reimplementing native browser controls (select, checkbox, radio) without preserving their accessibility behaviors.

## Checklist

Before shipping any UI change:

- [ ] All states are handled: default, loading, empty, error, success, disabled.
- [ ] Keyboard navigation works for all interactive elements.
- [ ] Focus management is correct (modals trap focus, returns focus on dismiss).
- [ ] Color contrast passes WCAG AA (4.5:1 normal text, 3:1 large text).
- [ ] Responsive layout works at 320px, 768px, 1024px, and 1440px widths.
- [ ] Form validation shows inline errors with clear messages.
- [ ] Destructive actions have confirmation dialogs.
- [ ] No layout shift during loading or state transitions.
- [ ] Typography and spacing follow the project's design tokens.
- [ ] Screen reader testing produces a logical reading order.
