import 'package:flutter/material.dart';
import 'package:campus_connect_v2/shared/widgets/glass_card.dart';
import 'package:campus_connect_v2/core/theme/app_colors.dart';
import 'package:campus_connect_v2/features/discover/data/discover_repository.dart';
import 'package:campus_connect_v2/features/discover/models/discover_user_model.dart';

class UsersPickerScreen extends StatefulWidget {
  const UsersPickerScreen({super.key});

  @override
  State<UsersPickerScreen> createState() => _UsersPickerScreenState();
}

class _UsersPickerScreenState extends State<UsersPickerScreen> {
  final DiscoverRepository repository = DiscoverRepository();
  List<DiscoverUser> users = [];
  List<DiscoverUser> filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      users = await repository.getUsers();
      filtered = users;
    } catch (_) {
      users = [];
      filtered = [];
    }
    if (mounted) setState(() => loading = false);
  }

  void _search(String q) {
    setState(() {
      final qq = q.toLowerCase();
      filtered = users.where((u) {
        return u.name.toLowerCase().contains(qq) || (u.skills ?? '').toLowerCase().contains(qq);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start a chat'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onChanged: _search,
                    decoration: const InputDecoration(
                      hintText: 'Search students...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, idx) {
                      final u = filtered[idx];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pop({
                            'id': u.id,
                            'name': u.name,
                          });
                        },
                        child: GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.primary,
                                child: Text(u.name.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(u.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 6),
                                  Text(u.course ?? '', style: const TextStyle(color: AppColors.textSecondary)),
                                ],
                              ))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
