import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:regis_flutter/home/api/dashboardapi.dart';
import 'package:regis_flutter/home/api/moodleapi.dart';
import 'package:regis_flutter/home/components/base_components.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _current = 0;
  bool _isLoading = true;
  late Set<Teacher> teachers;
  late Teacher user;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    loadTeacherList();
  }

  loadTeacherList() async {
    teachers = await getTeacherList();
    user = await getUserInfo();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return _isLoading
        ? const LoadingScreen()
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 12),
                  child: CachedNetworkImage(
                      imageUrl: user.avatar,
                      imageBuilder: (context, image) => Container(
                            width: 125,
                            height: 125,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: image,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Center(child: Column(
                      children: [
                        Text(user.name, style: theme.textTheme.headline2,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(user.email, style: theme.textTheme.subtitle1,),
                        ),
                        OutlinedButton(onPressed: () {handleSignOut(context);}, child: Text("Sign Out", style: theme.textTheme.headline3!.copyWith(color: theme.primaryColor), )),
                      ],
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "Your Teachers: ",
                    style: theme.textTheme.headline2,
                  ),
                ),
                CarouselSlider(
                  items: teachers
                      .map((element) =>
                          RegisCard(title: element.name, avatarImg: element.avatar, actions: {const Icon(Icons.email): () => launchUrl(Uri.parse("mailto:${element.email}"))}))
                      .toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                      height: 110,
                      autoPlay: false,
                      enlargeCenterPage: false,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: teachers.toList().asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 5.0,
                        height: 5.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: (Colors.white).withOpacity(_current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
        );
  }
}
