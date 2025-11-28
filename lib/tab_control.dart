import 'package:cs318final_project/account.dart';
import 'package:cs318final_project/due_later.dart';
import 'package:cs318final_project/overdue.dart';
import 'package:flutter/material.dart';
import './due_today.dart';
import './file_functions.dart';


class TaskManager extends StatefulWidget {
  const TaskManager({super.key});


  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Task Manager', style: TextStyle(color: Colors.white),),
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.logout), style: IconButton.styleFrom(foregroundColor: Colors.white),),
            backgroundColor: Colors.deepPurple,
            // fixme add search with "actions"
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){
                    showSearch(context: context, delegate: mySearch());
                  },
                    icon: const Icon(Icons.search), style: IconButton.styleFrom(foregroundColor: Colors.white),),
                  const SizedBox(width: 40,),
                ],
              )
            ],
            bottom: const TabBar(
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Today',),
                  Tab(text: 'Due Later',),
                  Tab(text: 'Overdue!',),
                  Tab(text: 'Account',)
                ]),
          ),
          body: const TabBarView(
              children: [
                TodayTab(),
                DueLaterTab(),
                OverdueTab(),
                AccountTab()
              ]),
        ));
  }
}


class mySearch extends SearchDelegate {


  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () {query = '';}, icon: const Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){close(context, null); },
        icon: const Icon(Icons.arrow_back));
  }


  @override
  Widget buildSuggestions(BuildContext context){
    List<String> matchQuerey = [];
    for(var item in GlobalVariables.allItems){
      if(item.toLowerCase().contains(query.toLowerCase())){
        matchQuerey.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuerey.length,
      itemBuilder: (context, index){
        var result = matchQuerey[index];
        return ListTile(
          title: Text(result),
        );
      });
  }


  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in GlobalVariables.allItems){
      if(item.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onLongPress: () {
            removeFromFile(result);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item removed successfully')));
          },
          title: Text(result),
        );
      },
    );
  }
}
