import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart' as intl;
import 'editing_tour.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

enum HotelStar { one, two, three, four, five }
enum HotelService { allInclude, breakfast, breakfastDinnerLunch, noFood, ultraAllInclude }

class AgentTourInformation extends StatefulWidget {
  const AgentTourInformation({super.key});

  @override
  State<AgentTourInformation> createState() => _AgentTourInformationState();
}

class _AgentTourInformationState extends State<AgentTourInformation> with TickerProviderStateMixin {
  String hotelStars = "3";
  HotelStar? _starsOption; // Write logic
  var starsString = {
    HotelStar.one : "1",
    HotelStar.two : "2",
    HotelStar.three : "3",
    HotelStar.four : "4",
    HotelStar.five : "5",
  };

  String hotelService = "";
  HotelService? _serviceOption; // Write logic
  var serviceString = {
    HotelService.allInclude : "All Include (Все включено)",
    HotelService.breakfast : "Сніданок",
    HotelService.breakfastDinnerLunch : "Сніданок, обід та вечеря",
    HotelService.noFood : "Без харчування",
    HotelService.ultraAllInclude : "Ultra All Include",
  };

  final List<Widget> imageSliders = imgList.map((item) => Container(
    margin: const EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(item, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'No. ${imgList.indexOf(item)} image',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )),
  ))
      .toList();

  late TabController _servicesTabController;
  late TabController _roomsTabController;

  @override
  void initState() {
    super.initState();
    _servicesTabController = TabController(vsync: this, length: 4);
    _roomsTabController = TabController(vsync: this, length: 3);
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
        title: const Text("ghbjlmk"),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text(
              //     "Gallery Hotel Sis",
              //     style: TextStyle(
              //         fontSize: 15,
              //         fontWeight: FontWeight.w400,
              //         color:Colors.blue
              //     ),
              //   ),
              // ), // Tour name
              CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  // autoPlay: true,
                ),
                items: imageSliders,
              ), // Photos
              ListTile(
                title: const Text(
                  "Gallery Hotel Sis",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color:Colors.blue
                  ),
                ),
                trailing: Column(
                  children: [
                    Text(intl.NumberFormat.simpleCurrency(locale: 'uk_UA').format(10000)),
                    Text(intl.NumberFormat.simpleCurrency(locale: 'en_US').format(10000)),
                    Text(intl.NumberFormat.simpleCurrency(locale: 'de_DE').format(10000)),
                  ],
                ),
              ),
              Column(
                children: const [
                  Text(
                    "Інформація про тур",
                  ),
                  Text(
                    "Дати туру: з 17.03 по 26.03, Тривалість: 9 ночей в Standard Room, Xарчування: все включено, Туристи: 1 дорослий, Переліт включений",
                  )
                ],
              ), // About tour
              const Text(
                "Homestay знаходиться в 5 км від центру Шарм-ель-Шейха - затоки Наама-Бей і в 2 км від вулиці Іль Меркато. Гостям резорту пропонується щоденний трансфер до центральних вулиць міста, де вони можуть відвідати торгові центри і рибний ресторан «Фарес». Аеропорт курорту знаходиться в 18 км. Постояльці можуть залишити автомобіль на парковці з приватною охороною. У номерах є сейф, фен, міні-бар і телевізор з дитячими каналами, балкон або тераса. Ванна оснащена приладдям для душа. На ваше прохання безкоштовно принесуть дитяче ліжко. Прибирання здійснюється щодня. Сервіс доставки їжі в номер, а також пральня та прасування одягу доступні за додаткову плату. Молодята, які хочуть купити тур в Xperience St. George Homestay можуть придбати пакет послуг для молодят. Новоспечену сімейну пару чекають компліменти після прибуття в вигляді святкового торта і кошики з фруктами. Також серед переваг - безкоштовне прання 10 одиниць одягу за один раз. Залишаючи відгуки про Xperience St. George Homestay, гості відзначають якісне харчування і смачні страви в ресторані готелю. На прохання мандрівника приготують дієтичну їжу. Вечорами постояльців чекають тематичні вечері. Крім «шведського столу» в головному закладі, гості також можуть пригоститися прохолодними напоями і місцевим алкоголем в барах резорту. У ресторані є дитячий куточок. На терасі подають легкі закуски. Готель знаходиться на другій берегової лінії і в затоці Шарм-ель-Майя.</span> Вхід в море - пологий. До послуг постояльців пляжне обладнання: лежаки, тенти і рушники. У морського берега гості можуть зіграти в волейбол і за доплату зайнятися дайвінгом з інструктором. Біля басейну туристи можуть насолоджуватися коктейлями та засмагати на терасі. Малюкам доступний дитячий басейн. Замовити розслаблюючі процедури в спа-центрі, а також дізнатися, яка їх ціна в Xperience St. George Homestay можна на ресепшені готелю. У спа-комплексі вам організують масаж, похід в хаммам, приготують парну і джакузі. На території працює салон краси. Також туристам доступний безкоштовний фітнес-клуб, стіл для тенісу та поле для гри в міні-футбол. За доплату можна зіграти в більярд. Тури в Xperience St. George Homestay дозволять маленьким гостям розважитися з командою аніматорів. Персонал захопить малюків розвиваючими іграми та намалює забавний аквагрим. Аніматори активно залучають гостей резорту до командних ігор. Туристи проводять змагання на галявині біля басейну і на пляжі. У цьому можна переконатися, подивившись фото готелю Xperience St. George Homestay. Увечері для гостей проводять розважальні шоу. Персонал готелю спілкується з відпочиваючими англійською та арабською мовами. На ресепшені адміністратор відреагує на всі ваші прохання, за доплату для вас викличуть доктора і організують трансфер. У туристичному бюро допоможуть організувати екскурсію. Готель приймає платіжні картки. Гості можуть скористатися пунктом обміну валют і банкоматом.",
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
                      tabs: const [
                        Tab(text: "Розваги та спорт"),
                        Tab(text: "Харчування"),
                        Tab(text: "Послуги готелю"),
                        Tab(text: "Краса та лікування")
                      ],
                    ),// ---------------------------------------------------------------------------------
                  ),
                  Container(
                    // color: Colors.white,
                    // height: 400, //height of TabBarView
                      decoration: const BoxDecoration(color: Colors.white),
                      height: 150,
                      child: TabBarView(
                          controller: _servicesTabController,
                          children: const <Widget>[
                            Text(
                              "прокат велосипедів",
                            ),
                            Text(
                              "ресторан, бар, обслуговування номерів, сніданок в номер",
                            ),
                            Text(
                              "wi-fi: безкоштовно, оренда автомобіля,  оренда ноутбука, банкетна зала, час роботи reception: цілодобово, кімната для зберігання багажу, парковка: безкоштовно, пральня, сейф, сувенірна крамниця, чищення взуття, факс / ксерокс / принтер, екскурсійні програми, послуги екскурсовода/замовлення квитків",
                            ),
                            Text(
                              "spa-салон, масаж, сауна",
                            ),
                          ]
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
                      tabs: const [
                        Tab(text: "Економ"),
                        Tab(text: "Звичайний"),
                        Tab(text: "Люкс")
                      ],
                    ),// ---------------------------------------------------------------------------------
                  ),
                  Container(
                      height: 150,
                      // height: 400, //height of TabBarView
                      decoration: const BoxDecoration(color: Colors.white),
                      child: TabBarView(
                          controller: _roomsTabController,
                          children: const <Widget>[
                            Text(
                              "Двоспальне ліжко або 2 односпальні ліжка. Душ, туалет, фен, праска, дошка для прасування, косметичні засоби: так, телефон, письмовий стіл, TБ: супутникове. Послуга wake-up",
                            ),
                            Text(
                              "Спальні місця для трьох або 3 односпальні ліжка. Душ, туалет, фен, телефон, письмовий стіл, TБ: супутникове. Послуга wake-up",
                            ),
                            Text(
                              "Спальні місця для чотирьох або 1 двоспальне ліжко, 2 односпальні ліжка. Душ туалет, фен, CD-плеєр, письмовий стіл, TБ: супутникове. Послуга wake-up",
                            ),
                          ]
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
                  // Row(
                  //     children: <Widget> [
                  //       // const Expanded(child:Image(image: NetworkImage("https://this-person-does-not-exist.com/gen/avatar-1140910d77f103ce53aad9947e6ce90f.jpg"), fit: BoxFit.cover,),),
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             const Text("All Include (Все включено)"),
                  //             Radio(
                  //               // activeColor: Colors.white,
                  //               value: HotelService.allInclude,
                  //               groupValue: _serviceOption,
                  //               onChanged: (HotelService? value) {
                  //                 setState(() {
                  //                   _serviceOption = value;
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             const Text("Сніданок"),
                  //             Radio(
                  //               // activeColor: Colors.white,
                  //               value: HotelService.breakfast,
                  //               groupValue: _serviceOption,
                  //               onChanged: (HotelService? value) {
                  //                 setState(() {
                  //                   _serviceOption = value;
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             const Text("Сніданок, обід та вечеря"),
                  //             Radio(
                  //               // activeColor: Colors.white,
                  //               value: HotelService.breakfastDinnerLunch,
                  //               groupValue: _serviceOption,
                  //               onChanged: (HotelService? value) {
                  //                 setState(() {
                  //                   _serviceOption = value;
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             const Text("Без харчування"),
                  //             Radio(
                  //               // activeColor: Colors.white,
                  //               value: HotelService.noFood,
                  //               groupValue: _serviceOption,
                  //               onChanged: (HotelService? value) {
                  //                 setState(() {
                  //                   _serviceOption = value;
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             const Text("Ultra All Include"),
                  //             Radio(
                  //               // activeColor: Colors.white,
                  //               value: HotelService.ultraAllInclude,
                  //               groupValue: _serviceOption,
                  //               onChanged: (HotelService? value) {
                  //                 setState(() {
                  //                   _serviceOption = value;
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ]
                  // ),
                ],
              ),
              // ---------------------------------------------------------------------------------------------// Tour agent
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
                            return const EditingTour();
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
                      'РЕДАГУВАТИ',
                      style: TextStyle(color: Colors.white),
                    )
                ),
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                      'ВИДАЛИТИ',
                      style: TextStyle(color: Colors.white),
                    )
                ),
              ),
            ],
          ),
        ),
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
