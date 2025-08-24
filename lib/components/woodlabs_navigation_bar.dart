import 'package:flutter/cupertino.dart';
import 'package:woodlabs_chatbot/components/woodlabs_navigation_bar_item.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class WoodlabsNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Widget? leading;
  final List<String> locations;
  final List<String> labels;
  final List<IconData> icons;
  final Widget? trailing;

  WoodlabsNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.locations,
    required this.labels,
    required this.icons,
    this.leading,
    this.trailing,
  }) : assert(
         locations.length == labels.length && labels.length == icons.length,
         'locations, labels, and icons must have the same length',
       );

  @override
  State<StatefulWidget> createState() => _WoodlabsNavigationBarState();
}

class _WoodlabsNavigationBarState extends State<WoodlabsNavigationBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> navigationItems = [];

    for (int i = 0; i < widget.locations.length; i++) {
      navigationItems.add(
        WoodlabsNavigationBarItem(
          icon: widget.icons[i],
          isSelected: i == widget.selectedIndex,
          label: widget.labels[i],
          onTap: () {
            context.goRouter.go(widget.locations[i]);
          },
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              if (widget.leading != null) widget.leading!,
              Expanded(child: Column(children: navigationItems)),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ],
    );
  }
}
