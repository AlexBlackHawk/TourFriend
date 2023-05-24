import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

enum HotelStar { one, two, three, four, five }
enum HotelService { allInclude, breakfast, breakfastDinnerLunch, noFood, ultraAllInclude }

class AddingTour extends StatefulWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  const AddingTour({super.key, required this.auth, required this.chat, required this.storage, required this.database});

  @override
  State<AddingTour> createState() => _AddingTourState();
}

class _AddingTourState extends State<AddingTour> with TickerProviderStateMixin {

  List<Tab> roomsTabs = <Tab>[];
  List<Widget> roomsTabsViews = <Widget>[];
  List<TextEditingController> roomsDescriptionControllers = <TextEditingController>[];

  List<Tab> servicesTabs = <Tab>[];
  List<Widget> servicesTabsViews = <Widget>[];
  List<TextEditingController> servicesDescriptionControllers = <TextEditingController>[];

  List<String> servicesTabsName = <String>[];
  List<String> roomsTabsName = <String>[];

  Map<String, String> servicesDescription = <String, String>{};
  Map<String, String> roomsDescription = <String, String>{};

  List<File> photoFiles = <File>[];

  List<String> imgList = <String>[];

  File? imageFile;

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

  final nameController = TextEditingController();
  final priceUAHController = TextEditingController();
  final priceUSDController = TextEditingController();
  final priceEURController = TextEditingController();
  final descriptionController = TextEditingController();
  final generalInfoController = TextEditingController();
  final servicesNameController = TextEditingController();
  final servicesController = TextEditingController();
  final roomNameController = TextEditingController();
  late TabController _servicesTabController;
  late TabController _roomsTabController;
  // late String roomName;
  // late String valueText;

  @override
  void initState() {
    super.initState();
    _servicesTabController = TabController(vsync: this, length: servicesTabs.length);
    _roomsTabController = TabController(vsync: this, length: roomsTabs.length);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    priceUAHController.dispose();
    priceUSDController.dispose();
    priceEURController.dispose();
    descriptionController.dispose();
    generalInfoController.dispose();
    servicesController.dispose();
    servicesNameController.dispose();
    roomNameController.dispose();
    _servicesTabController.dispose();
    _roomsTabController.dispose();
    for (var element in servicesDescriptionControllers) {
      element.dispose();
    }
    for (var element in roomsDescriptionControllers) {
      element.dispose();
    }
    super.dispose();
  }

