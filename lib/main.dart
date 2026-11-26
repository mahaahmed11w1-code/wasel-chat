class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasel Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('تم تسجيل الدخول بنجاح'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'المحادثات'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الحساب'),
        ],
      ),
    );
  }
}
