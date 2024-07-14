import 'package:flutter/material.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:json_bill_formatter/hotel_parser/hotel_data.dart';

class Mainui extends StatefulWidget {
  const Mainui({super.key});

  @override
  State<Mainui> createState() => _MainuiState();
}

class _MainuiState extends State<Mainui> {
  bool isPanelOpen = false;
  String currentHotelSelected = "";
  BitmapDescriptor markerIcon = AssetMapBitmap(
    "assets/hotel_marker.png",
    width: 40,
    height: 40,
  );
  @override
  Widget build(BuildContext context) {
    BoxController menuController = BoxController();
    BoxController chatBotController = BoxController();
    CameraPosition cameraPosition = const CameraPosition(
        target: LatLng(11.941720449978023, 79.80814205307853), zoom: 13);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.teal,
        shape: CircleBorder(),
        child: Image(
          width: 23,
          image: AssetImage("assets/chatbot.png"),
        ),
        onPressed: () {
          setState(() {
            if (chatBotController.isBoxClosed) {
              chatBotController.openBox();
            } else {
              chatBotController.closeBox();
            }
          });
        },
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: cameraPosition,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            markers: {
              customMarker(menuController, "Banana Leaf",
                  const LatLng(11.95121926830389, 79.80948051627232)),
              customMarker(menuController, "Hotel Thalapakatti",
                  const LatLng(11.945455859475707, 79.82007185419322)),
              customMarker(menuController, "Ginger World",
                  const LatLng(11.93835964396662, 79.8031576585075))
            },
          ),
          SlidingWindowMenu(
            controller: menuController,
            hotelName: currentHotelSelected,
          ),
          SlidingWindowChatBot(controller: chatBotController),
        ],
      ),
    );
  }

  Marker customMarker(
      BoxController controller, String markerId, LatLng position) {
    return Marker(
      infoWindow: InfoWindow(title: markerId, snippet: "Restaurant"),
      onTap: () {
        setState(() {
          if (controller.isBoxOpen) {
            controller.closeBox();
          } else {
            controller.openBox();
          }
          currentHotelSelected = markerId;
        });
      },
      icon: markerIcon,
      markerId: MarkerId(markerId),
      position: position,
    );
  }
}

class SlidingWindowMenu extends StatelessWidget {
  const SlidingWindowMenu({
    super.key,
    required this.controller,
    required this.hotelName,
  });

  final String hotelName;

