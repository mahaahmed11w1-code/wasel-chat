import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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

class AppStrings {
  final String lang;
  const AppStrings(this.lang);

  bool get isRtl => lang == 'ar';

  static const Map<String, Map<String, String>> _dict = {
    'app_name': {'ar': 'Wasel Chat', 'en': 'Wasel Chat', 'de': 'Wasel Chat'},
    'tab_chats': {'ar': 'المحادثات', 'en': 'Chats', 'de': 'Chats'},
    'tab_status': {'ar': 'الحالات', 'en': 'Status', 'de': 'Status'},
    'tab_profile': {'ar': 'الحساب', 'en': 'Profile', 'de': 'Profil'},
    'tab_settings': {'ar': 'الإعدادات', 'en': 'Settings', 'de': 'Einstellungen'},
    'search': {'ar': 'بحث', 'en': 'Search', 'de': 'Suche'},
    'close': {'ar': 'إغلاق', 'en': 'Close', 'de': 'Schließen'},
    'search_hint': {
      'ar': 'ابحث في المحادثات أو الرسائل...',
      'en': 'Search chats or messages...',
      'de': 'Chats oder Nachrichten suchen...',
    },
    'new_chat': {
      'ar': 'محادثة جديدة +',
      'en': 'New Chat +',
      'de': 'Neuer Chat +',
    },
    'select_user': {
      'ar': 'اختر مستخدماً لبدء المحادثة',
      'en': 'Select a user to start chatting',
      'de': 'Wähle einen Nutzer für den Chat',
    },
    'no_users': {
      'ar': 'لا يوجد مستخدمون آخرون مسجلون حالياً.',
      'en': 'No other registered users yet.',
      'de': 'Noch keine weiteren registrierten Nutzer.',
    },
    'no_chats': {
      'ar': 'لا توجد محادثات بعد. ابدأ محادثة جديدة الآن.',
      'en': 'No chats yet. Start a new conversation now.',
      'de': 'Noch keine Chats. Starte jetzt eine Unterhaltung.',
    },
    'my_status': {'ar': 'حالتي الحالية', 'en': 'My Status', 'de': 'Mein Status'},
    'post_status': {'ar': 'نشر حالة', 'en': 'Post Status', 'de': 'Status posten'},
    'status_hint': {
      'ar': 'ماذا يدور في بالك الآن؟',
      'en': 'What is on your mind?',
      'de': 'Was machst du gerade?',
    },
    'recent_statuses': {
      'ar': 'حالات المستخدمين',
      'en': 'Recent Updates',
      'de': 'Aktuelle Status',
    },
    'no_statuses': {
      'ar': 'لا توجد حالات منشورة من المستخدمين بعد.',
      'en': 'No status updates from others yet.',
      'de': 'Noch keine Statusmeldungen anderer Nutzer.',
    },
    'reply_status': {
      'ar': 'رد على الحالة',
      'en': 'Reply to Status',
      'de': 'Auf Status antworten',
    },
    'upload_photo': {
      'ar': 'رفع صورة من الجهاز',
      'en': 'Upload Photo',
      'de': 'Foto hochladen',
    },
    'remove_photo': {
      'ar': 'إزالة الصورة',
      'en': 'Remove Photo',
      'de': 'Foto entfernen',
    },
    'display_name': {
      'ar': 'الاسم الظاهر',
      'en': 'Display Name',
      'de': 'Anzeigename',
    },
    'bio_label': {
      'ar': 'النبذة التعريفية',
      'en': 'About / Bio',
      'de': 'Über mich / Bio',
    },
    'save_profile': {
      'ar': 'حفظ بيانات الحساب',
      'en': 'Save Profile',
      'de': 'Profil speichern',
    },
    'profile_saved': {
      'ar': 'تم حفظ بيانات الحساب بنجاح',
      'en': 'Profile saved successfully',
      'de': 'Profil erfolgreich gespeichert',
    },
    'sec_language': {
      'ar': 'اللغة والمنطقة',
      'en': 'Language',
      'de': 'Sprache',
    },
    'language_label': {
      'ar': 'لغة التطبيق',
      'en': 'App Language',
      'de': 'App-Sprache',
    },
    'sec_appearance': {
      'ar': 'المظهر والتخصيص',
      'en': 'Appearance',
      'de': 'Darstellung',
    },
    'dark_mode': {
      'ar': 'الوضع الليلي',
      'en': 'Dark Mode',
      'de': 'Dunkelmodus',
    },
    'dark_mode_sub': {
      'ar': 'تبديل بين الوضع النهاري والداكن',
      'en': 'Switch between light and dark theme',
      'de': 'Zwischen hellem und dunklem Design wechseln',
    },
    'theme_color': {
      'ar': 'لون السمة',
      'en': 'Theme Color',
      'de': 'Designfarbe',
    },
    'font_size': {
      'ar': 'حجم خط الرسائل',
      'en': 'Message Font Size',
      'de': 'Schriftgröße der Nachrichten',
    },
    'sec_notifications': {
      'ar': 'الإشعارات',
      'en': 'Notifications',
      'de': 'Benachrichtigungen',
    },
    'notif_enabled': {
      'ar': 'تفعيل الإشعارات',
      'en': 'Enable Notifications',
      'de': 'Benachrichtigungen aktivieren',
    },
    'notif_sound': {
      'ar': 'صوت الرسائل',
      'en': 'Message Sound',
      'de': 'Nachrichtenton',
    },
    'notif_preview': {
      'ar': 'معاينة نص الرسالة',
      'en': 'Message Preview',
      'de': 'Nachrichtenvorschau',
    },
    'sec_privacy': {
      'ar': 'الخصوصية والأمان',
      'en': 'Privacy & Security',
      'de': 'Datenschutz & Sicherheit',
    },
    'online_status': {
      'ar': 'إظهار حالة الاتصال',
      'en': 'Show Online Status',
      'de': 'Online-Status anzeigen',
    },
    'read_receipts': {
      'ar': 'مؤشرات القراءة',
      'en': 'Read Receipts',
      'de': 'Lesebestätigungen',
    },
    'auto_media': {
      'ar': 'تحميل الوسائط تلقائياً',
      'en': 'Auto-Download Media',
      'de': 'Medien automatisch laden',
    },
    'logout': {
      'ar': 'تسجيل الخروج',
      'en': 'Log Out',
      'de': 'Abmelden',
    },
    'type_message': {
      'ar': 'اكتب رسالة أو إيموجي...',
      'en': 'Type a message or emoji...',
      'de': 'Nachricht oder Emoji schreiben...',
    },
    'send': {'ar': 'إرسال', 'en': 'Send', 'de': 'Senden'},
    'back': {'ar': '← رجوع', 'en': '← Back', 'de': '← Zurück'},
    'copy': {'ar': 'نسخ النص', 'en': 'Copy Text', 'de': 'Text kopieren'},
    'delete': {'ar': 'حذف', 'en': 'Delete', 'de': 'Löschen'},
    'cancel': {'ar': 'إلغاء', 'en': 'Cancel', 'de': 'Abbrechen'},
    'photo_msg': {'ar': '📷 صورة', 'en': '📷 Photo', 'de': '📷 Foto'},
    'gallery': {
      'ar': 'اختيار صورة من المعرض',
      'en': 'Choose from Gallery',
      'de': 'Aus Galerie wählen',
    },
    'camera': {
      'ar': 'التقاط صورة بالكاميرا',
      'en': 'Take Photo with Camera',
      'de': 'Foto mit Kamera aufnehmen',
    },
  };

