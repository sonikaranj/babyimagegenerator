import 'dart:convert';
import 'dart:io';
import 'package:babyimage/const/color/color.dart';
import 'package:babyimage/const/global/globalapi.dart';
import 'package:babyimage/services/BIG_press_unpress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Import for Timer
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Ads/Bannerads.dart';
import '../../Ads/ads_load_util.dart';
import '../../Ads/ads_variable.dart';
import '../../Inapppurchase/credit/BIG_creditManager.dart';
import '../../Inapppurchase/credit/BIG_cut_credit.dart';
import '../../utils/BIG_ImageUtils.dart';
import '../BIG_Homepage.dart';


class BIG_BabyNameGenerator extends StatefulWidget {
  const BIG_BabyNameGenerator({super.key});

  @override
  _BIG_BabyNameGeneratorState createState() => _BIG_BabyNameGeneratorState();
}

class _BIG_BabyNameGeneratorState extends State<BIG_BabyNameGenerator> {
  String? _selectedGender = "Boys";
  String? _selectedOrigin ='India';
  String? _selectedLetter = 'A';
  bool loading = false;
  List<String> _names = [];

  Future<void> apicall2() async {
    setState(() {
      loading = true;
    });
    print("aaaaa");
    var url = Uri.parse('https://chatgpt-42.p.rapidapi.com/chatgpt');

    var headers = {
      'Content-Type': 'application/json',
      'x-rapidapi-host': 'chatgpt-42.p.rapidapi.com/gpt4',
      'x-rapidapi-key':
          Globals.babyname, // Replace with your RapidAPI key
    };
    var body = jsonEncode(
        {
          "messages": [
            {
              "role": "user",
              "content": "Provide a list of 5 different baby $_selectedGender names starting with '$_selectedLetter', of $_selectedOrigin origin. Format the response exactly as follows: {\"result\": [{\"Name\": \"Name1\", \"Gender\": \"Female\", \"Origin\": \"British\"}, {\"Name\": \"Name2\", \"Gender\": \"Female\", \"Origin\": \"British\"}, ..., {\"Name\": \"Name10\", \"Gender\": \"Female\", \"Origin\": \"British\"}]} .. Ensure the entire response is a single JSON object string. Do not include any additional text or nesting. Just provide the list of names formatted as specified, and avoid any repetitions."

            }
          ],
          "web_access": false
        }
    );
     print(body);
    try {
      print("try");
      var response = await http.post(url, headers: headers, body: body);
      print("karan");
      print(response.body);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        String jsonString = responseBody.substring(
            responseBody.indexOf('{'), responseBody.lastIndexOf('}') + 1);

        try {
          var data = jsonDecode(jsonString);
          var innerResultString = data['result'];
          var innerResult =
              jsonDecode(innerResultString) as Map<String, dynamic>;
          var namesList = innerResult['result'] as List<dynamic>;
          List<String> names = namesList
              .map<String>((item) => item['Name'] as String)
              .toSet()
              .toList();

          setState(() {
            _names = names;
            loading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NamesListScreen(names: _names, origin: _selectedOrigin!),
            ),
          );
        } catch (e) {
          print("catch ${e}");
          setState(() {
            loading = false;
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "API credit Not Available. Please recharge!",
          toastLength: Toast.LENGTH_SHORT, // LENGTH_SHORT or LENGTH_LONG
          gravity: ToastGravity.BOTTOM,    // Can be TOP, CENTER, or BOTTOM
          timeInSecForIosWeb: 1,           // Toast duration for iOS and Web
          backgroundColor: Colors.black,
          textColor: Color(0xFF14e7e2),
          fontSize: 16.0,
        );
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }
  Future<void> apicall() async {
    setState(() {
      loading = true;
    });
    print("aaaaa");
    var url = Uri.parse('https://chatgpt-42.p.rapidapi.com/chatgpt');

    var headers = {
      'Content-Type': 'application/json',
      'x-rapidapi-host': 'chatgpt-42.p.rapidapi.com/gpt4',
      'x-rapidapi-key': Globals.babyname, // Replace with your RapidAPI key
    };

    var body = jsonEncode({
      "messages": [
        {
          "role": "user",
          "content": "Provide a list of 5 different unique baby $_selectedGender names starting with '$_selectedLetter', of $_selectedOrigin origin. Format the response exactly as follows: {\"result\": [\"Name1\", \"Name2\", \"Name3\", \"Name4\", \"Name5\"]} Ensure the entire response is a single JSON object string with no additional text or nesting."
        }
      ],
      "web_access": false
    });

    print(body);
    try {
      print("try");
      var response = await http.post(url, headers: headers, body: body);
      print("karan");
      print(response.body);

      String jsonString = response.body;
      print("null1");
      // Step 1: Decode the main JSON string
      Map<String, dynamic> decodedJson = json.decode(jsonString);
      print("null2");
      // Step 2: Convert the 'result' field from a string into a JSON object

      print(decodedJson['result']);
      if(decodedJson['result'] == null){
      }else{
        Map<String, dynamic> resultField = json.decode(decodedJson['result']);
        decodedJson['result'] = resultField;
        // Now 'decodedJson' is the proper JSON object
        print(decodedJson);
        print(decodedJson['result']['result']);// print here : [Aarav, Arjun, Aditya, Aryan, Abhinav]
      }

        if (response.statusCode == 200) {
          try {
            String gender = _selectedGender.toString();
            String origin = _selectedOrigin.toString();

            List<String> names = List<String>.from(decodedJson['result']['result']);
            Set<String> uniqueNames = names.toSet(); // Convert to Set to remove duplicates


            if(loading == true){
              setState(() {
                _names = uniqueNames.toList(); // Convert back to List<String>
                loading = false;
              });
              AdsLoadUtil.onShowAds(context, (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NamesListScreen(names: _names, origin: origin),
                  ),
                );
              });
            }
            // Navigate to the NamesListScreen


          } catch (e) {

            print("catch ${e}");
            setState(() {
              loading = false;
            });
          }
        } else {
          Fluttertoast.showToast(
            msg: "API credit Not Available. Please recharge!",
            toastLength: Toast.LENGTH_SHORT, // LENGTH_SHORT or LENGTH_LONG
            gravity: ToastGravity.BOTTOM,    // Can be TOP, CENTER, or BOTTOM
            timeInSecForIosWeb: 1,           // Toast duration for iOS and Web
            backgroundColor: Colors.black,
            textColor: Color(0xFF14e7e2),
            fontSize: 16.0,
          );
          setState(() {
            loading = false;
          });
        }

      // Step 3: Replace the 'result' field in the decoded JSON with the newly decoded object

    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading == true ? WillPopScope(
      onWillPop: ()async{
        BIG_ImageUtils.showCloseConfirmationDialog(context, (){ setState(() {
          loading = false;
        });});
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/sc_6/bg.png'),fit: BoxFit.fill)
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Image.asset('assets/sc_9/generating.gif',width: 750.w,height: 750.h,),
                ).marginOnly(bottom: 20.h),

              ],
            ),
          ),
        ),
      ),
    ) : WillPopScope(
      onWillPop: ()async{
        AdsLoadUtil.onShowAds(context, (){
          Get.back();
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: LightThemeColors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the icon color to white
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BIG_PressUnpress(
              onTap: () async {
                AdsLoadUtil.onShowAds(context, (){
                  Get.back();
                });
              },
              unPressColor: Colors.transparent,
              height: 100.h,
              width: 100.w,
              imageAssetPress: 'assets/sc_6/back_press.png',
              imageAssetUnPress: 'assets/sc_6/back_unpress.png',
            ).marginOnly(left: 20.w),
          ),
          backgroundColor: LightThemeColors.black,
          title: Text('Baby Name Generator',
              style: TextStyle(color: LightThemeColors.white, fontSize: 60.sp)),
          actions: [

            BIG_PressUnpress(
              onTap: () async {
                AdsLoadUtil.onShowAds(context, (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                });
              },
              unPressColor: Colors.transparent,
              height: 100.h,
              width: 100.w,
              imageAssetPress: 'assets/sc_14/fav_press.png',
              imageAssetUnPress: 'assets/sc_14/fav_unpress.png',
            ).marginOnly(right: 50.w),
          ],
        ),
        body: Container(
          height: 2208.h,
          width: 1242.w,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/sc_6/bg.png'), fit: BoxFit.fill),
          ),
          child: Padding(
            padding:  EdgeInsets.only(left: 25, top: 70.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Seleact Your Baby's Gender",
                      style: TextStyle(color: Colors.white, fontSize: 50.sp),
                    ),
                  ],
                ).marginOnly(bottom: 50.h),
                Container(
                  height: 300.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BIG_PressUnpress(
                        onTap: () async {
                          setState(() {
                            _selectedGender = 'Boys';
                          });
                        },
                        unPressColor: Colors.transparent,
                        height: 280.h,
                        width: 470.w,
                        imageAssetPress: 'assets/sc_14/boy_press.png',
                        imageAssetUnPress: _selectedGender == 'Boys'
                            ? 'assets/sc_14/boy_press.png'
                            : 'assets/sc_14/boy_unpress.png',
                      ).marginOnly(right: 50.w),
                      BIG_PressUnpress(
                        onTap: () async {
                          setState(() {
                            _selectedGender = 'Girls';
                          });
                        },
                        unPressColor: Colors.transparent,
                        height: 280.h,
                        width: 470.w,
                        imageAssetPress: 'assets/sc_14/girl_press.png',
                        imageAssetUnPress: _selectedGender == 'Girls'
                            ? 'assets/sc_14/girl_press.png'
                            : 'assets/sc_14/girl_unpress.png',
                      )
                    ],
                  ).marginOnly(bottom: 40.h,right: 25),
                ),
                Text(
                  "Seleact Origin",
                  style: TextStyle(color: Colors.white, fontSize: 50.sp),
                ),
                const SizedBox(height: 16),
                DropdownButtonExample(
                  selectedcountry:  _selectedOrigin!,
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      _selectedOrigin = value;
                    });
                  },
                ),
                Text(
                  "Seleact Alphabet",
                  style: TextStyle(color: Colors.white, fontSize: 50.sp),
                ).marginOnly(top: 50.h),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(26, (index) {
                      String letter = String.fromCharCode(index + 65);
                      return BIG_PressUnpress(
                        onTap: () async {
                          setState(() {
                            _selectedLetter = letter;
                          });
                        },
                        unPressColor: Colors.transparent,
                        height: 150.h,
                        width: 150.w,
                        imageAssetPress: 'assets/sc_14/alphbet_bg_press.png',
                        imageAssetUnPress: _selectedLetter == letter
                            ? 'assets/sc_14/alphbet_bg_press.png'
                            : 'assets/sc_14/alphbet_bg_unpress.png',
                        child: Center(
                            child: Text(
                          letter,
                          style: TextStyle(color: Colors.white, fontSize: 70.sp),
                        )),
                      ).marginOnly(right: 30.w);
                    }),
                  ).marginOnly(top: 20.h),
                ),
                Spacer(),
                Center(
                  child: BIG_PressUnpress(
                    onTap: () async {
                      if (_selectedGender == null ||
                          _selectedOrigin == null ||
                          _selectedLetter == null) {

                        Fluttertoast.showToast(
                          msg: 'Please select Gender,Origin or Letter !',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black,
                          textColor: Color(0xFF14e7e2),
                          fontSize: 16.0,
                        );
                      } else {
                        int userCredits = await BIG_CreditsManager.getUserCredits();
                        if(userCredits >= AdsVariable.big_babyname_creditcut){
                          //cut credit
                          AdsLoadUtil.onShowAds(context, (){
                            BigCutCredit.cutCredit(5);
                            apicall();
                          });
                        }else{
                          Fluttertoast.showToast(msg: "You dont't have any credit");
                        }
                      }
                    },
                    unPressColor: Colors.transparent,
                    height: 180.h,
                    width: 950.w,
                    imageAssetPress: 'assets/sc_14/continue_press.png',
                    imageAssetUnPress: 'assets/sc_14/continue_unpress.png',
                  ),
                ).marginOnly(bottom: 100.h, right: 25),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar:  AdsVariable.isPurchase == false
            ? (AdsVariable.big_babyname_bannerAd!= "11")
            ? Container(
          child: BannerAdWidget(
              adId: AdsVariable.big_babyname_bannerAd),
        )
            : Container()
            : Container(),
      ),
    );
  }

  Widget Dropdown(BuildContext context) {
    return Container();
  }
}

