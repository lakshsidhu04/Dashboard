import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashbaord/utils/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:dashbaord/models/user_model.dart';
import 'package:dashbaord/screens/login_screen.dart';
import 'package:dashbaord/screens/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar(
      {super.key,
      required this.onThemeChanged,
      required this.user,
      required this.image,
      required this.isGuest});
  final UserModel? user;
  final String image;
  final bool isGuest;
  final ValueChanged<int> onThemeChanged;

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final greeting = getGreeting();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$greeting\n',
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              TextSpan(
                text: user?.name.split(' ').first ?? 'User',
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        isGuest
            ? InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => LoginScreen(
                                onThemeChanged: onThemeChanged,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      // color: Colors.orange,
                      borderRadius: BorderRadius.circular(500)),
                  child: const Icon(Icons.logout_rounded),
                ),
              )
            : InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  if (user == null) {
                    return;
                  }
                  Navigator.of(context).push(CustomPageRoute(
                    child: ProfileScreen(
                      user: user!,
                      image: image,
                      onThemeChanged: onThemeChanged,
                    ),
                  ));
                },
                child: ClipOval(
                  child: CircleAvatar(
                      radius: 24, child: CachedNetworkImage(imageUrl: image)),
                ),
              )
      ],
    );
  }
}