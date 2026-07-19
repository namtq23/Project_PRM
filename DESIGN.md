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
