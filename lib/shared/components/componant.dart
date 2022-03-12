import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildTaskItem(Map? model, context) => Dismissible(
      key: Key('${model?['id']}'),
      onDismissed: (direction){
        AppCubit.get(context).deleteDatabase(id: model?['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: Text(
                    '${model!['time']}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${model['title']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${model['date']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .updateDatabase(status: 'done', id: model['id']);
                    },
                    icon: const Icon(
                      Icons.check_box,
                      color: Colors.blue,
                    )),
                IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .updateDatabase(status: 'archive', id: model['id']);
                    },
                    icon: const Icon(
                      Icons.archive_outlined,
                      color: Colors.black38,
                    )),
                IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .deleteDatabase(id: model['id']);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    )),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );


Widget buildListResult(List<Map>tasks)=>ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context)=>ListView.separated(
      itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
      separatorBuilder: (context,index)=>Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20.0,
        ),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ),
      itemCount: tasks.length
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.menu,
          size: 60,
          color: Colors.black38,),
        Text('Tasks Empty ! ... Add Some Tasks',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),)
      ],
    ),
  ),
);
