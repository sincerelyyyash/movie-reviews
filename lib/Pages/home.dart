import 'package:flutter/material.dart';
import 'package:moviereviews/Pages/infopage.dart';
import 'package:moviereviews/Pages/search.dart';

import 'models/api_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<dynamic> data;
  late List<dynamic> filteredData = [];

  @override
  void initState() {
    super.initState();
    APIController.getMovie().then((result) {
      setState(() {
        data = result;
        filteredData = data;
      });
    });
  }

  void search(String query) {
    setState(() {
      filteredData = data
          .where((item) =>
              item['show']['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _currentIndex = 0;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(data: data),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.redAccent),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            label: 'Search',
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,

        title: Image.asset(
          'assets/logo.png',
          height: 255,
          width: 255,
        ),
        // title: const Text(
        //   'Movie Collection',
        //   style: TextStyle(color: Colors.red, fontSize: 24),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: filteredData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return MovieCard(
              image: filteredData[index]['show']['image']['original'],
              desc: filteredData[index]['show']['summary'],
              link: filteredData[index]['show']['_links']['self']['href'],
              title: filteredData[index]['show']['name'],
            );
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  MovieCard({
    Key? key,
    required this.desc,
    required this.image,
    required this.link,
    required this.title,
  });

  final String? image, title, link, desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          if (link != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoviePage(link: link!),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    image!,
                    height: 150,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(width: 12.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      SizedBox(height: 8.0),
                      if (desc != null)
                        Text(
                          desc!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          if (link != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoviePage(link: link!),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Read More...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
