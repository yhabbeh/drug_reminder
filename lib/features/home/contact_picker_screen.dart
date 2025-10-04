import 'dart:developer';

import 'package:drug_dose/features/home/bloc/reminder_bloc.dart';
import 'package:drug_dose/features/home/bloc/reminder_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MultiContactPickerScreen extends StatefulWidget {
  const MultiContactPickerScreen({Key? key}) : super(key: key);

  @override
  State<MultiContactPickerScreen> createState() =>
      _MultiContactPickerScreenState();
}

class _MultiContactPickerScreenState extends State<MultiContactPickerScreen> {
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  final Set<Contact> _selectedContacts = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    // if (await FlutterContacts.requestPermission()) {
    final contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      _allContacts = contacts;
      _filteredContacts = contacts;
      _loading = false;
    });
    // } else {
    //   setState(() => _loading = false);
    // }
  }

  void _filterContacts(String query) {
    final lower = query.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((c) {
        return c.displayName.toLowerCase().contains(lower);
      }).toList();
    });
  }

  void _toggleSelection(Contact contact) async {
    // If we only have lightweight contact, load full details
    if (contact.phones.isEmpty) {
      final fullContact = await FlutterContacts.getContact(
        contact.id,
        withProperties: true,
      );
      // Replace the old contact in selection set with fullContact
      setState(() {
        if (_selectedContacts.contains(contact)) {
          _selectedContacts.remove(contact);
        } else {
          _selectedContacts.add(fullContact ?? contact);
        }
      });
    } else {
      // Already have full contact
      setState(() {
        if (_selectedContacts.contains(contact)) {
          _selectedContacts.remove(contact);
        } else {
          _selectedContacts.add(contact);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.read<ReminderBloc>().add(
                ContactsSelected(_selectedContacts),
              );
              log(
                _selectedContacts
                    .map((contact) => contact.displayName)
                    .toList()
                    .toString(),
              );
              // Return selected contacts to previous screen or handle them
              Navigator.pop(context, _selectedContacts.toList());
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterContacts,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _filteredContacts.isEmpty
          ? const Center(child: Text('No contacts found'))
          : ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                final selected = _selectedContacts.contains(contact);
                final phones = contact.phones.isNotEmpty
                    ? contact.phones.map((e) => e.number).join(', ')
                    : 'Tap to load numbers';

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      contact.displayName.isNotEmpty
                          ? contact.displayName[0]
                          : '?',
                    ),
                  ),
                  title: Text(contact.displayName),
                  subtitle: Text(phones.isEmpty ? 'No phones' : phones),
                  trailing: Checkbox(
                    value: selected,
                    onChanged: (_) => _toggleSelection(contact),
                  ),
                  onTap: () => _toggleSelection(contact),
                );
              },
            ),
    );
  }
}
