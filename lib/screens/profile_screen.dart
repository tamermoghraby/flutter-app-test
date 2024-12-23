import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/fetchData.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future data;

  @override
  void initState() {
    super.initState();
    data = ApiService().fetchData(); // Fetch data from network
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data; // Access fetched data

              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _HeaderDelegate(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final item = items['data'][index];
                        if (item['type'] == 1) {
                          return ListTile(
                            leading: Image.network(item["image"],
                                width: 50, height: 50),
                            title: Text(item["title"]),
                            subtitle: Text(
                              item["desc"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        } else if (item["type"] == 2) {
                          return SizedBox(
                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: item["images"].length,
                              itemBuilder: (context, idx) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    item["images"][idx],
                                    width: 90,
                                    height: 50,
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          throw Exception(
                              "Unknown item type"); // Handle unknown type
                        }
                      },
                      childCount: items['data'].length,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("Error: ${snapshot.error}")); // Handle error
            }
            return const Center(
                child: CircularProgressIndicator()); // Loading indicator
          },
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double maxHeight = 300;
    final double minHeight = 200;
    final double currentHeight = maxHeight - shrinkOffset;
    final double effectiveHeight = currentHeight.clamp(minHeight, maxHeight);

    final double imageSize = (effectiveHeight / maxHeight) * 120;
    final double nameFontSize = (effectiveHeight / maxHeight) * 28;
    final double roleFontSize = (effectiveHeight / maxHeight) * 18;

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: imageSize / 2,
              backgroundImage: const NetworkImage(
                  "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg"),
            ),
            const SizedBox(height: 8),
            Text(
              "John Doe",
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Developer",
              style: TextStyle(
                fontSize: roleFontSize,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 300;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
