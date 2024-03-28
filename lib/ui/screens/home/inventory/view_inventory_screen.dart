import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/routes/routes.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/app_icon_button.dart';
import '../../../widgets/global_text.dart';

class ViewInventoryScreen extends StatefulWidget {
  const ViewInventoryScreen({super.key});

  @override
  State<ViewInventoryScreen> createState() => _ViewInventoryScreenState();
}

class _ViewInventoryScreenState extends State<ViewInventoryScreen> {
  @override
  bool searchable = true;
  bool noSearch = true;

  List<Map<String, String>> products = [];
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> productList = [
    {
      'image': AppAssets.apple,
      'title': 'Apple',
      'brand': 'Ice Berry',
      'categoryImage': AppAssets.inventoryMid,
      'inventoryLevel': 'low',
      'category': 'Fresh Fruits',
      'storage': 'Fridge Rack',
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
    {
      'image': AppAssets.leaf,
      'title': 'Leaf',
      'brand': 'Alvera',
      'categoryImage': AppAssets.inventoryLow,
      'inventoryLevel': 'low',
      'category': 'Fresh Vegetables',
      'storage': 'Fridge Rack',
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
    {
      'image': AppAssets.orange,
      'title': 'Orange',
      'brand': 'Devil',
      'categoryImage': AppAssets.inventoryLow,
      'inventoryLevel': 'high',
      'category': 'Fresh Fruits',
      'storage': 'Fridge Rack',
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
    {
      'image': AppAssets.noImage,
      'title': 'Product Name',
      'brand': 'William',
      'categoryImage': AppAssets.inventoryMid,
      'inventoryLevel': 'high',
      'category': 'Fresh Fruits',
      'storage': 'Paper Rank',
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
    {
      'image': AppAssets.beetroot,
      'title': 'Beetroot',
      'brand': 'Bee',
      'categoryImage': AppAssets.inventoryMid,
      'inventoryLevel': 'low',
      'category': 'Fresh Vegetables',
      'storage': 'Paper Rack',
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
  ];
  Widget build(BuildContext context) {
    void _onSearchChanged(String query) {
      setState(() {
        products = productList
            .where((product) =>
                product['title']!.toLowerCase().contains(query.toLowerCase()) ||
                product['brand']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    return Scaffold(
      // appBar: !searchable ?AppBar(
      //   title:   AppTextField(
      //     controller:searchController,
      //     name: "Enter product name",
      //     hintText: "Search product ",
      //     // labelText: "  Product name",
      //
      //     labelStyle: textStyle16.copyWith(
      //         color: AppColors.blackColor, fontWeight: FontWeight.w400),
      //
      //     suffixIcon: Padding(
      //       padding:  EdgeInsets.all(15.sp),
      //       child: GestureDetector(
      //           onTap: (){
      //             _onSearchChanged(searchController.text);
      //
      //             setState(() {
      //               searchable=!searchable;
      //             });
      //           },
      //           child:  SvgIcon(searchController.text.isNotEmpty ? AppAssets.cancel : AppAssets.search,size: 10.sp,color: AppColors.blackGreyColor,)
      //       ),
      //     ),
      //     prefixIcon: Padding(
      //       padding:  EdgeInsets.all(15.sp),
      //       child: GestureDetector(
      //           onTap: (){
      //             _onSearchChanged(searchController.text);
      //
      //             setState(() {
      //               searchable=!searchable;
      //             });
      //           },
      //           child:  SvgIcon(searchController.text.isEmpty ? AppAssets.dropDown : AppAssets.search,size: 10.sp,color: AppColors.blackGreyColor,)
      //       ),
      //     ),
      //
      //   ),
      // ):AppBar(
      //
      //   backgroundColor: AppColors.whiteColor,
      //
      //   title:
      //        Text(
      //     "Inventory List",
      //     style: appBarTitleStyle.copyWith(
      //         fontWeight: FontWeight.w600, fontSize: 24.sp),),
      //
      //
      //
      //   actions: [
      //
      //
      //   IconButton(
      //         onPressed: () {
      //           setState(() {
      //             searchable = !searchable;
      //           });
      //           searchController.clear();
      //         },
      //         icon: SvgIcon(
      //           AppAssets.search,
      //           size: 20.sp,
      //           color: AppColors.blackGreyColor,
      //         )),
      //    AppIconButton(
      //         onTap: () {
      //           context.pushNamed(AppRoute.scancode.name);
      //         },
      //         child: SvgIcon(
      //           AppAssets.scanner,
      //           size: 20.sp,
      //           color: AppColors.blackGreyColor,
      //         )),
      //    AppIconButton(
      //         onTap: () {},
      //         child: SvgIcon(
      //           AppAssets.add,
      //           size: 20.sp,
      //           color: AppColors.primaryColor,
      //         )),
      //     5.w.horizontalSpace,
      //   ],
      // ),

      //   appBar: AppBar(
      //     backgroundColor: Colors.white,
      //     automaticallyImplyLeading: false,
      //     title: searchable
      //         ? GlobalText(
      //    'Inventory List',
      //       textStyle:textStyle14,
      //     )
      //         : Container(),
      //     actions: [
      //       searchable
      //           ? GestureDetector(
      //           onTap: () {
      //             print('Search clicked!');
      //             setState(() {
      //               searchable = !searchable;
      //             });
      //           },
      //           child:SvgIcon(AppAssets.search),
      //       )
      //           : Stack(
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.only(left: 20, right: 20),
      //             child: Container(
      //                 height: 48.h,
      //                 width: double.infinity,
      //                 child: TextField(
      //
      //                   controller: searchController,
      //                   onChanged: (value) {
      //                     print(value);
      //                     _onSearchChanged(searchController.text);
      //                   },
      //                   decoration: InputDecoration(
      //                     border: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(50),
      //                     ),
      //                     contentPadding: EdgeInsets.only(left: 70),
      //                     focusedBorder: OutlineInputBorder(
      //                       borderSide:
      //                       BorderSide(color: AppColors.greyColor),
      //                       borderRadius: BorderRadius.circular(50.0),
      //                     ),
      //                   ),
      //                 )
      //             ),
      //           ),
      //           Positioned(
      //               top: 12,
      //               left: 40,
      //               child: Container(
      //                 child: SvgIcon(AppAssets.search)
      //               )),
      //           Positioned(
      //               top: 15,
      //               right: 40,
      //               child: GestureDetector(
      //                   onTap: () {
      //                     print('Search clicked!');
      //                     setState(() {
      //                       searchable = !searchable;
      //                     });
      //                   },
      //                   child: Container(
      //                     child: SvgIcon(AppAssets.cancel)
      //                   ))),
      //         ],
      //       ),
      //       searchable
      //           ?   AppIconButton(
      // onTap: () {
      // context.pushNamed(AppRoute.scancode.name);
      // },
      // child: SvgIcon(
      // AppAssets.scanner,
      // size: 20.sp,
      // color: AppColors.blackGreyColor,
      // ))
      //           : Container(),
      //       searchable
      //           ?      AppIconButton(
      // onTap: () {},
      // child: SvgIcon(
      // AppAssets.add,
      // size: 20.sp,
      // color: AppColors.primaryColor,
      // ))
      //           : Container(),
      //     ],
      //   ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: searchable
            ? GlobalText(
                "Inventory List",
                textStyle: appBarTitleStyle.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 24.sp),
              )
            : Container(),
        actions: [
          searchable
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchable = !searchable;
                    });
                    searchController.clear();
                  },
                  icon: SvgIcon(
                    AppAssets.search,
                    size: 20.sp,
                    color: AppColors.blackGreyColor,
                  ))
              : Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                          // color: Colors.yellow,
                          height: 60.h,
                          width: double.infinity,
                          child: AppTextField(
                            prefixIcon: AppIconButton(
                              onTap: () {
                                setState(() {
                                  searchable = !searchable;
                                });
                              },
                              child: searchController.text.isEmpty
                                  ? Icon(Icons.arrow_back)
                                  : SvgIcon(
                                      AppAssets.search,
                                      size: 15,
                                    ),
                            ),
                            controller: searchController,
                            onChanged: (value) {
                              print(value);
                              _onSearchChanged(searchController.text);
                            },
                            name: 'Search',
                          )),
                    ),
                    // Positioned(
                    //     top: 15,
                    //     left: 40,
                    //     child: Container(
                    //       child:Icon(Icons.arrow_back)
                    //     )),
                    Positioned(
                        top: 15,
                        right: 40,
                        child: GestureDetector(
                            onTap: () {
                              print('Search clicked!');
                              setState(() {
                                searchable = !searchable;
                              });
                            },
                            child: SvgIcon(
                              AppAssets.cancel,
                              size: 18,
                            ))),
                  ],
                ),
          searchable
              ? Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: AppIconButton(
                      onTap: () {
                        context.pushNamed(AppRoute.scanAndAddScreen.name);
                      },
                      child: SvgIcon(
                        AppAssets.scanner,
                        size: 23,
                        color: AppColors.blackGreyColor,
                      )),
                )
              : Container(),
          searchable
              ? Padding(
                  padding: EdgeInsets.only(left: 5, right: 10),
                  child: AppIconButton(
                      onTap: () {},
                      child: SvgIcon(
                        AppAssets.add,
                        size: 20,
                        color: AppColors.orangeColor,
                      )),
                )
              : Container(),
        ],
      ),

