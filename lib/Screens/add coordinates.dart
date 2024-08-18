import 'package:flutter/material.dart';
import 'package:flutter_application_1/Sub%20Screens/SingleCorner_page.dart';
import 'package:flutter_application_1/Sub%20Screens/multipleCorners_page.dart';

class AddCoordinates extends StatelessWidget {
  const AddCoordinates({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTabController(
              length: 2, // Number of tabs
              child: Column(
                children: [
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                        color: Colors.red),
                    labelColor: Colors.white,
                    unselectedLabelStyle: const TextStyle(color: Colors.red),
                    tabs: const [
                      Tab(text: 'Single Corner '),
                      Tab(text: 'Multiple Corner'),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [SingleCorner(), MultipleCorners()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
