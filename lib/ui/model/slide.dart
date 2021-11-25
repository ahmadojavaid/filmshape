import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: AssetStrings.imageFirst,
    title: 'Create a project',
    description:
        'Create film and TV projects where you can find other filmmakers to collaborate with. Add project details, team members and roles you require to be part of your film.',
  ),
  Slide(
    imageUrl: AssetStrings.imageSecons,
    title: 'Join a project',
    description:
        'Find like-minded individuals who have already formed a team to collaborate with.',
  ),
  Slide(
    imageUrl: AssetStrings.imageThird,
    title: 'Search for talent',
    description:
        'If you\'ve already created a project, you can find the right people to help bring those ideas to life.',
  ),
];
