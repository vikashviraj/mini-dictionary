import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_dictionary/Screen/Dictionary/dictionary_screen.dart';
import 'Controller/Navigation/bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mini Dictionary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: GoogleFonts.lato().fontFamily),
      home: const MyHomePage(title: 'Mini Dictionary'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _checkNetworkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      //Get.back();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      //Get.back();
    } else {
      Get.snackbar(
        '',
        '',
        titleText: const Text(
          'Network Error!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        messageText: const Text('Network connection unavailable.'),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.teal.withOpacity(0.5),
        overlayBlur: 5,
        isDismissible: false,
        duration: const Duration(seconds: 60),
        mainButton: TextButton(
          onPressed: () {
            Get.back();
            _checkNetworkStatus();
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.mobile){
        // I am connected to a mobile network.
        Get.back();
      }else if(result == ConnectivityResult.wifi){
        // I am connected to a wifi network.
        Get.back();
      }else if(result == ConnectivityResult.none){
        _checkNetworkStatus();
      }else{
        _checkNetworkStatus();
      }
    });
    _checkNetworkStatus();
    super.initState();
  }

  @override
  void dispose() {
    //_checkNetworkStatus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title),
        leading: AvatarGlow(
          glowColor: Colors.white,
          endRadius: 90.0,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          child: Material(
            // Replace this child with your own
            elevation: 8.0,
            shape: const CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  height: 60,
                  imageUrl:
                      "https://yt3.ggpht.com/l8OV5qikDzAfDVkgyJI8NwfYDFuIoANCBhYLHojZKZfta4VzXcLooIuNBctVWcnsyknMDKt6_A=s900-c-k-c0x00ffffff-no-rj",
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              radius: 20.0,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
      body: const SingleChildScrollView(
        child: DictionaryBody(),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
