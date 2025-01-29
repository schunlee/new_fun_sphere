import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:new_fun_sphere/biding/initial_biding.dart';
import 'package:new_fun_sphere/controller/checkin_controller.dart';
import 'package:new_fun_sphere/controller/navigation_controller.dart';
import 'package:new_fun_sphere/controller/task_controller.dart';
import 'package:new_fun_sphere/firebase_options.dart';
import 'package:new_fun_sphere/view/account.dart';
import 'package:new_fun_sphere/view/home.dart';
import 'package:new_fun_sphere/view/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await InitialBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());

    return GetMaterialApp(
        title: 'Fun Sphere',
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: ShowCaseWidget(
          disableBarrierInteraction: true,
          onComplete: (p0, p1) async {
            navigationController.isLock.value = false;
            final TaskController taskController = Get.put(TaskController());
            final Uri url = Uri.parse(taskController
                .appList[taskController.currentIndex.value].apkUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              Get.snackbar(
                "Error",
                "Could not launch $url",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          builder: (context) => const HomePage(),
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _one = GlobalKey();

  final TaskController taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    _showShowCase();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(const Duration(seconds: 1), () {
    //     ShowCaseWidget.of(context).startShowCase([_one]);
    //   });
    // });
  }

  Future<void> _showShowCase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownShowCase = prefs.getBool('hasShownShowCase') ?? false;

    if (!hasShownShowCase) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 1), () {
          ShowCaseWidget.of(context).startShowCase([_one]);
          prefs.setBool('hasShownShowCase', true);
        });
      });
    }else{
      navigationController.isLock.value = false;
    }
  }

  final NavigationController navigationController =
      Get.put(NavigationController());

  final double bottomIconHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    // Set the status bar to be transparent
    Get.put(CheckinController());
    taskController.fetchPromotions();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make the status bar transparent
        statusBarIconBrightness:
            Brightness.light, // Light icons for dark backgrounds
      ),
    );
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SizedBox(
            height: 0.0,
            child: AppBar(
              title: const Text(""),
              elevation: 0.0,
            ),
          )),
      body: Obx(() {
        switch (navigationController.currentIndex.value) {
          case 0:
            return Center(
                child: Home(
              gkey: _one,
            ));
          case 1:
            return Center(child: Task());
          case 2:
            return Center(child: Account());
          default:
            return Center(
                child: Home(
              gkey: _one,
            ));
        }
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
            currentIndex: navigationController.currentIndex.value,
            onTap: (index) {
              if (navigationController.isLock.value == true &&
                  navigationController.currentIndex.value == 0) {
              } else {
                navigationController.changeIndex(index);
              }
            },
            items: [
              BottomNavigationBarItem(
                  label: "",
                  icon: Image.asset("assets/images/home_inactive.png",
                      height: bottomIconHeight),
                  activeIcon: Image.asset("assets/images/home_active.png",
                      height: bottomIconHeight)),
              BottomNavigationBarItem(
                label: "",
                icon: Image.asset("assets/images/task_inactive.png",
                    height: bottomIconHeight),
                activeIcon: Image.asset("assets/images/task_active.png",
                    height: bottomIconHeight),
              ),
              BottomNavigationBarItem(
                  label: "",
                  icon: Image.asset("assets/images/account_inactive.png",
                      height: bottomIconHeight),
                  activeIcon: Image.asset("assets/images/account_active.png",
                      height: bottomIconHeight)),
            ]);
      }),
    );
  }
}
