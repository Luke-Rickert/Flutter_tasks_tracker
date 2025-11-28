import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import './file_functions.dart';

class DueLaterTab extends StatefulWidget {
  const DueLaterTab({super.key});

  @override
  State<DueLaterTab> createState() => _DueLaterTabState();
}

class _DueLaterTabState extends State<DueLaterTab> {
  final TextEditingController _entryController = TextEditingController();
  DateTime? calendarDate;
  final _entryKey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    GlobalVariables.updateGlobalItemList();
    updateLists();
  }


  void addThisWeek() async{
      storeToFile(_entryController.text, calendarDate);
      String date = calendarDate == null ? 'No Due Date' : '${calendarDate?.month}/${calendarDate?.day}/${calendarDate?.year}';

      if(mounted) {
        setState(() {
          GlobalVariables.allItems.add('${_entryController.text}    ($date)');
          updateLists();
        });
      }
      updateLists();

      setState(() {
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item added successfully')));

    _entryController.clear();
    calendarDate = null;
  }


  void removeThisWeek(int index) async{
    String item = GlobalVariables.dueLaterItems[index];

    removeFromFile(GlobalVariables.dueLaterItems[index]);

    if(mounted) {
      setState(() {
        GlobalVariables.allItems.remove(item);
      });
    }
    updateLists();
  }



  void changeDate(int index, DateTime? updatedDate) async{
    changeDateFile(GlobalVariables.dueLaterItems[index], updatedDate);
    String date = updatedDate == null ? 'No Due Date' : '${updatedDate.month}/${updatedDate.day}/${updatedDate.year}';


    //for the loop
    int myIndex = 0;
    for(String s in GlobalVariables.allItems){
      if(s == GlobalVariables.dueLaterItems[index]){
        if(mounted) {
          setState(() {
            s = GlobalVariables.dueLaterItems[index].replaceRange(GlobalVariables.dueLaterItems[index].indexOf('(') + 1, GlobalVariables.dueLaterItems[index].indexOf(')'), date);
            GlobalVariables.allItems[myIndex] = GlobalVariables.dueLaterItems[index].replaceRange(GlobalVariables.dueLaterItems[index].indexOf('(') + 1, GlobalVariables.dueLaterItems[index].indexOf(')'), date);
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
                style: IconButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                icon: const Icon(Icons.calendar_month)),
          ],
        ),),
        const SizedBox(height: 30,),
        SizedBox(width: 150,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: (){
                if(_entryKey.currentState!.validate()){
                  addThisWeek();
                }
              },
              child: const Text('Add Item', style: TextStyle(color: Colors.white))),),
        const SizedBox(height: 20,),
        Expanded(child:
        ListView.builder(
            itemCount: GlobalVariables.dueLaterItems.length,
            itemBuilder: (context, index){
              return Card(
                color: Colors.deepPurpleAccent,
                child: ListTile(
                  onLongPress: () => removeThisWeek(index),
                  onTap: () async{
                    final newDate = await showCalendarDatePicker2Dialog(
                      context: context,
                      config: CalendarDatePicker2WithActionButtonsConfig(),
                      dialogSize: const Size(325, 400),
                    );
                    changeDate(index, newDate?[0]);
                  },
                  title: Text(GlobalVariables.dueLaterItems[index], style: const TextStyle(color: Colors.white),),
                ),
              );
            }
        ))
      ],
    );
  }
}
