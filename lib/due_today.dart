import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import './file_functions.dart';
import 'package:flutter/material.dart';

class TodayTab extends StatefulWidget {
  const TodayTab({super.key});

  @override
  State<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  final _entryKey = GlobalKey<FormState>();
  final TextEditingController _entryController = TextEditingController();
  DateTime? calendarDate;



  @override
  void initState() {
    super.initState();
    GlobalVariables.updateGlobalItemList();
    updateLists();
  }



  void addToday() {
    storeToFile(_entryController.text, calendarDate);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item added successfully')));
    String date = calendarDate == null ? 'No Due Date' : '${calendarDate!.month}/${calendarDate!.day}/${calendarDate!.year}';
    if(mounted) {
      setState(() {
        GlobalVariables.allItems.add('${_entryController.text}    ($date)');
        updateLists();
      });
    }
    updateLists();

    setState(() {
    });

    _entryController.clear();
    calendarDate = null;
  }


  void removeToday(int index) async{
    String item = GlobalVariables.todayItems[index];

    removeFromFile(GlobalVariables.todayItems[index]);

    if(mounted) {
      setState(() {
        GlobalVariables.allItems.remove(item);
      });
    }
    updateLists();
  }



  void changeDate(int index, DateTime? updatedDate) async{
    changeDateFile(GlobalVariables.todayItems[index], updatedDate);
    String date = updatedDate == null ? 'No Due Date' : '${updatedDate.month}/${updatedDate.day}/${updatedDate.year}';


    //for the loop
    int myIndex = 0;
    for(String s in GlobalVariables.allItems){
      if(s == GlobalVariables.todayItems[index]){
        if(mounted) {
          setState(() {
            s = GlobalVariables.todayItems[index].replaceRange(GlobalVariables.todayItems[index].indexOf('(') + 1, GlobalVariables.todayItems[index].indexOf(')'), date);
            GlobalVariables.allItems[myIndex] = GlobalVariables.todayItems[index].replaceRange(GlobalVariables.todayItems[index].indexOf('(') + 1, GlobalVariables.todayItems[index].indexOf(')'), date);
          });
        }
      }
      ++myIndex;
    }
    updateLists();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30,),
        Form(
          key: _entryKey,
          child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 200,
              child: TextFormField(
                controller: _entryController,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'Type...',
                    border: OutlineInputBorder()
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please type an item';
                  }
                  return null;
                },
              ),),
            IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                onPressed: () async{
              final newDate = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(),
                  dialogSize: const Size(325, 400),
              );
              setState(() {
                calendarDate = newDate?[0];
              });
            },
                icon: const Icon(Icons.calendar_month)),
          ],
        ),
        ),
        const SizedBox(height: 30,),
        SizedBox(width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: (){
                if(_entryKey.currentState!.validate()) {
                  addToday();
                }
              },
              child: const Text('Add Item', style: TextStyle(color: Colors.white),)),),
        const SizedBox(height: 20,),
        Expanded(child:
        ListView.builder(
            itemCount: GlobalVariables.todayItems.length,
            itemBuilder: (context, index){
              return Card(
                color: Colors.deepPurpleAccent,
                child: ListTile(
                  onLongPress: () => removeToday(index),
                  onTap: () async{
                    final newDate = await showCalendarDatePicker2Dialog(
                      context: context,
                      config: CalendarDatePicker2WithActionButtonsConfig(),
                      dialogSize: const Size(325, 400),
                    );
                    changeDate(index, newDate?[0]);
                  },
                  title: Text(GlobalVariables.todayItems[index], style: const TextStyle(color: Colors.white),),
                ),
              );
            }
        ))
      ],
    );
  }
}
