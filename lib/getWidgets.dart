

import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pcc_todo_app/data_structure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskWidget extends StatefulWidget {
  final String taskid;
  final String title;
  final String task;
  final DateTime deadline;
  final List<String> tags;
  final bool completed;
  final Function callback;
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;
  const TaskWidget(this.taskid,this.title, this.task, this.deadline, this.tags, this.completed, this.callback, this.lightDynamic, this.darkDynamic,  {super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState(isCompleted: completed);
}

class _TaskWidgetState extends State<TaskWidget> {
   late bool isCompleted;

   _TaskWidgetState({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.darkDynamic?.primary.withOpacity(0.5)??const Color.fromRGBO(222,208,182,0.5),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            blurStyle: BlurStyle.inner,
            color: widget.lightDynamic?.primary.withAlpha(50)??const Color.fromARGB(50, 0, 0, 0)
          )
        ]
      ),
      // padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      width: double.infinity,
      height: 200,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              color:  widget.lightDynamic?.primary.withAlpha(150)?? const Color.fromRGBO(222,208,182,0.8),
            ),
            width: double.infinity,
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(

                  child: Container(
                    decoration: const BoxDecoration(

                    ),
                    child: SingleChildScrollView(

                      scrollDirection: Axis.horizontal,

                      child: Row(

                        children: [
                          for (String tag in widget.tags) Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color:  widget.lightDynamic?.primary.withAlpha(150)??const Color.fromRGBO(208, 193, 163, 1.0),

                                    borderRadius: BorderRadius.circular(1000)
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(tag, style: TextStyle(color: widget.darkDynamic?.secondary??Colors.black)),
                              ),
                              const SizedBox(width: 12,)
                            ],
                          )
                        ],
                      ),
                    )
                ),
                ),
                const SizedBox(width: 24,),
                SizedBox(
                  width: 44,
                  child: Text('${widget.deadline.day}/${widget.deadline.month}', style: TextStyle(color: widget.darkDynamic?.secondary??Colors.black)),
                )
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(


            ),

            margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(overflow: TextOverflow.fade, style: TextStyle(
                  fontSize: 24,
                  color: widget.darkDynamic?.primaryContainer??Colors.black
                ), widget.title),

                Container(
                  child: PopupMenuButton(color: widget.darkDynamic?.primary??Colors.black,itemBuilder: (BuildContext context)=><PopupMenuEntry>[
                    PopupMenuItem(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      value: 1,
                        child: SizedBox(
                          child: Row(
                            children: [
                              Icon(color: widget.darkDynamic?.inversePrimary??Colors.black, Icons.edit_note_outlined),
                              const SizedBox(width: 6,),
                              Text(style: TextStyle(color: widget.darkDynamic?.inversePrimary??Colors.black,), 'Edit')
                            ],
                          ),
                        ),
                    ),
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      value: 2,
                      child: SizedBox(
                        child: Row(
                          children: [
                            Icon(color: widget.darkDynamic?.inversePrimary??Colors.black, Icons.delete_outline),
                            const SizedBox(width: 6,),
                            Text(style: TextStyle(color: widget.darkDynamic?.inversePrimary??Colors.black,), 'Delete')
                          ],
                        )
                      ),
                    ),
                    PopupMenuItem(
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                      value: 3,
                        child: SizedBox(
                          child: Row(
                            children: [
                              Icon(color: widget.darkDynamic?.inversePrimary??Colors.black, Icons.done_all_outlined),
                              const SizedBox(width: 6,),
                              Text(style: TextStyle(color: widget.darkDynamic?.inversePrimary??Colors.black,), isCompleted==false?'Mark done':'Mark Incomplete'),
                            ],
                          ),
                        ),
                    ),
                  ],
                  onSelected: (value) {
                    if(value==1) {
                      showDialog(context: context, builder: (BuildContext context)=>Dialog.fullscreen(
                        child: TaskEntry(widget.taskid, widget.lightDynamic, widget.darkDynamic),
                      ));
                    } else if(value==2) {
                      deleteTask(widget.taskid);
                      widget.callback();
                    } else {
                      taskMap[widget.taskid]?.setCompleted(!isCompleted);
                      save(taskMap[widget.taskid]!);
                      if(isCompleted){
                        completed--;
                        inComplete++;
                      }else{
                        completed++;
                        inComplete--;
                      }

                      widget.callback();
                    }
                  },),
                )
              ],
            )
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 12, right: 12),

            child: Text(overflow: TextOverflow.ellipsis, widget.task,style: TextStyle(
                fontSize: 17,color: widget.lightDynamic?.secondary??Colors.black)),
          ),


        ],
      ),
    );
  }

  deleteTask(String taskid) async {
    if(isCompleted) {
      completed--;
    } else {
      inComplete--;
    }
    tasks.remove(taskid);
    taskMap.remove(taskid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(taskid);
    prefs.setStringList('tasks', tasks);

  }

  save( Task task) async {
   final prefs = await SharedPreferences.getInstance();
   prefs.setString(task.taskID.toString(), jsonEncode(task));
   prefs.setStringList('tasks', tasks);

  }
}


