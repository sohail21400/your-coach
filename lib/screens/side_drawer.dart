import 'package:flutter/material.dart';

class SideDrawer extends StatefulWidget {
  final ValueChanged<String> onDropdownChanged;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<bool> onToggleChanged;

  const SideDrawer({
    Key? key,
    required this.onDropdownChanged,
    required this.onSliderChanged,
    required this.onToggleChanged,
  }) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  String _selectedOption = 'Imam';
  double _sliderValue = 0.0;
  bool _isContinuousConversationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text('Select the personality of your coach'),
          ),
          DropdownButton<String>(
            value: _selectedOption,
            onChanged: (newValue) {
              setState(() {
                _selectedOption = newValue!;
              });
              widget.onDropdownChanged(newValue!);
            },
            items: [
              DropdownMenuItem(
                child: Text('Imam'),
                value: 'Imam',
              ),
              DropdownMenuItem(
                child: Text('Lawyer'),
                value: 'Lawyer',
              ),
              DropdownMenuItem(
                child: Text('Poet'),
                value: 'Poet',
              ),
            ],
          ),
          Slider(
            value: _sliderValue,
            min: 0.0,
            max: 2.0,
            divisions: 20,
            onChanged: (newValue) {
              setState(() {
                _sliderValue = newValue;
              });
              widget.onSliderChanged(newValue);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Continuous Conversations'),
              Switch(
                value: _isContinuousConversationsEnabled,
                onChanged: (newValue) {
                  setState(() {
                    _isContinuousConversationsEnabled = newValue;
                  });
                  widget.onToggleChanged(newValue);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
