import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nature_connect/custom_widgets/draft_widget.dart';
import 'package:nature_connect/providers/draft_provider.dart';
import 'package:nature_connect/model/draft.dart';

class DraftsPage extends StatefulWidget {
  final bool showAppBar;
  const DraftsPage({this.showAppBar = false, super.key});

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  final DraftProvider _draftProvider = DraftProvider();
  List<Draft> drafts = [];

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    drafts = await _draftProvider.getDrafts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Drafts'),
              leading: BackButton(
                onPressed: () {
                  context.go('/home');
                },
              ),
            )
          : null,
      body: drafts.isEmpty
          ? const Center(child: Text('No drafts available'))
          : ListView.builder(
              itemCount: drafts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    DraftWidget(
                        draft: drafts[index],
                        onDelete: () async {
                          await _draftProvider
                              .deleteDraft(drafts[index].draftId!);
                          await _loadDrafts();
                        }),
                    if (index != drafts.length - 1)
                      const Divider(), // Divider between items
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/makedraft');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
