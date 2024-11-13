// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  void initState() {
    super.initState();
    // 给Vinmin设置初始值
    vinMinController.text = '5.0'; // 初始值设为 5.0 或其他值
    vinMaxController.text = '5.0';
    vOutController.text = '5.0';
    vOutController.text = '3.3';
    iOutController.text = '1.0';
    fController.text = '1.0';
    cinController.text = '10.0';
    coutController.text = '10.0';
  }

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
                      decoration: InputDecoration(
                        labelText: '最小输入电压Vinmin',
                        suffixText: 'V',
                      ),
                      // onTap: () {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('1222')),
                      //   );
                      // },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                        // 只允许数字和小数点
                      ],
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
                      decoration: InputDecoration(
                        labelText: '最大输入电压Vinmax',
                        suffixText: 'V',
                      ),
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
                      decoration: InputDecoration(
                        labelText: '输出电压Vout',
                        suffixText: 'V',
                      ),
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
                      decoration: InputDecoration(
                        labelText: '输出电流Iout',
                        suffixText: 'A',
                      ),
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
                      decoration: InputDecoration(
                        labelText: '开关频率f',
                        suffixText: 'MHz',
                      ),
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
                      decoration: InputDecoration(
                        labelText: '输入电容Cin',
                        suffixText: 'uF',
                      ),
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
                      decoration: InputDecoration(
                        labelText: '输出电容Cout',
                        suffixText: 'uF',
                      ),
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
                      decoration: InputDecoration(
                        labelText: '输入电容直流等效电阻Cin_ESR(可选)',
                        suffixText: 'mΩ',
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: coutEsrController,
                      decoration: InputDecoration(
                        labelText: '输出电容直流等效电阻Cout_ESR(可选)',
                        suffixText: 'mΩ',
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                      decoration: InputDecoration(
                        labelText: '电感值L(可选)',
                        suffixText: 'uH',
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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

                    // 检查 vinMin 是否大于 vinMax
                    if (vinMin != null && vinMax != null && vinMin > vinMax) {
                      // 弹窗警告用户
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('输入错误'),
                            content: Text('Vinmin 不能大于 Vinmax'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('确定'),
                              ),
                            ],
                          );
                        },
                      );
                      return; // 如果 vinMin 大于 vinMax，则返回，避免进行后续计算
                    }

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
