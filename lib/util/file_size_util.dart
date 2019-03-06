class FileSizeUtil {
  static String formetFileSize(int fileS) {
    String fileSizeString = "";
    String wrongSize = "0B";
    if (fileS == 0) {
      return wrongSize;
    }
    if (fileS < 1024) {
      fileSizeString = fileS.toString() + "B";
    } else if (fileS < 1048576) {
      fileSizeString = (fileS / 1024).toStringAsFixed(2) + "KB";
    } else if (fileS < 1073741824) {
      fileSizeString = (fileS / 1048576).toStringAsFixed(2) + "MB";
    } else {
      fileSizeString = (fileS / 1073741824).toStringAsFixed(2) + "GB";
    }
    return fileSizeString;
  }
}
