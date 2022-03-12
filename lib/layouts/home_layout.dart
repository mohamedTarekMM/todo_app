import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayoutsScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)=>{
          if (state is AppInsertDatabaseState){
          Navigator.pop(context)
    }
        },
        builder: (context,state){
          AppCubit cubit = AppCubit.get(context);
          return Form(
            key: formKey,
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: const Text('TodoApp'),
                actions: [                   //delete all Element in Table
                  IconButton(
                      onPressed: (){
                        cubit.deleteAllDatabase();
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: (){
                  if(cubit.isBottomSheetShown){
                    if(formKey.currentState!.validate()){
                      cubit.insertToDatabase(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
                      titleController.clear();
                      dateController.clear();
                      timeController.clear();
                      cubit.openSheet(icons: Icons.edit, isOpen: false);
                    }
                  }
                  else{
                    scaffoldKey.currentState!.showBottomSheet((context) =>
                        Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: titleController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'title is empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.title),
                                  label: Text('Title Task'),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: timeController,
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                      .then((value) =>
                                  {
                                    timeController.text =
                                        value!.format(context).toString(),
                                    print(value.format(context).toString())
                                  });
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'time is empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                  label: Text('Time Task'),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2030)).then((value) =>
                                  {
                                    print(DateFormat.yMMMd().format(value!)),
                                    dateController.text =
                                        DateFormat.yMMMd().format(value)
                                  });
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'date is empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                      Icons.calendar_today_outlined),
                                  label: Text('Date Task'),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        )).closed.then((value){
                          cubit.openSheet(icons: Icons.edit, isOpen: false);
                    });
                    cubit.openSheet(
                        icons: Icons.add, isOpen: true);

                  }

                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.green,
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index){
                  cubit.changeIndex(index);
                },
                items:const [
                  BottomNavigationBarItem(icon: Icon(Icons.menu),label: 'Tasks'),
                  BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline),label: 'Done'),
                  BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),label: 'Archive'),
                ],
              ),
              body: cubit.screen[cubit.currentIndex],
            ),
          );
        },
      ),
    );
  }
}
