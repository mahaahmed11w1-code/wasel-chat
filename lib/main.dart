import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WaselChatApp());
}

class WaselChatApp extends StatefulWidget {
  const WaselChatApp({super.key});

  @override
  State<WaselChatApp> createState() => _WaselChatAppState();
}

class _WaselChatAppState extends State<WaselChatApp> {
  Locale _locale = const Locale('ar');
  bool _darkMode = false;
  String _userName = 'مستخدم واصل شات';
  String _userStatus = 'متصل الآن';

  final List> _chats = [
    {'name': 'أحمد', 'message': 'أهلاً بك في واصل شات', 'time': '10:00 ص'},
    {'name': 'سارة', 'message': 'تم تحديث النسخة بنجاح', 'time': '09:45 ص'},
    {'name': 'الدعم الفني', 'message': 'كيف يمكننا مساعدتك اليوم؟', 'time': 'أمس'},
  ];

  void _changeLanguage(String code) {
    setState(() {
      _locale = Locale(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'واصل شات',
      locale: _locale,
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: MainHomeScreen(
        chats: _chats,
        currentLang: _locale.languageCode,
        darkMode: _darkMode,
        userName: _userName,
        userStatus: _userStatus,
        onLanguageChanged: _changeLanguage,
        onThemeChanged: (val) => setState(() => _darkMode = val),
        onProfileSaved: (name, status) {
          setState(() {
            _userName = name;
            _userStatus = status;
          });
        },
        onAddChat: (name, msg) {
          setState(() {
            _chats.insert(0, {'name': name, 'message': msg, 'time': 'الآن'});
          });
        },
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  final List> chats;
  final String currentLang;
  final bool darkMode;
  final String userName;
  final String userStatus;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<bool> onThemeChanged;
  final void Function(String name, String status) onProfileSaved;
  final void Function(String name, String msg) onAddChat;

  const MainHomeScreen({
    super.key,
    required this.chats,
    required this.currentLang,
    required this.darkMode,
    required this.userName,
    required this.userStatus,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.onProfileSaved,
    required this.onAddChat,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _index = 0;

  void _showNewChatDialog() {
    final nameCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('محادثة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'الاسم'),
            ),
            TextField(
              controller: msgCtrl,
              decoration: const InputDecoration(labelText: 'الرسالة'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                widget.onAddChat(
                  nameCtrl.text.trim(),
                  msgCtrl.text.trim().isEmpty ? 'مرحباً' : msgCtrl.text.trim(),
                );
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
          final item = widget.chats[i];
          return ListTile(
            leading: CircleAvatar(child: Text(item['name']![0])),
            title: Text(item['name']!),
            subtitle: Text(item['message']!),
            trailing: Text(item['time']!),
          );
        },
      ),
      ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.donut_large)),
            title: Text('حالة أحمد'),
            subtitle: Text('منذ 15 دقيقة'),
          ),
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.donut_large)),
            title: Text('حالة سارة'),
            subtitle: Text('منذ ساعة'),
          ),
        ],
      ),
      ProfileEditorTab(
        userName: widget.userName,
        userStatus: widget.userStatus,
        onSave: widget.onProfileSaved,
      ),
      ListView(
        children: [
          SwitchListTile(
            title: const Text('الوضع الليلي'),
            value: widget.darkMode,
            onChanged: widget.onThemeChanged,
          ),
          const ListTile(title: Text('اللغة / Language / Sprache')),
          RadioListTile<String>(
            title: const Text('العربية (AR)'),
            value: 'ar',
            groupValue: widget.currentLang,
            onChanged: (v) => v != null ? widget.onLanguageChanged(v) : null,
          ),
          RadioListTile<String>(
            title: const Text('English (EN)'),
            value: 'en',
            groupValue: widget.currentLang,
            onChanged: (v) => v != null ? widget.onLanguageChanged(v) : null,
          ),
          RadioListTile<String>(
            title: const Text('Deutsch (DE)'),
            value: 'de',
            groupValue: widget.currentLang,
            onChanged: (v) => v != null ? widget.onLanguageChanged(v) : null,
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('واصل شات')),
      body: pages[_index],
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: _showNewChatDialog,
              child: const Icon(Icons.add_comment),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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

class ProfileEditorTab extends StatefulWidget {
  final String userName;
  final String userStatus;
  final void Function(String name, String status) onSave;

  const ProfileEditorTab({
    super.key,
    required this.userName,
    required this.userStatus,
    required this.onSave,
  });

  @override
  State<ProfileEditorTab> createState() => _ProfileEditorTabState();
}

class _ProfileEditorTabState extends State<ProfileEditorTab> {
  late final TextEditingController _nameController;
  late final TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _statusController = TextEditingController(text: widget.userStatus);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'الاسم'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _statusController,
            decoration: const InputDecoration(labelText: 'الحالة'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              widget.onSave(
                _nameController.text.trim().isEmpty
                    ? 'مستخدم واصل شات'
                    : _nameController.text.trim(),
                _statusController.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ الملف الشخصي')),
              );
            },
            child: const Text('حفظ الملف الشخصي'),
          ),
        ],
      ),
    );
  }
}
