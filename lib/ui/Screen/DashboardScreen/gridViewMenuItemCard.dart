import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GridViewMenuItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8)),
        ),
        child: Column(
          children: [
            menuItemImageView(context),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 6, right: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemNameTextField(context),
                  ratingBarandReview(context),
                  priceTextField(context),
                  cartAndFavouriteIcons(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemNameTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        "Tandoori Pizza",
        textAlign: TextAlign.left,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget menuItemImageView(BuildContext context) {
    return Container(
      width: 170,
      height: 125,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
        child: CachedNetworkImage(
          imageUrl:
              "https://www.dailybreeze.com/wp-content/uploads/2019/04/LDN-L-DINE-PIZZA-0412-1-1.jpg?w=525",
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(1),
                  bottomRight: Radius.circular(1),
                  topLeft: Radius.circular(8)),
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black12, BlendMode.colorBurn)),
            ),
          ),
          placeholder: (context, url) => Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )),
            ],
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget ratingBarandReview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Container(
        child: Row(
          children: [
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 12,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.star,
                    size: 12,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.star,
                    size: 12,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                ],
              ),
              // child: RatingBar(
              //   initialRating: 3,
              //   minRating: 1,
              //   direction: Axis.horizontal,
              //   allowHalfRating: true,
              //   itemCount: 5,
              //   itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
              //   itemBuilder: (context, _) {
              //     return Icon(
              //       Icons.star,
              //       size: 6,
              //       color: Colors.amber,
              //     );
              //   },
              //   onRatingUpdate: (rating) {
              //     print(rating);
              //   },
              // ),
            ),
            Text(
              "(3 reviews)",
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }

  Widget priceTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Text(
            "Price: ",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(" \$34.00",style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black87),),
        ],
      ),
    );
  }

  Widget cartAndFavouriteIcons(BuildContext context) {
    return Container(
      height: 20,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 18,
              ),
              onPressed: null),
          IconButton(
              icon: Icon(
                FontAwesomeIcons.cartPlus,
                size: 18,
              ),
              onPressed: null)
        ],
      ),
    );
  }
}
