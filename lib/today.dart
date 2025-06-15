import 'package:flutter/material.dart';

class TodayScreen extends StatefulWidget {
  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  List<TaskItem> tasks = [
    TaskItem(id: 1, title: 'Task 1', isCompleted: false),
    TaskItem(id: 2, title: 'Task 2', isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        title: Text(
          'Today',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              onPressed: () {
                // Handle calendar action
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: GestureDetector(
                        onTap: () {
                          setState(() {
                            tasks[index].isCompleted = !tasks[index].isCompleted;
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: tasks[index].isCompleted 
                                  ? Color(0xFFFF6B6B) 
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            color: tasks[index].isCompleted 
                                ? Color(0xFFFF6B6B) 
                                : Colors.transparent,
                          ),
                          child: tasks[index].isCompleted
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                      title: Text(
                        tasks[index].title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: tasks[index].isCompleted 
                              ? Colors.grey.shade500 
                              : Colors.black,
                          decoration: tasks[index].isCompleted 
                              ? TextDecoration.lineThrough 
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Icon(
                        Icons.more_horiz,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        backgroundColor: Color(0xFFFF6B6B),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    tasks.add(TaskItem(
                      id: tasks.length + 1,
                      title: controller.text,
                      isCompleted: false,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B6B),
              ),
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class TaskItem {
  final int id;
  final String title;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.isCompleted,
  });
}

// Untuk menggunakan screen ini di main app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'SF Pro Display',
      ),
      home: TodayScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(MyApp());
}