import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/model/foodCategory.dart';

// ignore: must_be_immutable
class ImageSlider extends StatefulWidget {
  List<Sliderinfo> sliderinfo = List<Sliderinfo>();

  ImageSlider(this.sliderinfo);
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  // List<String> items = [
  //   "https://www.pymnts.com/wp-content/uploads/2019/09/DoorDash-Chowly-Panera-Postmates-restaurants-delivery.jpg",
  //   "https://blog.doemal.com/en/wp-content/uploads/sites/2/2019/03/Features-1.jpg",
  //   "https://www.jetsetter.com/uploads/sites/7/2018/07/2zFs3Mzm-1380x690.jpeg",
  //   "https://www.sitchu.com.au/media/images/bistro-moncur-french-restaurant-sydney_2.original.jpg"
  // ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              //enlargeCenterPage: true,
              height:   MediaQuery.of(context).size.height *0.25,
              pauseAutoPlayOnTouch: Duration(seconds: 3),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                  print("$_current");
                });
              },
              items: widget.sliderinfo.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                        child: CachedNetworkImage(
                          imageUrl:  i.sliderimage==
                           APIConstants.baseUrl
                    ? "https://ozersky.tv/wp-content/uploads/2018/02/hamburger-7.jpg"
                    : i.sliderimage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              //           border: Border.all(
                              //   color: Colors.blue,
                              //   width: 0.5,
                              // ),
                              shape: BoxShape.rectangle,

                              //  borderRadius: BorderRadius.circular(500),
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black12, BlendMode.colorBurn)),
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
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            size: 30,
                            color: Colors.red[200],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.sliderinfo.map((url) {
                  int index = widget.sliderinfo.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 18.0, horizontal: 3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 0.5,
                      ),
                      shape: BoxShape.circle,
                      color: _current == index ? Colors.white : Colors.white38,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
