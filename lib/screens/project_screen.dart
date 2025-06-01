import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_flutter_app/constants.dart';
import 'package:my_flutter_app/screens/project_details_screen.dart';
import 'package:my_flutter_app/screens/statistics_screen.dart';
import 'package:my_flutter_app/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final TextEditingController _searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects"),
        actions: [
          PopupMenuButton(
            itemBuilder:
                (_) => [
                  const PopupMenuItem(value: 0, child: Text('View Statistics')),
                  const PopupMenuItem(value: 1, child: Text('Logout')),
                ],
            onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticsScreen()),
                );
              } else {
                AuthServices().logout(context);
              }
            },
          ),
          // IconButton(
          //   onPressed: () {
          //     AuthServices().logout(context);
          //   },
          //   icon: Icon(Icons.logout_outlined),
          // ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          searchFocusNode.unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _searchController,
                focusNode: searchFocusNode,
                decoration: InputDecoration(labelText: "Search Projects"),
              ),
            ),
            Expanded(child: ProjectList(searchQuery: _searchQuery)),
          ],
        ),
      ),
    );
  }
}

class ProjectList extends StatelessWidget {
  final String searchQuery;

  const ProjectList({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('projects').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No projects found.'));
        }

        // Extract the documents
        final documents = snapshot.data!.docs;

        // Filter projects based on the search query
        final filteredDocuments =
            documents.where((doc) {
              String name = doc['name'] ?? '';
              return name.toLowerCase().contains(searchQuery);
            }).toList();

        if (filteredDocuments.isEmpty) {
          return Center(child: Text('No matching projects found.'));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(
                context,
              ), // Responsive column count
              childAspectRatio: 1, // Adjust aspect ratio as needed
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: filteredDocuments.length,
            itemBuilder: (context, index) {
              // Extract the 'name' field from each document
              String name = filteredDocuments[index]['name'] ?? 'No Name';
              String description =
                  filteredDocuments[index]['description'] ?? '';
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProjectDetailsScreen(
                            project:
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>,
                          ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 2,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, textAlign: TextAlign.center),
                        Text(description, textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    // Adjust the number of columns based on screen width
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 2; // 2 columns for small screens
    } else if (width < 1200) {
      return 3; // 3 columns for medium screens
    } else {
      return 4; // 4 columns for large screens
    }
  }
}
