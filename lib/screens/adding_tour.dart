import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

enum HotelStar { one, two, three, four, five }
enum HotelService { allInclude, breakfast, breakfastDinnerLunch, noFood, ultraAllInclude }

class AddingTour extends StatefulWidget {
  const AddingTour({super.key});

  @override
  State<AddingTour> createState() => _AddingTourState();
}

class _AddingTourState extends State<AddingTour> with TickerProviderStateMixin {
  HotelStar? _starOption;
  HotelService? _serviceOption;

  List<Tab> roomsTabs = <Tab>[];
  List<Widget> roomsTabsViews = <Widget>[];
  List<TextEditingController> roomsDescriptionControllers = <TextEditingController>[];

  List<Tab> servicesTabs = <Tab>[];
  List<Widget> servicesTabsViews = <Widget>[];
  List<TextEditingController> servicesDescriptionControllers = <TextEditingController>[];

  List<String> imgList = [
    // 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    // 'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    // 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    // 'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    // 'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    // 'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  final nameController = TextEditingController();
  final priceUAHController = TextEditingController();
  final priceUSDController = TextEditingController();
  final priceEURController = TextEditingController();
  final descriptionController = TextEditingController();
  final generalInfoController = TextEditingController();
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
                            imgList.add("fhgbjnk");
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
                            _roomNameInputDialog(context);
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
                          groupValue: _starOption,
                          onChanged: (HotelStar? value) {
                            setState(() {
                              _starOption = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("2"),
                          activeColor: Colors.black,
                          value: HotelStar.two,
                          groupValue: _starOption,
                          onChanged: (HotelStar? value) {
                            setState(() {
                              _starOption = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("3"),
                          activeColor: Colors.black,
                          value: HotelStar.three,
                          groupValue: _starOption,
                          onChanged: (HotelStar? value) {
                            setState(() {
                              _starOption = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("4"),
                          activeColor: Colors.black,
                          value: HotelStar.four,
                          groupValue: _starOption,
                          onChanged: (HotelStar? value) {
                            setState(() {
                              _starOption = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("5"),
                          activeColor: Colors.black,
                          value: HotelStar.five,
                          groupValue: _starOption,
                          onChanged: (HotelStar? value) {
                            setState(() {
                              _starOption = value;
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
                      onPressed: () {
                        Navigator.pop(context);
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

  List<Widget> getBB() {
    return imgList.map((item) => Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 1000.0),
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
                          int itemIndex = imgList.indexOf(item);
                          imgList[itemIndex] = "";
                        });
                      },
                    ),
                    // Ink(
                    //   decoration: const ShapeDecoration(
                    //     color: Colors.lightBlue,
                    //     shape: CircleBorder(),
                    //   ),
                    //   child: IconButton(
                    //     icon: const Icon(Icons.create),
                    //     color: Colors.white,
                    //     onPressed: () {
                    //       setState(() {
                    //         int itemIndex = imgList.indexOf(item);
                    //         imgList[itemIndex] = "";
                    //       });
                    //     },
                    //   ),
                    // ),
                    // Ink(
                    //   decoration: const ShapeDecoration(
                    //     color: Colors.lightBlue,
                    //     shape: CircleBorder(),
                    //   ),
                    //   child: IconButton(
                    //     icon: const Icon(Icons.clear),
                    //     color: Colors.white,
                    //     onPressed: () {
                    //       setState(() {
                    //         imgList.remove(item);
                    //       });
                    //     },
                    //   ),
                    // ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          imgList.remove(item);
                        });
                      },
                    ),
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
    roomsTabs.add(Tab(text: roomNameController.text));
  }

  void addRoomTabBarView() {
    TextEditingController newRoomController = TextEditingController();
    roomsDescriptionControllers.add(newRoomController);
    roomsTabsViews.add(
        TextField(
          keyboardType: TextInputType.name,
          textAlign: TextAlign.center,
          expands: true,
          minLines: null,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: newRoomController,
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