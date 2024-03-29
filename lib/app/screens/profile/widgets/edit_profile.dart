import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/services/profile_service.dart';
import 'package:evoke_nexus_app/app/provider/profile_service_provider.dart';

class UserForm extends ConsumerStatefulWidget {
  final User user;
  final bool isFromWelcomeScreen;
  const UserForm(
      {super.key, required this.user, required this.isFromWelcomeScreen});

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



Future<void> _handleSubmit(BuildContext context) async {
    FocusScope.of(context).unfocus();

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
          Navigator.pop(context);
      setState(() {
        initialAbout = currentUser.about!;
        initialSocialLinks = currentUser.socialLinks! as List<String>;
                

      });
    } else {
      print("No changes detected.");
    }
  Navigator.pop(context);
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
    final userAsyncValue = ref.watch(fetchUserProvider);
    if (widget.isFromWelcomeScreen == true) {
      return _editDetails(widget.user, context);
    } else {
      return userAsyncValue.when(
        data: (data) {
          return MobileLayout(
              title: 'Edit Profile',
              user: data,
              hasBackAction: true,
              hasRightAction: false,
              topBarButtonAction: () {},
              backButtonAction: () {
                Navigator.pop(context);
              },
              child: _editDetails(widget.user, context));
        },
        loading: () => const Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) {
          // Handle the error case if needed
          return Text('An error occurred: $error');
        },
      );
    }
  }

  Widget _editDetails(User user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
          child: SizedBox(
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _profilePicWidget(widget.user, ref),
                    TextButton(
                      onPressed: () => ref
                          .read(uploadProfileImageProvider(widget.user.userId)),
                      child: Center(
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
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 15),
                        _buildReadOnlyField("Email", widget.user.email),
                        const SizedBox(width: 30),
                        Row(
                          children: [
                            _buildReadOnlyField("Role", widget.user.role),
                            const SizedBox(width: 150),
                            _buildReadOnlyField("Status", widget.user.status),
                          ],
                        ),
                        const SizedBox(width: 30),
                        _buildReadOnlyField("Created At",
                            widget.user.createdAt.toIso8601String()),
                        const SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        TextField(
                          controller: _aboutController,
                          maxLines: 3, // Increase this number for more lines
                          decoration: const InputDecoration(
                              labelText: "About",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8)),

                          // maxLength: 3000,
                        ),
                        // ExpandCollapseDemo(),

                        const SizedBox(height: 20),
                        ..._buildSocialLinksFields()
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                                _handleSubmit(context);
                            },
                            child: const Text("Submit")),
                        const SizedBox(width: 10),
                        TextButton(
                            onPressed: _handleCancel,
                            child: const Text("Cancel")),
                      ],
                    ),
                  ],
                ),
                // ),
              ),
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

  Widget _profilePicWidget(User user, WidgetRef ref) {
    final avatarText = getAvatarText(user.name);

    final profileThumbnailAsyncValue =
        ref.watch(profileThumbnailProvider(user.profilePicture ?? ""));

    return profileThumbnailAsyncValue.when(
      data: (data) {
        if (data != null) {
          return Center(
              child: CircleAvatar(
            backgroundImage: NetworkImage(data),
            radius: 80.0,
          ));
        } else {
          // Render a placeholder or an error image
          return CircleAvatar(radius: 80.0, child: Text(avatarText));
        }
      },
      loading: () => const Center(
        child: SizedBox(
          height: 80.0,
          width: 80.0,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // Handle the error case if needed
        return CircleAvatar(radius: 80.0, child: Text(avatarText));
      },
    );
  }

  String getAvatarText(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return '';
  }
}