  String t(String key) {
    return _dict[key]?[lang] ?? _dict[key]?['ar'] ?? key;
  }
}

class EmojiCatalog {
  static const List<String> categoryKeys = [
    'faces',
    'hearts',
    'hands',
    'nature',
    'food',
    'activities',
  ];

  static String categoryLabel(String key, String lang) {
    const labels = {
      'faces': {'ar': 'وجوه', 'en': 'Faces', 'de': 'Gesichter'},
      'hearts': {'ar': 'قلوب', 'en': 'Hearts', 'de': 'Herzen'},
      'hands': {'ar': 'إيماءات', 'en': 'Hands', 'de': 'Hände'},
      'nature': {'ar': 'طبيعة', 'en': 'Nature', 'de': 'Natur'},
      'food': {'ar': 'طعام', 'en': 'Food', 'de': 'Essen'},
      'activities': {'ar': 'أنشطة', 'en': 'Activity', 'de': 'Aktivität'},
    };
    return labels[key]?[lang] ?? key;
  }

  static const Map<String, List<String>> items = {
    'faces': [
      '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃', '😉', '😊',
      '😇', '🥰', '😍', '🤩', '😘', '😗', '😚', '😙', '😋', '😛', '😜', '🤪',
      '😝', '🤑', '🤗', '🤭', '🤫', '🤔', '🤐', '🤨', '😐', '😑', '😶', '😏',
      '😒', '🙄', '😌', '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢', '🤮',
      '🥵', '🥶', '🥴', '🤯', '🤠', '🥳', '😎', '🤓', '🧐', '😕', '😟', '🙁',
      '☹️', '😮', '😯', '😲', '😳', '🥺', '😦', '😧', '😨', '😰', '😥', '😢',
      '😭', '😱', '😖', '😣', '😞', '😓', '😩', '😫', '🥱', '😤', '😡', '😠',
      '🤬', '😈', '👿', '💀', '☠️',
    ],
    'hearts': [
      '❤️', '🧡', '💛', '💚', '💙', '💜', '🤎', '🖤', '🤍', '🩷', '🩵', '🩶',
      '💔', '❤️‍🔥', '❤️‍🩹', '💕', '💞', '💓', '💗', '💖', '💘', '💝', '💟',
      '💌', '💢', '💥', '💫', '💦', '💨', '💤', '💬', '👁️‍🗨️', '🗯️', '💭',
      '💯', '🔥', '✨', '🌟', '⭐', '⚡', '☀️', '🌈', '🎉', '🎊', '🎈',
    ],
    'hands': [
      '👋', '🤚', '🖐️', '✋', '🖖', '👌', '🤌', '🤏', '✌️', '🤞', '🫰', '🤟',
      '🤘', '🤙', '👈', '👉', '👆', '🖕', '👇', '☝️', '👍', '👎', '✊', '👊',
      '🤛', '🤜', '👏', '🙌', '🫶', '👐', '🤲', '🤝', '🙏', '✍️', '💅', '🤳',
      '💪', '🦾', '🦿', '🦵', '🦶', '👂', '🦻', '👃', '🧠', '🫀', '🫁', '🦷',
    ],
    'nature': [
      '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮',
      '🐷', '🐸', '🐵', '🙈', '🙉', '🙊', '🐒', '🐔', '🐧', '🐦', '🐤', '🐣',
      '🐥', '🦆', '🦅', '🦉', '🦇', '🐺', '🐗', '🐴', '🦄', '🐝', '🪱', '🐛',
      '🦋', '🐌', '🐞', '🐜', '🪲', '🪳', '🦟', '🌸', '💮', '🏵️', '🌹', '🥀',
      '🌺', '🌻', '🌼', '🌷', '🌱', '🪴', '🌲', '🌳', '🌵', '🍀', '🍁',
    ],
    'food': [
      '🍏', '🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐', '🍈', '🍒',
      '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🥑', '🥦', '🥬', '🥒', '🌶️', '🌽',
      '🥕', '🧄', '🧅', '🥔', '🥐', '🥯', '🍞', '🥖', '🥨', '🧀', '🥚', '🍳',
      '🥞', '🧇', '🥓', '🥩', '🍗', '🍖', '🌭', '🍔', '🍟', '🍕', '🌮', '🌯',
      '🥗', '🍝', '🍜', '🍲', '🍛', '🍣', '🍤', '🍦', '🍨', '🍧', '🍩', '🍪',
      '🎂', '🍰', '🧁', '🍫', '🍬', '🍭', '☕', '🍵', '🧋', '🥤', '🧃', '🧊',
    ],
    'activities': [
      '⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉', '🥏', '🎱', '🏓', '🏸',
      '🥅', '⛳', '🏹', '🎣', '🥊', '🥋', '🎽', '🛹', '🛼', '🛷', '⛸️', '🎿',
      '⛷️', '🏂', '🏋️', '🤼', '🤸', '🤺', '🤾', '🏌️', '🏇', '🧘', '🏄', '🏊',
      '🤽', '🚣', '🧗', '🚵', '🚴', '🏆', '🥇', '🥈', '🥉', '🏅', '🎖️', '🎨',
      '🎬', '🎤', '🎧', '🎼', '🎹', '🥁', '🎷', '🎺', '🎸', '🪕', '🎮', '🎲',
      '🧩', '♟️', '🎯', '🎳', '🚀', '✈️', '🚗', '🚢', '🏙️', '🏖️', '⛰️',
    ],
  };