      body: SingleChildScrollView(
        child: productList.length != 0
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      children: [
                        10.horizontalSpace,
                        Text(
                          '${productList.length} Products',
                          style: textStyle16.copyWith(fontSize: 18),
                        ),
                        Spacer(),

                        // SvgIcon(
                        // AppAssets.filterIcon,
                        // size: 25,
                        //   color: Colors.black,
                        //
                        //
                        // )
                        SvgPicture.asset(
                          AppAssets.selectedFilterIcon,
                          width: 22.h,
                          height: 22.h,
                        ),
                        8.w.horizontalSpace,
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, String> product = productList[index];

                          return GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => ProductDetailScreen(product: product),
                                //   ),
                                // );
                                // context.pushNamed(AppRoute.productDetail.name, extra: product);
                              },
                              child: Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  child: Icon(Icons.delete),
                                ),
                                key: Key(product.toString()),
                                onDismissed: (direction) {
                                  setState(() {
                                    productList.removeAt(index);
                                  });
                                },
                                child: buildProduct(product, () {
                                  context.pushNamed(AppRoute.productDetail.name,
                                      extra: product);
                                }),
                              ));
                        }),
                  ),
                ],
              )
            : SafeArea(
                child: Center(
                child: BounceInUp(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      150.h.verticalSpace,
                      Container(
                        height: 200.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppAssets.noSearch)),
                        ),
                      ),
                      35.h.verticalSpace,
                      GlobalText(
                        'No matching search results',
                        textStyle: textStyle16.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackGreyColor),
                      ),
                      5.h.verticalSpace,

                      130.h.verticalSpace,
                      // Padding(
                      //   padding:  EdgeInsets.all(20.sp),
                      //   child: AppButton(
                      //       onPressed: () {
                      //
                      //         context.pushReplacementNamed(AppRoute.viewInventory.name);              // context.pushReplacementNamed(AppRoute.viewInventory.name);
                      //       },
                      //       text: 'Add an Inventory '
                      //   ),),
                    ],
                  ),
                ),
              )),
      ),
    );
  }

  Widget buildProduct(Map<String, String> product, VoidCallback onTap) {
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
    //   child: Container(
    //     color: Colors.grey.withOpacity(0.1),
    //     width: double.infinity,
    //
    //     child: Column(
    //       children: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             8.horizontalSpace,
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Container(
    //
    //                 height: 120.h,
    //                 width: 100.h,
    //                 decoration: BoxDecoration(
    //
    //                   image: DecorationImage(
    //                     image: AssetImage(product['image'] ?? ''),
    //                     fit:  BoxFit.contain,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             8.horizontalSpace,
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 10.verticalSpace,
    //                 GlobalText( product['title'] ?? '',textStyle: textStyle16.copyWith(fontSize: 18),),
    //                 20.verticalSpace,
    //                 Container(
    //                   decoration: BoxDecoration(
    //                     color: AppColors.lightGreyColor.withOpacity(0.1),
    //                     borderRadius: BorderRadius.circular(20),
    //                   ),
    //                   child: Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                           horizontal: 15, vertical: 10),
    //                       child: GlobalText(
    //                           textStyle: textStyle14, product['brand'] ?? '')),
    //                 ),
    //               ],
    //             ),
    //             Spacer(),
    //            SvgIcon(
    //                 AppAssets.addCart,
    //                 size: 22,
    //                 color: AppColors.greenColor,
    //
    //             ),
    //             12.horizontalSpace,
    //
    //              SvgIcon(
    //                 product['categoryImage'] ?? '',
    //                 size: 13,
    //
    //             ),
    //             10.horizontalSpace,
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      onTap: onTap,
      title: Container(
        color: Colors.grey[800]!.withOpacity(0.05),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 100.h,
                      width: 100.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(product['image'] ?? ''),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 8), // Assuming 8.horizontalSpace is a SizedBox
                  Container(
                    width: 110.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          product['title'] ?? '',
                          style: textStyle16.copyWith(fontSize: 18),
                        ),
                        SizedBox(
                            height: 10
                                .h), // Assuming 20.verticalSpace is a SizedBox
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              product['brand'] ?? '',
                              style: textStyle14.copyWith(
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  50.w.horizontalSpace,
                  // Spacer(),
                  SvgIcon(
                    AppAssets.addCart,
                    size: 25.sp,
                    color: AppColors.greenColor,
                  ),
                  SizedBox(width: 25.sp),

                  SvgPicture.asset(
                    product['categoryImage'] ?? '',
                    width: 18.h,
                    height: 18.h,
                  ),

                  SizedBox(
                      width:
                          10.sp), // Assuming 10.horizontalSpace is a SizedBox
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchDeltegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
