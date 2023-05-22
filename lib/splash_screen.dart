import 'package:todotaskprovider/auth_wrapper.dart';
import 'utils/assets_path.dart';
import 'utils/exports.dart';
import 'package:todotaskprovider/utils/components/routers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  Center(child: Image(image: AssetImage(AssetsPath.appWinner))),
    );
 
  }
  
  void navigate() {
    Future.delayed(const Duration(seconds: 2), (){
      PageNavigator(ctx: context).nextPageOnly(page: const AuthWrapper(),);
    });
  }
}