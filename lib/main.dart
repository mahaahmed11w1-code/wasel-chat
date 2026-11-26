import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  runApp(const WaselChatApp());
}

enum AppLang { ar, en, de }

class WaselStrings {
  final AppLang lang;
  const WaselStrings(this.lang);

  String get appName {
    switch (lang) {
      case AppLang.ar:
        return 'واصل شات';
      case AppLang.en:
        return 'Wasel Chat';
      case AppLang.de:
        return 'Wasel Chat';
    }
  }

  String get chatsTab {
    switch (lang) {
      case AppLang.ar:
        return 'المحادثات';
      case AppLang.en:
        return 'Chats';
      case AppLang.de:
        return 'Chats';
    }
  }

  String get statusTab {
    switch (lang) {
      case AppLang.ar:
        return 'الحالات';
      case AppLang.en:
        return 'Status';
      case AppLang.de:
        return 'Status';
    }
  }

  String get profileTab {
    switch (lang) {
      case AppLang.ar:
        return 'الملف';
      case AppLang.en:
        return 'Profile';
      case AppLang.de:
        return 'Profil';
    }
  }

  String get settingsTab {
    switch (lang) {
      case AppLang.ar:
        return 'الإعدادات';
      case AppLang.en:
        return 'Settings';
      case AppLang.de:
        return 'Einstellungen';
    }
  }

  String get typeMessage {
    switch (lang) {
      case AppLang.ar:
        return 'اكتب رسالة...';
      case AppLang.en:
        return 'Type a message...';
      case AppLang.de:
        return 'Nachricht schreiben...';
    }
  }

  String get addStatus {
    switch (lang) {
      case AppLang.ar:
        return 'إضافة حالة جديدة';
      case AppLang.en:
        return 'Add new status';
      case AppLang.de:
        return 'Neuen Status hinzufügen';
    }
  }

  String get languageLabel {
    switch (lang) {
      case AppLang.ar:
        return 'اللغة';
      case AppLang.en:
        return 'Language';
      case AppLang.de:
        return 'Sprache';
    }
  }
}

class WaselChatApp extends StatefulWidget {
  const WaselChatApp({super.key});

  @override
  State<WaselChatApp> createState() => _WaselChatAppState();
}

class _WaselChatAppState extends State<WaselChatApp> {
  AppLang _lang = AppLang.ar;
  ThemeMode _themeMode = ThemeMode.light;

  void _changeLang(AppLang lang) {
    setState(() {
      _lang = lang;
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  TextDirection _directionFor(AppLang lang) {
    return lang == AppLang.ar ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    final strings = WaselStrings(_lang);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appName,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008069)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF008069),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: _directionFor(_lang),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: HomeShell(
        strings: strings,
        currentLang: _lang,
        isDark: _themeMode == ThemeMode.dark,
        onLangChanged: _changeLang,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  final WaselStrings strings;
  final AppLang currentLang;
  final bool isDark;
  final ValueChanged<AppLang> onLangChanged;
  final ValueChanged<bool> onThemeChanged;

  const HomeShell({
    super.key,
    required this.strings,
    required this.currentLang,
    required this.isDark,
    required this.onLangChanged,
    required this.onThemeChanged,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ChatsTab(strings: widget.strings),
      StatusTab(strings: widget.strings),
      ProfileTab(strings: widget.strings),
      SettingsTab(
        strings: widget.strings,
        currentLang: widget.currentLang,
        isDark: widget.isDark,
        onLangChanged: widget.onLangChanged,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.strings.appName),
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() {
            _index = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: widget.strings.chatsTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.donut_large_outlined),
            selectedIcon: const Icon(Icons.donut_large),
            label: widget.strings.statusTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: widget.strings.profileTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: widget.strings.settingsTab,
          ),
        ],
      ),
    );
  }
}

class ChatsTab extends StatefulWidget {
  final WaselStrings strings;
  const ChatsTab({super.key, required this.strings});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _showEmojis = false;
  bool _sending = false;

