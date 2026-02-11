import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/database_helper.dart';
import 'add_edit_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<User> _users = [];
  String _searchQuery = '';
  String _sortMode = 'recent';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final users = await _dbHelper.getAllUsers();
    if (!mounted) return;
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _deleteUser(int id) async {
    await _dbHelper.deleteUser(id);
    _loadUsers();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User deleted')),
    );
  }

  Future<void> _navigateToAddEditScreen([User? user]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditUserScreen(user: user),
      ),
    );

    if (result == true) {
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = _users.where((u) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q);
    }).toList();

    if (_sortMode == 'name') {
      filtered.sort((a, b) => a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          ));
    } else if (_sortMode == 'age') {
      filtered.sort((a, b) => a.age.compareTo(b.age));
    }

    final totalUsers = filtered.length;
    final avgAge = totalUsers == 0
        ? null
        : filtered.map((u) => u.age).reduce((a, b) => a + b) / totalUsers;

    return Scaffold(
      appBar: AppBar(
        // Match the title text expected by widget tests.
        title: const Text('SQLite Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name or email',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        totalUsers == 0
                            ? 'No users'
                            : '$totalUsers user${totalUsers == 1 ? '' : 's'}'
                                '${avgAge == null ? '' : ' • Avg age: ${avgAge.toStringAsFixed(1)}'}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    DropdownButton<String>(
                      value: _sortMode,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _sortMode = value);
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'recent',
                          child: Text('Recent'),
                        ),
                        DropdownMenuItem(
                          value: 'name',
                          child: Text('Name'),
                        ),
                        DropdownMenuItem(
                          value: 'age',
                          child: Text('Age'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text('No users yet'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        itemBuilder: (context, index) {
                          final user = filtered[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  user.name.isEmpty
                                      ? '?'
                                      : user.name[0].toUpperCase(),
                                ),
                              ),
                              title: Text(
                                user.name,
                                style: theme.textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                '${user.email}\nAge: ${user.age}',
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _navigateToAddEditScreen(user),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      if (user.id != null) {
                                        _deleteUser(user.id!);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
