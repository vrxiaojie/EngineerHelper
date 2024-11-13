import 'package:flutter/material.dart';
import 'PowerPage.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {}

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
        page = HomePage(); // 主页面
        break;
      case 1:
        page = PowerPage(); // 电源页面
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                minExtendedWidth: 150,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('主页'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.power),
                    label: Text('电源'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

// 主页面

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Flex(
        direction: Axis.vertical, // 设置为垂直方向布局
        children: [
          // 第一行：两个容器
          Flexible(
            flex: 1, // 控制占用空间比例
            child: Row(
              children: [
                // 第一个容器：大标题
                Flexible(
                  flex: 2, // 大标题占用更多空间
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
                // 第二个容器：图片
                Flexible(
                  flex: 1, // 图片占用剩余空间
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.blue[50],
                    child: Image.asset(
                      'assets/bilibili.png', // 确保图片存在
                      height: 60, // 限制图片高度
                      fit: BoxFit.contain, // 保证图片适应容器
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // 添加空隙
          // 第三行：GitHub logo
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                // 使用 url_launcher 跳转到GitHub
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
                  'assets/github.png', // 确保图片存在
                  height: 60, // 限制图片高度
                  fit: BoxFit.contain, // 保证图片适应容器
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // 添加空隙
          // 第四行：版本号
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