  static List<String> forKey(String key) => items[key] ?? const [];
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
  String _languageCode = 'ar';

  void _toggleDarkMode(bool isDark) {
    setState(() => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void _changeSeedColor(Color color) {
    setState(() => _seedColor = color);
  }

  void _changeChatFontSize(double size) {
    setState(() => _chatFontSize = size);
  }

  void _changeLanguage(String code) {
    setState(() => _languageCode = code);
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
                languageCode: _languageCode,
                onChangeLanguage: _changeLanguage,
              ),
            ),
    );
  }
}

Widget buildUserAvatar({
  String? photoUrl,
  String fallbackEmoji = '😊',
  Color color = Colors.teal,
  double radius = 24,
}) {
  if (photoUrl != null && photoUrl.isNotEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withOpacity(0.15),
      backgroundImage: NetworkImage(photoUrl),
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundColor: color.withOpacity(0.18),
    child: Text(
      fallbackEmoji,
      style: TextStyle(fontSize: radius * 0.92),
    ),
  );
}

class MainAppShell extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;
  final Color seedColor;
  final ValueChanged<Color> onChangeSeedColor;
  final double chatFontSize;
  final ValueChanged<double> onChangeChatFontSize;
  final String languageCode;
  final ValueChanged<String> onChangeLanguage;

  const MainAppShell({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    required this.seedColor,
    required this.onChangeSeedColor,
    required this.chatFontSize,
    required this.onChangeChatFontSize,
    required this.languageCode,
    required this.onChangeLanguage,
  });

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;

  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _messagePreview = true;
  bool _showOnlineStatus = true;
  bool _readReceipts = true;
  bool _autoSaveMedia = false;

  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _bioCtrl = TextEditingController();
  bool _profileInitialized = false;
  String _currentEmoji = '😊';
  String? _currentPhotoUrl;
  bool _uploadingAvatar = false;

  final TextEditingController _statusTextCtrl = TextEditingController();
  String _statusEmoji = '✨';
  Color _statusBgColor = Colors.teal;
  bool _postingStatus = false;

  final ImagePicker _picker = ImagePicker();
  final List<Color> _themeColors = const [
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.deepPurple,
    Colors.green,
    Colors.orange,
  ];

  AppStrings get _s => AppStrings(widget.languageCode);

  String get _currentUid {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'guest_user';
  }

  String get _currentPhone {
    final phone = FirebaseAuth.instance.currentUser?.phoneNumber;
    return (phone != null && phone.isNotEmpty) ? phone : '-';
  }

  @override
  void initState() {
    super.initState();
    _syncUserPresence(true);
  }

  Future<void> _syncUserPresence(bool online) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(_currentUid);
    final snap = await userRef.get();
    if (!snap.exists) {
      await userRef.set({
        'uid': _currentUid,
        'name': 'مستخدم واصل',
        'bio': '',
        'phone': _currentPhone,
        'avatarEmoji': '😊',
        'photoUrl': '',
        'online': online,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await userRef.set({
        'online': online,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _statusTextCtrl.dispose();
    super.dispose();
  }

  String _buildDirectChatId(String uidA, String uidB) {
    final sorted = [uidA, uidB]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> _startOrOpenChatWithUser({
    required String targetUid,
    required String targetName,
    required String targetEmoji,
    String? targetPhotoUrl,
    String? initialMessage,
  }) async {
    if (targetUid == _currentUid) return;

    final chatId = _buildDirectChatId(_currentUid, targetUid);
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final snap = await chatRef.get();
    final myName =
        _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'مستخدم واصل';

    if (!snap.exists) {
      await chatRef.set({
        'participants': [_currentUid, targetUid],
        'participantNames': {
          _currentUid: myName,
          targetUid: targetName,
        },
        'participantEmojis': {
          _currentUid: _currentEmoji,
          targetUid: targetEmoji,
        },
        'participantPhotos': {
          _currentUid: _currentPhotoUrl ?? '',
          targetUid: targetPhotoUrl ?? '',
        },
        'lastMessage': '',
        'lastMessageType': 'text',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await chatRef.set({
        'participantNames': {
          _currentUid: myName,
          targetUid: targetName,
        },
        'participantEmojis': {
          _currentUid: _currentEmoji,
          targetUid: targetEmoji,
        },
        'participantPhotos': {
          _currentUid: _currentPhotoUrl ?? '',
          targetUid: targetPhotoUrl ?? '',
        },
      }, SetOptions(merge: true));
    }

    if (initialMessage != null && initialMessage.trim().isNotEmpty) {
      await chatRef.collection('messages').add({
        'type': 'text',
        'text': initialMessage.trim(),
        'imageUrl': '',
        'senderId': _currentUid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await chatRef.set({
        'lastMessage': initialMessage.trim(),
        'lastMessageType': 'text',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(
          chatId: chatId,
          currentUid: _currentUid,
          peerName: targetName,
          peerEmoji: targetEmoji,
          peerPhotoUrl: targetPhotoUrl,
          fontSize: widget.chatFontSize,
          readReceipts: _readReceipts,
          strings: _s,
        ),
      ),
    );
  }

  Future<void> _publishStatus() async {
    final text = _statusTextCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => _postingStatus = true);
    try {
      final myName = _nameCtrl.text.trim().isNotEmpty
          ? _nameCtrl.text.trim()
          : 'مستخدم واصل';
      await FirebaseFirestore.instance
          .collection('statuses')
          .doc(_currentUid)
          .set({
        'uid': _currentUid,
        'userName': myName,
        'userEmoji': _currentEmoji,
        'userPhotoUrl': _currentPhotoUrl ?? '',
        'statusText': text,
        'statusEmoji': _statusEmoji,
        'bgColorValue': _statusBgColor.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _statusTextCtrl.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_s.t('post_status'))),
      );
    } finally {
      if (mounted) {
        setState(() => _postingStatus = false);
      }
    }
  }

  Future<void> _deleteMyStatus() async {
    await FirebaseFirestore.instance
        .collection('statuses')
        .doc(_currentUid)
        .delete();
  }

  void _showReplyStatusDialog(Map<String, dynamic> statusData) {
    final targetUid = (statusData['uid'] ?? '') as String;
    final targetName = (statusData['userName'] ?? 'User') as String;
    final targetEmoji = (statusData['userEmoji'] ?? '😊') as String;
    final targetPhoto = statusData['userPhotoUrl'] as String?;
    final statusText = (statusData['statusText'] ?? '') as String;
    final replyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: _s.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          title: Text('${_s.t('reply_status')} • $targetName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '"$statusText"',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: replyCtrl,
                decoration: InputDecoration(
                  hintText: _s.t('type_message'),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(_s.t('cancel')),
            ),
            FilledButton(
              onPressed: () async {
                final msg = replyCtrl.text.trim();
                Navigator.pop(ctx);
                if (msg.isNotEmpty) {
                  await _startOrOpenChatWithUser(
                    targetUid: targetUid,
                    targetName: targetName,
                    targetEmoji: targetEmoji,
                    targetPhotoUrl: targetPhoto,
                    initialMessage: '↩️ $msg',
                  );
                }
              },
              child: Text(_s.t('send')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteChat(String chatId, String peerName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: _s.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          title: Text(_s.t('delete')),
          content: Text('$peerName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(_s.t('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(_s.t('delete')),
            ),
          ],
        ),
      ),
    );

    if (confirm != true) return;
    await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
  }

  void _showPeopleDirectorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Directionality(
        textDirection: _s.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          maxChildSize: 0.9,
          builder: (_, controller) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _s.t('select_user'),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final peers = (snapshot.data?.docs ?? [])
                          .where((d) => d.id != _currentUid)
                          .toList();

                      if (peers.isEmpty) {
                        return Center(
                          child: Text(
                            _s.t('no_users'),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: controller,
                        itemCount: peers.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final doc = peers[index];
                          final data = doc.data();
                          final name = (data['name'] ?? 'User') as String;
                          final bio = (data['bio'] ?? '') as String;
                          final emoji = (data['avatarEmoji'] ?? '😊') as String;
                          final photoUrl = data['photoUrl'] as String?;

                          return ListTile(
                            leading: buildUserAvatar(
                              photoUrl: photoUrl,
                              fallbackEmoji: emoji,
                              color: widget.seedColor,
                              radius: 22,
                            ),
                            title: Text(
                              name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              bio,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              _startOrOpenChatWithUser(
                                targetUid: doc.id,
                                targetName: name,
                                targetEmoji: emoji,
                                targetPhotoUrl: photoUrl,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadProfileImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null) return;

    setState(() => _uploadingAvatar = true);
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('avatars')
          .child('$_currentUid.jpg');
      await ref.putFile(File(picked.path));
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUid)
          .set({
        'photoUrl': url,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() => _currentPhotoUrl = url);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_s.t('profile_saved'))),
      );
    } finally {
      if (mounted) {
        setState(() => _uploadingAvatar = false);
      }
    }
  }

  Future<void> _saveProfileData() async {
    final name =
        _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'Wasel User';
    final bio = _bioCtrl.text.trim();

    await FirebaseFirestore.instance.collection('users').doc(_currentUid).set({
      'uid': _currentUid,
      'name': name,
      'bio': bio,
      'phone': _currentPhone,
      'avatarEmoji': _currentEmoji,
      'photoUrl': _currentPhotoUrl ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_s.t('profile_saved'))),
    );
  }

  Future<void> _signOut() async {
    try {
      await _syncUserPresence(false);
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    if (!mounted) return;
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
            languageCode: widget.languageCode,
            onChangeLanguage: widget.onChangeLanguage,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildRealChatsTab(),
      _buildStatusTab(),
      _buildProfileTab(),
      _buildSettingsTab(),
    ];

    final titles = [
      _s.t('app_name'),
      _s.t('tab_status'),
      _s.t('tab_profile'),
      _s.t('tab_settings'),
    ];

    return Directionality(
      textDirection: _s.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: _currentIndex == 0 && _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: _s.t('search_hint'),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                )
              : Text(titles[_currentIndex]),
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
                  _isSearching ? _s.t('close') : _s.t('search'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (_currentIndex != 3)
              TextButton(
                onPressed: () => setState(() => _currentIndex = 3),
                child: Text(
                  _s.t('tab_settings'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        body: pages[_currentIndex],
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton.extended(
                onPressed: _showPeopleDirectorySheet,
                label: Text(_s.t('new_chat')),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: [
            NavigationDestination(
              icon: const Text('💬', style: TextStyle(fontSize: 20)),
              label: _s.t('tab_chats'),
            ),
            NavigationDestination(
              icon: const Text('🟢', style: TextStyle(fontSize: 20)),
              label: _s.t('tab_status'),
            ),
            NavigationDestination(
              icon: const Text('👤', style: TextStyle(fontSize: 20)),
              label: _s.t('tab_profile'),
            ),
            NavigationDestination(
              icon: const Text('⚙️', style: TextStyle(fontSize: 20)),
              label: _s.t('tab_settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealChatsTab() {
    return StreamBuilder<QuerySnapshot>>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: _currentUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('${snapshot.error}', textAlign: TextAlign.center),
            ),
          );
        }

        final docs = (snapshot.data?.docs ?? []).toList();
        docs.sort((a, b) {
          final tsA = a.data()['updatedAt'] as Timestamp?;
          final tsB = b.data()['updatedAt'] as Timestamp?;
          if (tsA == null && tsB == null) return 0;
          if (tsA == null) return 1;
          if (tsB == null) return -1;
          return tsB.compareTo(tsA);
        });

        final filtered = docs.where((doc) {
          if (_searchQuery.trim().isEmpty) return true;
          final data = doc.data();
          final participants = List<String>.from(data['participants'] ?? []);
          final peerUid = participants.firstWhere(
            (id) => id != _currentUid,
            orElse: () => '',
          );
          final names =
              Map<String, dynamic>.from(data['participantNames'] ?? {});
          final peerName = (names[peerUid] ?? '').toString().toLowerCase();
          final lastMsg = (data['lastMessage'] ?? '').toString().toLowerCase();
          final q = _searchQuery.trim().toLowerCase();
          return peerName.contains(q) || lastMsg.contains(q);
        }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_s.t('no_chats'), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _showPeopleDirectorySheet,
                    child: Text(_s.t('new_chat')),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final doc = filtered[index];
            final data = doc.data();
            final participants = List<String>.from(data['participants'] ?? []);
            final peerUid = participants.firstWhere(
              (id) => id != _currentUid,
              orElse: () => '',
            );
            final names =
                Map<String, dynamic>.from(data['participantNames'] ?? {});
            final emojis =
                Map<String, dynamic>.from(data['participantEmojis'] ?? {});
            final photos =
                Map<String, dynamic>.from(data['participantPhotos'] ?? {});

            final peerName = (names[peerUid] ?? 'User') as String;
            final peerEmoji = (emojis[peerUid] ?? '😊') as String;
            final peerPhoto = photos[peerUid] as String?;
            final msgType = (data['lastMessageType'] ?? 'text') as String;
            final rawLastMsg = (data['lastMessage'] ?? '') as String;
            final displayLastMsg =
                msgType == 'image' ? _s.t('photo_msg') : rawLastMsg;

            final ts = data['updatedAt'] as Timestamp?;
            String timeLabel = '';
            if (ts != null) {
              final dt = ts.toDate();
              timeLabel =
                  '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
            }

            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatRoomScreen(
                      chatId: doc.id,
                      currentUid: _currentUid,
                      peerName: peerName,
                      peerEmoji: peerEmoji,
                      peerPhotoUrl: peerPhoto,
                      fontSize: widget.chatFontSize,
                      readReceipts: _readReceipts,
                      strings: _s,
                    ),
                  ),
                );
              },
              onLongPress: () => _deleteChat(doc.id, peerName),
              leading: buildUserAvatar(
                photoUrl: peerPhoto,
                fallbackEmoji: peerEmoji,
                color: widget.seedColor,
                radius: 24,
              ),
              title: Text(
                peerName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                displayLastMsg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                timeLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusTab() {
    const statusEmojis = ['✨', '😎', '☕', '💻', '🎯', '❤️', '🌙', '🚀'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _s.t('my_status'),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: statusEmojis.map((e) {
                      return ChoiceChip(
                        label: Text(e, style: const TextStyle(fontSize: 18)),
                        selected: _statusEmoji == e,
                        onSelected: (_) => setState(() => _statusEmoji = e),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: _themeColors.map((c) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () => setState(() => _statusBgColor = c),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: _statusBgColor == c
                                  ? Border.all(color: Colors.black, width: 2.5)
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _statusTextCtrl,
                    decoration: InputDecoration(
                      hintText: _s.t('status_hint'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _postingStatus ? null : _publishStatus,
                          child: Text(_s.t('post_status')),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _deleteMyStatus,
                        child: Text(_s.t('delete')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _s.t('recent_statuses'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>>(
            stream: FirebaseFirestore.instance
                .collection('statuses')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = (snapshot.data?.docs ?? []).toList();
              if (docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text(_s.t('no_statuses'))),
                );
              }

              return Column(
                children: docs.map((doc) {
                  final data = doc.data();
                  final isMe = doc.id == _currentUid;
                  final name = (data['userName'] ?? 'User') as String;
                  final userEmoji = (data['userEmoji'] ?? '😊') as String;
                  final userPhoto = data['userPhotoUrl'] as String?;
                  final statusText = (data['statusText'] ?? '') as String;
                  final stEmoji = (data['statusEmoji'] ?? '✨') as String;
                  final bgColor = Color(
                    (data['bgColorValue'] as int?) ?? Colors.teal.value,
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: buildUserAvatar(
                        photoUrl: userPhoto,
                        fallbackEmoji: userEmoji,
                        color: bgColor,
                        radius: 24,
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('$stEmoji  $statusText'),
                      trailing: isMe
                          ? null
                          : TextButton(
                              onPressed: () => _showReplyStatusDialog(data),
                              child: Text(_s.t('reply_status')),
                            ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return StreamBuilder<DocumentSnapshot>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? {};
        if (!_profileInitialized && data.isNotEmpty) {
          _nameCtrl.text = (data['name'] ?? '') as String;
          _bioCtrl.text = (data['bio'] ?? '') as String;
          _currentEmoji = (data['avatarEmoji'] ?? '😊') as String;
          _currentPhotoUrl = data['photoUrl'] as String?;
          _profileInitialized = true;
        }

        final quickEmojis = EmojiCatalog.forKey('faces').take(12).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    _uploadingAvatar
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(),
                          )
                        : buildUserAvatar(
                            photoUrl: _currentPhotoUrl,
                            fallbackEmoji: _currentEmoji,
                            color: widget.seedColor,
                            radius: 48,
                          ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: _uploadingAvatar
                              ? null
                              : _pickAndUploadProfileImage,
                          child: Text(_s.t('upload_photo')),
                        ),
                        if (_currentPhotoUrl != null &&
                            _currentPhotoUrl!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_currentUid)
                                  .set({'photoUrl': ''},
                                      SetOptions(merge: true));
                              setState(() => _currentPhotoUrl = '');
                            },
                            child: Text(_s.t('remove_photo')),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: quickEmojis.map((e) {
                  final selected = e == _currentEmoji &&
                      (_currentPhotoUrl == null || _currentPhotoUrl!.isEmpty);
                  return ChoiceChip(
                    label: Text(e, style: const TextStyle(fontSize: 18)),
                    selected: selected,
                    onSelected: (_) => setState(() {
                      _currentEmoji = e;
                      _currentPhotoUrl = '';
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: _s.t('display_name'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bioCtrl,
                decoration: InputDecoration(
                  labelText: _s.t('bio_label'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _saveProfileData,
                child: Text(_s.t('save_profile')),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionHeader(_s.t('sec_language')),
        ListTile(
          title: Text(_s.t('language_label')),
          trailing: DropdownButton<String>(
            value: widget.languageCode,
            items: const [
              DropdownMenuItem(value: 'ar', child: Text('العربية')),
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'de', child: Text('Deutsch')),
            ],
            onChanged: (code) {
              if (code != null) widget.onChangeLanguage(code);
            },
          ),
        ),
        const Divider(),
        _sectionHeader(_s.t('sec_appearance')),
        SwitchListTile(
          title: Text(_s.t('dark_mode')),
          subtitle: Text(_s.t('dark_mode_sub')),
          value: widget.isDarkMode,
          onChanged: widget.onToggleDarkMode,
        ),
        ListTile(
          title: Text(_s.t('theme_color')),
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
          title: Text(_s.t('font_size')),
          subtitle: Text('${widget.chatFontSize.toInt()}'),
        ),
        Slider(
          min: 13,
          max: 21,
          divisions: 8,
          value: widget.chatFontSize,
          onChanged: widget.onChangeChatFontSize,
        ),
        const Divider(),
        _sectionHeader(_s.t('sec_notifications')),
        SwitchListTile(
          title: Text(_s.t('notif_enabled')),
          value: _notificationsEnabled,
          onChanged: (v) => setState(() => _notificationsEnabled = v),
        ),
        SwitchListTile(
          title: Text(_s.t('notif_sound')),
          value: _soundEnabled,
          onChanged: _notificationsEnabled
              ? (v) => setState(() => _soundEnabled = v)
              : null,
        ),
        SwitchListTile(
          title: Text(_s.t('notif_preview')),
          value: _messagePreview,
          onChanged: _notificationsEnabled
              ? (v) => setState(() => _messagePreview = v)
              : null,
        ),
        const Divider(),
        _sectionHeader(_s.t('sec_privacy')),
        SwitchListTile(
          title: Text(_s.t('online_status')),
          value: _showOnlineStatus,
          onChanged: (v) => setState(() => _showOnlineStatus = v),
        ),
        SwitchListTile(
          title: Text(_s.t('read_receipts')),
          value: _readReceipts,
          onChanged: (v) => setState(() => _readReceipts = v),
        ),
        SwitchListTile(
          title: Text(_s.t('auto_media')),
          value: _autoSaveMedia,
          onChanged: (v) => setState(() => _autoSaveMedia = v),
        ),
        const Divider(),
        ListTile(
          title: Text(
            _s.t('logout'),
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onTap: _signOut,
        ),
      ],
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class ChatRoomScreen extends StatefulWidget {
  final String chatId;
  final String currentUid;
  final String peerName;
  final String peerEmoji;
  final String? peerPhotoUrl;
  final double fontSize;
  final bool readReceipts;
  final AppStrings strings;

  const ChatRoomScreen({
    super.key,
    required this.chatId,
    required this.currentUid,
    required this.peerName,
    required this.peerEmoji,
    this.peerPhotoUrl,
    required this.fontSize,
    required this.readReceipts,
    required this.strings,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _showEmojiPicker = false;
  int _emojiCatIndex = 0;
  bool _sendingImage = false;

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendTextMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();

    final chatRef =
        FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

    await chatRef.collection('messages').add({
      'type': 'text',
      'text': text,
      'imageUrl': '',
      'senderId': widget.currentUid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await chatRef.set({
      'lastMessage': text,
      'lastMessageType': 'text',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _sendImageMessage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 75,
    );
    if (picked == null) return;

    setState(() => _sendingImage = true);
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${widget.currentUid}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child(widget.chatId)
          .child(fileName);

      await ref.putFile(File(picked.path));
      final imageUrl = await ref.getDownloadURL();

      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

      await chatRef.collection('messages').add({
        'type': 'image',
        'text': '',
        'imageUrl': imageUrl,
        'senderId': widget.currentUid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await chatRef.set({
        'lastMessage': 'image',
        'lastMessageType': 'image',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } finally {
      if (mounted) {
        setState(() => _sendingImage = false);
      }
    }
  }

  Future<void> _onMessageLongPress({
    required String messageId,
    required String type,
    required String text,
    required bool isMe,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => Directionality(
        textDirection:
            widget.strings.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (type == 'text' && text.isNotEmpty)
                ListTile(
                  title: Text(widget.strings.t('copy')),
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: text));
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              if (isMe)
                ListTile(
                  title: Text(
                    widget.strings.t('delete'),
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    if (ctx.mounted) Navigator.pop(ctx);
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.chatId)
                        .collection('messages')
                        .doc(messageId)
                        .delete();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Directionality(
        textDirection:
            widget.strings.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(widget.strings.t('gallery')),
                onTap: () {
                  Navigator.pop(ctx);
                  _sendImageMessage(ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text(widget.strings.t('camera')),
                onTap: () {
                  Navigator.pop(ctx);
                  _sendImageMessage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _insertEmoji(String emoji) {
    final text = _msgCtrl.text;
    final sel = _msgCtrl.selection;
    final start = sel.isValid ? sel.start : text.length;
    final end = sel.isValid ? sel.end : text.length;
    final updated = text.replaceRange(start, end, emoji);
    _msgCtrl.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  void _openFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            leadingWidth: 80,
            leading: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                widget.strings.t('back'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          body: Center(
            child: InteractiveViewer(child: Image.network(imageUrl)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catKey = EmojiCatalog.categoryKeys[_emojiCatIndex];
    final emojis = EmojiCatalog.forKey(catKey);

    return Directionality(
      textDirection: widget.strings.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.strings.t('back')),
          ),
          title: Row(
            children: [
              buildUserAvatar(
                photoUrl: widget.peerPhotoUrl,
                fallbackEmoji: widget.peerEmoji,
                color: Theme.of(context).colorScheme.primary,
                radius: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(widget.peerName, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            if (_sendingImage) const LinearProgressIndicator(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('createdAt', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final msgs = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: msgs.length,
                    itemBuilder: (context, index) {
                      final doc = msgs[index];
                      final data = doc.data();
                      final isMe = data['senderId'] == widget.currentUid;
                      final type = (data['type'] ?? 'text') as String;
                      final text = (data['text'] ?? '') as String;
                      final imageUrl = (data['imageUrl'] ?? '') as String;
                      final ts = data['createdAt'] as Timestamp?;
                      String timeStr = '';
                      if (ts != null) {
                        final dt = ts.toDate();
                        timeStr =
                            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                      }

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onLongPress: () => _onMessageLongPress(
                            messageId: doc.id,
                            type: type,
                            text: text,
                            isMe: isMe,
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.74,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (type == 'image' && imageUrl.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => _openFullImage(imageUrl),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    text,
                                    style: TextStyle(
                                      color: isMe ? Colors.white : null,
                                      fontSize: widget.fontSize,
                                    ),
                                  ),
                                const SizedBox(height: 2),
                                Text(
                                  isMe && widget.readReceipts
                                      ? '$timeStr • ✓✓'
                                      : timeStr,
                                  style: TextStyle(
                                    color: isMe ? Colors.white70 : Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_showEmojiPicker)
              Container(
                height: 230,
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          EmojiCatalog.categoryKeys.length,
                          (i) {
                            final k = EmojiCatalog.categoryKeys[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(EmojiCatalog.categoryLabel(
                                    k, widget.strings.lang)),
                                selected: i == _emojiCatIndex,
                                onSelected: (_) =>
                                    setState(() => _emojiCatIndex = i),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                        ),
                        itemCount: emojis.length,
                        itemBuilder: (context, idx) {
                          final em = emojis[idx];
                          return GestureDetector(
                            onTap: () => _insertEmoji(em),
                            child: Center(
                              child: Text(em,
                                  style: const TextStyle(fontSize: 23)),
                            ),
                          );
                        },
                      ),
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
                    TextButton(
                      onPressed: _sendingImage ? null : _showImageSourceSheet,
                      child: const Text('📷', style: TextStyle(fontSize: 22)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _msgCtrl,
                        onTap: () {
                          if (_showEmojiPicker) {
                            setState(() => _showEmojiPicker = false);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: widget.strings.t('type_message'),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    FilledButton(
                      onPressed: _sendTextMessage,
                      child: Text(widget.strings.t('send')),
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
