import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

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
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Contact US",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://image.similarpng.com/very-thumbnail/2021/06/Medical-health-care-logo-design-template-on-transparent-background-PNG.png',
                          loadingBuilder: (context, child, loadingProgress) {
                            return loadingProgress == null
                                ? child
                                : const LinearProgressIndicator();
                          },
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const VerticalDivider(
                          width: 20,
                          thickness: 2,
                          indent: 2,
                          endIndent: 2,
                          color: Colors.white,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "STAY WELL.",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "STAY",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "CONNECTED",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Center(
                    child: Icon(
                      Icons.phone,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "0712906815",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Center(
                    child: Icon(
                      Icons.email,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "carelyinfo@carely.com",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Our Team",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.people,
                        size: 40,
                        color: Colors.white,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "S.D Gunawardana",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "U.L Chanthuka",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        VerticalDivider(
                          indent: 5,
                          endIndent: 5,
                          color: Colors.white,
                          thickness: 2,
                        ),
                        Column(
                          children: [
                            Text(
                              "P.K Thilakasiri",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "W.M Soysa",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "2443 Sierra Nevada Road,",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          Text(
                            "Mammoth Lakes CA",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
