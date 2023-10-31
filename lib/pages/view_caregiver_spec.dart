import 'package:caregiver_request/screen/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class CareGiverRequest extends StatefulWidget {
  final Map<String, dynamic> caregiverDetails;
  final dynamic caregiverId;

  const CareGiverRequest(this.caregiverDetails, this.caregiverId, {super.key});

  @override
  State<CareGiverRequest> createState() => _CareGiverRequestState();
}

class _CareGiverRequestState extends State<CareGiverRequest> {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  // starting date controller
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController briefDescription = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _careGiverDetails;
  late dynamic _caregiverId;
  late String careGiverName;

  // create a refference to the caregivers
  final caregiversCollection =
      FirebaseFirestore.instance.collection('caregivers');

  @override
  void initState() {
    _careGiverDetails = widget.caregiverDetails;
    _caregiverId = widget.caregiverId;
    phoneNumber.text = _careGiverDetails["mobileNumber"];
    email.text = _careGiverDetails["email"];

    switch (_careGiverDetails['careType']) {
      case 'Child':
        {
          _childBox = true;
        }
        break;
      case 'Adult':
        {
          _adultBox = true;
        }
        break;
      case 'Hospital':
        {
          _hospitalBox = true;
        }
        break;
      case 'Home':
        {
          _homeBox = true;
        }
    }
    super.initState();
  }

  // get current date
  DateTime selectedDate = DateTime.now();

  // Check box values
  var _childBox = false;
  var _adultBox = false;
  var _hospitalBox = false;
  var _homeBox = false;

  // send Reqeuest handling function
  Future<void> sendRequestToCaregiver() async {
    // print(_caregiverId);

    DocumentReference caregiverDoc = caregiversCollection.doc(_caregiverId);

    // Fetch the current requests array from Firestore
    DocumentSnapshot docSnapshot = await caregiverDoc.get();
    List<dynamic> existingRequests = docSnapshot.get('requests') ?? [];

// Modify the existing requests array by adding a new map
    existingRequests.add({
      "userId": "#loggedUserId",
      "startDate": startDate.text,
      "endDate": endDate.text,
      "description": briefDescription.text,
    });
// Update the document with the modified requests array
    await caregiverDoc.set({
      "requests": existingRequests,
    }, SetOptions(merge: true));

    return;
    // after successing the request send close the alert
  }

  // open confirm request dialog box
  Future<void> openConfirmDialogBox() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Do you want to send a request ?"),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () {
                    // after successing the request show a alert
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green),
                  onPressed: () {
                    sendRequestToCaregiver()
                        .then((value) => Navigator.of(context).pop());
                  },
                  child: const Text("Yes"))
            ],
            elevation: 24.0,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(208, 209, 209, 0.5),
                  Color.fromRGBO(38, 77, 86, 0.8),
                  Color.fromRGBO(27, 68, 78, 1.0)
                ],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(_careGiverDetails["profilePicture"]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    _careGiverDetails != Null
                        ? _careGiverDetails["fullName"]
                        : "NULL",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 30),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(children: [
                    TextField(
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                      readOnly: true,
                      controller: phoneNumber,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.phone),
                        suffixIconColor: Colors.black,
                        filled: true,
                        fillColor: const Color.fromRGBO(209, 218, 223, 1.0),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                      readOnly: true,
                      controller: email,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.mail_outline),
                        suffixIconColor: Colors.black,
                        filled: true,
                        fillColor: const Color.fromRGBO(209, 218, 223, 1.0),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ]),
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromRGBO(217, 217, 217, 1.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: startDate,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'select start date';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Start Date", hoverColor: null,
                                  // suffixIcon: Icon(Icons.calendar_today_outlined),
                                ),
                                onTap: () async {
                                  final DateTime? dateTime =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(3000),
                                  );

                                  if (dateTime != null) {
                                    setState(() {
                                      startDate.text =
                                          "${dateTime.year} - ${dateTime.month} - ${dateTime.day}";
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 80,
                            ),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: endDate,
                                decoration: const InputDecoration(
                                  labelText: "End Date",
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Select end date';
                                  }

                                  return null;
                                },
                                onTap: () async {
                                  final DateTime? dateTime =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(3000),
                                  );

                                  if (dateTime != null) {
                                    setState(() {
                                      endDate.text =
                                          "${dateTime.year} - ${dateTime.month} - ${dateTime.day}";
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: briefDescription,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a description';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Breif Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          maxLines: 5,
                          minLines: 3,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Select option below",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text("Child"),
                                value: _childBox,
                                onChanged: (value) {
                                  setState(() {
                                    _childBox = _childBox;
                                  });
                                },
                                checkColor: Colors.white,
                                fillColor: const MaterialStatePropertyAll(
                                    Colors.black),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: _adultBox,
                                title: const Text("Adult"),
                                onChanged: (value) {
                                  setState(() {
                                    _adultBox = _adultBox;
                                  });
                                },
                                checkColor: Colors.white,
                                fillColor: const MaterialStatePropertyAll(
                                    Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text("Hospital"),
                                value: _hospitalBox,
                                onChanged: (value) {
                                  setState(() {
                                    _hospitalBox = _hospitalBox;
                                  });
                                },
                                checkColor: Colors.white,
                                fillColor: const MaterialStatePropertyAll(
                                    Colors.black),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                value: _homeBox,
                                title: const Text("Home"),
                                onChanged: (value) {
                                  _homeBox = _homeBox;
                                },
                                checkColor: Colors.white,
                                fillColor: const MaterialStatePropertyAll(
                                    Colors.black),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.red),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white)),
                      onPressed: () {
                        Navigator.pop(
                            context, (context) => const SearchCareGiver());
                      },
                      child: const Text("CANCEL"),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          openConfirmDialogBox().then((value) => {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  onConfirmBtnTap: () {
                                    startDate.clear();
                                    endDate.clear();
                                    briefDescription.clear();

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SearchCareGiver()),
                                    );
                                  },
                                )
                              });
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green[500]),
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.white)),
                      child: const Text("REQUEST"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
