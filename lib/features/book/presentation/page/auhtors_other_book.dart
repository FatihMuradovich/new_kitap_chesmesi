import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AutgorsOtherBooks extends StatelessWidget {
  const AutgorsOtherBooks({
    super.key,
  
  });

  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(right: 12),
      shrinkWrap: true,
      itemExtent: 145.w,
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        // return BookItem(margin: true, );
        return Text('data');
      },
    );
  }
}