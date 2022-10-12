import 'package:chat_app/screens/search/searchtile.dart';
import 'package:flutter/material.dart';

class SearchList extends StatelessWidget {
  const SearchList({Key? key, required this.searchSnapshot}) : super(key: key);
  final dynamic searchSnapshot;
  @override
  Widget build(BuildContext context) {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.length,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot![index].get("name"),
                  userEmail: searchSnapshot![index].get("email"));
            },
          )
        : Container();
  }
}
