import 'package:photo_manager/photo_manager.dart';

abstract class PhotoManagerUtils {
 static Future<List<AssetEntity>> loadImages() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return [];

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    final recentAlbum = albums.first;

    final recentImages = await recentAlbum.getAssetListRange(
      start: 0,
      end: 5, 
    );
return recentImages;
    
  }

}