import 'package:flutter/material.dart';
import 'package:json_place_holder/models/album.dart';
import 'package:json_place_holder/models/photo.dart';
import 'package:json_place_holder/services/user_api.dart';

class AlbumItem extends StatelessWidget {
  final Album album;

  const AlbumItem({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FutureBuilder<List<Photo>>(
              future: UserApi.fetchPhotos(albumId: album.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Icon(Icons.error));
                }
                
                final photos = snapshot.data ?? [];
                final firstPhoto = photos.isNotEmpty ? photos.first : null;
                
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (firstPhoto != null)
                      Image.network(
                        firstPhoto.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.broken_image, size: 50),
                      )
                    else
                      const Center(child: Icon(Icons.photo_album, size: 50)),
                    
                    if (photos.length > 1)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+${photos.length - 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              album.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
