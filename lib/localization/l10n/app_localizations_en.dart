// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Book Shop';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get select => 'Select';

  @override
  String get tryAgain => 'Try again';

  @override
  String get noInternetTitle => 'No internet connection';

  @override
  String get noInternetMessage =>
      'Please check your internet connection and try again.';

  @override
  String get homeScreen => 'Home';

  @override
  String get categories => 'Categories';

  @override
  String get favorites => 'Favorites';

  @override
  String get cart => 'Cart';

  @override
  String get profil => 'Profile';

  @override
  String get newBooks => 'New Books';

  @override
  String get discountBook => 'Discounted Books';

  @override
  String get turkmenBooks => 'Turkmen Books';

  @override
  String get childrenBooks => 'Children\'s Books';

  @override
  String get bookAuthorSearch => 'Book, author...';

  @override
  String get notification => 'Notifications';

  @override
  String get searchPage => 'Search page';

  @override
  String get noResultsFound => 'Book not found!';

  @override
  String get errorMessageSearch => 'An error occurred while searching!';

  @override
  String get viewing => 'Loading...';

  @override
  String get description => 'Description';

  @override
  String get readMore => 'Read more';

  @override
  String get showLess => 'Show less';

  @override
  String get auhtorsOtherBook => 'Other books by author';

  @override
  String get productCode => 'Product code';

  @override
  String get publisher => 'Publisher';

  @override
  String get bookLanguage => 'Language';

  @override
  String get bookCover => 'Book cover';

  @override
  String get publishYear => 'Publication year';

  @override
  String get page => 'Pages';

  @override
  String get hardCover => 'Hardcover';

  @override
  String get softCover => 'Softcover';

  @override
  String get add_cart => 'Add to cart';

  @override
  String get ratingsAndComments => 'Ratings and comments';

  @override
  String get seeAll => 'See all';

  @override
  String get addComment => 'Add comment...';

  @override
  String get commentsEmpty => 'You don\'t have any ratings and comments yet';

  @override
  String get commentsEmptyHint =>
      'Please add the first rating and comment for this book!';

  @override
  String get commentsError => 'Ratings and comments could not be loaded';

  @override
  String get commentsErrorHint => 'Ratings and comments could not be loaded';

  @override
  String get commentAddedSuccessfully =>
      'Your comment has been sended successfully!';

  @override
  String get clearRating => 'Clear rating';

  @override
  String get ratingNotSelected => 'Rating not selected';

  @override
  String get commentHint => 'Write your comment!';

  @override
  String get comment => 'Your comment...';

  @override
  String get sendComment => 'Send comment';

  @override
  String get commentInfo => 'Your comment will be moderated and displayed.';

  @override
  String get commentInfoHint => 'Please don\'t forget to write your comment.';

  @override
  String get rating => 'rating';

  @override
  String get stars => 'stars';

  @override
  String get daysAgo => 'day ago';

  @override
  String get hoursAgo => 'hour ago';

  @override
  String get minutesAgo => 'minute ago';

  @override
  String get now => 'Now';

  @override
  String get writeFirstComment => 'Write the first review for this book!';

  @override
  String get cartIsEmpty => 'Your cart is empty';

  @override
  String get empty_basket => 'Your cart is empty';

  @override
  String get amount => 'Amount';

  @override
  String get totalAmount => 'Total:';

  @override
  String get acceptCart => 'Confirm cart';

  @override
  String get completeOrder => 'Complete order';

  @override
  String get yourAdress => 'Your address (Street, house, apartment...)';

  @override
  String get addressIsRequired => 'Please enter your address!';

  @override
  String get note => 'Note';

  @override
  String get priceOfBooks => 'Price of books:';

  @override
  String get subtotal => 'Subtotal:';

  @override
  String get price => 'Price';

  @override
  String get deliveryFee => 'Delivery fee:';

  @override
  String get giftPaperFee => 'Gift paper fee:';

  @override
  String get giftError => 'Error loading gift covers!';

  @override
  String get orderSuccess => 'Your order has been successfully completed!';

  @override
  String get orderSuccessTitle => 'Your order was successfully received';

  @override
  String get orderSuccessMessage =>
      'Your order has been successfully received. We will contact you soon!';

  @override
  String get goIt => 'Got it';

  @override
  String get confirmRemoveFromCart =>
      'Do you want to remove this book from your cart?';

  @override
  String get confirm => 'Confirm';

  @override
  String get giftPaper => 'Gift paper covers';

  @override
  String get chooseProvince => 'Choose province';

  @override
  String get chooseDistrict => 'Choose district';

  @override
  String get selectFirstProvince => 'Select first province';

  @override
  String get noDistrictFound => 'Districts not found!';

  @override
  String get noProvinceFound => 'Province not found!';

  @override
  String get outOfStock => 'Out of stock!';

  @override
  String get stockIsEmpty => 'Stock is empty!';

  @override
  String get productAddedToCart => 'Product successfully added to cart!';

  @override
  String get enterCouponCode => 'Please enter the coupon code!';

  @override
  String get couponDiscount => 'Coupon savings';

  @override
  String get couponUsed => 'Coupon successfully applied!';

  @override
  String get use => 'Use';

  @override
  String get orderLoading => 'Order is being processed...';

  @override
  String get favoriteIsEmpty => 'Your favorite is empty!';

  @override
  String get empty_favorites => 'Your favorites list is empty!';

  @override
  String get allBooks => 'All Books';

  @override
  String get emptyCategory => 'There are no books in this category!';

  @override
  String get myProfile => 'My profile';

  @override
  String get myOrders => 'My orders';

  @override
  String get noOrdersYet => 'You have no orders yet';

  @override
  String orderItemsCount(int count) {
    return '$count books';
  }

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get activeOrder => 'Active Order';

  @override
  String get orderHistory => 'Order History';

  @override
  String get orderReceived => 'Order received';

  @override
  String get orderDetailTitle => 'Order details';

  @override
  String get orderItems => 'Books in the order';

  @override
  String get orderStatusHistoryTitle => 'Order status history';

  @override
  String get orderTotal => 'Total';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get cancelOrderConfirmTitle => 'Cancel the order?';

  @override
  String get cancelOrderConfirmMessage =>
      'This order will be cancelled. This action cannot be undone.';

  @override
  String get cancelReasonHint => 'Reason for cancellation (optional)';

  @override
  String get orderCancelledSuccess => 'Your order has been cancelled';

  @override
  String get orderCannotBeCancelled =>
      'This order can no longer be cancelled. Please contact us.';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get sessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get orderActorUser => 'You';

  @override
  String get orderActorAdmin => 'Store';

  @override
  String get orderActorSystem => 'System';

  @override
  String get aboutUs => 'About us';

  @override
  String get privacy => 'Privacy policy';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get contact => 'Contact';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get rules => 'Terms and conditions';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutDescription => 'Do you want to sign out?';

  @override
  String get loading => 'Loading...';

  @override
  String get areYouSure => '';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountDescription =>
      'Are you sure you want to delete your account? This action cannot be undone!';

  @override
  String get personal_information => 'Personal information';

  @override
  String get change_password => 'Change password';

  @override
  String get name => 'Name';

  @override
  String get surname => 'Surname';

  @override
  String get your_phone_number => 'Phone number';

  @override
  String get your_email_adress => 'E-mail';

  @override
  String get password => 'Password';

  @override
  String get old_password => 'Old password';

  @override
  String get new_password => 'New password';

  @override
  String get birthday => 'Birthday';

  @override
  String get profileUpdatedSuccessfully =>
      'Your profile has been updated successfully!';

  @override
  String get coupon => 'Coupon';

  @override
  String get get_coupon =>
      'Invite your friends and receive a 5% discount coupon';

  @override
  String get youDonHaveAnyCoupons => 'You don\'t have any coupons yet';

  @override
  String get earnCoupon => 'You can earn coupons by inviting your friends!';

  @override
  String get couponError => 'Coupons could not be loaded';

  @override
  String get invalidCoupon => 'Invalid coupon code!';

  @override
  String get couponCode => 'Coupon code';

  @override
  String get discountRate => 'Discount rate';

  @override
  String get active => 'Active';

  @override
  String get passive => 'Passive';

  @override
  String get couponTypeHoliday => 'Holiday';

  @override
  String get couponTypeBirthday => 'Birthday';

  @override
  String get couponTypeOther => 'Other';

  @override
  String get created => 'Created date:';

  @override
  String get couponCopied => 'Coupon code copied!';

  @override
  String get couponNotAllowedWithBookDiscount =>
      'Coupons cannot be used for books that are on sale.';

  @override
  String get contact_information => 'Contact us';

  @override
  String get our_phone_number => 'Phone number';

  @override
  String get email_address => 'E-mail';

  @override
  String get instagram => 'Instagram';

  @override
  String get tiktok => 'TikTok';

  @override
  String get sendMessage => 'Send message';

  @override
  String get messageSentSuccessfully =>
      'Your message has been sent successfully!';

  @override
  String get messageCannotBeEmpty => 'Message cannot be empty!';

  @override
  String get contactHint =>
      'If you have any questions or suggestions, please write to us!';

  @override
  String get contactResponse =>
      'We will answer your message as soon as possible after receiving your message.';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get invalidCredentials => 'Incorrect phone number or password';

  @override
  String stockLimit(int count) {
    return 'Not enough stock. You can add at most $count.';
  }

  @override
  String get errorMessage => 'An error occurred!';

  @override
  String get notificationIsEmpty => 'No notifications!';

  @override
  String get notificationIsEmptyDescription => 'No notifications for now';

  @override
  String get logout => 'Do you want to logout?';

  @override
  String get registerOderSignUp => 'Sign in or create an account';

  @override
  String get register => 'Create an account';

  @override
  String get signIn => 'Sign in';

  @override
  String get emptyFieldError => 'Field cannot be empty!';

  @override
  String get accountDeletedSuccessfully =>
      'Your account has been deleted successfully!';

  @override
  String get phoneNumberCannotBeEmpty => 'Phone number cannot be empty!';

  @override
  String get invalidPhoneNumber => 'Invalid phone number!';

  @override
  String get imageNotLoaded => 'Upload failed!';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get login => 'Login';

  @override
  String get youDontHaveAnAccount => 'You don\'t have an account?';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordHintHint => 'Password must be at least 8 characters long';

  @override
  String get doYouHaveAccount => 'Do you have an account?';

  @override
  String get referralCode => 'Referral code';

  @override
  String get birthdayHint => 'Enter your birthday';

  @override
  String get continue_button => 'Continue';

  @override
  String get forgotPasswordDescription => 'Enter your phone number';

  @override
  String get forgotPasswordDescriptionHint =>
      'We will send a 6-digit verification code to your phone number.';

  @override
  String get sendVerificationCode => 'Send verification code';

  @override
  String get newCodeSent => 'A new code has been sent.';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get dontReceiveCode => 'Don\'t receive the code?';

  @override
  String get resendCode => 'Resend code';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get newPasswordHint => 'Enter your new password';

  @override
  String get newPasswordHintHint => 'Create a strong and memorable password';

  @override
  String get confirmPassword => 'Confirm your password';

  @override
  String get confirmPasswordHint => 'Passwords do not match!';

  @override
  String get invalidCodeEntered => 'Incorrect code entered.';

  @override
  String get optional => '(Optional)';

  @override
  String get referralCodeHint =>
      'Use your friend\'s referral code and both of you will get a 5% discount coupon!';

  @override
  String get referralCodeHintHint => 'Referral code must be 6 characters long!';

  @override
  String get selectCategories => 'Select your favorite categories!';

  @override
  String get selectCategoriesHint =>
      'Select at least 3 categories to receive personalized recommendations.';

  @override
  String get selectCategoriesButton => 'Continue';

  @override
  String get categoriesNotLoaded => 'Categories not loaded.';

  @override
  String get categoryNotFound => 'Category not found.';

  @override
  String get recommendedBooks => 'Recommended books';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get updateAvailableHint =>
      'A new version of the app is available. Update now to enjoy new features, improvements, and bug fixes.';

  @override
  String get updateNow => 'Update now';

  @override
  String get later => 'Later';

  @override
  String get author => 'Author';

  @override
  String get priceRange => 'Price range';

  @override
  String get sort => 'Sort';

  @override
  String get priceAsc => 'Price ascending';

  @override
  String get priceDesc => 'Price descending';

  @override
  String get mostPurchased => 'Most purchased';

  @override
  String get authorSearch => 'Author search...';

  @override
  String get authorsSelected => 'authors selected';

  @override
  String get authorNotFound => 'Author not found';

  @override
  String get filter => 'Filter';

  @override
  String get apply => 'Apply';

  @override
  String get publisherSearch => 'Publisher search...';

  @override
  String get publishersSelected => 'publishers selected';

  @override
  String get publisherNotFound => 'Publisher not found';

  @override
  String get languagesSelected => 'languages selected';

  @override
  String get minPrice => 'Min.';

  @override
  String get maxPrice => 'Max.';

  @override
  String get priceRangeHint => 'Enter the minimum and maximum price';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get priceOnRequest => 'Price on request';

  @override
  String get specialOrderSectionTitle => 'We can bring it';

  @override
  String get specialOrderBadge => 'Can be ordered';

  @override
  String get myRequests => 'My requests';

  @override
  String get specialOrderTitle => 'Special order';

  @override
  String get createSpecialOrder => 'Place a special order';

  @override
  String get specialOrderSheetTitle => 'Bring it from abroad';

  @override
  String get specialOrderSheetInfo =>
      'Open a request — we will check the price and send you a quote.';

  @override
  String get specialOrderNoteHint => 'Your note (optional)';

  @override
  String get sendRequest => 'Send request';

  @override
  String get specialOrderRequestSent =>
      'Your request has been received. We will notify you when the quote is ready.';

  @override
  String get quantity => 'Quantity';

  @override
  String get specialOrderStatusPending => 'Pending';

  @override
  String get specialOrderStatusQuoted => 'Quote ready';

  @override
  String get specialOrderStatusApproved => 'Approved';

  @override
  String get specialOrderStatusRejected => 'Rejected';

  @override
  String get specialOrderStatusExpired => 'Expired';

  @override
  String get specialOrderStatusCancelled => 'Cancelled';

  @override
  String get specialOrderStatusUnavailable => 'Unavailable';

  @override
  String get supplyStatusTitle => 'Supply progress';

  @override
  String get supplyStatusPreparing => 'Preparing';

  @override
  String get supplyStatusOrderedAbroad => 'Ordered abroad';

  @override
  String get supplyStatusInTransit => 'In transit';

  @override
  String get supplyStatusArrived => 'Arrived';

  @override
  String requestNumber(int id) {
    return 'Request #$id';
  }

  @override
  String get activeRequest => 'Active request';

  @override
  String get requestHistory => 'Request history';

  @override
  String get emptyRequests => 'You have no requests';

  @override
  String get emptyRequestsHint =>
      'We can bring books that are out of stock from abroad.';

  @override
  String get requestNotFound => 'Request not found';

  @override
  String get deliveryMethodLabel => 'Delivery method';

  @override
  String deliveryMethodDays(int min, int max) {
    return '$min–$max days';
  }

  @override
  String get selectDeliveryMethod => 'Select a delivery method';

  @override
  String get selectBooks => 'Select books';

  @override
  String get itemUnavailable => 'Unavailable';

  @override
  String get noPriceForMethod => 'Not available with this method';

  @override
  String get adminNoteTitle => 'Note from the store';

  @override
  String quoteExpiresAt(String date) {
    return 'Quote valid until: $date';
  }

  @override
  String get quoteExpired => 'This quote has expired';

  @override
  String get productsTotal => 'Books total';

  @override
  String get approveQuote => 'Approve';

  @override
  String get rejectQuote => 'Reject';

  @override
  String get cancelRequest => 'Cancel request';

  @override
  String get rejectQuoteConfirmTitle => 'Reject this quote?';

  @override
  String get rejectQuoteConfirmMessage =>
      'This quote will be rejected. This action cannot be undone.';

  @override
  String get cancelRequestConfirmTitle => 'Cancel this request?';

  @override
  String get cancelRequestConfirmMessage =>
      'This request will be cancelled. This action cannot be undone.';

  @override
  String get quoteRejectedSuccess => 'Quote rejected';

  @override
  String get requestCancelledSuccess => 'Your request has been cancelled';

  @override
  String get requestActionNotAllowed => 'This action is no longer possible.';

  @override
  String get selectAtLeastOneBook => 'Select at least one book';

  @override
  String get estimatedArrival => 'Estimated arrival';

  @override
  String get specialOrderNoCoupon =>
      'Coupons cannot be used for special orders';

  @override
  String get bookAlreadyInOpenRequest =>
      'This book is already in one of your open requests';

  @override
  String get bookNotSpecialOrderable => 'This book cannot be ordered specially';

  @override
  String get specialOrderCreateFailed =>
      'The request could not be created. Please try again later.';
}
