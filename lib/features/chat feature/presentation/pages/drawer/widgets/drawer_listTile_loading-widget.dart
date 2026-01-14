import 'package:flutter/cupertino.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DrawerListTileLoadingWidget extends StatelessWidget {
  const DrawerListTileLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 5),
          child: CupertinoListTile(
            title: Skeletonizer(child: Text('Hi there How are you?')),
          ),
        );
      },
    );
  }
}
