import 'package:flutter/material.dart';
import 'package:gym_bar_sales/core/enums.dart';
import 'package:gym_bar_sales/core/models/category.dart';
import 'package:gym_bar_sales/core/models/client.dart';
import 'package:gym_bar_sales/core/models/employee.dart';
import 'package:gym_bar_sales/core/models/product.dart';
import 'package:gym_bar_sales/core/view_models/category_model.dart';
import 'package:gym_bar_sales/core/view_models/employee_client_model.dart';
import 'package:gym_bar_sales/ui/shared/text_styles.dart';
import 'package:gym_bar_sales/ui/views/base_view.dart';
import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';
import 'package:gym_bar_sales/ui/widgets/home_item.dart';
import 'package:search_widget/search_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddBill extends StatefulWidget {
  @override
  _AddBillState createState() => _AddBillState();
}

class _AddBillState extends State<AddBill> {
  String selectedBuyerName = "";
  int totalBill = 0;
  final TextEditingController name = TextEditingController();
  final TextEditingController payed = TextEditingController();
  String selectedCategory = "All";
  String selectedBuyerType = "Client";
  List<Product> filteredProduct;
  List<Product> selectedList = List<Product>();

  BorderRadiusGeometry radius =
      BorderRadius.only(topLeft: Radius.circular(28.0), topRight: Radius.circular(28.0));
  var branch = "بيفرلي";

  appBar() {
    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text("profile"),
          onPressed: () {},
        ),
        RaisedButton(
          child: Text("treasury"),
          onPressed: () {},
        ),
        RaisedButton(
          child: Text(selectedBuyerName),
          onPressed: () {},
        )
      ],
    );
  }

  searchWidget(List<Employee> employees, List<Client> clients, context) {
    if (selectedBuyerType == "Employee") {
      return Container(
        width: 400,
        child: SearchWidget<Employee>(
          dataList: employees,
          hideSearchBoxWhenItemSelected: false,
          listContainerHeight: MediaQuery.of(context).size.height / 4,
          queryBuilder: (String query, List<Employee> employee) {
            return employee
                .where((Employee employee) =>
                    employee.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
          },
          popupListItemBuilder: (Employee employee) {
            return Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(employee.name, style: const TextStyle(fontSize: 16))),
              ],
            );
          },
          selectedItemBuilder:
              // ignore: missing_return
              (Employee selectedItem, VoidCallback deleteSelectedItem) {},
          onItemSelected: (Employee employee) {
            setState(() {
              selectedBuyerName = employee.name;
            });
            print(selectedBuyerName);
          },
          noItemsFoundWidget: Center(child: Text("No item Found")),
          textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
            return searchTextField(controller, focusNode, context);
          },
        ),
      );
    }
    if (selectedBuyerType == "Client") {
      return Container(
        width: 400,
        child: SearchWidget<Client>(
          dataList: clients,
          hideSearchBoxWhenItemSelected: false,
          listContainerHeight: MediaQuery.of(context).size.height / 4,
          queryBuilder: (String query, List<Client> client) {
            return client
                .where((Client client) => client.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
          },
          popupListItemBuilder: (Client client) {
            return Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(client.name, style: const TextStyle(fontSize: 16))),
              ],
            );
          },
          selectedItemBuilder:
              // ignore: missing_return
              (Client selectedItem, VoidCallback deleteSelectedItem) {},
          onItemSelected: (Client client) {
            setState(() {
              selectedBuyerName = client.name;
            });
            print(selectedBuyerName);
          },
          noItemsFoundWidget: Center(child: Text("No item Found")),
          textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
            return searchTextField(controller, focusNode, context);
          },
        ),
      );
    } else
      return Container();
  }

  _buildCategoryList({List<Category> category, List<Product> products}) {
    List<Widget> choices = List();
    if (selectedCategory == "All") {
      filteredProduct = products;
    }
    choices.add(Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: ChoiceChip(
          labelStyle: chipLabelStyleLight,
          selectedColor: Colors.green,
          backgroundColor: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.green),
          ),
          label: Text("All"),
          selected: selectedCategory == "All",
          onSelected: (selected) {
            setState(() {
              selectedCategory = "All";
              filteredProduct = products;
            });
          },
        )));
    for (int i = 0; i < category.length; i++) {
      choices.add(Container(
        padding: const EdgeInsets.only(left: 30.0),
        child: ChoiceChip(
          labelStyle: chipLabelStyleLight,
          selectedColor: Colors.orange,
          backgroundColor: Colors.white,
          shape: StadiumBorder(side: BorderSide(color: Colors.orange)),
          label: Text(category[i].name),
          selected: selectedCategory == category[i].name,
          onSelected: (selected) {
            setState(() {
              selectedCategory = category[i].name;
              filteredProduct =
                  products.where((product) => product.category == selectedCategory).toList();
            });
          },
        ),
      ));
    }
    return choices;
  }

  List<Widget> buyerTypeChoices() {
    return [
      ChoiceChip(
        labelStyle: chipLabelStyleLight,
        selectedColor: Colors.blue,
        backgroundColor: Colors.white,
        shape: StadiumBorder(
          side: BorderSide(color: Colors.blue),
        ),
        label: Text("عميل"),
        selected: selectedBuyerType == "Client",
        onSelected: (selected) {
          setState(() {
            selectedBuyerType = "Client";
          });
          calculateTheTotalBillPerProduct();
          calculateTheTotalBill();
        },
      ),
      SizedBox(width: 20),
      ChoiceChip(
        labelStyle: chipLabelStyleLight,
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
        shape: StadiumBorder(
          side: BorderSide(color: Colors.blue),
        ),
        label: Text("عامل"),
        selected: selectedBuyerType == "House",
        onSelected: (selected) {
          setState(() {
            selectedBuyerType = "House";
          });
          calculateTheTotalBillPerProduct();
          calculateTheTotalBill();
        },
      ),
      SizedBox(width: 20),
      ChoiceChip(
        labelStyle: chipLabelStyleLight,
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
        shape: StadiumBorder(
          side: BorderSide(color: Colors.blue),
        ),
        label: Text("موظف"),
        selected: selectedBuyerType == "Employee",
        onSelected: (selected) {
          setState(() {
            selectedBuyerType = "Employee";
          });
          calculateTheTotalBillPerProduct();
          calculateTheTotalBill();
        },
      )
    ];
  }

  billHeader({List<Employee> employees, List<Client> clients, context}) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Text(
          "الفاتوره",
          style: headerStyle,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: searchWidget(employees, clients, context)),
            SizedBox(
              width: 15,
            ),
            Text('اسم المشتري'),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          children: buyerTypeChoices(),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  tableHead() {
    return Container(
      height: 60,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("الإجمالي", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("سعر القطعه", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("العدد", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
          Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("اسم المنتج", style: tableTitleStyle),
              SizedBox(width: 10),
            ],
          )),
        ],
      ),
    );
  }

  calculateTheTotalBillPerProduct() {
    for (int i = 0; i < selectedList.length; i++) {
      selectedList[i].theTotalBillPerProduct = selectedList[i].selectionNo *
          int.parse(
            selectedBuyerType == "Client"
                ? selectedList[i].customerPrice
                : selectedBuyerType == "Employee"
                    ? selectedList[i].employeePrice
                    : selectedList[i].housePrice,
          );
    }
  }

  calculateTheTotalBill() {
    var sum = 0;
    selectedList.forEach((element) {
      sum += element.theTotalBillPerProduct;
    });
    setState(() {
      totalBill = sum;
    });
  }

