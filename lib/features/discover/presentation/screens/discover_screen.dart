import 'package:flutter/material.dart';

import 'package:campus_connect_v2/shared/widgets/glass_card.dart';

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

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void search(String value) {
    setState(() {
      final query = value.toLowerCase();

      filteredUsers = users.where((user) {
        return user.name.toLowerCase().contains(query) ||
            (user.skills ?? "")
                .toLowerCase()
                .contains(query) ||
            (user.course ?? "")
                .toLowerCase()
                .contains(query) ||
            (user.college ?? "")
                .toLowerCase()
                .contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: loadUsers,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const Text(
                              "Discover",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            const Text(
                              "Find talented students around your campus",
                              style: TextStyle(
                                color:
                                    Colors.white70,
                              ),
                            ),

                            const SizedBox(
                                height: 22),

                            TextField(
                              onChanged: search,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
                              decoration:
                                  const InputDecoration(
                                hintText:
                                    "Search by name, skills...",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors
                                      .white70,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 16),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .white
                                    .withOpacity(
                                        .08),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            30),
                              ),
                              child: Text(
                                "${filteredUsers.length} Students",
                                style:
                                    const TextStyle(
                                  color: Colors
                                      .white,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child:
                          filteredUsers.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No students found",
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding:
                                      const EdgeInsets
                                          .fromLTRB(
                                    20,
                                    0,
                                    20,
                                    25,
                                  ),
                                  itemCount:
                                      filteredUsers
                                          .length,
                                  itemBuilder:
                                      (context,
                                          index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets
                                              .only(
                                        bottom: 16,
                                      ),
                                      child:
                                          StudentCard(
                                        user:
                                            filteredUsers[
                                                index],
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}