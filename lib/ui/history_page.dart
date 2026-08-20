import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../data/database.dart';
import '../domain/generated_report.dart';
import '../domain/mammography_exam.dart';

/// Список ранее сохранённых заключений: просмотр текста, копирование,
/// загрузка выбора обратно в конструктор как черновик, удаление.
class HistoryPage extends StatelessWidget {
  final AppDatabase db;
  final ValueChanged<MammographyExam> onLoadDraft;

  const HistoryPage({super.key, required this.db, required this.onLoadDraft});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SavedReport>>(
      stream: db.watchAllReports(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final reports = snapshot.data!;
        if (reports.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Пока нет сохранённых заключений.\nСохраните первое на вкладке «Конструктор».',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final report = reports[index];
            return Card(
              margin: EdgeInsets.zero,
              child: ExpansionTile(
                title: Text(dateFormat.format(report.createdAt)),
                subtitle: Text(
                  report.conclusionText.split('\n').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                          report.fullText,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => onLoadDraft(
                                MammographyExam.fromJson(
                                  jsonDecode(report.examJson)
                                      as Map<String, dynamic>,
                                ),
                              ),
                              icon: const Icon(Icons.open_in_new, size: 18),
                              label: const Text('Открыть как черновик'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: reportTextForClipboard(
                                      report.fullText,
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Текст скопирован'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy, size: 18),
                              label: const Text('Копировать'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => db.deleteReport(report.id),
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text('Удалить'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
