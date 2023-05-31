import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart' as intl;
import 'chat.dart';
import 'reserving_tour.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

enum HotelStar { one, two, three, four, five }
enum HotelService { allInclude, breakfast, breakfastDinnerLunch, noFood, ultraAllInclude }

class ClientTourInformation extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final String tour;
  const ClientTourInformation({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.tour});

  @override
  State<ClientTourInformation> createState() => _ClientTourInformationState();
}

class _ClientTourInformationState extends State<ClientTourInformation> with TickerProviderStateMixin {
  late Future<Map<String, dynamic>> tourInfo;
  List<Widget>? photosWidgets;
  List<dynamic>? photos;
  String? name;
  String? country;
  String? city;
  String? stars;
  String? serviceType;
  int? priceUAH;
  int? priceUSD;
  int? priceEUR;
  String? aboutTour;
  String? generalInformation;
  DocumentReference? tourAgent;
  // String? tourInformation;
  Map<String, dynamic>? servicesDescriptions;
  Map<String, dynamic>? roomsDescriptions;
  late Future<Map<String, dynamic>> tourAgentInfo;

  late TabController _servicesTabController;
  late TabController _roomsTabController;

  List<Tab> roomsTabs = <Tab>[];
  List<Widget> roomsTabsViews = <Widget>[];

  List<Tab> servicesTabs = <Tab>[];
  List<Widget> servicesTabsViews = <Widget>[];

  bool end = false;

  HotelStar? _starsOption; // Write logic
  var starsString = {
    HotelStar.one: "1",
    HotelStar.two: "2",
    HotelStar.three: "3",
    HotelStar.four: "4",
    HotelStar.five: "5",
  };

  HotelStar getStarOption(String star) {
    if (star == "1") {
      return HotelStar.one;
    }
    else if (star == "2") {
      return HotelStar.two;
    }
    else if (star == "3") {
      return HotelStar.three;
    }
    else if (star == "4") {
      return HotelStar.four;
    }
    else {
      return HotelStar.five;
    }
  }

  HotelService? _serviceOption; // Write logic
  var serviceString = {
    HotelService.allInclude: "All Include (Все включено)",
    HotelService.breakfast: "Сніданок",
    HotelService.breakfastDinnerLunch: "Сніданок, обід та вечеря",
    HotelService.noFood: "Без харчування",
    HotelService.ultraAllInclude: "Ultra All Include",
  };

  HotelService getServiceOption(String service) {
    if (service == "All Include (Все включено)") {
      return HotelService.allInclude;
    }
    else if (service == "Сніданок") {
      return HotelService.breakfast;
    }
    else if (service == "Сніданок, обід та вечеря") {
      return HotelService.breakfastDinnerLunch;
    }
    else if (service == "Без харчування") {
      return HotelService.noFood;
    }
    else {
      return HotelService.ultraAllInclude;
    }
  }

