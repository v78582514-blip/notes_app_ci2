import 'dart:io';
builder: (context, _) {
final st = AppStorage.instance;
final g = st.groups.firstWhere((e) => e.id == groupId);
final items = st.notes.where((n) => n.groupId == groupId).toList();
return SafeArea(
child: Scaffold(
appBar: AppBar(
title: Text(g.name),
actions: [
IconButton(
tooltip: 'Экспорт группы (.json) и поделиться',
onPressed: () async {
final f = await AppStorage.instance.exportGroupJson(g);
await Share.shareXFiles([XFile(f.path)], subject: 'Группа: ${g.name}');
},
icon: const Icon(Icons.ios_share),
)
],
),
body: ListView.builder(
itemCount: items.length,
itemBuilder: (context, i) {
final n = items[i];
return ListTile(
title: Text(n.title.isEmpty ? 'Без названия' : n.title),
subtitle: Text(_preview(n.content)),
onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditScreen(noteId: n.id))),
trailing: PopupMenuButton<String>(
onSelected: (v) async {
switch (v) {
case 'export_json':
final f = await AppStorage.instance.exportNoteJson(n);
await Share.shareXFiles([XFile(f.path)], subject: n.title);
break;
case 'export_txt':
final f = await AppStorage.instance.exportNoteTxt(n);
await Share.shareXFiles([XFile(f.path)], subject: n.title);
break;
case 'share_text':
await Share.share(n.content, subject: n.title);
break;
case 'delete':
await AppStorage.instance.deleteNote(n.id);
break;
}
},
itemBuilder: (context) => const [
PopupMenuItem(value: 'share_text', child: Text('Поделиться текстом')),
PopupMenuItem(value: 'export_txt', child: Text('Экспорт как .txt')),
PopupMenuItem(value: 'export_json', child: Text('Экспорт как .json')),
PopupMenuDivider(),
PopupMenuItem(value: 'delete', child: Text('Удалить')),
],
),
);
},
),
floatingActionButton: FloatingActionButton.extended(
onPressed: () async {
final n = await AppStorage.instance.createNote(groupId: groupId);
if (!context.mounted) return;
Navigator.push(context, MaterialPageRoute(builder: (_) => NoteEditScreen(noteId: n.id)));
},
icon: const Icon(Icons.add),
label: const Text('Заметка'),
),
),
);
},
);
}


String _preview(String content) {
final s = content.replaceAll('\n', ' ');
return s.length > 80 ? '${s.substring(0, 80)}…' : s;
}
}
