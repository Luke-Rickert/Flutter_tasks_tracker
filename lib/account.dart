import 'package:cs318final_project/file_functions.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';


class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Hi ${GlobalVariables.currentUsername}, Here is your current task status',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(25),
              child: PieChart(
                  dataMap: GlobalVariables.completionData,
                  legendOptions: const LegendOptions(legendPosition: LegendPosition.right),
                  chartValuesOptions: const ChartValuesOptions(showChartValues: true),
              ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Log Out', style: TextStyle(color: Colors.white),))
        ],
      ),
    );
  }
}
