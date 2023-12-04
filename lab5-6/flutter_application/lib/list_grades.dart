import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:theme_provider/theme_provider.dart';
import 'GradeChartPage.dart';
import 'grade.dart';
import 'grade_form.dart';
import 'grades_model.dart';
import 'package:csv/csv.dart';

class ListGrades extends StatefulWidget {
  @override
  _ListGradesState createState() => _ListGradesState();
}

enum SortOption {
  increasingSid,
  decreasingSid,
  increasingGrade,
  decreasingGrade,
}

class _ListGradesState extends State<ListGrades> {
  List<Grade> originalGrades = [];
  List<Grade> grades = [];
  String searchQuery = '';
  GradesModel gradesModel = GradesModel();
  int _selectedIndex = -1;
  SortOption _sortOption = SortOption.increasingSid;

  @override
  void initState() {
    super.initState();
    gradesModel.initDatabase().then((_) {
      reloadGrades();
    });
  }

  void _addGrade() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GradeForm(grade: null)),
    ).then((grade) {
      if (grade != null) {
        gradesModel.insertGrade(grade).then((_) {
          reloadGrades();
        });
      }
    });
  }

  Grade? _deleteGrade(int index) {
    Grade deletedGrade = grades[index];
    gradesModel.deleteGradeById(deletedGrade.id!).then((_) {
      reloadGrades();
      setState(() {
        _selectedIndex = -1;
      });
    });
    return deletedGrade;
  }

  void _showDeleteSnackbar(Grade deletedGrade, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Grade deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            gradesModel.insertGrade(deletedGrade).then((_) {
              reloadGrades();
            });
          },
        ),
      ),
    );
  }

  void _onDeleteGrade(int index) {
    Grade? deletedGrade = _deleteGrade(index);
    if (deletedGrade != null) {
      _showDeleteSnackbar(deletedGrade, index);
    }
  }

  void _editGrade(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradeForm(
          grade: grades[index],
        ),
      ),
    ).then((grade) {
      if (grade != null) {
        gradesModel.updateGrade(grade).then((_) {
          reloadGrades();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Edit Saved!'),
            ),
          );
        });
      }
    });
  }

  void reloadGrades() async {
    List<Grade> _grades = await gradesModel.getAllGrades();
    setState(() {
      originalGrades = _grades;
      grades = _grades;
    });
  }

  void _sortGrades(SortOption? option) {
    if (option != null) {
      setState(() {
        _sortOption = option;
        switch (option) {
          case SortOption.increasingSid:
            grades.sort((a, b) => (a.sid ?? '').compareTo(b.sid ?? ''));
            break;
          case SortOption.decreasingSid:
            grades.sort((a, b) => (b.sid ?? '').compareTo(a.sid ?? ''));
            break;
          case SortOption.increasingGrade:
            grades.sort((a, b) => (a.grade ?? '').compareTo(b.grade ?? ''));
            break;
          case SortOption.decreasingGrade:
            grades.sort((a, b) => (b.grade ?? '').compareTo(a.grade ?? ''));
            break;
        }
      });
    }
  }

  Future<void> _importCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.isNotEmpty) {
        print("File Info: ${result.files.first}");

        File file = File(result.files.first.path!);
        String csvString = await file.readAsString();

        List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

        for (List<dynamic> row in csvTable) {
          String sid = row.length > 0 ? row[0].toString() : '';
          String grade = row.length > 1 ? row[1].toString() : '';

          Grade newGrade = Grade(sid: sid, grade: grade);
          await gradesModel.insertGrade(newGrade);
        }

        setState(() {
          reloadGrades();
        });
      } else {
        print("Error: No files selected.");
      }
    } catch (e) {
      print("Error importing CSV: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = ThemeProvider.themeOf(context).data;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forms and SQLite'),
        actions: <Widget>[
          PopupMenuButton<SortOption?>(
            onSelected: _sortGrades,
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<SortOption?>>[
              PopupMenuItem<SortOption?>(
                value: SortOption.increasingSid,
                child: Text('Increasing Sid'),
              ),
              PopupMenuItem<SortOption?>(
                value: SortOption.decreasingSid,
                child: Text('Decreasing Sid'),
              ),
              PopupMenuItem<SortOption?>(
                value: SortOption.increasingGrade,
                child: Text('Increasing Grade'),
              ),
              PopupMenuItem<SortOption?>(
                value: SortOption.decreasingGrade,
                child: Text('Decreasing Grade'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GradeChartPage(grades: grades),
                ),
              );
            },
          ),
          // Add this IconButton for importing CSV
          IconButton(
            icon: Icon(Icons.upload_file_rounded),
            onPressed: _importCSV,
          ),
          IconButton(
            icon: Icon(Icons.sunny_snowing),
            onPressed: () {
              ThemeProvider.controllerOf(context).nextTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                  grades = originalGrades
                      .where((grade) =>
                          grade.sid!.toLowerCase().contains(searchQuery) ||
                          grade.grade!.toLowerCase().contains(searchQuery))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: grades.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(grades[index].id.toString()),
                  onDismissed: (direction) {
                    _onDeleteGrade(index);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: GestureDetector(
                    onLongPress: () {
                      _editGrade(index);
                    },
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${grades[index].sid}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${grades[index].grade}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGrade,
        child: Icon(Icons.add),
      ),
    );
  }
}
