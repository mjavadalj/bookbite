# Design System

## Purpose

This document defines BookBite's product-wide interaction and presentation rules. Feature specifications provide feature-specific layouts, components, tokens, and measurable performance budgets.

## Experience

BookBite must feel calm, personal, warm, minimal, and trustworthy. It is a reading companion, not a productivity dashboard or social feed.

Every screen should:

- prioritize the reader's current task;
- minimize cognitive load and visual noise;
- provide clear hierarchy and navigation;
- respond immediately to input;
- preserve access to local content during background work or network failure.

## Interaction Feedback

Users must always know whether an action succeeded, is processing, failed, or can be retried.

For Bite capture:

1. confirm when the page image is durably saved;
2. allow reading to continue while OCR runs;
3. expose `processing`, `ready`, and recoverable `failed` states;
4. never imply that a pending Bite was lost.

Optimistic feedback may be used only when failure can be recovered without losing user data.

## Standard States

Every feature must define:

- initial and populated states;
- empty state with a meaningful next action;
- background-processing state;
- recoverable error state;
- offline behavior;
- unavailable external-service behavior;
- missing or deleted local-asset behavior.

Local content should remain visible during refresh. Full-screen blocking indicators should be reserved for actions that cannot safely continue.

## Visual System

Interfaces must use shared tokens for:

- color and semantic states;
- typography;
- spacing;
- shape;
- elevation;
- motion.

Components must be readable, reusable, accessible, and consistent. New patterns require a demonstrated need and must not duplicate an existing component.

Exact token values belong to the design-system implementation and must be reused by feature specifications.

## Motion

Motion must be purposeful, brief, and non-blocking. It may explain spatial change or confirm an action; it must not be decorative distraction.

Reduced-motion settings must be respected. No action or meaning may depend on an animation completing.

## Accessibility

All experiences must:

- provide correct screen-reader names, roles, states, and focus order;
- support dynamic text without hiding essential content or actions;
- meet WCAG 2.2 AA contrast expectations;
- meet platform minimum touch-target guidance;
- provide non-visual alternatives to covers, spines, decorations, color, and motion;
- remain operable with reduced motion enabled.

Accessibility is a completion criterion, not optional polish.

## Localization and Direction

English LTR and Persian RTL are first-class.

All user-facing strings must be localized. Layout, navigation direction, alignment, icons, focus order, truncation, and mixed-direction text must behave naturally in both languages.

Physical metaphors such as bookshelves and book spines must remain readable and usable in Persian, with large text, and through assistive technology.

## Calm Progression

Achievements, milestones, and ranks must support reflection without competing with books.

Do not use:

- leaderboards or competitive comparison;
- streak-loss pressure;
- shame or urgency;
- reward-first navigation;
- attention-seeking celebration.

## Feature-Specification Requirements

Each feature specification must define:

- its states and recovery paths;
- accessibility and RTL behavior;
- reduced-motion behavior;
- required design tokens and components;
- measurable interaction, rendering, and animation performance criteria.
