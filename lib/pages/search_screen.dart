import 'package:caregiver_request/screen/view_caregiver_spec.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchCareGiver extends StatefulWidget {
  const SearchCareGiver({super.key});

  @override
  State<SearchCareGiver> createState() => _SearchCareGiverState();
}

class _SearchCareGiverState extends State<SearchCareGiver> {
  var _city = 'COLOMBO';
  var _ratings = 1.0;
  var _childCheckBox = false;
  var _adultCheckBox = false;
  var _hostpitaCheckBox = false;
  var _homeCheckBox = false;

  void triggerSearch() {
    print("Search");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            const SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Find CareGiver",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 40,
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromRGBO(217, 217, 217, 1.0),
              ),
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.all(10.0),
              // width: 500,
              // height: 500,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text("Child"),
                          value: _childCheckBox,
                          onChanged: (value) {
                            setState(() {
                              _childCheckBox = !_childCheckBox;
                            });
                          },
                          checkColor: Colors.white,
                          fillColor:
                              const MaterialStatePropertyAll(Colors.black),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text("Adult"),
                          value: _adultCheckBox,
                          onChanged: (value) {
                            setState(() {
                              _adultCheckBox = !_adultCheckBox;
                            });
                          },
                          checkColor: Colors.white,
                          fillColor:
                              const MaterialStatePropertyAll(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Hsopital"),
                            value: _hostpitaCheckBox,
                            onChanged: (value) {
                              setState(() {
                                _hostpitaCheckBox = !_hostpitaCheckBox;
                              });
                            },
                            checkColor: Colors.white,
                            fillColor:
                                const MaterialStatePropertyAll(Colors.black),
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Home"),
                            value: _homeCheckBox,
                            onChanged: (value) {
                              setState(() {
                                _homeCheckBox = !_homeCheckBox;
                              });
                            },
                            checkColor: Colors.white,
                            fillColor:
                                const MaterialStatePropertyAll(Colors.black),
                          ),
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton(
                        value: _city,
                        focusColor: Colors.red,
                        items: const [
                          DropdownMenuItem(
                              value: "COLOMBO", child: Text("Colombo")),
                          DropdownMenuItem(
                              value: "KADUWELA", child: Text("Kaduwela")),
                          DropdownMenuItem(
                              value: "KOLLUPITIYA", child: Text("Kollupitiya")),
                          DropdownMenuItem(
                              value: "MALABE", child: Text("Malabe")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _city = value!;
                          });
                        },
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      DropdownButton(
                        value: _ratings,
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        items: const [
                          DropdownMenuItem(value: 1.0, child: Text("1.0")),
                          DropdownMenuItem(value: 2.0, child: Text("2.0")),
                          DropdownMenuItem(value: 3.0, child: Text("3.0")),
                          DropdownMenuItem(value: 4.0, child: Text("4.0")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _ratings = value!;
                          });
                        },
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(38, 76, 86, 1.0),
                          ),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      child: const Text(
                        "Search",
                      ),
                      onPressed: () {
                        triggerSearch();
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color.fromRGBO(217, 217, 217, 1.0),
                ),
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("caregivers")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final caregiver = snapshot.data!.docs[index];
                          return userComponent(context,
                              user: caregiver.data(), userId: caregiver.id);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("There is an Error ${snapshot.error}"),
                      );
                    } else if (!(snapshot.hasData)) {
                      return const Center(
                        child: Text("There are no Caregivers data"),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  userComponent(BuildContext context, {required user, required userId}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CareGiverRequest(user, userId)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(76, 170, 106, 1.0),
              borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(user['profilePicture']),
                      )),
                  const SizedBox(width: 10),
                  Text(
                    user["fullName"],
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "${user["rating"].toString()}.0",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber[400],
                        weight: 1000,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CareGiverRequest(user, userId)));
                          },
                          child: const Icon(Icons.arrow_forward_ios_outlined))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
