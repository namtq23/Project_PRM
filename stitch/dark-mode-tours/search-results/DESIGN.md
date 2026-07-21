---
name: Premium Travel Booking System
colors:
  surface: '#FFFFFF'
  surface-dim: '#d6dae0'
  surface-bright: '#f6faff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f4fa'
  surface-container: '#eaeef4'
  surface-container-high: '#e4e8ee'
  surface-container-highest: '#dee3e9'
  on-surface: '#171c20'
  on-surface-variant: '#3e4850'
  inverse-surface: '#2c3135'
  inverse-on-surface: '#edf1f7'
  outline: '#6e7881'
  outline-variant: '#bec8d2'
  surface-tint: '#006591'
  primary: '#006591'
  on-primary: '#ffffff'
  primary-container: '#0ea5e9'
  on-primary-container: '#003751'
  inverse-primary: '#89ceff'
  secondary: '#006b5f'
  on-secondary: '#ffffff'
  secondary-container: '#6df5e1'
  on-secondary-container: '#006f64'
  tertiary: '#8a5100'
  on-tertiary: '#ffffff'
  tertiary-container: '#de8712'
  on-tertiary-container: '#4d2b00'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c9e6ff'
  primary-fixed-dim: '#89ceff'
  on-primary-fixed: '#001e2f'
  on-primary-fixed-variant: '#004c6e'
  secondary-fixed: '#71f8e4'
  secondary-fixed-dim: '#4fdbc8'
  on-secondary-fixed: '#00201c'
  on-secondary-fixed-variant: '#005048'
  tertiary-fixed: '#ffdcbd'
  tertiary-fixed-dim: '#ffb86e'
  on-tertiary-fixed: '#2c1600'
  on-tertiary-fixed-variant: '#693c00'
  background: '#F8FAFC'
  on-background: '#171c20'
  surface-variant: '#dee3e9'
  accent: '#F59E0B'
  success: '#22C55E'
  warning: '#F59E0B'
  danger: '#EF4444'
  text-main: '#0F172A'
  text-muted: '#64748B'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-max: 1280px
  gutter: 1rem
  margin-mobile: 1rem
  margin-desktop: 2.5rem
  unit: 4px
---

# DESIGN.md --- Tour Booking Platform

## Product Vision

Design a premium travel booking platform that feels modern, trustworthy,
and effortless. The experience should be comparable to Airbnb,
Booking.com, and Klook while remaining simple for first-time users.

## Target Platforms

-   Mobile-first
-   Responsive Web
-   Tablet support

## Design Principles

-   Clean
-   Premium
-   Minimal
-   Accessible
-   Fast
-   Consistent

## Visual Style

-   Soft rounded corners (12--16px)
-   Large destination photography
-   Spacious layout
-   Subtle shadows
-   Smooth animations (200--300ms)
-   Light mode first, Dark mode supported

## Colors

Primary: #0EA5E9 Secondary: #14B8A6 Accent: #F59E0B Success: #22C55E
Warning: #F59E0B Danger: #EF4444 Background: #F8FAFC

## Typography

Font: Inter

## Navigation

Customer Bottom Navigation - Home - Explore - Wishlist - Bookings -
Profile

Admin Sidebar - Dashboard - Tours - Categories - Bookings - Users -
Reviews - Analytics - Settings

## Core Components

-   Search Bar
-   Filter Drawer
-   Tour Card
-   Category Chip
-   Hero Banner
-   Image Carousel
-   Rating Stars
-   Price Card
-   Sticky Booking CTA
-   Stepper
-   Booking Timeline
-   Review Card
-   Empty State
-   Loading Skeleton
-   Confirmation Dialog
-   Toast Notifications

## Customer Screens

1.  Splash
2.  Login
3.  Register
4.  Forgot Password
5.  Home
6.  Search
7.  Filter
8.  Tour Detail
9.  Wishlist
10. Checkout
11. Payment
12. Booking Success
13. Booking History
14. Booking Detail
15. Profile
16. Edit Profile
17. Settings
18. Notifications
19. Reviews

### Home

Sections: - Hero Banner - Search - Categories - Featured Tours - Popular
Destinations - Recommended Tours - Promotions

### Tour Detail

Sections: - Image gallery - Title - Rating - Price - Itinerary -
Included/Excluded - Reviews - Map - Sticky "Book Now"

### Checkout

Sections: - Traveler Information - Promo Code - Payment Method - Price
Breakdown - Confirm Booking

## Admin Screens

-   Login
-   Dashboard
-   Manage Tours
-   Tour Editor
-   Categories
-   Bookings
-   Booking Detail
-   Users
-   Reviews
-   Analytics
-   System Settings

## Dashboard Widgets

-   Revenue
-   Bookings
-   Active Tours
-   New Users
-   Recent Bookings
-   Booking Chart

## UX Rules

-   Maximum 3 primary actions per screen.
-   Use skeleton loading instead of spinners where possible.
-   Always provide empty, loading, success and error states.
-   Preserve scroll position.
-   Validate forms inline.

## Accessibility

-   WCAG AA contrast
-   Keyboard navigation
-   Touch targets \>=44px
-   Visible focus states
-   Semantic labels

## Motion

-   Fade: 200ms
-   Slide: 250ms
-   Modal scale: 180ms

## Responsive

Mobile: 360--480px Tablet: 768px Desktop: 1280px+

## Inspiration

-   Airbnb
-   Booking.com
-   Klook
-   Google Material 3
-   Apple Human Interface Guidelines

## AI Instructions for Stitch

Generate a polished, production-quality UI using the above design
system. Prioritize visual consistency, premium travel imagery, intuitive
booking flow, high accessibility, reusable components, and responsive
layouts. Avoid placeholder-heavy screens; each screen should feel
realistic with sample content, charts, cards, and states.