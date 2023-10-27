import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CareGiverWorkingArea extends StatefulWidget {
  const CareGiverWorkingArea({Key? key}) : super(key: key);

  @override
  State<CareGiverWorkingArea> createState() => _CareGiverWorkingAreaState();
}

class _CareGiverWorkingAreaState extends State<CareGiverWorkingArea> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final workingAreaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Get data from firestore
    FirebaseFirestore.instance
        .collection('usersv2')
        .doc(currentUser.email)
        .get()
        .then((value) {
      if (value.exists) {
        workingAreaController.text = value['workingArea'];
      }
    });
  }

  //Working Areas List
  final List<String> workingAreas = [
    'Colombo',
    'Kandy',
    'Galle',
    'Matara',
    'Kurunegala',
    'Jaffna',
    'Kegalle',
    'Gampaha',
    'Kalutara',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Ratnapura',
    'Ampara',
    'Trincomalee',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Monaragala',
    'Puttalam',
    'Kilinochchi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: const Text(
          'Working Area',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Select your working area',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Select Working Area',
                  ),
                  //value: workingAreaController.text,
                  onChanged: (value) {
                    setState(() {
                      workingAreaController.text = value.toString();
                    });
                  },
                  items: workingAreas.map((area) {
                    return DropdownMenuItem(
                      value: area,
                      child: Text(area),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('usersv2')
                      .doc(currentUser.email)
                      .update({
                    'workingArea': workingAreaController.text,
                  });
                  //Show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Working Area Updated'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
