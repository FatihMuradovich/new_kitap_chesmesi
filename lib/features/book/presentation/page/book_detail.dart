import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/book/domain/model/book_model.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/page/auhtors_other_book.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/book_speciality.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/cover_item.dart';
import 'package:new_kitap_chesmesi/features/book/presentation/widget/detail_bottom_bar.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class BookDetail extends StatelessWidget {
  final BookModel book;
  const BookDetail({super.key,required this.book});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey[50],
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.asset('assets/images/1.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
              // IconButton(
              //       icon: Icon(
              //         widget.book.isFavorite
              //             ? Icons.favorite
              //             : Icons.favorite_border,
              //         color: widget.book.isFavorite ? Colors.red : null,
              //       ),
              //       onPressed: () {
              //         context
              //             .read<FavoritesCubit>()
              //             .toggleFavorite(widget.book);
              //       },
              //     )
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                  child: Text(
                    'Dorian Gray\'in Portresi',
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Poppins-black',
                      fontSize: 14.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    'Oscar Wilde',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: CoverItem(
                          title: 'Hard Cover',
                          color: CustomColors.blueColor,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: CoverItem(
                          title: 'Soft Cover',
                          color: Colors.grey,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    context.l10n.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins-regular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5.w),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: Colors.black54,
                      fontSize: 12.sp,
                    ),
                    '''Oscar Wilde'ın sadece birkaç gün içerisinde yazdığı Dorian Gray'in Portresi; hazcılık, psikoloji ve insan değerleri üzerine kendi içinde bir tartışmaya giriyor. Karakterler arasında kurguladığı diyaloglarla bunu başarıyla gerçekleştiren Wilde, kitabı kaleme aldıktan sonra karakterler hakkında bir açıklama yapıyor. "Basil Hallward, olduğum kişi; Lord Henry, insanların ben olduğumu sandığı kişi ve Dorian Gray ise aslında olmak istediğim kişi." Bu çerçevede kitabı okumaya başlarsanız Oscar Wilde ile ilgili de fikir sahibi olabilirsiniz. Okuyanların bir kere okumakla yetinmediği romanda her defasında farklı bir bakış açısına tanıklık ediliyor. Yazıldığı dönemde üzerine konuşulması bile yasak olan konular, Oscar Wilde'ın edebi dili ile gözler önüne seriliyor. Roman, Wilde'ın çok büyük bir üne sahip olmasını sağlarken bir taraftan tutuklanmasına varan olayların başlangıcı oluyor.
''',
                  ),
                ),

                // kitap ozellikleri
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: BookSpeciality(),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Awtoryň başga kitaplar',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.w),
                SizedBox(height: 215.w, child: AutgorsOtherBooks()),
                SizedBox(height: 15.w),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DetailBottomBar(book: book,),
    );
  }
}