InkWell getTaskWidget(Task task, Function callback, BuildContext context, ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
  return InkWell(
    onTap: () {
      showDialog(context: context, builder:
          (BuildContext context)=>Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              height: 272,
              decoration: BoxDecoration(
                color: darkDynamic?.secondary??const Color.fromRGBO(252, 249, 253, 1.0),
                borderRadius: BorderRadius.circular(24)
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 272-96,
                      child: SingleChildScrollView(
                        child: Text(task.task,style: TextStyle(
                            fontSize: 16,
                          decoration: TextDecoration.none,
                          color: darkDynamic?.inversePrimary??Colors.black,
                          fontWeight: FontWeight.normal
                        ),textAlign: TextAlign.justify),
                      ),

                    ),
                    const SizedBox(height: 12,),

                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: TextButton(onPressed: () => Navigator.pop(context), child: Text('Close',style: TextStyle(color: lightDynamic?.primary??Colors.black),))

                    ),
                    Container(),
                  ],
                ),
              ),
            ),
          )
      );
    },
    child: TaskWidget(task.taskID.toString(), task.title, task.task, task.deadline, task.tags, task.completed, callback, lightDynamic, darkDynamic),
  );
}


class Head extends StatefulWidget {
  final String userName;
  final int taskCount;
  final Function callback;
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;

  const Head(this.userName, this.taskCount, this.callback, this.lightDynamic, this.darkDynamic, {super.key});

  @override
  State<Head> createState() => _HeadState();
}

class _HeadState extends State<Head> {
  late int taskCount;
  bool toggle = false;
  void callFunction(String val) {
    widget.callback(val);
  }
  @override
  Widget build(BuildContext context) {


    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
      ),
      constraints: const BoxConstraints(

      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 12, right: 12),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width-136,
                  child: Row(
                    children: [
                      IconButton(onPressed: () {
                        showDialog(context: context,
                            builder: (BuildContext context)=>Dialog(
                              child: UserPage(widget.lightDynamic, widget.darkDynamic),
                            )
                        );
                      }, icon: Icon(Icons.settings, color: widget.lightDynamic?.inversePrimary??Colors.black,)),
                      Expanded(
                        child: Text(
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: widget.lightDynamic?.primaryContainer??Colors.black,
                                overflow: TextOverflow.ellipsis
                            ),
                            'Hello ${widget.userName}'
                        ),

                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: ElevatedButton(

                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            widget.lightDynamic?.inversePrimary??const Color.fromRGBO(187, 173, 146, 1.0)

                        ),

                      ),
                      onPressed: ()=>{
                        showDialog(context: context, builder: (BuildContext context)=>Dialog.fullscreen(
                          child: TaskEntry('', widget.lightDynamic, widget.darkDynamic),
                        ))
                      }, child: Text('Add Task',style: TextStyle(color: widget.darkDynamic?.primaryContainer??Colors.black),)
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            child: Text(style: TextStyle(
              fontSize: 28,
              color: widget.lightDynamic?.secondaryContainer??Colors.black
            ),'You Have $inComplete ${inComplete==1?'task':'tasks'} to complete.'),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   child: Container(
          //     width: double.infinity,
          //     child: TextField(
          //
          //       onChanged: (value) => {callFunction(value)},
          //       decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //         labelText: 'Search'
          //       ),
          //
          //     ),
          //   ),
          // ),

        ],
      ),
    );
  }
}

Head getHead(Function callback, ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
  return Head(user, taskMap.length, callback, lightDynamic, darkDynamic);
}



class TaskEntry extends StatefulWidget {
  final String taskid;
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;
  const TaskEntry(this.taskid, this.lightDynamic, this.darkDynamic ,{super.key});

  @override
  State<TaskEntry> createState() => _TaskEntryState(taskid: taskid);
}

class _TaskEntryState extends State<TaskEntry> {
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  DateTime deadline = DateTime.now();
  bool isInEdit = false;

