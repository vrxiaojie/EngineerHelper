import 'package:flutter/material.dart';
import 'PowerPage.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '电子工程师助手',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HomePage(); // 主页面
        break;
      case 1:
        page = const PowerPageWithDrawer(); // 电源页面（添加了抽屉菜单）
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.power),
            label: '电源',
          ),
        ],
      ),
    );
  }
}

// 主页面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Flex(
        direction: Axis.vertical, // 设置为垂直方向布局
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blue[100],
                    child: Text(
                      '电子工程师助手',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blue[50],
                    child: Image.asset(
                      'assets/bilibili.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                final url = Uri.parse('https://github.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.blue[50],
                child: Image.asset(
                  'assets/github.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue[100],
              child: Text(
                'V0.0.1',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 电源页面添加抽屉菜单
class PowerPageWithDrawer extends StatelessWidget {
  const PowerPageWithDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('电源页面'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                '功能选项',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bolt),
              title: const Text('BOOST'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PowerBoostPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text('BUCK'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PowerBuckPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.electrical_services),
              title: const Text('LDO'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PowerLDOPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('电源页面内容')),
    );
  }
}
