import 'dart:io';import 'package:flutter/material.dart';import 'package:gym_bar_sales/core/models/category.dart';import 'package:gym_bar_sales/core/services/bill_services.dart';import 'package:gym_bar_sales/core/services/home_services.dart';import 'package:gym_bar_sales/core/view_models/category_model.dart';import 'package:gym_bar_sales/core/view_models/product_model.dart';import 'package:gym_bar_sales/core/view_models/total_model.dart';import 'package:gym_bar_sales/ui/shared/dimensions.dart';import 'package:gym_bar_sales/ui/shared/text_styles.dart';import 'package:gym_bar_sales/ui/widgets/form_widgets.dart';import 'package:provider/provider.dart';class HomeAppBar extends StatelessWidget {  final File file = null;  final List<String> choices = <String>[    "العملاء",    "البلاغات",    "الاعدادات",    "تسجيل الخروج",  ];  @override  Widget build(BuildContext context) {    TextStyles _textStyles = TextStyles(context: context);    FormWidget _formWidget = FormWidget(context: context);    Dimensions _dimensions = Dimensions(context);    CategoryModel categoryModel = Provider.of<CategoryModel>(context);    ProductModel productModel = Provider.of<ProductModel>(context);    String branchName = context.read<String>();    HomeServices homeServices = Provider.of<HomeServices>(context);    BillServices billServices = Provider.of<BillServices>(context);    String selectedCategory = categoryModel.selectedCategory;    List<Category> categories = categoryModel.categories;    String transactionType = homeServices.transactionType;    bool switcherOpen = homeServices.switcherOpen;    Widget addPhoto() {      if (file == null) {        return _formWidget.logo(            imageContent: Image.asset("assets/images/myprofile.jpg", fit: BoxFit.cover), backgroundColor: Colors.white);      } else        return _formWidget.logo(imageContent: Image.file(file, fit: BoxFit.cover));    }    _buildCategoryList() {      List<Widget> choices = [];      choices.add(Container(          padding: EdgeInsets.only(left: _dimensions.heightPercent(2)),          child: ChoiceChip(            labelStyle: _textStyles.chipLabelStyleLight(),            selectedColor: Colors.green,            backgroundColor: Colors.white,            shape: StadiumBorder(              side: BorderSide(color: Colors.green),            ),            label: Text("الكل"),            selected: selectedCategory == "All",            onSelected: (selected) {              categoryModel.selectedCategory = "All";            },          )));      for (int i = 0; i < categories.length; i++) {        choices.add(Container(          padding: EdgeInsets.only(left: _dimensions.heightPercent(2)),          child: ChoiceChip(            labelStyle: _textStyles.chipLabelStyleLight(),            selectedColor: Colors.orange,            backgroundColor: Colors.white,            shape: StadiumBorder(side: BorderSide(color: Colors.orange)),            label: Text(categories[i].name),            selected: selectedCategory == categories[i].name,            onSelected: (selected) {              categoryModel.selectedCategory = categories[i].name;              // filteredProducts = products              //     .where((product) => product.category == selectedCategory)              //     .toList();            },          ),        ));      }      return choices;    }    onSelected(choice) {      if (choice == "العملاء") {        Navigator.pushNamed(context, '/clients');      }      if (choice == "البلاغات") {        Navigator.pushNamed(context, '/report');      }      if (choice == "تسجيل الخروج") {        // Navigator.pushNamed(context, '/logout');      }      if (choice == "الاعدادات") {        // Navigator.pushNamed(context, '/settings');      }    }    Widget more() {      return PopupMenuButton(        itemBuilder: (BuildContext context) {          return choices.map((String choice) {            return PopupMenuItem<String>(              value: choice,              child: Container(                height: _dimensions.heightPercent(6),                child: Text(                  choice,                  style: _textStyles.popupMenuButtonStyle(),                ),              ),            );          }).toList();        },        onSelected: (choice) {          onSelected(choice);        },        child: Icon(Icons.more_vert_rounded, size: _dimensions.widthPercent(4)),      );    }    Widget appBar() {      return Column(        children: [          SizedBox(height: _dimensions.heightPercent(2)),          Row(            children: <Widget>[              SizedBox(width: _dimensions.widthPercent(1)),              Container(height: _dimensions.heightPercent(15), width: _dimensions.widthPercent(15), child: addPhoto()),              SizedBox(width: _dimensions.widthPercent(1)),              Text(                "عمر خالد",                style: _textStyles.profileNameTitleStyle(),              ),              Expanded(child: SizedBox()),              StreamProvider<String>(                create: (_) => TotalModel().fetchTotalCashStream(branchName),                initialData: "loading...",                catchError: (_, Object err) {                  if (err.toString().contains("Tried calling: [](\"cash\")")) {                    return "لا يوجد";                  } else                    return "حدث خطأ";                },                child: Consumer<String>(                  builder: (BuildContext context, total, Widget child) {                    return Text(                      total == null ? "" : total,                      style: _textStyles.profileNameTitleStyle(),                    );                  },                ),              ),              SizedBox(width: _dimensions.widthPercent(2)),              Text(                ':الخزنه',                style: _textStyles.profileNameTitleStyle(),              ),              SizedBox(width: _dimensions.widthPercent(2)),              more(),              SizedBox(width: _dimensions.widthPercent(2)),            ],          ),          SizedBox(height: _dimensions.heightPercent(1)),        ],      );    }    Widget transactionTypeSwitcher() {      return Row(        children: [          SizedBox(width: _dimensions.widthPercent(1)),          Container(            width: _dimensions.widthPercent(6),            padding: EdgeInsets.only(left: _dimensions.heightPercent(2)),            child: Transform.scale(              scale: 1.5,              child: Switch(                value: switcherOpen,                onChanged: (_) {                  homeServices.changeSwitchSide();                  productModel.cleanProductSelection();                  billServices.totalBill = 0;                },              ),            ),          ),          SizedBox(width: _dimensions.widthPercent(1)),          Text(            transactionType,            style: _textStyles.appBarTextStyle(),          ),        ],      );    }    Widget categoryList() {      return Container(        height: _dimensions.heightPercent(7),        child: Row(          children: [            Expanded(              child: ListView(                scrollDirection: Axis.horizontal,                children: _buildCategoryList(),              ),            ),          ],        ),      );    }    return Column(      children: [        appBar(),        transactionTypeSwitcher(),        categoryList(),      ],    );  }}