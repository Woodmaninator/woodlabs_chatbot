import 'package:flutter/material.dart';
import 'package:woodlabs_chatbot/styles/custom_text_styles.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class WoodlabsComboBox<T> extends StatelessWidget {
  final List<T> items;
  final List<String> itemLabels;
  final T selectedItem;
  final ValueChanged<T> onChanged;
  final String label;

  const WoodlabsComboBox({
    super.key,
    required this.items,
    required this.itemLabels,
    required this.selectedItem,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    var dropDownItems = <DropdownMenuItem<T>>[];
    for (int i = 0; i < items.length; i++) {
      dropDownItems.add(
        DropdownMenuItem<T>(
          value: items[i],
          child: Text(
            itemLabels[i],
            style: context.customTextStyles.bodyRegular,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.customTextStyles.label),
        SizedBox(height: 4.0),
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: context.customColors.backgroundLight,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: context.customColors.attmayGreen),
          ),
          child: Theme(
            data: ThemeData(
              canvasColor: context.customColors.backgroundLight,
              textTheme: CustomTextStyles.globalTextTheme,
            ),
            child: DropdownButton(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
              value: selectedItem,
              items: dropDownItems,
              onChanged: (value) => onChanged(value!),
              underline: const SizedBox.shrink(), // hides the underline
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: context.customColors.white100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
