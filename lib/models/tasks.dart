class Task {
  int id;
  String title;
  String content;
  DateTime modifiedTime;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });
}

List<Task> sampleNotes = [
  Task(
    id: 0,
    title: 'Medication',
    content: '1. Panadol\n2.cetirizine\n3.Samahan',
    modifiedTime: DateTime(2022, 1, 1, 34, 5),
  ),
  Task(
    id: 1,
    title: 'Monitoring Health',
    content:
        'Keeping track of the health status and reporting any changes or concerns to the family members.',
    modifiedTime: DateTime(2023, 3, 1, 19, 5),
  ),
  Task(
    id: 2,
    title: 'Clean Room',
    content:
        '1.Vacuum carpets, rugs, and upholstery to remove dust and dirt.\n2.Clean Windows and Mirrors',
    modifiedTime: DateTime(2022, 1, 1, 34, 5),
  ),
];
