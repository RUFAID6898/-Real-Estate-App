import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/krookie_Image_page.dart';
import 'package:flutter_application_1/Screens/plotnNo_page.dart';
import 'package:flutter_application_1/Screens/add%20coordinates.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Estate App'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Locate your Property',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Use one of the following methods',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.red,
                      labelColor: Colors.red,
                      tabs: [
                        Tab(text: 'Krookie Image'),
                        Tab(text: 'Add Coordinates'),
                        Tab(text: 'Plot No'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          KrookieImagePage(),
                          AddCoordinates(),
                          PlotNoTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
