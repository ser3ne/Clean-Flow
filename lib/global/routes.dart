import 'dart:io';
import 'package:path_provider/path_provider.dart';

const root = '/';
const deviceprofile = '/deviceprofile';
const devicebottomsheet = '/devicebottomsheet';
const scanresult = '/scanresult';

class FilePath {
  Future<File> get _localFile async {
    final directory = await getApplicationCacheDirectory();

    print("===============");
    print("File ath ${directory.path}");
    print("===============");

    return File('${directory.path}/remoteId.txt');
  }

  Future<void> saveDeviceId(String remoteId) async {
    final file = await _localFile;
    await file.writeAsString(remoteId);
  }
}
