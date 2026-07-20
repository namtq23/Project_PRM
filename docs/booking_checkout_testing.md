# Booking & Checkout - Test Guide

## Scope

Module 3 covers these SRS use cases:

- Input Booking Info
- Checkout
- View Booking Result
- View Booking History and Detail
- Review Tour

The production dependency flow is:

```text
Booking views
  -> Booking ViewModels
  -> BookingRepositoryImpl
  -> BookingLocalDataSource
  -> AppDatabase (SQLite)
```

`MockBookingRepository` is no longer used. A successful checkout creates a
`pending` row in the `bookings` table. Review submission creates a row in the
`reviews` table only when the owned booking has status `completed`.

## Automated tests

Run all Booking tests:

```powershell
flutter test test/features/bookings
```

Run the entire project test suite:

```powershell
flutter test
```

Run static analysis:

```powershell
flutter analyze
```

The repository integration tests use an in-memory SQLite database. They verify:

- all five declared tables are created;
- the price is read again from the `tours` table during checkout;
- adult and child prices are calculated correctly;
- `VIETTRAVEL10` applies a 10 percent discount;
- invalid input and inactive tours are rejected;
- the booking is persisted with status `pending`;
- a review is rejected before the booking is completed;
- a completed booking can be reviewed once only.

The ViewModel tests verify:

- booking draft state survives the checkout steps;
- the promo result updates Riverpod state;
- the current user ID comes from SharedPreferences instead of a hard-coded ID;
- checkout is blocked when there is no logged-in session;
- history is loaded for the current user only.

## Manual UI flow

Before testing, the database must contain:

1. An active user whose ID is stored as `current_user_id` after login.
2. An active tour in the `tours` table.
3. A Tour Detail "Book Now" action that opens the booking route with real data:

```dart
context.push(
  RoutePaths.bookingInfo,
  extra: BookingStartArgs(
    tourId: tour.tourId!,
    basePrice: tour.price,
  ),
);
```

The Tours module is not yet connected to SQLite, so this handoff must be added by
the team member who owns Tour Detail before a full end-to-end UI test is possible.
For Booking module development, the same route also accepts query parameters:

```text
/booking/info?tourId=1&basePrice=100
```

Test the happy path:

1. Log in and open an active tour.
2. Press Book Now.
3. Enter a contact name and a 10-11 digit phone number.
4. Select a future departure date.
5. Change adult and child quantities and verify the temporary total changes.
6. Select a payment method.
7. Apply `VIETTRAVEL10` and verify a 10 percent discount.
8. Confirm payment.
9. Verify the success screen displays a `VT-XXXXXXXX` confirmation code.
10. Open My Bookings and verify the new booking appears as `pending`.
11. Open its detail screen and verify date, passenger count, payment method,
    total, status, and confirmation code.

Test validation and error flows:

- leave name or phone empty;
- enter a phone number with fewer than 10 digits;
- continue without selecting a departure date;
- continue without selecting a payment method;
- enter an invalid promo code and verify the total remains unchanged;
- deactivate the tour before confirmation and verify checkout is rejected;
- clear `current_user_id` and verify checkout/history asks the user to log in.

Test reviews:

1. Change the test booking status from `pending` to `completed` through the Admin
   module or a controlled test database update.
2. Open Booking Detail; the Review button should now be visible.
3. Submit without selecting a star and verify validation fails.
4. Select 1-5 stars, enter a comment, and submit.
5. Submit a second review for the same user and tour; it must be rejected.

## Current schema limitations

The existing database schema stores only `passenger_quantity`, not separate
adult/child counts or booking contact name/phone. Those values remain in the
Riverpod draft during checkout and cannot be reconstructed from booking history.

The existing `tours` table has no capacity or departure inventory columns.
Therefore, the SRS alternative flow "No Slots Available" cannot be implemented
correctly without a coordinated Tours schema change, such as a departure table
with date and available capacity. Do not hard-code a capacity inside Booking.

There is no promo-code table. `VIETTRAVEL10` is currently a deterministic local
business rule, not mock repository data. Move it to a promo data source when the
team adds a promo table or remote API.

Real payment gateway integration remains out of scope. Checkout persists a
`pending` booking for later Admin confirmation, matching the current course
architecture and Admin booking-status use case.
