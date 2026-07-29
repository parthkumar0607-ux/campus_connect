import 'package:flutter/material.dart';

import '../../data/discover_repository.dart';
import '../../models/discover_user_model.dart';
import '../widgets/student_card.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() =>
      _DiscoverScreenState();
}

class _DiscoverScreenState
    extends State<DiscoverScreen> {
  final DiscoverRepository repository =
      DiscoverRepository();

  List<DiscoverUser> users = [];
  List<DiscoverUser> filteredUsers = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      users = await repository.getUsers();
      filteredUsers = users;
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  void search(String value) {
    setState(() {
      filteredUsers = users.where((user) {
        final query = value.toLowerCase();

        return user.name.toLowerCase().contains(query) ||
            (user.skills ?? "")
                .toLowerCase()
                .contains(query) ||
            (user.course ?? "")
                .toLowerCase()
                .contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover Students"),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadUsers,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: search,
                      decoration: InputDecoration(
                        hintText: "Search students...",
                        prefixIcon:
                            const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filteredUsers.isEmpty
                        ? const Center(
                            child: Text(
                              "No students found",
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                filteredUsers.length,
                            itemBuilder: (context, index) {
                              return StudentCard(
                                user:
                                    filteredUsers[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}