  final BoxController controller;
  List<Map<String, dynamic>> buildList(hotelName) {
    if (hotelName == "Banana Leaf") {
      return HotelData.bananaLeaf;
    } else if (hotelName == "Hotel Thalapakatti") {
      return HotelData.hotelThalapakatti;
    }
    return HotelData.gingerWorld;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> hotelData = buildList(hotelName);
    return SlidingBox(
        collapsed: true,
        draggableIconBackColor: Colors.white,
        animationDuration: const Duration(milliseconds: 500),
        controller: controller,
        minHeight: 0,
        maxHeight: 600,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "  $hotelName",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  for (int i = 0; i < hotelData.length; i++)
                    ItemCard(
                        itemName: hotelData[i]['itemName'],
                        isVeg: hotelData[i]['isVeg'],
                        amount: hotelData[i]['amount'],
                        star: hotelData[i]['star'],
                        noOfRatings: hotelData[i]['noOfRatings'],
                        description: hotelData[i]['description'],
                        imagePath: hotelData[i]['imagePath']),
                ],
              ),
            ),
          ),
        ));
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.itemName,
    required this.isVeg,
    required this.amount,
    required this.star,
    required this.noOfRatings,
    required this.description,
    required this.imagePath,
  });

  final String itemName;
  final bool isVeg;
  final String amount;
  final String star;
  final String noOfRatings;
  final String description;
  final String imagePath;
  Future<void> _showDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Hello"),
              content: Container(
                width: 100,
                height: 100,
                color: Colors.red,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showDialog(context);
        print("Hello");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: SizedBox(
          width: 406,
          height: 170,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Icon(Iconsax.refresh_square_2,
                              color: isVeg
                                  ? Colors.green.shade800
                                  : Colors.red.shade700,
                              size: 25),
                        ),
                        Positioned(
                          top: 6.6,
                          right: 6.6,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Icon(
                              Icons.circle_sharp,
                              size: 12,
                              color: isVeg
                                  ? Colors.green.shade800
                                  : Colors.red.shade700,
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      itemName,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹ $amount",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Colors.amber.shade700,
                        ),
                        Row(
                          children: [
                            Text(
                              star,
                              style: TextStyle(color: Colors.amber.shade700),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "($noOfRatings)",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(description,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        Image(fit: BoxFit.fill, image: AssetImage(imagePath)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SlidingWindowChatBot extends StatefulWidget {
  const SlidingWindowChatBot({super.key, required this.controller});
  final BoxController controller;

  @override
  State<SlidingWindowChatBot> createState() => _SlidingWindowChatBotState();
}

class _SlidingWindowChatBotState extends State<SlidingWindowChatBot> {
  List<Map<bool, String>> messages = [
    {true: "How may i help you?"},
    {false: "I need the best chicken tandoori"},
    {
      true:
          "You can try at Banana Leaf. The ratings are best compared among all"
    },
    {false: "Where can i get aloo gobi?"},
    {
      true:
          "As of my knowledge hotels Ginger World and Thalapakatti provides aloo gobi but based on quality, price and reviews it is better at Ginger World"
    },
  ];
  @override
  Widget build(BuildContext context) {
    TextEditingController controllerText = TextEditingController();

    return SlidingBox(
      collapsed: true,
      animationDuration: Duration(milliseconds: 500),
      draggableIconVisible: false,
      controller: widget.controller,
      minHeight: 0,
      maxHeight: 500,
      body: Column(
        children: [
          Container(
            width: 500,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Container(
                  child: Image(
                    width: 60,
                    image: AssetImage("assets/chatbot_appbar.png"),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Food Assistant",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white),
                )
              ],
            ),
          ),
          for (int i = 0; i < messages.length; i++)
            if (messages[i].keys.first)
              BotMessage(message: messages[i][true]!)
            else
              UserMesaage(message: messages[i][false]!),
          Padding(
            padding: const EdgeInsets.only(top: 35.0, right: 80, left: 20),
            child: TextFormField(
              controller: controllerText,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (controllerText.text.trim() == "") {
                      showSnackBar("Error", "Please enter a message!");
                    } else {
                      setState(() {
                        messages.add({false: controllerText.text.trim()});
                      });
                    }
                  },
                  child: Icon(Iconsax.send_14),
                ),
                hintText: "Type a message!",

                errorMaxLines: 3,
                prefixIconColor: Colors.grey.shade700,
                suffixIconColor: Colors.grey.shade700,
                // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
                labelStyle: const TextStyle()
                    .copyWith(fontSize: 12, color: Colors.black),
                hintStyle: const TextStyle()
                    .copyWith(fontSize: 18, color: Colors.grey.shade700),
                errorStyle:
                    const TextStyle().copyWith(fontStyle: FontStyle.normal),
                floatingLabelStyle: const TextStyle()
                    .copyWith(color: Colors.black.withOpacity(0.8)),
                border: const OutlineInputBorder().copyWith(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                ),
                enabledBorder: const OutlineInputBorder().copyWith(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: const BorderSide(width: 1, color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder().copyWith(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                ),
                errorBorder: const OutlineInputBorder().copyWith(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: const BorderSide(width: 1, color: Colors.orange),
                ),
                focusedErrorBorder: const OutlineInputBorder().copyWith(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: const BorderSide(width: 2, color: Colors.orange),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showSnackBar(String? errorMessage1, String errorMessage2) {
    Get.snackbar(
      backgroundColor: Colors.black,
      colorText: Colors.white,
      errorMessage1!,
      '$errorMessage2',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10), //
    );
  }
}

class BotMessage extends StatelessWidget {
  const BotMessage({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: AssetImage("assets/chatbot_appbar.png"),
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 300,
            child: Container(
              child: Text(
                message,
                style: TextStyle(fontSize: 15),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserMesaage extends StatelessWidget {
  const UserMesaage({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, right: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 300,
            child: Container(
              child: Text(
                message,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.end,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Align(
            child: Image(
              image: AssetImage("assets/user_icon.png"),
              width: 35,
            ),
          ),
        ],
      ),
    );
  }
}
