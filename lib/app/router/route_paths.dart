abstract final class RoutePaths {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const search = '/search';
  static const searchResults = '/search/results';
  static const wishlist = '/wishlist';
  static const tourDetail = '/tours/:tourId';
  static const bookingInfo = '/booking/info';
  static const bookingPayment = '/booking/payment';
  static const bookingCheckout = '/booking/checkout';
  static const bookingSuccess = '/booking/success';
  static const bookingFailed = '/booking/failed';
  static const bookings = '/bookings';
  static const bookingDetail = '/bookings/:bookingId';
  static const reviewTour = '/bookings/:bookingId/review';
  static const profile = '/profile';
  static const settings = '/settings';
  static const adminDashboard = '/admin';
  static const adminTours = '/admin/tours';
  static const adminCategories = '/admin/categories';
  static const adminBookings = '/admin/bookings';
  static const adminUsers = '/admin/users';
  static const adminReviews = '/admin/reviews';
  static const adminSettings = '/admin/settings';
  static const adminAnalytics = '/admin/analytics';

  static String tourDetailFor(String tourId) => '/tours/$tourId';
  static String bookingDetailFor(String bookingId) => '/bookings/$bookingId';
}
