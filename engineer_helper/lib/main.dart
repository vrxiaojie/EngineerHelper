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
        page = const ToolsPage(); // 工具页面（由电源页面改名并更新内容）
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
            icon: Icon(Icons.build), // 工具图标
            label: '工具',
          ),
        ],
      ),
    );
  }
}

// 新的工具页面
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2, // 固定为两列
        crossAxisSpacing: 16.0, // 列之间的间距
        mainAxisSpacing: 16.0, // 行之间的间距
        childAspectRatio: 4.5, // 控制每个按钮的宽高比（2.5 表示宽是高的 2.5 倍）
        shrinkWrap: true, // 让 GridView 适配内容大小
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PowerBoostPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 按钮圆角
              ),
            ),
            child: const Text(
              'BOOST',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PowerBuckPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'BUCK',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PowerLDOPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'LDO',
              style: TextStyle(color: Colors.black),
            ),
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
                'v0.0.2',
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
