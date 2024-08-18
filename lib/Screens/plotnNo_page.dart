import 'package:flutter/material.dart';

class PlotNoTab extends StatefulWidget {
  const PlotNoTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlotNoTabState createState() => _PlotNoTabState();
}

class _PlotNoTabState extends State<PlotNoTab> {
  final TextEditingController _plotNoController = TextEditingController();
  String _selectedGovernorate = 'All Governorate';
  String _selectedCity = 'All cities';
  bool _isNewPlot = false;

  final List<String> governorates = [
    'All Governorate',
    'Muscat',
    'Batinah South',
    'Dhofar',
    'Buraimi',
  ];

  final List<String> cities = [
    'All cities',
    'City 1',
    'City 2',
    'City 3',
    'City 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _plotNoController,
              decoration: const InputDecoration(
                labelText: 'Plot No',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _isNewPlot,
                  onChanged: (bool? value) {
                    setState(() {
                      _isNewPlot = value ?? false;
                    });
                  },
                ),
                const Text('Is New Plot'),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGovernorate,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGovernorate = newValue!;
                });
              },
              onTap: () async {
                String? selected = await showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(governorates),
                );
                if (selected != null && selected != 'null') {
                  setState(() {
                    _selectedGovernorate = selected;
                  });
                }
              },
              items: governorates.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              decoration: const InputDecoration(
                labelText: 'Select a governorate',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCity,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue!;
                });
              },
              onTap: () async {
                String? selected = await showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(cities),
                );
                if (selected != null && selected != 'null') {
                  setState(() {
                    _selectedCity = selected;
                  });
                }
              },
              items: cities.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              decoration: const InputDecoration(
                labelText: 'Select a city',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _plotNoController.clear();
                    setState(() {
                      _isNewPlot = false;
                      _selectedGovernorate = 'All Governorate';
                      _selectedCity = 'All cities';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.clear),
                      SizedBox(width: 8),
                      Text('Clear Results'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Search'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> data;

  CustomSearchDelegate(this.data);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, 'null');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = data
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
