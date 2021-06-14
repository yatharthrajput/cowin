import 'package:cowin/Models/CenterModel.dart';
import 'package:cowin/methods/CenterViewModel.dart';
//import 'package:cowin/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  String stateName;
  String districtName;
  String districtId;
  String stateId;
  DateTime date;
  String pin;
  bool isPin;

  MyHomePage(
      {@required this.stateName,
      @required this.stateId,
      @required this.districtName,
      @required this.districtId,
      @required this.date,
      @required this.pin,
      @required this.isPin});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();

  bool loading = true;

  bool _eighteen = true;
  bool _forty5 = true;
  bool cvld = true;
  bool cvx = true;
  String selectedDate;

  Widget myCard(CenterBlockModel centerBlockModel) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20),
        //     image: DecorationImage(
        //         image: AssetImage(
        //           'assets/start.jpg',
        //         ),
        //         fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Center(
                    child: Text(
                      centerBlockModel.sessions[0].vaccine.toString() ?? 'NA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(22),
                    ),
                    color: Colors.red,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(centerBlockModel.name, style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(centerBlockModel.address, style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                            centerBlockModel.sessions[0].minAgeLimit == null
                                ? 'NA'
                                : centerBlockModel.sessions[0].minAgeLimit.toString() + '+',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                        Text("Age", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                            centerBlockModel.sessions[0].availableCapacity == null
                                ? 'NA'
                                : centerBlockModel.sessions[0].availableCapacity.toString(),
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                        Text("Doses", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              //TIME SLOTS

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Slots Available:", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 5),
                    for (int i = 0; i < centerBlockModel.sessions[0].slots.length; i++)
                      Column(
                        children: [
                          SizedBox(height: 2),
                          Text(centerBlockModel.sessions[0].slots[i]),
                        ],
                      ),
                    SizedBox(height: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _loadData() async {
  //   await CenterViewModel.getCentresByDistrict(
  //       distId: widget.districtId, date: widget.date);
  //   await CenterViewModel.getCentresByPin(pin: widget.pin, date: widget.date);
  // }

  @override
  void initState() {
    // TODO: implement initState
    // _loadData();

    super.initState();
    if (mounted) {
      var day = (widget.date.day <= 9 ? '0' : '') + widget.date.day.toString();
      var month = (widget.date.month <= 9 ? '0' : '') + widget.date.month.toString();
      selectedDate = day + '-' + month + '-' + widget.date.year.toString();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,

        body: Stack(
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.6,
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(88)),
            //   ),
            // ),
            Center(child: Image.asset('assets/image.png')),
            FutureBuilder(
              future: widget.isPin
                  ? CenterViewModel.getCentresByPin(pin: widget.pin, date: selectedDate)
                  : CenterViewModel.getCentresByDistrict(distId: widget.districtId, date: selectedDate),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  CentresModel cm = snapshot.data;
                  print(cm.centers.length.toString());
                  print("data");
                  return CupertinoScrollbar(
                    //MAIN LIST VIEW
                    child: ListView(padding: EdgeInsets.symmetric(horizontal: 12), children: [
                      header(),
                      SizedBox(height: 25),
                      FilterMenu(),
                      cm.centers.length == 0
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.transparent.withOpacity(0.5),
                                // Colors.white.withOpacity(0.6),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  'No appointments',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsetsDirectional.only(top: 10, bottom: 20),
                              shrinkWrap: true,
                              itemCount: cm.centers.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                // print(cm.centers[i].sessions[0].vaccine);
                                bool show18 = false;
                                bool show45 = false;
                                bool showCovx = false;
                                bool showCovd = false;
                                if (cvx) {
                                  if (cm.centers[i].sessions[0].vaccine.toLowerCase().startsWith("covax"))
                                    showCovx = true;
                                  else
                                    showCovx = false;
                                }

                                if (cvld) {
                                  if (cm.centers[i].sessions[0].vaccine.toLowerCase().startsWith('covi'))
                                    showCovd = true;
                                  else
                                    showCovd = false;
                                }

                                if (_eighteen) {
                                  if (cm.centers[i].sessions[0].minAgeLimit == 18)
                                    show18 = true;
                                  else
                                    show18 = false;
                                }

                                if (_forty5) {
                                  if (cm.centers[i].sessions[0].minAgeLimit == 45)
                                    show45 = true;
                                  else
                                    show45 = false;
                                }
                                if ((show18 || show45) && (showCovd || showCovx))
                                  return myCard(cm.centers[i]);
                                else
                                  return Container();
                              }),
                    ]),
                  );
                } else
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        header(),

                        //TODO:ADDING SOME LOADING GIF
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),

                        Text(
                          'Getting centres...',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  );
              },
            ),
          ],
        ),


      ),
    );
  }

  FilterMenu() {
    double borderRadius = 12;
    Color red = Colors.red;
    Color tnsp = Colors.transparent.withOpacity(0.5);
    Color white = Colors.white;
    Color black = Colors.black;
    return Container(
      height: 40,

      // color: Colors.white.withOpacity(0.6),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: _eighteen ? red : white),
            ),
            color: _eighteen ? red : tnsp,
            child: Text("18+", style: TextStyle(color: white, fontWeight: FontWeight.w600)),
            onPressed: () {
              _eighteen = !_eighteen;
              HapticFeedback.lightImpact();
              setState(() {});
            },
          ),
          SizedBox(width: 10),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: _forty5 ? red : white),
            ),
            color: _forty5 ? red : tnsp,
            child: Text(
              "45+",
              style: TextStyle(color: white),
            ),
            onPressed: () {
              _forty5 = !_forty5;
              HapticFeedback.lightImpact();
              setState(() {});
            },
          ),

          SizedBox(width: 10),
          // SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: cvx ? red : white),
            ),
            color: cvx ? red : tnsp,
            child: Text(
              "Covaxin",
              style: TextStyle(
                color: white,
              ),
            ),
            onPressed: () {
              cvx = !cvx;
              HapticFeedback.lightImpact();
              setState(() {});
            },
          ),

          SizedBox(width: 10),
          // SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: cvld ? red : white),
            ),
            color: cvld ? red : tnsp,
            child: Text(
              "Covishield",
              style: TextStyle(
                color: white,
              ),
            ),
            onPressed: () {
              cvld = !cvld;
              HapticFeedback.lightImpact();
              setState(() {});
            },
          ),
          SizedBox(width: 10),
          // SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        ],
      ),
    );
  }

  header() {
    List<String> weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    // print(weekday[dateTime.weekday-1]+', '+dateTime.day.toString()+' '+ month[dateTime.month-1]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Align(
          alignment: Alignment.topLeft,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        SizedBox(height: 20),
        Text('Centres in ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Text("${widget.isPin ? widget.pin : widget.districtName + ','}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ))),
            // Text(getDate(widget.date), style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        widget.isPin
            ? Container()
            : Text("${widget.stateName}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                )),
      ],
    );
  }
}
