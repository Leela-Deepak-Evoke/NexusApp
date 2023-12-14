import 'package:evoke_nexus_app/app/models/user.dart';
import 'package:evoke_nexus_app/app/widgets/common/mobile_custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileLayout extends StatefulWidget {
  final Widget child;
  final String title;
  final User user;
  final bool hasBackAction;
  final bool hasRightAction;
  final bool? showSearchIcon;
  final Widget? rightChildWiget;
  final Function() topBarButtonAction;
  final Function() backButtonAction;
  final void Function()? topBarSearchButtonAction;
  const MobileLayout({
    super.key,
    required this.child,
    required this.title,
    required this.user,
    required this.hasBackAction,
    required this.hasRightAction,
    this.showSearchIcon,
    required this.topBarButtonAction,
    required this.backButtonAction,
    this.rightChildWiget,
    this.topBarSearchButtonAction,
  });
  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  @override
  Widget build(BuildContext context) {
    final currentUri = Uri.parse(GoRouter.of(context).location);
    final currentPath = currentUri.path;
    final ValueNotifier<double> headerNegativeOffset = ValueNotifier<double>(0);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const Drawer(),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _buildHeader(size, headerNegativeOffset),
          Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 120),
              child: widget.child),
          CustomAppbar(
              title: widget.title,
              hasBackAction: widget.hasBackAction,
              hasRightAction: widget.hasRightAction,
              showSearchIcon: widget.showSearchIcon ?? false,
              topBarButtonAction: () => widget.topBarButtonAction(),
              backButtonAction: () => widget.backButtonAction(),
              rightChildWiget: widget.rightChildWiget,
              topBarSearchButtonAction: () =>
                  widget.topBarSearchButtonAction!()),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size, ValueNotifier<double> headerNegativeOffset) {
    const double maxHeaderHeight = 250.0;
    return Stack(
      children: [
        Container(
          child: ValueListenableBuilder<double>(
            valueListenable: headerNegativeOffset,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset * -1),
                child: SizedBox(
                  height: maxHeaderHeight,
                  width: size.width,
                  child: const Image(
                    image: AssetImage('assets/images/navBarRect.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        // Other header elements can be added here if needed.
      ],
    );
  }
}
