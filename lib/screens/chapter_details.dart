// lib/chapter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart'; // Add in pubspec: share_plus: ^10.0.0
import 'package:intl/intl.dart'; // Add in pubspec: intl: ^0.19.0

class ChapterScreen extends StatefulWidget {
  final String studentClass;
  final String subject;
  final String chapterName;

  const ChapterScreen({
    super.key,
    required this.studentClass,
    required this.subject,
    required this.chapterName,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final firestore = FirebaseFirestore.instance;

  String? notes;
  Timestamp? uploadedAt;
  Timestamp? updatedAt;

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadNotesFromDoc();
    // If you later switch to subcollection based notes, comment the line above
    // and use: _loadLatestNoteFromSubcollection();
  }

  String _fmt(Timestamp? ts) {
    if (ts == null) return '';
    final dt = ts.toDate();
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  /// Current structure: notes stored in the chapter document
  /// notes/{CLASS}/subjects/{SUBJECT}/chapters/{CHAPTER}
  Future<void> _loadNotesFromDoc() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final docRef = firestore
          .collection('notes')
          .doc(widget.studentClass)
          .collection('subjects')
          .doc(widget.subject)
          .collection('chapters')
          .doc(widget.chapterName);

      final snap = await docRef.get();

      if (!snap.exists) {
        setState(() {
          error = 'Notes not found for this chapter.';
        });
        return;
      }

      final data = snap.data()!;
      setState(() {
        notes = (data['notesContent'] as String?)?.trim() ?? '';
        updatedAt = data['notesUpdatedAt'] as Timestamp?;
        uploadedAt = data['uploadedAt'] as Timestamp?;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load notes: $e';
      });
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// OPTIONAL: If you decide to store multiple notes in a subcollection:
  /// notes/{CLASS}/subjects/{SUBJECT}/chapters/{CHAPTER}/notes/{noteId}
  /// Uncomment and use this instead of _loadNotesFromDoc()
  /*
 Future<void> _loadLatestNoteFromSubcollection() async {
 setState(() {
 isLoading = true;
 error = null;
 });

 try {
 final query = await firestore
 .collection('notes')
 .doc(widget.studentClass)
 .collection('subjects')
 .doc(widget.subject)
 .collection('chapters')
 .doc(widget.chapterName)
 .collection('notes')
 .orderBy('createdAt', descending: true)
 .limit(1)
 .get();

 if (query.docs.isEmpty) {
 setState(() => notes = '');
 return;
 }

 final data = query.docs.first.data();
 setState(() {
 notes = (data['content'] as String?)?.trim() ?? '';
 updatedAt = data['createdAt'] as Timestamp?;
 });
 } catch (e) {
 setState(() => error = 'Failed to load notes: $e');
 } finally {
 if (mounted) setState(() => isLoading = false);
 }
 }
 */

  void _copyNotes() async {
    if ((notes ?? '').isEmpty) return;
    await Clipboard.setData(ClipboardData(text: notes!));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notes copied to clipboard')),
    );
  }

  void _shareNotes() {
    if ((notes ?? '').isEmpty) return;
    final title = widget.chapterName;
    Share.share(notes!, subject: 'Notes: $title');
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      color: Colors.redAccent,
      fontWeight: FontWeight.w600,
    );

    final infoStyle = const TextStyle(color: Colors.white38, fontSize: 12);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.chapterName, style: const TextStyle(color: Colors.redAccent)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          if (!isLoading && (notes?.isNotEmpty == true)) ...[
            IconButton(
              tooltip: 'Copy',
              icon: const Icon(Icons.copy),
              onPressed: _copyNotes,
            ),
            IconButton(
              tooltip: 'Share',
              icon: const Icon(Icons.share),
              onPressed: _shareNotes,
            ),
          ]
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? _ErrorView(message: error!, onRetry: _loadNotesFromDoc)
            : (notes == null || notes!.isEmpty)
            ? const _EmptyView()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text('Chapter Notes', style: titleStyle),
            const SizedBox(height: 8),
            Row(
              children: [
                if (updatedAt != null)
                  Text('Updated: ${_fmt(updatedAt)}', style: infoStyle),
                if (updatedAt == null && uploadedAt != null)
                  Text('Uploaded: ${_fmt(uploadedAt)}', style: infoStyle),
              ],
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  notes!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No notes available for this chapter yet.',
        style: TextStyle(color: Colors.white70),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.redAccent)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
