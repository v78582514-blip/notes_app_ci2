import 'package:flutter/material.dart';
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 12),
child: TextField(
controller: bodyC,
maxLines: null,
keyboardType: TextInputType.multiline,
decoration: const InputDecoration(
hintText: 'Текст заметки…',
border: OutlineInputBorder(),
),
),
),
),
),
],
),
bottomNavigationBar: SafeArea(
child: BottomAppBar(
child: Row(
children: [
const SizedBox(width: 8),
FilterChip(
label: const Text('Нумерация'),
selected: numberingEnabled,
onSelected: (_) => _toggleNumbering(),
),
const SizedBox(width: 8),
IconButton(
tooltip: 'Вставить пункт',
onPressed: () {
if (!numberingEnabled) _toggleNumbering();
_ensureLeadingNumber();
final text = bodyC.text;
final sel = bodyC.selection;
final before = text.substring(0, sel.start);
final after = text.substring(sel.end);
currentNumber = _lastNumber(text.split('\n')) + 1;
final insert = '\n${currentNumber}. ';
bodyC.text = before + insert + after;
bodyC.selection = TextSelection.collapsed(offset: before.length + insert.length);
},
icon: const Icon(Icons.format_list_numbered),
),
const Spacer(),
IconButton(
tooltip: 'Шэр текст',
onPressed: () => Share.share(bodyC.text, subject: titleC.text),
icon: const Icon(Icons.share),
),
const SizedBox(width: 8),
],
),
),
),
),
);
}
}
