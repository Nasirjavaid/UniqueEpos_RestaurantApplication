import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DashboardOffersImageContainer extends StatelessWidget {
  final double height, width, borderWidth;
  final String imageLink;
  DashboardOffersImageContainer(
      {this.height, this.width, this.borderWidth, this.imageLink});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, top: 3, right: 3),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
          child: CachedNetworkImage(
            imageUrl: imageLink,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                    topLeft: Radius.circular(5)),
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black12, BlendMode.colorBurn)),
              ),
            ),
            placeholder: (context, url) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
            errorWidget: (context, url, error) =>
                Center(child: Icon(Icons.error)),
          ),
        ),
      ),
    );
  }
}
