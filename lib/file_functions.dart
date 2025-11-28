import 'dart:io';


class GlobalVariables{

  static String currentUsername = '';
  static Map<String, String> currentUsers = {};
  static List<String> allItems = [];
  static List<String> todayItems = [];
  static List<String> overdueItems = [];
  static List<String> dueLaterItems = [];

  static Map<String, double> completionData = {
    'Overdue!!!' : 0,
    'Due Today' : 0,
    'Due Later' : 0,
  };

  //Makes a universal list of all items
  static Future<void> updateGlobalItemList() async{
    List<String> tempList = await showAll();
    allItems = [];
    for(String items in tempList) {
      if(items.split('|')[1] == currentUsername){
        allItems.add(items.split('|')[0]);
      }
    }
  }

  //Ought to make a map with all usernames and passwords
  static void createGlobalUserList() async{
    Map<String, String> tempString = await findUser();
    currentUsers = tempString;
  }


  static void addToTodayList(String str){
    todayItems.add(str);
  }
}

//class FileOperations {
  var file = File('C:\\Users\\user\\StudioProjects\\cs318final_project\\lib\\data.txt');
  var users = File('C:\\Users\\user\\StudioProjects\\cs318final_project\\lib\\users.txt');


  void storeToFile(String myString, DateTime? calendarDate) async{
    String date = calendarDate == null ? 'No Due Date' : '${calendarDate.month}/${calendarDate.day}/${calendarDate.year}';
    myString += '    ($date)|${GlobalVariables.currentUsername}|\n';
    await file.writeAsString(myString, mode: FileMode.append);
  }

  void createNewAccount(String name, String username, String password) async{
    name += '|$username|$password|\n';
    await users.writeAsString(name, mode: FileMode.append);
  }


  //Removes item from file by item and date
  Future<void> removeFromFile(String myString) async {
    List<String> myList = await showAll();
    List<String> newList = [];
    for(String entry in myList){
      List<String> line = entry.split('|');
      if(line[0] != myString || line[1] != GlobalVariables.currentUsername){
        newList.add(entry);
      }
    }

    await file.writeAsString('', mode: FileMode.write);
    for(String line in newList) {
      line += '\n';
      await file.writeAsString(line, mode: FileMode.append);
    }
  }


  //Operates on the file data
Future<void> changeDateFile(String myString, DateTime? newDate) async {
  String date = newDate == null ? 'No Due Date' : '${newDate.month}/${newDate.day}/${newDate.year}';
  List<String> myList = await showAll();
  List<String> newList = [];
  for(String entry in myList){
    List<String> line = entry.split('|');
    if(line[0] == myString && line[1] == GlobalVariables.currentUsername){
      entry = entry.replaceRange(line[0].indexOf('(') + 1, line[0].indexOf(')'), date);
    }
    newList.add(entry);
  }
  await file.writeAsString('', mode: FileMode.write);
  for(String line in newList) {
    line += '\n';
    await file.writeAsString(line, mode: FileMode.append);
  }
}


void updateLists() {
    //fixme probably unneccessary await GlobalVariables.updateGlobalItemList();
  List<String> todayList = [];
  List<String> oldList = [];
  List<String> futureList = [];
  for(String item in GlobalVariables.allItems) {
    List<String> line = item.split('|');
    String date = line[0].split('(')[1].replaceAll(')', ''); //separates the date
      //Adds to today list
      if (date != 'No Due Date') {
        List<String> datePiece = date.split('/'); //splits the date
        if (date == '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}') {
          todayList.add(line[0]);
        }
        //for the Overdue items in oldList
        else if (int.parse(datePiece[2]) < DateTime.now().year) {
          oldList.add(line[0]);
        }
        else if (int.parse(datePiece[2]) == DateTime.now().year && int.parse(datePiece[0]) < DateTime.now().month) {
          oldList.add(line[0]);
        }
        else if (int.parse(datePiece[2]) == DateTime.now().year && int.parse(datePiece[0]) == DateTime.now().month && int.parse(datePiece[1]) < DateTime.now().day) {
          oldList.add(line[0]);
        }
        // next two elses are for futureList
        else {
          futureList.add(line[0]);
        }
      }
      else {
        futureList.add(line[0]);
      }

  }


  GlobalVariables.todayItems = todayList;
  GlobalVariables.overdueItems = oldList;
  GlobalVariables.dueLaterItems = futureList;

  GlobalVariables.completionData['Due Today'] = todayList.length.toDouble();
  GlobalVariables.completionData['Overdue!!!'] = oldList.length.toDouble();
  GlobalVariables.completionData['Due Later'] = futureList.length.toDouble();
}




  //returns a Future list of items to do, including their date and user.
  Future<List<String>> showAll() async {
    List<String> contents = await file.readAsLines();
    return contents;
  }

  //Returns a map with usernames and passwords
  Future<Map<String, String>> findUser() async{
    Map<String, String> usernames = {};
    //var usernames = Map();
    for(String line in await users.readAsLines()){
      usernames[line.split('|')[1]] = line.split('|')[2];
    }
    return usernames;
  }
//}


