import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/services/profile_service.dart';
import 'package:evoke_nexus_app/app/provider/profile_service_provider.dart';

class UserForm extends ConsumerStatefulWidget {
  final User user;
  const UserForm({super.key, required this.user});

  @override
  ConsumerState<UserForm> createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<UserForm> {
  late TextEditingController _aboutController;
  late List<TextEditingController> _socialLinksControllers;

  late String initialAbout;
  late List<String> initialSocialLinks;
  final profileService = ProfileService();

  @override
  void initState() {
    super.initState();

    //user = ref.watch(currentUserProvider.notifier).state!;

    _aboutController = TextEditingController(text: widget.user.about);

    // Assuming the socialLinks is a comma-separated string
    List<String> socialLinksList = (widget.user.socialLinks ?? "").split(',');
    _socialLinksControllers = List.generate(
      3,
      (index) => TextEditingController(
          text: (index < socialLinksList.length) ? socialLinksList[index] : ''),
    );

    // Storing initial values
    initialAbout = widget.user.about ?? "";
    initialSocialLinks = List.generate(
        3,
        (index) =>
            (index < socialLinksList.length) ? socialLinksList[index] : "");
  }

  Future<void> _handleSubmit() async {
    bool changed = initialAbout != _aboutController.text ||
        !_compareLists(initialSocialLinks,
            _socialLinksControllers.map((e) => e.text).toList());

    if (changed) {
      // Update the user object with new values
      User updatedUser = User(
        userId: widget.user.userId,
        identityId: widget.user.identityId,
        name: widget.user.name,
        email: widget.user.email,
        title: widget.user.title,
        role: widget.user.role,
        createdAt: widget.user.createdAt,
        status: widget.user.status,
        about: _aboutController.text,
        profilePicture: widget.user.profilePicture,
        socialLinks: _socialLinksControllers.map((e) => e.text).join(','),
      );
      final currentUser =
          await ref.read(updateUserProvider(updatedUser).future);
      setState(() {
        initialAbout = currentUser.about!;
        initialSocialLinks = currentUser.socialLinks! as List<String>;
      });
    } else {
      print("No changes detected.");
    }
  }

  void _handleCancel() {
    // Reset form fields to initial values
    _aboutController.text = initialAbout;
    for (int i = 0; i < 3; i++) {
      _socialLinksControllers[i].text = initialSocialLinks[i];
    }
  }

  bool _compareLists(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () =>
                      ref.read(uploadProfileImageProvider(widget.user.userId)),
                  child: Text(
                    widget.user.profilePicture != null &&
                            widget.user.profilePicture!.isNotEmpty
                        ? 'Change Profile Picture'
                        : 'Add Profile Picture',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 15),
                    _buildReadOnlyField("Email", widget.user.email),
                    const SizedBox(width: 30),
                    _buildReadOnlyField("Role", widget.user.role),
                    const SizedBox(width: 150),
                    _buildReadOnlyField(
                        "Created At", widget.user.createdAt.toIso8601String()),
                    const SizedBox(width: 30),
                    _buildReadOnlyField("Status", widget.user.status),
                    const SizedBox(width: 15)
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    TextField(
                      controller: _aboutController,
                      decoration: const InputDecoration(
                          labelText: "About",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8)),
                    ),
                    const SizedBox(height: 20),
                    ..._buildSocialLinksFields()
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: _handleSubmit, child: const Text("Submit")),
                    const SizedBox(width: 10),
                    TextButton(
                        onPressed: _handleCancel, child: const Text("Cancel")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(value),
        ],
      ),
    );
  }

  List<Widget> _buildSocialLinksFields() {
    // Icons for Facebook, LinkedIn, Instagram
    List<IconData> icons = [
      Icons.facebook,
      Icons.group,
      Icons.photo_album,
    ];
    List<String> labels = [
      "Facebook",
      "LinkedIn",
      "Instagram",
    ];
    return List.generate(3, (index) {
      return Column(
        children: [
          TextField(
            controller: _socialLinksControllers[index],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: labels[index],
              prefixIcon: Icon(icons[index]),
              contentPadding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  @override
  void dispose() {
    _aboutController.dispose();

    for (var controller in _socialLinksControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
