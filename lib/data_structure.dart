class Task{
  final int taskID;
  late String title;
  late String task;
  late DateTime deadline;
  late List<String> tags;
  late bool completed;

  Task(this.taskID, this.title, this.task, this.deadline, this.tags){

    completed=false;
  }

  void updateTitle(String newTitle) {
    title=newTitle;
  }

  void updateTask(String newTask) {
    task=newTask;
  }

  void updateDeadline(DateTime newDl) {
    deadline=newDl;
  }

  void addTag(String tag) {
    tags.add(tag);
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }

  bool isComplete(){
    return completed;
  }

  void setCompleted(bool state){
    completed=state;
  }

  Map<String, dynamic> toJson()=>{
    'taskId': taskID.toString(),
    'title': title,
    'task': task,
    'deadline': deadline.toString(),
    'tags': tags.join(" "),
    'completed': completed.toString()
  };

  Task.fromJson(Map<String, dynamic> json):
      taskID = int.parse(json['taskId']),
      title = json['title'],
      task = json['task'],
      deadline = DateTime.parse(json['deadline']),
      tags = List.from(json['tags'].split(" "), growable: true),
      completed = json['completed']=='true';
}

List<String> tasks = List.empty(growable: true);
Map<String, Task> taskMap = {};

int completed = 0;
int inComplete = 0;

String user = 'User';

