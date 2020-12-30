import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class FoodProduct extends Equatable {
  String status;
  int statusCode;
  String message;
  Data data;

  FoodProduct({this.status, this.statusCode, this.message, this.data});

  FoodProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  @override
  List<Object> get props => ["object checking  : "];
}

class Data {
  String currency;
  String currencyIcon;
  String restaurantvat;
  List<Foodinfo> foodinfo;
  List<Shippinginfo> shippinginfo;

  Data({this.currency, this.currencyIcon, this.restaurantvat, this.foodinfo});

  Data.fromJson(Map<String, dynamic> json) {
    currency = json['Currency'];
    currencyIcon = json['CurrencyIcon'];
    restaurantvat = json['Restaurantvat'];
    if (json['foodinfo'] != null) {
      foodinfo = new List<Foodinfo>();
      json['foodinfo'].forEach((v) {
        foodinfo.add(new Foodinfo.fromJson(v));
      });
    }

    if (json['shippinginfo'] != null) {
      shippinginfo = new List<Shippinginfo>();
      json['shippinginfo'].forEach((v) {
        shippinginfo.add(new Shippinginfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Currency'] = this.currency;
    data['CurrencyIcon'] = this.currencyIcon;
    data['Restaurantvat'] = this.restaurantvat;
    if (this.foodinfo != null) {
      data['foodinfo'] = this.foodinfo.map((v) => v.toJson()).toList();
    }

    if (this.shippinginfo != null) {
      data['shippinginfo'] = this.shippinginfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shippinginfo {
  String shippingName;
  String shippingrate;

  Shippinginfo({this.shippingName, this.shippingrate});

  Shippinginfo.fromJson(Map<String, dynamic> json) {
    shippingName = json['ShippingName'];
    shippingrate = json['Shippingrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShippingName'] = this.shippingName;
    data['Shippingrate'] = this.shippingrate;
    return data;
  }
}

class Foodinfo {
  int count;
  int total;
  int shippingInfoListIndexFormFoodInfo;
  String shippingInfoType;
  double foodItemTtotalPrice;
  String productsID;
  String productName;
  String productImage;
  String component;
  String destcription;
  String itemnotes;
  String description;
  String productvat;
  String offersRate;
  String offerIsavailable;
  String offerstartdate;
  String offerendate;
  String variantid;
  String variantName;
  String price;
  int addons;
  bool addToCartStatus = false;
  double foodPerItemTtotalPrice;
  double addOnsListTotalPrice;
  List<Addonsinfo> addonsinfo;
  CartTotalBill cartTotalBill;
  double foodItemDiscountedPrice;
  List<ProductOptions> productOptions;
  String selectedOptionValues;

  Foodinfo(
      {this.count,
      this.total,
      this.shippingInfoListIndexFormFoodInfo,
      this.productsID,
      this.productName,
      this.productImage,
      this.component,
      this.destcription,
      this.itemnotes,
      this.description,
      this.productvat,
      this.offersRate,
      this.offerIsavailable,
      this.offerstartdate,
      this.offerendate,
      this.variantid,
      this.variantName,
      this.price,
      this.addons,
      this.addonsinfo,
      this.foodPerItemTtotalPrice,
      this.addOnsListTotalPrice,
      this.cartTotalBill,
      this.addToCartStatus = false,
      this.foodItemDiscountedPrice,
      this.foodItemTtotalPrice,this.productOptions,this.selectedOptionValues});

  Foodinfo.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    total = json['total'];
    shippingInfoListIndexFormFoodInfo =
        json['shippingInfoListIndexFormFoodInfo'];
    foodItemTtotalPrice = json['foodItemTtotalPrice'];
    shippingInfoType = json['shippingInfoType'];
    productsID = json['ProductsID'];
    productName = json['ProductName'];
    productImage = json['ProductImage'];
    component = json['component'];
    destcription = json['destcription'];
    itemnotes = json['itemnotes'];
    description = json['Description'];
    productvat = json['productvat'];
    offersRate = json['OffersRate'];
    offerIsavailable = json['offerIsavailable'];
    offerstartdate = json['offerstartdate'];
    offerendate = json['offerendate'];
    variantid = json['variantid'];
    variantName = json['variantName'];
    price = json['price'];
    addons = json['addons'];
    addToCartStatus = json['addToCartStatus'];
    foodPerItemTtotalPrice = json["foodPerItemTtotalPrice"];
    foodItemDiscountedPrice = json["foodItemDiscountedPrice"];
    addOnsListTotalPrice = json["addOnsListTotalPrice"];
    selectedOptionValues = json["selectedOptionValues"];
    if (json['addonsinfo'] != null) {
      addonsinfo = new List<Addonsinfo>();
      json['addonsinfo'].forEach((v) {
        addonsinfo.add(new Addonsinfo.fromJson(v));
      });
    }
    if (json['cartTotalBill'] != null) {
      cartTotalBill = new CartTotalBill();
      json['cartTotalBill'] = cartTotalBill;
    }

    if (json['product_options'] != null) {
			productOptions = new List<ProductOptions>();
			json['product_options'].forEach((v) { productOptions.add(new ProductOptions.fromJson(v)); });
		}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['total'] = this.total;
    data['shippingInfoListIndexFormFoodInfo'] =
        this.shippingInfoListIndexFormFoodInfo;
    data['foodItemTtotalPrice'] = this.foodItemTtotalPrice;
    data['shippingInfoType'] = this.shippingInfoType;
    data['foodItemDiscountedPrice'] = this.foodItemDiscountedPrice;
    data['ProductsID'] = this.productsID;
    data['ProductName'] = this.productName;
    data['ProductImage'] = this.productImage;
    data['component'] = this.component;
    data['destcription'] = this.destcription;
    data['itemnotes'] = this.itemnotes;
    data['Description'] = this.description;
    data['productvat'] = this.productvat;
    data['OffersRate'] = this.offersRate;
    data['offerIsavailable'] = this.offerIsavailable;
    data['offerstartdate'] = this.offerstartdate;
    data['offerendate'] = this.offerendate;
    data['variantid'] = this.variantid;
    data['variantName'] = this.variantName;
    data['price'] = this.price;
    data['addons'] = this.addons;
    data['addToCartStatus'] = this.addToCartStatus;
    data['foodPerItemTtotalPrice'] = this.foodPerItemTtotalPrice;
    data['addOnsListTotalPrice'] = this.addOnsListTotalPrice;
    data['addons'] = this.addons;
    data['selectedOptionValues'] = this.selectedOptionValues;
    if (this.addonsinfo != null) {
      data['addonsinfo'] = this.addonsinfo.map((v) => v.toJson()).toList();
    }
    if (this.cartTotalBill != null) {
      data['cartTotalBill'] = this.cartTotalBill.toJson();
    }

    if (this.productOptions != null) {
      data['product_options'] = this.productOptions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addonsinfo {
  String addonsid;
  String addOnName;
  String addonsprice;
  int addOnsCount;
  double addonsPerItemTotalPrice;
  bool addedStatus;
  Addonsinfo({
    this.addonsPerItemTotalPrice,
    this.addonsid,
    this.addOnName,
    this.addonsprice,
    this.addOnsCount,
    this.addedStatus,
  });
  Addonsinfo.fromJson(Map<String, dynamic> json) {
    addonsid = json['addonsid'];
    addOnName = json['add_on_name'];
    addonsprice = json['addonsprice'];
    addOnsCount = json['addOnsCount'];
    addonsPerItemTotalPrice = json['addonsPerItemTotalPrice'];
    addedStatus = json['addedStatus'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addonsid'] = this.addonsid;
    data['add_on_name'] = this.addOnName;
    data['addonsprice'] = this.addonsprice;
    data['addOnsCount'] = this.addOnsCount;
    data['addonsPerItemTotalPrice'] = this.addonsPerItemTotalPrice;
    data['addedStatus'] = this.addedStatus;
    return data;
  }
}

class CartTotalBill {
  double subTotal;
  double deliveryFee;
  double totalBill;
  double disccount;

  String currency;
  String currencyIcon;
  String restaurantvat;
  double vatAmount;
  int shippingInfoListIndexFormCartTotalBill;
  //double grandTotalAfterDiscount;

  List<Shippinginfo> shippinginfo;

  CartTotalBill({
    this.subTotal,
    this.deliveryFee,
    this.totalBill,
    this.disccount,
    this.currency,
    this.currencyIcon,
    this.restaurantvat,
    this.vatAmount,
    this.shippinginfo,
    this.shippingInfoListIndexFormCartTotalBill
  });
  CartTotalBill.fromJson(Map<String, dynamic> json) {
    subTotal = json['subTotal'];
    deliveryFee = json['deliveryFee'];
    totalBill = json['totalBill'];
    disccount = json['disccount'];
    currency = json['Currency'];
    currencyIcon = json['CurrencyIcon'];
    restaurantvat = json['Restaurantvat'];
    vatAmount = json['vatAmount'];
    shippingInfoListIndexFormCartTotalBill = json['shippingInfoListIndexFormCartTotalBill'];
    //  grandTotalAfterDiscount = json['grandTotalAfterDiscount'];

    if (json['shippinginfo'] != null) {
      shippinginfo = new List<Shippinginfo>();
      json['shippinginfo'].forEach((v) {
        shippinginfo.add(new Shippinginfo.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subTotal'] = this.subTotal;
    data['deliveryFee'] = this.deliveryFee;
    data['totalBill'] = this.totalBill;
    data['disccount'] = this.disccount;

    data['Currency'] = this.currency;
    data['CurrencyIcon'] = this.currencyIcon;
    data['Restaurantvat'] = this.restaurantvat;
    data['vatAmount'] = this.vatAmount;
    data['shippingInfoListIndexFormCartTotalBill'] = this.shippingInfoListIndexFormCartTotalBill;
    // data['grandTotalAfterDiscount'] = this.grandTotalAfterDiscount;

    if (this.shippinginfo != null) {
      data['shippinginfo'] = this.shippinginfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ProductOptions {
	String itemOptionId;
	String itemId;
	String title;
	String maximumSelection;
	String optionValues;

	ProductOptions({this.itemOptionId, this.itemId, this.title, this.maximumSelection, this.optionValues});

	ProductOptions.fromJson(Map<String, dynamic> json) {
		itemOptionId = json['item_option_id'];
		itemId = json['item_id'];
		title = json['title'];
		maximumSelection = json['maximum_selection'];
		optionValues = json['option_values'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['item_option_id'] = this.itemOptionId;
		data['item_id'] = this.itemId;
		data['title'] = this.title;
		data['maximum_selection'] = this.maximumSelection;
		data['option_values'] = this.optionValues;
		return data;
	}
}
