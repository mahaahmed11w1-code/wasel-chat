import 'package:flutter/material.dart';

void main() {
  runApp(const WaselChatApp());
}

class WaselChatApp extends StatefulWidget {
  const WaselChatApp({super.key});

  @override
  State<WaselChatApp> createState() => _WaselChatAppState();
}

class _WaselChatAppState extends State<WaselChatApp> {
  String _lang = 'ar';
  bool _darkMode = false;
  String _name = 'مستخدم واصل شات';
  String _status = 'متصل الآن';

  final List> _chats = [
    {'name': 'أحمد', 'msg': 'أهلاً بك في واصل شات', 'time': '10:00 ص'},
    {'name': 'سارة', 'msg': 'تم تحديث التطبيق بنجاح', 'time': '09:45 ص'},
    {'name': 'الدعم', 'msg': 'نحن هنا لمساعدتك', 'time': 'أمس'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'واصل شات',
      locale: Locale(_lang),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: HomePage(
        chats: _chats,
        lang: _lang,
        darkMode: _darkMode,
        name: _name,
        status: _status,
        onLang: (v) => setState(() => _lang = v),
        onTheme: (v) => setState(() => _darkMode = v),
        onProfile: (n, s) => setState(() {
          _name = n;
          _status = s;
        }),
        onAddChat: (n, m) => setState(() {
          _chats.insert(0, {'name': n, 'msg': m, 'time': 'الآن'});
        }),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final List> chats;
  final String lang;
  final bool darkMode;
  final String name;
  final String status;
  final ValueChanged<String> onLang;
  final ValueChanged<bool> onTheme;
  final void Function(String name, String status) onProfile;
  final void Function(String name, String msg) onAddChat;

  const HomePage({
    super.key,
    required this.chats,
    required this.lang,
    required this.darkMode,
    required this.name,
    required this.status,
    required this.onLang,
    required this.onTheme,
    required this.onProfile,
    required this.onAddChat,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _idx = 0;

  void _addDialog() {
    final nCtrl = TextEditingController();
    final mCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('محادثة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nCtrl, decoration: const InputDecoration(labelText: 'الاسم')),
            TextField(controller: mCtrl, decoration: const InputDecoration(labelText: 'الرسالة')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () {
              final n = nCtrl.text.trim();
              final m = mCtrl.text.trim();
              if (n.isNotEmpty) {
                widget.onAddChat(n, m.isEmpty ? 'مرحباً' : m);
              }
              Navigator.pop(ctx);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      ListView.builder(
        itemCount: widget.chats.length,
        itemBuilder: (context, i) {
          final c = widget.chats[i];
          final n = c['name'] ?? 'مستخدم';
          return ListTile(
            leading: CircleAvatar(child: Text(n.substring(0, 1))),
            title: Text(n),
            subtitle: Text(c['msg'] ?? ''),
            trailing: Text(c['time'] ?? ''),
          );
        },
      ),
      ListView(
        children: const [
          ListTile(leading: Icon(Icons.donut_large), title: Text('حالة أحمد'), subtitle: Text('منذ 15 دقيقة')),
          ListTile(leading: Icon(Icons.donut_large), title: Text('حالة سارة'), subtitle: Text('منذ ساعة')),
        ],
      ),
      ProfileView(name: widget.name, status: widget.status, onSave: widget.onProfile),
      ListView(
        children: [
          SwitchListTile(
            title: const Text('الوضع الليلي'),
            value: widget.darkMode,
            onChanged: widget.onTheme,
          ),
          ListTile(
            title: const Text('العربية (AR)'),
            trailing: widget.lang == 'ar' ? const Icon(Icons.check) : null,
            onTap: () => widget.onLang('ar'),
          ),
          ListTile(
            title: const Text('English (EN)'),
            trailing: widget.lang == 'en' ? const Icon(Icons.check) : null,
            onTap: () => widget.onLang('en'),
          ),
          ListTile(
            title: const Text('Deutsch (DE)'),
            trailing: widget.lang == 'de' ? const Icon(Icons.check) : null,
            onTap: () => widget.onLang('de'),
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('واصل شات')),
      body: pages[_idx],
      floatingActionButton: _idx == 0
          ? FloatingActionButton(onPressed: _addDialog, child: const Icon(Icons.add_comment))
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'المحادثات'),
          NavigationDestination(icon: Icon(Icons.donut_large), label: 'الحالات'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'الملف'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  final String name;
  final String status;
  final void Function(String name, String status) onSave;

  const ProfileView({super.key, required this.name, required this.status, required this.onSave});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final TextEditingController _name;
  late final TextEditingController _status;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.name);
    _status = TextEditingController(text: widget.status);
  }

  @override
  void dispose() {
    _name.dispose();
    _status.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 16),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'الاسم')),
          const SizedBox(height: 12),
          TextField(controller: _status, decoration: const InputDecoration(labelText: 'الحالة')),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              widget.onSave(
                _name.text.trim().isEmpty ? 'مستخدم واصل شات' : _name.text.trim(),
                _status.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم الحفظ')),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