//  var priceWidget;

//  priceManager(index) {
//    if (selectedBuyerType == "Employee") {
//      setState(() {
//        priceWidget = Text(selectedList[index].employeePrice, style: tableContentStyle);
//      });
//    }
//    if (selectedBuyerType == "Client") {
//      setState(() {
//        priceWidget = Text(selectedList[index].customerPrice, style: tableContentStyle);
//      });
//    }
//    if (selectedBuyerType == "House") {
//      setState(() {
//        priceWidget = Text(selectedList[index].housePrice, style: tableContentStyle);
//      });
//    }
//  }

  tableBuilder() {
    return ListView.builder(
        itemCount: selectedList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  minHeight: 15.0,
                  maxHeight: 200,
                ),
                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(width: 150),
                    Container(
                      child: Text(selectedList[index].theTotalBillPerProduct.toString(),
                          style: tableContentStyle),
                      constraints: BoxConstraints(
                        maxWidth: 100.0,
                        minWidth: 100,
                      ),
                    ),
                    SizedBox(width: 230),
                    Container(
                      child: Text(
                          selectedBuyerType == "Client"
                              ? selectedList[index].customerPrice
                              : selectedBuyerType == "Employee"
                                  ? selectedList[index].employeePrice
                                  : selectedList[index].housePrice,
                          style: tableContentStyle),
                      constraints: BoxConstraints(
                        maxWidth: 100.0,
                        minWidth: 100,
                      ),
                    ),
                    SizedBox(width: 70),
                    Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 100,
                          ),
                          child: IconButton(
                            color: Colors.red,
                            iconSize: 50,
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              final product = filteredProduct.firstWhere(
                                  (product) => product.name == selectedList[index].name);
                              setState(() {
                                product.selectionNo -= 1;
                                product.theTotalBillPerProduct =
                                    product.selectionNo * int.parse(product.customerPrice);
                                selectedList
                                    .removeWhere((selectedList) => selectedList.selectionNo == 0);
                              });
                              calculateTheTotalBill();
                            },
                          ),
                        ),
                        SizedBox(width: 50),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 50,
                          ),
                          child: Text(selectedList[index].selectionNo.toString(),
                              style: tableContentStyle),
                        ),
                        SizedBox(width: 10),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            minWidth: 100,
                          ),
                          child: IconButton(
                              color: Colors.green,
                              iconSize: 50,
                              icon: Icon(Icons.add_circle),
                              onPressed: () {
                                final product = filteredProduct.firstWhere(
                                    (product) => product.name == selectedList[index].name);
                                setState(() {
                                  product.selectionNo += 1;
                                  product.theTotalBillPerProduct =
                                      product.selectionNo * int.parse(product.customerPrice);
                                });
                                calculateTheTotalBill();
                              }),
                        ),
                        SizedBox(width: 120),
                      ],
                    ),

                    //todo: change customerPrice to the selected one in the slidingUpPanel.
                    Container(
                        constraints: BoxConstraints(
                          maxWidth: 100.0,
                          minWidth: 100,
                        ),
                        child: Text(selectedList[index].name, style: tableContentStyle))
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.black),
              Divider(height: 1, color: Colors.black),
            ],
          );
        });
  }

  billFooter(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              totalBill.toString(),
              style: formTitleStyle,
            ),
            SizedBox(
              width: 80,
            ),
            Text(
              'الاجمالي',
              style: formTitleStyle,
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        SizedBox(height: 20),
        Divider(height: 1, color: Colors.black),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
                onDoubleTap: () {
                  _dialog();
                },
                child: Text('500', style: formTitleStyle)),
            SizedBox(width: 80),
            Text('المدفوع', style: formTitleStyle),
            SizedBox(width: 20),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                constraints: BoxConstraints(
                  minWidth: 110,
                  minHeight: 50,
                  maxWidth: 500,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('الباقي: 12', style: formTitleStyle),
                  ],
                )),
            SizedBox(width: 15),
          ],
        ),
        SizedBox(height: 15),
        Center(
            child: ButtonTheme(
          minWidth: 200.0,
          height: 40,
          child: RaisedButton(
            color: Colors.blueAccent,
            child: Text("إتمام العمليه", style: formButtonStyle),
            onPressed: () {},
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(height: 20),
      ],
    );
  }

  _dialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('title'),
          content: formTextFieldTemplate(),
          actions: <Widget>[
            FlatButton(
              child: Text('buttonText'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryModel>(
        onModelReady: (model) => model.fetchCategoriesAndProducts(branchName: branch),
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                body: SlidingUpPanel(
                  parallaxEnabled: true,
                  backdropEnabled: true,
                  backdropOpacity: 0.3,
                  maxHeight: 800,
                  borderRadius: radius,
                  panel: BaseView<EmployeeClientModel>(
                    onModelReady: (model) => model.fetchClientsAndEmployees(branchName: branch),
                    builder: (context, model, child) => model.state == ViewState.Busy
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              billHeader(
                                  employees: model.employees,
                                  clients: model.clients,
                                  context: context),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    tableHead(),
                                    Expanded(child: tableBuilder()),
                                  ],
                                ),
                              ),
                              billFooter(context),
                            ],
                          ),
                  ),
                  collapsed: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
                    child: Center(
                      child: Text("الفاتوره", style: headerStyle),
                    ),
                  ),
                  body: model.state == ViewState.Busy
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                  delegate: SliverChildListDelegate(
                                [appBar()],
                              )),
                              SliverToBoxAdapter(
                                child: Container(
                                  height: 50.0,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: _buildCategoryList(
                                        category: model.categories, products: model.products),
                                  ),
                                ),
                              ),
                              SliverGrid(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20),
                                      child: item(
                                        onPressIcon: () {
                                          if (filteredProduct[index].selectionNo > 0) {
                                            setState(() {
                                              filteredProduct[index].selectionNo -= 1;
                                              selectedList.removeWhere(
                                                  (selectedList) => selectedList.selectionNo == 0);
                                            });
                                          }
                                          calculateTheTotalBillPerProduct();
                                          calculateTheTotalBill();
                                        },
                                        selectionNo: filteredProduct[index].selectionNo,
                                        statistics: filteredProduct[index].selectionNo > 0
                                            ? filteredProduct[index].selectionNo.toString()
                                            : "",
                                        topSpace: SizedBox(height: 50),
                                        betweenSpace: SizedBox(height: 20),
                                        title: filteredProduct[index].name,
                                        assetImage: "",
                                        backGround: Colors.black,
                                        onPress: () {
                                          setState(() {
                                            filteredProduct[index].selectionNo += 1;
                                          });
                                          if (!selectedList.contains(filteredProduct[index])) {
                                            selectedList.add(filteredProduct[index]);
                                          }
                                          calculateTheTotalBillPerProduct();
                                          calculateTheTotalBill();
                                        },
                                      ),
                                    );
                                  },
                                  childCount: filteredProduct.length,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ));
  }
}
