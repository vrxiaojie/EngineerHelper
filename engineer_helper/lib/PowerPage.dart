// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// BOOST 子页面
class PowerBoostPage extends StatefulWidget {
  const PowerBoostPage({super.key});

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
    cin /= 1000000;
    cout /= 1000000;
    cinEsr /= 1000;
    coutEsr /= 1000;
    f *= 1000000;
    l /= 1000000;
    resultK =
        (vinMin! / (l! * f! * iOut!) * (1 - (vinMin / vOut!)) * (vinMin / vOut))
            .toStringAsFixed(3);

    resultDeltaVin = (((vinMin / (l * f) * (1 - (vinMin / vOut))) *
                (cinEsr! + 1 / (8 * f * cin!))) *
            1000)
        .toStringAsFixed(0);

    resultDeltaVout = ((((vOut * iOut / vinMin) +
                        vinMin / (2 * l * f) * (1 - vinMin / vOut)) *
                    coutEsr! +
                iOut / (f * cout!) * (1 - vinMin / vOut)) *
            1000)
        .toStringAsFixed(0);

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
    return Scaffold(
        appBar: AppBar(
          title: Text('Boost电路参数设置'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 返回上一级页面
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  // 计算按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final vinMin =
                                  double.tryParse(vinMinController.text);
                              final vinMax =
                                  double.tryParse(vinMaxController.text);
                              final vOut = double.tryParse(vOutController.text);
                              final iOut = double.tryParse(iOutController.text);
                              final f = double.tryParse(fController.text);
                              final cin = double.tryParse(cinController.text);
                              final cout = double.tryParse(coutController.text);
                              final cinEsr =
                                  double.tryParse(cinEsrController.text);
                              final coutEsr =
                                  double.tryParse(coutEsrController.text);
                              final l = double.tryParse(lController.text);

                              // 检查vin min 是否大于了vin max
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
                                vinMinController.text =
                                    double.tryParse(vinMaxController.text)
                                        .toString();
                                return;
                              }
                              // 检查vin max 是否大于了vout
                              if (vinMax! >= vOut!) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('输入错误'),
                                      content: Text('VinMax 不能大于等于 Vout'),
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
                                vinMaxController.text =
                                    (double.tryParse(vOutController.text)! - 1)
                                        .toString();
                                return;
                              }
                              //计算结果
                              calResult(vinMin, vinMax, vOut, iOut, f, cin,
                                  cout, cinEsr, coutEsr, l);
                            }
                          },
                          icon: Icon(
                              Icons.calculate), // Icon for calculate button
                          label: Text('计算'),
                        ),
                      ),
                      SizedBox(
                          width:
                              16), // Increase the space between the two buttons
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

                  //计算结果第一行
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('电感电流纹波率K:'),
                            Text(
                              resultK.isEmpty ? '' : resultK,
                            ), // 用来显示计算结果
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('输入纹波ΔVin:'),
                            Text(resultDeltaVin.isEmpty
                                ? ''
                                : '$resultDeltaVin mV'),
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
                                : '$resultDeltaVout mV'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  //计算结果第二行
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
                  //计算结果第三行
                  Row(
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
        ));
  }
}

// BUCK 子页面
class PowerBuckPage extends StatefulWidget {
  const PowerBuckPage({super.key});

  @override
  State<PowerBuckPage> createState() => _PowerBuckPageState();
}

class _PowerBuckPageState extends State<PowerBuckPage> {
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
    vOutController.text = '3.3';
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
    cin /= 1000000;
    cout /= 1000000;
    cinEsr /= 1000;
    coutEsr /= 1000;
    f *= 1000000;
    l /= 1000000;

    resultK =
        (vOut! / (l! * f! * iOut!) * (1 - (vOut / vinMin!))).toStringAsFixed(3);