  List<Widget> imageSliders(List<dynamic> photos) {
    return photos.map((item) => Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 1000.0),
            ],
          )),
    ))
        .toList();
  }

  List<Tab> getTabs(Iterable<String> tabsNames) {
    List<Tab> tabs = <Tab>[];
    for (var element in tabsNames) {
      tabs.add(Tab(text: element,));
    }
    return tabs;
  }

  List<Text> getTabsTexts(Iterable<dynamic> tabsTexts) {
    List<Text> tabs = <Text>[];
    for (var element in tabsTexts) {
      tabs.add(Text(element,));
    }
    return tabs;
  }

  @override
  void initState() {
    super.initState();
    tourInfo = widget.database.getTourInfo(widget.tour);
  }

  // void initializeVariables(Map<String, dynamic> tourInformation) {
  //   photos = tourInformation["photos"];
  //   photosWidgets = imageSliders(photos!);
  //   name = tourInformation["name"];
  //   country = tourInformation["country"];
  //   city = tourInformation["city"];
  //   stars = tourInformation["stars"].toString();
  //   serviceType = tourInformation["food"].toString();
  //   priceUAH = tourInformation["price UAH"];
  //   priceUSD = tourInformation["price USD"];
  //   priceEUR = tourInformation["price EUR"];
  //   aboutTour = tourInformation["tour information"];
  //   generalInformation = tourInformation["general information"];
  //   tourAgent = tourInformation["tour agent"];
  //   servicesDescriptions = tourInformation["services"];
  //   roomsDescriptions = tourInformation["rooms"];
  //   _starsOption = getStarOption(stars!);
  //   _serviceOption = getServiceOption(serviceType!);
  //   widget.database.getInfoByReference(tourAgent!).then((value) {
  //     tourAgentInfo = value;
  //   });
  //   _servicesTabController = TabController(vsync: this, length: servicesDescriptions!.length);
  //   _roomsTabController = TabController(vsync: this, length: roomsDescriptions!.length);
  //   makeServiceTabs();
  //   makeRoomTabs();
  // }

  void makeServiceTabs() {
    servicesDescriptions!.forEach((key, value) {
      addServiceTab(key);
      addServiceTabBarView(value);
    });
  }

  void makeRoomTabs() {
    roomsDescriptions!.forEach((key, value) {
      addRoomTab(key);
      addRoomTabBarView(value);
    });
  }

  void addRoomTab(String tabName) { // String roomName
    // Tab roomTab = const Tab(text: 'Address');
    // roomsTabsName.add(tabName);
    roomsTabs.add(Tab(text: tabName));
  }

  void addRoomTabBarView(String tabContent) {
    // TextEditingController newRoomController = TextEditingController();
    // roomsDescriptionControllers.add(newRoomController);
    roomsTabsViews.add(
        TextFormField(
          keyboardType: TextInputType.name,
          initialValue: tabContent,
          readOnly: true,
          textAlign: TextAlign.start,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            border: OutlineInputBorder(),
          ),
          cursorColor: Colors.black,
          // controller: newRoomController,
        )
    );
  }

  void addServiceTab(String tabName) { // String roomName
    // Tab roomTab = const Tab(text: 'Address');
    // String serviceTabName = servicesNameController.text;
    // servicesTabsName.add(tabName);
    servicesTabs.add(Tab(text: tabName));
  }

  void addServiceTabBarView(String tabContent) {
    // TextEditingController newServicesController = TextEditingController();
    // servicesDescriptionControllers.add(newServicesController);
    servicesTabsViews.add(
        TextFormField(
          keyboardType: TextInputType.name,
          initialValue: tabContent,
          textAlign: TextAlign.start,
          readOnly: true,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            border: OutlineInputBorder(),
          ),
          cursorColor: Colors.black,
          // controller: newServicesController,
        )
    );
  }

  @override
  void dispose() {
    _servicesTabController.dispose();
    _roomsTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Опис туру"),
      ),
      backgroundColor: Colors.grey.shade300,
      body: FutureBuilder<Map<String, dynamic>>(
        future: tourInfo,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              photos = snapshot.data!["photos"];
              photosWidgets = imageSliders(photos!);
              name = snapshot.data!["name"];
              country = snapshot.data!["country"];
              city = snapshot.data!["city"];
              stars = snapshot.data!["stars"].toString();
              serviceType = snapshot.data!["food"].toString();
              priceUAH = snapshot.data!["price UAH"];
              priceUSD = snapshot.data!["price USD"];
              priceEUR = snapshot.data!["price EUR"];
              aboutTour = snapshot.data!["tour information"];
              generalInformation = snapshot.data!["general information"];
              tourAgent = snapshot.data!["tour agent"];
              servicesDescriptions = snapshot.data!["services"];
              roomsDescriptions = snapshot.data!["rooms"];
              _starsOption = getStarOption(stars!);
              _serviceOption = getServiceOption(serviceType!);
              tourAgentInfo = widget.database.getInfoByReference(tourAgent!);
              _servicesTabController = TabController(vsync: this, length: servicesDescriptions!.length);
              _roomsTabController = TabController(vsync: this, length: roomsDescriptions!.length);
              makeServiceTabs();
              makeRoomTabs();
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: photosWidgets,
                      ), // Photos
                      ListTile(
                        title: Text(
                          name!,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color:Colors.blue
                          ),
                        ),
                        trailing: Column(
                          children: [
                            Text(intl.NumberFormat.simpleCurrency(locale: 'uk_UA').format(priceUAH)),
                            Text(intl.NumberFormat.simpleCurrency(locale: 'en_US').format(priceUSD)),
                            Text(intl.NumberFormat.simpleCurrency(locale: 'de_DE').format(priceEUR)),
                          ],
                        ),
                      ),
                      Text(
                        " $city, $country ",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Інформація про тур",
                          ),
                          Text(
                            aboutTour!,
                          )
                        ],
                      ), // About tour
                      Text(
                        generalInformation!,
                      ),// General information
                      Column(
                        children: [
                          const Text(
                            "Послуги",
                          ),
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(color: Colors.white),
                            child: TabBar(
                              controller: _servicesTabController,
                              isScrollable: true,
                              labelColor: Colors.orange,
                              unselectedLabelColor: Colors.black,
                              tabs: getTabs(servicesDescriptions!.keys),
                            ),// ---------------------------------------------------------------------------------
                          ),
                          Container(
                            // color: Colors.white,
                            // height: 400, //height of TabBarView
                              decoration: const BoxDecoration(color: Colors.white),
                              height: 150,
                              child: TabBarView(
                                  controller: _servicesTabController,
                                  children: getTabsTexts(servicesDescriptions!.values)
                              )
                          ),
                        ],
                      ),// Services
                      Column(
                        children: [
                          const Text(
                            "Номери",
                          ),
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(color: Colors.white),
                            child: TabBar(
                              controller: _roomsTabController,
                              isScrollable: true,
                              labelColor: Colors.orange,
                              unselectedLabelColor: Colors.black,
                              tabs: getTabs(roomsDescriptions!.keys),
                            ),// ---------------------------------------------------------------------------------
                          ),
                          Container(
                              height: 150,
                              // height: 400, //height of TabBarView
                              decoration: const BoxDecoration(color: Colors.white),
                              child: TabBarView(
                                  controller: _roomsTabController,
                                  children: getTabsTexts(roomsDescriptions!.values)
                              )
                          )
                        ],
                      ), // Rooms
                      Column(
                        children: [
                          const Text(
                            "Зірки",
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RadioListTile(
                                title: const Text("1"),
                                activeColor: Colors.black,
                                value: HotelStar.one,
                                groupValue: _starsOption,
                                onChanged: (HotelStar? value) {
                                  setState(() {
                                    _starsOption = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("2"),
                                activeColor: Colors.black,
                                value: HotelStar.two,
                                groupValue: _starsOption,
                                onChanged: (HotelStar? value) {
                                  setState(() {
                                    _starsOption = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("3"),
                                activeColor: Colors.black,
                                value: HotelStar.three,
                                groupValue: _starsOption,
                                onChanged: (HotelStar? value) {
                                  setState(() {
                                    _starsOption = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("4"),
                                activeColor: Colors.black,
                                value: HotelStar.four,
                                groupValue: _starsOption,
                                onChanged: (HotelStar? value) {
                                  setState(() {
                                    _starsOption = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("5"),
                                activeColor: Colors.black,
                                value: HotelStar.five,
                                groupValue: _starsOption,
                                onChanged: (HotelStar? value) {
                                  setState(() {
                                    _starsOption = value;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      // ---------------------------------------------------------------------------------------------
                      Column(
                        children: [
                          const Text(
                            "Харчування",
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RadioListTile(
                                title: const Text("All Include (Все включено)"),
                                activeColor: Colors.black,
                                value: HotelService.allInclude,
                                groupValue: _serviceOption,
                                onChanged: (HotelService? value) {
                                  setState(() {
                                    _serviceOption = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("Сніданок"),
                                activeColor: Colors.black,
                                value: HotelService.breakfast,
                                groupValue: _serviceOption,
                                onChanged: (HotelService? value) {
                                  setState(() {
                                    _serviceOption = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("Сніданок, обід та вечеря"),
                                activeColor: Colors.black,
                                value: HotelService.breakfastDinnerLunch,
                                groupValue: _serviceOption,
                                onChanged: (HotelService? value) {
                                  setState(() {
                                    _serviceOption = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("Без харчування"),
                                activeColor: Colors.black,
                                value: HotelService.noFood,
                                groupValue: _serviceOption,
                                onChanged: (HotelService? value) {
                                  setState(() {
                                    _serviceOption = value;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("Ultra All Include"),
                                activeColor: Colors.black,
                                value: HotelService.ultraAllInclude,
                                groupValue: _serviceOption,
                                onChanged: (HotelService? value) {
                                  setState(() {
                                    _serviceOption = value;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      // ---------------------------------------------------------------------------------------------
                      FutureBuilder<Map<String, dynamic>>(
                        future: tourAgentInfo,
                        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: Row(
                                      children: <Widget> [
                                        Expanded(child:Image(image: NetworkImage(snapshot.data!["avatar"]), fit: BoxFit.cover,),),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!["name"],
                                              ),
                                              Text(
                                                snapshot.data!["email"],
                                              ),
                                              Text(
                                                snapshot.data!["tour company"],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                        textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: Colors. white,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    onPressed: () {
                                      String? chatRoom = widget.chat.getChatRoomID(widget.auth.user!.uid, tourAgent!.id) as String?;
                                      if (chatRoom == null) {
                                        Map<String, dynamic> chatData = <String, dynamic>{
                                          'users': [widget.auth.user!.uid, tourAgent!.id],
                                          'last message': null,
                                          'time': null,
                                        };
                                        chatRoom ??= widget.chat.addChatRoom(chatData) as String?;
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return Chat(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, chatRoomId: chatRoom!,);
                                          },
                                        ),
                                      );
                                    },
                                    child: const Text("НАПИСАТИ"),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Error');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      // Container(),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ReservingTour(auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database, tourID: widget.tour);
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            child: const Text(
                              'ЗАБРОНЮВАТИ',
                              style: TextStyle(color: Colors.white),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return Center(
                child: Column(
                  children: const [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ],
                ),
              );
            }
          },
      ),
    );
  }

  void logout(BuildContext context) {
    // Firebase logout
    Navigator.pushNamed(
      context,
      '/',
    );
  }
}