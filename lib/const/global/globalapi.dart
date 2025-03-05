class Globals {
  static String babygenerator = '5e70f4fc9emshd334e170e36833fp13f46bjsn7c053bd4b708'; // free api rapid
  static String babyllok ='KnQtx18MbmHcmeDUVJXaq2lBOIztkKQCSpgAyzGvrW77ZWsYT9rBPbD0Y5jeFOAu'; //ai lab tools
  static String agedetection ='5e70f4fc9emshd334e170e36833fp13f46bjsn7c053bd4b708'; //age detection
  static String babyname ='84eec3ae40msh180b87ede9c1cecp1176a8jsn08a2360da525'; //chatgpt api
  static String clebritydetection ='6cb139b8dfmsh5e511308a133238p19a864jsn9e3890ba2d0e'; //salibrity face api

  // Method to set an API key
  static void setApiKey(int index, String apiKey) {
    switch (index) {
      case 1:
        babygenerator = apiKey;
        break;
      case 2:
        babyllok = apiKey;
        break;
      case 3:
        agedetection = apiKey;
        break;
      case 4:
        babyname = apiKey;
        break;
      case 5:
        clebritydetection = apiKey;
        break;
      default:
        throw Exception('Invalid API key index');
    }
  }

  // Method to get an API key
  static String? getApiKey(int index) {
    switch (index) {
      case 1:
        return babygenerator;
      case 2:
        return babyllok;
      case 3:
        return agedetection;
      case 4:
        return babyname;
      case 5:
        return clebritydetection;
      default:
        throw Exception('Invalid API key index');
    }
  }
}
