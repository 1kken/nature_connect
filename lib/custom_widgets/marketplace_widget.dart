import 'package:flutter/material.dart';
import 'package:nature_connect/model/marketplace_item.dart';
import 'package:nature_connect/model/marketplace_media.dart';
import 'package:nature_connect/services/marketplace_media_service.dart';

class MarketplaceWidget extends StatefulWidget {
  final MarketplaceItem item;
  const MarketplaceWidget({required this.item, super.key});

  @override
  State<MarketplaceWidget> createState() => _MarketplaceWidgetState();
}

class _MarketplaceWidgetState extends State<MarketplaceWidget> {
  Future<Image> fetchImage() async {
    MarketplaceMedia? media = await MarketplaceMediaService()
        .getFirstMarketplaceMedia(widget.item.id);

    if (media == null) {
      throw 'No media found';
    }
    debugPrint('Media: ${media.storageUrl}');
    return Image.network(loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    }, fit: BoxFit.cover, width: 100, media.storageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
            future: fetchImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Icon(Icons.error);
              }
              return ClipRRect(
                borderRadius:
                    BorderRadius.circular(5), // Add rounded corners to image
                child: SizedBox(
                  height: 200, // Define a fixed height for the image
                  width: double
                      .infinity, // Let the image take the full available width
                  child: snapshot.data,
                ),
              );
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "₱${widget.item.price.toString()} - ${widget.item.title}",
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
