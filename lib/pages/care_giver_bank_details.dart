import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CareGiverBankDetails extends StatefulWidget {
  const CareGiverBankDetails({Key? key}) : super(key: key);

  @override
  State<CareGiverBankDetails> createState() => _CareGiverBankDetailsState();
}

class _CareGiverBankDetailsState extends State<CareGiverBankDetails> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final bankController = TextEditingController();
  final branchController = TextEditingController();
  final accountController = TextEditingController();

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
        bankController.text = value['bank'];
        branchController.text = value['branch'];
        accountController.text = value['account'];
      }
    });
  }

  //Banks List
  final List<String> banks = [
    'Commercial Bank',
    'Sampath Bank',
    'HNB',
    'BOC',
    'Peoples Bank',
    'Seylan Bank',
    'DFCC Bank',
    'NDB Bank',
    'Union Bank',
    'NSB',
    'Pan Asia Bank',
    'SDB Bank',
    'Regional Development Bank',
    'HDFC Bank',
    'Standard Chartered Bank',
    'Citibank',
  ];

  //Branches List
  final List<String> branches = [
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: const Text(
          'Bank Details',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usersv2')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.exists) {
              return ListView(padding: const EdgeInsets.all(20), children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Bank Selection
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
                            hintText: 'Select Bank',
                          ),
                          value: bankController.text,
                          onChanged: (value) {
                            setState(() {
                              bankController.text = value.toString();
                            });
                          },
                          items: banks.map((bank) {
                            return DropdownMenuItem(
                              value: bank,
                              child: Text(bank),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    //Branch Selection
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
                            hintText: 'Select Branch',
                          ),
                          value: branchController.text,
                          onChanged: (value) {
                            setState(() {
                              branchController.text = value.toString();
                            });
                          },
                          items: branches.map((branch) {
                            return DropdownMenuItem(
                              value: branch,
                              child: Text('$branch'),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    //Account Number
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: accountController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Account Number',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter account number';
                          }
                          return null;
                        },
                      ),
                    ),

                    //Save Button
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('usersv2')
                              .doc(currentUser.email)
                              .update({
                            'bank': bankController.text,
                            'branch': branchController.text,
                            'account': accountController.text,
                          });
                          //Show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bank details saved'),
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
                        child:
                            const Text('Save', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ]);
            } else {
              return const Center(
                child: Text('No data found'),
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