    resultDeltaVin = ((iOut /
                    (cin * f) *
                    vOut /
                    vinMin *
                    (1 - (vOut / vinMin)) +
                (iOut + (vOut / (2 * f * l) * (1 - vOut / vinMin))) * cinEsr) *
            1000)
        .toStringAsFixed(0);

    resultDeltaVout = (((vOut /
                (f * l) *
                (1 - (vOut / vinMin)) *
                (coutEsr + 1 / (8 * f * cout))) *
            1000))
        .toStringAsFixed(0);

    resultIpeak =
        (iOut + vOut / (2 * f * l) * (1 - vOut / vinMin)).toStringAsFixed(3);

    resultIrms = iOut.toStringAsFixed(3);

    resultD = ((vOut / vinMax) * 100).toStringAsFixed(1);

    resultTon = ((vOut / vinMax / f) * 1000000).toStringAsFixed(3);

    resultToff = (((1 - vOut / vinMax) / f) * 1000000).toStringAsFixed(3);

    resultIin = (vOut * iOut / vinMin).toStringAsFixed(3);

    //更新状态
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Buck电路参数设置'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 返回上一级页面
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  // 计算按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final vinMin =
                                  double.tryParse(vinMinController.text);
                              final vinMax =
                                  double.tryParse(vinMaxController.text);
                              final vOut = double.tryParse(vOutController.text);
                              final iOut = double.tryParse(iOutController.text);
                              final f = double.tryParse(fController.text);
                              final cin = double.tryParse(cinController.text);
                              final cout = double.tryParse(coutController.text);
                              final cinEsr =
                                  double.tryParse(cinEsrController.text);
                              final coutEsr =
                                  double.tryParse(coutEsrController.text);
                              final l = double.tryParse(lController.text);

                              // 检查vin min 是否大于了vin max
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
                                vinMinController.text =
                                    double.tryParse(vinMaxController.text)
                                        .toString();
                                return;
                              }
                              // 检查vin max 是否小于了vout
                              if (vinMax! <= vOut!) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('输入错误'),
                                      content: Text('VinMax 不能小于等于 Vout'),
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
                                vinMaxController.text =
                                    (double.tryParse(vOutController.text)! - 1)
                                        .toString();
                                return;
                              }
                              //计算结果
                              calResult(vinMin, vinMax, vOut, iOut, f, cin,
                                  cout, cinEsr, coutEsr, l);
                            }
                          },
                          icon: Icon(
                              Icons.calculate), // Icon for calculate button
                          label: Text('计算'),
                        ),
                      ),
                      SizedBox(
                          width:
                              16), // Increase the space between the two buttons
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

                  //计算结果第一行
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('电感电流纹波率K:'),
                            Text(
                              resultK.isEmpty ? '' : resultK,
                            ), // 用来显示计算结果
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('输入纹波ΔVin:'),
                            Text(resultDeltaVin.isEmpty
                                ? ''
                                : '$resultDeltaVin mV'),
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
                                : '$resultDeltaVout mV'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  //计算结果第二行
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
                  //计算结果第三行
                  Row(
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
        ));
  }
}

// LDO 子页面
class PowerLDOPage extends StatefulWidget {
  const PowerLDOPage({super.key});

  @override
  State<PowerLDOPage> createState() => _PowerLDOPageState();
}

