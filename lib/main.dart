import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'phone_auth_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyDJpiLXYokCPhJDJ5oinPd8noo0SBJFDzk',
      appId: '1:149081851409:android:eab0af7c54934e9dea93b0',
      messagingSenderId: '149081851409',
      projectId: 'wasel-ea314',
      storageBucket: 'wasel-ea314.firebasestorage.app',
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    initError = e.toString();
  }

  runApp(WaselChatApp(firebaseInitError: initError));
}

class WaselChatApp extends StatefulWidget {
  final String? firebaseInitError;

  const WaselChatApp({super.key, this.firebaseInitError});

  @override
  State<WaselChatApp> createState() => _WaselChatAppState();
}

class _WaselChatAppState extends State<WaselChatApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Color _seedColor = Colors.teal;
  double _chatFontSize = 15.0;

  void _toggleDarkMode(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeSeedColor(Color color) {
    setState(() {
      _seedColor = color;
    });
  }

  void _changeChatFontSize(double size) {
    setState(() {
      _chatFontSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Wasel Chat',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: widget.firebaseInitError != null
          ? FirebaseErrorScreen(errorMessage: widget.firebaseInitError!)
          : PhoneAuthScreen(
              onAuthenticated: MainAppShell(
                isDarkMode: _themeMode == ThemeMode.dark,
                onToggleDarkMode: _toggleDarkMode,
                seedColor: _seedColor,
                onChangeSeedColor: _changeSeedColor,
                chatFontSize: _chatFontSize,
                onChangeChatFontSize: _changeChatFontSize,
              ),
            ),
    );
  }
}

enum AvatarStyleType { emoji, badge }

class AvatarChoice {
  final String id;
  final String label;
  final String displayText;
  final AvatarStyleType type;
  final Color accentColor;

  const AvatarChoice({
    required this.id,
    required this.label,
    required this.displayText,
    required this.type,
    required this.accentColor,
  });
}

const List<AvatarChoice> kAvatarGallery = [
  AvatarChoice(
    id: 'av1',
    label: 'مبتسم',
    displayText: '😊',
    type: AvatarStyleType.emoji,
    accentColor: Colors.teal,
  ),
  AvatarChoice(
    id: 'av2',
    label: 'مطور',
    displayText: '🧑🏻‍💻',
    type: AvatarStyleType.emoji,
    accentColor: Colors.indigo,
  ),
  AvatarChoice(
    id: 'av3',
    label: 'مصمم',
    displayText: '👩🏻‍🎨',
    type: AvatarStyleType.emoji,
    accentColor: Colors.pink,
  ),
  AvatarChoice(
    id: 'av4',
    label: 'صاروخ',
    displayText: '🚀',
    type: AvatarStyleType.emoji,
    accentColor: Colors.orange,
  ),
  AvatarChoice(
    id: 'av5',
    label: 'نجم',
    displayText: '⭐',
    type: AvatarStyleType.emoji,
    accentColor: Colors.amber,
  ),
  AvatarChoice(
    id: 'av6',
    label: 'شخصي W',
    displayText: 'W',
    type: AvatarStyleType.badge,
    accentColor: Colors.blue,
  ),
  AvatarChoice(
    id: 'av7',
    label: 'VIP',
    displayText: 'VIP',
    type: AvatarStyleType.badge,
    accentColor: Colors.deepPurple,
  ),
  AvatarChoice(
    id: 'av8',
    label: 'PRO',
    displayText: 'PRO',
    type: AvatarStyleType.badge,
    accentColor: Colors.green,
  ),
];

Widget buildAvatarCircle({
  required String text,
  required Color color,
  required AvatarStyleType type,
  double radius = 24,
}) {
  final isBadge = type == AvatarStyleType.badge;
  return CircleAvatar(
    radius: radius,
    backgroundColor: isBadge ? color : color.withOpacity(0.18),
    child: Text(
      text,
      style: TextStyle(
        fontSize: isBadge ? radius * 0.62 : radius * 0.92,
        fontWeight: isBadge ? FontWeight.bold : FontWeight.normal,
        color: isBadge ? Colors.white : null,
      ),
    ),
  );
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class ChatThread {
  final String id;
  final String name;
  final String avatarText;
  final AvatarStyleType avatarType;
  final Color avatarColor;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final List<ChatMessage> messages;

  ChatThread({
    required this.id,
    required this.name,
    required this.avatarText,
    this.avatarType = AvatarStyleType.emoji,
    required this.avatarColor,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.messages,
  });
}

class MainAppShell extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;
  final Color seedColor;
  final ValueChanged<Color> onChangeSeedColor;
  final double chatFontSize;
  final ValueChanged<double> onChangeChatFontSize;

  const MainAppShell({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    required this.seedColor,
    required this.onChangeSeedColor,
    required this.chatFontSize,
    required this.onChangeChatFontSize,
  });

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  // بيانات الحساب والصورة الشخصية
  String _userName = 'مستخدم واصل';
  String _userBio = 'متاح للدردشة على Wasel Chat';
  String _userPhone = '+966 5X XXX XXXX';
  String _profileAvatarText = '😊';
  AvatarStyleType _profileAvatarType = AvatarStyleType.emoji;
  Color _profileColor = Colors.teal;

  // إعدادات الإشعارات والخصوصية والوسائط
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _messagePreview = true;
  bool _showOnlineStatus = true;
  bool _readReceipts = true;
  bool _appLock = false;
  bool _autoSaveMedia = false;

  // البحث
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // المحادثات
  final List<ChatThread> _chats = [
    ChatThread(
      id: '1',
      name: 'أحمد علي',
      avatarText: '🧑🏻‍💻',
      avatarType: AvatarStyleType.emoji,
      avatarColor: Colors.indigo,
      time: '08:15',
      unreadCount: 2,
      isOnline: true,
      messages: [
        ChatMessage(text: 'مرحباً! كيف حالك اليوم؟', isMe: false, time: '08:10'),
        ChatMessage(text: 'أهلاً بك، تم تسجيل الدخول بنجاح 👌', isMe: true, time: '08:12'),
        ChatMessage(text: 'جرّب الإيموجي والصور الرمزية الجديدة!', isMe: false, time: '08:15'),
      ],
    ),
    ChatThread(
      id: '2',
      name: 'سارة محمود',
      avatarText: '👩🏻‍🎨',
      avatarType: AvatarStyleType.emoji,
      avatarColor: Colors.pink,
      time: 'أمس',
      unreadCount: 0,
      isOnline: true,
      messages: [
        ChatMessage(text: 'هل غيّرت صورة الحساب والإعدادات؟', isMe: false, time: 'أمس'),
        ChatMessage(text: 'نعم، كل شيء مرتب وواضح 🎉', isMe: true, time: 'أمس'),
      ],
    ),
    ChatThread(
      id: '3',
      name: 'مجموعة فريق واصل',
      avatarText: 'VIP',
      avatarType: AvatarStyleType.badge,
      avatarColor: Colors.deepPurple,
      time: 'الثلاثاء',
      unreadCount: 1,
      isOnline: false,
      messages: [
        ChatMessage(text: 'تحديث جديد للتطبيق جاهز للتجربة.', isMe: false, time: 'الثلاثاء'),
      ],
    ),
  ];

  final List<Color> _themeColors = const [
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.deepPurple,
    Colors.green,
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChat(ChatThread chat) {
    setState(() {
      final index = _chats.indexWhere((c) => c.id == chat.id);
      if (index != -1) {
        _chats[index] = ChatThread(
          id: chat.id,
          name: chat.name,
          avatarText: chat.avatarText,
          avatarType: chat.avatarType,
          avatarColor: chat.avatarColor,
          time: chat.time,
          unreadCount: 0,
          isOnline: chat.isOnline,
          messages: chat.messages,
        );
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          chat: chat,
          fontSize: widget.chatFontSize,
          readReceipts: _readReceipts,
          onSendMessage: (String text) {
            setState(() {
              chat.messages.add(
                ChatMessage(
                  text: text,
                  isMe: true,
                  time: 'الآن',
                ),
              );
            });
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _showNewChatDialog() {
    final nameController = TextEditingController();
    AvatarChoice selectedChoice = kAvatarGallery.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('محادثة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: buildAvatarCircle(
                    text: selectedChoice.displayText,
                    color: selectedChoice.accentColor,
                    type: selectedChoice.type,
                    radius: 30,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'اسم الشخص أو المجموعة',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'اختر صورة المحادثة:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: kAvatarGallery.map((choice) {
                    final isSelected = choice.id == selectedChoice.id;
                    return ChoiceChip(
                      label: Text(choice.displayText),
                      selected: isSelected,
                      onSelected: (_) =>
                          setDialogState(() => selectedChoice = choice),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final newChat = ChatThread(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    avatarText: selectedChoice.displayText,
                    avatarType: selectedChoice.type,
                    avatarColor: selectedChoice.accentColor,
                    time: 'الآن',
                    isOnline: true,
                    messages: [
                      ChatMessage(
                        text: 'بدأت المحادثة مع $name 👋',
                        isMe: true,
                        time: 'الآن',
                      ),
                    ],
                  );
                  setState(() {
                    _chats.insert(0, newChat);
                  });
                  Navigator.pop(ctx);
                  _openChat(newChat);
                }
              },
              child: const Text('بدء'),
            ),
          ],
        ),
      ),
    );
  }

  void _openAvatarPickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'اختيار الصورة الشخصية',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: kAvatarGallery.map((item) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      setState(() {
                        _profileAvatarText = item.displayText;
                        _profileAvatarType = item.type;
                        _profileColor = item.accentColor;
                      });
                      Navigator.pop(ctx);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildAvatarCircle(
                          text: item.displayText,
                          color: item.accentColor,
                          type: item.type,
                          radius: 26,
                        ),
                        const SizedBox(height: 4),
                        Text(item.label, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = _chats.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (c.messages.isNotEmpty &&
              c.messages.last.text
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()));
    }).toList();

    final pages = [
      _buildChatsTab(filteredChats),
      _buildProfileTab(),
      _buildSettingsTab(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: _currentIndex == 0 && _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'ابحث في المحادثات أو الرسائل...',
                    border: InputBorder.none,
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                )
              : Text(
                  _currentIndex == 0
                      ? 'Wasel Chat'
                      : _currentIndex == 1
                          ? 'الملف الشخصي'
                          : 'الإعدادات',
                ),
          actions: [
            if (_currentIndex == 0)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchQuery = '';
                      _searchController.clear();
                    }
                  });
                },
                child: Text(
                  _isSearching ? 'إغلاق' : 'بحث',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (_currentIndex == 0)
              TextButton(
                onPressed: () => setState(() => _currentIndex = 2),
                child: const Text(
                  'الإعدادات',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        body: pages[_currentIndex],
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton.extended(
                onPressed: _showNewChatDialog,
                label: const Text('محادثة +'),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Text('💬', style: TextStyle(fontSize: 20)),
              label: 'المحادثات',
            ),
            NavigationDestination(
              icon: Text('👤', style: TextStyle(fontSize: 20)),
              label: 'الحساب',
            ),
            NavigationDestination(
              icon: Text('⚙️', style: TextStyle(fontSize: 20)),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsTab(List<ChatThread> chats) {
    if (chats.isEmpty) {
      return const Center(
        child: Text('لا توجد محادثات مطابقة حالياً'),
      );
    }

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final chat = chats[index];
        final lastMsg = chat.messages.isNotEmpty
            ? chat.messages.last.text
            : 'لا توجد رسائل بعد';
        return ListTile(
          onTap: () => _openChat(chat),
          leading: Stack(
            children: [
              buildAvatarCircle(
                text: chat.avatarText,
                color: chat.avatarColor,
                type: chat.avatarType,
                radius: 24,
              ),
              if (_showOnlineStatus && chat.isOnline)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            chat.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            lastMsg,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.time,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (chat.unreadCount > 0) ...[
                const SizedBox(height: 4),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    '${chat.unreadCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileTab() {
    final nameCtrl = TextEditingController(text: _userName);
    final bioCtrl = TextEditingController(text: _userBio);
    final phoneCtrl = TextEditingController(text: _userPhone);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                buildAvatarCircle(
                  text: _profileAvatarText,
                  color: _profileColor,
                  type: _profileAvatarType,
                  radius: 48,
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: _openAvatarPickerSheet,
                  child: const Text('تغيير الصورة الشخصية'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'تخصيص لون الخلفية:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: _themeColors.map((color) {
              final selected = color == _profileColor;
              return GestureDetector(
                onTap: () => setState(() => _profileColor = color),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: Colors.black, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'الاسم الشخصي',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: bioCtrl,
            decoration: const InputDecoration(
              labelText: 'الحالة / النبذة',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneCtrl,
            decoration: const InputDecoration(
              labelText: 'رقم الهاتف',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              setState(() {
                if (nameCtrl.text.trim().isNotEmpty) {
                  _userName = nameCtrl.text.trim();
                }
                _userBio = bioCtrl.text.trim();
                _userPhone = phoneCtrl.text.trim();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ بيانات الملف الشخصي ✅')),
              );
            },
            child: const Text('حفظ التغييرات'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: ListTile(
            leading: buildAvatarCircle(
              text: _profileAvatarText,
              color: _profileColor,
              type: _profileAvatarType,
              radius: 24,
            ),
            title: Text(
              _userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('$_userBio • $_userPhone'),
            trailing: TextButton(
              onPressed: () => setState(() => _currentIndex = 1),
              child: const Text('تعديل'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'المظهر والتخصيص',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ),
        SwitchListTile(
          title: const Text('الوضع الليلي'),
          subtitle: const Text('تبديل المظهر بين النهاري والداكن'),
          value: widget.isDarkMode,
          onChanged: widget.onToggleDarkMode,
        ),
        ListTile(
          title: const Text('لون السمة الرئيسي'),
          subtitle: const Text('اختر لون واجهة التطبيق'),
          trailing: Wrap(
            spacing: 6,
            children: _themeColors.map((color) {
              final isSelected = color == widget.seedColor;
              return GestureDetector(
                onTap: () => widget.onChangeSeedColor(color),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.black, width: 2.5)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('حجم خط الرسائل'),
          subtitle: Text('الحجم الحالي: ${widget.chatFontSize.toInt()}'),
        ),
        Slider(
          min: 13,
          max: 21,
          divisions: 8,
          value: widget.chatFontSize,
          onChanged: widget.onChangeChatFontSize,
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'الإشعارات',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ),
        SwitchListTile(
          title: const Text('تفعيل الإشعارات'),
          subtitle: const Text('استقبال تنبيهات الرسائل الواردة'),
          value: _notificationsEnabled,
          onChanged: (v) => setState(() => _notificationsEnabled = v),
        ),
        SwitchListTile(
          title: const Text('صوت التنبيهات'),
          subtitle: const Text('تشغيل صوت عند وصول رسالة جديدة'),
          value: _soundEnabled,
          onChanged: _notificationsEnabled
              ? (v) => setState(() => _soundEnabled = v)
              : null,
        ),
        SwitchListTile(
          title: const Text('معاينة نص الرسالة'),
          subtitle: const Text('إظهار نص الرسالة في الإشعار'),
          value: _messagePreview,
          onChanged: _notificationsEnabled
              ? (v) => setState(() => _messagePreview = v)
              : null,
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'الخصوصية والأمان',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ),
        SwitchListTile(
          title: const Text('إظهار حالة الاتصال'),
          subtitle: const Text('إظهار نقطة الاتصال للمحادثات النشطة'),
          value: _showOnlineStatus,
          onChanged: (v) => setState(() => _showOnlineStatus = v),
        ),
        SwitchListTile(
          title: const Text('مؤشرات القراءة'),
          subtitle: const Text('عرض حالة قراءة الرسائل'),
          value: _readReceipts,
          onChanged: (v) => setState(() => _readReceipts = v),
        ),
        SwitchListTile(
          title: const Text('حماية إضافية للتطبيق'),
          subtitle: const Text('تأكيد حالة الجلسة الآمنة'),
          value: _appLock,
          onChanged: (v) {
            setState(() => _appLock = v);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  v ? 'تم تفعيل وضع الحماية الإضافية' : 'تم إيقاف وضع الحماية الإضافية',
                ),
              ),
            );
          },
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'الدردشة والوسائط والحساب',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ),
        SwitchListTile(
          title: const Text('الحفظ التلقائي للوسائط'),
          subtitle: const Text('تجهيز حفظ الصور والملفات تلقائياً'),
          value: _autoSaveMedia,
          onChanged: (v) => setState(() => _autoSaveMedia = v),
        ),
        ListTile(
          title: const Text('إعادة ضبط المحادثات الافتراضية'),
          subtitle: const Text('استعادة المحادثات التجريبية الأولية'),
          onTap: () {
            setState(() {
              _chats.removeWhere((c) => !['1', '2', '3'].contains(c.id));
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إعادة ضبط المحادثات')),
            );
          },
        ),
        ListTile(
          title: const Text(
            'العودة إلى شاشة تسجيل الدخول',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PhoneAuthScreen(
                  onAuthenticated: MainAppShell(
                    isDarkMode: widget.isDarkMode,
                    onToggleDarkMode: widget.onToggleDarkMode,
                    seedColor: widget.seedColor,
                    onChangeSeedColor: widget.onChangeSeedColor,
                    chatFontSize: widget.chatFontSize,
                    onChangeChatFontSize: widget.onChangeChatFontSize,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final ChatThread chat;
  final double fontSize;
  final bool readReceipts;
  final ValueChanged<String> onSendMessage;

  const ChatDetailScreen({
    super.key,
    required this.chat,
    required this.fontSize,
    required this.readReceipts,
    required this.onSendMessage,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _msgController = TextEditingController();
  bool _showEmojiPicker = false;
  int _emojiCategoryIndex = 0;

  final List<List<String>> _emojiCategories = const [
    ['😀', '😂', '😍', '🤩', '😎', '🥳', '😢', '😡', '🤔', '😴', '😇', '🤗'],
    ['❤️', '👍', '👏', '🙏', '🔥', '🎉', '👌', '💪', '✨', '💯', '🤝', '✌️'],
    ['💬', '📱', '🚀', '🌟', '☕', '🍕', '🎵', '🎁', '✅', '📌', '🔔', '🌈'],
  ];

  final List<String> _categoryNames = const [
    'وجوه',
    'تفاعلات',
    'رموز',
  ];

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    widget.onSendMessage(text);
    _msgController.clear();
    setState(() {});
  }

  void _insertEmoji(String emoji) {
    final text = _msgController.text;
    final selection = _msgController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final updated = text.replaceRange(start, end, emoji);
    _msgController.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeEmojis = _emojiCategories[_emojiCategoryIndex];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 74,
          leading: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('← رجوع'),
          ),
          title: Row(
            children: [
              buildAvatarCircle(
                text: widget.chat.avatarText,
                color: widget.chat.avatarColor,
                type: widget.chat.avatarType,
                radius: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.chat.isOnline ? 'متصل الآن' : 'آخر ظهور ${widget.chat.time}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: widget.chat.messages.length,
                itemBuilder: (context, index) {
                  final m = widget.chat.messages[index];
                  return Align(
                    alignment:
                        m.isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: m.isMe
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            m.text,
                            style: TextStyle(
                              color: m.isMe ? Colors.white : null,
                              fontSize: widget.fontSize,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            m.isMe && widget.readReceipts
                                ? '${m.time} • ✓✓'
                                : m.time,
                            style: TextStyle(
                              color: m.isMe ? Colors.white70 : Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_showEmojiPicker)
              Container(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_categoryNames.length, (i) {
                        final selected = i == _emojiCategoryIndex;
                        return ChoiceChip(
                          label: Text(_categoryNames[i]),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _emojiCategoryIndex = i),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 10,
                      runSpacing: 8,
                      children: activeEmojis
                          .map(
                            (e) => GestureDetector(
                              onTap: () => _insertEmoji(e),
                              child: Text(e, style: const TextStyle(fontSize: 25)),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmojiPicker = !_showEmojiPicker);
                      },
                      child: Text(
                        _showEmojiPicker ? '⌨️' : '😊',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        onTap: () {
                          if (_showEmojiPicker) {
                            setState(() => _showEmojiPicker = false);
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالة أو اختر إيموجي...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    FilledButton(
                      onPressed: _send,
                      child: const Text('إرسال'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirebaseErrorScreen extends StatelessWidget {
  final String errorMessage;

  const FirebaseErrorScreen({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Initialization Error')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SelectableText(
            errorMessage,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
