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
    {'name': 'سارة', 'message': 'تم تجهيز التطبيق بنجاح', 'time': '09:45 ص'},
    {'name': 'الدعم الفني', 'message': 'كيف يمكننا مساعدتك اليوم؟', 'time': 'أمس'},
  ];

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
      home: WaselHomePage(
        chats: _chats,
        currentLang: _locale.languageCode,
        darkMode: _darkMode,
        userName: _userName,
        userStatus: _userStatus,
        onLangChanged: (code) => setState(() => _locale = Locale(code)),
        onThemeChanged: (val) => setState(() => _darkMode = val),
        onSaveProfile: (name, status) => setState(() {
          _userName = name;
          _userStatus = status;
        }),
        onAddChat: (name, msg) => setState(() {
          _chats.insert(0, {'name': name, 'message': msg, 'time': 'الآن'});
        }),
      ),
    );
  }
}

class WaselHomePage extends StatefulWidget {
  final List> chats;
  final String currentLang;
  final bool darkMode;
  final String userName;
  final String userStatus;
  final ValueChanged<String> onLangChanged;
  final ValueChanged<bool> onThemeChanged;
  final void Function(String name, String status) onSaveProfile;
  final void Function(String name, String msg) onAddChat;

  const WaselHomePage({
    super.key,
    required this.chats,
    required this.currentLang,
    required this.darkMode,
    required this.userName,
    required this.userStatus,
    required this.onLangChanged,
    required this.onThemeChanged,
    required this.onSaveProfile,
    required this.onAddChat,
  });

  @override
  State<WaselHomePage> createState() => _WaselHomePageState();
}

class _WaselHomePageState extends State<WaselHomePage> {
  int _selectedIndex = 0;

  void _openAddChatDialog() {
    final nameController = TextEditingController();
    final msgController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('محادثة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'الاسم'),
            ),
            TextField(
              controller: msgController,
              decoration: const InputDecoration(labelText: 'الرسالة'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final msg = msgController.text.trim();
              if (name.isNotEmpty) {
                widget.onAddChat(name, msg.isEmpty ? 'مرحباً' : msg);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ListView.builder(
        itemCount: widget.chats.length,
        itemBuilder: (context, index) {
          final chat = widget.chats[index];
          final name = chat['name'] ?? 'مستخدم';
          final message = chat['message'] ?? '';
          final time = chat['time'] ?? '';
          return ListTile(
            leading: CircleAvatar(
              child: Text(name.isNotEmpty ? name.characters.first : '?'),
            ),
            title: Text(name),
            subtitle: Text(message),
            trailing: Text(time),
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
      ProfileEditorSection(
        userName: widget.userName,
        userStatus: widget.userStatus,
        onSave: widget.onSaveProfile,
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
            onChanged: (val) {
              if (val != null) widget.onLangChanged(val);
            },
          ),
          RadioListTile<String>(
            title: const Text('English (EN)'),
            value: 'en',
            groupValue: widget.currentLang,
            onChanged: (val) {
              if (val != null) widget.onLangChanged(val);
            },
          ),
          RadioListTile<String>(
            title: const Text('Deutsch (DE)'),
            value: 'de',
            groupValue: widget.currentLang,
            onChanged: (val) {
              if (val != null) widget.onLangChanged(val);
            },
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('واصل شات')),
      body: tabs[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _openAddChatDialog,
              child: const Icon(Icons.add_comment),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
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

class ProfileEditorSection extends StatefulWidget {
  final String userName;
  final String userStatus;
  final void Function(String name, String status) onSave;

  const ProfileEditorSection({
    super.key,
    required this.userName,
    required this.userStatus,
    required this.onSave,
  });

  @override
  State<ProfileEditorSection> createState() => _ProfileEditorSectionState();
}

class _ProfileEditorSectionState extends State<ProfileEditorSection> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _statusCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.userName);
    _statusCtrl = TextEditingController(text: widget.userStatus);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _statusCtrl.dispose();
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
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'الاسم'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _statusCtrl,
            decoration: const InputDecoration(labelText: 'الحالة'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              final cleanName = _nameCtrl.text.trim();
              widget.onSave(
                cleanName.isEmpty ? 'مستخدم واصل شات' : cleanName,
                _statusCtrl.text.trim(),
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
