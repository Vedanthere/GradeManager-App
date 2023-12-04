import 'package:flutter/material.dart';
import 'grade.dart';

class GradeForm extends StatefulWidget {
  final Grade? grade;

  GradeForm({required this.grade});

  @override
  _GradeFormState createState() => _GradeFormState();
}

class _GradeFormState extends State<GradeForm> {
  TextEditingController _sidController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.grade != null) {
      _sidController.text = widget.grade!.sid ?? '';
      _gradeController.text = widget.grade!.grade ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grade != null ? 'Edit Grade' : 'Add Grade'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _sidController,
              decoration: InputDecoration(labelText: 'SID'),
            ),
            TextField(
              controller: _gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Grade grade = Grade(
                  sid: _sidController.text,
                  grade: _gradeController.text,
                  id: widget.grade?.id, // For edit mode
                );
                Navigator.pop(context, grade);
              },
              child: Text(widget.grade != null ? 'Submit Changes' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
