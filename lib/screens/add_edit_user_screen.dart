import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/database_helper.dart';

class AddEditUserScreen extends StatefulWidget {
  final User? user;

  const AddEditUserScreen({super.key, this.user});

  @override
  State<AddEditUserScreen> createState() => _AddEditUserScreenState();
}

class _AddEditUserScreenState extends State<AddEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _ageController.text = widget.user!.age.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    final user = User(
      id: widget.user?.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      age: int.parse(_ageController.text.trim()),
    );

    if (widget.user == null) {
      await DatabaseHelper.instance.createUser(user);
    } else {
      await DatabaseHelper.instance.updateUser(user);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                widget.user == null
                    ? 'Create a new user'
                    : 'Update user details',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Required';
                  final emailRegex = RegExp(r'^[^@\\s]+@[^@\\s]+\\.[^@\\s]+\$');
                  if (!emailRegex.hasMatch(text)) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  final age = int.tryParse(value!.trim());
                  if (age == null) return 'Enter a valid number';
                  if (age < 1 || age > 120) return 'Age must be 1–120';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.maybePop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveUser,
                      child: Text(widget.user == null ? 'Add' : 'Update'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
