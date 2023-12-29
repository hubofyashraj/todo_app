import 'package:flutter/material.dart';
import 'package:pcc_todo_app/data_structure.dart';
import 'package:pcc_todo_app/getWidgets.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'init.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future _initFuture = Init.initialize();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {




    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return const MyHomePage(title: 'title');
          } else {
            return getSplashScreen();
          }
        },
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  callback(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    tabCallBack(String text){
      setState(() {
        callback();
      });
    }

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
                color: lightDynamic?.primary.withAlpha(200)??const Color.fromRGBO(206, 192, 165, 1.0)
            ),

            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: getHead(tabCallBack, lightDynamic, darkDynamic),
                ),
                SizedBox(

                    height: MediaQuery.of(context).size.height-200,
                    child:DefaultTabController(length: 2, child: Scaffold(
                      backgroundColor: darkDynamic?.primary.harmonizeWith(Colors.black).harmonizeWith(Colors.black).harmonizeWith(Colors.black)??Colors.white70,
                        appBar: AppBar(
                          backgroundColor: darkDynamic?.primary.withAlpha(180)?? const Color.fromRGBO(253, 247, 228, 0.5),
                          title: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                      style: TextStyle(
                                        fontSize: 28,
                                        color: darkDynamic?.inversePrimary??Colors.black,
                                      ),
                                      'My Tasks'
                                  ),
                                ),
                              ],
                            ),
                          ),
                          centerTitle: true,
                          bottom: TabBar(
                            indicatorColor: lightDynamic?.primary??Colors.blueAccent,
                            labelColor:  lightDynamic?.primary??Colors.blueAccent,
                            unselectedLabelColor: lightDynamic?.primary.withAlpha(200)??Colors.lightBlueAccent,

                            tabs: const [
                              Tab(child: Text('Incomplete',),),
                              Tab(child: Text('Complete',),),
                            ],
                            onTap: (value) {
                            },
                          ),
                        ),
                        body: TabBarView(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(

                                decoration: const BoxDecoration(

                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                width: double.infinity,
                                child: Column(

                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    for (String task in tasks)
                                      if(taskMap[task]?.completed==false)
                                        Column(
                                          children: [
                                            getTaskWidget(taskMap[task]!, callback, context, lightDynamic, darkDynamic),SizedBox(height: 12, width: 12,child: Container(),)
                                          ],
                                        )
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(

                                decoration: const BoxDecoration(

                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                width: double.infinity,
                                child: Column(

                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    for (String task in tasks) if(taskMap[task]?.completed==true) Column(
                                      children: [
                                        getTaskWidget(taskMap[task]!, callback, context, lightDynamic, darkDynamic),SizedBox(height: 12, width: 12,child: Container(),)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    ))




                )
              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