  save( Task task) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(task.taskID.toString(), jsonEncode(task));
    prefs.setStringList('tasks', tasks);

  }
  String taskid;
  _TaskEntryState({required this.taskid});

  @override
  void initState(){
    if(widget.taskid!=''){
      isInEdit=true;
      Task? t = taskMap[widget.taskid];
      if(t!=null){
        titleController.text=t.title;
        taskController.text=t.task;
        dateController.text=t.deadline.toString().split(' ')[0];
        deadline = t.deadline;
        tagsController.text=t.tags.join(' ');

      }
    }else{
      isInEdit=false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: widget.darkDynamic?.primary.harmonizeWith(Colors.black).harmonizeWith(Colors.black)??const Color.fromRGBO(251, 245, 226, 1.0),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 16,
        foregroundColor: widget.lightDynamic?.secondaryContainer??Colors.black,
        backgroundColor: widget.lightDynamic?.primary.withAlpha(200)??const Color.fromRGBO(204, 190, 164, 1.0),
        centerTitle: true,
        title: Text(isInEdit?'Edit Task':'New Task', textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,

            )
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 36,),

              SizedBox(
                width: double.infinity,
                child: TextField(
                  onChanged: (value) {
                    setState(() {

                    });
                  },

                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Colors.black
                    )
                  ),
                ),
              ),
              const SizedBox(height: 24,),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  onChanged: (value) {
                    setState(() {

                    });
                  },
                  controller: taskController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task details',
                      labelStyle: TextStyle(
                          color: Colors.black
                      )

                  ),
                ),
              ),
              const SizedBox(height: 24,),
              SizedBox(
                  width: double.infinity,

                  child: TextField(
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                    controller: dateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Deadline',
                        labelStyle: TextStyle(
                            color: Colors.black
                        )


                    ),
                    onTap: () async => {
                      deadline = (await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2049)))!,
                      dateController.text = deadline.toString().split(" ")[0]
                    },
                  )
              ),
              const SizedBox(height: 24,),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  onChanged: (value) {
                    setState(() {

                    });
                  },
                  controller: tagsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tags',
                      labelStyle: TextStyle(
                          color: Colors.black
                      )

                  ),

                ),
              ),
              const SizedBox(height: 24,),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  color: widget.lightDynamic?.primary.withAlpha(200)??Colors.blueAccent, height: 56,minWidth: double.infinity ,
                  disabledColor: widget.lightDynamic?.secondary??Colors.blueGrey,
                  onPressed: (titleController.text.isEmpty||taskController.text.isEmpty||dateController.text.isEmpty||tagsController.text.isEmpty)?null:()=>{
                    if(widget.taskid==''){
                      if(tasks.isEmpty){
                        tasks.add((1).toString())
                      }else {
                        tasks.add((int.parse(tasks.last)+1).toString())
                      },
                      taskid=tasks.last,
                      inComplete++,
                    },

                    taskMap[taskid]=Task(int.parse(taskid),titleController.text, taskController.text, deadline, List.of(tagsController.text.split(' '), growable: true)),
                    save(taskMap[taskid]!),
                    Navigator.pop(context)
                }, child: Text(isInEdit?'Save':'Add Task',style: TextStyle(color: widget.darkDynamic?.secondary??Colors.black),)),
              ),
            ],
          ),
        )
      )
    );
  }
}


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Initialization",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 20,),
          CircularProgressIndicator()

        ],
      ),
    );
  }
}

SplashScreen getSplashScreen(){
  return const SplashScreen();
}


class UserPage extends StatefulWidget {
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;
  const UserPage(this.lightDynamic, this.darkDynamic, {super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController userNameController = TextEditingController();
  @override
  void initState() {
    userNameController.text=user;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Edit User Name'),
          centerTitle: true,
        ),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24),bottomRight: Radius.circular(24)),
              color: widget.darkDynamic?.primary.withAlpha(200)
            ),

            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  style: TextStyle(
                    color: widget.darkDynamic?.inversePrimary??Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: userNameController,
                  decoration: InputDecoration(
                      labelText: 'Name',
                    labelStyle: TextStyle(
                      color: widget.darkDynamic?.inversePrimary??Colors.black
                    )
                  ),
                ),
                const SizedBox(height: 16,),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(onPressed: () async {
                    user=userNameController.text;
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('user', user);
                    Navigator.pop(context);
                  }, child: const Text('Save')),
                )

              ],
            ),
          ),
      ),
    );
  }
}