class _PowerLDOPageState extends State<PowerLDOPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController vinController = TextEditingController();
  final TextEditingController voutController = TextEditingController();
  final TextEditingController ioutController = TextEditingController();
  final TextEditingController vdropController = TextEditingController();
  final TextEditingController RController = TextEditingController();
  final TextEditingController jAController = TextEditingController();
  final TextEditingController envTempController = TextEditingController();

  String resultRmax = '',
      resultP_R = '',
      resultP_LDO = '',
      resultEfficiency = '',
      resultDeltaT = '',
      resultJunctionTemp = '';
  @override
  void setDefaultValue() {
    // 设置初始值
    vinController.text = '5.0';
    voutController.text = '3.3';
    ioutController.text = '1.0';
    vdropController.text = '1.0';
    RController.text = '0.0';
    jAController.text = '25';
    envTempController.text = '25';
    resultRmax = '';
    resultP_R = '';
    resultP_LDO = '';
    resultEfficiency = '';
    resultDeltaT = '';
    resultJunctionTemp = '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setDefaultValue();
  }

  void calResult(double? vin, vout, iout, vdrop, r, jA, envtemp) {
    //更新状态
    resultRmax = ((vin! - vout - vdrop) / iout).toStringAsFixed(1);
    resultP_R = (iout * iout * r).toStringAsFixed(1);
    resultP_LDO = ((vin - iout * r - vout) * iout).toStringAsFixed(1);
    resultEfficiency = (vout / (vin - iout * r) * 100).toStringAsFixed(1);
    resultDeltaT = (((vin - iout * r - vout) * iout) * jA).toStringAsFixed(1);
    resultJunctionTemp =
        (((vin - iout * r - vout) * iout) * jA + envtemp).toStringAsFixed(1);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('LDO电路参数设置'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // 返回上一级页面
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 第一行输入框：Vin, Vout,iout
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: vinController,
                          decoration: InputDecoration(
                            labelText: '输入电压Vin',
                            suffixText: 'V',
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$')),
                            // 只允许数字和小数点
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入Vin';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: voutController,
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
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: ioutController,
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
                    ],
                  ),
                  SizedBox(height: 8),

                  // 第二行输入框：Iout, f, Cin
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: vdropController,
                          decoration: InputDecoration(
                            labelText: '压差Vdropout',
                            suffixText: 'V',
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入Vdropout';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: RController,
                          decoration: InputDecoration(
                            labelText: '串联分压电阻R',
                            suffixText: 'Ω',
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: jAController,
                          decoration: InputDecoration(
                            labelText: 'LDO热阻θjA',
                            suffixText: '℃/W',
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入θjA';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // 第三行输入框：L
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: envTempController,
                          decoration: InputDecoration(
                            labelText: '环境温度T',
                            suffixText: '℃',
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入θjA';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // 计算按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final vin = double.tryParse(vinController.text);
                              final vout = double.tryParse(voutController.text);
                              final iout = double.tryParse(ioutController.text);
                              final vdrop =
                                  double.tryParse(vdropController.text);
                              final r = double.tryParse(RController.text);
                              final jA = double.tryParse(jAController.text);
                              final envtemp =
                                  double.tryParse(envTempController.text);

                              // 检查vin 是否小于了vout
                              if (vin! <= vout!) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('输入错误'),
                                      content: Text('Vin 不能小于等于 Vout'),
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
                                vinController.text =
                                    (double.tryParse(voutController.text)! - 1)
                                        .toString();
                                return;
                              }
                              //计算结果
                              calResult(vin, vout, iout, vdrop, r, jA, envtemp);
                            }
                          },
                          icon: Icon(
                              Icons.calculate), // Icon for calculate button
                          label: Text('计算'),
                        ),
                      ),
                      SizedBox(
                          width:
                              16), // Increase the space between the two buttons
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

                  //计算结果第一行
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('最大电阻值Rmax:'),
                            Text(
                              resultRmax.isEmpty ? '' : "$resultRmax Ω",
                            ), // 用来显示计算结果
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('电阻功耗PR:'),
                            Text(resultP_R.isEmpty ? '' : '$resultP_R W'),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LDO功耗PLDO:'),
                            Text(resultP_LDO.isEmpty ? '' : '$resultP_LDO W'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  //计算结果第二行
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LDO效率:'),
                            Text(resultEfficiency.isEmpty
                                ? ''
                                : '$resultEfficiency %'),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LDO结温温升ΔT:'),
                            Text(resultDeltaT.isEmpty ? '' : '$resultDeltaT ℃'),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LDO结温T:'),
                            Text(resultJunctionTemp.isEmpty
                                ? ''
                                : '$resultJunctionTemp ℃'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ));
  }
}
