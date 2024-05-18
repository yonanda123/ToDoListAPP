import 'package:flutter/material.dart';

class AddDescriptionPage extends StatefulWidget {
  @override
  _AddDescriptionPageState createState() => _AddDescriptionPageState();
}

class _AddDescriptionPageState extends State<AddDescriptionPage> {
  String description = '';
  bool showError = false;

  void validateDescription(String value) {
    setState(() {
      if (value.length >= 45) {
        showError = true;
      } else {
        showError = false;
        description = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Description'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Description',
              style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => validateDescription(value),
              maxLines: null,
              decoration: InputDecoration(
                hintText: '    Enter your description...',
                errorText: showError
                    ? 'Description cannot exceed 45 characters'
                    : null,
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(50),
                //   borderSide: BorderSide(color: Color(0x80B19CEC)),
                // ),
                hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xd9B19CEC),
                    fontFamily: 'PoppinsLight'),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Color(0xFFB19CEC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide:
                      const BorderSide(color: Color(0xD9B19CEC), width: 0.5),
                ),
                filled: true,
                fillColor: Color(0x1AB19CEC),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!showError && description.isNotEmpty) {
                  Navigator.of(context).pop(description);
                }
              },
              child: Text(
                'Select',
                style: TextStyle(
                  fontFamily: 'PoppinsMedium',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(40),
                backgroundColor: Color(0xCCF14A5B),
                shadowColor: Color(0xCCF14A5B),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
