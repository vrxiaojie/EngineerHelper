import 'package:flutter/material.dart';

// 电源页面
class PowerPage extends StatefulWidget {
  @override
  State<PowerPage> createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = PowerBoostPage(); // BOOST子页面
        break;
      case 1:
        page = PowerBuckPage(); // BUCK子页面
        break;
      case 2:
        page = PowerLdoPage(); // LDO子页面
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('电源'),
      ),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: true,
              minExtendedWidth: 100,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.trending_up),
                  label: Text('BOOST'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.flash_on),
                  label: Text('BUCK'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.power),
                  label: Text('LDO'),
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
  }
}

// BOOST 子页面
class PowerBoostPage extends StatefulWidget {
  @override
  _PowerBoostPageState createState() => _PowerBoostPageState();
}

class _PowerBoostPageState extends State<PowerBoostPage> {
  final _formKey = GlobalKey<FormState>();

  // 控制器，用于获取用户输入的值
  final TextEditingController vinMinController = TextEditingController();
  final TextEditingController vinMaxController = TextEditingController();
  final TextEditingController vOutController = TextEditingController();
  final TextEditingController iOutController = TextEditingController();
  final TextEditingController fController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
  final TextEditingController coutController = TextEditingController();
  final TextEditingController cinEsrController = TextEditingController();
  final TextEditingController coutEsrController = TextEditingController();
  final TextEditingController lController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Boost电路参数设置',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 16),

              // 第一行输入框：Vinmin, Vinmax, Vout
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: vinMinController,
                      decoration: InputDecoration(labelText: 'Vinmin'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入Vinmin';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: vinMaxController,
                      decoration: InputDecoration(labelText: 'Vinmax'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入Vinmax';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: vOutController,
                      decoration: InputDecoration(labelText: 'Vout'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入Vout';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // 第二行输入框：Iout, f, Cin
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: iOutController,
                      decoration: InputDecoration(labelText: 'Iout'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入Iout';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: fController,
                      decoration: InputDecoration(labelText: 'f'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入f';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: cinController,
                      decoration: InputDecoration(labelText: 'Cin'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入Cin';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // 第三行输入框：Cout, Cin_ESR, Cout_ESR
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: coutController,
                      decoration: InputDecoration(labelText: 'Cout'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入Cout';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: cinEsrController,
                      decoration: InputDecoration(labelText: 'Cin_ESR'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入Cin_ESR';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: coutEsrController,
                      decoration: InputDecoration(labelText: 'Cout_ESR'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入Cout_ESR';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // 第四行输入框：L
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: lController,
                      decoration: InputDecoration(labelText: 'L'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入L';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // 提交按钮
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // 获取用户输入的值并进行后台计算
                    final vinMin = double.tryParse(vinMinController.text);
                    final vinMax = double.tryParse(vinMaxController.text);
                    final vOut = double.tryParse(vOutController.text);
                    final iOut = double.tryParse(iOutController.text);
                    final f = double.tryParse(fController.text);
                    final cin = double.tryParse(cinController.text);
                    final cout = double.tryParse(coutController.text);
                    final cinEsr = double.tryParse(cinEsrController.text);
                    final coutEsr = double.tryParse(coutEsrController.text);
                    final l = double.tryParse(lController.text);

                    // 进行后台计算（示例）
                    print(
                        'Vinmin: $vinMin, Vinmax: $vinMax, Vout: $vOut, Iout: $iOut, f: $f, Cin: $cin, Cout: $cout, Cin_ESR: $cinEsr, Cout_ESR: $coutEsr, L: $l');
                  }
                },
                child: Text('计算'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BUCK 子页面
class PowerBuckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('BUCK Page'));
  }
}

// LDO 子页面
class PowerLdoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('LDO Page'));
  }
}
