import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ECommerce extends StatefulWidget {
  @override
  _ECommerceState createState() => _ECommerceState();
}

class _ECommerceState extends State<ECommerce> {
  List allProducts = [
    {
      'name': 'Indoor Square Marble Taj Mahal Souvenir',
      'price': 21,
      'address': 'Pashan Kala',
      'near': 'Taj Mahal, Agra',
      'image':
          'https://5.imimg.com/data5/PW/NV/MY-28758/marble-taj-mahal-souvenir.jpg'
    },
    {
      'name': 'IEH Ceramic India Gate Gift',
      'price': 100,
      'address': 'Indian Export House',
      'near': 'India Gate, New Delhi',
      'image':
          'https://5.imimg.com/data5/DL/BA/MY-8113910/ceramic-india-gate-gift-500x500.png'
    },
    {
      'name': 'Red Fort Delhi Fridge Magnet',
      'price': 10,
      'address': 'Popli Brass Shop',
      'near': 'Red Fort, New Delhi',
      'image':
          'https://5.imimg.com/data5/HI/UJ/MW/SELLER-12118886/m-68a-500x500.jpeg'
    },
    {
      'name': 'Dancing Qutub Minar Dholak Delhi Fridge Magnet',
      'price': 60,
      'address': 'Chanderi Sarees - Artsy India',
      'near': 'Qutab Minar, New Delhi',
      'image':
          'https://3.imimg.com/data3/GL/JH/MY-16272986/image-cache-data-fridgemagnets-artsy006a-420x420-500x500.jpg'
    },
    {
      'name': 'Taj Mahal Souvenir Fridge Magnet',
      'price': 40,
      'address': 'Asia Enterprises',
      'near': 'Taj Mahal, Agra',
      'image': 'https://5.imimg.com/data5/LD/JO/RN/SELLER-91180/21-500x500.jpg'
    },
    {
      'name': 'SHIVIKA Gateway of India Fridge Magnet',
      'price': 35,
      'address': 'SHIVIKA',
      'near': 'Gateway Of India, Mumbai',
      'image':
          'https://images-na.ssl-images-amazon.com/images/I/51v-NufSeyL.jpg'
    },
    {
      'name': 'Envelop Monuments Fridge Magnet',
      'price': 65,
      'address': 'Chanderi Sarees - Artsy India',
      'near': 'Qutab Minar, New Delhi',
      'image':
          'https://3.imimg.com/data3/OI/PO/MY-16272986/image-cache-data-fridgemagnets-artsy011a-420x420-500x500.jpg'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
              child: ListView.builder(
                itemCount: allProducts
                    .length, // response from db <List of dicts>(json decoded)
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    child: Card(
                      shadowColor: Colors.black,
                      elevation: 15.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: 'No Information Provided',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1);
                        },
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              child: Image.network(
                                (allProducts[index])['image'],
                                width: 300,
                                height: 150,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            ListTile(
                              title: Text(
                                (allProducts[index])['name'],
                                style: TextStyle(
                                  fontFamily: 'LexendDeca',
                                  fontSize: 15.0,
                                ),
                              ),
                              subtitle: Text(
                                'By ${(allProducts[index])['address']}',
                                style: TextStyle(
                                  fontFamily: 'LexendDeca',
                                  fontSize: 13.0,
                                ),
                              ),
                              trailing: Text(
                                '₹ ${(allProducts[index])['price']}',
                                style: TextStyle(
                                  fontFamily: 'LexendDeca',
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Near ${(allProducts[index])['near']}',
                                style: TextStyle(
                                  fontFamily: 'LexendDeca',
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            MaterialButton(
                              splashColor: Colors.white,
                              height: 50.0,
                              minWidth: 500.0,
                              elevation: 5.0,
                              onPressed: () {
                                Fluttertoast.showToast(
                                    msg: 'No Information in Prototype Version',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1);
                              },
                              color: Theme.of(context).highlightColor,
                              child: Text(
                                "Buy",
                                style: TextStyle(
                                  fontFamily: 'LexendDeca',
                                  fontSize: 17.0,
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 20.0,
                color: Theme.of(context).focusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
