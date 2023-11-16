import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/common/widgets/embedded_view.dart';
import 'package:homly/features/property_visualizer/widgets/carousel_gallery.dart';

final showSideNavigationProvider = StateProvider<bool>((ref) {
  return true;
});

final selectedImageProvider = StateProvider<String?>((ref) {
  return ref.watch(galleryImagesProvider).firstOrNull;
});

final galleryImagesProvider = StateProvider<List<String>>((ref) {
  return [];
});

final selectedIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final widgetListProvider = StateProvider<List<Widget>>((ref) {
  return [
    const CarouselGallery(),
    const EmbeddedView(
      link: 'https://www.youtube.com/embed/8tF0q-LeeDA',
      radius: 0,
    ),
    const EmbeddedView(
      link: 'https://my.matterport.com/show/?m=pFwTx81YraT&sr=-.11,.92&ss=115',
      radius: 0,
    ),
    const Text('About Property'),
  ];
});

final selectedIndexScreenProvider = StateProvider<int>((ref) {
  return 0;
});

final selectedWidgetProvider = StateProvider<Widget>((ref) {
  return ref.watch(widgetListProvider)[ref.watch(selectedIndexScreenProvider)];
});
