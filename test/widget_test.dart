import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniwiki/app.dart';
import 'package:uniwiki/core/services/notification_service.dart';
import 'package:uniwiki/core/widgets/custom_bottom_nav_bar.dart';

void main() {
  testWidgets('renders UniWiki and navigates to Scholarship Tracker', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UniWikiApp());
    await tester.pumpAndSettle();

    // Verify Home Screen elements
    expect(find.text('Find your right fit university'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Popular University'), findsOneWidget);

    // Tap the 'Scholarship' nav item in the bottom navigation bar
    final scholarshipTab = find.descendant(
      of: find.byType(CustomBottomNavBar),
      matching: find.byIcon(Icons.school_rounded),
    );
    expect(scholarshipTab, findsOneWidget);
    await tester.tap(scholarshipTab);
    await tester.pumpAndSettle();

    // Verify Scholarship Tracker elements
    expect(find.text('Scholarship Tracker'), findsOneWidget);
    expect(find.text('Deadlines and aid, all in one place'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Saved'), findsWidgets);
    expect(find.text('Closing Soon'), findsWidgets);

    // Verify at least one scholarship card (NUM is first with 2 days left)
    expect(find.text('NUM Young Entrepreneur Scholarship'), findsOneWidget);
    expect(find.text('30% Discount'), findsWidgets);

    // Test Apply Now interaction
    final initialNotifCount = NotificationService.instance.notifications.length;
    final applyButtons = find.text('Apply Now');
    expect(applyButtons, findsWidgets);

    await tester.tap(applyButtons.first);
    await tester.pump();

    // Verify notification was created
    expect(NotificationService.instance.notifications.length, initialNotifCount + 1);

    // Verify snackbar is displayed
    expect(find.text('Application Sent!'), findsOneWidget);

    await tester.pumpAndSettle();

    // Verify button transitioned to 'Applied'
    expect(find.text('Applied'), findsOneWidget);

    // Tapping again does not increment notification count
    await tester.tap(find.text('Applied'));
    await tester.pump();
    expect(NotificationService.instance.notifications.length, initialNotifCount + 1);
  });

  testWidgets('bookmarks university and removes it with swipe to delete', (WidgetTester tester) async {
    await tester.pumpWidget(const UniWikiApp());
    await tester.pumpAndSettle();

    // Bookmark the first university on Home
    final bookmarkBtn = find.byTooltip('Save bookmark').first;
    await tester.tap(bookmarkBtn);
    await tester.pumpAndSettle();

    // Navigate to Bookmark screen
    final bookmarkTab = find.descendant(
      of: find.byType(CustomBottomNavBar),
      matching: find.byIcon(Icons.bookmark_rounded),
    );
    await tester.tap(bookmarkTab);
    await tester.pumpAndSettle();

    // Verify card is in Bookmark screen and wrapped in Dismissible
    expect(find.byType(Dismissible), findsOneWidget);

    // Swipe card to the left to delete
    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    // Verify empty state is now displayed
    expect(find.text('No bookmarks yet'), findsOneWidget);
  });

  testWidgets('navigates to Profile screen, verifies user details and tests logout confirmation dialog', (WidgetTester tester) async {
    await tester.pumpWidget(const UniWikiApp());
    await tester.pumpAndSettle();

    // Tap on Pu Do profile header avatar on Home Screen
    final profileHeader = find.text('Pu Do');
    expect(profileHeader, findsOneWidget);
    await tester.tap(profileHeader);
    await tester.pumpAndSettle();

    // Verify Profile screen title and details
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('+855 12 345 678'), findsOneWidget);
    expect(find.text('pu.do@uniwiki.edu.kh'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Preferences & App Settings'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);

    // Scroll to Log Out button and tap it
    await tester.ensureVisible(find.text('Log Out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    // Verify logout confirmation dialog is displayed
    expect(find.text('Log Out?'), findsOneWidget);
    expect(find.text('Are you sure you want to log out of your UniWiki account?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Tap Cancel to dismiss dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify dialog is dismissed
    expect(find.text('Log Out?'), findsNothing);

    // Verify floating back button stays visible even when scrolled down
    final floatingBackBtn = find.byTooltip('Back');
    expect(floatingBackBtn, findsOneWidget);

    // Tap floating back button to return to Home
    await tester.tap(floatingBackBtn);
    await tester.pumpAndSettle();

    // Verify returned to Home screen
    expect(find.text('Find your right fit university'), findsOneWidget);
  });

  testWidgets('navigates to UniversityScreen, verifies background and unique majors, and toggles bookmark', (WidgetTester tester) async {
    await tester.pumpWidget(const UniWikiApp());
    await tester.pumpAndSettle();

    // Tap on RUPP university card on Home
    final ruppCard = find.text('Royal University of Phnom Penh');
    expect(ruppCard, findsOneWidget);
    await tester.ensureVisible(ruppCard);
    await tester.pumpAndSettle();
    await tester.tap(ruppCard);
    await tester.pumpAndSettle();

    // Verify University Screen elements
    expect(find.text('Royal University of Phnom Penh'), findsWidgets);
    expect(find.text('About University'), findsOneWidget);
    expect(find.text('Location & Campus'), findsOneWidget);
    expect(find.text('Main Campus & IFL'), findsWidgets);
    expect(find.textContaining('Russian Federation Blvd (110)'), findsOneWidget);
    expect(find.byTooltip('Copy full address'), findsOneWidget);
    expect(find.text('Offered Majors'), findsOneWidget);

    // Test copy address button
    final copyBtn = find.byTooltip('Copy full address');
    await tester.ensureVisible(copyBtn);
    await tester.pumpAndSettle();
    await tester.tap(copyBtn);
    await tester.pumpAndSettle();
    expect(find.text('Address copied to clipboard!'), findsOneWidget);

    // Verify RUPP specific majors exist
    final csMajorCard = find.text('Computer Science');
    expect(csMajorCard, findsOneWidget);
    expect(find.text('Data Science & Artificial Intelligence'), findsOneWidget);

    // Tap on Computer Science to open MajorDetailScreen
    await tester.ensureVisible(csMajorCard);
    await tester.pumpAndSettle();
    await tester.tap(csMajorCard);
    await tester.pumpAndSettle();

    // Verify MajorDetailScreen loaded with curriculum and pricing
    expect(find.text('About this Major'), findsOneWidget);
    expect(find.text('Career Pathways'), findsOneWidget);
    expect(find.text('Full-Stack Software Developer'), findsOneWidget);
    expect(find.text('Curriculum & Courses'), findsOneWidget);
    expect(find.text('CS101'), findsOneWidget);
    expect(find.text('Introduction to Computer Science & Computing'), findsOneWidget);
    expect(find.text('\$350'), findsWidgets); // Semester fee

    // Tap to expand Semester 2
    final sem2Header = find.text('Year 1 · Semester 2 (Programming Foundations)');
    await tester.ensureVisible(sem2Header);
    await tester.pumpAndSettle();
    await tester.tap(sem2Header);
    await tester.pumpAndSettle();
    expect(find.text('CS102'), findsOneWidget);
    expect(find.text('Structured Programming in C/C++'), findsOneWidget);

    // Tap Back to return to UniversityScreen
    final majorBackBtn = find.byTooltip('Back to University');
    expect(majorBackBtn, findsOneWidget);
    await tester.tap(majorBackBtn);
    await tester.pumpAndSettle();

    // Verify floating bookmark button works on UniversityScreen
    final bookmarkBtn = find.byTooltip('Bookmark university');
    expect(bookmarkBtn, findsOneWidget);
    await tester.tap(bookmarkBtn);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);

    // Tap floating back button to return to Home
    final backBtn = find.byTooltip('Back');
    expect(backBtn, findsOneWidget);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    // Tap on ITC university card on Home
    final itcCard = find.text('Institute of Technology of Cambodia');
    expect(itcCard, findsOneWidget);
    await tester.ensureVisible(itcCard);
    await tester.pumpAndSettle();
    await tester.tap(itcCard);
    await tester.pumpAndSettle();

    // Verify ITC has its own unique majors, not RUPP's
    expect(find.text('Civil & Structural Engineering'), findsOneWidget);
    final itcSoftwareMajor = find.text('Software & Network Engineering');
    expect(itcSoftwareMajor, findsOneWidget);

    // Tap on ITC Software & Network Engineering to verify school-specific curriculum
    await tester.ensureVisible(itcSoftwareMajor);
    await tester.pumpAndSettle();
    await tester.tap(itcSoftwareMajor);
    await tester.pumpAndSettle();

    // Verify ITC distinct courses (French engineering model)
    expect(find.text('Analyse Mathématique I (Differential Calculus)'), findsOneWidget);
    expect(find.text('Algorithmique & Programmation en Langage C'), findsOneWidget);
    expect(find.text('Embedded Systems Engineer'), findsOneWidget);
  });

  testWidgets('taps top major card on Home, shows all offering universities, and tapping one directs to that major', (WidgetTester tester) async {
    await tester.pumpWidget(const UniWikiApp());
    await tester.pumpAndSettle();

    // Find and scroll to Top Major section on Home Screen
    final topMajorHeader = find.text('Top Major');
    await tester.ensureVisible(topMajorHeader);
    await tester.pumpAndSettle();

    // Tap on the first Top Major card: Computer Science
    final csCard = find.text('Computer Science');
    expect(csCard, findsOneWidget);
    await tester.tap(csCard);
    await tester.pumpAndSettle();

    // Verify MajorUniversitiesScreen displays
    expect(find.text('Offering Universities'), findsOneWidget);
    expect(find.textContaining('Universities Offer This Major'), findsOneWidget);

    // Verify universities offering Computer Science are listed
    expect(find.text('Royal University of Phnom Penh'), findsOneWidget);
    expect(find.text('Paragon International University'), findsOneWidget);

    // Tap on Paragon International University to direct to its major screen
    final paragonUniCard = find.text('Paragon International University');
    await tester.ensureVisible(paragonUniCard);
    await tester.pumpAndSettle();
    await tester.tap(paragonUniCard);
    await tester.pumpAndSettle();

    // Verify directed to MajorDetailScreen for Paragon
    expect(find.text('About this Major'), findsOneWidget);
    expect(find.text('Paragon International University'), findsWidgets);
    expect(find.text('Curriculum & Courses'), findsOneWidget);
    expect(find.text('CS105'), findsOneWidget); // Paragon specific course code
    expect(find.text('Intro to Computing with Modern Python'), findsOneWidget);

    // Tap back to return to Offerings Screen
    final majorBackBtn = find.byTooltip('Back to University');
    expect(majorBackBtn, findsOneWidget);
    await tester.tap(majorBackBtn);
    await tester.pumpAndSettle();

    // Verify back on MajorUniversitiesScreen
    expect(find.text('Offering Universities'), findsOneWidget);

    // Tap back to return to Home Screen
    final offeringsBackBtn = find.byTooltip('Back to Home');
    expect(offeringsBackBtn, findsOneWidget);
    await tester.tap(offeringsBackBtn);
    await tester.pumpAndSettle();

    // Verify back on Home Screen
    expect(find.text('Find your right fit university'), findsOneWidget);
  });

  testWidgets('tests Home search, sort bottom sheet, and See All for universities, majors and categories', (WidgetTester tester) async {
    await tester.pumpWidget(const UniWikiApp());
    await tester.pumpAndSettle();

    // 1. Test Search on Home
    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);
    await tester.enterText(searchField, 'Puthisastra');
    await tester.pumpAndSettle();

    // Verify Search Results section shows 1 result
    expect(find.text('Search Results'), findsOneWidget);
    expect(find.text('1 found'), findsOneWidget);
    expect(find.text('University of Puthisastra'), findsOneWidget);

    // Clear search using the clear button in search field
    final clearSearchIcon = find.byIcon(Icons.close_rounded);
    expect(clearSearchIcon, findsWidgets);
    await tester.tap(clearSearchIcon.first);
    await tester.pumpAndSettle();

    // Verify normal sections restored
    expect(find.text('Search Results'), findsNothing);
    expect(find.text('Popular University'), findsOneWidget);

    // 2. Test Sort bottom sheet
    final sortBtn = find.byIcon(Icons.sort_rounded);
    expect(sortBtn, findsOneWidget);
    await tester.tap(sortBtn);
    await tester.pumpAndSettle();

    // Verify Sort Universities sheet
    expect(find.text('Sort Universities'), findsOneWidget);
    expect(find.text('Name: A to Z'), findsOneWidget);
    expect(find.text('Tuition: Low to High'), findsOneWidget);

    // Tap Name: A to Z
    await tester.tap(find.text('Name: A to Z'));
    await tester.pumpAndSettle();

    // Verify sort sheet closed and active sort chip is shown
    expect(find.text('Sort Universities'), findsNothing);
    expect(find.text('Name: A to Z'), findsOneWidget); // Active filter chip

    // 3. Test See All on Popular University
    final seeAllPopular = find.text('See all').first;
    await tester.ensureVisible(seeAllPopular);
    await tester.pumpAndSettle();
    await tester.tap(seeAllPopular);
    await tester.pumpAndSettle();

    // Verify AllUniversitiesScreen
    expect(find.text('All Universities'), findsOneWidget);
    expect(find.text('Showing 15 universities'), findsOneWidget);
    expect(find.text('Tuol Kouk'), findsOneWidget);

    // Return to Home
    final uniBackBtn = find.byTooltip('Back');
    await tester.tap(uniBackBtn);
    await tester.pumpAndSettle();

    // 4. Test See All on Top Major
    final seeAllTopMajor = find.text('See all').last;
    await tester.ensureVisible(seeAllTopMajor);
    await tester.pumpAndSettle();
    await tester.tap(seeAllTopMajor);
    await tester.pumpAndSettle();

    // Verify AllMajorsScreen
    expect(find.text('Explore Majors'), findsOneWidget);
    expect(find.text('Showing 10 majors'), findsOneWidget);

    // Return to Home
    final majorBackBtn = find.byTooltip('Back');
    await tester.tap(majorBackBtn);
    await tester.pumpAndSettle();
  });

  testWidgets('navigates to Comparison screen, tests searchable university selection, major pickers, and side-by-side course & tuition comparison', (WidgetTester tester) async {
    await tester.pumpWidget(const UniWikiApp());
    await tester.pumpAndSettle();

    // Tap on Compare nav item
    final compareTab = find.descendant(
      of: find.byType(CustomBottomNavBar),
      matching: find.byIcon(Icons.compare_arrows_rounded),
    );
    expect(compareTab, findsOneWidget);
    await tester.tap(compareTab);
    await tester.pumpAndSettle();

    // Verify Comparison screen elements
    expect(find.text('University & Major Compare'), findsOneWidget);
    expect(find.text('Compare courses, subjects & semester tuition side-by-side'), findsOneWidget);
    expect(find.text('Side 1'), findsOneWidget);
    expect(find.text('Side 2'), findsOneWidget);

    // Initial state is empty: no comparison is preloaded
    expect(find.text('Select Universities & Majors'), findsOneWidget);
    expect(find.text('Select University'), findsNWidgets(2));

    // 1. Select University on Side 1
    await tester.tap(find.text('Select University').first);
    await tester.pumpAndSettle();

    // Verify UniversitySearchModal is visible
    expect(find.text('Select First University'), findsOneWidget);
    expect(find.text('Type to search by name or location'), findsOneWidget);

    // Type query in university search modal
    final uniSearchField = find.byType(TextField);
    expect(uniSearchField, findsOneWidget);
    await tester.enterText(uniSearchField, 'Royal University of Phnom Penh');
    await tester.pumpAndSettle();

    // Select RUPP from list (avoiding the text inside TextField)
    final ruppOption = find.widgetWithText(InkWell, 'Royal University of Phnom Penh');
    expect(ruppOption, findsOneWidget);
    await tester.tap(ruppOption);
    await tester.pumpAndSettle();

    // Verify RUPP is selected on Side 1
    expect(find.text('Royal University of Phnom Penh'), findsOneWidget);

    // 2. Select Major on Side 1
    await tester.tap(find.text('Select Major').first);
    await tester.pumpAndSettle();

    expect(find.text('Select Major 1'), findsOneWidget);
    final csOption = find.widgetWithText(InkWell, 'Computer Science');
    expect(csOption, findsOneWidget);
    await tester.tap(csOption);
    await tester.pumpAndSettle();

    expect(find.text('Computer Science'), findsOneWidget);

    // 3. Select University on Side 2
    await tester.tap(find.text('Select University').first); // Side 2 remains
    await tester.pumpAndSettle();

    expect(find.text('Select Second University'), findsOneWidget);
    final uniSearchField2 = find.byType(TextField);
    await tester.enterText(uniSearchField2, 'Paragon');
    await tester.pumpAndSettle();

    final paragonOption = find.widgetWithText(InkWell, 'Paragon International University');
    expect(paragonOption, findsOneWidget);
    await tester.tap(paragonOption);
    await tester.pumpAndSettle();

    // 4. Select Major on Side 2
    await tester.tap(find.text('Select Major').first);
    await tester.pumpAndSettle();

    expect(find.text('Select Major 2'), findsOneWidget);
    final paragonMajor = find.widgetWithText(InkWell, 'Computer Science & Software Development');
    expect(paragonMajor, findsOneWidget);
    await tester.tap(paragonMajor);
    await tester.pumpAndSettle();

    // Content is still hidden until "Compare Majors" is clicked
    expect(find.text('Tuition & Price Comparison'), findsNothing);

    // Tap "Compare Majors" button
    final compareButton = find.text('Compare Majors');
    expect(compareButton, findsOneWidget);
    await tester.tap(compareButton);
    await tester.pumpAndSettle();

    // Now comparison content shows!
    expect(find.text('Tuition & Price Comparison'), findsOneWidget);
    expect(find.text('Semester Curriculum Breakdown'), findsOneWidget);
    expect(find.text('CS101'), findsOneWidget); // RUPP CS course
    expect(find.text('CS105'), findsOneWidget); // Paragon CS course

    // Switch to Semester 2 via ChoiceChip
    final sem2Chip = find.text('Semester 2');
    expect(sem2Chip, findsOneWidget);
    await tester.ensureVisible(sem2Chip);
    await tester.pumpAndSettle();
    await tester.tap(sem2Chip);
    await tester.pumpAndSettle();

    // Verify Semester 2 subjects updated
    expect(find.text('CS102'), findsOneWidget);
    expect(find.text('CS106'), findsOneWidget);

    // Verify Compare Majors button remains active
    expect(find.text('Compare Majors'), findsOneWidget);
  });
}


