import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:music_app/presentation/pages/search_page.dart';
import 'package:music_app/presentation/widgets/appbar_search_button.dart';
import 'package:music_app/presentation/widgets/tite_description_widget.dart';


final Finder backButton = find.byTooltip("Back").last;
final Finder buttonAppbarSearch = find.byType(AppbarSearchButton);



void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const String searchFieldText="Eminem";
  const String albumName ="Park";

  testWidgets("e2e test of Music app", (WidgetTester tester) async {
    app.main();
    await searchForAlbum(tester, searchFieldText);
    await OpenLastAlbumSearchResultPage(tester,albumName);
    await tapFirstFavouriteButton(tester);
    await verifyAlbumDetailsPageDisplayed(tester);
    await clickOnTheBackButtonOnTop(tester);
    await clickOnTheBackButtonOnTop(tester);

  });

}

 OpenLastAlbumSearchResultPage(WidgetTester tester,String songName)
async {
  await tester.pumpAndSettle();
  final Finder searchText = find
      .textContaining(songName)
      .last;
  await tester.tap(searchText);
  await tester.pumpAndSettle();
}
  tapFirstFavouriteButton(WidgetTester tester)
  async {
  final Finder favouriteButton = find.byType(FavoriteButton).first;

  await tester.tap(favouriteButton);
  await tester.pumpAndSettle();
  final Finder albumWidget = find.byKey(const ValueKey('AlbumWidgetText')).first;
  String favAlbumName =find.descendant(of: albumWidget, matching: find.byType(RichText)).toString();
  tester.printToConsole(favAlbumName);
  await tester.tap(albumWidget);
  await tester.pumpAndSettle();
  await tester.tap(backButton);
}

searchForAlbum(WidgetTester tester,String searchFieldText) async{
  await tester.pumpAndSettle();
  await tester.tap(buttonAppbarSearch);
  await tester.pumpAndSettle();
  final Finder fieldSearch = find.byType(TextField);
  await tester.enterText(fieldSearch, searchFieldText);
  await tester.tap(buttonAppbarSearch);
  await tester.pumpAndSettle();
  final Finder searchResult = find.byType(ArtistWidget).first;
  final List<Widget> resultList=tester.widgetList(searchResult).toList();
  assert(resultList.isNotEmpty);
}

verifyAlbumDetailsPageDisplayed(WidgetTester tester) async{
  await tester.pumpAndSettle();
  final Finder albumWidget = find.byKey(const ValueKey('AlbumWidgetText')).first;
  await tester.tap(albumWidget);
  await tester.pumpAndSettle();
 final Finder titles = find.byType(TitleDescriptionWidget);
  expect(titles, findsWidgets);
  await tester.pumpAndSettle();
   tester.printToConsole("Assert Pass");
 }

clickOnTheBackButtonOnTop(WidgetTester tester)
async {
  await tester.pumpAndSettle();
  await tester.tap(backButton);
}


