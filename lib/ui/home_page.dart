import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/database.dart';
import '../domain/exam_controller.dart';
import 'constructor_page.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ExamController _controller = ExamController();
  final AppDatabase _db = AppDatabase();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _db.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конструктор маммографических заключений'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Конструктор', icon: Icon(Icons.edit_note)),
            Tab(text: 'История', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ConstructorPage(
            controller: _controller,
            onSave: (report) async {
              await _db.saveReport(
                examJson: jsonEncode(_controller.exam.toJson()),
                fullText: report.fullText,
                descriptionText: report.descriptionText,
                conclusionText: report.conclusionText,
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Заключение сохранено в историю')),
                );
              }
            },
          ),
          HistoryPage(
            db: _db,
            onLoadDraft: (exam) {
              _controller.load(exam);
              _tabController.animateTo(0);
            },
          ),
        ],
      ),
    );
  }
}
