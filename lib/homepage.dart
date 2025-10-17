import 'package:flutter/material.dart';
import 'package:pixels_api/models/pixel_model.dart';
import 'package:pixels_api/provider/photo_provider.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PhotoProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.photos == null && !provider.isLoading) {
        provider.fetchPhotos('nature');
      }
    });

    void showPhotoDetails(BuildContext context, Photos photo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(photo.photographer ?? 'Unknown Photographer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(photo.src?.large ?? ''),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Text(photo.alt ?? 'No description available'),
          ],
        ),
      ),
    );
  }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pexels API',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Your Favourite Photo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        provider.fetchPhotos(value.trim());
                      }
                    },
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
               SizedBox(
 width: MediaQuery.of(context).size.width * 0.25,
  height: MediaQuery.of(context).size.height * 0.06,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
    ),
    onPressed: () {
      if (_searchController.text.trim().isNotEmpty) {
        provider.fetchPhotos(_searchController.text.trim());
      }
    },
    child: const Text(
      'Search',
      style: TextStyle(color: Colors.white),
    ),
  ),
)

              ],
            ),
          ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.photos == null ||
                        provider.photos!.photos == null ||
                        provider.photos!.photos!.isEmpty
                    ? const Center(child: Text('No photos found'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: provider.photos!.photos!.length,
                        itemBuilder: (context, index) {
                          final photo = provider.photos!.photos![index];
                          return GestureDetector(
                            onTap: () => showPhotoDetails(context, photo),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                photo.src?.medium ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  
}
