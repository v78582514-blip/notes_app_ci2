import 'dart:io';
),
bottomNavigationBar: BottomAppBar(
child: Row(
children: [
const SizedBox(width: 12),
ElevatedButton.icon(
icon: const Icon(Icons.create_new_folder_outlined),
onPressed: () async {
final name = await _askText(context, 'Новая группа', '');
if (name != null && name.trim().isNotEmpty) {
await AppStorage.instance.createGroup(name.trim());
}
},
label: const Text('Группа'),
),
const Spacer(),
IconButton(
tooltip: 'Бэкап всех групп (.json)',
onPressed: () async {
final f = await _exportAllSnapshot();
await Share.shareXFiles([XFile(f.path)], subject: 'Бэкап всех заметок');
},
icon: const Icon(Icons.save_alt),
),
const SizedBox(width: 8),
],
),
),
),
);
},
);
}


Future<File> _exportAllSnapshot() async {
final st = AppStorage.instance;
final snap = SnapshotExport(st.groups, st.notes);
final dir = await Directory.systemTemp.createTemp('backup');
final f = File('${dir.path}/notes_backup.json');
await f.writeAsString(snap.toJsonString());
return f;
}


Future<bool> _askPasswordAndVerify(BuildContext context, String groupId) async {
final pass = await _askText(context, 'Введите пароль', '', obscure: true);
if (pass == null) return false;
final ok = await AppStorage.instance.verifyGroupPassword(groupId, pass);
if (!ok && context.mounted) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Неверный пароль')));
}
return ok;
}
}


Future<String?> _askText(BuildContext context, String title, String initial, {bool obscure = false}) async {
final c = TextEditingController(text: initial);
return showDialog<String>(
context: context,
builder: (context) => AlertDialog(
title: Text(title),
content: TextField(controller: c, obscureText: obscure, autofocus: true),
actions: [
TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
FilledButton(onPressed: () => Navigator.pop(context, c.text), child: const Text('ОК')),
],
),
);
}
