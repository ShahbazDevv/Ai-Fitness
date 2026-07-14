---
name: Aura Kinetic
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#e7bdb7'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#ad8883'
  outline-variant: '#5d3f3b'
  surface-tint: '#ffb4aa'
  primary: '#ffb4aa'
  on-primary: '#690003'
  primary-container: '#ff5545'
  on-primary-container: '#5c0002'
  inverse-primary: '#c0000a'
  secondary: '#ffb3ae'
  on-secondary: '#68000b'
  secondary-container: '#b2001b'
  on-secondary-container: '#ffbdb8'
  tertiary: '#c8c6c5'
  on-tertiary: '#313030'
  tertiary-container: '#929090'
  on-tertiary-container: '#2a2a2a'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdad5'
  primary-fixed-dim: '#ffb4aa'
  on-primary-fixed: '#410001'
  on-primary-fixed-variant: '#930005'
  secondary-fixed: '#ffdad7'
  secondary-fixed-dim: '#ffb3ae'
  on-secondary-fixed: '#410004'
  on-secondary-fixed-variant: '#930014'
  tertiary-fixed: '#e5e2e1'
  tertiary-fixed-dim: '#c8c6c5'
  on-tertiary-fixed: '#1b1b1b'
  on-tertiary-fixed-variant: '#474746'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 16px
  md: 24px
  lg: 32px
  xl: 48px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 80px
---

## Brand & Style
The design system embodies a premium, high-performance ethos tailored for elite fitness enthusiasts. It leverages a sophisticated **Glassmorphic** aesthetic, blending deep obsidian surfaces with vibrant, high-energy crimson accents. The goal is to evoke a sense of "technological luxury"—where AI precision meets human vitality.

The visual language is characterized by:
- **Atmospheric Depth:** Multi-layered transparency and background blurs create a physical sense of space.
- **Kinetic Energy:** The primary red gradient acts as a focal point, symbolizing heat, intensity, and progress.
- **Precision:** Ultra-refined typography and thin-line iconography signal data accuracy and professional-grade coaching.

## Colors
The palette is rooted in a "Void Black" (`#0B0B0B`) foundation to maximize contrast and reduce visual fatigue during workouts. 

- **Primary Gradient:** The transition from Deep Red to Bright Red is reserved for interactive elements and progress indicators.
- **Surface Layering:** Surfaces utilize `#1B1B1B` with 60-80% opacity and a `20px` backdrop blur to achieve the glass effect.
- **Typography Colors:** Pure White (`#FFFFFF`) ensures maximum legibility for critical data, while Muted Grey (`#A1A1A1`) provides hierarchy for secondary information.
- **Atmospheric Accents:** Subtle red glows (`rgba(255, 59, 48, 0.05)`) should be used sparingly as background "blobs" to suggest AI activity.

## Typography
This design system uses **Inter** exclusively to maintain a clean, systematic, and functional appearance. 

- **Hierarchy:** High contrast is achieved by pairing heavy weights (700-800) for headers with regular weights (400) for body text.
- **Display Text:** Use `display-lg` for primary metrics like "Heart Rate" or "Calories Burned" to create an impactful data visualization.
- **Micro-copy:** Use `label-caps` for section headers or small metadata to add a technical, dashboard-like feel.
- **Scaling:** On mobile devices, ensure headlines scale down slightly to prevent awkward line breaks in narrow cards.

## Layout & Spacing
The layout follows a **fluid grid** model with generous safe areas to maintain a premium, airy feel.

- **Grid:** Use a 12-column grid for desktop and a 4-column grid for mobile.
- **Spacing Rhythm:** An 8px-based stepping system governs all margins and padding. 
- **Card Spacing:** Internal padding for glass containers should default to `md` (24px) to allow content to breathe against blurred backgrounds.
- **Mobile Reflow:** Elements should stack vertically on mobile, with full-width buttons to ensure high hit-area targets during physical activity.

## Elevation & Depth
Depth is created through transparency and light rather than traditional drop shadows.

- **Tier 1 (Background):** Solid `#0B0B0B`.
- **Tier 2 (Cards):** 60% opacity `#1B1B1B` with a `1px` stroke of `rgba(255, 255, 255, 0.1)`. This stroke acts as a "specular highlight" on the edge of the glass.
- **Tier 3 (Modals/Overlays):** 80% opacity `#1B1B1B` with a `40px` backdrop blur.
- **Primary Shadow:** Only applied to the Primary Red Button—a soft, diffused glow using `#FF3B30` at 30% opacity with a `20px` blur to make it appear "energized."

## Shapes
The shape language is deliberately smooth and approachable, contrasting with the high-intensity color palette.

- **Standard Containers:** Use `rounded-lg` (16px) for most metric cards and content blocks.
- **Interactive Elements:** Buttons and Input fields should use `rounded-xl` (24px) or full pill-shape to feel comfortable and ergonomic.
- **Border Treatment:** Always use a subtle inner stroke on glass elements to define their boundaries against the dark background.

## Components

### Buttons
- **Primary:** Pill-shaped with the Red Gradient. White text, 700 weight. Subtle red drop-glow.
- **Secondary:** Transparent background with a `1.5px` white or grey stroke. Use `backdrop-filter: blur(10px)` for a subtle glass effect.
- **Ghost:** No background or border, purely text-based for tertiary actions.

### Cards & Containers
- **Glass Card:** `#1B1B1B` at 60% opacity. 16px corner radius. 1px stroke (white @ 10% opacity). 20px backdrop blur.
- **Metric Card:** Features a large `display-lg` number in white with a small `label-caps` description in muted grey.

### Input Fields
- **Search/Form:** Dark grey surface (`#1B1B1B`) with 40% opacity. Height: 56px. Left-aligned icons using thin-line weights. Active state should change the border color to Primary Red.

### Navigation
- **Floating Bottom Nav:** A pill-shaped glass bar. Active icons should glow slightly in primary red, while inactive icons remain muted grey.

### Specialized Components
- **Progress Rings:** Use the primary gradient for the stroke. The background path should be a dark, semi-transparent grey.
- **AI Insight Chip:** A small, high-blur glass chip with a "sparkle" icon to denote AI-generated content.