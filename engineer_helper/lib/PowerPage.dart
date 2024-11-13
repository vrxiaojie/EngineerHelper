// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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

  String resultK = '',
      resultDeltaVin = '',
      resultDeltaVout = '',
      resultIpeak = '',
      resultIrms = '',
      resultD = '',
      resultTon = '',
      resultToff = '',
      resultIin = '';
  @override
  void initState() {
    super.initState();
    setDefaultValue();
  }

  void setDefaultValue() {
    // 设置初始值
    vinMinController.text = '5.0';
    vinMaxController.text = '5.0';
    vOutController.text = '9.0';
    iOutController.text = '1.0';
    fController.text = '1.0';
    cinController.text = '10.0';
    coutController.text = '10.0';
    cinEsrController.text = '0';
    coutEsrController.text = '0';
    lController.text = '1';
    resultK = '';
    resultDeltaVin = '';
    resultDeltaVout = '';
    resultIpeak = '';
    resultIrms = '';
    resultD = '';
    resultTon = '';
    resultToff = '';
    resultIin = '';
    setState(() {});
  }

  void calResult(
      double? vinMin, vinMax, vOut, iOut, f, cin, cout, cinEsr, coutEsr, l) {
    resultK =
        (vinMin! / (l! * f! * iOut!) * (1 - (vinMin / vOut!)) * (vinMin / vOut))
            .toStringAsFixed(3);

    resultDeltaVin = ((vinMin / (l * f) * (1 - (vinMin / vOut))) *
            (cinEsr! + 1 / (8 * f * cin!)))
        .toStringAsFixed(3);

    resultDeltaVout =
        (((vOut * iOut / vinMin) + vinMin / (2 * l * f) * (1 - vinMin / vOut)) *
                    coutEsr! +
                iOut / (f * cout!) * (1 - vinMin / vOut))
            .toStringAsFixed(3);

    resultIpeak =
        ((vOut * iOut / vinMin) + vinMin / (2 * f * l) * (1 - vinMin / vOut))
            .toStringAsFixed(3);

    resultIrms = (vOut * iOut / vinMin).toStringAsFixed(3);

    resultD = ((1 - vinMax! / vOut) * 100).toStringAsFixed(1);

    resultTon = ((1 - vinMax / vOut) / f).toStringAsFixed(3);

    resultToff = (vinMax / (vOut * f)).toStringAsFixed(3);

    resultIin = (vOut * iOut / vinMin).toStringAsFixed(3);

    //更新状态
    setState(() {});
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
                        labelText: '电感值L',
                        suffixText: 'uH',
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  // 计算按钮
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final vinMin = double.tryParse(vinMinController.text);
                          final vinMax = double.tryParse(vinMaxController.text);
                          final vOut = double.tryParse(vOutController.text);
                          final iOut = double.tryParse(iOutController.text);
                          final f = double.tryParse(fController.text);
                          final cin = double.tryParse(cinController.text);
                          final cout = double.tryParse(coutController.text);
                          final cinEsr = double.tryParse(cinEsrController.text);
                          final coutEsr =
                              double.tryParse(coutEsrController.text);
                          final l = double.tryParse(lController.text);

                          // Check if vinMin is greater than vinMax
                          if (vinMin != null &&
                              vinMax != null &&
                              vinMin > vinMax) {
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
                            return;
                          }
                          calResult(vinMin, vinMax, vOut, iOut, f, cin, cout,
                              cinEsr, coutEsr, l);
                        }
                      },
                      icon: Icon(Icons.calculate), // Icon for calculate button
                      label: Text('计算'),
                    ),
                  ),
                  SizedBox(
                      width: 16), // Increase the space between the two buttons
                  // 重置按钮
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setDefaultValue(); // Reset values
                      },
                      icon: Icon(Icons.refresh), // Icon for reset button
                      label: Text('重置'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('电感电流纹波率K:'),
                        Text(resultK.isEmpty ? '' : resultK), // 用来显示计算结果
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('输入纹波ΔVin:'),
                        Text(resultDeltaVin.isEmpty ? '' : '$resultDeltaVin V'),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('输出纹波ΔVout:'),
                        Text(resultDeltaVout.isEmpty
                            ? ''
                            : '$resultDeltaVout V'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('电感峰值电流 Ipeak:'),
                        Text(resultIpeak.isEmpty ? '' : '$resultIpeak A'),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('电感电流有效值Irms:'),
                        Text(resultIrms.isEmpty ? '' : '$resultIrms A'),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('占空比D:'),
                        Text(resultD.isEmpty ? '' : '$resultD %'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('导通时间Ton:'),
                        Text(resultTon.isEmpty ? '' : '$resultTon us'),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('关断时间Toff:'),
                        Text(resultToff.isEmpty ? '' : '$resultToff us'),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('平均输入电流 Iin:'),
                        Text(resultIin.isEmpty ? '' : '$resultIin A'),
                      ],
                    ),
                  ),
                ],
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