// class DropdownButtonExample extends StatefulWidget {
//   final Function(String?) onChanged; // Callback to pass the selected value
//   final String selectedcountry;
//
//   const DropdownButtonExample({
//     Key? key,
//     required this.onChanged,
//     required this.selectedcountry,
//   }) : super(key: key);
//
//   @override
//   _DropdownButtonExampleState createState() => _DropdownButtonExampleState();
// }
//
// class _DropdownButtonExampleState extends State<DropdownButtonExample> {
//   final List<String> items = [
//     'India',
//     'United States',
//     'Canada',
//     'United Kingdom',
//     'Australia',
//     'Germany',
//     'France',
//     'Italy',
//     'Spain',
//     'China',
//     'Japan',
//     'Brazil',
//     'Mexico',
//     'South Africa',
//     'Russia',
//     'South Korea',
//     'New Zealand',
//     'Singapore',
//     'Netherlands',
//     'Sweden',
//     'Norway',
//   ];
//
//   String? selectedValue;
//   final ScrollController _scrollController = ScrollController(); // Create a ScrollController
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: PopupMenuButton<String>(
//         color: Colors.white,
//         onSelected: (String value) {
//           setState(() {
//             selectedValue = value;
//           });
//           widget.onChanged(value); // Pass the selected value back to the parent
//         },
//         itemBuilder: (BuildContext context) {
//           return [
//             PopupMenuItem(
//               enabled: false, // Disable this item to act as a container
//               child: Container(
//                 width: double.infinity,
//                 height: 960.h, // Set the height of the container
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/sc_15/popup_bg.png'), // Background image for the entire popup menu
//                     fit: BoxFit.fill, // Fill the entire popup menu
//                   ),
//                   borderRadius: BorderRadius.circular(15), // Rounded corners
//                 ),
//                 padding: EdgeInsets.zero, // Remove padding to eliminate margins
//                 child: Scrollbar(
//                   controller: _scrollController, // Use the ScrollController
//                   thumbVisibility: true, // Always show the scrollbar thumb
//                   thickness: 4.0, // Customize scrollbar thickness
//                   radius: Radius.circular(10), // Customize scrollbar radius
//                   child: SingleChildScrollView( // Use SingleChildScrollView to allow scrolling
//                     controller: _scrollController, // Assign the ScrollController
//                     child: Column(
//                       children: items.map((String choice) {
//                         return PopupMenuItem<String>(
//                           value: choice,
//                           padding: EdgeInsets.zero, // Remove padding for individual items
//                           child: Container(
//                             height: 30, // Set the height of each item to 30
//                             child: Row(
//                               children: [
//                                 Text(
//                                   choice,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 choice == widget.selectedcountry
//                                     ? Container(
//                                   width: 49.w,
//                                   height: 47.h,
//                                   decoration: BoxDecoration(
//                                     image: DecorationImage(
//                                       image: AssetImage('assets/sc_15/select.png'),
//                                     ),
//                                   ),
//                                 ).marginOnly(right: 40.w)
//                                     : SizedBox.shrink(),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ];
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.black.withOpacity(0.1),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 selectedValue ?? 'Select a country',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Image.asset(
//                 'assets/sc_14/drop_down_unpress.png',
//                 height: 24,
//                 width: 24,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





class DropdownButtonExample extends StatefulWidget {
  final Function(String?) onChanged; // Callback to pass the selected value
  final String selectedcountry;

  const DropdownButtonExample({
    Key? key,
    required this.onChanged,
    required this.selectedcountry,
  }) : super(key: key);

  @override
  _DropdownButtonExampleState createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  final List<String> items = [
    'India',
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'Germany',
    'France',
    'Italy',
    'Spain',
    'China',
    'Japan',
    'Brazil',
    'Mexico',
    'South Africa',
    'Russia',
    'South Korea',
    'New Zealand',
    'Singapore',
    'Netherlands',
    'Sweden',
    'Norway',
  ];

  String? selectedValue;

  void _showDropdownMenu(BuildContext context) {
    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                color: Colors.black54, // Dim the background
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Positioned(
              right: 20, // Change this to set horizontal position
              bottom: 320.h, // Change this to set vertical position
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: 650.w, // Set the width of the dropdown
                  height: 900.h, // Set the height of the dropdown
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/sc_15/popup_bg.png'), // Background image for the dropdown
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Scrollbar(
                    thumbVisibility: false,
                    thickness: 6, // Customize scrollbar thickness
                    radius: Radius.circular(10), // Round scrollbar edges
                    child: SingleChildScrollView(
                      child: Column(
                        children: items.map((String choice) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedValue = choice; // Update the selected value
                                widget.onChanged(choice); // Call the onChanged callback
                              });
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Container(
                              height: 40, // Set the height of each item
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    choice,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 55.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'RedHatDisplaysemibold',
                                    ),
                                  ),
                                  Spacer(),
                                  if (choice == widget.selectedcountry)
                                    Container(
                                      width: 49.w, // Customize this based on your design
                                      height: 37.h,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/sc_15/select.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDropdownMenu(context), // Show dropdown on tap
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValue ?? widget.selectedcountry,
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class NamesListScreen extends StatefulWidget {
  final List<String> names;
  final String origin;

  const NamesListScreen({super.key, required this.names, required this.origin});

  @override
  _NamesListScreenState createState() => _NamesListScreenState();
}

class _NamesListScreenState extends State<NamesListScreen> {
  List<String> _favoriteNames = []; // Change Set to List
  List<String> _country = []; // Change Set to List

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load favorite names and countries as lists, then keep them in sync
      _favoriteNames = prefs.getStringList('favorite_names') ?? [];
      _country = prefs.getStringList('country') ?? [];
    });
  }

  Future<void> _toggleFavorite(String name, String origin) async {
    final prefs = await SharedPreferences.getInstance();
    print(name);
   print(_country);
    setState(() {
      if (_favoriteNames.contains(name)) {
        // Get the index of the name to remove
        int index = _favoriteNames.indexOf(name);
        _favoriteNames.removeAt(index);
        _country.removeAt(index); // Remove the corresponding country
      } else {
        _favoriteNames.add(name);
        _country.add(origin);
      }
    });

    // Save the updated favorite names and countries
    await prefs.setStringList('favorite_names', _favoriteNames);
    await prefs.setStringList('country', _country); // Save the countries too
  }

  void _showDetails(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameDetailsScreen(
          name: name,
          origin: widget.origin,
          similarNames: widget.names,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        AdsLoadUtil.onShowAds(context, (){
          // Get.back();
          Get.offAll(() => BIG_Homepage());
        });
        return false;
      },
      child: Scaffold(
        backgroundColor: LightThemeColors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, // Set the icon color to black
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BIG_PressUnpress(
              onTap: () async {
                AdsLoadUtil.onShowAds(context, (){
                  // Get.back();
                  Get.offAll(() => BIG_Homepage());
                });
              },
              unPressColor: Colors.transparent,
              height: 100.h,
              width: 100.w,
              imageAssetPress: 'assets/sc_6/back_press.png',
              imageAssetUnPress: 'assets/sc_6/back_unpress.png',
            ).marginOnly(left: 20.w),
          ),
          centerTitle: true,
          backgroundColor: LightThemeColors.black,
          title: Text(
            'Name List',
            style: TextStyle(color: LightThemeColors.white, fontSize: 60.sp),
          ),
        ),
        body: ListView.builder(
          itemCount: widget.names.length,
          itemBuilder: (context, index) {
            final name = widget.names[index];
            final isFavorite = _favoriteNames.contains(name);

            return GestureDetector(
              // onTap: () => _showDetails(name),
              child: Container(
                margin: const EdgeInsets.only(top: 8, left: 30),
                child: ListTile(
                  title: Text(
                    name,
                    style: TextStyle(color: Colors.white, fontSize: 60.sp),
                  ),
                  subtitle: Text(
                    widget.origin,
                    style: TextStyle(color: Color(0XFF464646)),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.pink : null,
                    ),
                    onPressed: () => _toggleFavorite(name, widget.origin),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Map<String, String> _favoriteNames = {}; // Change to Map for name-country pairs
  final Duration _removalDelay = const Duration(microseconds: 1);
  final Map<String, Timer> _removalTimers = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load favorite names and countries
      final names = prefs.getStringList('favorite_names') ?? [];
      final countries = prefs.getStringList('country') ?? [];
      _favoriteNames = {
        for (int i = 0; i < names.length; i++) names[i]: countries[i],
      };
    });
  }

  Future<void> _toggleFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteNames.containsKey(name)) {
      setState(() {
        _favoriteNames.remove(name);
      });
    } else {
      // Assume you have a way to get the corresponding country when adding
      // This example uses 'Unknown' for demonstration; adjust accordingly.
      _favoriteNames[name] = 'Unknown'; // Placeholder, adjust as needed
    }
    // Save the updated favorite names and countries
    await prefs.setStringList('favorite_names', _favoriteNames.keys.toList());
    await prefs.setStringList('country', _favoriteNames.values.toList());
  }

  void _showDetails(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NameDetailsScreen2(
          name: name,
          // Pass the country if needed
        ),
      ),
    );
  }

  void _startRemovalTimer(String name) {
    final timer = Timer(_removalDelay, () async {
      setState(() {
        _favoriteNames.remove(name);
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('favorite_names', _favoriteNames.keys.toList());
      prefs.setStringList('country', _favoriteNames.values.toList());
      _removalTimers.remove(name);
    });
    _removalTimers[name] = timer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the icon color to white
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BIG_PressUnpress(
            onTap: () async {
              AdsLoadUtil.onShowAds(context, (){
                Get.back();
              });
            },
            unPressColor: Colors.transparent,
            height: 100.h,
            width: 100.w,
            imageAssetPress: 'assets/sc_6/back_press.png',
            imageAssetUnPress: 'assets/sc_6/back_unpress.png',
          ).marginOnly(left: 20.w),
        ),
        backgroundColor: LightThemeColors.black,
        title: Text('Favorite',
            style: TextStyle(color: LightThemeColors.white, fontSize: 60.sp)),
      ),
      body: _favoriteNames.isEmpty
          ? const Center(child: Text('No favorite names yet.',style: TextStyle(),))
          : Container(
        height: 2208.h,
        width: 1242.w,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/sc_6/bg.png'), fit: BoxFit.fill),
        ),
        child: ListView.builder(
          itemCount: _favoriteNames.length,
          itemBuilder: (context, index) {
            final name = _favoriteNames.keys.elementAt(index);
            final country = _favoriteNames[name];

            return Dismissible(
              key: ValueKey(name),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              onDismissed: (direction) {
                // Cancel any existing timer
                _removalTimers[name]?.cancel();
                _startRemovalTimer(name);
              },
              child: GestureDetector(
                // onTap: () => _showDetails(name),
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 60.sp),
                    ),
                    subtitle: Text(country ?? 'Unknown', // Display country
                        style: const TextStyle(color: Color(0XFF464646))),
                    trailing: IconButton(
                      icon: Icon(
                        _favoriteNames.containsKey(name)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _favoriteNames.containsKey(name)
                            ? Colors.pink
                            : null,
                      ),
                      onPressed: () => _toggleFavorite(name),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class NameDetailsScreen extends StatelessWidget {
  final String name;
  final String origin;
  final List<String> similarNames;

  const NameDetailsScreen({
    super.key,
    required this.name,
    required this.origin,
    required this.similarNames,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.black,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BIG_PressUnpress(
            onTap: () async {
              Get.back();
            },
            unPressColor: Colors.transparent,
            height: 100.h,
            width: 100.w,
            imageAssetPress: 'assets/sc_6/back_press.png',
            imageAssetUnPress: 'assets/sc_6/back_unpress.png',
          ).marginOnly(left: 20.w),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the icon color to white
        ),
        backgroundColor: LightThemeColors.black,
        title: Text(
          name,
          style: const TextStyle(color: LightThemeColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: LightThemeColors.white),
            ),
            const SizedBox(height: 8),
            Text('Origin: $origin',
                style: const TextStyle(
                    fontSize: 18, color: LightThemeColors.white)),
            const SizedBox(height: 16),
            const Text(
              'Similar Names:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: LightThemeColors.white),
            ),
            const SizedBox(height: 8),
            ...similarNames
                .map((similarName) => Text(
                      similarName,
                      style: const TextStyle(color: LightThemeColors.white),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class NameDetailsScreen2 extends StatefulWidget {
  final String name;

  const NameDetailsScreen2({super.key, required this.name});

  @override
  _NameDetailsScreenState createState() => _NameDetailsScreenState();
}

class _NameDetailsScreenState extends State<NameDetailsScreen2> {
  String origin = '';
  List<String> similarNames = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchNameDetails();
  }

  Future<void> _fetchNameDetails() async {
    var url = Uri.parse('https://chatgpt-42.p.rapidapi.com/chatgpt');

    var headers = {
      'Content-Type': 'application/json',
      'x-rapidapi-host': 'chatgpt-42.p.rapidapi.com',
      // 'x-rapidapi-key': '9c3b7f376bmshc5dfbbfef6de654p17d3d7jsn4671d214ec78', // Replace with your RapidAPI key
      'x-rapidapi-key': Globals.babyname, // Replace with your RapidAPI key
    };

    var body = jsonEncode({
      "messages": [
        {
          "role": "user",
          "content":
              "Provide the origin and similar names of baby the name '${widget.name} only not surname and all similar name not same name  and'. Format the response as follows: {\"origin\": \"OriginName\", \"similarNames\": [\"SimilarName1\", \"SimilarName2\", ...]}."
        }
      ],
      "web_access": false
    });

    try {
      print("try");
      var response = await http.post(url, headers: headers, body: body);
      print(response.body); // Debugging: Print the raw response body

      if (response.statusCode == 200) {
        // Extract the nested JSON from the 'result' field
        String responseBody = response.body;
        Map<String, dynamic> data = jsonDecode(responseBody);
        String resultString = data['result'] as String;

        // Parse the nested JSON string
        Map<String, dynamic> resultData = jsonDecode(resultString);
        String originData = resultData['origin'] as String;
        List<dynamic> similarNamesData =
            resultData['similarNames'] as List<dynamic>;

        List<String> namesList =
            similarNamesData.map<String>((item) => item as String).toList();

        setState(() {
          origin = originData;
          similarNames = namesList;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print("Error fetching details: $e"); // Debugging: Print the error
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.black,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BIG_PressUnpress(
            onTap: () async {
              Get.back();
            },
            unPressColor: Colors.transparent,
            height: 100.h,
            width: 100.w,
            imageAssetPress: 'assets/sc_6/back_press.png',
            imageAssetUnPress: 'assets/sc_6/back_unpress.png',
          ).marginOnly(left: 20.w),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: LightThemeColors.black,
        title: Text(widget.name,
            style: const TextStyle(color: LightThemeColors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? Center(child: CupertinoActivityIndicator(color: Colors.white,))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${widget.name}',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: LightThemeColors.white),
                  ),
                  const SizedBox(height: 8),
                  Text('Origin: $origin',
                      style: const TextStyle(
                          fontSize: 18, color: LightThemeColors.white)),
                  const SizedBox(height: 16),
                  const Text(
                    'Similar Names:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LightThemeColors.white),
                  ),
                  const SizedBox(height: 8),
                  ...similarNames
                      .map((similarName) => Text(similarName,
                          style:
                              const TextStyle(color: LightThemeColors.white)))
                      .toList(),
                ],
              ),
      ),
    );
  }
}
