import 'package:flutter/material.dart';
import 'package:flutter_mastering_reset_api/pages/album.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Album> getAlbum() async {
    await Future.delayed(const Duration(milliseconds: 3));
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      return Album.fromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  late Future<Album> futureAlbum;
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureAlbum = getAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        FutureBuilder<Album>(
          future: futureAlbum,
          // builder = action builder
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return Center(child: Text(snapshot.data!.title));
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data!.id == 0
                      ? 'Delete Data'
                      : snapshot.data!.title),
                  ElevatedButton(
                    child: const Text('Delete Data'),
                    onPressed: () {
                      setState(() {
                        futureAlbum = deleteAlbum(snapshot.data!.id.toString());
                      });
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return const CircularProgressIndicator();
          },
        ),

        // colom 1 create data
        const Divider(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Enter Title'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  futureAlbum = createAlbum(titleController.text);
                  titleController.clear();
                });
              },
              child: const Text('Create Data'),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),

            // colom 2 update data
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: 'Enter Title'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureAlbum = updateAlbum(titleController.text);
                      titleController.clear();
                    });
                  },
                  child: const Text('Update Data'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
          ],
        )
      ]),
    );
  }
}