  _getFromGallery() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _roomNameInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('TextField in Dialog'),
            content: TextField(
              // onChanged: (value) {
              //   setState(() {
              //     valueText = value;
              //   });
              // },
              controller: roomNameController,
              decoration: const InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    // roomName = valueText;
                    addRoomTab(); // roomName
                    addRoomTabBarView();
                    Navigator.pop(context);
                  });
                },
              ),

            ],
          );
        });
  }

  Future<void> _serviceNameInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('TextField in Dialog'),
            content: TextField(
              // onChanged: (value) {
              //   setState(() {
              //     valueText = value;
              //   });
              // },
              controller: servicesNameController,
              decoration: const InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    // roomName = valueText;
                    addServiceTab(); // roomName
                    addServiceTabBarView();
                    Navigator.pop(context);
                  });
                },
              ),

            ],
          );
        });
  }

  void setServices() {
    for (int i = 0; i < servicesTabs.length; i++) {
      servicesDescription[servicesTabsName[i]] = servicesDescriptionControllers[i].text;
    }
  }

  void setRooms() {
    for (int i = 0; i < roomsTabs.length; i++) {
      roomsDescription[roomsTabsName[i]] = roomsDescriptionControllers[i].text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ghbjlmk"),
        ),
        backgroundColor: Colors.grey.shade300,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            // alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [

                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        // autoPlay: true,
                      ),
                      items: getBB(),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors. white,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        child: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _getFromGallery();
                            if (imageFile != null) {
                              photoFiles.add(imageFile!);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Назва",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color:Colors.black
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      keyboardType: TextInputType.name,
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
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ціна",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color:Colors.black
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "UAH",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color:Colors.black
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
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
                                controller: priceUAHController,
                              ),
                              // const SizedBox(
                              //   height: 8.0,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "USD",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color:Colors.black
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
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
                                controller: priceUSDController,
                              ),
                              // const SizedBox(
                              //   height: 8.0,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "EUR",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color:Colors.black
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
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
                                controller: priceEURController,
                              ),
                              // const SizedBox(
                              //   height: 8.0,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Опис туру",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color:Colors.black
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.start,
                      // minLines: null,
                      maxLines: null,
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
                      controller: descriptionController,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Загальна інформація",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color:Colors.black
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.start,
                      // expands: true,
                      // minLines: null,
                      maxLines: null,
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
                      controller: generalInfoController,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),

                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            tabs: servicesTabs
                        ),// ---------------------------------------------------------------------------------
                      ),
                      Container(
                        // color: Colors.white,
                        // height: 400, //height of TabBarView
                          decoration: const BoxDecoration(color: Colors.white),
                          height: 150,
                          child: TabBarView(
                              controller: _servicesTabController,
                              children: servicesTabsViews
                          )
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors. white,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          child: const Icon(Icons.add, color: Colors.white,),
                          onPressed: () {
                            _serviceNameInputDialog(context);
                          },
                        ),
                      ),
                    ]
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        tabs: roomsTabs,
                      ),// ---------------------------------------------------------------------------------
                    ),
                    Container(
                        height: 150,
                        // height: 400, //height of TabBarView
                        decoration: const BoxDecoration(color: Colors.white),
                        child: TabBarView(
                            controller: _roomsTabController,
                            children: roomsTabsViews
                        )
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors. white,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        child: const Icon(Icons.add, color: Colors.white,),
                        onPressed: () {
                          _roomNameInputDialog(context);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 2.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                // // ---------------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(
                  height: 10.0,
                ),
                // tour characteristics
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        String userID = widget.auth.user!.uid;

                        servicesDescription = serviceDictionary();
                        roomsDescription = roomDictionary();

                        Map<String, dynamic> tourInfo = <String, dynamic>{
                          "photos": imgList,
                          "name": nameController.text,
                          "price UAH": priceUAHController.text,
                          "price USD": priceUSDController.text,
                          "price EUR": priceEURController.text,
                          "tour information": descriptionController.text,
                          "general information": generalInfoController.text,
                          "services": servicesDescription,
                          "rooms": roomsDescription,
                          "food": serviceString[_serviceOption],
                          "stars": starsString[_starsOption],
                          "tour agent": widget.database.db.doc("Users/$userID"),
                        };
                        String documentID = await widget.database.addNewDocument("Tours", tourInfo);
                        imgList = storeImages(documentID);
                        widget.database.updateDocumentData("Tours", documentID, {"photos": imgList});
                        const snackBar = SnackBar(
                          content: Text('Новий тур успішно створено'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      child: const Text(
                        'СТВОРИТИ',
                        style: TextStyle(color: Colors.white),
                      )
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  List<String> storeImages(String tourID) {
    List<String> result = <String>[];
    for (var element in photoFiles) {
      String fileName = p.basename(element.path);
      String filePath = "Tours/$tourID/$fileName";
      widget.storage.uploadFile(filePath, element.path, fileName).then((value) {
        result.add(value);
        // setState(() {
        //   result.add(value);
        // });
      });
    }
    return result;
  }

  Map<String, String> serviceDictionary() {
    Map<String, String> result = <String, String>{};
    for (var i = 0; i < servicesTabsName.length;i++) {
      result[servicesTabsName[i]] = servicesDescriptionControllers[i].text;
    }
    return result;
  }

  Map<String, String> roomDictionary() {
    Map<String, String> result = <String, String>{};
    for (var i = 0; i < roomsTabsName.length;i++) {
      result[roomsTabsName[i]] = roomsDescriptionControllers[i].text;
    }
    return result;
  }

  List<Widget> getBB() {
    return photoFiles.map((item) => Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.file(item, fit: BoxFit.cover, width: 1000.0),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: ButtonBar(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.create),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _getFromGallery();
                          if (imageFile != null) {
                            int itemIndex = photoFiles.indexOf(item);
                            photoFiles[itemIndex] = imageFile!;
                          }
                          // photos!.add(imageFile);
                        });
                      },
                    ), //replace photo
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          photoFiles.remove(item);
                        });
                      },
                    ), //delete photo
                  ],
                ),
              ),
            ],
          )),
    ))
        .toList();
  }

  void addRoomTab() { // String roomName
    // Tab roomTab = const Tab(text: 'Address');
    String roomTabName = roomNameController.text;
    roomsTabsName.add(roomTabName);
    roomsTabs.add(Tab(text: roomTabName));
  }

  void addRoomTabBarView() {
    TextEditingController newRoomController = TextEditingController();
    roomsDescriptionControllers.add(newRoomController);
    roomsTabsViews.add(
        TextField(
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          expands: true,
          minLines: null,
          maxLines: null,
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
          controller: newRoomController,
        )
    );
  }

  void addServiceTab() { // String roomName
    // Tab roomTab = const Tab(text: 'Address');
    String serviceTabName = servicesNameController.text;
    servicesTabsName.add(serviceTabName);
    servicesTabs.add(Tab(text: serviceTabName));
  }

  void addServiceTabBarView() {
    TextEditingController newServicesController = TextEditingController();
    servicesDescriptionControllers.add(newServicesController);
    servicesTabsViews.add(
        TextField(
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          expands: true,
          minLines: null,
          maxLines: null,
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
          controller: newServicesController,
        )
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      title: const Text(""),
      backgroundColor: Colors.blue[800],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Назад',
        onPressed: () => Navigator.pushNamed(context, '/tour_agent/tour_list'),
      ),
      actions: <Widget>[
        IconButton(onPressed: () => logout(context), icon: const Icon(Icons.logout), tooltip: "Вийти",)
      ],
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