
import 'package:album_api/src/models/album_response_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlbumListWidget extends StatelessWidget {
  final List<AlbumResponseModel> albumList;
  AlbumListWidget(this.albumList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return buildEachItem(index);
      },
      itemCount: albumList.length,
    );
  }

  Container buildEachItem(int index) {
    return Container(
        height: 500,
        color: Colors.grey[200],
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        //decoration: BoxDecoration(border: Border.all()),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    albumList[index].thumbnail!,
                    height: 50,
                    width: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          albumList[index].title!,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(albumList[index].artist!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Image.network(
                  albumList[index].image!,
                  fit: BoxFit.fitHeight,
                )),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    launchURL(albumList[index].url!);
                  },
                  child: Text("Buy Album")),
            )
          ],
        ));
  }

  launchURL(String url) async {
    var connectivityResult = await(Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      if (await canLaunch(url)) {
        await launch(url);
      }
    }

    else{
      Fluttertoast.showToast(msg: "Check Your Internet",
        toastLength: Toast.LENGTH_LONG,
      );
    }
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text("Check Your Internet!"),
    //   duration: Duration(seconds: 3),));
  }
}

