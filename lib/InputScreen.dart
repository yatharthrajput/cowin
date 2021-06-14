import 'package:cowin/Models/DisctrictsModel.dart';
import 'package:cowin/Models/IndStateModel.dart';
import 'package:cowin/homePage.dart';
import 'package:cowin/methods/DistrictsViewModel.dart';
import 'package:cowin/methods/StatesViewModel.dart';
//import 'package:cowin/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController stateController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController pinController = TextEditingController(text: "");
  StatesModel selectedStatesModel = StatesModel(stateName: 'Choose State', stateId: null);
  final _formKey1 = GlobalKey<FormState>();
  bool pinError = false;
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));

  DistrictBlockModel selectedDistModel = DistrictBlockModel(districtName: 'Choose District', districtId: null);
  // String selectedDistName;
  // String selectedDistId;
  void _loadStates() async {
    await StateViewModel.getStates();
  }

  @override
  void initState() {
    // TODO: implement initState
    // _loadData();
    _loadStates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Image.asset('assets/image.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GestureDetector(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_sharp, color: Colors.white),
                    // Text(
                    //   ' ${selectedDate != null ? getDate(selectedDate) : 'Choose Date'}',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 20,
                    //   ),
                    // )
                  ],
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime datetime = DateTime.now();
                  datetime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2100),
                  );
                  if (datetime != null) {
                    // var day = (date.day <= 9 ? '0' : '') + date.day.toString();
                    // var month =
                    //     (date.month <= 9 ? '0' : '') + date.month.toString();
                    // selectedDate =
                    //     day + '-' + month + '-' + date.year.toString();
                    // // selectDay = weekday[date.weekday - 1];
                    // print(selectedDate);
                    selectedDate = datetime;
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Search By Pin Code:",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                  SizedBox(height: 20),
                  PinCodeTextField(
                    hasUnderline: true,
                    controller: pinController,
                    highlight: true,
                    defaultBorderColor: Colors.white,
                    pinTextStyle: TextStyle(color: Colors.white),
                    hasTextBorderColor: Colors.grey.shade100.withOpacity(0.5),
                    highlightColor: Colors.white,
                    maxLength: 6,
                    pinBoxHeight: MediaQuery.of(context).size.width / 8,
                    pinBoxWidth: MediaQuery.of(context).size.width / 8,
                    pinBoxRadius: 16,
                    onDone: (otp) {
                      if (pinError) {
                        if (pinController.text.length == 6) {
                          pinError = false;
                          setState(() {});
                        }
                      }
                    },
                  ),
                  pinError ? Text('Enter Pincode', style: TextStyle(color: Colors.red)) : Container(),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Find Centres ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      ),
                      onPressed: () {
                        if (pinController.text.length != 6) {
                          pinError = true;
                          setState(() {});
                        } else
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => MyHomePage(
                                        stateName: selectedStatesModel.stateName,
                                        districtName: selectedDistModel.districtName,
                                        stateId: selectedStatesModel.stateId.toString(),
                                        districtId: selectedDistModel.districtId.toString(),
                                        date: selectedDate,
                                        pin: pinController.text,
                                        isPin: true,
                                      )));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(child: Divider(color: Colors.white.withOpacity(0.6), thickness: 2)),
              Text("  OR  ", style: TextStyle(color: Colors.white, fontSize: 25)),
              Expanded(child: Divider(color: Colors.white.withOpacity(0.6), thickness: 2)),
            ]),
            SizedBox(height: 20),
            Form(
              key: _formKey1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Search by state",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        )),
                    Text(" & district:",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        )),
                    SizedBox(height: 20),
                    DropdownSearch<StatesModel>(
                      // searchBoxController: TextEditingController(text: ''),
                      items: StateViewModel.statesModel,
                      selectedItem: selectedStatesModel,

                      mode: Mode.DIALOG,
                      maxHeight: 300,
                      // showSelectedItem: true,
                      dropdownSearchDecoration: InputDecoration(
                          labelText: 'State',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(borderSide: BorderSide.none)),
                      searchBoxDecoration: InputDecoration(
                        prefix: Icon(Icons.search),
                        hintText: 'Search',
                      ),
                      // dialogMaxWidth: 500,
                      isFilteredOnline: true,
                      showClearButton: false,
                      showSearchBox: true,
                      showAsSuffixIcons: false,
                      dropDownButton: Icon(Icons.expand_more, color: Colors.white),
                      filterFn: (item, query) {
                        return item.stateName.toLowerCase().startsWith(query.toLowerCase());
                      },
                      popupBackgroundColor: Colors.white,
                      // Colors.grey.shade100.withOpacity(0.6),
                      // autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (StatesModel sm) {
                        if (sm.stateId == null) return 'Choose State';
                        return null;
                      },
                      onChanged: (item) async {
                        selectedStatesModel = StatesModel(stateId: item.stateId, stateName: item.stateName);
                        setState(() {
                          DistrictViewModel.districts.clear();
                          selectedDistModel = DistrictBlockModel(districtName: 'Choose District', districtId: null);

                          stateController.text = item.stateName;
                        });
                        await DistrictViewModel.getDistricts(id: selectedStatesModel.stateId.toString());
                        setState(() {});
                      },

                      dropdownBuilder: (context, selectedItem, itemAsString) {
                        if (selectedItem == null) {
                          return Container();
                        }
                        return ListTile(
                          title: Text(selectedItem.stateName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              )),
                        );
                      },
                      popupItemBuilder: (context, item, isSelected) {
                        return Column(
                          children: [
                            ListTile(
                                title: Text(
                              item.stateName,
                              style: TextStyle(fontSize: 18),
                            )),
                            Divider(),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownSearch<DistrictBlockModel>(
                      selectedItem: selectedDistModel,
                      items: DistrictViewModel.districts,

                      mode: Mode.DIALOG,
                      maxHeight: 300,
                      // showSelectedItem: true,
                      dropdownSearchDecoration: InputDecoration(
                          labelText: 'District',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(borderSide: BorderSide.none)),
                      searchBoxDecoration: InputDecoration(
                        prefix: Icon(Icons.search),
                        hintText: 'Search',
                      ),
                      // dialogMaxWidth: 500,
                      isFilteredOnline: true,
                      showClearButton: false,
                      showSearchBox: true,
                      showAsSuffixIcons: false,
                      dropDownButton: Icon(Icons.expand_more, color: Colors.white),

                      filterFn: (item, query) {
                        return item.districtName.toLowerCase().startsWith(query.toLowerCase());
                      },
                      // showSelectedItem: true
                      popupBackgroundColor: Colors.white,
                      // Colors.grey.shade200.withOpacity(0.6),

                      // autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (DistrictBlockModel dm) {
                        if (dm.districtId == null) return 'Choose District';
                        return null;
                      },
                      onChanged: (dm) {
                        setState(() {
                          selectedDistModel =
                              DistrictBlockModel(districtId: dm.districtId, districtName: dm.districtName);
                        });
                      },

                      popupItemBuilder: (context, item, isSelected) {
                        return Column(
                          children: [
                            ListTile(
                                title: Text(
                              item.districtName,
                            )),
                            Divider(),
                          ],
                        );
                      },
                      dropdownBuilder: (context, selectedItem, itemAsString) {
                        if (selectedItem == null) {
                          return Container();
                        }
                        return ListTile(
                          title: Text(selectedItem.districtName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              )),
                        );
                      },
                      // popupSafeArea: PopupSafeArea(top: true, bottom: true),
//                    selectedItem:
//                        districtBlockModel ?? DistrictViewModel.districts[0],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Find Centres ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () {
                          if (_formKey1.currentState.validate())
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyHomePage(
                                          stateName: selectedStatesModel.stateName,
                                          districtName: selectedDistModel.districtName,
                                          stateId: selectedStatesModel.stateId.toString(),
                                          districtId: selectedDistModel.districtId.toString(),
                                          date: selectedDate,
                                          pin: pinController.text,
                                          isPin: false,
                                        )));
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
