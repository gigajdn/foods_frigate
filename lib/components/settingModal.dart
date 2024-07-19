import 'package:flutter/material.dart';

class SettingsModal extends StatelessWidget {
  final bool isOpen;
  final VoidCallback closeModal;
  final bool darkMode;
  final ValueChanged<bool?> changeColor;
  final VoidCallback loadSamples;
  final VoidCallback deleteAll;

  SettingsModal({
    required this.isOpen,
    required this.closeModal,
    required this.darkMode,
    required this.changeColor,
    required this.loadSamples,
    required this.deleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isOpen ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: isOpen
          ? Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Container(
                  width: 350,
                  padding: EdgeInsets.all(20),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Settings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Color Mode'),
                          Row(
                            children: [
                              Radio<bool>(
                                value: false,
                                groupValue: darkMode,
                                onChanged: changeColor,
                              ),
                              Text('Light'),
                              Radio<bool>(
                                value: true,
                                groupValue: darkMode,
                                onChanged: changeColor,
                              ),
                              Text('Dark'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Data Storage'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: null,
                                  ),
                                  Text('Enable Cloud Storage'),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.cloud),
                                label: Text('Sign in with Google'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              Text('Development in progress'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: closeModal,
                        child: Text('Save Settings'),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reset your data',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'These actions will overwrite your existing data, and cannot be undone.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: loadSamples,
                                  child: Text('Load Samples'),
                                ),
                                ElevatedButton(
                                  onPressed: deleteAll,
                                  child: Text('Delete All'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
