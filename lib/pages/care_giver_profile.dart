import 'package:carely_v2/pages/care_giver_bank_details.dart';
import 'package:carely_v2/pages/care_giver_edit_profile.dart';
import 'package:carely_v2/pages/care_giver_working_area.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CareGiverProfile extends StatefulWidget {
  const CareGiverProfile({Key? key}) : super(key: key);

  @override
  State<CareGiverProfile> createState() => _CareGiverProfileState();
}

//sign user out method
void signUserOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  //showing snack bar
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('You have been signed out successfully.'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

class _CareGiverProfileState extends State<CareGiverProfile> {
  //getting the current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //Delete user method
  void deleteUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('usersv2')
          .doc(currentUser.email)
          .update({'isDeleted': true});
      //Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account Deleted Successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      signUserOut(context);
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //Deactivate user method
  void deactivateUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('usersv2')
          .doc(currentUser.email)
          .update({'isActive': false});
      //Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Account Deactivated Successfully. You can reactivate your account at any time.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //Reactivate user method
  void reactivateUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('usersv2')
          .doc(currentUser.email)
          .update({'isActive': true});
      //Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account Reactivated Successfully.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  //Show deactivation confirmation dialog
  void showDeactivationConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deactivate Account'),
          icon: Icon(
            Icons.hide_image_outlined,
            color: Colors.yellow[900],
            size: 35,
          ),
          content: const Text(
            'Are you sure you want to deactivate your account?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => {
                deactivateUser(),
                Navigator.pop(context),
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  //Show reactivation confirmation dialog
  void showReactivationConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reactivate Account'),
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 35,
          ),
          content: const Text(
            'Are you sure you want to reactivate your account?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => {
                reactivateUser(),
                Navigator.pop(context),
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  //Show delete confirmation dialog
  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
            size: 35,
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () => signUserOut(context),
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
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
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image(
                        image: NetworkImage(
                            snapshot.data!.get('imageUrl') as String),
                      ),
                    ),
                    //Welcome message
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Welcome, ${userData['First Name']} ${userData['Last Name']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 12,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Caregiver',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Switch(
                                value: userData['isActive'] as bool,
                                onChanged: (value) => {},
                                activeColor: Colors.green,
                                activeTrackColor: Colors.green[100],
                                inactiveThumbColor: Colors.red,
                                inactiveTrackColor: Colors.red[100],
                                activeThumbImage: const NetworkImage(
                                    "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Check_green_circle.svg/2048px-Check_green_circle.svg.png"))
                          ]),
                    ),
                    //Email
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${userData['email']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    //Edit Profile Button
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CareGiverEditProfile()),
                          )
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          minimumSize: const Size(200, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    // Stats - Total Patients, Total Appointments, Total Earnings (with icons)
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.green,
                                size: 35,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '12',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Total Patients',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.green,
                                size: 35,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '42',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Total Appointments',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Colors.green,
                                size: 35,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Rs.75780',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Total Earnings',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CareGiverWorkingArea()),
                        )
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                        child: Card(
                          elevation: 4,
                          //corner radius on all sides
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.location_on_rounded,
                              color: Colors.green,
                            ),
                            title: Text(
                              'Working Area',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CareGiverBankDetails()),
                        )
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Card(
                          elevation: 4,
                          //corner radius on all sides
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.account_balance,
                              color: Colors.green,
                            ),
                            title: Text(
                              'Bank Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Show Deactivate Account if account is active else Show Reactivate Account
                    userData['isActive'] == true
                        ? GestureDetector(
                            onTap: () =>
                                showDeactivationConfirmationDialog(context),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              child: Card(
                                elevation: 4,
                                //corner radius on all sides
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                //Background color of the button must be red
                                color: Colors.yellow[900],
                                child: const ListTile(
                                  leading: Icon(Icons.hide_image_outlined,
                                      color: Colors.white),
                                  title: Text(
                                    'Deactivate Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () =>
                                showReactivationConfirmationDialog(context),
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 20, right: 20),
                              child: Card(
                                elevation: 4,
                                //corner radius on all sides
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                //Background color of the button must be red
                                color: Colors.green,
                                child: ListTile(
                                  leading: Icon(Icons.check_circle_outline,
                                      color: Colors.white),
                                  title: Text(
                                    'Reactivate Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                    GestureDetector(
                      onTap: () => showDeleteConfirmationDialog(context),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Card(
                          elevation: 4,
                          //corner radius on all sides
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          //Background color of the button must be red
                          color: Colors.red[700],
                          child: const ListTile(
                            leading: Icon(Icons.delete, color: Colors.white),
                            title: Text(
                              'Delete Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('No data found.'),
              );
            }
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