  static const List<String> _emojis = [
    '😀', '😂', '😍', '🤩', '😎', '🙏',
    '❤️', '🔥', '👍', '🎉', '✨', '🌙',
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  String _currentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid.isNotEmpty) {
      return user.uid;
    }
    return 'guest_user';
  }

  Future<void> _sendMessage({String? imageUrl}) async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty && (imageUrl == null || imageUrl.isEmpty)) {
      return;
    }
    setState(() {
      _sending = true;
    });
    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': text,
        'imageUrl': imageUrl ?? '',
        'senderId': _currentUserId(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      _msgCtrl.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;

      setState(() {
        _sending = true;
      });

      final file = File(picked.path);
      final fileName = 'chat_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child('chat_images/$fileName');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      await _sendMessage(imageUrl: downloadUrl);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return Center(child: Text(widget.strings.typeMessage));
              }
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final rawData = docs[index].data();
                  final Map<String, dynamic> data =
                      rawData is Map<String, dynamic> ? rawData : <String, dynamic>{};
                  final String text = (data['text'] as String?) ?? '';
                  final String imageUrl = (data['imageUrl'] as String?) ?? '';
                  final String senderId = (data['senderId'] as String?) ?? '';
                  final Timestamp? ts = data['createdAt'] as Timestamp?;
                  final bool isMe = senderId == _currentUserId();
                  final String timeLabel = ts != null
                      ? '${ts.toDate().hour.toString().padLeft(2, '0')}:${ts.toDate().minute.toString().padLeft(2, '0')}'
                      : '';

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imageUrl.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          if (text.isNotEmpty)
                            Text(text, style: const TextStyle(fontSize: 15)),
                          if (timeLabel.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                timeLabel,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (_showEmojis)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _emojis.length,
              itemBuilder: (context, idx) {
                final emoji = _emojis[idx];
                return IconButton(
                  onPressed: () {
                    _msgCtrl.text = '${_msgCtrl.text}$emoji';
                    _msgCtrl.selection = TextSelection.fromPosition(
                      TextPosition(offset: _msgCtrl.text.length),
                    );
                  },
                  icon: Text(emoji, style: const TextStyle(fontSize: 22)),
                );
              },
            ),
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showEmojis = !_showEmojis;
                    });
                  },
                  icon: const Icon(Icons.emoji_emotions_outlined),
                ),
                IconButton(
                  onPressed: _sending ? null : _pickAndSendImage,
                  icon: const Icon(Icons.photo_outlined),
                ),
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: InputDecoration(
                      hintText: widget.strings.typeMessage,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton.filled(
                  onPressed: _sending ? null : () => _sendMessage(),
                  icon: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatusTab extends StatefulWidget {
  final WaselStrings strings;
  const StatusTab({super.key, required this.strings});

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  final TextEditingController _statusCtrl = TextEditingController();

  @override
  void dispose() {
    _statusCtrl.dispose();
    super.dispose();
  }

  Future<void> _publishStatus() async {
    final text = _statusCtrl.text.trim();
    if (text.isEmpty) return;
    await FirebaseFirestore.instance.collection('statuses').add({
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    _statusCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('statuses')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _statusCtrl,
                  decoration: InputDecoration(
                    hintText: widget.strings.addStatus,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _publishStatus,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final rawData = docs[index].data();
                  final Map<String, dynamic> data =
                      rawData is Map<String, dynamic> ? rawData : <String, dynamic>{};
                  final String text = (data['text'] as String?) ?? '';
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.auto_awesome)),
                    title: Text(text),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProfileTab extends StatelessWidget {
  final WaselStrings strings;
  const ProfileTab({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'guest@wasel.chat';
    final uid = user?.uid ?? 'local-session';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: CircleAvatar(
            radius: 42,
            child: Icon(Icons.person, size: 42),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(email),
            subtitle: Text('UID: $uid'),
          ),
        ),
      ],
    );
  }
}

class SettingsTab extends StatelessWidget {
  final WaselStrings strings;
  final AppLang currentLang;
  final bool isDark;
  final ValueChanged<AppLang> onLangChanged;
  final ValueChanged<bool> onThemeChanged;

  const SettingsTab({
    super.key,
    required this.strings,
    required this.currentLang,
    required this.isDark,
    required this.onLangChanged,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: isDark,
          onChanged: onThemeChanged,
        ),
        const Divider(),
        ListTile(
          title: Text(strings.languageLabel),
        ),
        RadioListTile<AppLang>(
          title: const Text('العربية (AR)'),
          value: AppLang.ar,
          groupValue: currentLang,
          onChanged: (val) {
            if (val != null) onLangChanged(val);
          },
        ),
        RadioListTile<AppLang>(
          title: const Text('English (EN)'),
          value: AppLang.en,
          groupValue: currentLang,
          onChanged: (val) {
            if (val != null) onLangChanged(val);
          },
        ),
        RadioListTile<AppLang>(
          title: const Text('Deutsch (DE)'),
          value: AppLang.de,
          groupValue: currentLang,
          onChanged: (val) {
            if (val != null) onLangChanged(val);
          },
        ),
      ],
    );
  }
}
